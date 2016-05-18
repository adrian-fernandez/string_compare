String Compare
===============

String Compare is an implementation of different string comparison algorithms.

Installation
------------

Add this into your Gemfile and then run bundle install

    gem "string_compare"

Usage
-----

This gem overrides String class adding new functions for the different string comparison models

### Jaro Winkler distance
```erb
  str = "String Compare"
  str.jaro_winkler('Srting comparer')
```

[Algorithm info in wikipedia](https://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance)


### Hamming distance
```erb
  str = "String Compare"
  str.hamming_distance('Srting comparer')
```
[Algorithm info in wikipedia](https://en.wikipedia.org/wiki/Hamming_distance)

### Damerau Levenshtein
```erb
  str = "String Compare"
  str.damerau_levenshtein('Srting comparer')
```
[Algorithm info in wikipedia](https://es.wikipedia.org/wiki/Distancia_de_Damerau-Levenshtein)

### Dice coefficient
```erb
  str = "String Compare"
  str.dice_coefficient('Srting comparer')
```

### Cosine similarity
```erb
  str = "String Compare"
  str.cosine('Srting comparer')
```

[Algorithm info in wikipedia](https://en.wikipedia.org/wiki/Cosine_similarity https://en.wikipedia.org/wiki/Cosine_similarity)

### Needleman Wunsch
```erb
  str = "String Compare"
  str.needle('Srting comparer')
```

[Algorithm info in wikipedia](https://en.wikipedia.org/wiki/Needleman%E2%80%93Wunsch_algorithm)

## Author
---------

Adrián Fernández <adrian@adrian-fernandez.net>

[http://www.adrian-fernandez.net](http://www.adrian-fernandez.net)

[@adrian-fernandez](https://twitter.com/adrianfdez14)


