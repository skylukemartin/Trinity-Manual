# Images

Paste or drag an image into a note and Obsidian adds it to the `attachments` folder. A plain markdown image is placed as is:

![Example chart](</docs/attachments/Progress Chart.png>)

# Figures

To get a numbered caption, wrap the image in a figure with the `figure-with-caption` template (`Alt + I`). Give it an `id` to refer to it, like [@progress-chart]:

<figure id="progress-chart">
<img src="docs/attachments/Progress Chart.png" alt="Bar chart of pages written per week" width="70%">
<figcaption>
Example chart with a caption, scaled to 70% of the page width.
</figcaption>
</figure>

# Web Images

Images from the web work too, both as `![alt](https://…)` and inside figures like [@earth]. When you build the PDF, `toolbox.sh` downloads them once into a hidden `.cache` folder, so the PDF still builds offline afterwards. Web PDFs work the same way (the PDF shows their first page).

<figure id="earth">
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/The_Earth_seen_from_Apollo_17.jpg/960px-The_Earth_seen_from_Apollo_17.jpg" alt="The Earth seen from Apollo 17" width="45%">
<figcaption>
The Earth seen from Apollo 17 (NASA, public domain), downloaded from Wikimedia Commons when the PDF is built.
</figcaption>
</figure>

To keep a permanent copy in the vault instead, run `./toolbox.sh localize`. It saves each web image in the `attachments` folder next to the note and changes the link to point there.

# Mermaid Diagrams

Mermaid code blocks are rendered automatically, like [@pipeline]. Add `%% caption: …` and `%% id: …` lines at the top of the block to make it a numbered figure you can refer to; Obsidian ignores those lines.

# Tables

Markdown tables, including column alignment:

| Feature | Markdown | Supported |
| :-- | :-- | :-: |
| Callouts | `> [!note]` | Yes |
| Highlights | `==text==` | Yes |
| Maths | `$x^2$` | Yes |
| Wikilinks | `[[Note]]` | Yes |
| Dataview | ` ```dataview ` | No |
