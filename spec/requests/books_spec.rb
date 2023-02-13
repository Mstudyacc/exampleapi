require 'rails_helper'

describe 'Books API', type: :request do
  describe 'GET /books' do 
    before do 
      #Создаём 2 объекта класса book in the test db using factory rails bot gem
      FactoryBot.create(:book, title: "1994", author: "George Orwell")
      FactoryBot.create(:book, title: "RoR", author: "DHH")
    end

    it 'returns all books' do
      get '/api/v1/books'
      
      #Мы ожидаем что гет запрос по адресу выше заврешиться успешно (код 200)
      expect(response).to have_http_status(:success)
      #Теперь проверяем что по запросу нам возвращается фактичски все (2) книги
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'POST /books' do 
    it 'create a new book' do 
      #Убедимся что в БД реально создаётся запись, проверяем просто каунтером 
      expect {
        post '/api/v1/books', params: {
          book: {title: "Some book"},
          author: {first_name: "Some", last_name: "author", age: "11"}
        }
      }.to change {Book.count}.from(0).to(1)
      
      expect(response).to have_http_status(:created)
      expect(Author.count).to eq(1)
    end
  end

  describe 'DELETE /books/id' do
    let!(:book) { FactoryBot.create(:book, title: "1994", author: "George Orwell") }

    it 'deletes a book' do 
      expect {
        delete "/api/v1/books/#{book.id}"
      }.to change {Book.count}.from(1).to(0)
      
      expect(response).to have_http_status(:no_content)
    end
  end
end
 