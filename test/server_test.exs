defmodule Clock.ServerTest do
  use ExUnit.Case, async: false
  alias Clock.Server

  test "starts up successfully" do
    refute Process.whereis(Clock.Server)
    start()
    assert Clock.Server |> Process.whereis() |> Process.alive?()
  end

  test "tracks ticks" do
    start()

    assert time() == 0

    Server.tick()
    assert time() == 1

    Server.tick()
    assert time() == 2
  end

  defp start do
    start_link_arguments = [
      %{
        led_adapter: Clock.LEDAdapter.Test,
        send_ticks: fn -> :do_nothing end,
        pins: Server.default_pins(),
        time: 0
      }
    ]

    child_spec = %{
      id: Clock.Server,
      start: {Server, :start_link, start_link_arguments}
    }

    start_supervised!(child_spec)
  end

  defp time do
    :sys.get_state(Clock.Server).time
  end
end
