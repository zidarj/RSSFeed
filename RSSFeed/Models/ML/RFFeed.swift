//
//  RFFeed.swift
//  RSSFeed
//
//  Created by Josip Zidar on 05.04.2022..
//

import Foundation
import UIKit

class RFFeed: Codable {
    private enum CodingKeys: String, CodingKey {
        case name,
             image,
             description,
             url
    }
    
    var name: String
    var image: Data?
    var description: String
    var url: String
    
    init(with name: String, image: Data?, description: String, url: String) {
        self.name = name
        self.image = image
        self.description = description
        self.url = url
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        image = container.contains(.image) ? try container.decode(Data?.self, forKey: .image) : nil
        description = try container.decode(String.self, forKey: .description)
        url = try container.decode(String.self, forKey: .url)
    }
}
