CLI version of the haxe package [Geometrize Haxe](https://github.com/Tw1ddle/geometrize-haxe) based on the [Geometrize Lib Example](https://github.com/Tw1ddle/geometrize-lib-example)

## How to use

Build the executable and use it like this:

```
executable -i input.png -o output.svg -s 500 -t "circle rotated_ellipse"
```

## Parameters

| Flag | Description                                                        | Default                                                                                                                                             |
| ---- | ------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| i    | The filepath to load the input image from                          | ~                                                                                                                                                   |
| o    | The filepath to save the output image, JSON data or SVG            | ~                                                                                                                                                   |
| t    | The types of shapes to use                                         | One or more of: rectangle, rotated_rectangle, triangle, ellipse, rotated_ellipse, circle, line, quadratic_bezier, polyline (**separated by space**) |
| s    | Number of shapes to use in the output image                        | 200                                                                                                                                                 |
| c    | The number of candidate shapes per shape added to the output image | 500                                                                                                                                                 |
| m    | The maximum number of times to mutate each candidate shape         | 100                                                                                                                                                 |
| a    | The opacity (0-255) of each shape added to the output image        | 128                                                                                                                                                 |

# How to build

Install haxe and all the dependencies in the `build.hxml` file
Build with `haxe build.hxml`

Copy the `GeometrizeCli` executable and put it in a directory that's in your PATH

Download my [SVG to Image CLI](https://github.com/ErikGaDev/svg-to-img-cli/releases) and put it in the same directory as the executable if you want to save the geometrized output to an SVG.
