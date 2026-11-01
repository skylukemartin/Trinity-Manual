Standard markdown works as you'd expect: headings, **bold**, *italic*, ~~strikethrough~~, lists, tables, `code`, code blocks with syntax highlighting, links, footnotes and `<sub>`/`<sup>`. Rendering is done by the [cmarker](https://typst.app/universe/package/cmarker) package. [@writing-your-manual] shows each of the following in use.

| You write | You get in the PDF |
| --- | --- |
| `> [!note] Title` | A callout box (see [@callouts]) |
| `![[Chapter]]` or `![](</docs/Chapter.md>)` | The whole note, with a heading named after the file |
| `![[Chapter\|My title]]` | The same, with `My title` as the heading |
| `![[Chapter#Heading]]` | Just that section |
| `![[pic.png\|300]]` | The image, 300 pixels wide |
| `![[handout.pdf#page=2]]` | That page of the PDF, as an image |
| `[[Note]]`, `[[Note#Heading]]` | A clickable link if the target is in the PDF, otherwise plain text |
| `text ^block-id` | A target for `[[#^block-id]]` links |
| Text between two `%%` | Nothing: comments only show in Obsidian's editor |
| `^[inline footnote]` | A footnote |
| `- [ ] task`, `- [x] done` | Checkboxes |
| `==text==` | Highlighted text |
| `$E = mc^2$`, `$$ … $$` | Maths, inline or as a block |
| `[@CitationKey]` | A citation like `[1]` and an entry in the reference list |
| `[@some-heading]` | A cross-reference like "Section 2.1" |
| `<figure id="my-chart">` | A figure you can refer to with `[@my-chart]` |
| `![alt](https://…)` | The web image, downloaded when you build |
| A Mermaid code block | The rendered diagram |
| `<!--typst-begin-exclude-->` | Hides everything up to `<!--typst-end-exclude-->` from the PDF |
| `<!--raw-typst #pagebreak()-->` | Runs Typst code directly |
| Front matter (properties), `#tag` | Left out, and plain text |

A cross-reference label is the heading in lowercase, with spaces turned into dashes and punctuation dropped: `Results & Discussion` becomes `[@results--discussion]`. A second heading with the same text gets `-1` added.

These aren't converted: plugin-only syntax such as Dataview queries (it stays a code block), and embeds of audio, video, canvases and web pages (the file name or a link is shown instead).
