class Api::V1::GamesController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }
  before_filter :check_authentication

  # include Serializers::V1::ItemsSerializer

  # Just skip the authentication for now
  # before_filter :authenticate_user!

  respond_to :json

  def create
    @game = Game.new(game_params)
		if @game.save
      render :status => 200,
             :json => { :success => true,
                        :info => "Success! Game has been saved.",
                        :data => {} }
			#@group.fix_private

		  #	current_user.create_group_admin_member(@group)
			#redirect_to organization_group_path([@group.organization.url], [@group.url])
			# redirect_to root_path
		else
      render :status => 401,
             :json => { :success => false,
                        :info => "Error, game not saved.",
                        :data => {} }
		end
  end

  def current_position
    if @user.game_id != 0
      @game = user.game
      render :status => 200,
             :json => { :success => true,
                        :info => "Success! Current position returned.",
                        :data => {} }
    elsif

    end
  end

  def update_position
    @user.update_attributes(user_params)




  private

  def game_params
    params.require(:game).permit(:name, :user_id, :longitude, :latitude, :radius)
  end



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



end
