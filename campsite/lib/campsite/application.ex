defmodule Campsite.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    start_cowboy()

    children = [
      # Starts a worker by calling: Campsite.Worker.start_link(arg)
      # {Campsite.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Campsite.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_cowboy() do
    root_route = {"/", :cowboy_static, {:priv_file, :campsite, "static/index.html"}}
    main_route = {:_, Campsite.Web.PageHandler, Campsite.Web.Router}
    static_route = {"/[...]", :cowboy_static, {:priv_dir, :campsite, "static"}}

    dispatch =
      :cowboy_router.compile([
        {:_,
         [
           root_route,
           main_route,
           static_route
         ]}
      ])

    opts = [port: 8080]
    env = [dispatch: dispatch]

    case :cowboy.start_http(:http, 10, opts, env: env) do
      {:ok, _pid} -> IO.puts("cowboy server running... Go to http://localhost:8080")
      _ -> IO.puts("Error starting cowboy web server!")
    end
  end
end
