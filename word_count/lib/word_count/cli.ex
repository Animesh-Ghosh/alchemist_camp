defmodule WordCount.CLI do
  def main(args) do
    {parsed, args, invalid} =
      OptionParser.parse(
        args,
        strict: [chars: :boolean, lines: :boolean, words: :boolean],
        aliases: [c: :chars, l: :lines, w: :words]
      )

    WordCount.start(parsed, args, invalid)
  end
end
