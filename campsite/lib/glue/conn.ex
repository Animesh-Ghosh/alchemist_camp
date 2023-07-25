defmodule Glue.Conn do
  defstruct req_path: "",
            resp_headers: [{"Content-Type", "text/html"}],
            resp_body: "",
            status: 200

  def put_resp_body(conn, body) do
    %{conn | resp_body: body}
  end

  def put_status(conn, code) do
    %{conn | status: code}
  end
end
