# frozen_string_literal: true

module UsersHelper
  def avatar_for(user, options = {})
    return '' if user.image_url.blank?

    avatar_url = user.image_url
    image_tag(avatar_url, alt: user.name, class: 'avatar rounded-circle shadow-4', **options)
  end
end
