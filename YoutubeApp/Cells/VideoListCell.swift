//
//  VideoListCell.swift
//  YoutubeApp
//
//  Created by 五十嵐慎吉 on 2020/11/03.
//

import Foundation
import UIKit
//キャッシュ処理ができる
import Nuke

class VideoListCell: UICollectionViewCell {
    
    var videoItem: Item? {
        didSet{
            if let url = URL(string: videoItem?.snippet.thumbnails.medium.url ?? ""){
                Nuke.loadImage(with: url, into: thumbnailImageView)
            }
            
            if let channelUrl = URL(string: videoItem?.channnel?.items[0].snippet.thumbnails.medium.url ?? ""){
                Nuke.loadImage(with: channelUrl, into: channelImageView)
            }
            titleLabel.text = videoItem?.snippet.title
            descriptionLabel.text = videoItem?.snippet.description
        }
    }
    
    @IBOutlet weak var channelImageView: UIImageView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    //xibと紐付けされている時は.initは使わない,awakeFromNibを使う！
    override func awakeFromNib() {
        super.awakeFromNib()
        
        channelImageView.layer.cornerRadius = 40/2
    }
    
    
}
