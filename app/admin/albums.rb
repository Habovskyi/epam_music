ActiveAdmin.register Album do
  permit_params :title

  index do
    selectable_column

    column :id
    column :title
    column :created_at
    column :updated_at

    actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    f.inputs 'Album' do
      f.input :title
    end

    f.actions
  end

  controller do
    include AdminHelper

    private

    def form_klass
      Admin::Albums::BaseForm
    end
  end
end
