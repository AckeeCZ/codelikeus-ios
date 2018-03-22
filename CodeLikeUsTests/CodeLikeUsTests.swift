//
//  CodeLikeUsTests.swift
//  CodeLikeUsTests
//
//  Created by Dominik Vesely on 22/03/2018.
//  Copyright © 2018 Petr Šíma. All rights reserved.
//

import XCTest
@testable import CodeLikeUs

class CodeLikeUsTests: XCTestCase {
    
    
    
    override func setUp() {
        super.setUp()
        
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testViewModelNotEmpty() {
        
        let vm = RecipesListViewModel(apiService: DummyCookbookAPIService())
        vm.loadRecipes()
        XCTAssertFalse(vm.recipes.value.isEmpty)
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testRefreshingChangesState() {
        let vm = RecipesListViewModel(apiService: DummyCookbookAPIService())
        var results : [Bool] = []
        
        
        let expectation = self.expectation(description: "check refresh")
        
        vm.isRefreshing.producer.startWithValues { value in
            results.append(value)
        }
        vm.loadRecipes()
        expectation.fulfill()
        self.waitForExpectations(timeout: 1.0, handler: { _ in
            XCTAssertEqual(results, [false,true,false])
        })
        
    }
    
}
