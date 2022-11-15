//
//  MainDependencies.swift
//  PaperClipApp
//
//  Created by Grinch on 08/11/2022.
//

import Foundation
import Domain
import Repository
import RemoteStore

typealias MainDependencing = HasAdsRemoteStore & HasCategoriesRemoteStore &
HasAdsRepository & HasCategoriesRepository

class MainDependencies: MainDependencing {

    let adsRemoteStore: Domain.AdsRemoteStoreProtocol
    let categoriesRemoteStore: Domain.CategoriesRemoteStoreProtocol

    lazy var adsRepository: Domain.AdsRepositoryProtocol = AdsRepository(adsRemoteStore: adsRemoteStore)
    lazy var categoriesRepository: Domain.CategoriesRepositoryProtocol = CategoriesRepository(
        categoriesRemoteStore: categoriesRemoteStore)

    init() {
        adsRemoteStore = AdsRemoteStore(httpDataProvider: URLSession.shared)
        categoriesRemoteStore = CategoriesRemoteStore(httpDataProvider: URLSession.shared)
    }

}
