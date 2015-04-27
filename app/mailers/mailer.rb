require 'action_mailer'
require 'bcrypt'

class Mailer < ActionMailer::Base
  default to: "groupergroups@gmail.com"

  def notification(from_email)
    mail(from: from_email, subject: "New Password") do |format|
      format.text
      format.html
    end
  end
end