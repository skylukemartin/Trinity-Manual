| Problem | Fix |
| --- | --- |
| `typst: command not found` | Close and reopen the terminal after installing. If that doesn't help, reinstall Typst (see [@installing-the-tools]) and check `typst --version`. |
| `./toolbox.sh: Permission denied` | Run it with bash instead, for example `bash toolbox.sh build`. |
| `$'\r': command not found` or `bad interpreter` (Windows) | The script got Windows line endings. Back up or commit your work, then run `git rm -rq --cached . && git reset --hard` in the vault. |
| `.sh` files open in Notepad (Windows) | Don't double-click them. Run them from **Git Bash** (see [@opening-a-terminal]). |
| `failed to download package` | The first build needs internet. Check your connection or school/work firewall and try again. |
| `file not found` for an embed or image | The link must start with `/` and match the file's path and name exactly, including capital letters. Drag the file into the note again to fix the link. |
| `unknown font family` warning | You ran `typst` directly. Use `./toolbox.sh build`, which loads `.fonts/`. |
| A citation shows as `@Key` or `key not found` | The source isn't in `citations/references.bib`. Check Zotero's **Keep updated** export (see [@citations-with-zotero]). |
| `could not download …` during setup | Check your connection. A firewall must allow `github.com`. Then run `./toolbox.sh setup` again. |
| `could not render Mermaid diagram …` | Check your connection (a firewall must allow `mermaid.ink`) and check the diagram on [mermaid.live](https://mermaid.live). The PDF still builds, with the code instead. |
| Plugins or theme missing in Obsidian | Turn on community plugins in **Settings → Community plugins** and restart Obsidian. If they're still missing, close Obsidian and run `./toolbox.sh setup` again. |
| Something is in Obsidian but not in the PDF | Check that it isn't inside a `typst-begin-exclude` block, and that it isn't syntax that isn't converted (see [@syntax-quick-reference]). |
| The PDF doesn't update while watching | Check that the `./toolbox.sh watch` terminal is still open and shows no error. Some viewers, such as Adobe Reader, lock the file or don't reload: try another viewer. |
