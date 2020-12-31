import Config

# send_ticks_fn is set to 60k mili, 1 minute.
config :clock,
  pins: %{0 => 21, 1 => 19, 2 => 6, 3 => 23, 4 => 12, 5 => 18},
  led_adapter: Clock.LEDAdapter.Embedded,
  send_ticks_fn: &Clock.Server.send_ticks_60/0
