# frozen_string_literal: true

module ModelHelper
  # NOTE: han stands for Human Attribute Name
  def han(model, attribute)
    model.to_s
         .classify
         .constantize
         .human_attribute_name(attribute)
  end

  # NOTE: hsn stands for Human State Name
  def hsn(model, state)
    model_states(model).to_h { |s| [s.name, t(s.name, scope: 'states')] } [state.to_sym]
  end

  def model_states(model)
    model.to_s
         .classify
         .constantize
         .aasm
         .states
  end
end
