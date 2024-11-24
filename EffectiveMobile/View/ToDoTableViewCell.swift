//
//  ToDoTableViewCell.swift
//  EffectiveMobile
//
//  Created by Азалия Халилова on 21.11.2024.
//

import UIKit
import SnapKit

class ToDoTableViewCell: UITableViewCell {
    // MARK: - GUI Variables
    private lazy var containerView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 5
        
        return view
    }()
    
    private lazy var radioButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "circlebadge"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark"), for: .selected)
        button.addTarget(self, action: #selector(toggleRadioButtons), for: .touchUpInside)
        return button
    }()
    
    private lazy var todoTitle: UILabel = {
        let label = UILabel()
        
        label.text = "Title"
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var dateTitle: UILabel = {
        let label = UILabel()
        
        label.text = "1"
        label.font = .boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    private var onStateChange: ((Bool) -> Void)?
    private var todo: Todo?
    
    // MARK: - Initializations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        addContextMenuInteraction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc
    func toggleRadioButtons(sender: UIButton) {
        sender.isSelected.toggle()
        onStateChange?(sender.isSelected)
    }
    
    func setup(todo: Todo, onStateChange: @escaping (Bool) -> Void) {
        self.todo = todo
        todoTitle.text = todo.todo
        radioButton.isSelected = todo.completed
        self.onStateChange = onStateChange
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        if let date = todo.date {
            dateTitle.text = dateFormatter.string(from: date)
        } else {
            print("Todo date is nil")
            dateTitle.text = dateFormatter.string(from: Date())
        }
    }
    // MARK: - Private Methods
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(radioButton)
        containerView.addSubview(todoTitle)
        containerView.addSubview(dateTitle)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        radioButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.size.equalTo(60)
        }
        
        todoTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(radioButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        dateTitle.snp.makeConstraints { make in
            make.top.equalTo(todoTitle.snp.bottom).offset(5)
            make.leading.equalTo(radioButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
        private func addContextMenuInteraction() {
            let interaction = UIContextMenuInteraction(delegate: self)
            containerView.addInteraction(interaction)
        }
}

// MARK: - UIContextMenuInteractionDelegate
extension ToDoTableViewCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let todo = todo else { return nil }
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                NotificationCenter.default.post(name: NSNotification.Name("EditTask"), object: todo)
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                NotificationCenter.default.post(name: NSNotification.Name("ShareTask"), object: todo)
            }
            
            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                NotificationCenter.default.post(name: NSNotification.Name("DeleteTask"), object: todo)
            }
            
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
}
