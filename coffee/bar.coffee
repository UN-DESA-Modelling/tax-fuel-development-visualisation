define ['d3', 'data', 'graph'], (d3, data, graph) ->
  draw = (opts) ->
    id       = opts.id
    action   = opts.action
    x_vars   = opts.x_vars
    param    = opts.param

    width    = $("##{ id }-graph").width() - 50
    height   = _g.base_graph.height() - 20

    sources  = data
      .pluck  _g.queries[param], param
      .filter (s) -> not data.ignored_asset(s)

    x_vars       = x_vars.filter (e) -> not data.ignored_asset e
    x_vars_label = x_vars.map (e) -> _g.details[e] or e

    x = d3.scale.ordinal()
      .domain x_vars_label
      .rangeRoundBands [0, width]

    xAxis = d3.svg.axis()
      .scale x
      .orient "bottom"

    m = d3.max sources, (d) -> d['value']

    highest =
      if x_vars.length is 1
        _g.max_diff / 100
      else
        d3.max sources, (d) -> Math.abs(d['value'])

    y = d3.scale.linear()
      .domain [(-1)*highest, highest]
      .range  [height, 0]

    yAxis = d3.svg.axis()
      .scale y
      .orient "left"
      .tickFormat (v) -> graph.tick_format(v,m)


    if action is 'create'
      graph.clear id
      container = graph.draw id


    if action is 'update'
      d3.selectAll "##{ id } .year-watermark"
        .remove()

      d3.selectAll "##{ id } .axis"
        .remove()

      d3.selectAll "##{ id } .bar-group"
        .remove()

      container = d3.select "g##{ id }"

    container.append 'g'
      .attr
        class:     'x axis'
        transform: "translate(0, #{ height / 2 })"

      .call xAxis

    container.selectAll(".tick text")
      .call wrap, x.rangeBand()

    container.append 'g'
      .attr
        class:  'y axis'

      .call yAxis

    # y axis name
    container.append 'text'
      .attr
        class: 'axis'
        x: -(height/2)
        y: -50
        transform: 'rotate(-90)'
        dy: '1em'
        'text-anchor': 'middle'

      .text (d) -> "change in indicator over base %"


    # x axis name
    container.append 'text'
      .attr
        class: 'axis'
        x: width/2
        y: height
        dy: '1em'
        'text-anchor': 'middle'

      .text (d) -> _g.subtitles[param]

    bar = container.selectAll '.bar-group'
      .data sources
      .enter()
      .append 'g'
      .attr
        class: 'bar-group'

    bar.append 'rect'
      .attr
        id: (d) -> d[param]
        class:  'bar'

        width:
          if x_vars.length is 1
            width * 0.5
          else
            (width / x_vars.length) - 5

        height: (d) -> Math.abs factorise d['value'], highest, height / 2

        x: (d) ->
          if param? and d[param]
            x(_g.details[d[param]]) + 5
          else
            width * 0.25

        y: (d) -> pick_y d, highest, height / 2

        fill: (d) ->
          if d[param] in _g.current_assets then _g.blue else _g.grey

        "fill-opacity": 0.5

        stroke: (d) ->
          if d[param] in _g.current_assets then _g.blue else _g.grey

        "stroke-opacity": 0.3

      .on
        'click': (d) -> _g.click_focus d, id, param

      d3.selectAll('text').moveToFront();

    # bar.append 'text'
    #   .text (d,i) -> d['value']
    #   .attr
    #     y: (d) -> pick_y(d, highest, height / 2) + 10

  factorise = (value, highest_value, height) ->
    return 0 if highest_value is 0

    value * (height / highest_value)

  pick_y = (d, highest_value, height) ->
    c = factorise(d['value'], highest_value, height)

    return if c < 0 then height else height - Math.abs(c)

  wrap = (text, width) ->
    text.each ->
      text = d3.select(this)
      words = text.text().split(/\s+/).reverse()

      line = []
      lineNumber = 0
      lineHeight = 1.1

      y = text.attr 'y'
      dy = parseFloat text.attr('dy')

      tspan = text.text(null).append('tspan').attr
        x: 0
        y: y
        dy: dy + 'em'

      while word = words.pop()
        line.push word
        tspan.text line.join(' ')
        if tspan.node().getComputedTextLength() > width
          line.pop()
          tspan.text line.join(' ')
          line = [ word ]
          tspan = text.append('tspan')
            .attr
              x: 0
              y: y
              dy: ++lineNumber * lineHeight + dy + 'em'

            .text(word)

  return bar =
    draw: draw
