// Generated by CoffeeScript 1.10.0
(function() {
  var DG, DrawDataGenerator;

  DrawDataGenerator = (function() {
    function DrawDataGenerator(parent) {
      var self, svg;
      this.parent = parent != null ? parent : 'body';
      if (!d3) {
        console.error('you need d3.js to use the data-generator');
        return;
      }
      self = this;
      this.data = [];
      this.latLngData = [];
      this.width = 900;
      this.height = 810;
      d3.select('body').style('background-color', 'grey');
      svg = d3.select(this.parent).append('svg').attr({
        width: this.width,
        height: this.height
      }).style('border', '1px solid darkgray');
      this.g = svg.append('g');
      svg.on('mousemove', function() {
        self.pos = d3.mouse(this);
        if (d3.event.shiftKey && !this.interval) {
          return this.interval = setInterval(function() {
            return self.draw();
          }, 100);
        } else if (!d3.event.shiftKey && this.interval) {
          clearInterval(this.interval);
          return this.interval = null;
        }
      });
      document.onkeypress = function(e) {
        if (e.which === 32) {
          return self.convertData();
        }
      };
    }

    DrawDataGenerator.prototype.draw = function() {
      this.data.push(this.pos);
      return this.g.selectAll('circle').data(this.data).enter().append('circle').attr({
        cx: function(d) {
          return d[0];
        },
        cy: function(d) {
          return d[1];
        },
        r: 5,
        fill: 'blue',
        opacity: .3,
        stroke: 'darkblue'
      });
    };

    DrawDataGenerator.prototype.clear = function() {
      this.data = [];
      return this.g.selectAll('circle').data([]).exit().remove();
    };

    DrawDataGenerator.prototype.convertData = function() {
      var file, i, len, pos, ref, x, y;
      ref = this.data;
      for (i = 0, len = ref.length; i < len; i++) {
        pos = ref[i];
        x = pos[0];
        y = pos[1];
        this.latLngData.push([Math.round10(-(y - (this.height / 2)) * (180 / this.height), -4), Math.round10((x - (this.width / 2)) * (360 / this.width), -4)]);
      }
      console.log("latitude/longitude output:");
      console.log(this.latLngData);
      file = document.createElement('a');
      file.download = 'latLng.json';
      file.textContent = 'Download';
      file.href = 'data:application/json;base64,' + window.btoa(unescape(encodeURIComponent(JSON.stringify(this.latLngData))));
      return document.body.appendChild(file);
    };

    return DrawDataGenerator;

  })();

  DG = new DrawDataGenerator('main');

}).call(this);
