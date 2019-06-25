defmodule KosynierzyWeb.Blog.PostView do
  use KosynierzyWeb, :view

  def format_date(nil), do: "N/D"

  def format_date(date) do
    Timex.format(date, "{0D}-{0M}-{YYYY}")
  end
end
