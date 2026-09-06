# frozen_string_literal: true

# Only content-addressed assets can safely outlive a deployment in browser caches.
class FingerprintedAssetCache
  ASSET_PATH = %r{\A/assets/(?:[^/]+/)*[^/]+-[a-f0-9]{64}\.[a-z0-9.]+\z}
  CACHE_CONTROL = "public, max-age=31536000, immutable"

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    if %w[GET HEAD].include?(env["REQUEST_METHOD"]) &&
        ASSET_PATH.match?(env["PATH_INFO"].to_s) &&
        [200, 206, 304].include?(status) && !headers.key?("set-cookie")
      headers = headers.merge("cache-control" => CACHE_CONTROL)
    end
    [status, headers, body]
  end
end
