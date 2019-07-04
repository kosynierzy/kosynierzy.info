defmodule Kosynierzy.CMSTest do
  use Kosynierzy.DataCase

  import Kosynierzy.Factory

  alias Kosynierzy.CMS
  alias Kosynierzy.CMS.Comment

  @valid_attrs %{
    author: "some author",
    author_email: "some author_email",
    content: "some content",
    ip: "some ip",
    url: "some url",
    user_agent: "some user_agent"
  }
  @update_attrs %{
    author: "some updated author",
    author_email: "some updated author_email",
    content: "some updated content",
    url: "some updated url"
  }
  @invalid_attrs %{
    author: nil,
    author_email: nil,
    content: nil,
    ip: nil,
    url: nil,
    user_agent: nil
  }

  describe "list_comments/0" do
    setup :create_comment

    test "returns all comments", %{comment: comment} do
      assert CMS.list_comments() == [comment]
    end
  end

  describe "get_comment!/1" do
    setup :create_comment

    test "returns the comment with given id", %{comment: comment} do
      assert CMS.get_comment!(comment.id) == comment
    end
  end

  describe "create_comment/3" do
    setup :create_article

    test "with valid data creates a comment", %{article: article} do
      assert {:ok, %Comment{} = comment} =
               CMS.create_comment(
                 article,
                 %{user_agent: "agent", ip: {127, 0, 0, 1}},
                 @valid_attrs
               )

      assert comment.author == "some author"
      assert comment.author_email == "some author_email"
      assert comment.content == "some content"
      assert comment.ip == %Postgrex.INET{address: {127, 0, 0, 1}, netmask: 32}
      assert comment.url == "some url"
      assert comment.user_agent == "agent"
    end

    test "with invalid data returns error changeset", %{article: article} do
      assert {:error, %Ecto.Changeset{}} =
               CMS.create_comment(
                 article,
                 %{user_agent: "agent", ip: {127, 0, 0, 1}},
                 @invalid_attrs
               )
    end
  end

  describe "update_comment/2" do
    setup :create_comment

    test "with valid data updates the comment", %{comment: comment} do
      assert {:ok, %Comment{} = comment} = CMS.update_comment(comment, @update_attrs)
      assert comment.author == "some updated author"
      assert comment.author_email == "some updated author_email"
      assert comment.content == "some updated content"
      assert comment.url == "some updated url"
    end

    test "with invalid data returns error changeset", %{comment: comment} do
      assert {:error, %Ecto.Changeset{}} = CMS.update_comment(comment, @invalid_attrs)
      assert comment == CMS.get_comment!(comment.id)
    end
  end

  describe "delete_comment/1" do
    setup :create_comment

    test "deletes the comment", %{comment: comment} do
      assert {:ok, %Comment{}} = CMS.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> CMS.get_comment!(comment.id) end
    end
  end

  describe "change_comment/1" do
    setup :create_comment

    test "change_comment/1 returns a comment changeset", %{comment: comment} do
      assert %Ecto.Changeset{} = CMS.change_comment(comment)
    end
  end

  defp create_article(_) do
    %{article: insert(:article)}
  end

  defp create_comment(_) do
    %{comment: insert(:comment)}
  end
end
