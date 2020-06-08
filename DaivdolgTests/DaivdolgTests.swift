//
//  DaivdolgTests.swift
//  DaivdolgTests
//
//  Created by Dmitry Bakulin on 04.06.2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import XCTest
@testable import Daivdolg

class DaivdolgTests: XCTestCase {
  
   var sut: UserDataStorage!

    override func setUpWithError() throws {
         sut = UserDataStorage()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
  
  func testIsAuthenticationRequiredShouldBeTrue() throws {
    sut.isAuthenticationRequired = true
    let value = sut.isAuthenticationRequired
    
    XCTAssert(value == true, "isAuthenticationRequired should be true")
  }

}
