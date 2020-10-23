//
//  MoviesViewController.swift
//  GhibliMovies
//
//  Created by Clément Cardonnel on 21/10/2020.
//

import UIKit
import Combine

/// Handler that sends a Film
typealias FilmHandler = ((Film) -> Void)

/**
 The app's main screen. It shows a list of Ghibli Movies and let the user see more details by selecting them.
 */
final class MoviesViewController: UIViewController {
    
    // MARK: Static Properties and Helper Objects
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    static let badgeElementKind = "badge-element-kind"
    
    /// We only have one section.
    enum Section: CaseIterable {
        case movies
    }
    
    // MARK: Public Properties
    
    var viewModel: FilmViewModel!
    
    // MARK: Private Properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        collection.backgroundColor = .systemBackground
        collection.alwaysBounceVertical = true
        
        collection.delegate = self
        
        return collection
    }()
      
    private var dataSource: UICollectionViewDiffableDataSource<Section, Film>!
        
    private var subscriptions = Set<AnyCancellable>()
    
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "MOVIES_SECTION_TITLE".localized
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseIdentifier)
        
        // Once the collection view is all set, we can setup its data source
        configureDataSource()
        
        // And subscribe to our view model's various outputs
        viewModel.$films
            .sink(receiveValue: { [weak self] films in
                self?.performQuery(on: films)
            })
            .store(in: &subscriptions)
        
        viewModel.$error
            .sink { [weak self] (error) in
                if let _ = error {
                    self?.showErrorAlert()
                }
            }
            .store(in: &subscriptions)
        
        // Once everything is ready, we can ask it to fetch new films.
        viewModel.fetchNewFilms()
    }
    
}



// MARK: - Error Handling

extension MoviesViewController {
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "NETWORK_ERROR_TITLE".localized, message: "NETWORK_ERROR_DESCRIPTION".localized, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "NETWORK_ERROR_RETRY".localized, style: .default) { [weak self] (_) in
            self?.viewModel.fetchNewFilms()
        }
        let doneAction = UIAlertAction(title: "NETWORK_ERROR_DONE".localized, style: .default) { (_) in }
        alert.addAction(retryAction)
        alert.addAction(doneAction)
        present(alert, animated: true, completion: nil)
    }
    
}



// MARK: - Data Source

private extension MoviesViewController {
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Film>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, film: Film) -> UICollectionViewCell? in
            guard let movieCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: MovieCell.reuseIdentifier, for: indexPath) as? MovieCell else {
                print("Failed at creating cells 🎃")
                return nil
            }
            movieCell.present(film)
            return movieCell
        }
        
        let supplementaryRegistration = UICollectionView.SupplementaryRegistration
        <BadgeSupplementaryView>(elementKind: BadgeSupplementaryView.reuseIdentifier) { [weak self]
            (badgeView, string, indexPath) in
            if let film = self?.dataSource.itemIdentifier(for: indexPath) {
                // Show the badge only if the film is a favorite
                badgeView.isHidden = !film.isFavorite
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: indexPath)
        }
    }
    
    /// Update the datasource to show the films
    func performQuery(on films: [Film]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Film>()
        snapshot.appendSections([.movies])
        snapshot.appendItems(films)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}



// MARK: - Layout

private extension MoviesViewController {
    
    /// Create a badge supplementary item
    static func badge() -> NSCollectionLayoutSupplementaryItem {
        let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], absoluteOffset: CGPoint(x: -4, y: 4))
        let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(22),
                                              heightDimension: .absolute(22))
        return NSCollectionLayoutSupplementaryItem(
            layoutSize: badgeSize,
            elementKind: Self.badgeElementKind,
            containerAnchor: badgeAnchor)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let contentSize = layoutEnvironment.container.effectiveContentSize
            
            // Sizing
            let columns: Int
            if contentSize.width > Constants.Layout.doubleColumnMaxSize {
                columns = 3
            } else if contentSize.width < Constants.Layout.doubleColumnMinSize {
                columns = 1
            } else {
                columns = 2
            }
            
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))

            let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [Self.badge()])
            
            // Group
            // We divide by the number of columns because we want the images to keep the same format no matter the number of columns.
            let threeByTwoDivisor: CGFloat = 1.5
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(threeByTwoDivisor / CGFloat(columns)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            group.interItemSpacing = .fixed(Constants.Layout.spacing)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = Constants.Layout.spacing
            section.contentInsets = NSDirectionalEdgeInsets(
                top: Constants.Layout.edgeSpacing,
                leading: Constants.Layout.edgeSpacing,
                bottom: Constants.Layout.edgeSpacing,
                trailing: Constants.Layout.edgeSpacing)

            return section
        }
        return layout
    }
    
}



// MARK: - Delegate

extension MoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Update the detail screen
        viewModel.selectedFilmIndex = indexPath.row
        
        // Ask the SplitVC to show the detail screen
        splitViewController?.show(.secondary)
        
        // We check the trait collection to deselect because we want to maintain the selection UI in regular sizes.
        if splitViewController?.traitCollection.horizontalSizeClass == .compact {
            // Deselect to remove the selection indicator
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if let film = dataSource.itemIdentifier(for: indexPath) {
            let favoriteAction: UIAction
            
            if film.isFavorite {
                favoriteAction = UIAction(title: "Remove from Favorites", image: UIImage(systemName: "heart.slash"), handler: { [weak self] (_) in
                    self?.viewModel.updateFavorite(filmId: film.id, isFavorite: false)
                })
            } else {
                favoriteAction = UIAction(title: "Favorite", image: UIImage(systemName: "heart"), identifier: nil, handler: { [weak self] (_) in
                    self?.viewModel.updateFavorite(filmId: film.id, isFavorite: true)
                })
            }
            
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (_) -> UIMenu? in
                UIMenu(title: film.title, children: [favoriteAction])
            }
        } else {
            return nil
        }
    }
    
}



// MARK: - Constants

private extension MoviesViewController {
    
    struct Constants {
        
        struct Layout {
            static let doubleColumnMaxSize: CGFloat = 600
            static let doubleColumnMinSize: CGFloat = 300
            static let groupHeight: CGFloat = 300
            static let spacing: CGFloat = 10
            static let edgeSpacing: CGFloat = 10
        }
        
    }
    
}

