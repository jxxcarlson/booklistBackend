

```
## CREATE APP
$ mix phx.new --no-brunch --no-html book_list
$ cd book_list

## CONFIGURE DATABASE
# Configure in ~/.profile:
# BOOKLIST_DATABASE_URL="ecto://postgres@localhost/book_list"
# Configure in repo.ex: System.get_env("BOOKLIST_DATABASE_URL"
$ mix ecto.create

## CREATE USER MVC
$ mix phx.gen.json BookSpace User users username:string email:string

## CREATE BOOK MVC
$ mix phx.gen.json BookSpace Book books title:string author:string notes:text pages:integer pages_read:integer rating:integer public:boolean user_id:references:users

## MIGRATE
$ mix ecto.migrate

## ROUTES
resources "/users", UserController #, except: [:new, :edit]
resources "/books", BookController

## START APP
$ iex -S mix phx.server

## CREATE ONE USER RECORD
iex(1)> alias BookList.Repo; alias BookList.BookSpace.User
iex(3)> params = %{"username": "jxxcarlson", "email": "jxxcarlson@gmail.com"}
iex(5)> ucs = User.changeset(%User{}, params)
iex(6)> Repo.insert(ucs)

## VERIFY USER
iex(14)> Repo.get(User, 1)
iex(15)> Repo.all(User)

## CREATE ONE BOOK RECORD
iex(1)> alias BookList.Repo
iex(3)> alias BookList.BookSpace.Book
iex(4)> params = %{"user_id": 1, "title": "Turing's Vision", "author": "Chris Bernhardt", "pages": 189, "pages_read": 31, "notes": "Just started", "rating": 5}
iex(4)> bcs = Book.changeset(%Book{}, params)
iex(9)> Repo.insert(bcs)

## VERIFY BOOK
iex(14)> Repo.get(Book, 1)
iex(15)> Repo.all(Book)

```
