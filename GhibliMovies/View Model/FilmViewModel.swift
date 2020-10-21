//
//  FilmViewModel.swift
//  GhibliMovies
//
//  Created by Clément Cardonnel on 21/10/2020.
//

import Foundation
import Combine

final class FilmViewModel: ObservableObject {
    
    // MARK: Public Properties
    
    @Published var films = [Film]()
    
    @Published var error: Error?
    
    // MARK: Private Properties
        
    private var cancellableDataTask: AnyCancellable?
    
    
    
    // MARK: Actions
    
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
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
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
                },
                receiveValue: { [weak self] (films) in
                    // Notify our subscribers we've got films!
                    self?.films = films
                }
            )
    }
    
}



// MARK: - Constants

private extension FilmViewModel {
    
    struct Constants {
        
        static let baseUrl: String = "https://ghibliapi.herokuapp.com/"
        
        static let filmUrlAddition: String = "films"
        
        static let includedFields = "id,title,description,director,producer,release_date,rt_score,people,url"
        
    }
    
}

