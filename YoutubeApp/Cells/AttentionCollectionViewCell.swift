//
//  AttentionCollectionViewCell.swift
//  YoutubeApp
//
//  Created by 五十嵐慎吉 on 2020/11/05.
//

import UIKit
import Nuke

class AttentionCollectionViewCell: UICollectionViewCell {
    
    var videoItem: Item? {
        didSet{
            if let url = URL(string: videoItem?.snippet.thumbnails.medium.url ?? ""){
                Nuke.loadImage(with: url, into: thumbnailImageView)
            }
            videoTitleLabel.text = videoItem?.snippet.title
            descriptionLabel.text = videoItem?.snippet.description
            channelTitleLabel.text = videoItem?.channnel?.items[0].snippet.title
        }
    }
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override class func awakeFromNib() {
        super .awakeFromNib()
        
        
    }
}
