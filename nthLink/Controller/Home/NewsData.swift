//
//  NewsData.swift
//  nthLink
//
//  Created by Vaneet Modgill on 28/02/24.
//


import Foundation

// MARK: - Welcome
class NewsData: Codable {
    var notifications: [HeadlineNewsData]?
    var headlineNews: [HeadlineNewsData]?
    var redirectURL: String?
    var listData = [CommonNewsData]()
    var servers: [Servers]?

    enum CodingKeys: String, CodingKey {
        case notifications, headlineNews
        case redirectURL = "redirectUrl"
        case listData, servers
    }
    init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.notifications = try container.decodeIfPresent([HeadlineNewsData].self, forKey: .notifications)
        self.headlineNews = try container.decodeIfPresent([HeadlineNewsData].self, forKey: .headlineNews)
        self.redirectURL = try container.decodeIfPresent(String.self, forKey: .redirectURL)
        self.listData = try container.decodeIfPresent([CommonNewsData].self, forKey: .listData) ?? [CommonNewsData]()
        self.servers = try container.decodeIfPresent([Servers].self, forKey: .servers)
    }
}

// MARK: - HeadlineNew
class HeadlineNewsData: Codable {
    var url: String?
    var title, image: String?
    init() {
        
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
    }
}

class CommonNewsData:Codable {
    var type: Int = 0
    var data = HeadlineNewsData()
    init() {
        
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(Int.self, forKey: .type) ?? 0
        self.data = try container.decodeIfPresent(HeadlineNewsData.self, forKey: .data) ?? HeadlineNewsData()
    }
   
}
