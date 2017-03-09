define ['d3'], (d3) ->
  parse_date = d3.time.format("%Y").parse

  filter_ignored = (array) ->
    rep = array[0]

    if rep.scn?
      a = array.filter (e) ->
        not (e.scn in _g.ignored_scenarios)

    else if rep.cnt?
      a = array.filter (e) ->
        not (e.cnt in _g.ignored_countries)

    else if rep.ind?
      a = array.filter (e) ->
        not (e.ind in _g.ignored_indicators)

    return a

  csv_query = (source, country, scenario, indicator) ->
    source0 = source1 = null

    source.forEach (d) ->
      if (d['cnt']  is country  and
          d['ind']  is indicator and
          d['scn']  is scenario)

        source0 = reformat d


      if (d['cnt']  is country  and
          d['ind']  is indicator and
          d['scn']  is 'base')

        source1 = reformat d

    return [source0, source1]

  reformat = (d) ->
    o = []

    for t in _g.year_range
      p = parseFloat d[t]

      o.push
        indicator: d['ind']
        scenario:  d['scn']
        country:   d['cnt']
        date:      parse_date t.toString()
        value:     p

    return o

  pluck = (query, param) ->
    query.map (q) ->
      result = {}
      o = {}

      if param isnt 'year'
        o =
          obj:  q[0].find (i) -> i['date'].getFullYear() is _g.current_year
          base: q[1].find (i) -> i['date'].getFullYear() is _g.current_year

      else
        o =
          obj:  query[0].find (i) -> i['date'].getFullYear() is _g.current_year
          base: query[1].find (i) -> i['date'].getFullYear() is _g.current_year

      b = o['base']['value']
      v = o['obj']['value']

      result['value'] = (v-b) / (b * 100)
      result[param] = o['obj'][param]

      return result

  ignored_asset = (x) ->
    e = if (typeof x is 'string') then x else ((x.indicator) or (x.scenario) or (x.country))

    return ((e in _g.ignored_indicators) or (e in _g.ignored_scenarios) or (e in _g.ignored_countries))

  return data =
    csv_query:      csv_query
    filter_ignored: filter_ignored
    pluck:          pluck
    ignored_asset:  ignored_asset
