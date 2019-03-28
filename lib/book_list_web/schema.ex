defmodule BookListWeb.Schema do
  use Absinthe.Schema

  alias BookListWeb.Resolvers.BookResolver  # BookListWeb.BookResolver 

  object :book do
    field :id, non_null(:id)
    field :author, :string
    field :notes, :string
    field :category, :string
    field :pages, :integer
    field :pages_read
    field :public, :boolean
    field :rating, :integer
    field :title, :string
    field :subtitle, :string
    field :user_id, :id
    field :start_date_string
    field :finish_date_string
    field :pages_read_today
    field :average_reading_rate
  end



  query do
    field :all_books, non_null(list_of(non_null(:book))) do
      resolve &BookResolver.all_books/3
    end
  end

  mutation do
    field :create_book, :book do
      arg :title, non_null(:string)
      arg :author, non_null(:string)

      resolve &BookResolver.create_link/3
    end
  end

  end