module Api
  module V1
    module Reactions
      class CreateService < ApplicationService
        attr_reader :current_user, :params, :playlist, :previous_reaction, :reaction

        def initialize(current_user, params = {})
          @current_user = current_user
          @params = params
        end

        def call
          @playlist = find_playlist
          @previous_reaction = find_previous_reaction
          @reaction_type = handle_reaction_type
          delete_previous_reaction if previous_reaction
          create_new_reaction if @reaction_type
        end

        private

        def find_playlist
          ::Playlist.find(params[:playlist_id])
        end

        def handle_reaction_type
          return if params[:reaction_type] == previous_reaction&.reaction_type

          params[:reaction_type]
        end

        def find_previous_reaction
          playlist.reactions.find_by(user: current_user)
        end

        def create_new_reaction
          @reaction = playlist.reactions.new(user: current_user, reaction_type: @reaction_type)
          reaction.save if reaction.valid?
          {
            status: reaction.errors.any? ? :failure : :success,
            model: reaction,
            errors: reaction.errors
          }
        end

        def delete_previous_reaction
          previous_reaction.destroy
        end
      end
    end
  end
end
