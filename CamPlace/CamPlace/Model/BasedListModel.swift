//
//  BasedListModel.swift
//  CamPlace
//
//  Created by Chung Wussup on 6/15/24.
//

import Foundation

struct BasedListItem: BasedItem {
    let imageUrl: String?
    var title: String?
    var subTitle: String?
    let mapX: String?
    let mapY: String?
    
    let contentId: String
    
    let lineIntro: String
    let intro: String
    let allar: String
    let insrncAt: String
    let trsagntNo: String
    let bizrno: String
    let facltDivNm: String
    let mangeDivNm: String
    let mgcDiv: String
    let manageSttus: String
    let hvofBgnde: String
    let hvofEnddle: String
    let featureNm: String
    let induty: String
    let lctCl: String
    let doNm: String
    let sigunguNm: String
    let zipcode: String
    
    let addr2: String
    
    let direction: String
    let tel: String
    let homepage: String
    let resveUrl: String
    let resveCl: String
    let manageNmpr: String
    let gnrlSiteCo: String
    let autoSiteCo: String
    let glampSiteCo: String
    let caravSiteCo: String
    let indvdlCaravSiteCo: String
    let sitedStnc: String
    let siteMg1Width: String
    let siteMg2Width: String
    let siteMg3Width: String
    let siteMg1Vrticl: String
    let siteMg2Vrticl: String
    let siteMg3Vrticl: String
    let siteMg1Co: String
    let siteMg2Co: String
    let siteMg3Co: String
    let siteBottomCl1: String
    let siteBottomCl2: String
    let siteBottomCl3: String
    let siteBottomCl4: String
    let siteBottomCl5: String
    let tooltip: String
    let glampInnerFclty: String
    let caravInnerFclty: String
    let prmisnDe: String
    let operPdCl: String
    let operDeCl: String
    let trlerAcmpnyAt: String
    let caravAcmpnyAt: String
    let toiletCo: String
    let swrmCo: String
    let wtrplCo: String
    let brazierCl: String
    let sbrsCl: String
    let sbrsEtc: String
    let posblFcltyCl: String
    let posblFcltyEtc: String
    let clturEventAt: String
    let clturEvent: String
    let exprnProgrmAt: String
    let exprnProgrm: String
    let extshrCo: String
    let frprvtWrppCo: String
    let frprvtSandCo: String
    let fireSensorCo: String
    let themaEnvrnCl: String
    let eqpmnLendCl: String
    let animalCmgCl: String
    let tourEraCl: String
    let createdtime: String
    let modifiedtime: String

    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "firstImageUrl"
        case title = "facltNm"
        case subTitle = "addr1"
        case contentId, lineIntro, intro, allar, insrncAt, trsagntNo, bizrno, facltDivNm, mangeDivNm, mgcDiv, manageSttus, hvofBgnde, hvofEnddle, featureNm, induty, lctCl, doNm, sigunguNm, zipcode, addr2, mapX, mapY, direction, tel, homepage, resveUrl, resveCl, manageNmpr, gnrlSiteCo, autoSiteCo, glampSiteCo, caravSiteCo, indvdlCaravSiteCo, sitedStnc, siteMg1Width, siteMg2Width, siteMg3Width, siteMg1Vrticl, siteMg2Vrticl, siteMg3Vrticl, siteMg1Co, siteMg2Co, siteMg3Co, siteBottomCl1, siteBottomCl2, siteBottomCl3, siteBottomCl4, siteBottomCl5, tooltip, glampInnerFclty, caravInnerFclty, prmisnDe, operPdCl, operDeCl, trlerAcmpnyAt, caravAcmpnyAt, toiletCo, swrmCo, wtrplCo, brazierCl, sbrsCl, sbrsEtc, posblFcltyCl, posblFcltyEtc, clturEventAt, clturEvent, exprnProgrmAt, exprnProgrm, extshrCo, frprvtWrppCo, frprvtSandCo, fireSensorCo, themaEnvrnCl, eqpmnLendCl, animalCmgCl, tourEraCl, createdtime, modifiedtime

    }
}

