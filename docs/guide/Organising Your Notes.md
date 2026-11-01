**`main.md` is your document.** Whatever it contains ends up in the PDF, in the same order.

# Splitting Into Notes

For anything longer than a few pages, put each chapter or section in its own note in `docs/` and **embed** it in `main.md`. Drag the note from the file list into `main.md` and add a `!` in front of the link:

```markdown
# Introduction

![](</docs/Background.md>)
```

The note's file name becomes a heading, and the note's own headings move down a level to fit underneath (see the `embed-headings` and `embed-offset` options in [@customising-the-layout]). With all the content in embedded notes, `main.md` only holds the chapter headings and embeds, so you can reorder chapters by moving lines.

# Names and Links

- Keep folder names lowercase (`docs`, `attachments`). Linux and git treat `Docs` and `docs` as different folders, so mixed case can break the build on a groupmate's computer.
- Give notes readable names, such as `AI Disclosure.md`. They become headings in the PDF.
- Paste or drag images into a note. Obsidian saves them in an `attachments` folder next to the note and inserts the link.
- Links can use any form Obsidian understands: `[[Note]]`, `[text](</docs/Note.md>)` or a path relative to the note. The recommended settings write links that start with `/` (from the vault root), which also work on GitHub.

# Folder Structure

```
.
├── main.md               ← your document (start here)
├── main.typ              ← PDF settings and title page
├── main.pdf              ← the output (not in git)
├── obsidian.typ          ← Obsidian → Typst converter
├── docs/                 ← other notes, embedded in main.md
│   └── attachments/      ← images you paste into notes
├── citations/
│   └── references.bib    ← your sources (kept by Zotero)
├── templates/            ← snippets for Alt + I
├── .fonts/               ← PDF fonts + licences
├── .obsidian.default/    ← recommended Obsidian settings
├── .obsidian/            ← your Obsidian settings (not in git)
├── .cache/               ← web images, Mermaid (not in git)
└── toolbox.sh            ← build, watch, setup, format
```

Everything marked *not in git* is created on each computer: `main.pdf` and `.cache/` by `./toolbox.sh build`, and `.obsidian/` by `./toolbox.sh setup`. You never need to edit `obsidian.typ`.
