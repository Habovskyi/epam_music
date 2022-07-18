ActiveAdmin.register Genre do
  permit_params :name
  remove_filter :songs
  actions :all, except: %i[destroy]
  config.batch_actions = false

  form do |f|
    f.inputs 'Genre' do
      f.input :name
    end

    f.actions
  end

  controller do
    include AdminHelper

    private

    def form_klass
      Admin::GenreForm
    end
  end
end
