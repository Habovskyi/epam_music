# rubocop:disable Rails/SkipsModelValidations
class DeleteActionTextTables < ActiveRecord::Migration[7.0]
  def up
    ::About.update_all("body = texts.body
      FROM action_text_rich_texts AS texts
      WHERE abouts.id = texts.record_id
        AND texts.record_type = 'About'")

    drop_table :action_text_rich_texts
  end

  def down
    primary_key_type, foreign_key_type = primary_and_foreign_key_types

    create_table :action_text_rich_texts, id: primary_key_type do |t|
      t.string     :name, null: false
      t.text       :body, size: :long
      t.references :record, null: false, polymorphic: true, index: false, type: foreign_key_type

      t.timestamps

      t.index %i[record_type record_id name], name: 'index_action_text_rich_texts_uniqueness', unique: true
    end
  end

  private

  def primary_and_foreign_key_types
    config = Rails.configuration.generators
    setting = config.options[config.orm][:primary_key_type]
    primary_key_type = setting || :primary_key
    foreign_key_type = setting || :bigint
    [primary_key_type, foreign_key_type]
  end
end
# rubocop:enable Rails/SkipsModelValidations
