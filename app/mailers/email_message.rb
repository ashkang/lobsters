class EmailMessage < ActionMailer::Base
  default :from => "#{Rails.application.name} " <<
    "<nobody@#{Rails.application.domain}>"

  def notify(message, user)
    @message = message
    @user = user

    mail(
      :to => user.email,
      :subject => "#{Rails.application.name} - پیام خصوصی از طرف" <<
        "#{message.author_username}: #{message.subject}"
    )
  end
end
