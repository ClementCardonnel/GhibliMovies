#  GhibliMovies

## Known issues

* Sometimes the collection view may crash due to "inconsistent moves".
* The app uses local cache in priority at all times. Which means that if in the future the API would add or update movies, any instance that has already loaded the API once may never fetch the changes. In a better product, cache protocols should be implemented and followed for better results.
* Split View Controller weirdly prevents the detail's navigation bar to be transparent with the usual blur. I had to basically disable translucency to have something barely acceptable.
