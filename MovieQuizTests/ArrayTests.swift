//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Александр Плешаков on 15.01.2024.
//

import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {

    func testGetValueInRange() throws {
        // Given
        let array = [1, 2, 3, 4, 5]
        // When
        let value = array[safe: 2]
        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
    }
    
    func testGetValueOutOfRange() throws {
        // Given
        let array = [1, 2, 3, 4, 5]
        // When
        let value = array[safe: 5]
        // Then
        XCTAssertEqual(value, nil)
    }

}
