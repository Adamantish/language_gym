# Language Gym: German For Programmers
The ideas from the excellent [German For Programmers](https://www.meetup.com/German-for-Programmers/) taster lesson written in ruby!

Just fire up a terminal and run...
```
ruby cases.rb
```

I went to the lesson yesterday evening and couldn't resist writing this out this morning.

The idea of this is that if you know an OO programming language (not necessarily ruby) this should be helpful in understanding how to do adjectives and articles.

Read through, try plugging in different arguments, maybe `gem install pry` and debug your way through to make clear this weird algorithm all Germans hold in their heads.

Honestly, I've yet to internalise these rules so I wrote this to help me. I'm about 80% sure that this code spits out the right answers but by all means check it properly, send me a PR, extend it, make the `use_weak_grid?` method more accurate, write tests, whatever. If you do then try to use no dependencies if possible and maybe use the less ruby idiomatic way to do things if there's an alternative common to more languages. e.g. we rubyists usually declare an array literal of strings with `%w(one two three)` but I've gone for the more language agnostic `['one', 'two', 'three']` form here.

### Update

There's also now an analysis of how helpful it is to memorise some rules for guessing the gender of a noun. (spoiler: Only a few of them are really helpful). It currently uses a list of the 3000 supposedly most common German nouns but it doesn't seem to be the highest quality data. In fact it's probably the 3000 most common English nouns translated. Probably doesn't make a very big difference to the results though.
