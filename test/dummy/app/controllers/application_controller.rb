class ApplicationController < ActionController::Base
  def current_user
    @current_user ||= User.where(name: "Bob", email: "bob@example.org").first_or_create
  end
end
