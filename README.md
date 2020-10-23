#  GhibliMovies

An iOS app that shows movies from Studio Ghibli using [GhibliAPI](https://ghibliapi.herokuapp.com/).

![Ghibli Movies on iPad](https://github.com/Pomme2Poule/GhibliMovies/blob/main/presentation.png)

## Installation

Just download the .zip and run the project.

## Choix techniques

L'application utilise UIKit et Combine. Les requêtes réseaux sont effectuées via une URLSession qui persiste des données en local avec le cache. Les préférences utilisateurs sont stockées via UserDefaults.

L'app est compatible iPhone et iPad, mais aussi les iPhone en mode portrait. Je vous encourage à essayer différentes configurations.

La Collection View de MoviesViewController emploie les Compositional Layout, mais aussi les Diffable Data Sources. Un haptic touch est supporté sur les cellules des films pour les ajouter ou les retirer des favoris.

## Project structure

A view model (`FilmViewModel`) is instantiated from `SplitViewController` and injected into `MoviesViewController`. `MoviesViewController` is the master screen and shows a list of all the movies. When it appears, it asks the view model to fetch the movies from the API. Combine acts as a glue between the view model and the different view controllers and it updates their content as it's produced.



## Known issues

* Sometimes the collection view may crash due to "inconsistent moves".
* The app uses local cache in priority at all times. Which means that if in the future the API would add or update movies, any instance that has already loaded the API once may never fetch the changes. In a better product, cache protocols should be implemented and followed for better results.
* Split View Controller weirdly prevents the detail's navigation bar to be transparent with the usual blur. I had to basically disable translucency to have something barely acceptable.
* Detail Screen could be improved by using a UIVisualEffectView with vibrancy.
* Accessibility  features such as VoiceOver support could be improved.
