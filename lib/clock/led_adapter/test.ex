defmodule Clock.LEDAdapter.Test do
  defstruct pin: 0, lit: false, history: []
  alias Clock.LEDAdapter
  @behaviour LEDAdapter

  @impl LEDAdapter
  def open(pin) do
    %__MODULE__{
      pin: pin,
      lit: false,
      history: [:open]
    }
  end

  @impl LEDAdapter
  def on(led) do
    %{led | lit: true, history: [:on | led.history]}
  end

  @impl LEDAdapter
  def off(led) do
    %{led | lit: false, history: [:off | led.history]}
  end
end
