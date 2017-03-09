requirejs.config
  'baseUrl': './javascripts'
  'paths':
    'd3':            '../lib/d3/d3.min'
    'js-extras':     '../lib/js-extras/dist/js-extras.min'
    'web-extras':    '../lib/web-extras/dist/web-extras.min'
    'jquery':        '../lib/jquery/dist/jquery.min'
    'foundation':    '../lib/foundation/js/foundation/foundation'
    'joyride':       '../lib/foundation/js/foundation/foundation.joyride'
    'bootstrap':     '../lib/bootstrap/dist/js/bootstrap.min'
    'rivets':        '../lib/rivets/dist/rivets.bundled.min'

  'shim':
    'bootstrap':
      'deps': ['jquery']

    'foundation':
      'deps': ['jquery']

    'joyride':
      'deps': ['foundation']

    'web-extras':
      'deps': ['js-extras', 'jquery']

    'rivets-config':
      'deps': ['rivets']


require [
  'jquery'
  'd3'
  'global'
  'graph'
  'area'
  'data'
  'bar'
  'foundation'
  'bootstrap'
  'js-extras'
  'web-extras'
  'joyride'
],

($, d3, _g, graph, area, data, bar) ->
  d3.selection.prototype.moveToFront = () ->
    this.each () ->
      this.parentNode.appendChild this

  _g.reload_graphs = (action = 'update') ->
    for k,v of _g.graphs
      _g.graphs[k].draw_function bar.draw, action

  _g.click_focus = (d, id, param) ->
    graph.clear id

    $("#selectors select[name=#{ param }]").val d[param]
    $('#selectors').submit()

    area.move_time_mark d, d['value']


  d3.csv _g.data_file, (db) ->
    _g.indicators = (db.map (row) -> { ind: row['ind'], indicator: _g.details[row['ind']] }).unique_p 'ind'
    _g.scenarios  = (db.map (row) -> { scn: row['scn'], scenario: _g.details[row['scn']] }).unique_p 'scn'
    _g.countries  = (db.map (row) -> { cnt: row['cnt'], country:  _g.details[row['cnt']] }).unique_p 'cnt'

    $('select').on 'change', (e) ->
      $('#selectors').submit()

    $('#selectors').submit (e) ->
      e.preventDefault()

      form = $(this).toObject()

      _g.current_country   = form['country']
      _g.current_indicator = form['indicator']
      _g.current_scenario  = form['scenario']

      _g.current_assets = []
      _g.current_assets.push form['country'], form['indicator'], form['scenario']

      _g.queries.year = data.csv_query db, form['country'], form['scenario'], form['indicator']
      area.draw _g.queries.year

      _g.queries.indicator = _g.indicators.map (v) -> data.csv_query db, form['country'], form['scenario'], v['ind']
      _g.queries.country   = _g.countries.map (c)  -> data.csv_query db, c['cnt'],        form['scenario'], form['indicator']
      _g.queries.scenario  = _g.scenarios.map (s)  -> data.csv_query db, form['country'], s['scn'],         form['indicator']

      _g.reload_graphs 'create'

      d3.selectAll('.axis, .overlay, .time-marker, .graph-title').moveToFront()

      _g.mousemove_disabled = false

    $('#leave').on 'click', () ->
      window.location = './index.html'

    rivets.bind $('#selectors'),
      countries:  data.filter_ignored _g.countries
      scenarios:  data.filter_ignored _g.scenarios
      indicators: data.filter_ignored _g.indicators

    rivets.bind $('.panel'),
      g: _g

    # ...

    $('#selectors select[name="country"]').val   'uga'
    $('#selectors select[name="scenario"]').val  'infr'
    $('#selectors select[name="indicator"]').val 'mr.u5'

    $('#selectors select[name="indicator"]').submit()

    # ...

    # tootlip

    $('[data-toggle="tooltip"]').tooltip()

    $('#guide').click -> $(document).foundation 'joyride', 'start'
    $('#close-guide-button').click -> $(document).foundation 'joyride', 'hide'

    $(document).foundation 'joyride', 'start'
