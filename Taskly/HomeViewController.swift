//
//  ViewController.swift
//  Taskly
//
//  Created by Maha Alqarni on 22/10/1446 AH.
//

import UIKit
import CoreData

class HomeViewController: UIViewController , UITableViewDataSource , UITableViewDelegate , addTaskDelegate {
    //Home viewController 1111
    func didAddTask() {
        fetchTask()
        tableView.reloadData()
    }
    
    // MARK: - UI Elements
    let toDayLabe: UILabel = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEE d MMMM yyyy"
        let currentDate = Date()
        let formaterDate = formatter.string(from: currentDate)
       
        let label = UILabel()
        label.text = "\(formaterDate)"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  UIColor(red: 109/255, green: 178/255, blue: 138/255, alpha: 1.0)
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TO DO"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let noTaskLabe: UILabel = {
        let label = UILabel()
        label.text = "There are no task to disply \n To Add please click add button ✚ "
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .systemGray3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" ➕ ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGreen
        return button
    }()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        
        return table
        
    }()
    
    var tasks = [Task]()
    
    let content = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 223/255, green: 245/255, blue: 234/255, alpha: 1.0)
        
       tableView.layer.borderColor = CGColor(red: 109/255, green: 178/255, blue: 138/255, alpha: 1.0)
        tableView.layer.borderWidth = 2

        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 20
    
        addButton.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)
    
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "taskCell")
        
        
        setupViews()
        fetchTask()
    }
    
    func setupViews() {
        
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        view.addSubview(tableView)
        view.addSubview(noTaskLabe)
        view.addSubview(toDayLabe)
        
        NSLayoutConstraint.activate([
            // title .......
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 120),
          //  titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            //button .....
            addButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
          //  addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            // tableView .....
            tableView.topAnchor.constraint(equalTo: addButton.topAnchor,constant: 40),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -5),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor , constant: -60),
            //no task
            noTaskLabe.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 300),
            noTaskLabe.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50),
            //date of the day
            toDayLabe.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            toDayLabe.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            toDayLabe.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 5)
        ])
    }
    @objc func addTaskTapped(){
        
            let addVC = AddTaskViewController()
            addVC.delegate = self
            let navController = UINavigationController(rootViewController: addVC)
        navController.modalPresentationStyle = .pageSheet
            present(navController, animated: true, completion: nil)
        }
       
        func fetchTask(){
    
            do {
                tasks = try self.content.fetch(Task.fetchRequest())
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if self.tasks.isEmpty {
                        self.tableView.isHidden = true
                        self.noTaskLabe.isHidden = false
                        
                    }else{
                        self.tableView.isHidden = false
                        self.noTaskLabe.isHidden = true
                    }
                }
            }catch{
                print("Failed to fetch tasks : \(error)")
            }
        }
        
        // table view func ........
    func numberOfSections(in tableView: UITableView) -> Int {
      return  tasks.count
    }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //  let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "taskCell")
            let task = tasks[indexPath.section]
            cell.textLabel?.text = "✏️\t" + task.title!
            cell.textLabel?.textColor = UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 1.0)
            if task.isCompleted {
                let color = UIColor(red: 109/255, green: 178/255, blue: 138/255, alpha: 1.0)
                let checkmarkImage = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(color,renderingMode: .alwaysOriginal)
                cell.accessoryView = UIImageView(image: checkmarkImage)
                
            }else{
                cell.accessoryView = .none
            }
            
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            if let taskDate = task.createdAt{
                cell.detailTextLabel?.text = "Added at:\t\(formatter.string(from: taskDate))"
                cell.detailTextLabel?.textColor = UIColor(red: 111/255, green: 111/255, blue: 111/255, alpha: 1.0)
            }else{
                cell.detailTextLabel?.text = ""
            }
          //  cell.translatesAutoresizingMaskIntoConstraints = false
       //     cell.contentView.backgroundColor = .white
        //    cell.contentView.layer.cornerRadius = 30
         //   cell.contentView.layer.masksToBounds = true
          //  cell.contentView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        //    cell.contentView.preservesSuperviewLayoutMargins = false
            cell.backgroundColor = .white
            return cell
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let task1 = tasks[indexPath.section]
        
            let color = UIColor(red: 109/255, green: 178/255, blue: 138/255, alpha: 1.0)
            
            let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
            
            let titleFont = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 25),
                             NSAttributedString.Key.foregroundColor:color]
            let titleAttrString = NSAttributedString(string: "Edit Task",attributes: titleFont)
            alert.setValue(titleAttrString, forKey: "attributedTitle")
            
            alert.addTextField{ UItextField in
                UItextField.text = task1.title
                UItextField.gestureRecognizers?.first?.view?.translatesAutoresizingMaskIntoConstraints = false
            }
            let saveAction = UIAlertAction(title: "save", style: .default){ _ in
                if let newTask = alert.textFields?.first?.text, !newTask.isEmpty {
                    task1.title = newTask
                    
                    do {
                        try self.content.save()
                    }catch{
                        
                    }
                    tableView.reloadData()
                }
            }
            let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            saveAction.setValue(color, forKey: "titleTextColor")
            cancelAction.setValue(color, forKey: "titleTextColor")
            alert.addAction(saveAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in
            
            let taskTodelete = self.tasks[indexPath.section]
            if let notiId = taskTodelete.notificationID {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notiId])

            }
            self.content.delete(taskTodelete)
            
            do {
                try self.content.save()
                self.tasks.remove(at: indexPath.section)
                tableView.reloadData()
                self.fetchTask()
            }catch{
                print("Error deleting task : \(error)")
                
            }
            
            completionHandler(true)
        }
        let color = UIColor(red: 109/255, green: 178/255, blue: 138/255, alpha: 1.0)
        
        deleteAction.backgroundColor = .systemRed
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let trashImage = UIImage(systemName: "trash",withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        deleteAction.image = trashImage
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { _, _, completionHandler in
            
            let task = self.tasks[indexPath.section]
            task.isCompleted.toggle()
            do{
                try self.content.save()
                tableView.reloadData()
                self.fetchTask()
                
            }catch{
                print("Error updating task : \(error)")
                
            }
            completionHandler(true)
        }
        doneAction.backgroundColor = color
        
        let confige = UISwipeActionsConfiguration(actions: [deleteAction , doneAction])
        return confige
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacerView = UIView()
        spacerView.backgroundColor = .clear
        return spacerView
    }
    
    
    }




