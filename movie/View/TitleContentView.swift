//
//  TitleContentView.swift
//  movie
//
//  Created by Thong Hao Yi on 24/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import UIKit

class TitleContentView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    class func instanceFromNib() -> TitleContentView {
        return UINib(nibName: "TitleContentView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TitleContentView
    }
    
    var viewModel: TitleContentViewViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        if let viewModel = viewModel {
            titleLabel.text = viewModel.title
            contentLabel.text = viewModel.content
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.textColor = .white
    }
}
