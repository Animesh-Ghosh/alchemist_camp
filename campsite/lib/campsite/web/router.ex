defmodule Campsite.Web.Router do
  import Glue.Conn

  def call(conn) do
    content_for(conn.req_path, conn)
  end

  defp content_for("/", conn) do
    put_resp_body(conn, "<h1>Hello from Campsite!</h1>")
  end

  defp content_for("/2", conn) do
    put_resp_body(conn, "<h1>Hello from Campsite from here two!!</h1>")
  end

  defp content_for("/contact", conn) do
    put_resp_body(conn, ~s(<h1>
      Find us on <a href="https://github.com/Animesh-Ghosh">GitHub</a>
      and <a href="https://twitter.com/theOnlyMaDDogx">Twitter</a>!
    </h1>))
  end

  defp content_for(_, conn) do
    conn
    |> put_resp_body("<h1>Page not found! :(</h1>")
    |> put_status(404)
  end
end
