# Encoding: utf-8

class UsersController < ApplicationController
  before_filter :check_if_admin, except: [:show]
  before_filter :find_user

  def check_out
    if @user.active_visit.present?
      @user.active_visit.depart!
      flash[:notice] = "#{@user.name} checked out"
    else
      flash[:alert] = "#{@user.name} not checked in"
    end

    redirect_to :back
  end

  def approve
    @user.update_attribute :approved, true
    flash[:notice] = "#{@user.name} approved"
    redirect_to :back
  end

  def delete
    name = @user.name
    @user.destroy
    flash[:notice] = "#{name} deleted"
    redirect_to :back
  end

  def show
    if !@user.approved? && @user != current_user && !(current_user.try(:admin?))
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  protected

  def check_if_admin
    if current_user.try :admin
      true
    else
      flash[:alert] = "You must be an admin to do that"
      redirect_to new_user_session_path
    end
  end

  def find_user
    @user = User.where(id: params[:id]).first

    if @user.blank?
      flash[:alert] = "Couldn't find user with id #{params[:id].to_s}"
      redirect_to :back
      false
    else
      true
    end
  end
end
