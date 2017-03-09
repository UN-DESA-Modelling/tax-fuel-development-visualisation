define ['d3', 'graph', 'global'], (d3, graph, _g) ->
  container = null

  width  = _g.base_graph.width()
  height = _g.base_graph.height() - 20

  bisectDate = d3.bisector((d) -> d.date).left

  x = y = null

  make_frame = (source0, source1) ->
    y_min = d3.min Array::concat(d3.min(source0, (d) -> d['value']), d3.min(source1, (d) -> d['value']))
    y_max = d3.max Array::concat(d3.max(source0, (d) -> d['value']), d3.max(source1, (d) -> d['value']))

    _g.max_diff = i = 0

    while i < source0.length
      tmp_diff = Math.abs(source1[i]['value'] - source0[i]['value']) / source0[i]['value']

      _g.max_diff = tmp_diff if (tmp_diff > _g.max_diff)

      i++

    frame = graph.create_frame source0, { min: y_min, max: y_max }, { width: width, height: height }

    x = frame.x
    y = frame.y

    container = graph.draw 'area'

    graph.set_axis container, frame.xAxis, 0, frame.yAxis, height

  move_time_mark = (d, dz) ->
    ddate = d.date or (new Date("#{ _g.current_year }/01/01"))

    tm = d3.selectAll '.time-marker'

    tm.attr
      transform: "translate(#{ x(ddate) }, 0)"

    tm.select "text"
      .text d3.format(",.2f")(dz)
      .attr
        y: 20
        x: -50
        stroke: 'grey'
        'font-size': '0.8em'

  create_time_mark = (source, rows) ->
    tm = d3.select '#area'
      .append 'g'
      .attr
        id : "time-marker-line"
        class : "time-marker"

    tm.append "rect"
      .attr
        width:  0.1
        height: height
        stroke: _g.blue_d
        fill:   "none"

    tm.append "text"
      .attr "x", 0
      .attr "dy", "-0.35em"


    mousemove = (it) ->
      return if _g.mousemove_disabled

      x_mouse = x.invert d3.mouse(it)[0]
      i = bisectDate source[0], x_mouse, 1

      d_left  = source[0][i-1]
      d_right = source[0][i]

      d  = if d_right? and (x_mouse - d_left.date) > (d_right.date - x_mouse) then d_right else d_left

      if _g.current_year isnt d.date.getFullYear()
        _g.current_year = d.date.getFullYear()

        _g.reload_graphs 'update'

        d3.selectAll('.axis').moveToFront()

        d3.selectAll '.time-marker'
          .attr 'year', d.date.getFullYear()


      v = source[0].find (e) ->
        e.date.getFullYear() is _g.current_year

      b = source[1].find (e) ->
        e.date.getFullYear() is _g.current_year

      area.move_time_mark d, (b['value'] - v['value'])


    click = (it) ->
      _g.mousemove_disabled = not _g.mousemove_disabled

      mousemove it

      d3.selectAll '.time-marker rect'
        .style stroke: if _g.mousemove_disabled then "black" else _g.blue_d

    container.append "rect"
      .attr
        class:  "overlay"
        width:  width
        height: height
        fill:   'none'

      .on 'mousemove', -> mousemove this
      .on 'click',     -> click this

  draw = (query) ->
    graph.clear 'area'

    make_frame query[0], query[1]

    b = query[1]
    o = query[0]

    area = d3.svg.area()
      .x (d)   -> x(d.date)
      .y (d,i) -> y(b[i]['value'])

    container
      .datum o

    container.append 'clipPath'
      .attr "id", "clip-below"
      .append "path"
      .attr "d", area.y0(height)

    container.append 'clipPath'
      .attr "id", "clip-above"
      .append "path"
      .attr "d", area.y0(0)

    container.append 'path'
      .attr
        d: area.y0((d,i) -> y(o[i]['value']))
        fill: (d) -> if d[0]['indicator'] in _g.inverted_indicators then _g.blue else _g.blue
        'fill-opacity': 0.4
        'clip-path': 'url(#clip-above)'

    container.append 'path'
      .attr
        d: area.y0((d,i) -> y(o[i]['value']))
        fill:  (d) -> if d[0]['indicator'] in _g.inverted_indicators then _g.blue else _g.blue
        'fill-opacity': 0.4
        'clip-path': 'url(#clip-below)'

    container.selectAll 'path'
      .attr
        stroke: 'black'
        'stoke-width': 1
        'stroke-opacity': 0.2

    create_time_mark query, _g.indicators_query

    container.append 'text'
      .attr
        class: 'axis'
        x: -height/2
        y: -50
        transform: 'rotate(-90)'
        dy: '1em'
        'text-anchor': 'middle'

      .text (d) -> _g.details[d[0]['indicator']]

  return area =
    draw: draw
    x: (value) -> x.call this, value
    create_time_mark: create_time_mark
    move_time_mark: move_time_mark
