define(['d3'], function(d3) {
  var clear, create_frame, draw, graph, set_axis, tick_format;
  clear = function(id) {
    return d3.select("#" + id + "-graph svg").remove();
  };
  tick_format = function(v, m) {
    var t;
    t = v * 10000;
    if (m * 10000 > 4) {
      return t.toFixed(0);
    } else {
      return t.toFixed(1);
    }
  };
  create_frame = function(data, y_range, size) {
    var frame, x, xAxis, y, yAxis;
    x = d3.time.scale().domain(d3.extent(data, function(d) {
      return d.date;
    })).range([0, size.width]);
    xAxis = d3.svg.axis().scale(x).orient('bottom').ticks(4);
    y = d3.scale.linear().domain([y_range.min, y_range.max]).range([size.height, 0]);
    yAxis = d3.svg.axis().scale(y).orient('left').ticks(4);
    return frame = {
      x: x,
      xAxis: xAxis,
      y: y,
      yAxis: yAxis
    };
  };
  set_axis = function(container, xAxis, dx, yAxis, dy) {
    container.append('g').attr({
      "class": 'x axis',
      transform: "translate(0," + dy + ")"
    }).call(xAxis);
    return container.append('g').attr({
      "class": 'y axis',
      transform: "translate(" + dx + ", 0)"
    }).call(yAxis);
  };
  draw = function(id) {
    var container, svg;
    svg = d3.select("#" + id + "-graph").append('svg').attr({
      version: "1.1",
      baseProfile: "full",
      xmlns: "http://www.w3.org/2000/svg",
      width: d3.select("#" + id + "-graph").node().clientWidth,
      height: _g.base_graph.height()
    });
    container = svg.append('g').attr({
      id: id,
      "class": "graph",
      transform: "translate(47,0)"
    });
    return container;
  };
  return graph = {
    clear: clear,
    draw: draw,
    set_axis: set_axis,
    tick_format: tick_format,
    create_frame: create_frame
  };
});

//# sourceMappingURL=data:application/json;charset=utf8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbImdyYXBoLmNvZmZlZSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUFBQSxNQUFBLENBQU8sQ0FBQyxJQUFELENBQVAsRUFBZSxTQUFDLEVBQUQ7QUFDYixNQUFBO0VBQUEsS0FBQSxHQUFRLFNBQUMsRUFBRDtXQUNOLEVBQUUsQ0FBQyxNQUFILENBQVUsR0FBQSxHQUFLLEVBQUwsR0FBUyxZQUFuQixDQUErQixDQUFDLE1BQWhDLENBQUE7RUFETTtFQUlSLFdBQUEsR0FBYyxTQUFDLENBQUQsRUFBRyxDQUFIO0FBQ1osUUFBQTtJQUFBLENBQUEsR0FBSSxDQUFBLEdBQUU7SUFFTixJQUFHLENBQUEsR0FBRSxLQUFGLEdBQVUsQ0FBYjtBQUNFLGFBQU8sQ0FBQyxDQUFDLE9BQUYsQ0FBVSxDQUFWLEVBRFQ7S0FBQSxNQUFBO0FBR0UsYUFBTyxDQUFDLENBQUMsT0FBRixDQUFVLENBQVYsRUFIVDs7RUFIWTtFQVNkLFlBQUEsR0FBZSxTQUFDLElBQUQsRUFBTyxPQUFQLEVBQWdCLElBQWhCO0FBQ2IsUUFBQTtJQUFBLENBQUEsR0FBSSxFQUFFLENBQUMsSUFBSSxDQUFDLEtBQVIsQ0FBQSxDQUNGLENBQUMsTUFEQyxDQUNNLEVBQUUsQ0FBQyxNQUFILENBQVUsSUFBVixFQUFnQixTQUFDLENBQUQ7YUFBTyxDQUFDLENBQUM7SUFBVCxDQUFoQixDQUROLENBRUYsQ0FBQyxLQUZDLENBRUssQ0FBQyxDQUFELEVBQUksSUFBSSxDQUFDLEtBQVQsQ0FGTDtJQUlKLEtBQUEsR0FBUSxFQUFFLENBQUMsR0FBRyxDQUFDLElBQVAsQ0FBQSxDQUNOLENBQUMsS0FESyxDQUNDLENBREQsQ0FFTixDQUFDLE1BRkssQ0FFRSxRQUZGLENBR04sQ0FBQyxLQUhLLENBR0MsQ0FIRDtJQUtSLENBQUEsR0FBSSxFQUFFLENBQUMsS0FBSyxDQUFDLE1BQVQsQ0FBQSxDQUNGLENBQUMsTUFEQyxDQUNNLENBQUMsT0FBTyxDQUFDLEdBQVQsRUFBYyxPQUFPLENBQUMsR0FBdEIsQ0FETixDQUVGLENBQUMsS0FGQyxDQUVNLENBQUMsSUFBSSxDQUFDLE1BQU4sRUFBYyxDQUFkLENBRk47SUFJSixLQUFBLEdBQVEsRUFBRSxDQUFDLEdBQUcsQ0FBQyxJQUFQLENBQUEsQ0FDTixDQUFDLEtBREssQ0FDQyxDQURELENBRU4sQ0FBQyxNQUZLLENBRUUsTUFGRixDQUdOLENBQUMsS0FISyxDQUdDLENBSEQ7QUFLUixXQUFPLEtBQUEsR0FDTDtNQUFBLENBQUEsRUFBRyxDQUFIO01BQ0EsS0FBQSxFQUFPLEtBRFA7TUFFQSxDQUFBLEVBQUcsQ0FGSDtNQUdBLEtBQUEsRUFBTyxLQUhQOztFQXBCVztFQTBCZixRQUFBLEdBQVcsU0FBQyxTQUFELEVBQVksS0FBWixFQUFtQixFQUFuQixFQUF1QixLQUF2QixFQUE4QixFQUE5QjtJQUNULFNBQVMsQ0FBQyxNQUFWLENBQWlCLEdBQWpCLENBQ0UsQ0FBQyxJQURILENBRUk7TUFBQSxDQUFBLEtBQUEsQ0FBQSxFQUFXLFFBQVg7TUFDQSxTQUFBLEVBQVcsY0FBQSxHQUFnQixFQUFoQixHQUFvQixHQUQvQjtLQUZKLENBS0UsQ0FBQyxJQUxILENBS1EsS0FMUjtXQU9BLFNBQVMsQ0FBQyxNQUFWLENBQWlCLEdBQWpCLENBQ0UsQ0FBQyxJQURILENBRUk7TUFBQSxDQUFBLEtBQUEsQ0FBQSxFQUFXLFFBQVg7TUFDQSxTQUFBLEVBQVcsWUFBQSxHQUFjLEVBQWQsR0FBa0IsTUFEN0I7S0FGSixDQUtFLENBQUMsSUFMSCxDQUtRLEtBTFI7RUFSUztFQWdCWCxJQUFBLEdBQU8sU0FBQyxFQUFEO0FBQ0wsUUFBQTtJQUFBLEdBQUEsR0FBTSxFQUFFLENBQUMsTUFBSCxDQUFVLEdBQUEsR0FBSyxFQUFMLEdBQVMsUUFBbkIsQ0FBMkIsQ0FBQyxNQUE1QixDQUFtQyxLQUFuQyxDQUNKLENBQUMsSUFERyxDQUVGO01BQUEsT0FBQSxFQUFhLEtBQWI7TUFDQSxXQUFBLEVBQWEsTUFEYjtNQUVBLEtBQUEsRUFBYSw0QkFGYjtNQUdBLEtBQUEsRUFBUyxFQUFFLENBQUMsTUFBSCxDQUFVLEdBQUEsR0FBSyxFQUFMLEdBQVMsUUFBbkIsQ0FBMkIsQ0FBQyxJQUE1QixDQUFBLENBQWtDLENBQUMsV0FINUM7TUFJQSxNQUFBLEVBQVMsRUFBRSxDQUFDLFVBQVUsQ0FBQyxNQUFkLENBQUEsQ0FKVDtLQUZFO0lBUU4sU0FBQSxHQUFZLEdBQUcsQ0FBQyxNQUFKLENBQVcsR0FBWCxDQUNWLENBQUMsSUFEUyxDQUVSO01BQUEsRUFBQSxFQUFJLEVBQUo7TUFDQSxDQUFBLEtBQUEsQ0FBQSxFQUFPLE9BRFA7TUFFQSxTQUFBLEVBQVcsaUJBRlg7S0FGUTtBQU1aLFdBQU87RUFmRjtBQWtCUCxTQUFPLEtBQUEsR0FDTDtJQUFBLEtBQUEsRUFBVSxLQUFWO0lBQ0EsSUFBQSxFQUFVLElBRFY7SUFFQSxRQUFBLEVBQVUsUUFGVjtJQUlBLFdBQUEsRUFBYSxXQUpiO0lBTUEsWUFBQSxFQUFrQixZQU5sQjs7QUEzRVcsQ0FBZiIsImZpbGUiOiJncmFwaC5qcyIsInNvdXJjZXNDb250ZW50IjpbImRlZmluZSBbJ2QzJ10sIChkMykgLT5cbiAgY2xlYXIgPSAoaWQpIC0+XG4gICAgZDMuc2VsZWN0KFwiIyN7IGlkIH0tZ3JhcGggc3ZnXCIpLnJlbW92ZSgpXG5cblxuICB0aWNrX2Zvcm1hdCA9ICh2LG0pIC0+XG4gICAgdCA9IHYqMTAwMDBcblxuICAgIGlmIG0qMTAwMDAgPiA0XG4gICAgICByZXR1cm4gdC50b0ZpeGVkKDApXG4gICAgZWxzZVxuICAgICAgcmV0dXJuIHQudG9GaXhlZCgxKVxuXG5cbiAgY3JlYXRlX2ZyYW1lID0gKGRhdGEsIHlfcmFuZ2UsIHNpemUpIC0+XG4gICAgeCA9IGQzLnRpbWUuc2NhbGUoKVxuICAgICAgLmRvbWFpbiBkMy5leHRlbnQoZGF0YSwgKGQpIC0+IGQuZGF0ZSlcbiAgICAgIC5yYW5nZSBbMCwgc2l6ZS53aWR0aF1cblxuICAgIHhBeGlzID0gZDMuc3ZnLmF4aXMoKVxuICAgICAgLnNjYWxlIHhcbiAgICAgIC5vcmllbnQgJ2JvdHRvbSdcbiAgICAgIC50aWNrcyA0XG5cbiAgICB5ID0gZDMuc2NhbGUubGluZWFyKClcbiAgICAgIC5kb21haW4gW3lfcmFuZ2UubWluLCB5X3JhbmdlLm1heF1cbiAgICAgIC5yYW5nZSAgW3NpemUuaGVpZ2h0LCAwXVxuXG4gICAgeUF4aXMgPSBkMy5zdmcuYXhpcygpXG4gICAgICAuc2NhbGUgeVxuICAgICAgLm9yaWVudCAnbGVmdCdcbiAgICAgIC50aWNrcyA0XG5cbiAgICByZXR1cm4gZnJhbWUgPVxuICAgICAgeDogeFxuICAgICAgeEF4aXM6IHhBeGlzXG4gICAgICB5OiB5XG4gICAgICB5QXhpczogeUF4aXNcblxuXG4gIHNldF9heGlzID0gKGNvbnRhaW5lciwgeEF4aXMsIGR4LCB5QXhpcywgZHkpIC0+XG4gICAgY29udGFpbmVyLmFwcGVuZCAnZydcbiAgICAgIC5hdHRyXG4gICAgICAgIGNsYXNzOiAgICAgJ3ggYXhpcydcbiAgICAgICAgdHJhbnNmb3JtOiBcInRyYW5zbGF0ZSgwLCN7IGR5IH0pXCJcblxuICAgICAgLmNhbGwgeEF4aXNcblxuICAgIGNvbnRhaW5lci5hcHBlbmQgJ2cnXG4gICAgICAuYXR0clxuICAgICAgICBjbGFzczogICAgICd5IGF4aXMnXG4gICAgICAgIHRyYW5zZm9ybTogXCJ0cmFuc2xhdGUoI3sgZHggfSwgMClcIlxuXG4gICAgICAuY2FsbCB5QXhpc1xuXG5cbiAgZHJhdyA9IChpZCkgLT5cbiAgICBzdmcgPSBkMy5zZWxlY3QoXCIjI3sgaWQgfS1ncmFwaFwiKS5hcHBlbmQgJ3N2ZydcbiAgICAgIC5hdHRyXG4gICAgICAgIHZlcnNpb246ICAgICBcIjEuMVwiXG4gICAgICAgIGJhc2VQcm9maWxlOiBcImZ1bGxcIlxuICAgICAgICB4bWxuczogICAgICAgXCJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2Z1wiXG4gICAgICAgIHdpZHRoOiAgIGQzLnNlbGVjdChcIiMjeyBpZCB9LWdyYXBoXCIpLm5vZGUoKS5jbGllbnRXaWR0aFxuICAgICAgICBoZWlnaHQ6ICBfZy5iYXNlX2dyYXBoLmhlaWdodCgpXG5cbiAgICBjb250YWluZXIgPSBzdmcuYXBwZW5kICdnJ1xuICAgICAgLmF0dHJcbiAgICAgICAgaWQ6IGlkXG4gICAgICAgIGNsYXNzOiBcImdyYXBoXCJcbiAgICAgICAgdHJhbnNmb3JtOiBcInRyYW5zbGF0ZSg0NywwKVwiXG5cbiAgICByZXR1cm4gY29udGFpbmVyXG5cblxuICByZXR1cm4gZ3JhcGggPVxuICAgIGNsZWFyOiAgICBjbGVhclxuICAgIGRyYXc6ICAgICBkcmF3XG4gICAgc2V0X2F4aXM6IHNldF9heGlzXG5cbiAgICB0aWNrX2Zvcm1hdDogdGlja19mb3JtYXRcblxuICAgIGNyZWF0ZV9mcmFtZTogICAgIGNyZWF0ZV9mcmFtZVxuIl19