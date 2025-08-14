//
//  String+Email.swift
//  Thursday
//
//  Created by Peter Kovacs on 3/21/22.
//

import Foundation

fileprivate let isEmailRegexp = "[A-Z0-9a-z._%+-]+@[-A-Za-z0-9.]+\\.[A-Za-z]{2,64}"
fileprivate let isEmailPredicate = NSPredicate(format: "SELF MATCHES %@", isEmailRegexp)


extension String {
    var isValidEmail: Bool {
        isEmailPredicate.evaluate(with: self)
    }
}
