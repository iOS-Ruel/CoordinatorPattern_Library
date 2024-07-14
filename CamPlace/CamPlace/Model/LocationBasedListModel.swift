//
//  LocationBasedListModel.swift
//  CamPlace
//
//  Created by Chung Wussup on 6/15/24.
//

import Foundation

struct LocationBasedListModel: BasedItem {
    var imageUrl: String?
    var title: String?
    var subTitle: String?
    var mapX: String?
    var mapY: String?
    let intro: String
    let doNm: String
    let sigunguNm: String
    let addr2: String
    let homepage: String
    let sbrsCl: String
    let animalCmgCl: String
    let tel: String
    let contentId: String
    let lineIntro: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "firstImageUrl"
        case title = "facltNm"
        case subTitle = "addr1"
        case mapX = "mapX"
        case mapY = "mapY"
        case intro, doNm, sigunguNm, addr2, homepage, sbrsCl, animalCmgCl, tel, contentId, lineIntro
    }
    
    init(from location: Location) {
        self.imageUrl = location.imageUrl
        self.title = location.title
        self.subTitle = location.subTitle
        self.mapX = location.mapX
        self.mapY = location.mapY
        self.intro = location.intro ?? ""
        self.doNm = location.doNm ?? ""
        self.sigunguNm = location.sigunguNm ?? ""
        self.addr2 = location.addr2 ?? ""
        self.homepage = location.homepage ?? ""
        self.sbrsCl = location.sbrsCl ?? ""
        self.animalCmgCl = location.animalCmgCl ?? ""
        self.tel = location.tel ?? ""
        self.contentId = location.contentId ?? ""
        self.lineIntro = location.lineIntro ?? ""
    }
    
    init(from locationBasedListModel: LocationBasedListModel) {
        self.imageUrl = locationBasedListModel.imageUrl
        self.title = locationBasedListModel.title
        self.subTitle = locationBasedListModel.subTitle
        self.mapX = locationBasedListModel.mapX
        self.mapY = locationBasedListModel.mapY
        self.intro = locationBasedListModel.intro
        self.doNm = locationBasedListModel.doNm
        self.sigunguNm = locationBasedListModel.sigunguNm
        self.addr2 = locationBasedListModel.addr2
        self.homepage = locationBasedListModel.homepage
        self.sbrsCl = locationBasedListModel.sbrsCl
        self.animalCmgCl = locationBasedListModel.animalCmgCl
        self.tel = locationBasedListModel.tel
        self.contentId = locationBasedListModel.contentId
        self.lineIntro = locationBasedListModel.lineIntro
    }
}

