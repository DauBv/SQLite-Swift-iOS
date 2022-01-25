//
//  ViewController.swift
//  SQLite-Swift-iOS
//

import UIKit

class ViewController: UIViewController {
    //    var names: [String] = ["Mạnh Đạt", "Văn Khánh", "Duy Dũng", "Mai Trang"]
    
    var db:DBHelper = DBHelper()
    //    var persons: [Student] = [
    //        Student(id: 1, name: "Bui Van A", age: 22, yearOfBirth: 2020, math: 9.0, physic: 9.0, science: 9, address: "Cau giay - HN"),
    //        Student(id: 2, name: "Tran Nguyen B", age: 29, yearOfBirth: 2021,math: 10.0, physic: 7, science: 8.0, address: "Long Bien - HN"),
    //        Student(id: 3, name: "Le van Luyen", age: 23, yearOfBirth: 2019,math: 8.0, physic: 7.5, science: 8.8, address: "Noi Bai - HN")
    //    ]
    var persons: [Student] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List data"
        
        // Insert data vao database
        db.insert(name: "Bui Van A", age: 22, yearOfBirth: 2020, math: 9.0, physic: 9.0, science: 9, address: "Cau giay - HN")
        db.insert(name: "Tran Nguyen B", age: 29, yearOfBirth: 2021,math: 10.0, physic: 7, science: 8.0, address: "Long Bien - HN")
        db.insert(name: "Le van Luyen", age: 23, yearOfBirth: 2019,math: 8.0, physic: 7.5, science: 8.8, address: "Noi Bai - HN")
        db.insert(name: "Thanh Trung", age: 17, yearOfBirth: 2005, math: 9.5, physic: 9.5, science: 9, address: "Royal City")
        db.insert(name: "Manh Dat", age: 20, yearOfBirth: 2005, math: 8, physic: 9, science: 7, address: "Times City")
        db.insert(name: "Van Khanh", age: 13, yearOfBirth: 2005, math: 9.5, physic: 7, science: 8.5, address: "Royal City")
        db.insert(name: "Duy Dung", age: 23, yearOfBirth: 2005, math: 9, physic: 8, science: 10, address: "Smart City")
        db.insert(name: "Mai Trang", age: 15, yearOfBirth: 2005, math: 10, physic: 7.5, science: 8.5, address: "An Hung")
        
        persons += db.read()
    }
}

// Extension ViewController UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCell
        if indexPath.row < self.persons.count {
            let student = self.persons[indexPath.row]
            cell.lbId.text = "\(student.id)"
            cell.lbName.text = student.name
            cell.lbMath.text = "\(student.math)"
            cell.lbPhysic.text = "\(student.physic)"
            cell.lbAddress.text = student.address
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.persons.count {
            let id = self.persons[indexPath.row].id
            let student = db.query(id: id)
            print("Name \(student.name) | age \(student.age) | address: \(student.address)")
            
//            let id = self.persons[indexPath.row].id
//            db.deleteByID(id: id)
//            persons = db.read()
//            tableView.reloadData()
//
//            db.update(id: indexPath.row + 1, name: "Bui Van Nam")
//            persons = db.read()
//            tableView.reloadData()
        }
    }
}


