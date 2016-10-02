class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      flash.now[:notice] = 'Сообщение успешно отрпавленно'
      @contact = Contact.new
    else
      flash.now[:error] = 'Ошибка отправки сообщения'
    end
  end
end