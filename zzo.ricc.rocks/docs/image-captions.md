# How to Add Image Captions in ZZO Theme

## ✅ Preferred Method: Hugo Figure Shortcode

Use the Hugo `figure` shortcode with the `narrow-caption` class:

```markdown
{{< figure 
    src="your-image.png" 
    alt="Descriptive alt text" 
    caption="**Fig X**: Your caption text here" 
    class="narrow-caption"
>}}
```

### Features:
- ✅ Clean, semantic markup
- ✅ DRY - styling controlled by CSS
- ✅ Caption is 80% width, centered
- ✅ Italic, gray text (#a4e7f0 or #666)
- ✅ Slightly smaller font (0.9em)

### Optional Parameters:
- `width="50%"` - Control image width
- `title="Title"` - Add a bold title above caption
- `link="https://..."` - Make image clickable

## ❌ Avoid: Inline HTML Figures

Don't use inline HTML with styles like this:

```html
<!-- DON'T DO THIS -->
<figure style="margin: 1.5rem auto; text-align: center;">
  <img src="image.png" alt="..." style="max-width: 100%; height: auto;">
  <figcaption style="width: 80%; margin: 0.5rem auto 0; font-style: italic; color: #666; font-size: 0.9em;">
    Caption text
  </figcaption>
</figure>
```

**Why avoid?**
- ❌ Not DRY - styles repeated everywhere
- ❌ Hard to maintain
- ❌ Ugly in markdown source
- ❌ Can't change styling globally

## CSS Implementation

The `narrow-caption` class is defined in `/assets/sass/custom.scss`:

```scss
.narrow-caption figcaption {
    width: 80%;
    margin: 0.5rem auto 0;
    text-align: center;
    font-style: italic;
    color: #666;  /* or #a4e7f0 for light blue */
    font-size: 0.9em;
}

.narrow-caption {
    margin: 1.5rem auto;
    text-align: center;
}
```

## Technical Notes

### ZZO Theme Fix
The ZZO theme had a bug with Hugo 0.150.1 using deprecated `resources.ToCSS`. 

**Solution**: Created `/layouts/partials/head/styles.html` override that uses `css.Sass` instead:

```go
{{ $custom_style := $custom_template | css.Sass | resources.Minify }}
```

This keeps the ZZO theme submodule vanilla while fixing the deprecation issue.

### Configuration
Enable custom CSS in `/config/_default/params.yaml`:

```yaml
custom_css: ["sass/custom.scss"]
```

## Examples

### Simple Caption
```markdown
{{< figure 
    src="screenshot.png" 
    caption="The application dashboard" 
    class="narrow-caption"
>}}
```

### With Figure Number
```markdown
{{< figure 
    src="diagram.png" 
    caption="**Fig 1**: System architecture overview" 
    class="narrow-caption"
>}}
```

### With Width Control
```markdown
{{< figure 
    src="logo.png" 
    caption="Company logo" 
    width="50%"
    class="narrow-caption"
>}}
```

---

**Last Updated**: 2026-01-15  
**Author**: Riccardo (with help from Antigravity 🚀)
