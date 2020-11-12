//
//  BaseTabBarController.swift
//  YoutubeApp
//
//  Created by 五十嵐慎吉 on 2020/11/04.
//

import UIKit

class BaseTabBarController: UITabBarController {
    
    enum controllerName: Int {
        case home, search, channel, mail, library
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewControllers()
    }
    
    private func setUpViewControllers(){
        //TabBarControllerのItemの配列の番号を取得している
        viewControllers?.enumerated().forEach({ (index,viewController) in
            
            if let name = controllerName.init(rawValue: index) {
                switch name {
                case .home:
                    setTabBarInfo(viewController, selectedImageName: "home-selected", unselectedimageName: "home-unselected", title: "ホーム")
                case .search:
                    setTabBarInfo(viewController, selectedImageName: "search-selected", unselectedimageName: "search-unselected", title: "検索")
                case .channel:
                    setTabBarInfo(viewController, selectedImageName: "channel-selected", unselectedimageName: "channel-unselected", title: "登録チャンネル")
                case .mail:
                    setTabBarInfo(viewController, selectedImageName: "mail-selected", unselectedimageName: "mail-unselected", title: "受信トレイ")
                case .library:
                    setTabBarInfo(viewController, selectedImageName: "library-selected", unselectedimageName: "library-unselected", title: "ライブラリ")
                }
            }
        })
    }
    
    private func setTabBarInfo(_ viewController: UIViewController,selectedImageName: String,unselectedimageName: String, title: String) {
        viewController.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.resize(size: .init(width: 25, height: 25))?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.image = UIImage(named: unselectedimageName)?.resize(size: .init(width: 25, height: 25))?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.title = title
    }
}
