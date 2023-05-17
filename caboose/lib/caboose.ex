defmodule Caboose do
  @default_lines 10

  def start(parsed, filename, invalid) do
    help_flag? = Enum.member?(parsed, {:help, true})

    if Enum.count(filename) != 1 or invalid != [] or help_flag? do
      unless help_flag?, do: IO.puts("Bad Input\n")
      show_help()
    else
      flags = Enum.into(parsed, %{})
      read_file(filename, flags)
    end
  end

  def show_help do
    IO.puts("""
    Usage: caboose filename [flags]

    Flags:
    --lines|-n [number] displays last n lines of the file
    --help|-h  shows this message

    If no flags are used, caboose displays the last 10 lines of a file.
    Example usage:

    caboose file.txt
    caboose file.txt --lines 20
    """)
  end

  def read_file(filename, flags) do
    body = File.read!(filename)
    lines = String.split(body, ~r{\r|\n|\r\n})
    num_displayed = if flags[:lines], do: flags[:lines], else: @default_lines

    lines
    |> Enum.take(-num_displayed)
    |> Enum.join("\n")
    |> IO.puts()
  end
end
