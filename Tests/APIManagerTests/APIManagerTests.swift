import XCTest
import Combine
@testable import APIManager

final class APIManagerTests: XCTestCase {
    
    var apiManager: APIManager!
    var cancellables: Set<AnyCancellable> = []
    
    struct GetMockEmployees: Codable {
        let data: [GetMockEmployee]
    }
    
    struct GetMockEmployee: Codable {
        let id: Int
        let employee_name: String
        let employee_salary: Double
        let employee_age: Int
        let profile_image: String
    }
    
    struct PostMockEmployeeResult: Codable {
        let status: String
        let data: PostMockEmployee
    }
    
    struct PostMockEmployee: Codable {
        let name: String
        let salary: String
        let age: String
    }

    override func setUp() {
        super.setUp()
        apiManager = APIManager(baseURL: "https://dummy.restapiexample.com", serviceName: "TestService")
    }
    
    override func tearDown() {
        apiManager = nil
        super.tearDown()
    }
    
    func testAPIGetMethod() {
        let expectation = self.expectation(description: "Get method called")
        
        apiManager.get(path: "/api/v1/employees")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Get method failed with error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { (response: GetMockEmployees) in
                XCTAssertFalse(response.data.first?.employee_name.isEmpty ?? true, "First employee's name should not be empty")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAPIPostMethod() {
        let requestBody = PostMockEmployee(name: "test", salary: "123", age: "23")
        let expectation = self.expectation(description: "Post method called")
        
        apiManager.post(path: "/api/v1/create", body: requestBody)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTFail("Post method failed with error: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { (response: PostMockEmployeeResult) in
                XCTAssertEqual(response.status, "success", "Response message should match")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}

