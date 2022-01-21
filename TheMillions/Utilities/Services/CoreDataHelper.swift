//
//  CoreDataHelper.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/21.
//

import Foundation
import CloudKit

extension Portfolio {
    var coinID: String {
        id ?? ""
    }
    var coinAmount: Double {
        amount
    }
    
    func prepareCloudRecords() -> CKRecord {
        // to prepare to go to iCloud
        // CKRecord is same as NSManagedObject for CloudKit, send and receive data using it

        // Created unique identifier
        let recordName = objectID.uriRepresentation().absoluteString
        let recordID = CKRecord.ID(recordName: recordName)
        // Matches to CoreData entities "Project"
        let record = CKRecord(recordType: "Portfolio", recordID: recordID)
        record["coinID"] = coinID
        record["amount"] = amount
        return record
    }
}
