# Warbly

This is an example application I used in finding a way to make a **JRuby** worker process deployable to both [Heroku](http://www.heroku.com/) and [Stackato](http://www.activestate.com/stackato).

At the time of writing, Stackato v2.4 does not yet support JRuby **standalone** applications (aka worker processes), either through the standalone framework or through Heroku buildpacks. So I decided to use [Warbler](https://github.com/jruby/warbler) to package my app into a **jar** file.

## Requirements

You will first need to have installed:

- [JRuby 1.7](http://jruby.org/) with RubyGems

Then install Warbler:

    $ jruby -S gem install warbler

And clone this repository:

    $ git clone https://github.com/nicolahery/warbly

## Architecture

The JRuby worker app is organized like a Ruby Gem, with the code in the `lib` directory, and the executable in the `bin` directory.

Two particularities are worthy to notice:

- Java `jar` files used in the code are vendored into the `lib` directory.
- A top-level `worker.rb` script replicates the executable in the `bin` directory in order to run the app from the project directory.

Also, for the purpose of the test, this worker app uses:

- the Java library `log4j`
- the Ruby library `chronic`

## Heroku

Deployment on Heroku is fairly straightforward, thanks to the [JRuby Heroku Buildpack](https://github.com/jruby/heroku-buildpack-jruby). We use a top-level Ruby script `worker.rb` that calls the main looping method of our worker, `run`. Then we define in the `Procfile` the worker process:

    worker: jruby worker.rb




