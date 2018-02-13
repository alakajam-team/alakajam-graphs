# Alakajam! graphs #

This is a toolset for creating graphs showing various data and statistics about AKJ events. [Haxe 4](http://www.haxe.org/) (and neko) is required for compilation. [Sass](http://sass-lang.com/) is used for stylesheet creation.

## Building ##

In the root directory, simply run:

    haxe make.hxml

And a `graph.n` file should be produced.

## Running ##

In the root directory, run:

    neko graph.n data/akj1.json akj1.html

To create `akj1.html` with data from the first AKJ. Please note that this requires the files `data/akj1/entries.csv` and `data/akj1/entryVotes.csv`, which have not been made public.

## Sass compilation ##

To auto-update the `assets/style.css` file whenever `assets/style.scss` is modified, in the root directory run:

    ./sass-watch.sh
