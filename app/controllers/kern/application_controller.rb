module Kern
  class ApplicationController < ActionController::Base
    include Authentication

    default_form_builder Kern::FormBuilder
  end
end
