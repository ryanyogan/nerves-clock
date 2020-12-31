import Config

config :clock,
  pins: %{0 => 26, 1 => 13, 2 => 6, 3 => 5, 4 => 16, 5 => 12},
  led_adapter: Clock.LEDAdapter.Embedded
