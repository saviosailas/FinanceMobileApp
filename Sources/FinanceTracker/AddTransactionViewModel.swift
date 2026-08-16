//
//  AddTransactionViewModel.swift
//  FinanceMobileApp
//
//  Created by savio sailas on 17/08/26.
//

import Foundation
import Observation

import SkipSQLCore
import SkipSQL

class AddTransactionViewModel: ObservableObject {

    @Published var amount: String = ""
    @Published var name: String = ""

    func addEvent() {
        
//        let dbpath = URL.applicationSupportDirectory.appendingPathComponent("db.sqlite").absoluteString
        let dbpath = URL.applicationSupportDirectory.appendingPathComponent("db.sqlite").relativeString
        
        
        
        

        do {
            
//            let appSupport = URL.applicationSupportDirectory
//
//            try FileManager.default.createDirectory(
//                at: appSupport,
//                withIntermediateDirectories: true
//            )
//
//            let dbpath = appSupport.appendingPathComponent("db.sqlite").relativeString

            
            let sqlite = try SQLContext(path: dbpath, flags: [.create, .readWrite], configuration: .platform)
            defer { try? sqlite.close() }
            
            try sqlite.exec(sql: "CREATE TABLE IF NOT EXISTS SOME_TABLE (STRING TEXT)")
            
            try sqlite.exec(sql: "INSERT INTO SOME_TABLE (STRING) VALUES (?)", parameters: [SQLValue.text("ABC")])
            
            let rows: [[SQLValue]] = try sqlite.selectAll(sql: "SELECT STRING FROM SOME_TABLE")
            assert(rows[0][0] == SQLValue.text("ABC"))
        } catch {
            print("errors: \(error)")
        }
//        
//        do {
//            let dbpath = URL.applicationSupportDirectory
//                .appendingPathComponent("db.sqlite")
//
//            let ctx = try SQLContext(
//                path: dbpath.path,
//                flags: [.create, .readWrite],
//                configuration: .platform
//            )
//
//            defer {
//                try? ctx.close()
//            }
//
//            try ctx.exec(
//                sql: """
//                CREATE TABLE IF NOT EXISTS SOME_TABLE (
//                    STRING TEXT
//                )
//                """
//            )
//
//            try ctx.exec(
//                sql: "INSERT INTO SOME_TABLE (STRING) VALUES (?)",
//                parameters: [
//                    SQLValue.text("\(name)")
//                ]
//            )
//
//            let rows: [[SQLValue]] = {
//                do {
//                    return try ctx.selectAll(
//                        sql: "SELECT STRING FROM SOME_TABLE"
//                    )
//                } catch {
//                    print("error: \(error)")
//                    return []
//                }
//            }()
//
//            print(rows)
//
//        } catch {
//            print("Database error: \(error)")
//        }
    }
}
