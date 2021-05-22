class FoundationalSchema < ActiveRecord::Migration[6.0]
  def change
    create_table :respondents do |t|
      t.string :uuid, null: false

      t.timestamps
    end

    create_table :questions do |t|
      t.string :uuid, null: false

      t.timestamps
    end

    create_table :answers do |t|
      t.string :uuid, null: false

      t.integer :question_id, null: false, foreign_key: true
      t.integer :respondent_id, null: false, foreign_key: true

      t.timestamps
    end

    create_table :options do |t|
      t.string :uuid, null: false

      t.integer :answer_id, null: false, foreign_key: true
      t.integer :respondent_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
