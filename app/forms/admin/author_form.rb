module Admin
  class AuthorForm < AdminForm
    NICKNAME_MIN_LENGTH = 2
    NICKNAME_MAX_LENGTH = 40
    AUTHOR_REGEXP = /\A^(?![_.])(?!.*[_.'&$+-]{2})[a-zA-Z0-9&-_'$.+ ]+(?<![+&_$. ])$\z/

    model :author

    property :nickname

    validates :nickname, presence: true, length: {
      in: NICKNAME_MIN_LENGTH..NICKNAME_MAX_LENGTH
    }, format: {
      with: AUTHOR_REGEXP
    }
    validate :unique_author_name

    def unique_author_name
      errors.add(:nickname, :already_exists) if ::Author.where(nickname:).any?
    end
  end
end
