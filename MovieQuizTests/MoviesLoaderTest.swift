//
//  MoviesLoaderTest.swift
//  MovieQuizTests
//
//  Created by Александр Плешаков on 15.01.2024.
//

import XCTest
@testable import MovieQuiz

final class MoviesLoaderTest: XCTestCase {

    func testSuccessLoading() throws {
        // Given
        let loader = MoviesLoader(networkClient: StubNetworkClient(emulateError: false))
        
        // When
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 2)
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFailureLoading() throws {
        // Given
        let loader = MoviesLoader(networkClient: StubNetworkClient(emulateError: true))
        // When
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            // Then
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1)
    }

}
