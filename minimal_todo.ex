defmodule MinimalTodo do
  def start do
    filename = IO.gets("Name of .csv to load: ") |> String.trim()
    read(filename) |> parse |> get_command
    # parse file data
    # ask for command
    # (read todos, add todo, delete todos, load file, save files)
  end

  def get_command(data) do
    prompt = """
    Type the first letter of the command to be ran:
    A)dd a Todo R)ead Todos D)elete a Todo L)oad another .csv S)Save to a .csv
    """

    command = IO.gets(prompt) |> String.trim() |> String.downcase()

    case command do
      "r" -> show_todos(data)
      "d" -> delete_todo(data)
      "q" -> "Goodbye!"
      _ -> get_command(data)
    end
  end

  def delete_todo(data) do
    todo = IO.gets("Which Todo to delete?: ") |> String.trim()

    if Map.has_key?(data, todo) do
      IO.puts("ok.")
      new_data = Map.drop(data, [todo])
      IO.puts(~s{"#{todo}" deleted!})
      get_command(new_data)
    else
      IO.puts(~s{No Todo named "#{todo}"!})
      show_todos(data, false)
      delete_todo(data)
    end
  end

  def read(filename) do
    case File.read(filename) do
      {:ok, body} ->
        body

      {:error, reason} ->
        IO.puts(~s{Could not open "#{filename}"})
        IO.puts(~s{#{:file.format_error(reason)}})
        start()
    end
  end

  def parse(body) do
    [header | lines] = String.split(body, ~r{(\r\n|\r|\n)}) |> Enum.filter(fn x -> x != "" end)
    titles = tl(String.split(header, ","))
    parse_lines(lines, titles)
  end

  def parse_lines(lines, titles) do
    Enum.reduce(lines, %{}, fn line, acc ->
      [name | fields] = String.split(line, ",")
      data = Enum.zip(titles, fields) |> Enum.into(%{})
      Map.merge(acc, %{name => data})
    end)
  end

  def show_todos(data, next_command? \\ true) do
    items = Map.keys(data)
    IO.puts("Todos:")
    Enum.each(items, fn item -> IO.puts(item) end)

    if next_command? do
      get_command(data)
    end
  end
end
