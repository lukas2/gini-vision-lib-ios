//
//  GiniVisionDocument.swift
//  GiniVision
//
//  Created by Enrique del Pozo Gómez on 9/4/17.
//  Copyright © 2017 Gini GmbH. All rights reserved.
//

import Foundation

@objc public protocol GiniVisionDocument:class {
    var type:GiniVisionDocumentType { get }
    var data:Data { get }
    var previewImage:UIImage? { get }
    
    init(data:Data)
    func checkType() throws
}

// MARK: GiniVisionDocumentType

@objc public enum GiniVisionDocumentType:Int {
    case PDF = 0
    case Image = 1
}

// MARK: GiniVisionDocumentFactory

public struct GiniVisionDocumentFactory {
    /**
     Creates a `GiniVisionDocument` with a Data object
     
     - Parameter withData: data object with an unknown type
     
     - Returns: A `GiniVisionDocument` if `data` has a valid type or nil if it hasn't.
     
     */
    public static func create(withData data:Data) -> GiniVisionDocument? {
        if data.isPDF {
            return GiniPDFDocument(data: data)
        } else if data.isImage {
            return GiniImageDocument(data: data)
        } else {
            return nil
        }
    }
}

// MARK: GiniVisionDocument extension

extension GiniVisionDocument {
    
    fileprivate var MAX_FILE_SIZE:Int { // Bytes
        return 10 * 1024 * 1024
    }
    
    // MARK: File validation
    /**
     Validates a document, checking if it has the correct size and type.
     
     - Throws: `DocumentValidationError.exceededMaxFileSize` if the size exceeds the max file size
               Also throws type validation errors, see `checkType` implementations
     
     */
    public func validate() throws {
        let document = self
        if !maxFileSizeExceeded(forData: document.data) {
            try checkType()
        } else {
            throw DocumentValidationError.exceededMaxFileSize
        }
    }
    
    // MARK: File size check
    
    fileprivate func maxFileSizeExceeded(forData data:Data) -> Bool {
        if data.count > MAX_FILE_SIZE {
            return true
        }
        return false
    }
}


