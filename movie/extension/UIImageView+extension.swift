//
//  UIImageView+Extension.swift
//  movie
//
//  Created by Thong Hao Yi on 23/10/2020.
//  Copyright © 2020 thong. All rights reserved.
//

import AlamofireImage

extension UIImageView {

    public func imageFromUrl(urlString: String) {
        guard let imageUrl = URL(string: urlString) else {
            self.image = UIImage(named: "placeholder")
            return
        }
        
        self.af_setImage(withURL: imageUrl, placeholderImage: UIImage(named: "placeholder"))
    }
}
