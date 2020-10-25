//
//  MovieDetailTests.swift
//  movie
//
//  Created by Thong Hao Yi on 25/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import XCTest
import RxSwift
@testable import movie

class MovieDetailTests: XCTestCase {
    
    func testMovieDetail() throws {
        let expectMovieTitle = "The Secret Life of Pets"
        let expectMovieTitleSame = expectation(description: "success: movie title is correct")
        let expectMovieDetailContentCount = expectation(description: "success: total 4 info")
        
        let disposeBag = DisposeBag()
        let httpManagerMock = MockHTTPManager()
        let viewModel = MovieDetailViewModel(movieId: 328111, httpManager: httpManagerMock)
    
        viewModel.movieDetail
            .subscribe(onNext: { movie in
                guard let movie = movie else {
                    return
                }
                
                let result = movie.title.compare(
                    expectMovieTitle,
                    options: .caseInsensitive
                )
                
                XCTAssertTrue(movie.content.count == 4)
                expectMovieDetailContentCount.fulfill()
                
                XCTAssertTrue(result == .orderedSame)
                expectMovieTitleSame.fulfill() } )
            .disposed(by: disposeBag)
        
        viewModel.getMovie(movieId: viewModel.movieId)
        wait(for: [expectMovieTitleSame, expectMovieDetailContentCount],timeout: 3)
    }
    
    func testBookingButtonTap() throws {
        
        let expectWebviewLink = "https://www.cathaycineplexes.com.sg/"
        let expectWebviewLinkSame = expectation(description: "success: Webview Link is correct")
        
        let disposeBag = DisposeBag()
        let httpManagerMock = MockHTTPManager()
        let viewModel = MovieDetailViewModel(movieId: 328111, httpManager: httpManagerMock)
        
        viewModel.webviewLink
            .map {  webviewUrl in
                let result = webviewUrl.compare(
                    expectWebviewLink,
                    options: .caseInsensitive
                )
                XCTAssertTrue(result == .orderedSame)
                expectWebviewLinkSame.fulfill() }
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.openBookingWebview(movieId: 328111)
        
        wait(for: [expectWebviewLinkSame],timeout: 3)
    }
}
