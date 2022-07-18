ActiveAdmin.register Author do
  filter :nickname, label: 'Name'

  permit_params :nickname

  index do
    selectable_column
    column :nickname
    actions
  end

  show do
    attributes_table do
      row :nickname
    end
  end

  form do |f|
    f.inputs I18n.t('admin.resource.author.new') do
      f.input :nickname
    end
    f.actions
  end

  controller do
    include AdminHelper

    private

    def form_klass
      Admin::AuthorForm
    end
  end
end
