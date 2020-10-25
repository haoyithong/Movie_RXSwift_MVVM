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
    @IBOutlet weak var bookingButton: UIButton!
    
    var viewModel: MovieDetailViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        bindViewModel()
        viewModel.getMovie(movieId: viewModel.movieId)
    }
    
    private func initUI() {
        movieTitleLabel.font = .boldSystemFont(ofSize: 25)
        movieTitleLabel.textColor = .white
        
        bookingButton.rx
            .tap
            .asObservable()
            .bind(to: viewModel.bookingButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.movieDetail
            .subscribe(onNext: { [weak self] movie in
                guard let movie = movie else {
                    // show a place holder view
                    self?.movieTitleLabel.text = "Title"
                    self?.posterImageView.imageFromUrl(urlString: "")
                    self?.detailStackView.removeAllArrangedSubviews()
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
        
        viewModel.webviewLink
            .map { [weak self] webviewUrl in
                self?.openWebview(url: webviewUrl) }
            .subscribe()
            .disposed(by: disposeBag)
        
       viewModel.onLoad
            .map { [weak self] showLoading in
                self?.showLoading(showLoading) }
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.onError
            .map({ [weak self] errorMessage in
                self?.onError(errorMessage: errorMessage) })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
    func openWebview(url: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WebviewViewController") as! WebviewViewController
        vc.url = url
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
