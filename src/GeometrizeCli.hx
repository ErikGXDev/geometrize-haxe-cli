
package src;

import geometrize.exporter.ShapeJsonExporter;
import geometrize.shape.ShapeType.ShapeTypes;
import geometrize.Model.ShapeResult;
import format.swf.Data.ShapeData;
import geometrize.exporter.SvgExporter;
import haxe.io.Bytes;
import geometrize.Util;
import sys.io.FileInput;
import geometrize.bitmap.Bitmap;
import haxe.io.Path;
import geometrize.runner.ImageRunner;
import arguable.ArgParser;
import format.png.Tools;
import format.png.Data;

class GeometrizeCli {

  

  static function main() {


    var shapeMap:Map<String, Int> = [
      "rectangle" => ShapeTypes.RECTANGLE,
      "rotated_rectangle" => ShapeTypes.ROTATED_RECTANGLE,
      "triangle" => ShapeTypes.TRIANGLE,
      "ellipse" => ShapeTypes.ELLIPSE,
      "rotated_ellipse" => ShapeTypes.ROTATED_ELLIPSE,
      "circle" => ShapeTypes.CIRCLE,
      "line" => ShapeTypes.LINE
    ];

    ArgParser.delimiter = "-";
    
    var results = ArgParser.parse(Sys.args());

    if (!results.has("i") || !results.has("o")) {
      Sys.println("Did not specify input or output.");
      Sys.exit(1);
    }

    var verbose = false;
    if (results.has("v")) {
      verbose = true;
    }
    
    var inputPath = results.get("i").value;
    var outputPath = results.get("o").value;

    var splitPath = outputPath.split(".");
    var fileExt = splitPath[splitPath.length-1];

    var shapeAmt = 200;

    if (results.has("s")) {
      shapeAmt = Std.parseInt(results.get("s").value);
    }

    var shapeTypes = [ShapeTypes.CIRCLE, ShapeTypes.ELLIPSE, ShapeTypes.LINE, ShapeTypes.RECTANGLE, ShapeTypes.ROTATED_ELLIPSE, ShapeTypes.ROTATED_RECTANGLE, ShapeTypes.TRIANGLE];
    if (results.has("t")) {
      shapeTypes = [];
      var split = results.get("t").value.split(" ");
      for (i in split) {
        shapeTypes.push(shapeMap[i]);
      }
    }

    var alpha = 128;
    if (results.has("a")) {
      alpha = Std.parseInt(results.get("a").value);
    }

    var candidates = 500;
    if (results.has("c")) {
      candidates = Std.parseInt(results.get("c").value);
    }

    var mutations = 100;
    if (results.has("m")) {
      mutations = Std.parseInt(results.get("m").value);
    }
    
    var bitmap = readPNGImage(new Path(inputPath));

    var avgColor = Util.getAverageImageColor(bitmap);
    
    var runner = new ImageRunner(bitmap, avgColor);

    var shapes: Array<ShapeResult> = [];


    for (i in 0...shapeAmt) {
      var shapeData = runner.step({shapeTypes: shapeTypes, alpha: alpha, candidateShapesPerStep: candidates, shapeMutationsPerStep: mutations });
      for (shape in shapeData) {
        shapes.push(shape);
      }
    }

    if (fileExt == "svg" || fileExt == "png") {
      var data = SvgExporter.export(shapes, bitmap.width, bitmap.height);

      // Insert a svg <rect> for the background

      var hex = rgbToHex(avgColor.r, avgColor.b, avgColor.g);

      var splitData = data.split("\n");

      splitData.insert(2, "<rect width=\""+bitmap.width+"\" height=\""+bitmap.height+"\" fill=\""+hex+"\" />");

      var finishedData = splitData.join("\n");

      var svgPath = new Path(outputPath).toString();
      
      sys.io.File.saveContent(svgPath, finishedData);

      if (fileExt == "png") {
        var programPath = Path.directory(Sys.programPath());
        var execPath = Path.join([programPath, "./svg-to-img-cli"]);
        var fileName = Path.withoutExtension(Path.withoutDirectory(outputPath));
        Sys.command(execPath + " -i ./" + svgPath + " -o ./" + fileName + ".png -w " + bitmap.width);
      }
    } else if (fileExt == "json") {
      var finishedData = ShapeJsonExporter.export(shapes);

      sys.io.File.saveContent(new Path(outputPath).toString(), finishedData);
    } else {
      Sys.println("Did not recognize output file extension.");
      Sys.println("Supported file extensions: .svg, .png, .json");
    }

    
    
  };

  private static function log(v: Dynamic, verbose: Bool) {
    if (verbose){
      trace(v);
    }
  }
    

  private static function readPNGImage(filePath:Path):Bitmap {
    try {
      var handle:FileInput = sys.io.File.read(filePath.toString(), true);
      var d:Data = new format.png.Reader(handle).read();
      var hdr:Header = format.png.Tools.getHeader(d);
      handle.close();

      // Convert data to RGBA format
      var bytes = Tools.extract32(d);
      Tools.reverseBytes(bytes);
      var rgba = argbToRgba(bytes);

      return Bitmap.createFromBytes(hdr.width, hdr.height, rgba);
    } catch (e:Dynamic) {
      return null;
    }
  }

  public static inline function argbToRgba(bytes:Bytes):Bytes {
		Sure.sure(bytes != null);
		Sure.sure(bytes.length % 4 == 0);
		
		var length:Int = bytes.length;
		var i:Int = 0;
		while (i < length) {
			var a = bytes.get(i);
			var r = bytes.get(i + 1);
			var g = bytes.get(i + 2);
			var b = bytes.get(i + 3);
			bytes.set(i, r);
			bytes.set(i + 1, g);
			bytes.set(i + 2, b);
			bytes.set(i + 3, a);
			i += 4;
		}
		return bytes;
	}

  private static var hexCodes = "0123456789ABCDEF";

	public static function rgbToHex(r:Int, g:Int, b:Int):String
	{
		var hexString = "#";
		//Red
		hexString += hexCodes.charAt(Math.floor(r/16));
		hexString += hexCodes.charAt(r%16);
		//Green
		hexString += hexCodes.charAt(Math.floor(g/16));
		hexString += hexCodes.charAt(g%16);
		//Blue
		hexString += hexCodes.charAt(Math.floor(b/16));
		hexString += hexCodes.charAt(b%16);
		
		return hexString;
	}
}