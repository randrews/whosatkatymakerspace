class VisitMailer < ActionMailer::Base
  default from: "info@katymakerspace.com"

  def notify name, email
    @name = name
    mail(to: email, subject: 'Katy Makerspace is open!')
  end
end
