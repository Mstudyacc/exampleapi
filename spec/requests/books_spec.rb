require 'rails_helper'

describe 'Books API', type: :request do
  it 'returns all books' do
    #Создаём 2 объекта класса book in the test db using factory rails bot gem
    FactoryBot.create(:book, title: "1994", author: "George Orwell")
    FactoryBot.create(:book, title: "RoR", author: "DHH")

    get '/api/v1/books'
    
    #Мы ожидаем что гет запрос по адресу выше заврешиться успешно (код 200)
    expect(response).to have_http_status(:success)
    #Теперь проверяем что по запросу нам возвращается фактичски все (2) книги
    expect(JSON.parse(response.body).size).to eq(2)
  end
end
