# Riccardo's Notes: Articles Compiled from External Repositories

⚠️ **IMPORTANT**: Do NOT edit the following article directories directly in this repository. Any direct modifications will be overwritten and lost during the next build/sync run:

*   `zzo.ricc.rocks/content/en/posts/technology/2026-06-16-crescendo-of-agents-part-1/`
*   `zzo.ricc.rocks/content/en/posts/technology/2026-06-16-crescendo-of-agents-part-2/`

---

## 🔗 How We Got Here (The Dependency)

These articles are developed, compiled, and synced from the private catch-all repository:
*   **Source Repo**: `ricclife-with-gemini-pvt`
*   **Source Drafts Path**: `~/git/ricclife-with-gemini-pvt/work/articles/20260605-worktree-multiagent-dev-flow/articles/`

## 🛠️ Update & Build Workflow

To edit or update these articles, follow this workflow in the source repository:

1.  Navigate to the source drafts:
    ```bash
    cd ~/git/ricclife-with-gemini-pvt/work/articles/20260605-worktree-multiagent-dev-flow/
    ```
2.  Edit the draft `ARTICLE.md` in the respective directory:
    -   Part 1: `articles/01-crescendo-of-agents-part-1/ARTICLE.md`
    -   Part 2: `articles/02-crescendo-of-agents-part-2/ARTICLE.md`
3.  Compile the Markdown and assets:
    ```bash
    just build
    ```
4.  Sync the built files to the `ricc.rocks` repository:
    ```bash
    just copy-to-ricc-rocks
    ```
5.  Commit and push in both repositories to keep remote sites aligned.
