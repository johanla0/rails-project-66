# frozen_string_literal: true

require 'test_helper'

class Web::AuthControllerTest < ActionDispatch::IntegrationTest
  test '#request' do
    post auth_request_path('github')

    assert_response :redirect
  end

  test '#create' do
    auth_hash = {
      provider: 'github',
      uid: '12345',
      info: {
        email: Faker::Internet.email,
        name: Faker::Name.name
      },
      credentials: {
        token: SecureRandom.hex(10)
      }
    }

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash::InfoHash.new(auth_hash)

    get callback_auth_url('github')

    assert_response :redirect

    user = User.find_by(email: auth_hash[:info][:email].downcase)

    assert { user.present? }
    assert { signed_in? }
  end

  test '#destroy' do
    delete auth_logout_path

    assert_response :redirect
    assert { current_user.blank? }
  end
end
