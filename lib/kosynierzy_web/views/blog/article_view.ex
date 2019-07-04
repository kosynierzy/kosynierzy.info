defmodule KosynierzyWeb.Blog.ArticleView do
  use KosynierzyWeb, :view

  @format "{0D}.{0M}.{YYYY}"

  def format_date(date) do
    with {:ok, date} <- Timex.format(date, @format) do
      date
    end
  end

  def link_to_article(conn, article) do
    with published_at <- article.published_at,
         year <- published_at.year,
         month <- published_at.month |> zeropad(),
         day <- published_at.day |> zeropad() do
      Routes.blog_article_path(conn, :show, year, month, day, article.slug)
    end
  end

  defp zeropad(num) do
    num |> Integer.to_string() |> String.pad_leading(2, "0")
  end
end
