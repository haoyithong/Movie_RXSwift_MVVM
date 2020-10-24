//
//  MovieDetailViewModel.swift
//  movie
//
//  Created by Thong Hao Yi on 24/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import RxSwift
import RxCocoa

class MovieDetailInfo {
    let title: String
    let image: String
    let content: [TitleContentViewViewModel]
    
    init(movie: MovieDetail) {
        
        let imageUrl = Config.imageBaseUrl + Config.DetailSize + movie.posterPath
        let tempContent: [TitleContentViewViewModel] = [
            TitleContentViewViewModel(
                title: "Synopsis",
                content:movie.overview
            ),
            TitleContentViewViewModel(
                title: "Genres",
                content:movie.getAllGenres()
            ),
            TitleContentViewViewModel(
                title: "Language",
                content:movie.getAllSpokenLanguage()
            ),
            TitleContentViewViewModel(
                title: "Duration",
                content:movie.runtime.minutesToHourMinutes()
            )
        ]

        self.title = movie.title
        self.image = imageUrl
        self.content = tempContent
    }
}

class MovieDetailViewModel {

    let httpManager: HTTPManager
    let disposeBag = DisposeBag()
    
    var onLoad: Observable<Bool> {
        return loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }
    
    var movieDetail: Observable<MovieDetailInfo?> {
        return onGetMovie.asObservable()
    }
    
    let loadInProgress = BehaviorRelay(value: false)
    
    let onGetMovie = BehaviorRelay<MovieDetailInfo?>(value: nil)
    
    init(httpManager: HTTPManager = HTTPManager()) {
        self.httpManager = httpManager
    }
    
    func getMovie(movieId: Int) {
        loadInProgress.accept(true)
        HTTPManager()
            .getMovie(with: movieId)
            .subscribe(
                onNext: { [weak self] movieDetail in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.loadInProgress.accept(false)
                    self?.onGetMovie.accept(MovieDetailInfo(movie: movieDetail))
                },
                onError: { [weak self] error in
                    guard let strongSelf = self else {
                        return
                    }
                })
            .disposed(by: disposeBag)
    }
}
