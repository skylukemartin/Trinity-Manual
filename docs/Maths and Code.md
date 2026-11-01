# Maths

Write LaTeX maths the same way as in Obsidian. Inline maths goes between single dollar signs, like $E = mc^2$ or $\sum_{i=1}^{n} i = \frac{n(n+1)}{2}$. Block maths goes between double dollar signs:

$$
\int_0^\infty e^{-x^2} \, dx = \frac{\sqrt{\pi}}{2}
$$

$$
\begin{pmatrix} a & b \\ c & d \end{pmatrix}
\begin{pmatrix} x \\ y \end{pmatrix}
=
\begin{pmatrix} ax + by \\ cx + dy \end{pmatrix}
$$

# Code

Code blocks keep their syntax highlighting when you name the language:

```python
def word_count(path: str) -> int:
    with open(path, encoding="utf-8") as file:
        return len(file.read().split())

print(word_count("main.md"))
```

```bash
./toolbox.sh build
```
