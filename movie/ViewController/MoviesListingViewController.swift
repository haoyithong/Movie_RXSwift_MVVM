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
        bindViewModel()
        
        viewModel.getMovie()
    }
    
    private func initTableView() {
        tableView.register(
            UINib(nibName: Cell.movieCell, bundle: nil),
            forCellReuseIdentifier: Cell.movieCell
        )
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        tableView.rx
            .modelSelected(MoviesListingViewModel.MovieListCellType.self)
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                
                self.performSegue(withIdentifier: "MovieDetail", sender: self)
            }).disposed(by: disposeBag)
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
                }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        tableView.addSubview(refreshControl)
    }
    
    private func bindViewModel() {
        viewModel.movieCells
            .bind(to: self.tableView.rx.items) { tableView, index, element in
                let indexPath = IndexPath(item: index, section: 0)
                switch element {
                case .movieCell(let cellViewModel):
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
            .map { [weak self] in self?.showLoading($0)}
            .subscribe()
            .disposed(by: disposeBag)
    }
}
