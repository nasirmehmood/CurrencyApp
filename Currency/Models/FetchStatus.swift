//
//  FetchStatus.swift
//  Currency
//
//  Created by Light on 19/11/2022.
//

import Foundation

enum FetchStatus {
    case initiated
    case completed
    case failed
}

typealias FetchStatusBlock = (FetchStatus, Error?) -> Void
