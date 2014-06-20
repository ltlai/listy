Network Calculator
==========================

Problem
-------

The task is to count the size of the social network of the word LISTY in the dictionary provided. We define two words as being friends if the edit distance between them is 1. For this problem, we will be using Levenshtein distance (http://en.wikipedia.org/wiki/Levenshtein_distance) as our edit distance.

The size of a word's social network is equal to that word, plus the number of words who are friends with it, plus the number of friends each of its friends has, and so on. A word is in its own social network, so if our dictionary is simply [HI] then the size of the social network for HI is 1.

Solution
-------

**Size of the social network for LISTY: 51,710.**

I experimented with several different solutions to the problem. Only the fastest is used in `network_size_calculator.rb`, but the others are included in `alternative_methods.rb`. Here I'll explain my logic for each and how I arrived at my final solution.

`build_network_recursively_v1`
-------

Initially, I attempted to solve the problem recursively. I wrote methods that would determine if two given words are friends and iterated through the dictionary, adding friends to a word's social network until there were no new friends to be found. 

This method worked for the very small test dictionary, but was extremely slow for the larger dictionaries because it had to iterate through the entire dictionary every time a new friend was found. 

`build_network_recursively_v2`
-------

Next, I tried first generating all the possible variants that are edit distance 1 from the original word. Then I would iterate through the set of variants and add them to the network if they appeared in the dictionary, recursing with each dictionary match.

This solution was much faster than the first recursive solution, but would return a "stack level too deep" error for dictionaries larger than the eighth dictionary. I tried increasing the permittable stack size to the maximum allowed, but still got the same error.

`build_network_iteratively`
-------

After it became clear that a recursive solution was not going to work for large dictionaries, I switched to an iterative solution. 

Using the `generate_variants_v1` method, this was actually a bit slower than `build_network_recursively_v2`, but it ran successfully with the full dictionary, taking about 55 seconds to complete.

Speed Optimizations
-------

Finally, I tried to find ways to make the solution faster:

- Using hashes instead of arrays:

This was actually a change I made while still using the recursive solution. I had initially used an array to store the dictionary as well as the social network of the word. But I discovered that `array#include?` is a much more expensive operation than `hash#[]`.

- Using `<<` instead of `+` to concatenate strings: 

With `generate_variants_v1`, the slowest part of the process was constructing each variant by concatenating portions of each word with each letter of the alphabet. I did a quick Google search to see if there was a faster way to do this and discovered that `<<` is faster than `+`. This cut the time required for the full dictionary from 55 to 48 seconds, but concatenation was still a pretty time-consuming operation.

- Using string element assignment (`[]=`) instead of string concatenation:

Using `[]=` instead of concatentation for letter replacement and insertion further reduced the total time to about 33 seconds.