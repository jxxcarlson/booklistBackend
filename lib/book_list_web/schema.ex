defmodule BookListWeb.Schema do
  use Absinthe.Schema

  import_types Absinthe.Type.Custom

  alias BookListWeb.Resolvers.BookResolver
  alias BookListWeb.Resolvers.UserResolver

  object :book do
    field :id, non_null(:id)
    field :author, :string
    field :notes, :string
    field :category, :string
    field :pages, :integer
    field :pages_read, :integer
    field :public, :boolean
    field :rating, :integer
    field :title, :string
    field :subtitle, :string
    field :user_id, :integer
    field :start_date_string, :string
    field :finish_date_stringm, :string
    field :pages_read_today, :integer
    field :average_reading_rate, :float
    field :inserted_at, :naive_datetime
  end

  object :user do
    field :id, non_null(:id)
    field :email, :string
    field :username, :string
    field :firstname, :string
    field :lastname, :string
    field :password_hash
    field :password, :string
    field :admin, :boolean
    field :blurb, :string
    field :public, :boolean
    field :follow, (list_of(:string))
    field :followers,list_of(:string)
    field :tags, list_of(:string)
    field :reading_stats, list_of(:stat)
    field :verified, :boolean
    field :inserted_at, :naive_datetime
  end

  object :stat do
    field :date, :string
    field :pages_read, :integer
  end

@docp """
http://localhost:4000/graphiql


  { getUser(id: 1) {
      username
      email
      id
      follow
      readingStats
      insertedAt
    }
  }

  listBooks {
    title
    id
    userId
    pagesRead
    pagesReadToday
    userId
    insertedAt
  }
}


{
  listBooks(userId: 34) {
    title
    id
    pagesRead
    pagesReadToday
    userId
    insertedAt
  }
}

"""

  query do

    field :list_books, non_null(list_of(non_null(:book))) do
      arg :user_id, non_null(:integer)
      resolve &BookResolver.list_books/3
    end

    field :list_books, non_null(list_of(non_null(:book))) do
      resolve &BookResolver.list_books/3
    end

    field :get_user, non_null(list_of(non_null(:user))) do
      arg :id, non_null(:integer)
      resolve &UserResolver.get_user/3
    end

    field :list_users, non_null(list_of(non_null(:user))) do
      resolve &UserResolver.list_users/3
    end
  end



  mutation do
    field :create_book, :book do
      arg :title, non_null(:string)
      arg :author, non_null(:string)

      resolve &BookResolver.create_book/3
    end
  end

  end