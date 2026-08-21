class EmailNotifier
  def initialize(mailer)
    @mailer = mailer
  end

  def send_welcome_email(user)
    subject = "Welcome, #{user.name}!"
    body = build_welcome_body(user)
    @mailer.deliver(user.email, subject, body)
  end

  def send_password_reset(user, token)
    subject = "Password Reset Request"
    body = build_reset_body(user, token)
    @mailer.deliver(user.email, subject, body)
  end

  private

  def build_welcome_body(user)
    "Hi #{user.name},\n\nWelcome to our platform! We are excited to have you."
  end

  def build_reset_body(user, token)
    "Hi #{user.name},\n\nClick here to reset your password: /reset?token=#{token}"
  end
end
