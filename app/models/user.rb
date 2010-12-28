class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable
  devise :database_authenticatable, :registerable, :token_authenticatable, :lockable, :timeoutable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  

  # private
  # 
  #   def password_required?
  #     # (authentications.empty? || !password.blank?) && super
  #     (!password.blank?) && super
  #   end
    
end
