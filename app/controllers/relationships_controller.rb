class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @relationships = current_user.following_relationships
  end

  def create
    followed_user = User.find(params[:followed_user_id])
    Relationship.create(follower: current_user, leader: followed_user) if current_user.can_follow?(followed_user)
    flash[:info] = "User added to people you follow!"
    redirect_to people_path
  end

  def destroy
    relationship = Relationship.find(params[:id])
    relationship.destroy if relationship.follower == current_user
    flash[:danger] = "User removed from people you follow."
    redirect_to people_path
  end
end
