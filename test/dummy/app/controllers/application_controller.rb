class ApplicationController < ActionController::Base
  include Authentication

  layout "kern/application"
end
