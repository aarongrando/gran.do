# gran.do share card

The production image is `app/assets/images/aaron-grando-og.png`, referenced by
the shared Open Graph and Twitter metadata. Render it on macOS from the repository root:

```sh
swift scripts/render-share-card.swift
```

The renderer embeds actual Libre Franklin glyphs from the same Google Fonts
family used by the site: Regular 400, Medium 500, and SemiBold 600. It preserves
the card's 1200 × 630 dimensions, colors, and main text layout. The top label
has been removed, the top-left mark uses the site's `shield.svg` directly,
and the pink rule runs along the full bottom edge. The footer reads
"VISIT GRAN.DO →". The font files are bundled with their SIL Open Font License
in `fonts/` so regeneration
does not depend on installed fonts or a network connection.

Font source: https://fonts.googleapis.com/css2?family=Libre+Franklin:wght@400;500;600&display=swap
