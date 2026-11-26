---
title: "Apertus on Cloud Run: The Sprungli of LLMs"
date: 2026-11-20T19:30:00+01:00
description: "Deploying Swiss AI's open-weight Apertus (v1.0 and multimodal v1.5) on Google Cloud Run across Zurich CPU and EU L4 GPUs, cutting image-pull cold starts and translating a synthetic Swiss tax letter."
summary: "How I deployed Swiss AI's open-weight Apertus models (v1.0 and multimodal v1.5) on Google Cloud Run across a Zurich CPU-only instance and EU L4 GPUs, fixed cold-start timeouts with Artifact Registry and GCS FUSE, and translated a synthetic Swiss tax letter into Zuerituutsch and Rumantsch."
draft: false
enableToc: true
tocLevels: ["h2", "h3"]
image: "/en/posts/technology/2026-11-20-apertus-on-cloud-run-the-sprungli-of-llms/images/hero_toblerone_apertus.png"
categories:
  - AI
  - Technology
tags:
  - AI
  - CloudRun
  - GPU
  - Apertus
  - SwissAI
  - vLLM
  - Ruby
  - Switzerland
build:
  list: never
  render: always
---

{{< img src="/en/posts/technology/2026-11-20-apertus-on-cloud-run-the-sprungli-of-llms/images/hero_toblerone_apertus.png" caption="Apertus on Cloud Run Hero Image — A Swiss Toblerone mountain peak topped with Cloud Run, a GPU rocket carrying Apertus, and a Sprungli-style 97% open chocolate bar" alt="Apertus on Cloud Run Hero Image — A Swiss Toblerone mountain peak topped with Cloud Run, a GPU rocket carrying Apertus, and a Sprungli-style 97% open chocolate bar" position="center" >}}

Proprietary frontier models cover almost everything well. **Apertus**, built in Switzerland by ETH Zurich, EPFL, and CSCS, feels different. Walking up to it feels like picking up a bar of **97% dark chocolate at Confiserie Sprungli** on Bahnhofstrasse: intensely Swiss, Apache-2.0 open down to the weights, and tuned for Swiss-German and Romansh.

I tested how well Apertus runs on [Google Cloud Run](https://cloud.google.com/run/docs/configuring/services/gpu?utm_campaign=CDR_0x89ad3e41_awareness_b586867301&utm_medium=external&utm_source=blog) with **zero persistent VMs** and **zero static API keys**. My goal covered three practical tests:

1. Serve Apertus inside **Zurich (`europe-west6`)** for strict Swiss data residency.
2. Run **multimodal `Apertus-v1.5-8B`** on Cloud Run GPUs cleanly for interactive CLI use.
3. Read a visual-only **synthetic Swiss tax letter PDF**, extract the balance and QR-IBAN, and translate the notice into **Zuerituutsch** and **Rumantsch**.

---

## Challenge 1: Zurich (`europe-west6`) Has No Cloud Run GPUs Yet

My first deploy targeted `--region=europe-west6` with an `nvidia-l4` GPU. Cloud Run returned `INVALID_ARGUMENT` right away. GPU instances in Europe currently run in `europe-west4` (Netherlands) and `europe-west1` (Belgium), while `europe-west6` offers CPU and memory only. Dry-run checks also surfaced two hard limits: Cloud Run allows at most `1` GPU per instance and caps ephemeral scratch disk at `10 GiB`.

Splitting text and vision workloads solved this cleanly. Zurich stays 100% inside Switzerland on CPU, and Belgium plus the Netherlands host GPU endpoints.

| Target Alias | Region | Compute | Engine & Model | Role |
| :--- | :--- | :--- | :--- | :--- |
| `zurich` (`zh`) | `europe-west6` | `8` vCPU / `32Gi` RAM | `llama.cpp` (`Q4_K_M`) | Swiss data residency + Web Chat UI |
| `belgium` (`be`) | `europe-west1` | `1x nvidia-l4` / `8` vCPU / `32Gi` | `vLLM v0.34.0` (`Apertus-8B-Instruct-2509`) | Closest EU GPU (~490 km from Zurich) |
| `ew4` (`nl`) | `europe-west4` | `1x nvidia-l4` / `8` vCPU / `32Gi` | `vLLM v0.34.0` (`Apertus-8B-Instruct-2509`) | Baseline GPU v1.0 service |
| `v15` | `europe-west4` | `1x nvidia-rtx-pro-6000` / `20` vCPU / `80Gi` | `vllm_apertus_1.5_release` (`Apertus-v1.5-8B`) | Vision (`--image`, `--pdf`) + tools |

The **Zurich CPU service** proved surprisingly practical. Running `ghcr.io/ggml-org/llama.cpp:server` with `unsloth/Apertus-8B-Instruct-2509-GGUF:Q4_K_M`, it cold-started in **`92s`** and answered `/v1/chat/completions` in **`6.69s` (`6.78 tok/s`)**. Tunneling port `8000` with `gcloud run services proxy` even opens llama.cpp's built-in chat UI in your browser.

---

## Challenge 2: Fixing `Apertus-v1.5-8B` Cold Starts and Timeouts

Upgrading to multimodal **`Apertus-v1.5-8B`** hit three engineering hurdles:

1. **Dedicated container runtime**: Upstream `vllm/vllm-openai` only registers `ApertusForCausalLM`. Version 1.5 uses `Apertus1p5ForConditionalGeneration`, which requires `ghcr.io/swiss-ai/vllm_apertus_1.5_release:latest-amd64` with explicit `--command=/opt/venv/bin/vllm` because the image omits an `ENTRYPOINT`.
2. **HuggingFace secret injection**: Since `v1.5` uses `"gated": "auto"`, Cloud Run mounts `HF_TOKEN` from Secret Manager.
3. **Cold starts crossed Cloud Run limits**: Pulling a ~15 GB GHCR container and downloading `17+ GiB` of weights over public HTTPS took `720.6s` on deploy. On a live cold request, the instance booted in `750.3s` and hit Cloud Run's queued-request `SIGTERM` just **`135ms`** after `/health` succeeded.

We fixed image pull latency and weight staging inside `europe-west4`:

1. **Artifact Registry mirror via `crane`**: `docker pull` inside Cloud Build failed with `archive/tar: invalid tar header` on GHCR zstd layers. Using `gcr.io/go-containerregistry/crane:debug` copied the image straight into `europe-west4-docker.pkg.dev`, cutting Cloud Run container pull time down to **`~2.7s`**.
2. **GCS FUSE model bucket**: Cloud Build downloaded `Apertus-v1.5-8B` once via `hf_transfer` into Cloud Storage, mounted read-only at `/models` with [Cloud Storage volume mounts](https://cloud.google.com/run/docs/configuring/services/cloud-storage-volume-mounts?utm_campaign=CDR_0x89ad3e41_awareness_b586867301&utm_medium=external&utm_source=blog).
3. **`--enforce-eager` and realistic probe headroom**: Disabling CUDA graph capture on boot saves warmup time, while matching `startupProbe` to `10m+` avoids premature restarts when reading `16 GiB` over FUSE.

**Wait — why an RTX PRO 6000 instead of an L4 for `v1.5`?**
Testing a live PDF on an L4 (`22.03 GiB` usable VRAM) exposed an important hardware boundary: `Apertus-v1.5-8B` BF16 weights take `17.23 GiB`, KV cache reserves ~`2 GiB`, and Apertus 1.5's vision encoder (`modeling_apertus1p5.py`) needs extra GPU workspace during image encoding (`torch.OutOfMemoryError: CUDA out of memory`). Moving `:v15` to **`1x nvidia-rtx-pro-6000`** (`96 GiB` VRAM, `20` vCPU, `80Gi` RAM, `--max-model-len=32768`) leaves `66.13 GiB` (`541,744` tokens) of headroom.

**Cold-start vs. cost tradeoff (`--min-instances=0` vs `--min-instances=1`):**
Even with a `2.64s` image pull and `20` vCPUs, reading `17.23 GiB` through GCSFuse plus vLLM initialization takes **~9.9 minutes** (`9m51s` measured). Keeping `--min-instances=0` costs `$0` when idle, though cold CLI callers wait nearly 10 minutes. For an active 7-day workshop or demo window, setting `--min-instances=1` delivers **`0s` cold start** for **`~$3.19/hour`** (`~$76.46/day`), paired with a calendar reminder to scale right back down to `0` once demos wrap.

---

## Multimodal Demo: Synthetic Swiss Tax Letter -> *Zuerituutsch* & *Rumantsch*

OpenAI-compatible vision endpoints accept base64 PNG/JPEG images rather than raw `.pdf` files. I wrapped the flow in a small Ruby CLI (`apertus.rb`) that mints short-lived OIDC tokens with `gcloud auth print-identity-token` and invokes `pdftoppm -png -r 100` whenever `--pdf` is passed. Using `100` DPI cuts single-page prompt tokens roughly in half (`~3,978` tokens instead of `~7,910` at `150` DPI), preserving crisp typography while leaving headroom inside the context window.

To avoid touching any real tax data, we built a **100% synthetic image-only PDF** (`FAKE_swiss_tax_letter.pdf`) addressed to fictional *"Herr Max Mustermann, Bahnhofstrasse 42, 8001 Zuerich"* (`pdftotext` returns zero bytes of text).

```bash
apertus.rb --target v15 --pdf FAKE_swiss_tax_letter.pdf --max-tokens 900 \
  "Read this Swiss tax letter image carefully and: 1) Extract issuer, recipient, assessment amount, remaining balance, due date, and QR-IBAN; 2) Translate the main notice cleanly into Schwiizertuutsch (Zuerituutsch) AND Rumantsch (Romansh)."
```

**Live output from `apertus.rb --pdf FAKE_swiss_tax_letter.pdf` (`HTTP 200` in `5.47s`, `3,982` prompt + `245` completion tokens):**

```text
1) Issuer: Kantonale Steuerverwaltung Zuerich
Recipient: Herr Max Mustermann
Assessment amount: CHF 14,800.00
Remaining balance: -CHF 18,800.00
Due date: 31. Dezember 2026
QR-IBAN: IBAN CH93-0076-2011-6238-5295-7

2)
Schwiizertuutsch: Herr Mustermann, si ha schribe, dass si dsue Jahr e Steuersumme vo CHF 14'800.00 schuld si. Si muess bis zum 31. Dezämber 2026 paye.
Rumantsch: Signur Mustermann, i Vus ha scrit che Vus avais da pajar in importo da taglia da CHF 14'800.00 l'onn passà. Vus avais da pajar fin ils 31 da december 2026.
```

That took **5.47 seconds** end-to-end (including local `pdftoppm` rendering and OIDC token minting). Notice also an honest 8B nuance: Apertus v1.5 nailed the **Rumantsch** notice cleanly while mixing Swiss-German with Standard German/French vocabulary (*"paye"*) unless given few-shot dialect examples—good to know before trusting small open models with official municipal forms!

---

## Practical Takeaways for Swiss Cloud Builders

1. **Keep text workloads in `europe-west6` when Swiss residency matters**: `llama.cpp` on `8` CPU cores cold-starts in `92s` and delivers `6.78 tok/s` with zero GPUs.
2. **Use Artifact Registry + GCS FUSE for open weights**: Regional `crane copy` dropped our container import step to `2.7s`, eliminating external GHCR/HuggingFace network flakiness.
3. **Match your scaling policy to your UX**: Keep `--min-instances=0` for batch jobs (`$0` idle), or budget `--min-instances=1` (`~$3.19/hr` on RTX PRO 6000) strictly during active workshops and set a calendar reminder to scale down.
4. **Authenticate with Cloud Run IAM**: Granting `roles/run.invoker` to teammates lets everyone query the endpoint with short-lived `gcloud` OIDC tokens and zero shared API keys.

Ready to deploy your own open-weight Swiss endpoint? Explore the [Cloud Run GPU documentation](https://cloud.google.com/run/docs/configuring/services/gpu?utm_campaign=CDR_0x89ad3e41_awareness_b586867301&utm_medium=external&utm_source=blog) and keep your models open.
