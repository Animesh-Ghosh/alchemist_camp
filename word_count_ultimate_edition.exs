filename =
  IO.gets("File name? (type h for help): ")
  |> String.trim()

if filename == "h" do
  IO.puts("""
  Usage: [filename] -[flags]
  Flags
  -l     displays line count
  -c     displays character count
  -w     displays word count (default)
  Multiple flags may be used. Example usage to display line and character count:

  samplefile.txt -lc
  """)
else
  parts = String.split(filename, "-")
  filename = List.first(parts) |> String.trim()

  flags =
    case Enum.at(parts, 1) do
      nil -> ~w[w]
      characters -> String.split(characters, "") |> Enum.filter(fn x -> x != "" end)
    end

  body = File.read!(filename)
  lines = String.split(body, ~r{(\n|\r|\r\n)})
  words = String.split(body, ~r{(\\n|[^\w'])+}) |> Enum.filter(fn x -> x != "" end)
  characters = String.split(body, "") |> Enum.filter(fn x -> x != "" end)

  Enum.each(flags, fn flag ->
    case flag do
      "l" -> IO.puts("Lines: #{Enum.count(lines)}")
      "w" -> IO.puts("Words: #{Enum.count(words)}")
      "c" -> IO.puts("Characters: #{Enum.count(characters)}")
      _ -> nil
    end
  end)
end
