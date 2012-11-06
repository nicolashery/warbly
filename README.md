# Warbly

This is an example application I used in finding a way to make a **JRuby** worker process deployable to both [Heroku](http://www.heroku.com/) and [Stackato](http://www.activestate.com/stackato).

At the time of writing, Stackato v2.4 does not yet support JRuby **standalone** applications (aka worker processes), either through a standalone framework or through Heroku buildpacks. So I decided to use [Warbler](https://github.com/jruby/warbler) to package my app into a **jar** file in order to deploy to Stackato.

## Installation

You will first need to have installed:

- [JRuby 1.7](http://jruby.org/) with RubyGems

Then install Warbler:

    $ jruby -S gem install warbler

Clone this repository:

    $ git clone https://github.com/nicolahery/warbly

And install its dependencies:

    $ jruby -S bundle install

You can test the app locally by running:

    $ jruby worker.rb

## Architecture

The JRuby worker app is organized like a Ruby Gem, with the code in the `lib` directory, and the executable in the `bin` directory.

Two particularities are worthy to notice:

- Java `jar` files used in the code are vendored into the `lib` directory.
- A top-level `worker.rb` script replicates the executable in the `bin` directory in order to run the app from the project directory.

Also, for the purpose of the test, this worker app uses:

- the Java library `log4j`
- the Ruby library `chronic`

## Heroku

Deployment on Heroku is fairly straightforward, thanks to the [JRuby Heroku Buildpack](https://github.com/jruby/heroku-buildpack-jruby). We use the top-level Ruby script `worker.rb` that calls the main looping method of our worker, `run`. We define the worker process in the `Procfile`:

    worker: jruby worker.rb

To deploy, use the JRuby buildpack:

    $ heroku create --buildpack https://github.com/jruby/heroku-buildpack-jruby.git
    $ git push heroku master
    $ heroku ps:scale worker=1

## Stackato

Deployment on Stackato is a little more tricky, and requires the use of Warbler to package the whole application and its dependencies into a `jar` file. The following was tested on **Stackato v2.4.3**.

In the project directory run:

    $ jruby -S warble

This will create the `warbly.jar` file. 

(*Note*: On my Windows machine, if a `warbly.jar` file already exists, Warbler has trouble with it and gets stuck in a loop where the file just keeps getting bigger and bigger. I need to delete it manually before I run the above command).

You can make sure it works by running:

    $ java -jar warbly.jar

To deploy, we use the Stackato **Java standalone** framework by declaring it in the `stackato.yml` configuration file:

    framework:
      type: standalone
      runtime: java
    
    command: java -jar warbly.jar

For the following, I assume there is a Stackato MicroCloud VM running at `stackato.local`. First, connect to Stackato:

    $ stackato target api.stackato.local
    $ stackato login user@example.com --passwd userpass

Then push the worker app:

    $ stackato push -n

(The `-n` option makes it use the `stackato.yml` config file.)

That should do it! Running `stackato logs warbly` should show the app is working.


