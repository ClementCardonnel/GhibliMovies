//
//  MoviesViewController.swift
//  GhibliMovies
//
//  Created by Clément Cardonnel on 21/10/2020.
//

import UIKit
import Combine

/**
 The app's main screen. It shows a list of Ghibli Movies and let the user see more details by selecting them.
 */
final class MoviesViewController: UIViewController {
    
    // MARK: Static Properties and Helper Objects
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    /// We only have one section.
    enum Section: CaseIterable {
        case movies
    }
    
    /// Handler that sends a Film
    typealias FilmHandler = ((Film) -> Void)
    
    // MARK: Public Properties
    
    /// Called when the user selects a film from the list
    var onFilmSelectedHandler: FilmHandler?
    
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
    
    private let viewModel = FilmViewModel()
    
    
    
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
            .sink { (error) in
                // TODO: Handle error, show popup, do things!
            }
            .store(in: &subscriptions)
        
        // Once everything is ready, we can ask it to fetch new films.
        viewModel.fetchNewFilms()
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
    }
    
    /// Update the datasource to show the films
    func performQuery(on films: [Film]) {
        let films = films.sorted(by: { $0.releaseDate < $1.releaseDate })

        var snapshot = NSDiffableDataSourceSnapshot<Section, Film>()
        snapshot.appendSections([.movies])
        snapshot.appendItems(films)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}



// MARK: - Layout

private extension MoviesViewController {
    
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

            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Group
            // We divide by the number of columns because we want the images to keep the same format no matter the number of columns.
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalWidth(1.5 / CGFloat(columns)))
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
        if let film = dataSource.itemIdentifier(for: indexPath) {
            // Update the detail screen
            onFilmSelectedHandler?(film)
            
            // Ask the SplitVC to show the detail screen
            splitViewController?.show(.secondary)
            
            // We check the trait collection to deselect because we want to maintain the selection UI in regular sizes.
            if splitViewController?.traitCollection.horizontalSizeClass == .compact {
                // Deselect to remove the selection indicator
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if let film = dataSource.itemIdentifier(for: indexPath) {
            return UIContextMenuConfiguration.movieCell(film: film, presenter: self)
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

