//
//  SplitViewController.swift
//  GhibliMovies
//
//  Created by Clément Cardonnel on 22/10/2020.
//

import UIKit
import Combine

/**
 The app's main SplitViewController
 */
class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    private let viewModel = FilmViewModel()
    
    private var subscriptions =  Set<AnyCancellable>()
    
    /// Movies View Controller: either at the left column on iPad or the first screen on iPhone
    private var moviesViewController: MoviesViewController? {
        (viewController(for: .primary) as? UINavigationController)?.viewControllers.first as? MoviesViewController
    }
    
    /// Our Detail view controller. Either on the right side on iPad, or the second screen on iPhone
    private var detailVC: DetailViewController? {
        (viewController(for: .secondary) as? UINavigationController)?.viewControllers.first as? DetailViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Subscribe this object to hte delegate so that we have exactly the split view behavior we desire
        self.delegate = self
        
        // We want the master view to always be visible on iPad.
        preferredDisplayMode = UISplitViewController.DisplayMode.oneBesideSecondary
        
        moviesViewController?.viewModel = viewModel
        
        Publishers.CombineLatest(viewModel.$films, viewModel.$selectedFilmIndex)
            .sink(receiveValue: { [weak self] films, index in
                if let index = index {
                    self?.detailVC?.film = films[index]
                }
            })
            .store(in: &subscriptions)
        
        detailVC?.onFavoriteToggleHandler = { [weak self] film in
            self?.viewModel.updateFavorite(filmId: film.id, isFavorite: !film.isFavorite)
        }
    }
    
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        // This ensures that the iPhone shows master first and not detail first.
        .primary
    }
    
}
