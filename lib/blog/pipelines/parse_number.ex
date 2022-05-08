defmodule Blog.Pipeline.ParseNumber do
  use Pipeline
  require Logger

  alias Pipeline.State

  pipeline :parse_number do
    init(:build_state)
    step(:parse)
    then(:log)
  end

  def build_state(value), do: State.new(:parse_number, value)

  def parse_number(nil, _), do: {:error, "Nil number"}

  def parse_number(value, _) do
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
        Logger.info("Processed a valid number: #{value}")

      %State{value: value} ->
        Logger.warn("Invalid number detected: #{inspect(value)}")
    end
  end
end
