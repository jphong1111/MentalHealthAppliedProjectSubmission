//
//  DemographicViewController2.swift
//  MentalHealth
//
//

import UIKit

final class DemographicViewController2: BaseViewController {
    
    private let tableView = UITableView(frame: .zero, style: .plain)

    private enum DemographicItem: Int, CaseIterable {
        case age, status, ethnicity

        var title: String {
            switch self {
            case .age: return .localized(.age)
            case .status: return .localized(.currentStatus)
            case .ethnicity: return .localized(.ethnicity)
            }
        }

        func value() -> String {
            if LoginManager.shared.isLoggedIn() {
                switch self {
                case .age:
                    return LoginManager.shared.getAge()
                case .status:
                    return LoginManager.shared.getWorkStatus()
                case .ethnicity:
                    return LoginManager.shared.getEthnicity()
                }
            } else {
                return "N/A"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SoliUColor.homepageBackground
        setCustomBackNavigationButton()
        setNavigationTitle(title: .localized(.demographics))
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(DemographicItem.allCases.count) * 64) // fixed height
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.register(DemographicCell.self, forCellReuseIdentifier: "DemographicCell")
    }
}

extension DemographicViewController2: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DemographicItem.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = DemographicItem(rawValue: indexPath.row),
              let cell = tableView.dequeueReusableCell(withIdentifier: "DemographicCell", for: indexPath) as? DemographicCell
        else { return UITableViewCell() }

        cell.configure(title: item.title, value: item.value())
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = DemographicItem(rawValue: indexPath.row) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        
        // MARK: Push to specific detail controller
        let detailVC = UIViewController()
        detailVC.view.backgroundColor = .systemBackground
        detailVC.title = item.title
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

final class DemographicCell: UITableViewCell {

    private let titleLabel = SoliULabel()
    private let valueLabel = SoliULabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }

    private func setup() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        valueLabel.font = UIFont.preferredFont(forTextStyle: .body)
        valueLabel.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
