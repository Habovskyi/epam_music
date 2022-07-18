module Servicable
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def call(*args, **kwarg)
      new(*args, **kwarg).call
    end
  end
end
