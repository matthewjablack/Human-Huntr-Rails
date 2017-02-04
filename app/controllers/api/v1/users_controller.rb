class Api::V1::UsersController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }
  before_filter :check_authentication, :except => [:reset_password]

  # include Serializers::V1::ItemsSerializer

  # Just skip the authentication for now
  # before_filter :authenticate_user!

  respond_to :json


  def get_current_user
    render :status => 200,
           :json => { :user => { name: @user.name, first_name: @user.first_name, last_name: @user.last_name, email: @user.email } }
  end

  def reset_password
    @user = User.find_by_email(params[:email])
    if @user.present?
      @user.send_reset_password_instructions
      render :status => 200, 
             :json => { :success => true,
                        :info => "Password instructions have been sent to your email",
                        :data => {} }
    else
      render :status => 401, 
             :json => { :success => false,
                        :info => "Email not found",
                        :data => {} }
    end
  end

  def update
    if @user.update_attributes(user_params)
      render :status => 200,
               :json => { :success => true,
                          :info => "Successfully update profile info",
                          :data => {} } 
    else
      render :status => 401,
               :json => { :success => false,
                          :info => "Error updating profile info",
                          :data => {} } 
    end
  end



  private

    def check_authentication
       if User.where(authentication_token: params[:auth_token]).count == 1
        @user = User.where(authentication_token: params[:auth_token]).first
       else
        render :status => 401,
               :json => { :success => false,
                          :info => "Authentication failed",
                          :data => {} }
       end
    end

    def user_params
		params.require(:user).permit(:name, :email, :first_name, :last_name, :password, :password_confirmtion)
	end



end