defmodule Campsite.Web.Router do
  @template_path "lib/campsite/web/templates"

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

  defp content_for("/hello", conn) do
    conn
    |> assign(:adj, "mysterious")
    |> render("hello")
  end

  defp content_for(other, conn) do
    name = Path.basename(other)

    if Enum.member?(get_templates(), name) do
      render(conn, name)
    else
      not_found(conn, name)
    end
  end

  defp not_found(conn, route) do
    conn
    |> put_resp_body("<h1>Page not found at #{route}! :(</h1>")
    |> put_status(404)
  end

  defp render(conn, name) do
    body = EEx.eval_file("#{@template_path}/#{name}.eex", Map.to_list(conn.assigns))
    put_resp_body(conn, body)
  end

  defp get_templates() do
    for template <- Path.wildcard("#{@template_path}/*.eex") do
      Path.basename(template, ".eex")
    end
  end
end
