# This is class for likes and dislikes of playlists
class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :playlist

  enum reaction_type: { liked: 0, disliked: 1 }

  validate :multiple_reactions

  def multiple_reactions
    reaction = Reaction.where(user_id:, playlist_id:).where.not(id:)

    errors.add(:base, :already_exists) if reaction.exists?
  end
end
