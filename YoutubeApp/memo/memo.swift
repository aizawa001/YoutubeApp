//
//  memo.swift
//  YoutubeApp
//
//  Created by 五十嵐慎吉 on 2020/11/06.
//

import Foundation
import Alamofire

//stackviewを使用する時は、stackviewのheightConstraintはつけない
//collectionViewCellの制約がbuildで適用されていない時は、storybordのcollectionViewFlowLayoutのEstimateSizeをnoneにする
//YoutubeAPIを使うときにはpartにsnippet,qに検索したいワードを埋め込む

//kind,publishedAt,channelId,title,description,thumbnail(medium/high)

//通信系（APIなど）ではclassからいちいちインスタンスを作るのは安全上よくない！そこでstatic let
//httpsのレスポンスが300以上の時は処理は走らないので事前にifで制限をつけておく


//EP6
//ある画面を初期起動の時の最初の画面に設定する
//① infoplistのAplicationSceneManifestのStoryBordName
//②一番上のAPPのディレクトリのMainInterface
//③isinitialController

//EP9
//stackViewで上下のerrorが出た時は、DistributionをFillEquallyにする
//画像スクロールを認識する
//①pangesture
//②storyBordのUserOnteractionEnable
//③transrationを取りだす
//④CGAffineTransform

