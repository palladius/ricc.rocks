// First-party Netlify Serverless Function proxy for Busuanzi counters.
// Bypasses Chrome ORB (Opaque Response Blocking on cross-origin JSONP with Content-Type: application/json)
// and ad-blockers (uBlock Origin / Brave Shields) by serving counters from first-party /.netlify/functions/busuanzi.

export default async (req, context) => {
  try {
    const reqUrl = new URL(req.url);
    const rawPageUrl = reqUrl.searchParams.get("url") || "https://ricc.rocks/en/";
    let parsed;
    try {
      parsed = new URL(rawPageUrl);
    } catch {
      parsed = new URL("https://ricc.rocks/en/");
    }

    // Always normalize host to canonical production domain so deploy previews & aliases share counters
    const canonicalReferer = `https://ricc.rocks${parsed.pathname}`;
    const cookies = req.headers.get("cookie") || "";
    const bszMatch = cookies.match(/busuanziId=([A-Za-z0-9]+)/);
    const upstreamHeaders = {
      "Referer": canonicalReferer,
      "User-Agent": req.headers.get("user-agent") || "Mozilla/5.0 (X11; Linux x86_64) Chrome/130.0.0.0",
    };
    if (bszMatch) {
      upstreamHeaders["Cookie"] = `busuanziId=${bszMatch[1]}`;
    }

    const controller = new AbortController();
    const timer = setTimeout(() => controller.abort(), 4500);

    const upstreamResp = await fetch(
      "https://busuanzi.ibruce.info/busuanzi?jsonpCallback=BusuanziCallback_1",
      {
        method: "GET",
        headers: upstreamHeaders,
        signal: controller.signal,
      }
    );
    clearTimeout(timer);

    const text = await upstreamResp.text();
    const jsonMatch = text.match(/BusuanziCallback_1\((\{.*?\})\)/);
    if (!jsonMatch) {
      throw new Error("Invalid upstream payload");
    }

    const data = JSON.parse(jsonMatch[1]);
    const respHeaders = {
      "Content-Type": "application/json; charset=utf-8",
      "Cache-Control": "no-store, max-age=0",
    };

    const setCookie = upstreamResp.headers.get("set-cookie");
    if (setCookie) {
      const idMatch = setCookie.match(/busuanziId=([A-Za-z0-9]+)/);
      if (idMatch) {
        respHeaders["Set-Cookie"] = `busuanziId=${idMatch[1]}; Path=/; Max-Age=31536000; SameSite=Lax; Secure`;
      }
    }

    return new Response(
      JSON.stringify({
        site_uv: Number(data.site_uv || 0),
        site_pv: Number(data.site_pv || 0),
        page_pv: Number(data.page_pv || 0),
      }),
      { status: 200, headers: respHeaders }
    );
  } catch (err) {
    return new Response(
      JSON.stringify({ site_uv: 35, site_pv: 36, page_pv: 1, fallback: true }),
      {
        status: 200,
        headers: {
          "Content-Type": "application/json; charset=utf-8",
          "Cache-Control": "no-store, max-age=0",
        },
      }
    );
  }
};
