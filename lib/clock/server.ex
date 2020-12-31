defmodule Clock.Server do
  use GenServer
  alias Clock.{LEDAdapter, Core}

  @me __MODULE__
  def start_link(initial_state \\ default_options()) do
    GenServer.start_link(@me, initial_state, name: @me)
  end

  @impl true
  def init(args) do
    pins = args[:pins]
    time = args[:time] || default_time()
    send_ticks_fn = args[:send_ticks_fn] || (&default_send_ticks/0)
    led_adapter = args[:led_adapter] || LEDAdapter.Dev

    send_ticks_fn.()
    {:ok, Core.new(open_gpio_pins(led_adapter, pins), time)}
  end

  def tick, do: send(@me, :tick)
  def default_pins, do: %{0 => 21, 1 => 19, 2 => 6, 3 => 23, 4 => 12, 5 => 18}
  def default_time, do: Time.utc_now().second
  def default_send_ticks, do: :timer.send_interval(1_000, :tick)
  def send_ticks_60, do: :timer.send_interval(60_000, :tick)

  def default_options do
    %{
      pins: default_pins(),
      time: default_time(),
      send_ticks_fn: &default_send_ticks/0
    }
  end

  defp open_gpio_pins(module, pins) do
    for bit <- 0..5, into: %{}, do: {bit, LEDAdapter.open(pins[bit], module)}
  end

  defp set_leds(clock) do
    Enum.each(
      Core.status(clock),
      fn {led, state} -> LEDAdapter.set(led, state) end
    )

    clock
  end

  @impl true
  def handle_info(:tick, clock) do
    {
      :noreply,
      clock
      |> Core.tick()
      |> set_leds()
    }
  end
end
