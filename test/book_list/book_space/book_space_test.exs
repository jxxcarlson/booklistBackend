defmodule BookList.BookSpaceTest do
  use BookList.DataCase

  alias BookList.BookSpace

  describe "users" do
    alias BookList.BookSpace.User

    @valid_attrs %{email: "some email", username: "some username"}
    @update_attrs %{email: "some updated email", username: "some updated username"}
    @invalid_attrs %{email: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> BookSpace.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert BookSpace.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert BookSpace.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = BookSpace.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BookSpace.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = BookSpace.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = BookSpace.update_user(user, @invalid_attrs)
      assert user == BookSpace.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = BookSpace.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> BookSpace.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = BookSpace.change_user(user)
    end
  end

  describe "books" do
    alias BookList.BookSpace.Book

    @valid_attrs %{author: "some author", notes: "some notes", pages: 42, pages_read: 42, public: true, rating: 42, title: "some title"}
    @update_attrs %{author: "some updated author", notes: "some updated notes", pages: 43, pages_read: 43, public: false, rating: 43, title: "some updated title"}
    @invalid_attrs %{author: nil, notes: nil, pages: nil, pages_read: nil, public: nil, rating: nil, title: nil}

    def book_fixture(attrs \\ %{}) do
      {:ok, book} =
        attrs
        |> Enum.into(@valid_attrs)
        |> BookSpace.create_book()

      book
    end

    test "list_books/0 returns all books" do
      book = book_fixture()
      assert BookSpace.list_books() == [book]
    end

    test "get_book!/1 returns the book with given id" do
      book = book_fixture()
      assert BookSpace.get_book!(book.id) == book
    end

    test "create_book/1 with valid data creates a book" do
      assert {:ok, %Book{} = book} = BookSpace.create_book(@valid_attrs)
      assert book.author == "some author"
      assert book.notes == "some notes"
      assert book.pages == 42
      assert book.pages_read == 42
      assert book.public == true
      assert book.rating == 42
      assert book.title == "some title"
    end

    test "create_book/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = BookSpace.create_book(@invalid_attrs)
    end

    test "update_book/2 with valid data updates the book" do
      book = book_fixture()
      assert {:ok, book} = BookSpace.update_book(book, @update_attrs)
      assert %Book{} = book
      assert book.author == "some updated author"
      assert book.notes == "some updated notes"
      assert book.pages == 43
      assert book.pages_read == 43
      assert book.public == false
      assert book.rating == 43
      assert book.title == "some updated title"
    end

    test "update_book/2 with invalid data returns error changeset" do
      book = book_fixture()
      assert {:error, %Ecto.Changeset{}} = BookSpace.update_book(book, @invalid_attrs)
      assert book == BookSpace.get_book!(book.id)
    end

    test "delete_book/1 deletes the book" do
      book = book_fixture()
      assert {:ok, %Book{}} = BookSpace.delete_book(book)
      assert_raise Ecto.NoResultsError, fn -> BookSpace.get_book!(book.id) end
    end

    test "change_book/1 returns a book changeset" do
      book = book_fixture()
      assert %Ecto.Changeset{} = BookSpace.change_book(book)
    end
  end
end
