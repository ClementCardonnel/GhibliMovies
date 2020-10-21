//
//  FilmViewModelTests.swift
//  GhibliMoviesTests
//
//  Created by Clément Cardonnel on 21/10/2020.
//

import XCTest
@testable import GhibliMovies
import Combine

class FilmViewModelTests: XCTestCase {
    
    private var viewModel: FilmViewModel!
    
    private var subscriptions = Set<AnyCancellable>()
    
    

    override func setUpWithError() throws {
        viewModel = FilmViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        subscriptions.removeAll()
    }
    
    
    
    func testGettingMovies() throws {
        // Declare our expectation
        let expectation = self.expectation(description: "Retrieved films from the API")
        
        /*
         Setup the observers
         */
        viewModel.$films
            .sink { (films) in
                if !films.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &subscriptions)
        
        viewModel.$error
            .sink { (error) in
                if let error = error {
                    XCTFail(error.localizedDescription)
                    
                    /*
                     We fulfill the expectation even though it should not be
                     in order to stop the wait timeout early.
                     */
                    expectation.fulfill()
                }
            }
            .store(in: &subscriptions)
        
        // Trigger the network request
        viewModel?.fetchNewFilms()
        
        /*
         Wait 5 seconds for the fetching to finish.
         It's long, but not too unrealistic.
         */
        waitForExpectations(timeout: 5, handler: nil)
    }

}
