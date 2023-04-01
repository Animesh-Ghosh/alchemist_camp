matcher = ~r{\.(jpg|jpeg|gif|png|bmp)$}
matched_files = File.ls!() |> Enum.filter(&Regex.match?(matcher, &1))

matched_count = Enum.count(matched_files)

IO.puts(
  "Matched #{matched_count} #{case matched_count do
    1 -> "file"
    _ -> "files"
  end}"
)

case File.mkdir("images") do
  :ok -> IO.puts("images directory created!")
  {:error, _} -> IO.puts("could not create images directory")
end

Enum.each(matched_files, fn matched_file_name ->
  case File.rename(matched_file_name, "images/#{matched_file_name}") do
    :ok -> IO.puts("#{matched_file_name} moved to images directory")
    {_, _} -> IO.puts("Error moving #{matched_file_name} to images directory")
  end
end)
