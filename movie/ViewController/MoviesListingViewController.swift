//
//  MoviesListingViewController.swift
//  movie
//
//  Created by Thong Hao Yi on 22/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import UIKit
import RxSwift

class MoviesListingViewController: BaseVC {
    
    @IBOutlet var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    
    let viewModel: MoviesListingViewModel = MoviesListingViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initTableView()
        initUI()
        setupEvent()

        DispatchQueue.main.async {
            self.bindViewModel()
            self.viewModel.getMovie()
        }
    }
    
    private func initTableView() {
        tableView.register(
            UINib(nibName: Cell.movieCell, bundle: nil),
            forCellReuseIdentifier: Cell.movieCell
        )
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
    }

    private func initUI() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.refreshControl.endRefreshing()
                }
                self?.viewModel.getMovieRefresh()
                })
            .disposed(by: disposeBag)
        
        tableView.addSubview(refreshControl)
    }
    
    private func bindViewModel() {
        viewModel.movieCells
            .bind(to: self.tableView.rx.items) { tableView, index, element in
                let indexPath = IndexPath(item: index, section: 0)
                switch element {
                case .movieCell(_, let cellViewModel):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.movieCell, for: indexPath) as? MovieTVCell else {
                        return UITableViewCell()
                    }
                    cell.viewModel = cellViewModel
                    return cell
                case .loadCell:
                    self.viewModel.getMovieNextPage()
                    return UITableViewCell()
                } }
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
    
    private func setupEvent() {
        tableView.rx
            .modelSelected(MoviesListingViewModel.MovieListCellType.self)
            .subscribe(onNext: { [weak self] modelSelected in
                switch modelSelected {
                case .movieCell(let id, _):
                    self?.openMovieDetail(movieId: id)
                default:
                    break
                } })
            .disposed(by: disposeBag)
    }
    
    func openMovieDetail(movieId: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        vc.viewModel = MovieDetailViewModel(movieId: movieId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
