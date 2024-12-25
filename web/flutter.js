if (!_flutter) {
  var _flutter = {
    loader: {
      loadEntrypoint: function(config) {
        var entrypoint = document.createElement('script');
        entrypoint.src = 'main.dart.js';
        entrypoint.type = 'application/javascript';
        document.body.appendChild(entrypoint);
      }
    }
  };
}