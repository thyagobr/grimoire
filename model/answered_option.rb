class AnsweredOption < ActiveRecord::Base
  belongs_to :answer
  belongs_to :option

  before_save do
    self.uuid ||= SecureRandom.uuid
  end
end
