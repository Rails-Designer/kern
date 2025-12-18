# Kern

Rails engine that handles the SaaS foundation: authentication, team invitations, subscription/billing, and common partials. Skip the boilerplate and start shipping the actual product.


<table>
  <tr>
    <td>
      <a href="https://raw.githubusercontent.com/Rails-Designer/kern/HEAD/.github/kern__auth.jpg" target="_blank">
        <img src="https://raw.githubusercontent.com/Rails-Designer/kern/HEAD/.github/kern__auth.jpg" alt="Authentication" width="400">
      </a>
    </td>
    <td>
      <a href="https://raw.githubusercontent.com/Rails-Designer/kern/HEAD/.github/kern__dashboard.jpg" target="_blank">
        <img src="https://raw.githubusercontent.com/Rails-Designer/kern/HEAD/.github/kern__dashboard.jpg" alt="Dashboard" width="400">
      </a>
    </td>
    <td>
      <a href="https://raw.githubusercontent.com/Rails-Designer/kern/HEAD/.github/kern__subscriptions.jpg" target="_blank">
        <img src="https://raw.githubusercontent.com/Rails-Designer/kern/HEAD/.github/kern__subscriptions.jpg" alt="Subscriptions" width="400">
      </a>
    </td>
  </tr>
</table>

<a href="https://railsdesigner.com/" target="_blank">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/Rails-Designer/kern/HEAD/.github/logo-dark.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/Rails-Designer/kern/HEAD/.github/logo-light.svg">
    <img alt="Rails Designer" src="https://raw.githubusercontent.com/Rails-Designer/kern/HEAD/.github/logo-light.svg" width="240" style="max-width: 100%;">
  </picture>
</a>



**Sponsored By [Rails Designer](https://railsdesigner.com/)**


> **kern** (Dutch/German, noun) — core, nucleus, foundation. The essential element at the center of something; the foundational part upon which everything else is built.


## Quickstart

```bash
bundle add kern
rails generate kern:install
rails db:migrate
```


## Installation

Add Kern to your Gemfile:
```bash
bundle add kern
```

Run the install generator:
```bash
rails generate kern:install
```

Run migrations:
```bash
rails db:migrate
```

Set your root route in `config/routes.rb`:
```ruby
root "dashboard#show"
```

## Usage

Kern works out of the box after installation. All features are available immediately.


### Generators

If you want to customize any available feature (e.g. sign up, log in, etc.), you can run: `bin/rails generate kern:feature`.

Append `--help` to see the generator's help.


## Included

Kern has all the foundational features for a SaaS built-in, so you can skip the boilerplate and ship your actual product.

> [!NOTE]
> Not all features listed below are part of Kern just yet.


### Authentication

Built on Rails' authentication generator.


### Sign up

Create an account for your app using email address and password.


### User settings

Update user's email and password.


### Multi-tenancy

By default a `Workspace` record is created upon sign up. Each `User` is associated to it using a `Member` join table. Each `Member` can have multiple `Role`'s you can use to authorize if they should have access (`Current.member.has_role? :owner`).


### Billing & subscriptions using Stripe

Following [Rails Designer's Stripe Billing set up](https://railsdesigner.com/saas/billing-with-stripe/), offer subscriptions right away. Just update `config/configurations/plans.yml` and add your Stripe API key and Signing secret to your credentials.


### Team invitations

Add more users to your `Workspace`, update roles or remove them again.


### Form builder

Pulled from [Rails Designer's Components](https://railsdesigner.com/components/), the included Form Builder lets you quicly build beautiful forms. Including a magic `input` helper that works like this:

```erb
<%= form_with url: session_path do |form| %>
  <%= form.input :email_address, required: true %>

  <%= form.input :password, required: true %>
<% end %>
```


### Component helper

Some basic components are included like:

- container; keep all your app's content in check
- heading; have consistent headings for each screen
- enhanced dialog element (works with Turbo Frames and, includes `centered` or a `drawer` variants)
- flash messages (notifiy your users from the bottom-right)

These are built using vanilla Rails, as [described in this article]() (`component` helper included).


### Application/dashboard layout

A clean, minimal (application) layout is included with a (collapsible sidebar to the left)


### Turbo Stream `notify` helper

When using Turbo Stream responses, use `turbo_stream.notify "Updated"` to notifiy user on a successful request.


## Rails Icons support

The application/dashboard layout and the Form Builder have optional support for [Rails Icons](https://github.com/Rails-Desiger/rails_icons). Run `bin/rails generate rails_icons:install --libraries=phosphor` to enable them.


### Sluggable concern

If you do not want to expose the record's primary key, use the `Sluggable` concern. Include it in the model, make sure it has a (unique) `slug` column, and look up records using `ModelName.sluggable.find(params[:id])`.


### Configuration

Little syntactic sugar on top of Rails' `config_for` as explained [in this article](https://railsdesigner.com/saas/configuration/). Keep configuration together in, e.g. `config/configuration/urls.yml` and call each value like `Config::Urls.docs`.


## Contributing

This project uses [Standard](https://github.com/testdouble/standard) for formatting Ruby code. Minitest for testing. Please run `rake` before submitting pull requests.


## License

Kern is released under the [MIT License](https://opensource.org/licenses/MIT).
