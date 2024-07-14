//
//  Location+CoreDataProperties.swift
//  CamPlace
//
//  Created by Chung Wussup on 7/5/24.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var addr2: String?
    @NSManaged public var animalCmgCl: String?
    @NSManaged public var contentId: String?
    @NSManaged public var doNm: String?
    @NSManaged public var homepage: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var intro: String?
    @NSManaged public var lineIntro: String?
    @NSManaged public var mapX: String?
    @NSManaged public var mapY: String?
    @NSManaged public var sbrsCl: String?
    @NSManaged public var sigunguNm: String?
    @NSManaged public var subTitle: String?
    @NSManaged public var tel: String?
    @NSManaged public var title: String?

}

extension Location : Identifiable {

}
