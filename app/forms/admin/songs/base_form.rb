module Admin
  module Songs
    class BaseForm < AdminForm
      TITLE_MIN_LENGTH = 2
      TITLE_MAX_LENGTH = 40
      TITLE_REGEXP = /\A[a-zA-Z0-9()\-'&? ]+\z/

      model :song

      property :title
      property :featured
      property :author_id
      property :album_id
      property :genre_id

      validates :title, presence: true, length: { in: TITLE_MIN_LENGTH..TITLE_MAX_LENGTH }, format: {
        with: TITLE_REGEXP
      }
      validates :author_id, :genre_id, presence: true
      validate :unique_song_of_author

      private

      def unique_song_of_author
        name_exist = ::Song.where(author_id:).where('title ILIKE :title', title:).where.not(id:).exists?

        errors.add(:title, :already_exists) if name_exist
      end
    end
  end
end
