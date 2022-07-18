module Admin
  module Albums
    class BaseForm < AdminForm
      TITLE_MIN_LENGTH = 1
      TITLE_MAX_LENGTH = 50
      ALBUM_REGEXP = %r{\A(?![_.'/-])(?!.*[_.]{2})[a-zA-Z0-9':/? ]+(?<![:/])$\z}

      model :album

      property :title

      validates :title, presence: true, length: { in: TITLE_MIN_LENGTH..TITLE_MAX_LENGTH }, format: {
        with: ALBUM_REGEXP
      }
    end
  end
end
