require 'rails_helper'

describe 'Books API', type: :request do

  let(:first_author) {FactoryBot.create(:author, first_name: "George", last_name: "Orwell", age: 11)}
  let(:second_author) {FactoryBot.create(:author, first_name: "DHH", last_name: "DHH", age: 11)}

  describe 'GET /books' do 
    before do 
      #Создаём 2 объекта класса book in the test db using factory rails bot gem
      FactoryBot.create(:book, title: "1994", author: first_author)
      FactoryBot.create(:book, title: "RoR", author: second_author)
    end

    it 'returns all books' do
      get '/api/v1/books'
      
      #Мы ожидаем что гет запрос по адресу выше заврешиться успешно (код 200)
      expect(response).to have_http_status(:success)
      #Теперь проверяем что по запросу нам возвращается фактичски все (2) книги
      expect(response_body.size).to eq(2)
      expect(response_body).to eq(
        [
          {
            "id" => 1,
            "title" => "1994",
            "author_name" => "George Orwell",
            "author_age" => 11
          },
          {
            "id" => 2,
            "title" => "RoR",
            "author_name" => "DHH DHH",
            "author_age" => 11
          }
        ]
      )
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
      expect(response_body).to eq(
        {
        "id" => 1,
        "title" => "Some book",
        "author_name" => "Some author",
        "author_age" => 11
        }
      )
    end
  end

  describe 'DELETE /books/id' do
    let!(:book) { FactoryBot.create(:book, title: "1994", author: first_author) }

    it 'deletes a book' do 
      expect {
        delete "/api/v1/books/#{book.id}"
      }.to change {Book.count}.from(1).to(0)
      
      expect(response).to have_http_status(:no_content)
    end
  end
end
 