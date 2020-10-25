//
//  MovieListingTests.swift
//  movieTests
//
//  Created by Thong Hao Yi on 22/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import XCTest
import RxSwift
@testable import movie

class MovieListingTests: XCTestCase {

    func testGetListing() throws {
        let expectTotalMovieCellCreated = expectation(description: "success: got 20 movie cell")
        let expectLoadingCellCreated = expectation(description: "success: the last cell is loading cell")
        
        let disposeBag = DisposeBag()
        let httpManagerMock = MockHTTPManager()
        let viewModel = MoviesListingViewModel(httpManager: httpManagerMock)
        viewModel.getMovieList()
        
        viewModel.movieCells.subscribe(
            onNext: { cells in
                var moviewCellCount: Int = 0
                let lastCellIsLoading: Bool
                
                for cell in cells {
                    switch cell {
                    case .movieCell(_, _):
                        moviewCellCount += 1
                    default:
                        break
                    }
                }
                
                if case.some(.loadCell) = cells.last {
                    lastCellIsLoading = true
                } else {
                    lastCellIsLoading = false
                }
                
                XCTAssertTrue(moviewCellCount == 20)
                expectTotalMovieCellCreated.fulfill()
                
                XCTAssertTrue(lastCellIsLoading)
                expectLoadingCellCreated.fulfill()} )
            .disposed(by: disposeBag)
        
         wait(for: [expectTotalMovieCellCreated, expectLoadingCellCreated],timeout: 3)
    }
    
    func testGetListingNextPage() throws {
        
        let expectTotalMovieCellCreated = expectation(description: "success: got 40 movie cell")
        let expectLoadingCellCreated = expectation(description: "success: the last cell is loading cell")
        
        let disposeBag = DisposeBag()
        let httpManagerMock = MockHTTPManager()
        let viewModel = MoviesListingViewModel(httpManager: httpManagerMock)
        
        viewModel.getMovieList()
        viewModel.getMovieListNextPage()
        
        viewModel.movieCells.subscribe(
            onNext: { cells in
                var moviewCellCount: Int = 0
                let lastCellIsLoading: Bool
                
                for cell in cells {
                    switch cell {
                    case .movieCell(_, _):
                        moviewCellCount += 1
                    default:
                        break
                    }
                }
                
                if case.some(.loadCell) = cells.last {
                    lastCellIsLoading = true
                } else {
                    lastCellIsLoading = false
                }
                
                XCTAssertTrue(moviewCellCount == 40)
                expectTotalMovieCellCreated.fulfill()
                
                XCTAssertTrue(lastCellIsLoading)
                expectLoadingCellCreated.fulfill()} )
            .disposed(by: disposeBag)
        
         wait(for: [expectTotalMovieCellCreated, expectLoadingCellCreated],timeout: 3)
    }
    
    func testGetListingRefreshList() throws {
        
        let expectTotalMovieCellCreated = expectation(description: "success: got 20 movie cell")
        let expectLoadingCellCreated = expectation(description: "success: the last cell is loading cell")
        
        let disposeBag = DisposeBag()
        let httpManagerMock = MockHTTPManager()
        let viewModel = MoviesListingViewModel(httpManager: httpManagerMock)
        
        viewModel.getMovieList()
        viewModel.getMovieListRefresh()
        
        viewModel.movieCells.subscribe(
            onNext: { cells in
                var moviewCellCount: Int = 0
                let lastCellIsLoading: Bool
                
                for cell in cells {
                    switch cell {
                    case .movieCell(_, _):
                        moviewCellCount += 1
                    default:
                        break
                    }
                }
                
                if case.some(.loadCell) = cells.last {
                    lastCellIsLoading = true
                } else {
                    lastCellIsLoading = false
                }
                
                XCTAssertTrue(moviewCellCount == 20)
                expectTotalMovieCellCreated.fulfill()
                
                XCTAssertTrue(lastCellIsLoading)
                expectLoadingCellCreated.fulfill()} )
            .disposed(by: disposeBag)
        
         wait(for: [expectTotalMovieCellCreated, expectLoadingCellCreated],timeout: 3)
    }
}
