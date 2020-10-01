import 'jsonloader.dart';
import 'maths.dart';


class Intersection {
    Frame frame;
    double distance;
    Surface surface;

    Intersection(this.frame, this.surface, this.distance);

    // convenience getters
    Point  get o => frame.o;
    Normal get n => Normal.fromDirection(frame.z);
    Material get material => surface.material;
}


class Material {
    var kd = RGBColor.white();
    var ks = RGBColor.black();
    var n  = 10.0;
    var kr = RGBColor.black();

    Material();

    Material.fromJson(JsonLoader loader) {
        kd = loader.loadObject('kd', (d)=>RGBColor.fromJson(d)) ?? kd;
        ks = loader.loadObject('ks', (d)=>RGBColor.fromJson(d)) ?? ks;
        n  = loader.loadDouble('n')                             ?? n;
        kr = loader.loadObject('kr', (d)=>RGBColor.fromJson(d)) ?? kr;
    }
}


class Surface {
    var type     = 'sphere';
    var size     = 1.0;
    var frame    = Frame();
    var material = Material();

    Surface();

    Surface.fromJson(JsonLoader loader) {
        type     = loader.loadString('type')                                ?? type;
        size     = loader.loadDouble('size')                                ?? size;
        frame    = loader.loadObject('frame',    (d)=>Frame.fromJson(d))    ?? frame;
        material = loader.loadObject('material', (d)=>Material.fromJson(d)) ?? material;
    }

    String toString() => 'Surface(type:$type, size:$size, frame:$frame)';
}


class Light {
    var frame     = Frame();
    var intensity = RGBColor(1, 1, 1);

    Light();

    Light.fromJson(JsonLoader loader) {
        frame     = loader.loadObject('frame',     (d)=>Frame.fromJson(d))    ?? frame;
        intensity = loader.loadObject('intensity', (d)=>RGBColor.fromJson(d)) ?? intensity;
    }
}


class Camera {
    var sensorSize     = Size2(1, 1);
    var sensorDistance = 1.0;
    var eye            = Point(0, 0, 1);
    var target         = Point(0, 0, 0);
    var up             = Direction(0, 1, 0);

    Camera();

    Camera.fromJson(JsonLoader loader) {
        sensorSize     = loader.loadObject('sensorSize',     (d)=>Size2.fromJson(d))     ?? sensorSize;
        sensorDistance = loader.loadObject('sensorDistance', (d)=>NumDouble.fromJson(d)) ?? sensorDistance;
        eye            = loader.loadObject('eye',            (d)=>Point.fromJson(d))     ?? eye;
        target         = loader.loadObject('target',         (d)=>Point.fromJson(d))     ?? target;
        up             = loader.loadObject('up',             (d)=>Direction.fromJson(d)) ?? up;
    }

    // convenience getter (note: _frame is cached, based on eye, target, up)
    Frame _frame;
    Frame get frame {
        return _frame ??= Frame.lookAt(eye, target, up);
    }
}


class Scene {
    var camera              = Camera();
    var resolution          = Size2i(512, 512);
    var pixelSamples        = 1;
    var backgroundIntensity = RGBColor(0.2, 0.2, 0.2);
    var ambientIntensity    = RGBColor(0.2, 0.2, 0.2);
    var lights              = [ Light() ];
    var surfaces            = [ Surface() ];

    Scene();

    Scene.fromJson(JsonLoader loader) {
        camera              = loader.loadObject('camera',              (d)=>Camera.fromJson(d))   ?? camera;
        resolution          = loader.loadObject('resolution',          (d)=>Size2i.fromJson(d))   ?? resolution;
        pixelSamples        = loader.loadInt   ('pixelSamples')                                   ?? pixelSamples;
        backgroundIntensity = loader.loadObject('backgroundIntensity', (d)=>RGBColor.fromJson(d)) ?? backgroundIntensity;
        ambientIntensity    = loader.loadObject('ambientIntensity',    (d)=>RGBColor.fromJson(d)) ?? ambientIntensity;
        lights              = loader.loadListOf<Light>('lights',       (d)=>Light.fromJson(d))    ?? lights;
        surfaces            = loader.loadListOf<Surface>('surfaces',   (d)=>Surface.fromJson(d))  ?? surfaces;
    }
}
