require "minitest/autorun"
require_relative "../lib/fingerprinted_asset_cache"

class FingerprintedAssetCacheTest < Minitest::Test
  ASSET = "/assets/libre-franklin-#{'a' * 64}.woff2"

  def response(path: ASSET, method: "GET", status: 200, headers: {})
    app = ->(_env) { [status, headers, ["asset"]] }
    FingerprintedAssetCache.new(app).call("PATH_INFO" => path, "REQUEST_METHOD" => method)
  end

  def test_caches_successful_asset_downloads_and_revalidation
    %w[GET HEAD].product([200, 206, 304]).each do |method, status|
      result = response(method: method, status: status, headers: { "etag" => "abc" })
      assert_equal status, result[0]
      assert_equal FingerprintedAssetCache::CACHE_CONTROL, result[1]["cache-control"]
      assert_equal "abc", result[1]["etag"]
    end
  end

  def test_does_not_cache_html_unversioned_files_errors_or_cookie_responses
    ["/", "/resume", "/robots.txt", "/sitemap.xml", "/preflight.css",
      "/assets/analytics.js", "/assets/font-shortdigest.woff2"].each do |path|
      refute response(path: path)[1].key?("cache-control"), path
    end
    [301, 302, 403, 404, 500].each { |status| refute response(status: status)[1].key?("cache-control") }
    refute response(method: "POST")[1].key?("cache-control")
    headers = { "set-cookie" => "session=test", "cache-control" => "private" }
    assert_equal "private", response(headers: headers)[1]["cache-control"]
  end
end
