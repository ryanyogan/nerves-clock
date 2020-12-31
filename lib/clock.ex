defmodule Clock do
  @moduledoc """
  Documentation for Clock.
  """
  @default_wait 200
  alias Clock.Blinker

  def blink(gpio, times, wait \\ @default_wait) do
    gpio
    |> Blinker.open()
    |> Blinker.blink_times(times, wait)

    :ok
  end

  def async_blink(gpio, times, wait \\ @default_wait) do
    Task.async(fn ->
      blink(gpio, times, wait)
    end)
  end
end
