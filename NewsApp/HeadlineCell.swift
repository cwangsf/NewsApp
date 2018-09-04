//
//  HeadlineCell.swift
//  NewsApp
//
//  Created by Cynthia Wang on 9/1/18.
//  Copyright © 2018 Cynthia Wang. All rights reserved.
//

import UIKit

class HeadlineCell: UITableViewCell {
    
    
    @IBOutlet weak var urlImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        urlImage.af_cancelImageRequest()
        urlImage.layer.removeAllAnimations()
        urlImage.image = nil
    }
}
