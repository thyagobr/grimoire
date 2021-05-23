class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :respondent
  has_many :options, class_name: "AnsweredOption"

  before_save do
    self.uuid ||= SecureRandom.uuid
  end
end
