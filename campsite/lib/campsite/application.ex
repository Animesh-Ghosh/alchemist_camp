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
    route1 = {"/", Campsite.Web.PageHandler, :base}
    route2 = {"/2", Campsite.Web.PageHandler, :two}
    route3 = {"/contact", Campsite.Web.PageHandler, :contact}
    others = {:_, Campsite.Web.PageHandler, :others}

    dispatch = :cowboy_router.compile([{:_, [route1, route2, route3, others]}])
    opts = [port: 4000]
    env = [dispatch: dispatch]

    case :cowboy.start_http(:http, 10, opts, env: env) do
      {:ok, _pid} -> IO.puts("cowboy server running... Go to http://localhost:4000")
      _ -> IO.puts("Error starting cowboy web server!")
    end
  end
end
