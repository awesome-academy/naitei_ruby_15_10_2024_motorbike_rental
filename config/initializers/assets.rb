Rails.application.config.assets.version = "1.0"
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "stylesheets")
Rails.application.config.assets.precompile += %w[bootstrap.min.js popper.js]
