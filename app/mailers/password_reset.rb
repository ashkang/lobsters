class PasswordReset < ActionMailer::Base
  default :from => "#{Rails.application.name} " <<
    "<nobody@#{Rails.application.domain}>"

  def password_reset_link(user, ip)
    @user = user
    @ip = ip

    mail(
      :to => user.email,
      :subject => "بازیابی رمز عبور #{Rails.application.name}"
    )
  end
end
