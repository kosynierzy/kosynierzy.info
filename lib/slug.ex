defmodule Slug do
  @doc """
  Convert string to slug.

  ## Examples

      iex> Slug.slugify("Foo Bar Baz")
      "foo-bar-baz"
      iex> Slug.slugify("Pajace! \\"Pajace?\\" Pajace!")
      "pajace-pajace-pajace"
      iex> Slug.slugify("F0rever --- young  b@@b")
      "f0rever-young-bb"
      iex> Slug.slugify("Bo my jesteśmy nienormalni… albo 'normalni' inaczej.")
      "bo-my-jestesmy-nienormalni-albo-normalni-inaczej"
      iex> Slug.slugify("Stal 84:77 Śląsk, 28 września 2008")
      "stal-8477-slask-28-wrzesnia-2008"
      iex> Slug.slugify("Galeria (szukamy zdjęć) 2005/06")
      "galeria-szukamy-zdjec-200506"
      iex> Slug.slugify("Przekaż 1% *** podatku na WKS Śląsk")
      "przekaz-1-podatku-na-wks-slask"

  """
  def slugify(string) do
    :iconv.convert("utf-8", "ascii//translit", string)
    |> String.downcase()
    |> String.replace(~r/[^\w\s-]/, "")
    |> String.replace(~r/[\s-]+/, "-")
  end
end
