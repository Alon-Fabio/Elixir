defmodule Identicon do
  def main(input) do
    input
    |>hash_input
    |>pick_color
    |>build_grid
    |>filter_to_squares
    |>build_pixel_map
    |>draw_rectangle
    |>save_image(input)

  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
      |>:binary.bin_to_list
      #^This^ is equal to 'hex = :binary.bin_to_list(hex)'

    %Identicon.Image{hex: hex}
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid = 
      hex
      |>Enum.chunk_every(3, 3, :discard)
      |>Enum.map(&mirror_row/1)
      |>List.flatten
      |>Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    [first, second | _tail ] = row

    row ++[second, first ]
  end

  def filter_to_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({square, _i})->
      rem(square, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_num, index})->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def draw_rectangle(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    fill_color = :egd.color(color)
    image = :egd.create(250, 250)

    Enum.each pixel_map, fn({top_left, bottom_right}) ->
      :egd.filledRectangle(image, top_left ,bottom_right, fill_color)
    end

    :egd.render(image)
  end

  def save_image(image, name) do
    File.write("#{name}.png", image)
  end

end
# Identicon.main("alon")