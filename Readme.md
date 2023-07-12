CLI version of the haxe package [Geometrize Haxe](https://github.com/Tw1ddle/geometrize-haxe) based on the [Geometrize Lib Example](https://github.com/Tw1ddle/geometrize-lib-example)

## How to use

Build the executable and use it like this:

```
executable -i input.png -o output.svg -s 500 -t "circle"
```

## Parameters

| Parameter        | Default Value | Description                                                                           |
| ---------------- | ------------- | ------------------------------------------------------------------------------------- |
| -i \<file>       | /             | Your input file. Required parameter.                                                  |
| -o \<file>       | /             | Your output file. Required parameter.                                                 |
| -w \<width>      | /             | Width of the png in pixels. The height will be fit to that width. Required parameter. |
| -bg \<css color> | #000000       | Background color of the png. Optional parameter.                                      |

# How to build

Install haxe and all the dependencies in the `build.hxml` file
Build with `haxe build.hxml`

Copy the `GeometrizeCli` executable and put it in a directory that's in your PATH

Download my [SVG to Image CLI](https://github.com/ErikGaDev/svg-to-img-cli/releases) and put it in the same directory as the executable if you want to save the geometrized output to an SVG.
