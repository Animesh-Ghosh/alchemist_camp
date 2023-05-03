defmodule AlchemyMarkdownTest do
  use ExUnit.Case
  doctest AlchemyMarkdown

  test "italicizes" do
    markdown_string = "Something *important*"
    html_string = "<em>important</em>"
    assert AlchemyMarkdown.to_html(markdown_string) =~ html_string
  end

  test "expands big tags" do
    markdown_string = "Some ++big++ words"
    html_string = "<big>big</big> words"
    assert AlchemyMarkdown.to_html(markdown_string) =~ html_string
  end

  test "expands small tags" do
    markdown_string = "Some --small-- words"
    html_string = "<small>small</small> words"
    assert AlchemyMarkdown.to_html(markdown_string) =~ html_string
  end

  test "expands hr tags" do
    markdown_string1 = "stuff over the line\n---"
    markdown_string2 = "stuff over the line\n***"
    markdown_string3 = "stuff over the line\n- - -"
    markdown_string4 = "stuff over the line\n*  *  *"

    Enum.each(
      [markdown_string1, markdown_string2, markdown_string3, markdown_string4],
      fn markdown_string ->
        assert AlchemyMarkdown.hrs(markdown_string) =~ "stuff over the line\n<hr />"
      end
    )

    markdown_string5 = "stuff over the line*  *  *"
    assert AlchemyMarkdown.hrs(markdown_string5) == markdown_string5
  end
end
