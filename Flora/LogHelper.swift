//
//  LogHelper.swift
//  Flora
//
//  Created by Florian Richter on 5/14/17.
//  Copyright © 2017 Florian Richter. All rights reserved.
//

import Foundation

#if DEBUG
    func DLog(_ message:  @autoclosure () -> String, filename: NSString = #file, function: String = #function, line: Int = #line) {
        NSLog("[\(filename.lastPathComponent):\(line)] \(function) - %@", message())
    }
#else
    func DLog(@autoclosure message:  () -> String, filename: String = #file, function: String = #function, line: Int = #line) {
    }
#endif

func ALog(_ message: String, filename: NSString = #file, function: String = #function, line: Int = #line) {
    NSLog("[\(filename.lastPathComponent):\(line)] \(function) - %@", message)
}
