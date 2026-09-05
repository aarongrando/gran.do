# Search metadata maintenance

The six public content pages have individual descriptions in their view templates. The shared layout reuses them for search, social previews, and structured data. `ApplicationHelper` defines stable canonical URLs and a linked Person/WebSite/ProfilePage or Article graph.

Keep descriptions and structured data consistent with the visible page. Do not describe former employment as current, desired titles as held positions, or company-wide metrics as personal results.

`public/sitemap.xml` lists only the six canonical content URLs. Redirects, health checks, error pages, and machine-readable indexes do not belong in that list. `public/robots.txt` advertises the sitemap and permits crawling.

No publication or modification dates are fabricated. The sitemap deliberately omits optional `lastmod` values, and structured data omits optional publication/modification dates. If verified substantive page-update dates are recorded later, add those dates individually. Never derive them from the current request time, deployment time, asset rebuild, or filesystem modification time.

Update `public/llms.txt` whenever the public profile, project names, or canonical page inventory changes. It is a concise guide to the public content, not an access policy or a promise of AI inclusion.

After deploying substantive changes, submit `https://gran.do/sitemap.xml` in Google Search Console and Bing Webmaster Tools. Inspect changed URLs and request indexing where appropriate; an accepted submission is not confirmation of indexing.
