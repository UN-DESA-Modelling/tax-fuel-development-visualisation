define ['d3'], (d3) ->
  clear = (id) ->
    d3.select("##{ id }-graph svg").remove()


  tick_format = (v,m) ->
    t = v*10000

    if m*10000 > 4
      return t.toFixed(0)
    else
      return t.toFixed(1)


  create_frame = (data, y_range, size) ->
    x = d3.time.scale()
      .domain d3.extent(data, (d) -> d.date)
      .range [0, size.width]

    xAxis = d3.svg.axis()
      .scale x
      .orient 'bottom'
      .ticks 4

    y = d3.scale.linear()
      .domain [y_range.min, y_range.max]
      .range  [size.height, 0]

    yAxis = d3.svg.axis()
      .scale y
      .orient 'left'
      .ticks 4

    return frame =
      x: x
      xAxis: xAxis
      y: y
      yAxis: yAxis


  set_axis = (container, xAxis, dx, yAxis, dy) ->
    container.append 'g'
      .attr
        class:     'x axis'
        transform: "translate(0,#{ dy })"

      .call xAxis

    container.append 'g'
      .attr
        class:     'y axis'
        transform: "translate(#{ dx }, 0)"

      .call yAxis


  draw = (id) ->
    svg = d3.select("##{ id }-graph").append 'svg'
      .attr
        version:     "1.1"
        baseProfile: "full"
        xmlns:       "http://www.w3.org/2000/svg"
        width:   d3.select("##{ id }-graph").node().clientWidth
        height:  _g.base_graph.height()

    container = svg.append 'g'
      .attr
        id: id
        class: "graph"
        transform: "translate(47,0)"

    return container


  return graph =
    clear:    clear
    draw:     draw
    set_axis: set_axis

    tick_format: tick_format

    create_frame:     create_frame
