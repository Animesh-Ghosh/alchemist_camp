defmodule StatWatch do
  def column_names do
    Enum.join(~w(datetime url origin headers args), ",")
  end

  def run do
    fetch_stats()
    |> save_csv()
  end

  def fetch_stats do
    now = DateTime.to_string(%{DateTime.utc_now() | microsecond: {0, 0}})
    %{body: body} = HTTPoison.get!(stat_url())
    %{url: url, origin: origin, headers: headers, args: args} = Poison.decode!(body, keys: :atoms)

    [
      now,
      url,
      origin,
      Poison.encode!(headers),
      Poison.encode!(args)
    ]
    |> Enum.join(",")
  end

  def save_csv(row_of_stats) do
    filename = "stats.csv"

    unless File.exists?(filename) do
      File.write!(filename, column_names() <> "\n")
    end

    File.write!(filename, row_of_stats <> "\n", [:append])
  end

  def stat_url do
    "https://httpbin.org/get"
  end
end
