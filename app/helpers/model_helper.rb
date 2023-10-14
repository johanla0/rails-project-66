# frozen_string_literal: true

module ModelHelper
  # NOTE: han stands for Human Attribute Name
  def han(model, attribute)
    model.to_s
         .classify
         .constantize
         .human_attribute_name(attribute)
  end
end
