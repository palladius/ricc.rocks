# 💡 Pro-Tip for Riccardo: Why Fourier Epicycle Videos Look Pixelated on YouTube (and How to Fix It)

When uploading a 1080p vector/epicycle render to YouTube, the video often looks **pixelated and blocky** (*sgranatissimo*). Here is why and how to fix it:

1. **YouTube's 1080p Bitrate Starvation on Thin Vector Lines**:
   Glowing `1.7px` cyan and white vector circles moving at 60fps across a deep `#07080c` black background have extreme high-frequency spatial gradients. YouTube's standard `1080p60` transcode crushes video down to ~2.5–3.5 Mbps using 4:2:0 chroma subsampling, creating mosquito noise and macroblocking around thin moving lines.

2. **Fix #1 — Native HTML5 `<video>` Hosting on `ricc.rocks` (`-tune animation`)**:
   Because `ricc.rocks` serves static assets directly over Netlify CDN without re-transcoding, embedding a `<video>` MP4 encoded with:
   ```bash
   ffmpeg -i input.mp4 -c:v libx264 -crf 19 -preset slow -tune animation -pix_fmt yuv420p -movflags +faststart -c:a aac -b:a 192k output.mp4
   ```
   preserves **100% razor-sharp 1080p60 vector edges AND the 192 kbps stereo soundtrack** in ~`16.8 MB` (whereas an equivalent 1080p60 `.gif` has **no audio**, only 256 colors, and weighs over `80 MB`!).

3. **Fix #2 — Upscale to 4K (`3840×2160`) Before Uploading to YouTube**:
   If you upload to YouTube, upscale the 1080p master to `3840×2160` first:
   ```bash
   ffmpeg -i italian_puffin_fourier_epicycles.mp4 -vf "scale=3840:2160:flags=lanczos" -c:v libx264 -crf 17 -preset slow -tune animation -c:a copy youtube_4k60_master.mp4
   ```
   Uploading a 4K60 file forces YouTube to allocate its **`2160p60` VP9 / AV1 profile (~25–35 Mbps)**—nearly **10× the bitrate** of 1080p!

4. **Fix #3 — Run the Math Live in an HTML5 `<canvas>`**:
   Ship the 2,049 complex numbers (`fourier_2049_coeffs.json`, just `48 KB`) and let the browser's GPU render the epicycles at native Retina/4K resolution (`/demos/fourier-italian-puffin/`).
