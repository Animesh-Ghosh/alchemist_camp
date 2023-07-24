defmodule Campsite.Web.PageHandler do
  def init({:tcp, :http}, req, state) do
    {:ok, req, state}
  end

  def handle(req, state) do
    headers = [{"Content-Type", "text/html"}]

    {:ok, resp} = :cowboy_req.reply(200, headers, content_for(state), req)
    {:ok, resp, :empty}
  end

  def content_for(:base) do
    "<h1>Hello from Campsite!</h1>"
  end

  def content_for(:two) do
    "<h1>Hello from Campsite from here two!!</h1>"
  end

  def content_for(:contact) do
    ~s(<h1>
      Find us on <a href="https://github.com/Animesh-Ghosh">GitHub</a>
      and <a href="https://twitter.com/theOnlyMaDDogx">Twitter</a>!
    </h1>)
  end

  def content_for(:others) do
    "<h1>Page not found! :(</h1>"
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
