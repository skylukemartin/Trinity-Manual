`main.typ` controls what goes into the PDF and how it looks. Open it in any text editor, such as Notepad, TextEdit or [VS Code](https://code.visualstudio.com). Obsidian lists the file but can't edit it.

# Cover and Page Layout

```typst
#let palette = "okyanus"

#show: im-doc.with(
  lang: "en",
  title: [obsidian.typ],
  subtitle: [User Manual],
  author: "Your Name",
  version: "Version 1.0",
  fonts: "plex",
  colors: palette,
  ...
)

#im-cover(style: "minimap", series: "Documentation")
```

Replace the example values with your own. Useful things to change:

- **Colours:** set `palette` to `okyanus` (blue), `fiyort`, `gece`, `celik`, `okabe` (colour-blind safe), `orman` (green), `nane`, `zeytin`, `kiremit`, `kehribar`, `gul`, `bordo`, `lavanta`, `murdum` or `grafit` (grey).
- **Cover artwork:** `style:` can be `waveform`, `pcm`, `packet`, `bits`, `gitgraph`, `minimap`, `neural`, `solid`, `topo` or `halftone`. Add `logo: image("docs/attachments/logo.png")` to show your logo.
- **Header and footer:** each slot (`left`, `center`, `right`) takes `"title"`, `"chapter"`, `"section"`, `"author"`, `"date"`, `"version"`, `"page"`, `"page-total"` or your own text.
- **Double-sided printing:** add `mirror: true, chapter-start: "odd"`.

The layout comes from the [ilkman](https://typst.app/universe/package/ilkman) package, whose page lists every option. Callouts are drawn as ilkman notes by the `callout` function in `main.typ`.

> [!note] Prefer a plain report?
> Switch to the `main` branch, or copy its `main.typ` and `.fonts/` folder into your vault.

# Choosing the Notes

`render_markdown` decides which notes go into the PDF:

```typst
#render_markdown(
  "main.md",
  "docs/Appendix.md",
)
```

Each file in the list starts on a new page. These options can be added inside the brackets:

| Option | Default | What it does |
| --- | --- | --- |
| `file-headings: true` | `false` | Adds a heading with the file's name above each file |
| `embed-headings: false` | `true` | Leaves out the heading above embedded notes |
| `embed-offset: 0` | `1` | How many levels deeper an embedded note's headings go |
| `auto-pagebreak: false` | `true` | Stops starting a new page at every top-level heading |

# References and Appendix

The end of `main.typ` adds the reference list (IEEE style, from `citations/references.bib`) and the `docs/AI Disclosure.md` page as Appendix A. To use another citation style, change `style: "ieee"` to, for example, `"apa"` or `"harvard-cite-them-right"`. To remove a part, delete its block.
