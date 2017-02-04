class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable


  before_save :ensure_authentication_token
  before_save :full_name

  def ensure_authentication_token
    self.authentication_token ||= generate_authentication_token
  end
  

  def full_name
    if !self.first_name.nil? && !self.last_name.nil?
      if self.name != (self.first_name + " " + self.last_name)
        self.update_attribute(:name, self.first_name + " " + self.last_name)
      end
    end
  end

  private

  	def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end
end
