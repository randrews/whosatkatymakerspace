class VisitController < ApplicationController
  before_filter :check_if_user

  def create
    v = Visit.new(user: current_user, active: true)
    if v.valid?
      v.save
      respond_to do |format|
        format.html {
          flash[:notice] = "You've arrived. Happy hacking!"
          redirect_to '/'
        }
        format.json { render json: v.to_json }
      end
    else
      respond_to do |format|
        format.html {
          flash[:alert] = v.errors.full_messages.to_sentence
          redirect_to '/'
        }
        format.json { render json: { error: v.errors.full_messages.to_sentence }, status: 422 }
      end
    end
  end

  def delete
    if current_user.active_visit.present?
      current_user.active_visit.depart!
      respond_to do |format|
        format.html {
          flash[:notice] = "You've departed. Hope to see you again soon!"
          redirect_to '/'
        }
        format.json { render json: current_user.active_visit.to_json }
      end
    else
      respond_to do |format|
        format.html {
          flash[:alert] = "You're not currently at the makerspace"
          redirect_to '/'
        }
        format.json { render json: { error: "You're not currently at the makerspace" }, status: 422 }
      end
    end
  end

  private

  def check_if_user
    if current_user.present?
      true
    else
      flash[:alert] = "Log in or create an account first"
      redirect_to new_user_session_path
      false
    end
  end
end
