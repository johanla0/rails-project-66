# frozen_string_literal: true

module Kernel
  def let(value)
    yield value
  end
end
