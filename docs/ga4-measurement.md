# gran.do measurement plan

## Activation

Activated September 6, 2026 under the existing site owner's Analytics account.
The property is named **gran.do**, with a **gran.do website** web stream.
The reporting timezone is America/New_York and the currency is USD.
Account, property, and stream identifiers are kept out of this public repository;
find them in the signed-in Analytics account. The production measurement ID is
configured in Heroku.

Heroku release v177 activates the tag through the production environment variable.
Google's installation test detected the live tag successfully. All six public
pages were checked for one analytics script with the correct ID and canonical URL.
GA4 Realtime confirmed `page_view`, `section_view`, `content_progress`, and
`portfolio_navigation` from a live Mod Heat to Nexus test. The navigation event
included `content_id`, `content_group`, and `destination_id`; the destination
value was verified as `nexus`. This test used `utm_source=qa`,
`utm_medium=validation`, and `utm_campaign=ga4_setup`. No contact click was
triggered during live validation, so the new contact key event has no test count.

Set the production environment variable `GA4_MEASUREMENT_ID` to the gran.do web
stream's `G-...` ID. The site does not load Google Analytics in development or
when the ID is absent/invalid. The shared layout covers all six canonical pages.
One explicit `page_view` is sent per full page load, with automatic config page
views disabled. This is a conventional Rails site, not a single-page app.

## Questions and events

| Question | Event | Definition |
| --- | --- | --- |
| Which content attracts visitors? | `page_view` | Canonical page; `content_id` identifies home, resume, nexus, geo, launchpad, or mod_heat. Built-in `content_group` separates profile, resume, and case_study. |
| How far do visitors get? | `content_progress` | Once at each 25%, 50%, 75%, 90% viewport depth within the main content. It measures exposure, not proof of reading. |
| Which visits show sustained interest? | `content_engaged` | Once after 30 foreground seconds and at least 50% content depth. Time pauses in hidden tabs and after 60 seconds without input. |
| Which chapters get seen? | `section_view` | A section heading stays fully visible for two continuous seconds; once per section per page load. |
| What do visitors read next? | `portfolio_navigation` | Internal link click with destination page, target section, and link placement. Includes resume clicks and the Mod Heat to Brand Agents link. |
| What leads toward a conversation? | `contact_click` | Email/phone link click. Measures contact intent, not a sent email or a qualified lead. |
| Do people inspect outside evidence? | `portfolio_outbound` | LinkedIn, podcast, or other external link with destination domain/path and placement. |
| Do visitors choose to open a demo? | `demo_open` | Explicit click on a GEO demo trigger. Autoplay and looping GIFs do not count as intentional demo viewing. |

Every custom event includes `content_id`, `content_group`, and `page_location`.
Section and placement values use stable IDs from the HTML rather than heading copy.
Reading events reset on a new page load, so report users/sessions as well as counts.

## GA4 property configuration

The following event-scoped custom dimensions were registered on September 6, 2026:

- Content ID: `content_id`
- Section ID: `section_id`
- Destination ID: `destination_id`
- Link placement: `link_placement`
- Link kind: `link_kind`
- Demo ID: `demo_id`
- Scroll milestone: `scroll_percent`
- Contact method: `contact_method`

`content_group`, `link_domain`, and `link_url` use GA4's existing parameters.
`contact_click` is registered as a key event, counted once per session, with no
default monetary value. Google's default `purchase` key event remains unused.
Keep reading, demo, LinkedIn, and resume clicks as secondary diagnostic signals so routine browsing
does not inflate the apparent number of inquiries.

Enhanced measurement can remain enabled for its standard events. Its `scroll`
event is the standard 90% threshold, distinct from `content_progress`. Its `click`
events can coexist with `portfolio_outbound`; do not sum both as separate clicks.
The portfolio has custom HTML5 demos, so enhanced YouTube video tracking does not
replace `demo_open`. No video completion claim is made for the autoplay loops.

## Three useful reports

The default Reports snapshot is set to Google's User behavior template.
The following additional report configurations are recommended:

1. **Content performance:** Pages and screens, grouped by Content group and
   page path. Compare users, views, average engagement time, and contact key
   events. Use a Free-form exploration with Content ID and Event name to compare
   `content_engaged`, `content_progress`, and `section_view` by case study.
2. **Portfolio journey:** An open session funnel from case-study `page_view`
   to `content_engaged`, then a `portfolio_navigation` event with Destination ID
   `resume`, then `contact_click`. Also inspect direct contact paths because
   a visitor need not read the resume before contacting you.
3. **Acquisition quality:** Session source/medium and Session campaign against
   engaged sessions and `contact_click` session key-event rate. Compare LinkedIn
   Featured, posts, organic search, and referring sites. Start with 28-day views
   and show visitor counts beside rates to make small samples apparent.

## LinkedIn attribution

Use tagged external entry links; keep internal site links free of UTMs:

- https://gran.do/nexus?utm_source=linkedin&utm_medium=social&utm_campaign=profile_featured&utm_content=nexus
- https://gran.do/geo?utm_source=linkedin&utm_medium=social&utm_campaign=profile_featured&utm_content=geo
- https://gran.do/launchpad?utm_source=linkedin&utm_medium=social&utm_campaign=profile_featured&utm_content=launchpad

For feed posts use `utm_campaign=portfolio_posts` and a short `utm_content` value
specific to the post. Six standard UTM fields are retained; arbitrary page query
strings and fragments are excluded. Referrers are reduced to their origin, and
outbound link query strings are excluded. Email addresses, message bodies, form
values, and visitor identity are never added as custom event parameters.

## Validation and operational notes

Run `node --test test/javascript/analytics.test.cjs` for behavior checks. Validate
the deployed tag in GA4 Realtime and DebugView before interpreting reports. Create
the custom definitions before gathering the data you want to analyze; normal
report processing is delayed. This implementation does not bypass ad blockers or
an existing consent manager. If one is added, connect its consent state to the
Google tag before activating measurement. Google advertising signals and ad
personalization signals are disabled in this implementation.

Sources: [Google event setup](https://developers.google.com/analytics/devguides/collection/ga4/events),
[enhanced measurement](https://support.google.com/analytics/answer/9216061),
[custom dimensions](https://support.google.com/analytics/answer/14240153).
