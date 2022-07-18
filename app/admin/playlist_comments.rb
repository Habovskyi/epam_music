ActiveAdmin.register Comment, as: 'PlaylistComment' do
  actions :destroy, :index, :show
  config.batch_actions = false
  includes :user, :playlist
end
