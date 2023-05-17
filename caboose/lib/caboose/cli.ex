defmodule Caboose.CLI do
  def main(args) do
    {parsed, args, invalid} =
      OptionParser.parse(args,
        strict: [lines: :integer, help: :boolean],
        aliases: [n: :lines, h: :help]
      )

    Caboose.start(parsed, args, invalid)
  end
end
