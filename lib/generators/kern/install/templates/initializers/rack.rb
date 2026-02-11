# Remove 'x-runtime' header
Rails.application.config.middleware.delete(Rack::Runtime)

if Rails.env.production?
  Rails.application.config.middleware.use Rack::Deflater
end

if Rails.env.development?
  Rails.application.config.middleware.insert_before(
    ActionDispatch::Static,
    Mata,
    watch: %w[app/views app/assets],
    skip: %w[app/assets/build]
  )
end
