include ApplicationHelper
require 'spec_helper'
# include Capybara::DSL
def sign_in(identity, provider)
  visit signin_path
  fill_in "Email address",    with: identity.email
  fill_in "Password", with: "foobar"
  click_button "Sign in"
  # Sign in when not using Capybara.
  Capybara.current_session.driver.request.cookies.[]('remember_token').should_not be_nil
  auth_token_value = Capybara.current_session.driver.request.cookies.[]('remember_token')
  # Capybara.reset_sessions!
  # page.driver.browser.set_cookie("remember_token=#{auth_token_value}")

  cookies[:remember_token] = auth_token_value
end