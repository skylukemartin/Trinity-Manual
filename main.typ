#import "@preview/basic-report:0.5.0": *
#import "obsidian.typ": render_markdown

#show: it => basic-report(
  doc-category: "Example Report",
  doc-title: "Writing Reports with obsidian.typ",
  author: "Your Name",
  language: "en",
  it,
)

#render_markdown(
  "main.md",
)

#pagebreak()

#bibliography(
  "citations/references.bib",
  title: "References",
  style: "ieee",
)

#pagebreak()

#render_markdown(
  "docs/AI Disclosure.md",
  file-headings: true,
)
