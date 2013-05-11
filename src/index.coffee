fs = require('fs')
Commands = require('./commands')

module.exports = class Selenium
  DEBUG: process.env.NODE_DEBUG && /selenium/.test(process.env.NODE_DEBUG)
  DEBUG_PREFIX: 'Selenium: '

  log: (msg) ->
    console.log "#{@DEBUG_PREFIX}#{msg}"
  
  SeleniumWrapper = null

  _loadSeleniumWrapperClass: () ->
    Java = require('java')
    Java.classpath.push(__dirname)
    extDir = fs.realpathSync(__dirname + '/../ext')
    found = false
    fs.readdirSync(extDir).map (jarname) ->
      abspath = fs.realpathSync(extDir + '/' + jarname)
      @log "Jarfile = #{abspath}" if @DEBUG
      Java.classpath.push(abspath)
      found = true
    throw new Error("Selenium RC JAR file NOT found in #{extDir}!  (did you run 'npm install'?)") unless found
    SeleniumWrapper = Java.import('SeleniumWrapper')

  constructor: (options = {}) ->
    unless SeleniumWrapper
      @_loadSeleniumWrapperClass()
    @seleniumWrapper = new SeleniumWrapper(options.url || '')
    @seleniumWrapper.setProxySync(options.proxy) if options.proxy

  openBrowser: (callback) ->
    @seleniumWrapper.openBrowser (err, s) =>
      @log "Selenium Browser has opened.  err=#{err}.  s= #{s}" if @DEBUG
      if err
        throw err
      @selenium = s
      callback()


js2hashMap = (obj) ->
  hashMap = new HashMap
  for k, v of obj
    hashMap.put(""+k, v)
  return hashMap

for cmd in Commands
  do (cmd) ->
    Selenium.prototype[cmd] = () ->
      throw new Error("Browser has not been opened yet") unless @selenium
      @log "Calling #{cmd}" if @DEBUG
      return @selenium[cmd].apply(@selenium, arguments)
