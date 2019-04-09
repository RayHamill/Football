# Player Similarity Scores

Similarity scores have been used in sports for years to compare and find players of a similar style and/or quality. Essentially they use a single number to represent how close (or similar) two players are to one another based on a range of statistics.

In football I feel they could have a few basic applications:
* to quickly compile a shortlist when searching for a like-for-like player replacement.
* to find similar alternatives to a transfer target in case it doesn't work out.
* communicating with coaches in a more familiar language - it may be easier to describe a relatively unknown player as similar to a player they can relate to.

Obviously this would just be a basic first step, after which there would need to be a more rigorous analysis ideally using a combination of both video and stats, but similarity scores can serve as a starting point that's fairly simple and easy to implement. 

## Application

I used R's Shiny package to develop an interactive application to play around with these similarity scores: https://rayhamill.shinyapps.io/similarity_scores/

[screenshot] https://github.com/RayHamill/Football/blob/master/similarity_scores/images/screenshot.png

## Method
Below outlines the steps taken to develop these player similarity scores.

* The starting point here is a dataset of on-the-ball events. I've included a combination of common features (passes, pass completion %, shots, tackles, etc) as well as spatial features (where players are making these actions), and my own engineered features (xG, xG assisted, passes into box, etc). In all there are around 40 metrics used.
* To convert these player stats into similarity scores, the features first need to be normalized so that they're all on the same scale.
* Principal component analysis (PCA) is then applied to reduce the dimentionality (kept 20 principal components) and deal with instances of correlation among features.
* Each player can now be thought of as a point in 20 dimensional space, and the similarity between any two players can be measured as the Euclidean distance between them.
* For interpretability, I used min-max normalization on the distances, and subtracted these distance values from 1 to end up with a scale of 0-1, where two identical players would have a similarity score of 1 and the two most dissimilar players would get a score of 0.

I'm aware that there are likely better and more advanced methods for calculating player similarity (Ben Torvaney's excellent [presentation](https://www.youtube.com/watch?v=t1y5incr5Gw) at the recent OptaPro Forum is one such example), so my intention here was simply to outline my own process and method in a (hopefully) interpretable manner. 

