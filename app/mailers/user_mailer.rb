# Encoding: utf-8

class UserMailer < ActionMailer::Base
  default from: "info@katymakerspace.com"

  def welcome user
    mail(to: user.email, subject: 'Welcome to Katy Makerspace!')
  end
end
