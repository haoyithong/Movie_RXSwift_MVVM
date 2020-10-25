//
//  HTTPManager.swift
//  movie
//
//  Created by Thong Hao Yi on 23/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import Alamofire
import RxSwift

class HTTPManager {
    private var manager: SessionManager
    
    init() {
       manager = Alamofire.SessionManager.default
    }
    
    func getMovieList(page: Int = 1) -> Observable<PagingList<Movie>> {
        let parameter: [String : Any] = [
            "api_key": Config.apiKey,
            "primary_release_date.lte": "2016-12-31",
            "sort_by": "release_date.desc",
            "page": page
        ]
        return Observable.create { observer -> Disposable in
            self.manager
                .request(
                    "\(Config.baseUrl)/\(Config.apiVersion)/\(API.getMovies)",
                    method: .get,
                    parameters: parameter)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? APIError.notFound)
                            return
                        }
                        do {
                            let moviesPaging = try JSONDecoder().decode(PagingList<Movie>.self, from: data)
                            observer.onNext(moviesPaging)
                        } catch {
                            observer.onError(error)
                        }
                        break
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
    }
    
    func getMovie(with movieId: Int) -> Observable<MovieDetail> {
        let parameter: [String : Any] = [
            "api_key": Config.apiKey,
        ]
        return Observable.create { observer -> Disposable in
            self.manager
                .request(
                    "\(Config.baseUrl)/\(Config.apiVersion)/\(API.getMovieDetail)/\(movieId)",
                    method: .get,
                    parameters: parameter)
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onError(response.error ?? APIError.notFound)
                            return
                        }
                        do {
                            let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                            observer.onNext(movieDetail)
                        } catch {
                            observer.onError(error)
                        }
                        break
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
    }
}
