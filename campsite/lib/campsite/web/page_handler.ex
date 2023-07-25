defmodule Campsite.Web.PageHandler do
  def init({:tcp, :http}, req, router) do
    {:ok, req, router}
  end

  def handle(req, router) do
    headers = [{"Content-Type", "text/html"}]

    {path, req} = :cowboy_req.path(req)
    {:ok, resp} = :cowboy_req.reply(200, headers, router.call(path), req)
    {:ok, resp, router}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
