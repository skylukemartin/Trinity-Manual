You need three programs to write and build a document, and two more for optional extras.

| Tool | Needed? | What it's for |
| --- | --- | --- |
| [Obsidian](https://obsidian.md/download) | **Yes** | Writing your notes |
| [Git](https://git-scm.com/downloads) | **Yes** | Downloading the template and (on Windows) running `toolbox.sh` via **Git Bash** |
| [Typst](https://github.com/typst/typst#installation) **0.15 or newer** | **Yes** | Turning the notes into a PDF |
| [Zotero](https://www.zotero.org/download/) | Only for citations | Managing your references |
| [Node.js](https://nodejs.org) | Only for auto-formatting | Running `./toolbox.sh format` |

# Windows

1. Install **Obsidian** from [obsidian.md/download](https://obsidian.md/download).
2. Install **Git for Windows** from [git-scm.com/downloads/win](https://git-scm.com/downloads/win). Keep the default options. It includes **Git Bash**, the terminal you'll use to run `toolbox.sh`.
3. Install **Typst**. Open **PowerShell** (Start menu → type `PowerShell`) and run:

   ```powershell
   winget install --id Typst.Typst
   ```

4. **Close and reopen** any open terminal windows so they can find `typst`.

# macOS

1. Install **Obsidian** from [obsidian.md/download](https://obsidian.md/download).
2. Install [Homebrew](https://brew.sh) if you don't have it, then open **Terminal** and run:

   ```bash
   brew install git typst
   ```

# Linux

1. Install **Obsidian** from [obsidian.md/download](https://obsidian.md/download) (AppImage, Flatpak or .deb).
2. Install **Git** with your package manager, for example `sudo apt install git`.
3. Install **Typst** with one of these:

   ```bash
   sudo snap install typst          # Ubuntu and other snap-based distros
   cargo install --locked typst-cli # if you have Rust installed
   ```

   You can also download `typst-x86_64-unknown-linux-musl.tar.xz` from the [Typst releases page](https://github.com/typst/typst/releases/latest), extract it, and put the `typst` file in a folder on your `PATH`, such as `~/.local/bin`.

# Checking the Installation

Open a terminal (Git Bash on Windows) and run:

```bash
git --version
typst --version
```

Both commands should print a version number. If you see `command not found`, see [@troubleshooting].
