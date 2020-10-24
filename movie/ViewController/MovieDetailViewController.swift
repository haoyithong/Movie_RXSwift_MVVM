//
//  MovieDetailViewController.swift
//  movie
//
//  Created by Thong Hao Yi on 24/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import UIKit
import RxSwift

class MovieDetailViewController: BaseVC {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var detailStackView: UIStackView!
    
    let viewModel: MovieDetailViewModel = MovieDetailViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        bindViewModel()
        viewModel.getMovie(movieId: 328111)
    }
    
    private func initUI() {
        movieTitleLabel.font = .boldSystemFont(ofSize: 25)
        movieTitleLabel.textColor = .white
    }
    
    private func bindViewModel() {
        viewModel.movieDetail
            .subscribe(onNext: { [weak self] movie in
                guard let movie = movie else {
                    return
                }
                self?.movieTitleLabel.text = movie.title
                self?.posterImageView.imageFromUrl(urlString: movie.image)
                self?.detailStackView.removeAllArrangedSubviews()
                for vm in movie.content {
                    let titleContentView = TitleContentView.instanceFromNib()
                    titleContentView.viewModel = vm
                    self?.detailStackView.addArrangedSubview(titleContentView)
                }})
            .disposed(by: disposeBag)
        
        viewModel.onLoad
            .map { [weak self] in self?.showLoading($0)}
            .subscribe()
            .disposed(by: disposeBag)
    }
}
