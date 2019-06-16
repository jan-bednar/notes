//
//  ListTableViewController.swift
//  notes
//
//  Created by Jan Bednar on 16/06/2019.
//  Copyright © 2019 bednarjan. All rights reserved.
//

import UIKit

protocol ListTableViewControllerDelegate: AnyObject {
    func listTableViewControllerDelete(note: Note)
    func listTableViewControllerSelect(note: Note)
    func listTableViewControllerRefresh()
}

class ListTableViewController: UITableViewController {
    
    let cellIdentifier = "cell"
    
    weak var delegate: ListTableViewControllerDelegate?
    
    private var notes: [Note] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        self.title = NSLocalizedString("list_title", comment: "List")
    }
    
    func update(notes: [Note]) {
        self.notes = notes
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
    }
    
    private func note(at indexPath: IndexPath) -> Note? {
        guard notes.count >= indexPath.row else {
            return nil
        }
        return notes[indexPath.row]
    }
    
    @objc private func refresh() {
        delegate?.listTableViewControllerRefresh()
    }
}

extension ListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let note = note(at: indexPath) {
            delegate?.listTableViewControllerSelect(note: note)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let note = note(at: indexPath) {
            notes = notes.filter { $0 != note }
            tableView.deleteRows(at: [indexPath], with: .left)
            delegate?.listTableViewControllerDelete(note: note)
        }
    }
}
