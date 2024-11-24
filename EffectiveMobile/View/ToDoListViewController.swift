//
//  ToDoListViewController.swift
//  EffectiveMobile
//
//  Created by Азалия Халилова on 21.11.2024.
//

import UIKit
import SnapKit

class ToDoListViewController: UITableViewController {
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    private let viewModel = TodoListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        
        setupConstraints()
        tableView.tableHeaderView = searchBar
        
        viewModel.reloadTable = { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
            self.setupToolBar(self.viewModel.filteredTodos.count)
        }
        viewModel.fetchTodos()
        
        registerObserver()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleEditTask(_:)), name: NSNotification.Name("EditTask"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleShareTask(_:)), name: NSNotification.Name("ShareTask"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeleteTask(_:)), name: NSNotification.Name("DeleteTask"), object: nil)
        
        
    }
    
    @objc private func handleEditTask(_ notification: Notification) {
        guard let task = notification.object as? Todo else { return }
        let taskViewModel = TaskViewModel(todo: task)
        
        let detailViewController = TaskViewController(viewModel: taskViewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    @objc private func handleShareTask(_ notification: Notification) {
        guard let task = notification.object as? Todo else { return }
        let activityVC = UIActivityViewController(activityItems: [task.todo], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    @objc private func handleDeleteTask(_ notification: Notification) {
        guard let task = notification.object as? Todo else { return }
        viewModel.delete(todo: task)
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.register(ToDoTableViewCell.self,
                           forCellReuseIdentifier: "ToDoTableViewCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
    }
    
    private func setupToolBar(_ count: Int) {
        let countLabel = UILabel()
        countLabel.text = "\(count) задач"
        countLabel.textAlignment = .center
        countLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        countLabel.textColor = .black
        
        let countBarButtonItem = UIBarButtonItem(customView: countLabel)
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(addAction))
        
        let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
        
        setToolbarItems([spacing, countBarButtonItem, spacing, addButton], animated: true)
        navigationController?.isToolbarHidden = false
    }
    
    @objc
    private func addAction() {
        let newId = viewModel.getNextId()
        
        let newTodo = Todo(id: newId,
                           todo: "",
                           completed: false,
                           userId: nil,
                           date: Date())
        
        let taskViewModel = TaskViewModel(todo: newTodo)
        let taskViewController = TaskViewController(viewModel: taskViewModel)
        navigationController?.pushViewController(taskViewController, animated: true)
        
    }
    
    
    private func registerObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateData),
                                               name: NSNotification.Name("Update"),
                                               object: nil)
    }
    
    @objc
    private func updateData() {
        viewModel.fetchTodos()
    }
    
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredTodos.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoTableViewCell", for: indexPath) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        
        let todo = viewModel.filteredTodos[indexPath.row]
        
        cell.setup(todo: todo) { [weak self] isSelected in
            guard let self = self else { return }
            
            self.viewModel.updateTodoCompletionStatus(at: indexPath, isSelected: isSelected)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTodo = viewModel.todos[indexPath.row]
        let taskViewModel = TaskViewModel(todo: selectedTodo)
        let detailViewController = TaskViewController(viewModel: taskViewModel)
        
        navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension ToDoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterTodos(by: searchText)
    }
}
