rivets.configure
  templateDelimiters: ["{{", "}}"]

rivets.formatters.mailto = (value) -> "mailto:#{ value }"

rivets.formatters.capitalise = (value) -> value.capitalise()

rivets.formatters.format = (value, args...) -> args.join(" ").format(Array(value.toString()))

rivets.formatters.upcase = (string) -> if string? then string.toUpperCase()

rivets.formatters.translate = (v) -> dictionary[v]

rivets.formatters.long = (v) -> if not v? then return "" else _g.details[v]

rivets.formatters.pdate = (t) ->
  fix = t.replace /(\d{4})-(\d{2})-(\d{2})/gi, '$1/$2/$3'
  new Date(fix).prettyHTML dictionary.weekdays, dictionary.months


shout = (obj,keypath) ->
  console.log " ---- ERROR: The value \"#{ keypath }\" of the following object is not defined OR \"#{ keypath }\" has not been called/bound by rivets ---- "
  console.log obj

  throw "TypeError: Cannot read property '_rv' of undefined"


rivets.adapters['.'].get = (obj,keypath) ->
  shout(obj,keypath) if typeof obj[keypath] is 'undefined'

  return obj[keypath]


# a "one-way adapter" for rv-value and similar
# this won't shout, for now, let's leave it as a 'soft' adapter.

rivets.adapters[':'] =
  observe: (obj,keypath,callback) -> rivets.adapters['.'].observe obj, keypath, callback

  unobserve: (obj,keypath,callback) ->

  get: (obj,keypath) -> return obj[keypath]

  set: (obj,keypath,value) ->


# eg: rv-class-someclass="user.type=sometype"

rivets.adapters['=']  =
  observe: (obj,keypath,callback) ->

  unobserve: (obj,keypath,callback) ->

  get: (obj,keypath) ->
    shout(obj,keypath) if typeof obj[keypath] is 'undefined'

    return obj is keypath

  set: (obj,keypath,value) ->


rivets.binders['match-*'] = (el,value) ->
  if value is @args[0]
    el.style.display = ""
  else
    el.style.display = "none"
