//
//  Cat.swift
//  PetsDiffingiOS13
//
//  Created by Alfian Losari on 21/07/19.
//  Copyright © 2019 alfianlosari. All rights reserved.
//

import UIKit

enum Section: Int {
    case rounded
    case customGrid
    case twoGrid
}

struct CatImage: Hashable {

    let identifier = UUID()
    var image: UIImage
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: CatImage, rhs: CatImage) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    static let dummyCats: [CatImage] = {
        let catImages = (1...18)
            .compactMap { UIImage(named: "cat\($0)") }
            .map { CatImage(image: $0) }
        
        return catImages
    }()
    
    
    static var shuffledSectionCats: [[CatImage]] {
        var cats = CatImage.dummyCats
        var sectionsCats = [[CatImage]]()
        
        var sectionCount = 3
        let catsInSection = cats.count / sectionCount
        
        while sectionCount > 0 {
            sectionsCats.append(Array(cats.prefix(catsInSection)).shuffled())
            cats.removeFirst(catsInSection)
            sectionCount -= 1
        }
        return sectionsCats
    }
 
}
