# This file doubles as a configuration file and an objec _g that'll
# store some global variables. Define ALL global variables here.
#
define ['jquery'], ($) ->
  window._g =
    # The data file location. You can set it to something like:
    # http://example.org/data.csv
    #
    # D3 handles this.
    #
    data_file: "./data.csv"

    # Ignored parameters. Not to be plotted or queried.
    #
    ignored_indicators: ["base"]
    ignored_scenarios:  ["base", "save", "edu.3"]
    ignored_countries:  []

    # Indicators that the decrease is actually is a positive thing:
    #
    inverted_indicators: ["mr.u5", "mr.mat"]

    details:
      base:      "Base"
      infr:      "Infrastructure"
      save:      "Savings/Debt"
      "edu.1":   "Primary Education"
      "edu.3":   "Tertiary Education"
      "edu.all": "All Education"
      "bdg.exp": "Budget Expansion"

      gdp:       "Real GDP"
      edu:       "Primary Education Completion"
      water:     "Drinking Water"
      sanit:     "Basic Sanitation"
      "mr.u5":   "Under-5 Mortality"
      "mr.mat":  "Maternal Mortality"

      bol: "Bolivia"
      cri: "Costa Rica"
      uga: "Uganda"


    subtitles:
      country:   "countries"
      indicator: "indicators"
      scenario:  "policy scenarios"


    # The year range parsed from the data file.
    #
    year_range: [2015..2030]


    # The starting year for the graphs
    #
    current_year: 2016


    # diff and area graphs sizes/positions
    #
    # It adapts to the screen upon loading.
    #
    # TODO: fix it. it's ugly.
    #
    base_graph:
      width:  -> d3.select('#area-graph').node().clientWidth - 65
      height: -> ($(window).height() - 450) / 2


    # bar graphs sizes/positions:
    #
    graphs:
      diff_graph:
        draw_function: (func, action) ->
          func
            id:      'diffbar'
            action:  action
            param:   'year'
            x_vars:  ['year']


      scenarios_graph:
        draw_function: (func, action) ->
          func
            id:      'scenarios'
            action:  action
            param:   'scenario'
            x_vars:  _g.scenarios.map (e) -> e['scn']


      indicators_graph:
        draw_function: (func, action) ->
          func
            id:      'indicators'
            action:  action
            param:   'indicator'
            x_vars:  _g.indicators.map (e) -> e['ind']


      countries_graph:
        draw_function: (func, action) ->
          func
            id:      'countries'
            action:  action
            param:   'country'
            x_vars: _g.countries.map (e) -> e['cnt']


    mousemove_disabled: false

    blue:   '#00ADEF'
    blue_d: '#276CA4'
    grey:   '#BDBCBC'
    red:    '#F2635C'
    green:  '#1BA397'

    # global variables/attributes.
    #
    # TODO: try to remove all of them
    #
    current_country:   'uga'
    current_indicator: 'mr.u5'
    current_scenario:  'infr'

    current_assets: []

    queries:
      year:      null
      indicator: null
      country:   null
      scenario:  null

    indicators: []
    scenarios:  []
    countries:  []

    max_diff: 0

  return _g
