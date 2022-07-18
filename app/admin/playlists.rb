ActiveAdmin.register Playlist do
  permit_params :featured
  actions :index, :show, :update, :edit

  config.action_items.delete_if { |item| item.display_on?(:show) }

  action_item :edit, only: :show do
    link_to 'Edit', edit_admin_playlist_path(resource.id) if resource.general?
  end

  batch_action :featured do |ids|
    batch_action_collection.general.where(id: ids).each do |playlist|
      playlist.update(featured: !playlist.featured)
    end
    redirect_to admin_playlists_path, alert: I18n.t('alert.admin.playlists.featured_changed')
  end

  index do
    selectable_column

    column :id
    column :title
    column :featured
    column :visibility
    column :count_listening
    column :created_at
    column :updated_at

    actions defaults: false do |playlist|
      item 'View', admin_playlist_path(playlist.id)
      item 'Edit', edit_admin_playlist_path(playlist.id) if playlist.general?
    end
  end

  show do
    attributes_table do
      row :id
      row :title
      row :featured
      row :visibility
      row :count_listening
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    f.inputs 'Playlist' do
      f.input :featured
    end

    f.actions
  end
end
