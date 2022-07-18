ActiveAdmin.register Friendship do
  includes :user_from, :user_to
  actions :all, except: %i[new create edit destroy]

  index do
    column :id
    column :user_from
    column :user_to
    column :status
    column :created_at
    column :updated_at

    actions
  end

  show do
    attributes_table do
      row :id
      row :user_from
      row :user_to
      row :status
      row :created_at
      row :updated_at
    end
  end
end
