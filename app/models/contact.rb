class Contact < MailForm::Base
  attribute :name
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :urls
  attribute :message
  attribute :nickname,  :captcha  => true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject            => "Обратная связь Bender",
      "X-Priority"        => "1 (Highest)",
      "X-MSMail-Priority" => "High",
      :to                 => "zahaz@alphav.ru",
      :from               => "hello@pbender.ru",
      :from_to            => %("#{name}" <#{email}>)
    }
  end
end