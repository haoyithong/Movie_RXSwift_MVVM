//
//  MovieTVCell.swift
//  movie
//
//  Created by Thong Hao Yi on 23/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import UIKit


class MovieTVCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var viewModel: MovieTVCellViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        if let viewModel = viewModel {
            titleLabel.text = viewModel.title
            popularityLabel.text = "Popularity: \(viewModel.popularity)"
            var imageUrl = Config.imageBaseUrl + Config.posterSize + viewModel.image
            posterImageView.imageFromUrl(urlString: imageUrl)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        popularityLabel.font = UIFont.systemFont(ofSize: 14)
        popularityLabel.textColor = UIColor.lightGray
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
