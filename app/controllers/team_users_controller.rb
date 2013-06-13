class TeamUsersController < ApplicationController
respond_to :html

  # before_filter :authenticate_user!, only: [:new, :edit, :update]
  # before_filter :verify_permission, only: [:edit]
  # before_filter :verify_team, only: [:new]

  def index
    @team_users = TeamUser.all
  end

  def new
    @team_users = Team.new
    @team = current_user.team
    @users = User.all
  end

  def create
    @team_users.team = @team
    @team_users.user = User.find(params[:team_id])
    if @team_users.save
      flash[:success] = "Successfully created team_users."
    end
    respond_with @team
  end

  def show
    @team_users = TeamUser.find(params[:team])
    # if request.path != team_path(@team)
    #   redirect_to team_path(@team), status: :moved_permanently
    # end
  end

  # def destroy
  #   @team = Team.find(params[:id])
  #   @team.destroy
  #   flash[:notice] = "Successfully destroyed team."
  #   respond_with(@team)
  # end

  # def edit
  #   @team = Team.find(params[:id])
  # end

  # def update
  #   @team = Team.find(params[:id])
  #   if @team.update_attributes(params[:team])
  #     flash[:success] = "Successfully updated team."
  #   end
  #   respond_with @team
  # end

  # private

  #   def verify_permission
  #     @team = Team.find(params[:id])
  #     redirect_to teams_path, notice: "you don't have permisson" unless current_user == @team.owner
  #   end

  #   def verify_team
  #     redirect_to teams_path, notice: "you have a team" unless current_user.team.blank?
  #   end

end