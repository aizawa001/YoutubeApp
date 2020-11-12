//
//  ViewController.swift
//  YoutubeApp
//
//  Created by 五十嵐慎吉 on 2020/11/03.
//

import UIKit
import Alamofire

class VideoListViewController: UIViewController {
    
    //cell.dequeueReusableCellとcollectionView.registerのforCellWithReuseIdentifierのidは同じにする！
    //xibファイルのidentifierの方にもいれる！
    private let cellId = "cellId"
    private let attentionCellId = "attentionCellId"
    
    private var videoItems = [Item]()
    private var prevContentOffset = CGPoint(x: 0, y: 0)
    private let headerMoveHeight: CGFloat = 7
    
    @IBOutlet weak var videoListCollectionView: UICollectionView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var hearderHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var hearderWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpViews()
        fetchYoutubeSearchInfo()
        
    }
    
    private func setUpViews(){
        videoListCollectionView.delegate = self
        videoListCollectionView.dataSource = self
        //nibNameにはそのxibファイルの名前
        videoListCollectionView.register(UINib(nibName: "VideoListCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        videoListCollectionView.register(AttentionCell.self, forCellWithReuseIdentifier: attentionCellId)
        profileImageView.layer.cornerRadius = 40/2
    }
    
    private func fetchYoutubeSearchInfo(){
        let params = ["q":"amelia"]
        API.shared.request(path: .search, params: params, type: Video.self) { (video) in
            self.videoItems = video.items
            //すべてのチャンネルの情報を取得すると通信が多くなるので、今回は配列の最初の動画のチャンネルの情報のみ取り出す
            let id = self.videoItems[0].snippet.channelId
            self.fetchYoutubeChannelInfo(id: id)
        }
    }
    
    private func fetchYoutubeChannelInfo(id: String){
        let params = ["id": id]
        API.shared.request(path: .channels, params: params, type: Channnel.self) { (channel) in
            self.videoItems.forEach{(item) in
                item.channnel = channel
            }
            self.videoListCollectionView.reloadData()
        }
    }
    
}

//MARK: - scrollViewのdelegateメソッド
extension VideoListViewController {
    //scrollViewがどのくらいスクロールしているかリアルタイムでわかる
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headerAnimation(scrollView: scrollView)
    }
    
    private func headerAnimation(scrollView: UIScrollView){
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.prevContentOffset = scrollView.contentOffset
        }
        
        guard let presentIndexPath = videoListCollectionView.indexPathForItem(at: scrollView.contentOffset) else {return}
        if scrollView.contentOffset.y < 0 {return}
        if presentIndexPath.row >= videoItems.count - 2 {return}
        
        let alphaRatio = 1 / hearderHeightConstraint.constant
        
        
        //下にスクロール
        if self.prevContentOffset.y < scrollView.contentOffset.y{
            if hearderWidthConstraint.constant <= -hearderHeightConstraint.constant {return}
            hearderWidthConstraint.constant -= headerMoveHeight
            headerView.alpha -= alphaRatio * headerMoveHeight
            //上にスクロール
        }else if self.prevContentOffset.y > scrollView.contentOffset.y {
            if hearderWidthConstraint.constant >= 0 {return}
            hearderWidthConstraint.constant += headerMoveHeight
            headerView.alpha += alphaRatio * headerMoveHeight
        }
    }
    
    //scrollViewがピタッと止まったときに呼ばれる
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            headerViewEndAnimation()
        }
    }
    
    //scrollViewが止まったときに呼ばれる
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        headerViewEndAnimation()
    }
    
    private func headerViewEndAnimation(){
        //半分より上だったらnaviConを上に隠す
        if hearderWidthConstraint.constant < -hearderHeightConstraint.constant / 2 {
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [],animations: {
                self.hearderWidthConstraint.constant = -self.hearderHeightConstraint.constant
                self.headerView.alpha = 0
                self.view.layoutIfNeeded()
            })
        }else{
            //半分より下だったらvaviConを下に隠す
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.8, options: [],animations: {
                self.hearderWidthConstraint.constant = 0
                self.headerView.alpha = 1
                self.view.layoutIfNeeded()
            })
            }
    }
}


//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension VideoListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let videoViewController = UIStoryboard(name: "Video", bundle: nil).instantiateViewController(identifier: "VideoViewController") as VideoViewController
        
        
        //参考演算子
        videoViewController.selectedItem = indexPath.row > 2 ? videoItems[indexPath.row - 1] : videoItems[indexPath.row]
        
//        if indexPath.row > 2 {
//            videoViewController.selectedItem = videoItems[indexPath.row - 1]
//
//        }else{
//            videoViewController.selectedItem = videoItems[indexPath.row]
//        }
                
        self.present(videoViewController, animated: true, completion: nil)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoItems.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 2 {
            let cell = videoListCollectionView.dequeueReusableCell(withReuseIdentifier: attentionCellId, for: indexPath) as! AttentionCell
            cell.videoItems = self.videoItems
            return cell
        }else{
            let cell = videoListCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VideoListCell
            
            if self.videoItems.count == 0 {return cell}
            //ここもしかしたら割り算でやった方がいいかんも
            if indexPath.row > 2 {
                cell.videoItem = videoItems[indexPath.row - 1]
            }else{
                cell.videoItem = videoItems[indexPath.row]
            }
            
            return cell
        }
    }
    
    //cellの大きさ調整の時はUICollectionViewDelegateFlowLayoutからsizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        
        if indexPath.row == 2 {
            return .init(width: width, height: 200)
        } else {
            return .init(width: width, height: width)
        }
    }
    
}
