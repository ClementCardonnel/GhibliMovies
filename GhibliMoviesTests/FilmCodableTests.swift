//
//  FilmCodableTests.swift
//  GhibliMoviesTests
//
//  Created by Clément Cardonnel on 21/10/2020.
//

import XCTest
@testable import GhibliMovies

class FilmCodableTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFromDictionary() throws {
        let decoder = JSONDecoder()
        
        let sampleJsonDictionary: [String: Any] = [
            "id": "2baf70d1-42bb-4437-b551-e5fed5a87abe",
            "title": "Castle in the Sky",
            "description": "The orphan Sheeta inherited a mysterious crystal that links her to the mythical sky-kingdom of Laputa. With the help of resourceful Pazu and a rollicking band of sky pirates, she makes her way to the ruins of the once-great civilization. Sheeta and Pazu must outwit the evil Muska, who plans to use Laputa's science to make himself ruler of the world.",
            "director": "Hayao Miyazaki",
            "producer": "Isao Takahata",
            "release_date": "1986",
            "rt_score": "95",
            "people": [
                "https://ghibliapi.herokuapp.com/people/"
            ],
            "url": "https://ghibliapi.herokuapp.com/films/2baf70d1-42bb-4437-b551-e5fed5a87abe"
        ]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: sampleJsonDictionary, options: .prettyPrinted)
            
            let _ = try decoder.decode(Film.self, from: data)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

}
