const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const source = fs.readFileSync('app/javascript/analytics.js', 'utf8');

function browser({ id = 'G-TEST123', path = '/nexus', href, main = true } = {}) {
  let now = 0;
  const documentEvents = {};
  const windowEvents = {};
  const intervals = [];
  const loaded = [];
  const heading = { top: 100, bottom: 130 };
  const bounds = { top: 0, height: 2000 };
  const section = { id: 'cs-context', querySelector: () => ({ getBoundingClientRect: () => heading }) };
  const document = {
    currentScript: { dataset: { measurementId: id, canonicalUrl: 'https://gran.do' + path } },
    title: 'Orion and Nexus', referrer: 'https://www.linkedin.com/feed/?private=secret',
    visibilityState: 'visible', head: { appendChild: node => loaded.push(node) },
    createElement: () => ({}),
    querySelector: () => main ? { getBoundingClientRect: () => bounds, querySelectorAll: () => [section] } : null,
    addEventListener: (name, fn) => { documentEvents[name] = fn; }
  };
  const window = {
    location: new URL(href || 'https://gran.do' + path), innerHeight: 600,
    addEventListener: (name, fn) => { windowEvents[name] = fn; },
    setInterval: fn => intervals.push(fn)
  };
  const context = vm.createContext({ window, document, URL, Date, performance: { now: () => now } });
  vm.runInContext(source, context);
  const events = name => (window.dataLayer || []).map(x => [...x]).filter(x => x[0] === 'event' && x[1] === name);
  return { window, document, events, loaded, bounds, heading,
    rerun: () => vm.runInContext(source, context),
    tick: (seconds = 1) => { for (let i = 0; i < seconds; i++) { now += 1000; intervals.forEach(fn => fn()); } },
    activity: () => windowEvents.scroll(),
    visibility: state => { document.visibilityState = state; documentEvents.visibilitychange(); },
    click: (href, { demo = false, audit = false } = {}) => {
      const target = {
        closest: selector => selector === 'section[id]' ? { id: 'cs-situation' } : null,
        matches: () => demo, hasAttribute: () => audit, getAttribute: () => href
      };
      documentEvents.click({ target: { closest: () => target } });
    }
  };
}

test('loads one tag and sends one canonical page view with safe campaign attribution', () => {
  const b = browser({ href: 'https://gran.do/nexus?utm_source=linkedin&utm_medium=social&utm_campaign=featured&email=private@example.com#cs-context' });
  b.rerun();
  assert.equal(b.loaded.length, 1);
  assert.equal(b.events('page_view').length, 1);
  assert.equal(b.events('page_view')[0][2].content_id, 'nexus');
  assert.equal(b.events('page_view')[0][2].page_location, 'https://gran.do/nexus?utm_source=linkedin&utm_medium=social&utm_campaign=featured');
  const configuration = [...b.window.dataLayer[1]][2];
  assert.equal(configuration.send_page_view, false);
  assert.equal(configuration.page_referrer, 'https://www.linkedin.com/');
});

test('invalid configuration and unsupported pages never load Google', () => {
  assert.equal(browser({ id: '' }).loaded.length, 0);
  assert.equal(browser({ id: 'G-<script>' }).loaded.length, 0);
  assert.equal(browser({ path: '/private' }).loaded.length, 0);
});

test('email clicks never transmit the address, subject, or body', () => {
  const b = browser();
  b.click('mailto:private@example.com?subject=Confidential&body=secret');
  assert.equal(b.events('contact_click')[0][2].contact_method, 'email');
  assert.doesNotMatch(JSON.stringify(b.window.dataLayer), /private@example|Confidential|secret/);
});

test('internal links retain destination and section; external links drop query values', () => {
  const b = browser();
  b.click('/nexus#cs-context');
  assert.equal(b.events('portfolio_navigation')[0][2].section_id, 'cs-context');
  b.click('/resume');
  assert.equal(b.events('portfolio_navigation')[1][2].destination_id, 'resume');
  b.click('https://www.linkedin.com/in/aarongrando/?token=secret');
  assert.equal(b.events('portfolio_outbound')[0][2].link_kind, 'linkedin');
  assert.equal(b.events('portfolio_outbound')[0][2].link_url, 'https://www.linkedin.com/in/aarongrando/');
});

test('foreground time and depth are both needed for engagement; hidden time does not count', () => {
  const b = browser();
  b.tick(30);
  assert.equal(b.events('content_engaged').length, 0);
  b.bounds.top = -500;
  b.visibility('hidden');
  b.tick(40);
  assert.equal(b.events('content_engaged').length, 0);
  b.visibility('visible'); b.tick(); b.tick(5);
  assert.equal(b.events('content_engaged').length, 1);
  assert.equal(b.events('content_engaged')[0][2].active_seconds, 31);
  assert.equal(b.events('content_progress').filter(e => e[2].scroll_percent === 50).length, 1);
});

test('section exposure requires two continuous visible seconds and is deduplicated', () => {
  const b = browser();
  b.tick(2); assert.equal(b.events('section_view').length, 0);
  b.heading.top = -20; b.tick();
  b.heading.top = 100; b.tick(3);
  assert.equal(b.events('section_view').length, 1);
  b.tick(10); assert.equal(b.events('section_view').length, 1);
});

test('autoplay is not a demo open; explicit demo interaction is measured', () => {
  const b = browser({ path: '/geo' });
  b.tick(5); assert.equal(b.events('demo_open').length, 0);
  b.click(null, { demo: true, audit: true });
  assert.equal(b.events('demo_open')[0][2].demo_id, 'geo_audit_results');
});
