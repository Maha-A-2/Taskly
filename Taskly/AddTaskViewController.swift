import UIKit
import CoreData
import UserNotifications

protocol addTaskDelegate: AnyObject {
    func didAddTask()
}

class AddTaskViewController: UIViewController , UITextFieldDelegate {
    
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    let taskTextField = UITextField()
    let reminderSwitch = UISwitch()
    let reminderLabel = UILabel()
    let datePicker = UIDatePicker()
    let saveButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)
    
    let color = UIColor(red: 109/255, green: 178/255, blue: 138/255, alpha: 1.0)
    
    weak var delegate : addTaskDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        taskTextField.returnKeyType = .default
        taskTextField.becomeFirstResponder()

        view.backgroundColor = .white
        taskTextField.delegate = self
        setupViews()
        setupConstraints()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }


    func setupViews() {
        // TextField
        taskTextField.placeholder = "Enter Task Name "
        taskTextField.borderStyle = .bezel
        view.addSubview(taskTextField)

        // Reminder Label
        reminderLabel.text = "Set reminder 🔔 ? "
        reminderLabel.textColor = .systemBrown
        reminderLabel.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(reminderLabel)

        // Switch
        reminderSwitch.addTarget(self, action: #selector(toggleDatePicker), for: .valueChanged)
        view.addSubview(reminderSwitch)

        // DatePicker
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())
        datePicker.isHidden = true
        view.addSubview(datePicker)

        // Save Button
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTask), for: .touchUpInside)
        saveButton.backgroundColor = color

        saveButton.setTitleColor(.white, for: .normal)
        view.addSubview(saveButton)

        // Cancel Button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        cancelButton.backgroundColor = color

        cancelButton.setTitleColor(.white, for: .normal)
        view.addSubview(cancelButton)
    }

    func setupConstraints() {
        [taskTextField, reminderLabel, reminderSwitch, datePicker, saveButton, cancelButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            reminderLabel.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 20),
            reminderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reminderSwitch.centerYAnchor.constraint(equalTo: reminderLabel.centerYAnchor),
            reminderSwitch.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            datePicker.topAnchor.constraint(equalTo: reminderSwitch.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 200),
            saveButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 30),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -60),
            saveButton.widthAnchor.constraint(equalToConstant: 60),
            cancelButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 30),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc func toggleDatePicker() {
        datePicker.isHidden = !reminderSwitch.isOn
    }

    @objc func saveTask() {
        guard let taskName = taskTextField.text, !taskName.isEmpty else { return }

        let newTask = Task(context: content)
        
        newTask.title = taskName
        newTask.createdAt = Date()
        newTask.isCompleted = false
        

        if reminderSwitch.isOn {
            let selectedDate = datePicker.date
            newTask.reminderDate = selectedDate
            self.scheduleNotification( for : taskName , at : selectedDate, task: newTask )
        }

        do {
            try content.save()
        }catch{
            
        }
        delegate?.didAddTask()
        dismiss(animated: true, completion: nil)
    }

    @objc func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func scheduleNotification(for taskTittls: String , at date :  Date , task : Task){
        
    let content = UNMutableNotificationContent()
    content.title = "Task Reminder"
    content.body = taskTittls
        content.sound = .default
    content.subtitle = "Time for  \(taskTittls)"
        let noId = UUID().uuidString
        task.notificationID = noId
        
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(identifier: noId, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
