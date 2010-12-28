class RegistrationsController < Devise::RegistrationsController
  
  # def create
  #   super
  #   session[:omniauth] = nil unless @user.new_record?
  # end
  
  private
  
    def after_update_path_for(resource)
      edit_user_registration_path # You can put whatever path you want here
    end
    
    # def build_resource(*args)
    #   super
    #   if session[:omniauth]
    #     @user.apply_omniauth(session[:omniauth])
    #     @user.valid?
    #   end
    # end
  
end