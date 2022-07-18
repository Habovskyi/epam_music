ActiveAdmin.register Song do
  permit_params :title, :genre_id, :author_id, :album_id, :featured
  remove_filter :playlist_songs
  includes :genre, :album, :author

  index do
    selectable_column

    column :id
    column :title
    column :genre
    column :author
    column :album
    column :featured
    column :created_at
    column :updated_at

    actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :genre
      row :author
      row :album
      row :featured
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    f.inputs 'Song' do
      f.input :title
      f.input :genre_id, as: :select, collection: ::Genre.order(:name).select(:name, :id)
      f.input :author_id, as: :select, collection: ::Author.order(:nickname).select(:nickname, :id)
      f.input :album_id, as: :select, collection: ::Album.order(:title).select(:title, :id)
      f.input :featured, as: :boolean
    end

    f.actions
  end

  controller do
    include AdminHelper

    private

    def form_klass
      Admin::Songs::BaseForm
    end
  end
end
