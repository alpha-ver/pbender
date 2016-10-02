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
      :to                 => "form@pbender.ru",
      :from               => %("#{name}" <#{email}>)
    }
  end
end