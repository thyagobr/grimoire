class Respondent < ActiveRecord::Base
  has_many :answers
  has_many :options # through answers?
end
