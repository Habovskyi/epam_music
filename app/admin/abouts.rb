MAX_BODY_INDEX_LENGTH = 100

ActiveAdmin.register About do
  config.filters = false

  permit_params :body

  index do
    id_column
    column :body do |about|
      truncate(about.body, length: MAX_BODY_INDEX_LENGTH)
    end
    column :updated_at
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :body do |ad|
        # rubocop:disable Rails/OutputSafety
        ad.body.html_safe
        # rubocop:enable Rails/OutputSafety
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.hidden_field :body, class: 'quill-content'
      f.div class: 'quill-editor'
    end
    f.actions
  end
end
