defmodule Identicon.Image do
  defstruct hex: nil, color: {}, grid: nil, pixel_map: nil
end

# the variable looks like thius :
#   %Identicon.Image{hex: value, color: {value}, grig: value, pixel_map: value}