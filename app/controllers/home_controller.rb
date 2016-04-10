class HomeController < ApplicationController
  def index
    if current_user.present? && current_user.admin?
      @visits = Visit.active
    elsif current_user.present? && !current_user.approved?
      @visits = Visit.active.approved_or_self(current_user)
    else
      @visits = Visit.active.approved
    end
  end
end
