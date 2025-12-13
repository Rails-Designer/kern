# Configuration

Load all YAML files from `config/configurations/` into `Config` constants.


## Usage

Each YAML file in this directory becomes a `Config` constant. For example:
- `config/configurations/urls.yml` becomes `Config::Urls`
- `config/configurations/features.yml` becomes `Config::Features`

Access values using dot notation:
```ruby
Config::Urls.app
Config::Urls.site
```


## Environment variables

You can override any configuration value using environment variables. For example, in `urls.yml`:
```yaml
shared:
  app: <%= ENV.fetch("URLS_APP", "http://localhost:3000") %>
  site: <%= ENV.fetch("URLS_SITE", "https://example.com") %>
```

The `URLS_` prefix is a recommended convention but not required. Use any naming convention that works for your application.


## How it works

Under the hood, this uses `Rails.application.config_for` which automatically handles environment-specific configurations and ERB processing.
