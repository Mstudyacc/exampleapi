class Book < ApplicationRecord
    belongs_to :author

    validates :title, presence: true, length: { minimum: 3, maximum: 125 }
end
