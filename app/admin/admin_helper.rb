module AdminHelper
  def build_new_resource
    form_klass.new(super)
  end

  def validatable_actions
    %w[edit update]
  end

  def find_resource
    action_name.in?(validatable_actions) ? form_klass.new(super) : super
  end
end
