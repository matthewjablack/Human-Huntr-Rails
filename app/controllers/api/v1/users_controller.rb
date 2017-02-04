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

  def update_position
    if @user.game_id != 0
      @user.update_attributes(user_params)
      @game = @user.game


      dist = @game.distance_between(@user.longitude, @user.latitude, @game.longitude, @game.latitude)
		  in_radius = @game.proximity(@game.radius, dist)

	    if in_radius
	      render :status => 200,
	               :json => { :success => true,
	                          :info => "Success, in game!",
	                          :data => {} }
	    else
	      render :status => 401,
	               :json => { :success => false,
	                          :info => "Out of game!",
	                          :data => {} }
	    end

	  elsif 
	  	render :status => 401,
	               :json => { :success => false,
	                          :info => "Out of game!",
	                          :data => {} }
    end
  end

  def join_game
    if params[:game_id]
      if Game.where(id: params[:game_id]).count > 0 
      	if @user.update_attributes(user_params)
      		render :status => 200,
	               :json => { :success => true,
	                          :info => "Success, in game!",
	                          :data => {} }
      	elsif 
      		render :status => 401,
             :json => { :success => false,
                        :info => "Error",
                        :data => {} }
      	end
      else
      	render :status => 401,
             :json => { :success => false,
                        :info => "Error",
                        :data => {} }
      end
    else
      render :status => 401,
             :json => { :success => false,
                        :info => "No Game ID",
                        :data => {} }
    end
  end


  def leave_game
  	if @user.update_attributes(game_id: 0)
  		render :status => 200,
	               :json => { :success => true,
	                          :info => "Successfully left game",
	                          :data => {} }
  	else
  		render :status => 401,
             :json => { :success => false,
                        :info => "Error leaving game",
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
		    params.require(:user).permit(:name, :email, :first_name, :last_name, :password, :password_confirmation, :longitude, :latitude, :game_id)
	  end



end
