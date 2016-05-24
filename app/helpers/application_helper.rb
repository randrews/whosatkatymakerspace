module ApplicationHelper
  def is_admin?
    current_user.try :admin
  end

  def is_mobile?
    request.user_agent =~ /Mobile|webOS|iPhone|iPad|Android|Tablet/
  end
end
