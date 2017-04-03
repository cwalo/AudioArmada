//
//  ExamplesListViewController.swift
//  AudioArmadaExamples
//
//  Created by Corey Walo on 4/3/17.
//  Copyright © 2017 Corey Walo. All rights reserved.
//

import UIKit

class ExamplesListViewController: UITableViewController {
    
    let examples: [UIViewController.Type] = [WaveformZoomableViewController.self]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Examples"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "exampleCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return examples.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exampleCell", for: indexPath)
        
        let controller = examples[indexPath.row] as! ExampleViewController.Type
        cell.textLabel?.text = controller.displayName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controllerClass = examples[indexPath.row]
        
        navigationController?.pushViewController(controllerClass.init(), animated: true)
    }
}
