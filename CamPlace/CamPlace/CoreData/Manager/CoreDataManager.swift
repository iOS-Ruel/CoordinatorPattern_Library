//
//  CoreDataManager.swift
//  CamPlace
//
//  Created by Chung Wussup on 7/5/24.
//

import CoreData
import UIKit
import Combine

class CoreDataManager: NSObject {
    static let shared: CoreDataManager = CoreDataManager()
    
    private let context: NSManagedObjectContext
    private var cancellables: Set<AnyCancellable> = []
    private var fetchedResultsController: NSFetchedResultsController<Location>!
    
    @Published var locations: [Location] = []
    
    private override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to get shared AppDelegate instance.")
        }
        context = appDelegate.persistentContainer.viewContext
        
        super.init()
        
        setupFetchedResultsController()
        performFetch()
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: context,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self
    }
    
    private func performFetch() {
        do {
            try fetchedResultsController.performFetch()
            locations = fetchedResultsController.fetchedObjects ?? []
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
        }
    }
    
    func saveToContext() -> Future<Void, Error> {
        return Future { promise in
            do {
                try self.context.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
    }
    
    func createData(content: LocationBasedListModel) {
        let location = Location(context: context)
        
        location.imageUrl = content.imageUrl
        location.title = content.title
        location.subTitle = content.subTitle
        location.mapX = content.mapX
        location.mapY = content.mapY
        location.intro = content.intro
        location.doNm = content.doNm
        location.sigunguNm = content.sigunguNm
        location.addr2 = content.addr2
        location.homepage = content.homepage
        location.sbrsCl = content.sbrsCl
        location.animalCmgCl = content.animalCmgCl
        location.tel = content.tel
        location.contentId = content.contentId
        location.lineIntro = content.lineIntro
        
        saveToContext()
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] in
                self?.performFetch()
            })
            .store(in: &cancellables)
    }
    
    func deleteData(content: LocationBasedListModel) {
        let location = locations.filter { $0.contentId == content.contentId }.first
        if let location = location {
            context.delete(location)
        }
        saveToContext()
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] in
                self?.performFetch()
            })
            .store(in: &cancellables)
    }
    
    func hasData(content: LocationBasedListModel) -> Future<Bool, Never> {
        return Future { promise in
            let request = Location.fetchRequest()
            let location = try? self.context.fetch(request)
            if let hasData = location?.contains(where: { $0.contentId == content.contentId }) {
                promise(.success(hasData))
            } else {
                promise(.success(false))
            }
        }
    }
}

extension CoreDataManager: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let locations = controller.fetchedObjects as? [Location] {
            self.locations = locations
        }
    }
}
