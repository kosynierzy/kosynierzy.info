defmodule Kosynierzy.Factory do
  use ExMachina.Ecto, repo: Kosynierzy.Repo

  alias Kosynierzy.CMS.Article
  alias Kosynierzy.CMS.Comment

  def article_factory do
    with title <- sequence(:title, &"You know nothing no. (Part #{&1})"),
         slug <- Slug.slugify(title) do
      %Article{
        title: title,
        slug: slug,
        content: "Lorem ipsum",
        published_at: Timex.now()
      }
    end
  end

  def comment_factory do
    %Comment{
      article: build(:article),
      author: "Jon Snow",
      author_email: "jon.snow@example.com",
      ip: {192, 168, 0, 1},
      user_agent: "black coat",
      content: "You know nothing"
    }
  end
end
