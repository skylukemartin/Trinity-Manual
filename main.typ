// User manual layout, using the ilkman template: https://typst.app/universe/package/ilkman
#import "@preview/ilkman:0.1.0": *
#import "obsidian.typ": render_markdown

// Colour palette: okyanus (blue), fiyort, gece, celik, okabe, orman (green), nane, zeytin,
// kiremit, kehribar, gul, bordo, lavanta, murdum or grafit (grey)
#let palette = "okyanus"
#let pal = palettes.at(palette)

#show: im-doc.with(
  lang: "en",
  title: [obsidian.typ],
  subtitle: [User Manual],
  author: "Your Name",
  version: "Version 1.0",
  fonts: "plex",
  colors: palette,
  par-indent: false, // block paragraphs, as usual in manuals
  note-column: 1 / 5, // wide left margin
  header: (left: "title", center: none, right: "chapter"),
  footer: (left: "version", center: none, right: "page"),
)

// Code blocks and tables in the palette's colours
#show raw.where(block: true): it => block(
  width: 100%,
  fill: pal.wash,
  stroke: 0.5pt + pal.tint,
  radius: 3pt,
  inset: (x: 0.9em, y: 0.75em),
  it,
)
// Inline code: ilkman draws it in a box, which can't break across lines, so a long command
// runs past the margin. Short code stays in one piece; longer code is highlighted instead, so it wraps.
#show raw.where(block: false): it => {
  let style = (fill: pal.wash, stroke: 0.4pt + pal.tint, radius: 2pt)
  let code = text(font: "IBM Plex Mono", size: 1.125em, fill: pal.ink, hyphenate: false, it.text)
  if it.text.len() <= 30 { box(..style, inset: (x: 2.5pt), outset: (y: 2.5pt), code) } else {
    highlight(..style, extent: 1.5pt, code)
  }
}
#set table(fill: (x, y) => if y == 0 { pal.primary } else if calc.even(y) { pal.wash })
#show table: set par(justify: false) // no stretched gaps in narrow cells
#set table.cell(breakable: false) // don't split a row across two pages
#show table.cell.where(y: 0): set text(fill: white, weight: "bold")

// Obsidian callouts as ilkman notes
#let callout(type, title, body) = {
  let kind = if type in ("tip", "hint", "success", "check", "done") { "tip" } else if type in (
    "warning",
    "caution",
    "attention",
    "important",
  ) { "warn" } else if type in ("danger", "error", "bug", "failure", "fail", "missing") { "danger" } else { "info" }
  im-note(kind: kind, title: if title != none { title } else { upper(type.first()) + type.slice(1) }, body)
}

#im-cover(style: "minimap", series: "Documentation")
#im-toc()

#render_markdown(
  "main.md",
  auto-pagebreak: false, // ilkman starts each chapter on a new page
  link-color: none, // use ilkman's link colour
  callout: callout,
)

#bibliography(
  "citations/references.bib",
  title: "References",
  style: "ieee",
)

#im-appendix[
  #render_markdown(
    "docs/AI Disclosure.md",
    file-headings: true,
    auto-pagebreak: false,
    link-color: none,
    callout: callout,
  )
]
