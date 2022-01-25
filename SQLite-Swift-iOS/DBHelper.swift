//
//  DBHelper.swift
//  SQLite-Swift-iOS
//

import Foundation
import SQLite3
import UIKit

class DBHelper {
    var db:OpaquePointer?
    let dbPath: String = "myDb.sqlite"
    
    init() {
        db = openDatabase()
        createTable()
    }
    
    //MARK: func create database
    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return nil
        } else {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    //MARK: - func create table database
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS student(Id INTEGER PRIMARY KEY,name TEXT,age INTEGER,yearOfBirth INTEGER,math TEXT,physic TEXT, science TEXT, address TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //MARK: - func add insert data to database
    func insert(name: String, age: Int, yearOfBirth: Int, math: Double, physic: Double, science: Double, address: String) {
        let insertStatementString = "INSERT INTO student (Id, name, age, yearOfBirth, math, physic, science, address) VALUES (?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(age))
            sqlite3_bind_int(insertStatement, 4, Int32(yearOfBirth))
            sqlite3_bind_double(insertStatement, 5, math)
            sqlite3_bind_double(insertStatement, 6, physic)
            sqlite3_bind_double(insertStatement, 7, science)
            sqlite3_bind_text(insertStatement, 8, (address as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    //MARK: - func get all data to database
    func read() -> [Student] {
        let queryStatementString = "SELECT * FROM student"
        var queryStatement: OpaquePointer? = nil
        var psns : [Student] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let age = sqlite3_column_int(queryStatement, 2)
                let yearOfBirth = sqlite3_column_int(queryStatement, 3)
                let math = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let physic = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let science = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let address = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                psns.append(Student(id: Int(id), name: name, age: Int(age), yearOfBirth: Int(yearOfBirth), math: Double(math)!,
                                    physic: Double(physic)!, science: Double(science)!, address: address))
                print("Query Result:")
                print("\(id) | \(name) | \(age) | \(yearOfBirth) | \(math) | \(physic) | \(science) | \(address)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    //MARK: - func deletae by id to database
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM student WHERE Id = \(id);"
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("\nSuccessfully deleted row.")
            } else {
                print("\nCould not delete row.")
            }
        } else {
            print("\nDELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    // MARK: - func get query object to database
    func query(id: Int) -> Student {
        let queryStatementString = "SELECT * FROM student WHERE Id = \(id);"
        var queryStatement: OpaquePointer? = nil
        var student: Student? = nil
        // 1
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            // 2
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let id = sqlite3_column_int(queryStatement, 0)
                let queryResultCol1 = sqlite3_column_text(queryStatement, 1)
                let name = String(cString: queryResultCol1!)
                let age = sqlite3_column_int(queryStatement, 2)
                let yearOfBirth = sqlite3_column_int(queryStatement, 3)
                let math = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                let physic = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let science = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let address = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                
                student = Student(id: Int(id), name: name, age: Int(age), yearOfBirth: Int(yearOfBirth), math: Double(math)!,
                                                        physic: Double(physic)!, science: Double(science)!, address: address)
                print("Query Result:")
                print("\(id) | \(name)")
                return student!
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        // 6
        sqlite3_finalize(queryStatement)
        return student!
    }
    
    //MARK: - func update object to database
    func update(id: Int, name: String) {
        let updateStatementString = "UPDATE student SET name = '\(name)' WHERE Id = \(id);"
        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("\nSuccessfully updated row.")
            } else {
                print("\nCould not update row.")
            }
        } else {
            print("\nUPDATE statement is not prepared")
        }
        sqlite3_finalize(updateStatement)
    }
}
