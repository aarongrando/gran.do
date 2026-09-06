require "sass-embedded"

Rails.application.config.watchable_files << Rails.root.join("app/assets/stylesheets/critical.scss").to_s

# Compile trusted repository styles once per boot/reload, never per page request.
Rails.application.config.to_prepare do
  source = Rails.root.join("app/assets/stylesheets/critical.scss").read
  Rails.application.config.x.critical_css = Sass.compile_string(
    "$development: #{Rails.env.development?};\n#{source}", style: :compressed, charset: false
  ).css.freeze
end
