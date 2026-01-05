module Kern
  class ApplicationController < ActionController::Base
    include Authentication
    include Layouts

    define_layout :application

    default_form_builder Kern::FormBuilder

    private

    def _prefixes = [controller_name] + super
  end
end
