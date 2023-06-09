defmodule StatWatch do
  def column_names do
    Enum.join(~w(DateTime Subscribers Videos Views), ",")
  end

  def run do
    fetch_stats()
    |> save_csv()
  end

  def fetch_stats do
    now = DateTime.to_string(%{DateTime.utc_now() | microsecond: {0, 0}})
    %{body: body} = HTTPoison.get!(stat_url())
    # %{items: [%{statistics: statistics} | _]} = Poison.decode!(body, keys: :atoms)

    # [
    #   now,
    #   statistics.subscriberCount,
    #   statistics.videoCount,
    #   statistics.viewCount
    # ]
    # |> Enum.join(",")
    body
  end

  def save_csv(row_of_stats) do
    filename = "stats.csv"

    unless File.exists?(filename) do
      File.write!(filename, column_names() <> "\n")
    end

    File.write!(filename, row_of_stats <> "\n", [:append])
  end

  def stat_url do
    youtube_api_v3 = "https://www.googleapis.com/youtube/v3/"
    channel = "id=" <> "<channel ID>"
    key = "key=" <> "<API key>"
    IO.puts("#{youtube_api_v3}channels?#{channel}&#{key}&part=statistics")
    "httpbin.org/get"
  end
end
