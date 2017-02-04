class Api::V1::GamesController < ApplicationController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }
  before_filter :check_authentication

  # include Serializers::V1::ItemsSerializer

  # Just skip the authentication for now
  # before_filter :authenticate_user!

  respond_to :json

  def index 
    @games = Game.all
    if @games.count > 0
      render :status => 200,
             :json => { :success => true,
                        :info => "Games loaded",
                        :data => {games: @games} }
    else
      render :status => 401,
             :json => { :success => false,
                        :info => "There are no games",
                        :data => {} }
    end
  end

  

  def create
    @game = Game.new(game_params)
		if @game.save
      render :status => 200,
             :json => { :success => true,
                        :info => "Success! Game has been saved.",
                        :data => {} }
		else
      render :status => 401,
             :json => { :success => false,
                        :info => "Error, game not saved.",
                        :data => {} }
		end
  end


  def user_positions
    if @user.game_id != 0
      @game = @user.game
      @users = @game.users.where.not(user_id: @user.id)
      render :status => 200,
             :json => { :success => true,
                        :info => "Game users location",
                        :data => { users: serialize_users(@users) } }
    else

    end
    
  end



  




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


    def serialize_users(users)
      users.map do |user|
          {
            id: user.id, 
            longitude: user.longitude,
            latitude: user.latitude,
            it: user.it
          }
        end
    end





end
