# frozen_string_literal: true

module RequestSpecHelper
  include Warden::Test::Helpers

  def self.included(base)
    base.before(:each) { Warden.test_mode! }
    base.after(:each) { Warden.test_reset! }
  end

  def sign_in(resource)
    login_as(resource)
  end

  def sign_out(resource)
    logout(resource)
  end

  private

  def warden_scope(resource)
    resource.class.name.underscore.to_sym
  end
end
