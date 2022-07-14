import Foundation

struct Employee: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name = "full_name"
        case phone = "phone_number"
        case email = "email_address"
        case biography = "biography"
        case photoUrlSmall = "photo_url_small"
        case photoUrlLarge = "photo_url_large"
        case team = "team"
        case type = "employee_type"
    }

    let id: String
    let name: String
    let phone: String
    let email: String
    let biography: String
    let photoUrlSmall: String
    let photoUrlLarge: String
    let team: String
    let type: String
}

struct Employees: Codable {
    enum CodingKeys: String, CodingKey {
        case employees = "employees"
    }

    let employees: [Employee]
}
