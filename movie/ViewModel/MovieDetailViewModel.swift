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
    
    let movieId: Int
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
    
    var webviewLink: Observable<String> {
        return onGetWebviewLink.asObservable().distinctUntilChanged()
    }
    
    let onError = PublishSubject<String>()
    let bookingButtonTapped = PublishSubject<Void>()
    
    private let loadInProgress = BehaviorRelay(value: false)
    private let onGetMovie = BehaviorRelay<MovieDetailInfo?>(value: nil)
    private let onGetWebviewLink = PublishSubject<String>()
    
    init(movieId: Int,
         httpManager: HTTPManager = HTTPManager()) {
        self.movieId = movieId
        self.httpManager = httpManager
        
        bookingButtonTapped
            .subscribe(
                onNext: { [weak self] in
                    self?.openBookingWebview(movieId: movieId)})
            .disposed(by: disposeBag)
    }
    
    func openBookingWebview(movieId: Int) {
        // webview link
        let webviewLink = "https://www.cathaycineplexes.com.sg/"
        onGetWebviewLink.onNext(webviewLink)
    }
    
    func getMovie(movieId: Int) {
        loadInProgress.accept(true)
        HTTPManager()
            .getMovie(with: movieId)
            .subscribe(
                onNext: { [weak self] movieDetail in
                    self?.loadInProgress.accept(false)
                    self?.onGetMovie.accept(MovieDetailInfo(movie: movieDetail)) },
                onError: { [weak self] error in
                    self?.loadInProgress.accept(false)
                    self?.onError.onNext(error.localizedDescription) })
            .disposed(by: disposeBag)
    }
}
