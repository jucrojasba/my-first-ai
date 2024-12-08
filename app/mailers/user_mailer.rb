class UserMailer < ApplicationMailer
  def response_ready(form)
    @form = form
    mail(to: "jucrojasba@gmail.com", subject: "¡Tu respuesta está lista!")
  end
end
