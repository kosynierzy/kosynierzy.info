defmodule Kosynierzy.BlogTest do
  use Kosynierzy.DataCase

  alias Kosynierzy.Blog

  describe "posts" do
    alias Kosynierzy.Blog.Post

    @valid_attrs %{title: "Blog post", content: "Blog content"}
    @update_attrs %{title: "Updated post", content: "Updated content"}
    @invalid_attrs %{title: "", content: "", published: ""}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Blog.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Blog.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Blog.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Blog.create_post(@valid_attrs)
    end

    test "create_post/1 with published: false keeps publication date empty" do
      attrs = Map.put(@valid_attrs, :published, false)

      assert {:ok, %Post{published_at: nil} = post} = Blog.create_post(attrs)
    end

    test "create_post/1 with published: true sets the publication date" do
      attrs = Map.put(@valid_attrs, :published, true)

      assert {:ok, %Post{published_at: %DateTime{}} = post} = Blog.create_post(attrs)
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Blog.update_post(post, @update_attrs)
    end

    test "update_post/2 with published: false unpublish the post" do
      post =
        @valid_attrs
        |> Map.put(:published, true)
        |> post_fixture()

      attrs = Map.put(@update_attrs, :published, false)

      assert {:ok, %Post{published_at: nil} = post} = Blog.update_post(post, attrs)
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, @invalid_attrs)
      assert post == Blog.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Blog.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Blog.change_post(post)
    end
  end
end
