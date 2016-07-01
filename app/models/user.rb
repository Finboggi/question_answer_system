class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :questions
  has_many :answers

  def author_of?(resource)
    resource.user_id == id
  end

  def vote(resource)
    resource.votes.where(user: self).first
  end

  def voted?(resource)
    vote(resource).present?
  end

  def not_voted?(resource)
    !voted? resource
  end

  def voted_for?(resource)
    vote(resource).positive?
  end

  def voted_against?(resource)
    vote(resource).negative?
  end
end
