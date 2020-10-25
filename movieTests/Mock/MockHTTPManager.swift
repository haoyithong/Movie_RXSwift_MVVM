//
//  MockHTTPManager.swift
//  movieTests
//
//  Created by Thong Hao Yi on 25/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import XCTest
import RxSwift

class MockHTTPManager: HTTPManager {
    
    override func getMovieList(page: Int = 1) -> Observable<PagingList<Movie>> {
        var resourceName = ""
        if (page == 1) {resourceName = "mock_movie_list_page_1"}
        else if (page == 2) {resourceName = "mock_movie_list_page_2"}
        
        return Observable.create { observer -> Disposable in
            if let path = Bundle.main.path(forResource: resourceName, ofType: "json")
            {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let moviesPaging = try JSONDecoder().decode(PagingList<Movie>.self, from: data)
                    observer.onNext(moviesPaging)
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    override func getMovie(with movieId: Int) -> Observable<MovieDetail> {
        let resourceName = "mock_movie_detail_328111"
        return Observable.create { observer -> Disposable in
            if let path = Bundle.main.path(forResource: resourceName, ofType: "json")
            {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                    observer.onNext(movieDetail)
                } catch {
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
