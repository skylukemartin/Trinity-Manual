The template comes in two layouts, each on its own git branch:

- **`main`**: a plain report layout.
- **`user-manual`**: the layout of this manual, with a cover page, chapters, running headers and note boxes.

Both branches contain the same converter and toolbox, so everything in this manual works with either one. You can switch layouts later (see [@customising-the-layout]).

> [!tip] Starting your own project?
> For a group assignment or anything you'll keep, open the template on GitHub and click **Use this template → Create a new repository** first. Then clone **your** new repository instead of the template. Tick **Include all branches** if you want the `user-manual` layout.

# Option A: GitHub Desktop

No terminal needed.

1. Install [GitHub Desktop](https://desktop.github.com).
2. Click **File → Clone repository…** and open the **URL** tab.
3. Paste `https://github.com/obsidian2typst/template`.
4. Choose where to put it, for example `Documents/Obsidian`, and click **Clone**.

# Option B: Command Line

```bash
cd ~/Documents
git clone https://github.com/obsidian2typst/template my-vault
cd my-vault
```

For the `user-manual` layout, add `-b user-manual` after `git clone`.

# Opening the Vault

1. Open Obsidian.
2. Click the vault name at the bottom left, then **Manage vaults…** (or use the start screen).
3. Click **Open folder as vault** and select the folder you cloned: the one that contains `main.md`.
