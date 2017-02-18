class InvitationMailer < ActionMailer::Base
  default :from => "#{Rails.application.name} " <<
    "<nobody@#{Rails.application.domain}>"

  def invitation(invitation)
    @invitation = invitation

    mail(
      :to => invitation.email,
      subject: "شما به #{Rails.application.name} دعوت شدید" <<
        Rails.application.name
    )
  end
end
