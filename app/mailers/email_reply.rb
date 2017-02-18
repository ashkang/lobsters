class EmailReply < ActionMailer::Base
  default :from => "#{Rails.application.name} " <<
    "<nobody@#{Rails.application.domain}>"

  def reply(comment, user)
    @comment = comment
    @user = user

    mail(
      :to => user.email,
      :subject => "#{Rails.application.name} - پاسخ از " <<
        "#{comment.user.username} در مطلب #{comment.story.title}"
    )
  end

  def mention(comment, user)
    @comment = comment
    @user = user

    mail(
      :to => user.email,
      :subject => "#{Rails.application.name} - منشن از طرف " <<
        "#{comment.user.username} در مطلب #{comment.story.title}"
    )
  end
end
