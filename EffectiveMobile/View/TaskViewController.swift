import UIKit
import SnapKit

class TaskViewController: UIViewController {
    
    var viewModel: TaskViewModelProtocol
    private var originalTodoText: String?
    
    // MARK: - UI Elements
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        textField.textColor = .black
        textField.borderStyle = .none
        textField.textAlignment = .left
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    private lazy var dateTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        titleTextField.delegate = self
        configureView()
    }
    
    init(viewModel: TaskViewModelProtocol) {
        self.viewModel = viewModel
        self.originalTodoText = viewModel.todo.todo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleTextField)
        view.addSubview(dateTitle)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(recognizer)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        dateTitle.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Configuration
    private func configureView() {
        titleTextField.text = viewModel.todo.todo
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        if let date = viewModel.todo.date {
            dateTitle.text = dateFormatter.string(from: date)
        } else {
            dateTitle.text = dateFormatter.string(from: Date())
        }
    }
    
    @objc
    private func hideKeyboard() {
        titleTextField.resignFirstResponder()
    }
    
    private func saveChanges() {
        viewModel.todo.todo = titleTextField.text ?? ""
        
        if originalTodoText == "" {
            viewModel.createToDo(todo: viewModel.todo)
            print("создал")
        } else {
            viewModel.saveChanges(todo: viewModel.todo)
            print("обновил")
        }
    }
}

extension TaskViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        titleTextField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveChanges()
    }
}
