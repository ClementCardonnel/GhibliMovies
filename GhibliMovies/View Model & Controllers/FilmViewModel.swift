//
//  FilmViewModel.swift
//  GhibliMovies
//
//  Created by Clément Cardonnel on 21/10/2020.
//

import Foundation
import Combine

/**
 A view model for a view that needs to display all the films.
 
 This view model handle the network fetching from the API. It report the result with either the `films` property or the `error` property.
 Both properties are @Published so you can subscribe to them and handle their outputs individually.
 */
final class FilmViewModel: ObservableObject {
    
    // MARK: Public Properties
    
    @Published var films = [Film]()
    
    /// The index of the currently selected film
    @Published var selectedFilmIndex: Int = 0
    
    @Published var error: Error?
    
    // MARK: Private Properties
        
    /// The network request as a cancellable
    private var cancellableDataTask: AnyCancellable?
    
    
    
    // MARK: Actions
    
    /// Update the `films` array to set their favorite property and trigger reactive updates
    func updateFavorite(filmId: String, isFavorite: Bool) {
        if let index = films.firstIndex(where: { $0.id == filmId }) {
            films[index].isFavorite = isFavorite
        }
    }
    
    /**
     Fetch new films from Ghibli API and updates the `films` and `error` Published properties.
     */
    func fetchNewFilms() {
        // check if the data task isn't already running
        guard cancellableDataTask == nil else {
            // We do nothing because our task will eventually complete and there's no use retrying it beforehand.
            return
        }
        
        /**
         The *films* endpoint.
         
         We include an URL parameter named `fields` in order to retrieve only the elements we need.
        */
        guard let url = URL(string: "\(Constants.baseUrl)\(Constants.filmUrlAddition)?fields=\(Constants.includedFields)") else {
            // Should never happen
            error = GhibliError.invalidUrl
            return
        }
        
        /*
         We use the default configuration with the `useProtocolCachePolicy`
         so that URLSessions uses local cache
         */
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        
        // URLSession data task publisher
        // We save the task in an AnyCancellable property
        cancellableDataTask = URLSession(configuration: configuration)
            .dataTaskPublisher(for: url)
            .retry(1) // We retry once, mainly to mitigate eventual networking issues
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    // Yeah, that failed
                    throw URLError(.badServerResponse)
                }
                // It seems that we've got data
                return element.data
            }
            .decode(type: [Film].self, decoder: JSONDecoder()) // Transform raw data in `Film` objects
            .receive(on: DispatchQueue.main) // The following code should execute on main thread
            .sink(
                receiveCompletion: { [weak self] (completion) in
                    if case let .failure(error) = completion {
                        // Update our subscribers with an error
                        self?.error = error
                    }
                    
                    self?.cancellableDataTask?.cancel()
                    self?.cancellableDataTask = nil
                },
                receiveValue: { [weak self] (films) in
                    // Notify our subscribers we've got films!
                    self?.films = films.sorted(by: { $0.releaseDate < $1.releaseDate })
                }
            )
    }
    
}



// MARK: - Constants

private extension FilmViewModel {
    
    struct Constants {
        
        static let baseUrl: String = "https://ghibliapi.herokuapp.com/"
        
        static let filmUrlAddition: String = "films"
        
        /// Fields that we chose to include. All the others are excluded and won't be returned in the response.
        static let includedFields = "id,title,description,director,producer,release_date,rt_score,people,url"
        
    }
    
}

