# Player Similarity Scores

Similarity scores are nothing new and have been used in sports for years to compare and find players of a similar style and/or quality. Essentially they use a single number to represent how close (or similar) two players are to one another based on a range of statistics.

In football I feel they could have a few basic applications:
* to quickly compile a shortlist when searching for a like-for-like player replacement.
* to find similar alternatives to a transfer target in case it doesn't work out.
* communicating with coaches in a more familiar language - it may be easier to describe a relatively unknown player as similar to a player they can relate to.

Obviously this would just be a basic first step, after which there would need to be a more rigorous analysis ideally using a combination of both video and stats, but similarity scores can serve as a starting point that's fairly simple and easy to implement. 

At the highest levels it may be obvious that certain players are similar to one another and it may well be the case that using your own eyes to watch players is a more accurate method. However, the advantage of using similarity scores (and stats in general) is that they work the same at all levels provided the data is available adn reliable. You can't watch every game from every league, but stats can, which is why they're useful for compiling shortlists of players worth investigating further. There is of course the caveat that to some degree player performance can be a product of their environment, so there's no guarantee they'll translate that to a new team or league. As is the case with regular scouting, these considerations need to be factored into any decisions made.


## Method
So, how do I go about calculating similarity scores? 

The first step involves feature selection and is dictated mainly by the data available to you. I'm using event level data, so the model includes aggregated totals of the different types of on the ball actions, as well as their completion rates and also some additional features I've engineered, such as expected goals.

These features need to be normalized so that they're all on the same scale, before applying PCA to reduce the dimensionality and deal with instances of correlation among features. Each player can now be thought of as a point in a 20 dimensional space, and we can define similarity as the Euclidean distance between any two players. 

I could leave it there but at this point the distance values are pretty much meaningless, so for the purpose of interpretability, when computing similarity to a given player I use min-max normalisation to scale the distances from 0-1 and calculate the similarity score as 1 minus the distance value. This leaves the furthest player in the dataset with a similarity score of 0, and the given player with a score of 1.

I'm aware that there are more advanced methods for calculating player similarity (Ben Torvaney's excellent presentation at the recent OptaPro Forum is one such example), so my intention here was simply to outline my own process and method in a (hopefully) interpretable manner. 

