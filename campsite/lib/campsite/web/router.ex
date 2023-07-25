defmodule Campsite.Web.Router do
  def call(path) do
    content_for(path)
  end

  defp content_for("/") do
    "<h1>Hello from Campsite!</h1>"
  end

  defp content_for("/2") do
    "<h1>Hello from Campsite from here two!!</h1>"
  end

  defp content_for("/contact") do
    ~s(<h1>
      Find us on <a href="https://github.com/Animesh-Ghosh">GitHub</a>
      and <a href="https://twitter.com/theOnlyMaDDogx">Twitter</a>!
    </h1>)
  end

  defp content_for(_) do
    "<h1>Page not found! :(</h1>"
  end
end
