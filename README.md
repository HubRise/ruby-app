![](https://github.com/hubrise/ruby-app/workflows/spec/badge.svg)


## Installation

Refer to https://github.com/HubRise/ruby-app/blob/v1/spec/dummy/ for examples

1. Install the gem (`gem "hubrise_app", git: "https://github.com/HubRise/ruby-app.git"` for now)
2. Add `hubrise_app/config.yaml`
3. Copy migrations with `rake hubrise_app:install:migrations` and migrate
4. Mount engine routes with `mount HubriseApp::Engine => "/"`
5. Define `hubrise_open_path` rails route (e.g. `get :hubrise_open, to: "application#open"`)
6. Inherit your `ApplicationController` and apply fundamental `before_actions`:
```
class ApplicationController < HubriseApp::ApplicationController
  before_action :ensure_authenticated!
  before_action :ensure_app_instance_found!

  def open
    render plain: current_user.full_name + " | " + current_app_instance.hr_id
  end
end
```

## Intro

This gem provides a framework for a Hubrise App with a Resource Based Access.
This means that each Hubrise User will be able to create a connection (App Instance) to multiple Accounts and Locations. And this connection will be shared with any other Hubrise User that has access to the same reseources on Hubrise side automatically.

### Note
The main app's scopes (`account_scope` and `location_scope`) must not include any kind of `profile` access. Otherwise it will make no sense to share the connection with other users.

## Documentation

The framework is based on 3 different Oauth Workflows: `Connect Workflow`, `Login Workflow` and `Authorize Workflow`.
And 4 main entities: `User`, `AppInstance`, `Account`, `Location`.

### Connect Workflow
Usualy this workflow gets triggered by clicking the "Install" button from the Hubrise App Market.
It requests the main connection with the `location_scope` or `account_scope` (which are specified by developer during app creation).

Once it has been completed a new `AppInstance` gets persisted in the DB.
`Account` and `Location` instances are being created automaticaly depending on the scope and populated from the api.
Note: this workflow is not responsible for creating a `User` record, it **only** happens in `Login Workflow`.

- If there's a user already logged in - the new app instance gets associated with this user automatically. And the user gets redirected to `hubrise_open_path` with a `app_instance_id` params.

- If there's no user logged in - the `Login Workflow` is triggered right away by redirecting to login oauth url.


Code: https://github.com/HubRise/ruby-app/blob/v1/app/controllers/hubrise_app/oauth_controller/action_connect_callback.rb

### Login Workflow
Usualy this workflow gets triggered after `Connect Workflow` or by the `ensure_authenticated!` filter for any anon access.
It requests `profile_with_email` scope.
Once completed - a new `User` gets persisted in the DB with a profile `access_token` and redirected to `hubrise_open_path`.


### Authorize Workflow
This workflow gets triggered by `ensure_app_instance_found!` whenever a logged in user does not have access (or it is expired) to `AppInstance` specified by `app_instance_id` param.
If `app_instance_id` is not specified - its considered to be a broken request and a fatal error message is shown.

Note: when a user opens already installed app by clicking the button from Hubrise Manager - it opens the `open_url` (specified by developer during app creation) with a `app_instance_id` param.

This `app_instance_id` param is carried on from request to request using `default_url_options`: https://github.com/HubRise/ruby-app/blob/v1/app/controllers/hubrise_app/application_controller/app_instance_methods.rb#L26


A use case:
1. UserA installs an app for Account1 - an `AppInstance` with `hr_id=abcd` being created
2. UserA adds UserB as a manager to Account1 (via Hubrise Manager user roles table)
3. UserB opens the installed app by clicking the button in the dashboard. It redirects to `open_url` with `app_instance_id=abcd`
4. UserB hits the `ensure_authenticated!` wall and agrees - a `User` record being created
5. UserB hits the `ensure_app_instance_found!` wall and agrees - a `UserAppInstace` being created for the user and `AppInstance` with `hr_id=abcd`
6. UserB now has access to the `AppInstance`


## Extension
TODO

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
