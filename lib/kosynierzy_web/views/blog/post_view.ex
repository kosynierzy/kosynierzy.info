defmodule KosynierzyWeb.Blog.PostView do
  use KosynierzyWeb, :view

  @format "{0D}.{0M}.{YYYY}"

  def format_date(date) do
    with {:ok, date} <- Timex.format(date, @format) do
      date
    end
  end
end
