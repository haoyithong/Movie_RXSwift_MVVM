//
//  MoviesListingViewModel.swift
//  movie
//
//  Created by Thong Hao Yi on 22/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import RxSwift
import RxCocoa

class MoviesListingViewModel {
    
    enum MovieListCellType {
        case movieCell(id: Int, vm: MovieTVCellViewModel)
        case loadCell
    }
    var movieCells: Observable<[MovieListCellType]> {
        return cells.asObservable()
    }
    
    var onLoad: Observable<Bool> {
        return loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }
    var onError = PublishSubject<String>()
    
    private let loadInProgress = BehaviorRelay(value: false)
    private let cells = BehaviorRelay<[MovieListCellType]>(value: [])
    
    let httpManager: HTTPManager
    let disposeBag = DisposeBag()
    
    var movies: [Movie] = []
    var currentPagingList: PagingList<Movie>? = nil
    var inLoading: Bool = false
    
    init(httpManager: HTTPManager = HTTPManager()) {
        self.httpManager = httpManager
    }
    
    func getCell(movies: [Movie], totalResult: Int) -> [MovieListCellType] {
        var movieListCellTypeArray: [MovieListCellType] = movies.compactMap {
            .movieCell(id: $0.id, vm: MovieTVCellViewModel(movie: $0))
        }
        if (totalResult > movies.count) {
            movieListCellTypeArray.append(MovieListCellType.loadCell)
        }
        return movieListCellTypeArray
    }
    
    func getMovieListRefresh() {
        getMovieList()
    }
    
    func getMovieListNextPage() {
        if let nextPage = self.currentPagingList?.nextPage {
            getMovieList(page: nextPage)
        }
    }
    
    func getMovieList(page: Int = 1) {
        
        guard inLoading != true else {
            return
        }
        
        loadInProgress.accept(true)
        inLoading = true
        self.httpManager
            .getMovieList(page: page)
            .subscribe(
                onNext: { [weak self] pagingList in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.loadInProgress.accept(false)
                    strongSelf.inLoading = false
                    guard pagingList.results.count > 0 else {
                        strongSelf.onError.onNext("No result found.")
                        return
                    }
                    strongSelf.currentPagingList = pagingList
                    
                    if(pagingList.page == 1) {
                        strongSelf.movies.removeAll()
                    }
                    strongSelf.movies.append(contentsOf: pagingList.results)
                    strongSelf.cells.accept(strongSelf.getCell(
                        movies: strongSelf.movies ,
                        totalResult: pagingList.totalResults) ) },
                onError: { [weak self] error in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.loadInProgress.accept(false)
                    strongSelf.inLoading = false
                    strongSelf.onError.onNext(error.localizedDescription)
                    strongSelf.cells.accept(strongSelf.getCell(
                        movies: strongSelf.movies,
                        totalResult: strongSelf.currentPagingList?.totalResults ?? 0
                    ) ) } )
            .disposed(by: disposeBag)
    }
}
