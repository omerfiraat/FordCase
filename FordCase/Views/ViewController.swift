//
//  ViewController.swift
//  FordCase
//
//  Created by Mac on 29.09.2024.
//

import UIKit
import SnapKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    private let searchTextField = UITextField()
    private let tableView = UITableView()
    private var viewModel = UserSearchViewModel()
    private var currentQuery: String = ""
    private var tapGesture: UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupKeyboardObservers()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupUI() {
        view.addSubview(searchTextField)
        view.addSubview(tableView)

        searchTextField.placeholder = "Kullanıcı adı girin"
        searchTextField.borderStyle = .roundedRect
        searchTextField.delegate = self

        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(40)
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "userCell")
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
    }

    private func setupBindings() {
        viewModel.onUsersFetched = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow() {
        if tapGesture == nil {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture?.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture!)
        }
    }

    @objc private func keyboardWillHide() {
        if let tapGesture = tapGesture {
            view.removeGestureRecognizer(tapGesture)
            self.tapGesture = nil
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        if updatedText.count >= 3 {
            currentQuery = updatedText
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard currentQuery.count >= 3 else { return }
        viewModel.resetSearch()
        viewModel.searchUsers(query: currentQuery)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Basit bir UITableViewCell kullanıyoruz
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.textLabel?.text = viewModel.users[indexPath.row].login
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = viewModel.users[indexPath.row].login
        let repoVC = RepoListViewController(username: selectedUser)
        navigationController?.pushViewController(repoVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight - 100 {
            viewModel.searchUsers(query: currentQuery, isPagination: true)
        }
    }
}
