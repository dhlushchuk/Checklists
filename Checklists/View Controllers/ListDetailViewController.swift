//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Dzmitry Hlushchuk on 21.06.24.
//

import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController {
    
    @IBOutlet var doneBarButton: UIBarButtonItem!
    @IBOutlet var textField: UITextField!
    @IBOutlet weak var iconImage: UIImageView!
    
    var iconName = "deskclock"
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            iconName = checklist.iconName
            doneBarButton.isEnabled = true
        }
        iconImage.image = UIImage(systemName: iconName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func done() {
        if let list = checklistToEdit {
            list.name = textField.text!
            list.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditing: list)
        } else {
            let list = Checklist(name: textField.text!, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAdding: list)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        done()
    }
    
    @IBAction func textFieldDoneButtonPressed(_ sender: UITextField) {
        done()
    }
    
    override func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        }
    }

}

// MARK: - UITextFieldDelegate
extension ListDetailViewController: UITextFieldDelegate {
    
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
    
}

// MARK: - IconPickerViewControllerDelegate
extension ListDetailViewController: IconPickerViewControllerDelegate {
    
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImage.image = UIImage(systemName: iconName)
        navigationController?.popViewController(animated: true)
    }
    
}
