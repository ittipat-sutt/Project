{{flutter_js}}
{{flutter_build_config}}

// Load CanvasKit from this project so web startup does not depend on gstatic.
_flutter.loader.load({
  config: {
    canvasKitBaseUrl: 'canvaskit/',
    canvasKitVariant: 'full',
  },
});
