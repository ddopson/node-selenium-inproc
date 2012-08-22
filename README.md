# Overview

Most Selenium solutions involve running the Selenium RC Server JAR file (eg ```java -jar selenium-server-standalone-2.25.0.jar```), letting that listen on port 4444, and then sending commands to it over a TCP connection.  This is what clients like [soda](https://github.com/LearnBoost/soda) do.  

That works great for the most part, but has a few downsides: 

* Requires getting devs to download, setup and run yet another localhost service
* No support for HTTP proxy (needed if you want to inject test fixture data)
* Less flexible since only part of Selenium's true functionality is exposed through the service

This project is slighly different.  Instead, it uses the same Selenium JAR file, but it loads it in-process using the robust [node-java](https://github.com/nearinfinity/node-java) bridge.  In effect, this creates "JS bindings" to Selenium based on the Java interface.  So we can now do [advanced stuff](http://seleniumhq.org/docs/04_webdriver_advanced.html) with Selenium without having to convert the entire project to Java.

Most notably, this means support for setting up an HTTP proxy that can be used to mock some or all of the responses from the server.  It also means that I don't have to explain to other developers how to launch the Selenium service or create a launchd entry for it.  There is no service.  They just run the test script, and a browser magically pops open and the tests run.


For now, this project is the metaphorical "tip of the iceberg".  I'm integrating [Zombie.js](http://zombie.labnotes.org/), wrapping both that and Selenium under one roof, throwing in a configurable proxy for storing traces of the server->client traffic, replaying said traces, etc. This is the first piece of that puzzle.


# Example

This is [CoffeeScript](http://coffeescript.org/), which is directly convertable to JS, so don't be intimidated if it's a new syntax to you. Same thing, just more terse.

    Selenium = require('selenium-inproc')
    s = new Selenium(
      url: 'http://m-local.wavii.com:3000'
      proxy: "localhost:#{PROXY_PORT}"
    )
    s.openBrowser () ->
      s.open '/users/auth/facebook', () ->
        s.type 'email', 'username@gmail.com'
        s.type 'pass', 'sekretPassword'
        s.click 'login', () ->

          s.open '/feed/main', () ->
            console.log "Title is #{s.getTitle()}"
            console.log "Attribute is #{s.getAttribute('css=.inline-topic@data-topic-id')}"

            s.close()
            setTimeout(() ->
              console.log "Buh-Bye"
              Proxy.close()
            , 1000)

The commands supported are just the same ones as in the [Javadoc](http://selenium.googlecode.com/svn/trunk/docs/api/java/com/thoughtworks/selenium/Selenium.html), which is pretty much just [Selenese](http://seleniumhq.org/docs/02_selenium_ide.html#selenium-commands-selenese).

Here's the exaustive list: [src/commands.coffee](https://github.com/ddopson/node-selenium-inproc/blob/master/src/commands.coffee)

