Zotero keeps track of your sources and writes them to `citations/references.bib`, which the PDF build reads.

# One-Time Setup

1. Install [Zotero](https://www.zotero.org/download/) and its browser connector.
2. Install the [Better BibTeX](https://retorque.re/zotero-better-bibtex/installation/) add-on for Zotero.
3. In Zotero, open **Edit → Settings → Better BibTeX → Export → BibTeX** (on macOS: **Zotero → Settings**):
   - Untick **Export unicode as plain-text latex commands**.
   - Set **Add URLs to BibTeX export** to **in the 'url' field**.
4. Click **File → Import… → A file**, select `citations/references.bib` in the vault, then **Next → Finish**. This creates a new collection.
5. Right-click that collection and choose **Export Collection…**. Pick the format **Better BibTeX**, tick **Keep updated** and click **OK**. Save over `citations/references.bib` in the vault.

From now on, everything you add to that collection is written to `references.bib` automatically.

# Adding and Citing Sources

To add a source, open the web page or paper, click the Zotero browser extension and save it into **that collection**.

To cite it in Obsidian, press `Ctrl + P` (`Cmd + P` on macOS), type **insert markdown citation** and pick the source. This inserts something like `[@ObsidianSharpenYour]`, which becomes `[1]` in the PDF, with the source listed under **References**.

> [!tip] Working in a group?
> Commit `citations/references.bib` to git so everyone has the same sources.
