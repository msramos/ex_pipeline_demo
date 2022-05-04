defmodule Blog.Pipeline.ParseNumber do
  use Pipeline
  require Logger

  alias Pipeline.State

  pipeline :echo do
    init(:build_state)
    step(:echo)
    then(:log)
  end

  def build_state(value), do: State.new(:echo, value)

  def echo(nil, _), do: {:error, "Nil number"}

  def echo(value, _) do
    case Integer.parse(value) do
      {number, ""} ->
        {:ok, number}

      _ ->
        {:error, "not a number"}
    end
  end

  def log(state, _) do
    case state do
      %State{value: value, valid?: true} ->
        Logger.info("valid echo: #{value}")

      %State{value: value} ->
        Logger.warn("invalid echo: #{inspect(value)}")
    end
  end
end
