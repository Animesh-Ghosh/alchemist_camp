defmodule MinimalTodo do
  def start do
    input = IO.gets("Create a new .csv? (y/n): ") |> String.trim()

    if input == "y" do
      create_initial_todo() |> get_command
    else
      load_csv()
    end

    # parse file data
    # ask for command
    # (read todos, add todo, delete todos, load file, save files)
  end

  def create_initial_todo do
    titles = create_headers()
    name = get_item_name(%{})
    fields = Enum.map(titles, &field_from_user(&1))
    IO.puts(~s{New Todo "#{name}" added})
    %{name => Enum.into(fields, %{})}
  end

  def create_headers do
    IO.puts("""
    What data should each Todo have?
    Enter field names one by one and an empty line when done
    """)

    create_header([])
  end

  def create_header(headers) do
    case IO.gets("Add field: ") |> String.trim() do
      "" -> headers
      header -> create_header([header | headers])
    end
  end

  def load_csv do
    filename = IO.gets("Name of .csv to load: ") |> String.trim()
    read(filename) |> parse |> get_command
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

  def get_command(data) do
    prompt = """
    Type the first letter of the command to be ran:
    A)dd a Todo R)ead Todos D)elete a Todo L)oad another .csv S)ave to a .csv
    """

    command = IO.gets(prompt) |> String.trim() |> String.downcase()

    case command do
      "r" -> show_todos(data)
      "a" -> add_todo(data)
      "d" -> delete_todo(data)
      "l" -> load_csv()
      "s" -> save_csv(data)
      "q" -> "Goodbye!"
      _ -> get_command(data)
    end
  end

  def show_todos(data, next_command? \\ true) do
    items = Map.keys(data)
    IO.puts("Todos:")
    Enum.each(items, fn item -> IO.puts(item) end)

    if next_command? do
      get_command(data)
    end
  end

  def add_todo(data) do
    name = get_item_name(data)
    titles = get_fields(data)

    fields = Enum.map(titles, fn title -> field_from_user(title) end)
    new_todo = %{name => Enum.into(fields, %{})}
    IO.puts(~s{New Todo "#{name}" added.})
    new_data = Map.merge(data, new_todo)
    get_command(new_data)
  end

  def get_item_name(data) do
    name = IO.gets("Enter name of new Todo: ") |> String.trim()

    if Map.has_key?(data, name) do
      IO.puts("Todo exists already!")
      get_item_name(data)
    else
      name
    end
  end

  def get_fields(data) do
    data[hd(Map.keys(data))] |> Map.keys()
  end

  def field_from_user(field) do
    value = IO.gets("#{field}: ") |> String.trim()

    case value do
      _ -> {field, value}
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

  def prepare_csv(data) do
    headers = ["Item" | get_fields(data)]
    items = Map.keys(data)
    item_rows = Enum.map(items, fn item -> [item | Map.values(data[item])] end)
    rows = [headers | item_rows]
    row_strings = Enum.map(rows, &Enum.join(&1, ","))
    Enum.join(row_strings, "\n")
  end

  def save_csv(data) do
    filename = IO.gets(".csv filename to save: ") |> String.trim()
    prepared_csv = prepare_csv(data)

    case File.write(filename, prepared_csv) do
      :ok ->
        IO.puts("CSV saved")
        get_command(data)

      {:error, reason} ->
        IO.puts(~s{Could not save "#{filename}"})
        IO.puts(~s{#{:file.format_error(reason)}})
        get_command(data)
    end
  end
end
