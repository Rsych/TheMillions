//
//  PortfolioDataservice-CloudKit.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/21.
//

import Foundation
import CloudKit


extension PortfolioDataService {
    func uploadToiCloud(_ portfolio: Portfolio) {
        let record = portfolio.prepareCloudRecords()
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .allKeys

        operation.modifyRecordsResultBlock = { result in
            switch result {
            case .success:
                print("Success")
            case .failure(let error):
                print("Cloud Error: \(error.localizedDescription)")
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    func removeFromCloud(_ portfolio: Portfolio) {
        let name = portfolio.objectID.uriRepresentation().absoluteString
        let id = CKRecord.ID(recordName: name)

        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [id])

        operation.modifyRecordsResultBlock = { result in
            switch result {
            case .success:
                print("Deleted")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }

        CKContainer.default().publicCloudDatabase.add(operation)
    }
}
