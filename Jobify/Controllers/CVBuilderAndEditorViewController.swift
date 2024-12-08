import UIKit



class CVBuilderAndEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    var educations: [Education] = []

//    @IBOutlet weak var txtDegree: UITextField!
//    
//    @IBOutlet weak var tableView: UITableView!
//    
//    @IBOutlet weak var txtInstitution: UITextField!
//
    @IBOutlet weak var txtFrom: UITextField!
//    
    @IBOutlet weak var txtTo: UITextField!
//    

    @IBOutlet weak var imageUploadCircle: UIImageView!
    

    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        setupImageUploadCircle()
//        tableView.dataSource = self
    }

    // MARK: - Date Picker Setup
    func createDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "en_US")

        // Add a toolbar with a Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)

        txtFrom.inputAccessoryView = toolbar
        txtFrom.inputView = datePicker

        txtTo.inputAccessoryView = toolbar
        txtTo.inputView = datePicker
    }

    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        let dateString = formatter.string(from: datePicker.date)

        if txtFrom.isFirstResponder {
            txtFrom.text = dateString
        } else if txtTo.isFirstResponder {
            txtTo.text = dateString
        }

        view.endEditing(true)
    }

    // MARK: - Save Education
//    @IBAction func saveAndAddAnother(_ sender: UIButton) {
//        saveEducation(shouldNavigate: false)
//    }

//    private func saveEducation(shouldNavigate: Bool) {
//        guard let degree = txtDegree.text, !degree.isEmpty,
//              let institution = txtInstitution.text, !institution.isEmpty,
//              let startDateString = txtFrom.text, !startDateString.isEmpty,
//              let endDateString = txtTo.text, !endDateString.isEmpty else {
//            // Show an alert if needed
//            return
//        }
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM"
//
//        guard let startDate = dateFormatter.date(from: startDateString),
//              let endDate = dateFormatter.date(from: endDateString) else {
//            // Show an alert about invalid date format
//            return
//        }
//
//        let newEducation = Education(degree: degree, institution: institution, startDate: startDate, endDate: endDate)
//        educations.append(newEducation)
//        tableView.reloadData()
//        updateTableViewHeight()
//
//        // Clear the text fields
//        txtDegree.text = ""
//        txtInstitution.text = ""
//        txtFrom.text = ""
//        txtTo.text = ""
//
//        // Navigate to next page if needed
//    }

    // MARK: - TableView DataSource
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return educations.count
//    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "EducationCell", for: indexPath)
//        let education = educations[indexPath.row]
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM"
//
//        let startDateString = dateFormatter.string(from: education.startDate)
//
//
//        let endDateString = dateFormatter.string(from: education.endDate ?? Date()) // Default to the current date if endDate is nil
//
//        cell.textLabel?.text = "\(education.degree) at \(education.institution) (\(startDateString) - \(endDateString))"
//
//
//        cell.textLabel?.text = "\(education.degree) at \(education.institution) (\(startDateString) - \(endDateString))"
//        return cell
//    }

    // MARK: - Adjust TableView Height
//    private func updateTableViewHeight() {
//        let height = tableView.contentSize.height
//        var frame = tableView.frame
//        frame.size.height = height
//        tableView.frame = frame
//    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        tableView.layoutIfNeeded()
//        updateTableViewHeight()
    }

    // MARK: - Image Picker
    @IBAction func btnImagePicker(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        imageUploadCircle.image = image
        dismiss(animated: true)
    }

    private func setupImageUploadCircle() {
        imageUploadCircle.layer.cornerRadius = imageUploadCircle.frame.size.width / 2
        imageUploadCircle.clipsToBounds = true
    }
}
