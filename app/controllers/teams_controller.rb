class TeamsController < ApplicationController
  respond_to :html

  before_filter :authenticate_user!, only: [:new, :edit, :update]
  before_filter :verify_permission, only: [:edit]
  before_filter :verify_team, only: [:new]

  def index
    @teams = Team.all
  end

  def new
    @team = Team.new
    @team.build_profile
  end

  def create
    @players_ids = params[:team][:player_tokens].split(',')
    params[:team].delete(:player_tokens)
    @team = current_user.create_team(params[:team])
    save_players(@team)
    if @team.save
      flash[:success] = t('flash.team', message: t('flash.created'))
    end
    respond_with @team
  end

  def show
    @team = Team.find(params[:id])
    if request.path != team_path(@team)
      redirect_to team_path(@team), status: :moved_permanently
    end
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    flash[:notice] = t('flash.team', message: t('flash.destroyed'))
    respond_with(@team)
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    @players_ids = params[:team][:player_tokens].split(',')
    params[:team].delete(:player_tokens)
    update_players(@team)
    if @team.update_attributes(params[:team])
      flash[:success] = t('flash.team', message: t('flash.updated'))
    end
    respond_with @team
  end

  private

    def verify_permission
      @team = Team.find(params[:id])
      redirect_to(teams_path, notice: t('flash.permission_team')) unless current_user == @team.owner
    end

    def verify_team
      redirect_to(teams_path, notice: t('flash.verify_team')) unless current_user.team.blank?
    end

    def save_players(team)
      @players_ids.each do |player|
        team.players << User.find_by_id(player)
      end
    end  
    def update_players(team)
      # team.users.each do |user|
      #   if @players_ids.include?(user.id)
      #   else
      #      @team.users.delete(user)
      #   end  
      # end
      # save_players(team)
    end  

end