# Run with RAILS_ENV=production bin/rails runner test/performance_rendering_check.rb
require "nokogiri"

def verify(condition, message)
  raise message unless condition
end

session = ActionDispatch::Integration::Session.new(Rails.application)
session.host! "gran.do"
session.https!
ENV["GA4_MEASUREMENT_ID"] = "G-TEST123"
paths = %w[/ /resume /nexus /geo /launchpad /mod-heat]
font_url = nil
paths.each do |path|
  session.get(path)
  verify(session.response.status == 200, "#{path}: render failed")
  doc = Nokogiri::HTML(session.response.body)
  main = doc.css("main")
  verify(main.length == 1 && main.first.at_css("h1"), "#{path}: missing main content")
  verify(doc.css("main .case-site-header, main .case-site-footer").empty?, "#{path}: site chrome inside main")
  verify(doc.css('link[rel="stylesheet"]').empty?, "#{path}: blocking stylesheet")
  verify(!session.response.body.include?("fonts.googleapis.com"), "#{path}: external font stylesheet")
  preload = doc.css('link[rel="preload"][as="font"]')
  verify(preload.length == 1 && preload.first.key?("crossorigin"), "#{path}: font preload missing")
  font_url = preload.first["href"]
  verify(font_url.match?(%r{\A/assets/libre-franklin-latin-variable-[a-f0-9]{64}\.woff2\z}), "#{path}: font not fingerprinted")
  css = doc.css("style").map(&:text).join
  verify(!css.include?("\uFEFF"), "#{path}: inline CSS has an embedded BOM")
  verify(css.include?("box-sizing:border-box"), "#{path}: reset missing")
  verify(css.include?("font-weight:300 600") && css.include?("font-display:swap"), "#{path}: variable font missing")
  verify(css.include?(font_url), "#{path}: preload and font face disagree")
  tags = doc.css("script[data-measurement-id]")
  verify(tags.length == 1 && tags.first["data-canonical-url"] == "https://gran.do#{path}", "#{path}: analytics changed")
  verify(tags.first.key?("defer"), "#{path}: analytics is blocking")
end

session.get(font_url)
verify(session.response.status == 200 && session.response.body.start_with?("wOF2"), "Compiled font is not served")
verify(session.response.headers["cache-control"] == FingerprintedAssetCache::CACHE_CONTROL, "Asset cache middleware missing")
%w[/ /robots.txt /sitemap.xml /preflight.css].each do |path|
  session.get(path)
  verify(!session.response.headers["cache-control"].to_s.include?("immutable"), "#{path}: unversioned content cached indefinitely")
end
puts "Six pages passed: main landmarks, local font preload, inline reset, analytics, and production asset caching."
