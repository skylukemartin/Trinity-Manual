# obsidian.typ

Write your notes in [Obsidian](https://obsidian.md). Get a properly formatted PDF from them with [Typst](https://typst.app): title page, table of contents, callouts, figures, citations and a reference list.

You write normal Obsidian markdown in `main.md` (and any other notes you link in), run one script, and get `main.pdf`.

> **Never used a terminal before?** That's fine. Follow the steps in order and copy-paste the commands exactly. Every command in this README is meant to be run **from inside the vault folder** (step 6 shows how to open a terminal there).

---

## Contents

1. [Install the tools](#1-install-the-tools)
2. [Get the template](#2-get-the-template)
3. [Open it in Obsidian](#3-open-it-in-obsidian)
4. [Apply the recommended settings](#4-apply-the-recommended-settings)
5. [Write your document](#5-write-your-document)
6. [Build the PDF](#6-build-the-pdf)
7. [Markdown cheat sheet (what turns into what)](#7-markdown-cheat-sheet)
8. [Customise the PDF (`main.typ`)](#8-customise-the-pdf-maintyp)
9. [Citations with Zotero](#9-citations-with-zotero)
10. [Templates and hotkeys](#10-templates-and-hotkeys)
11. [Web images and Mermaid diagrams](#11-web-images-and-mermaid-diagrams)
12. [Auto-formatting (optional)](#12-auto-formatting-optional)
13. [Folder structure](#13-folder-structure)
14. [Troubleshooting](#14-troubleshooting)

---

## 1. Install the tools

| Tool | Needed? | What it's for |
| --- | --- | --- |
| [Obsidian](https://obsidian.md/download) | **Yes** | Writing your notes |
| [Git](https://git-scm.com/downloads) | **Yes** | Downloading the template and (on Windows) running `toolbox.sh` via **Git Bash** |
| [Typst](https://github.com/typst/typst#installation) **0.15 or newer** | **Yes** | Turning the notes into a PDF |
| [Zotero](https://www.zotero.org/download/) | Only for citations | Managing your references |
| [Node.js](https://nodejs.org) | Only for auto-formatting | Running `./toolbox.sh format` |

### Windows

1. Install **Obsidian**: [obsidian.md/download](https://obsidian.md/download).
2. Install **Git for Windows**: [git-scm.com/downloads/win](https://git-scm.com/downloads/win). Keep the default options; it includes **Git Bash**, which you'll use to run `toolbox.sh`.
3. Install **Typst**. Open **PowerShell** (Start menu → type `PowerShell`) and run:

   ```powershell
   winget install --id Typst.Typst
   ```

4. **Close and reopen** any terminal windows so they can find `typst`.

### macOS

1. Install **Obsidian**: [obsidian.md/download](https://obsidian.md/download).
2. Install [Homebrew](https://brew.sh) if you don't have it, then open **Terminal** and run:

   ```bash
   brew install git typst
   ```

### Linux

1. Install **Obsidian**: [obsidian.md/download](https://obsidian.md/download) (AppImage, Flatpak or .deb).
2. Install **Git** with your package manager (for example `sudo apt install git`).
3. Install **Typst** with one of these:

   ```bash
   sudo snap install typst          # Ubuntu and other snap-based distros
   # or
   cargo install --locked typst-cli # if you have Rust installed
   ```

   Or download `typst-x86_64-unknown-linux-musl.tar.xz` from the [Typst releases page](https://github.com/typst/typst/releases/latest), extract it, and put the `typst` file somewhere on your `PATH` (for example `~/.local/bin`).

### Check that it worked

Open a terminal (Git Bash on Windows) and run:

```bash
git --version
typst --version
```

Both should print a version number. If you see `command not found`, see [Troubleshooting](#14-troubleshooting).

---

## 2. Get the template

Pick **one** of these.

### Option A: GitHub Desktop (no terminal)

1. Install [GitHub Desktop](https://desktop.github.com).
2. **File → Clone repository… → URL** tab.
3. Paste `https://github.com/obsidian2typst/template`.
4. Choose where to put it (for example `Documents/Obsidian`) and click **Clone**.

### Option B: Command line

```bash
cd ~/Documents            # or wherever you keep your vaults
git clone https://github.com/obsidian2typst/template my-vault
cd my-vault
```

> Starting your own project (for example a group assignment)? On the GitHub page click **Use this template → Create a new repository** first, then clone **your** new repository instead.

---

## 3. Open it in Obsidian

1. Open Obsidian.
2. Click the vault name at the bottom left → **Manage vaults…** (or use the start screen).
3. Click **Open folder as vault** and select the folder you just cloned (the one containing `main.md`).

---

## 4. Apply the recommended settings

The template comes with ready-made Obsidian settings in the `.obsidian.default` folder. Together with two plugins, they make links, attachments and citations work the way the PDF build expects. The plugins aren't stored in this repo: the setup script downloads them from their official GitHub releases.

### The easy way (script)

1. **Close Obsidian.**
2. Open a terminal in the vault folder (see [step 6](#6-build-the-pdf) if you don't know how).
3. Run:

   ```bash
   ./toolbox.sh setup
   ```

4. Answer the questions by typing `y` or `n` and pressing Enter:
   - **Remove the git-ignored files above?** This is only asked if you already have vault settings. It deletes your current `.obsidian/` folder (settings and installed plugins) and the old `main.pdf`. Type `y` on a fresh copy of the template. Type `n` if you've customised Obsidian and want to keep that; the recommended settings are copied over it either way, and plugins you already have stay enabled.
   - **Also install the extras?** The two required plugins are always installed. Type `y` to also get the Minimal theme and some handy plugins (see the list below), or `n` to keep Obsidian plain.
5. Open Obsidian again. If it asks whether you trust the plugins, click **Trust author and enable plugins**.

The script needs internet, because it downloads the plugins.

### The manual way

1. Copy the `.json` files **inside** `.obsidian.default` into the vault's `.obsidian` folder (create it if it doesn't exist, overwrite if asked).
2. In Obsidian, go to **Settings → Community plugins**, turn off Restricted mode, and install **Better Markdown Links** and **Citations** with **Browse**.
3. Copy each plugin's `data.json` from `.obsidian.default/plugins/<plugin>/` into `.obsidian/plugins/<plugin>/` (overwrite), then restart Obsidian. Or set them by hand using the list below.

> Can't see these folders? Names starting with a dot are hidden. In Windows File Explorer: **View → Show → Hidden items**. On macOS Finder: press `Cmd + Shift + .`

<details>
<summary><b>What the settings do / setting them up by hand</b> (click to expand)</summary>

You only need this if you want to set everything up yourself instead of copying `.obsidian.default`.

**Required community plugins**

- [Better Markdown Links](https://obsidian.md/plugins?id=better-markdown-links) makes links use paths the PDF build understands.
- [Citations](https://obsidian.md/plugins?id=obsidian-citation-plugin) inserts citations from `citations/references.bib`.

**Optional extras** (installed by `./toolbox.sh setup` if you answer `y`): [Minimal](https://github.com/kepano/obsidian-minimal) theme, Minimal Theme Settings, Style Settings, Linter, Advanced Tables, Multi Properties, Note Auto Creator, Omnisearch, Text Extractor, Emoji Autocomplete, Vim Toggle.

With the extras, PDFs opened inside Obsidian are shown exactly as they print: Minimal's "Invert PDFs in dark mode" and "Blend PDFs in light mode" are turned off (**Settings → Style Settings → Minimal → PDFs**). The PDF file itself is never affected by these.

The plugin versions are pinned in the lists at the top of `toolbox.sh`, so everyone gets versions that work with these settings. To upgrade one, change its version number there and run setup again.

**Settings → Files and links**

- `Default location for new notes` = `Same folder as current file`
- `Default location for new attachments` = `In subfolder under current folder`
- `Subfolder name` = `attachments`
- `New link format` = `Absolute path in vault`
- `Automatically update internal links` = on
- `Use [[Wikilinks]]` = off. The PDF build understands both kinds of link, but markdown links also work on GitHub.
- `Detect all file extensions` = on

**Settings → Editor**

- `Strict line breaks` = on, so a single line break looks the same in Obsidian as in the PDF and on GitHub (a new paragraph needs an empty line).

**Settings → Core plugins → Templates**

- `Template folder location` = `templates`

**Settings → Community plugins → Better Markdown Links**

- `Should use leading dot for relative paths` = on
- `Should use leading slash for absolute paths` = on
- `Should use angle brackets` = on
- `Should normalize file links` = on
- `Convert links` = `On save command`
- `Should automatically update links on rename or move` = on
- `Should allow empty embed alias` = on
- `Should include attachment extension to embed alias` = off
- `Should preserve existing link style` = off
- `Include paths` / `Exclude paths` = leave as default

**Settings → Community plugins → Citations**

- `Citation database format` = `BibLaTeX`
- `Citation database path` = `citations/references.bib`
- `Markdown citation template` = `[@{{citekey}}]`

</details>

---

## 5. Write your document

- **`main.md` is your document.** Whatever is in it ends up in the PDF.
- Put other notes (chapters, sections) in `docs/` and **embed** them in `main.md` by dragging the note from the file list into `main.md` and adding a `!` in front:

  ```markdown
  # Introduction

  ![](</docs/Background.md>)
  ```

  The embedded note is pasted into the PDF at that spot, with its headings shifted to fit underneath (see [`embed-headings`](#8-customise-the-pdf-maintyp)).
- Images: paste or drag them into a note. Obsidian saves them into an `attachments` folder next to the note and inserts the link for you.
- Keep folder names lowercase (`docs`, `attachments`) and give notes readable names (`AI Disclosure.md`). Linux and git treat `Docs` and `docs` as different folders, so mixed case can break the build on a groupmate's computer. Note names can be anything: they become headings in the PDF.
- Links can use any form Obsidian understands: `[[Note]]`, `[text](</docs/Note.md>)`, or a path relative to the note. The recommended settings create links that start with `/` (from the vault root), which also work on GitHub.

---

## 6. Build the PDF

Everything runs through one script, `toolbox.sh`. Run `./toolbox.sh` with nothing after it to get a numbered menu, or add a command (`build`, `watch`, `setup`, `format`, `localize`) to run it straight away.

### Open a terminal in the vault folder

- **Windows:** open the vault folder in File Explorer, right-click an empty area → **Open Git Bash here**. On Windows 11 you may need to click **Show more options** first.
- **macOS:** right-click the folder in Finder → **New Terminal at Folder**. If you don't see it, open Terminal, type `cd ` (with a space), drag the folder into the window and press Enter.
- **Linux:** right-click in the folder → **Open in Terminal**.

### Compile once

```bash
./toolbox.sh build
```

This creates (or updates) `main.pdf` in the vault folder. The **first** run needs internet, because Typst downloads the packages it uses. It also downloads any web images and renders any Mermaid diagrams in your notes (see [step 11](#11-web-images-and-mermaid-diagrams)). After that it works offline.

### Live preview (recommended while writing)

```bash
./toolbox.sh watch
```

This recompiles `main.pdf` every time you save a file, and downloads or renders new web images and Mermaid diagrams as you add them. Open `main.pdf` in a PDF viewer that reloads automatically (for example the PDF viewer in VS Code, SumatraPDF on Windows, Skim on macOS, or most Linux viewers). Press `Ctrl + C` in the terminal to stop.

> Both commands compile `main.typ` by default. To build a different file: `./toolbox.sh build other.typ`.
>
> Always use the toolbox rather than running `typst compile` yourself. It also loads the bundled fonts in `.fonts/` and prepares web images and Mermaid diagrams. With plain `typst compile`, web images become links and Mermaid diagrams stay as code.

---

## 7. Markdown cheat sheet

Most normal markdown works as you'd expect: headings, **bold**, *italic*, ~~strikethrough~~, lists, tables, `code`, code blocks with syntax highlighting, links, footnotes (`[^1]`), and `<sub>`/`<sup>`. Rendering is done by the [cmarker](https://typst.app/universe/package/cmarker) package; see its page for exact details.

**The example notes in `docs/` show every feature below.** Build the PDF once and compare it with the notes in Obsidian. `docs/Obsidian Syntax.md` uses all of Obsidian's own syntax.

What this template adds:

| You write | You get in the PDF |
| --- | --- |
| `> [!note] Title`<br>`> Text` | A coloured callout box with icon. Works with `note`, `info`, `important`, `tip`, `success`, `warning`, `caution`, `error`, `danger`, `bug`, `example`, `quote`; any other name becomes a blue box. Folded callouts (`[!note]-` / `[!note]+`) work too and are shown expanded. |
| `![[Chapter]]` or `![](</docs/Chapter.md>)` (on its own line) | The whole note is inserted here, with a heading named after the file |
| `![[Chapter\|My title]]` or `![My title](</docs/Chapter.md>)` | Same, but with `My title` as the heading |
| `![[Chapter#Heading]]` / `![[Chapter#^block-id]]` | Just that section / just that paragraph |
| `![[pic.png]]`, `![[pic.png\|300]]`, `![alt\|300x200](…)` | The image, optionally with a width (and height) in pixels like in Obsidian |
| `![[handout.pdf#page=2]]` | That page of the PDF, as an image |
| `[[Note]]`, `[[Note\|text]]`, `[[Note#Heading]]`, `[[#^block-id]]`, `[text](</docs/Note.md>)` | A clickable link if that note, heading or block is in the PDF; otherwise plain text |
| `text ^block-id` | A target for `[[#^block-id]]` links (the id itself isn't shown) |
| `%%comment%%` (also over several lines) | Nothing: comments only show in Obsidian's editor |
| `^[inline footnote]` | A normal footnote |
| `- [ ] task`, `- [x] done` | Checkboxes. Other marks Obsidian themes use (`- [/]`, `- [-]` …) count as done. |
| Front matter (properties) | Nothing: it's left out |
| `#tag` | The tag as plain text |
| The `figure-with-caption` template | A numbered figure with a caption |
| `![alt](https://…)` or `<img src="https://…">` | The web image or PDF (first page), downloaded when you build |
| ` ```mermaid ` code block | The rendered diagram. Add `%% caption: …` and `%% id: …` lines at the top to make it a numbered figure (`mermaid-figure` template). |
| `==text==` | Highlighted text |
| `$E = mc^2$` and `$$ … $$` | LaTeX maths, inline and as a block (converted by [MiTeX](https://typst.app/universe/package/mitex)) |
| `[@CitationKey]` | An in-text citation like `[1]`, plus an entry in the reference list |
| `[@some-heading]` | A cross-reference like "Section 2.1". The label is the heading in lowercase, with spaces turned into dashes and punctuation dropped (`Results & Discussion` → `[@results--discussion]`); a second heading with the same text gets `-1`. To choose your own, write the heading as `<h2 id="results">Results & Discussion</h2>`. |
| `<figure id="my-chart">` … and `[@my-chart]` | A cross-reference like "Figure 1" |
| `<!--typst-begin-exclude-->` … `<!--typst-end-exclude-->` | Everything in between appears in Obsidian but **not** in the PDF |
| `<!--raw-typst #pagebreak()-->` | Runs Typst code directly, here a page break. Anything Typst can do works, for example `#lorem(50)` for filler text. |

**Not converted:**

- Plugin-only syntax (Dataview queries, Tasks queries, Excalidraw…): it stays a code block.
- Embeds of anything that isn't a note, image or PDF (audio, video, canvas, web pages): the file name or a link is shown instead.
- Obsidian shows tags as coloured pills; in the PDF they're plain text.

---

## 8. Customise the PDF (`main.typ`)

`main.typ` controls what goes into the PDF and how it looks. Open it in any text editor, such as Notepad, TextEdit or [VS Code](https://code.visualstudio.com). Obsidian lists the file but can't edit it.

### Title page

```typst
#show: it => basic-report(
  doc-category: "Assignment",
  doc-title: "My Report",
  author: "Your Name",
  language: "en",
  it,
)
```

Replace the example values with your own. The layout comes from the [basic-report](https://typst.app/universe/package/basic-report) package; its page lists every option.

### Which notes go in

```typst
#render_markdown(
  "main.md",
)
```

You can list several files. Each one starts on a new page:

```typst
#render_markdown(
  "main.md",
  "docs/Appendix.md",
)
```

Options you can add inside `render_markdown(...)`:

| Option | Default | What it does |
| --- | --- | --- |
| `file-headings: true` | `false` | Adds a top-level heading with the file's name above each file (used for `AI Disclosure`) |
| `embed-headings: false` | `true` | Don't add a heading above embedded notes |
| `embed-offset: 0` | `1` | How many levels deeper an embedded note's headings go than the heading it's embedded under |
| `auto-pagebreak: false` | `true` | Don't start a new page at every top-level (`#`) heading |

### References and AI disclosure

The rest of `main.typ` adds the reference list (IEEE style, from `citations/references.bib`) and the `docs/AI Disclosure.md` page. To use a different citation style, change `style: "ieee"` to, for example, `"apa"` or `"harvard-cite-them-right"`. To remove a section, delete its block.

---

## 9. Citations with Zotero

### One-time setup

1. Install [Zotero](https://www.zotero.org/download/) and its browser connector.
2. Install the [Better BibTeX](https://retorque.re/zotero-better-bibtex/installation/) add-on for Zotero.
3. In Zotero: **Edit → Settings → Better BibTeX → Export → BibTeX** (on macOS: **Zotero → Settings**):
   - Untick **Export unicode as plain-text latex commands**.
   - Set **Add URLs to BibTeX export** to **in the 'url' field**.
4. **File → Import… → A file →** select `citations/references.bib` from the vault → **Next → Finish**. This creates a new collection.
5. Right-click that collection → **Export Collection…** → Format **Better BibTeX**, tick **Keep updated** (and **Export Notes** if you like) → **OK** → save over `citations/references.bib` in the vault.

From now on, anything you add to that collection is automatically written into `references.bib`.

### Adding a source

On the web page or paper you want to cite, click the Zotero browser extension and save it into **that collection**.

### Citing in Obsidian

Press `Ctrl + P` (`Cmd + P` on macOS), type **insert markdown citation**, pick the source. You'll get something like `[@ObsidianSharpenYour]`. When you build the PDF it becomes `[1]` and the source appears in **References**.

> Working in a group? Commit `citations/references.bib` to git so everyone has the same sources.

---

## 10. Templates and hotkeys

Insert a template with `Alt + I` (or `Ctrl/Cmd + P` → **Templates: Insert template**):

| Template | Inserts |
| --- | --- |
| `figure-with-caption` | An image with a caption (replace `filepath`, `description`, `caption`) |
| `mermaid-figure` | A Mermaid diagram with a caption and id, so it becomes a numbered figure |
| `typst-pagebreak` | A page break |
| `typst-begin-exclude` / `typst-end-exclude` | Start / end of a block that's hidden from the PDF |
| `typst-lorem-50` | 50 words of filler text |

Other hotkeys set by the recommended settings:

| Hotkey | Action |
| --- | --- |
| `` Ctrl/Cmd + ` `` | Toggle between source and live preview |
| `Ctrl/Cmd + Esc` | Toggle Vim mode (only with the extras installed) |

---

## 11. Web images and Mermaid diagrams

Typst can't download anything itself, so `./toolbox.sh build` and `./toolbox.sh watch` do it just before compiling:

- **Web images and PDFs** (`![alt](https://…)` and `<img src="https://…">`) are downloaded once into the hidden `.cache/` folder and used from there. The PDF still builds offline afterwards. If a download fails, or the link isn't an image or PDF, it becomes a normal link in the PDF and the toolbox prints a warning.
- **Mermaid code blocks** are rendered to images by [mermaid.ink](https://mermaid.ink) (the rendering service of [mermaid.live](https://mermaid.live)), at 3× resolution. Each diagram is only rendered again when its code changes. If rendering fails, the PDF shows the diagram's code instead.

  ````markdown
  ```mermaid
  %% caption: How a note becomes a PDF.
  %% id: pipeline
  flowchart LR
      A[Notes] --> B[PDF]
  ```
  ````

  The `%% caption:` and `%% id:` lines are optional Mermaid comments, so Obsidian ignores them. With them, the diagram becomes a numbered figure you can refer to with `[@pipeline]`.

`.cache/` isn't committed to git, so everyone in a group downloads their own copy. To keep web images permanently in the vault instead (for example if a website might disappear), run:

```bash
./toolbox.sh localize
```

This copies every web image into the `attachments` folder next to the note that uses it and changes the link to point there. To do that automatically on every build, set `LOCALIZE_ON_BUILD=true` near the top of `toolbox.sh`.

---

## 12. Auto-formatting (optional)

Requires [Node.js](https://nodejs.org). **Commit your work first** so you can undo it with git if you don't like the result.

```bash
./toolbox.sh format
```

This tidies every `.md` file in the vault (including Mermaid code) with [Prettier](https://prettier.io). The first run downloads Prettier into `~/.cache/obsidian-typ-prettier`, so it needs internet.

### Make notes readable on GitHub

Obsidian-only syntax shows up as raw text on GitHub (`[[links]]`, `%%comments%%` …). To rewrite it as standard markdown that GitHub, Obsidian **and** the PDF all understand:

```bash
./toolbox.sh format --github
```

(or choose **4** in the menu and answer `y`). This needs Typst but not Node.js: without Node.js it just skips the Prettier step. It changes:

| Obsidian | Becomes |
| --- | --- |
| `[[Note]]`, `[[Note\|text]]`, `[[Note#Heading]]` | `[Note](</docs/Note.md>)`, `[text](…)`, `[Note > Heading](</docs/Note.md#heading>)` |
| `![[pic.png]]` / `![[pic.png\|300]]` | `![](</docs/attachments/pic.png>)` / `<img src="attachments/pic.png" width="300">` |
| `![[Note]]`, `![[file.pdf]]` | `![](</docs/Note.md>)`, `![](</docs/file.pdf>)`: GitHub can't embed these, but Obsidian and the PDF still do |
| `%%comment%%` | `<!--comment-->` |
| `==text==` | `<mark>text</mark>` |
| `^[inline footnote]` | `[^inline-1]` plus `[^inline-1]: inline footnote` at the end of the note |
| `text ^block-id` / `[[#^block-id]]` | `text <a id="block-id"></a>` / `[block-id](<#block-id>)` |
| `> [!success] Title` | `> [!TIP]` with `**Title**` as its first line (GitHub has five alert types: note, tip, important, warning, caution) |

Code, maths, Mermaid, front matter, `README.md` and the `templates/` folder are left alone. Links to notes that don't exist yet stay as `[[wikilinks]]`, so Obsidian can still create them.

Some things only work one way afterwards: Obsidian opens `#heading` links at the top of the note rather than at the heading, and callout types other than GitHub's five become the closest one. **Commit your work first** so you can undo it with git.

---

## 13. Folder structure

```
.
├── main.md               ← your document (start here)
├── main.typ              ← PDF settings and title page
├── main.pdf              ← the output (not in git)
├── obsidian.typ          ← Obsidian → Typst converter
├── docs/                 ← other notes, embedded in main.md
│   ├── Background.md, …  ← example sections (replace them)
│   ├── AI Disclosure.md  ← AI usage disclosure page
│   └── attachments/      ← images you paste into notes
├── citations/
│   └── references.bib    ← your sources (kept by Zotero)
├── templates/            ← snippets for Alt + I
├── .fonts/               ← PDF fonts (Ubuntu, Vollkorn) + licences
├── .obsidian.default/    ← recommended Obsidian settings
├── .obsidian/            ← your Obsidian settings (not in git)
├── .cache/               ← web images, Mermaid (not in git)
└── toolbox.sh            ← build, watch, setup, format
```

Everything marked *not in git* is created on each computer: `main.pdf` and `.cache/` by `./toolbox.sh build`, `.obsidian/` by `./toolbox.sh setup`. You never need to edit `obsidian.typ`.

Suggested way to organise a bigger document:

- One note per chapter or section in `docs/` (for example `docs/1 Introduction.md`, `docs/2 Method.md`).
- `main.md` only holds the top-level headings and embeds, so you can reorder chapters by moving lines.
- Images live in the `attachments` folder next to the note that uses them.

---

## 14. Troubleshooting

| Problem | Fix |
| --- | --- |
| `typst: command not found` (or the script says typst isn't installed) | Close and reopen the terminal after installing. Still broken? Reinstall Typst ([step 1](#1-install-the-tools)) and check `typst --version`. |
| `./toolbox.sh: Permission denied` | Run it with bash instead: `bash toolbox.sh build` (or whichever command you wanted). |
| `$'\r': command not found` or `bad interpreter` (Windows) | The script got Windows line endings. Commit or back up your work, then run `git rm -rq --cached . && git reset --hard` in the vault. This re-downloads the files with the correct line endings. |
| `.sh` files open in Notepad instead of running (Windows) | Don't double-click them. Run them from **Git Bash** as shown in [step 6](#6-build-the-pdf). |
| `failed to download package` | The first build needs internet. Check your connection (or school/work firewall) and try again. |
| `file not found` pointing at an embed or image | The link must start with `/` and match the file's real path and name exactly (capital letters matter: `docs`, not `Docs`). Re-drag the file into the note to regenerate the link. |
| `unknown font family` warning | You ran `typst` directly. Use `./toolbox.sh build`, which loads `.fonts/`. |
| A citation shows up as `@Key` or errors with `key not found` | That source isn't in `citations/references.bib`. Check Zotero's **Keep updated** export ([step 9](#9-citations-with-zotero)). |
| `could not download …` during setup | Check your internet connection (or school/work firewall: it must allow `github.com`) and run `./toolbox.sh setup` again. |
| `Warning: could not download …` or `could not render Mermaid diagram …` | Check your internet connection (or firewall: it must allow the website and `mermaid.ink`). For Mermaid, check the diagram for mistakes on [mermaid.live](https://mermaid.live). The PDF still builds, with a link or the diagram code instead. |
| Plugins/theme missing in Obsidian | **Settings → Community plugins → Turn on community plugins** (turn off Restricted mode), then restart Obsidian. Still missing? Close Obsidian and run `./toolbox.sh setup` again. |
| Something appears in Obsidian but not in the PDF | Check that it isn't inside a `typst-begin-exclude` block, and that it isn't syntax from the [not converted](#7-markdown-cheat-sheet) list. |
| The PDF doesn't update while watching | Make sure the `./toolbox.sh watch` terminal is still open and shows no error. Some PDF viewers (for example Adobe Reader) lock the file or don't reload. Try another viewer. |
