//
//  CustomErrorTypes.swift
//  Thursday
//
//  Created by Scott Begin on 12/14/22.
//

import Foundation

enum ThursError: Error {
    case registrationError(message: String)
}


extension ThursError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .registrationError(message: let message):
            return NSLocalizedString(message, comment: "Registration Error")
        }
    }
}
