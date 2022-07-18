module Admin
  class GenreForm < AdminForm
    NAME_MIN_LENGTH = 2
    NAME_MAX_LENGTH = 15
    GENRE_REGEXP = %r{\A[A-Za-z ]+[/&]?[A-Za-z ]+\z}

    model :genre

    property :name

    validates :name, presence: true,
                     length: { in: NAME_MIN_LENGTH..NAME_MAX_LENGTH },
                     format: { with: GENRE_REGEXP }
    validate :unique_genre_name

    def unique_genre_name
      errors.add(:name, :already_exists) if ::Genre.where(name:).any?
    end
  end
end
