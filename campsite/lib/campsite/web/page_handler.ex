defmodule Campsite.Web.PageHandler do
  def init({:tcp, :http}, req, router) do
    {:ok, req, router}
  end

  def handle(req, router) do
    {path, req} = :cowboy_req.path(req)
    conn = %Glue.Conn{req_path: path}
    conn = router.call(conn)

    {:ok, resp} =
      :cowboy_req.reply(
        conn.status,
        conn.resp_headers,
        conn.resp_body,
        req
      )

    {:ok, resp, router}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end
end
