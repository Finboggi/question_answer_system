class Question < ActiveRecord::Base
  has_many :answer, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user_id, presence: true
end
