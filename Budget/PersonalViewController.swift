//
//  MoreViewController.swift
//  Budget
//
//  Created by nono chan  on 2020/12/1.
//

import UIKit

class PersonalViewController: UIViewController {

    @IBOutlet weak var personalTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        personalTableView.dataSource = self
        personalTableView.delegate = self
    }

}
extension PersonalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = personalTableView.dequeueReusableCell(withIdentifier: "PersonalTableViewCell", for: indexPath) as! PersonalTableViewCell
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 375
    }

}
