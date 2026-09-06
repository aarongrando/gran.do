/* Portfolio measurement. No form values, email addresses, or arbitrary query strings. */
(() => {
  "use strict";
  const script = document.currentScript;
  const id = script && script.dataset.measurementId;
  if (!/^G-[A-Z0-9]+$/.test(id || "") || window.grandoAnalyticsLoaded) return;
  const pages = {
    "/": ["home", "profile"], "/resume": ["resume", "resume"],
    "/nexus": ["nexus", "case_study"], "/geo": ["geo", "case_study"],
    "/launchpad": ["launchpad", "case_study"], "/mod-heat": ["mod_heat", "case_study"]
  };
  const canonical = new URL(script.dataset.canonicalUrl);
  const page = pages[canonical.pathname];
  if (!page) return;
  window.grandoAnalyticsLoaded = true;

  // Keep campaign attribution, but exclude unrelated URL parameters and fragments.
  const location = new URL(canonical);
  const incoming = new URL(window.location.href);
  ["utm_source", "utm_medium", "utm_campaign", "utm_content", "utm_term", "utm_id"].forEach(key => {
    const value = incoming.searchParams.get(key);
    if (value && value.length <= 100 && !/@|%40/i.test(value)) location.searchParams.set(key, value);
  });
  let referrer = "";
  try { referrer = new URL(document.referrer).origin + "/"; } catch (_) { /* Direct visit. */ }
  const defaults = { content_id: page[0], content_group: page[1], page_location: location.href };
  window.dataLayer = window.dataLayer || [];
  window.gtag = window.gtag || function () { window.dataLayer.push(arguments); };
  window.gtag("js", new Date());
  window.gtag("config", id, {
    ...defaults, page_referrer: referrer, send_page_view: false,
    allow_google_signals: false, allow_ad_personalization_signals: false
  });
  const send = (name, params = {}) => window.gtag("event", name, { ...defaults, ...params, send_to: id });
  send("page_view", { page_title: document.title });
  const google = document.createElement("script");
  google.async = true;
  google.src = "https://www.googletagmanager.com/gtag/js?id=" + encodeURIComponent(id);
  document.head.appendChild(google);

  const main = document.querySelector("#container");
  if (!main) return;
  const sent = new Set();
  const once = (key, name, params) => {
    if (sent.has(key)) return;
    sent.add(key);
    send(name, params);
  };
  const placement = element => {
    const section = element.closest("section[id]");
    if (section) return section.id;
    if (element.closest("nav")) return "navigation";
    if (element.closest("footer, .case-footer, .case-back-home")) return "footer";
    return "page";
  };
  document.addEventListener("click", event => {
    const target = event.target.closest && event.target.closest("a[href], [data-geo-pip-trigger]");
    if (!target) return;
    if (target.matches("[data-geo-pip-trigger]")) {
      send("demo_open", {
        demo_id: target.hasAttribute("data-geo-pip-audit-trigger") ? "geo_audit_results" : "geo_landing",
        link_placement: placement(target)
      });
      return;
    }
    const url = new URL(target.getAttribute("href"), window.location.href);
    const common = { link_placement: placement(target) };
    if (url.protocol === "mailto:" || url.protocol === "tel:") {
      send("contact_click", { ...common, contact_method: url.protocol === "mailto:" ? "email" : "phone" });
    } else if (["http:", "https:"].includes(url.protocol)) {
      const internal = [window.location.hostname, "gran.do", "www.gran.do"].includes(url.hostname);
      if (internal) {
        const destination = pages[url.pathname.replace(/\/$/, "") || "/"];
        if (!destination) return;
        const section = /^#[a-z0-9-]+$/i.test(url.hash) ? url.hash.slice(1) : "";
        send("portfolio_navigation", { ...common, destination_id: destination[0], section_id: section });
      } else {
        const kind = /(^|\.)linkedin\.com$/.test(url.hostname) ? "linkedin"
          : /podcast|rootedinrevenue/.test(url.href) ? "podcast" : "external";
        send("portfolio_outbound", { ...common, link_kind: kind, link_domain: url.hostname,
          link_url: url.origin + url.pathname });
      }
    }
  }, { capture: true });

  // Foreground reading time pauses in hidden tabs and after a minute without activity.
  let lastActivity = performance.now();
  let lastTick = lastActivity;
  let activeSeconds = 0;
  let maxDepth = 0;
  const sections = [...main.querySelectorAll("section[id]")].filter(section => section.querySelector("h1, h2, h3"));
  const sectionTimers = new Map();
  const checkReading = () => {
    const now = performance.now();
    const elapsed = Math.min((now - lastTick) / 1000, 5);
    lastTick = now;
    if (document.visibilityState !== "visible" || now - lastActivity > 60000) {
      sectionTimers.clear();
      return;
    }
    activeSeconds += elapsed;
    const bounds = main.getBoundingClientRect();
    if (bounds.height > 0) {
      const depth = Math.max(0, Math.min(100, (window.innerHeight - bounds.top) / bounds.height * 100));
      maxDepth = Math.max(maxDepth, depth);
      [25, 50, 75, 90].forEach(percent => {
        if (depth >= percent) once("depth_" + percent, "content_progress", { scroll_percent: percent });
      });
    }
    if (activeSeconds >= 30 && maxDepth >= 50) {
      once("engaged", "content_engaged", { active_seconds: Math.floor(activeSeconds), scroll_percent: Math.floor(maxDepth) });
    }
    sections.forEach(section => {
      const heading = section.querySelector("h1, h2, h3").getBoundingClientRect();
      if (heading.top >= 0 && heading.bottom <= window.innerHeight) {
        if (!sectionTimers.has(section.id)) sectionTimers.set(section.id, now);
        if (now - sectionTimers.get(section.id) >= 2000) {
          once("section_" + section.id, "section_view", { section_id: section.id });
        }
      } else sectionTimers.delete(section.id);
    });
  };
  ["scroll", "pointerdown", "keydown", "touchstart"].forEach(name => {
    window.addEventListener(name, () => { lastActivity = performance.now(); }, { passive: true });
  });
  document.addEventListener("visibilitychange", () => {
    lastTick = performance.now();
    sectionTimers.clear();
    if (document.visibilityState === "visible") lastActivity = lastTick;
  });
  window.setInterval(checkReading, 1000);
})();
