module Kern
  class Settings::UsersController < ApplicationController
    before_action :set_user, only: %w[show update]

    def show
    end

    def update
      if @user.update(user_params)
        redirect_to settings_user_path, notice: "Updated"
      else
        redirect_to settings_user_path, alert: "Password is incorrect"
      end
    end

    private

    def set_user
      @user = Current.user
    end

    def user_params
      params.expect(user: [:email_address, :password, :password_confirmation])
    end
  end
end
