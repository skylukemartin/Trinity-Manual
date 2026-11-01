# Notes Only You Can See

Anything between `<!--typst-begin-exclude-->` and `<!--typst-end-exclude-->` stays in Obsidian but is left out of the PDF. Open this note in Obsidian to see the hidden paragraph that follows.

<!--typst-begin-exclude-->

> [!todo] Hidden from the PDF
> Use exclude blocks for to-do lists, drafts or feedback from your group. Insert them with the `typst-begin-exclude` and `typst-end-exclude` templates.

<!--typst-end-exclude-->

# Raw Typst

A comment starting with `raw-typst` runs Typst code directly, for anything markdown can't express. For example, `<!--raw-typst #text(fill: rgb("#16a34a"), weight: "bold")[green bold text]-->` gives <!--raw-typst #text(fill: rgb("#16a34a"), weight: "bold")[green bold text]-->, and `#block(lorem(30))` gives a paragraph of filler text:

<!--raw-typst #block(lorem(30))-->

The same trick adds a list of all figures in the document:

<!--raw-typst #outline(title: none, target: figure)-->

Page breaks work the same way, with the `typst-pagebreak` template.
