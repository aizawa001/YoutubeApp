//
//  Channel.swift
//  YoutubeApp
//
//  Created by 五十嵐慎吉 on 2020/11/04.
//

import Foundation

class Channnel: Decodable {
    let items: [ChannnelItem]
}

class ChannnelItem: Decodable {
    let snippet: ChannnelSnippet
}

class ChannnelSnippet: Decodable {
    let title: String
    let thumbnails: Thumbnail
}
