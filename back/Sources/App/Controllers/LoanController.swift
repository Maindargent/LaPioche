import Fluent
import Vapor

struct LoanController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let loans = routes.grouped("loans")
        loans.post(use: create)
        loans.post("game", ":gameID", "return", use: returnLoanByGame)
        
        routes.get("members", ":memberID", "loans", use: getMemberLoans)
    }

    @Sendable
    func create(req: Request) async throws -> Response {
        let dto = try req.content.decode(CreateLoanDTO.self)

        guard let game = try await Game.find(dto.gameID, on: req.db) else {
            throw Abort(.notFound, reason: "Game not found")
        }
        
        let activeLoan = try await Loan.query(on: req.db)
            .filter(\.$game.$id == game.id!)
            .filter(\.$returnedAt == nil)
            .first()

        guard activeLoan == nil else {
            throw Abort(.conflict, reason: "Game is already borrowed")
        }
        
        guard let member = try await Member.find(dto.memberID, on: req.db) else {
            throw Abort(.notFound, reason: "Member not found")
        }

        let now = Date()
        let loan = Loan(
            gameID: try game.requireID(),
            memberID: try member.requireID(),
            borrowedAt: now,
            dueAt: try Loan.dueDate(from: now)
        )
        try await loan.save(on: req.db)
        return try await loan.toDTO().encodeResponse(status: .created, for: req)
    }
    
    @Sendable
    func returnLoanByGame(req: Request) async throws -> Response {
        let gameID = try req.parameters.require("gameID", as: UUID.self)
        
        guard let activeLoan = try await Loan.query(on: req.db)
            .filter(\.$game.$id == gameID)
            .filter(\.$returnedAt == nil)
            .first() else {
            throw Abort(.notFound, reason: "Active loan not found for this game")
        }
        
        activeLoan.returnedAt = Date()
        try await activeLoan.save(on: req.db)
        
        return try await activeLoan.toDTO().encodeResponse(for: req)
    }
    
    @Sendable
    func getMemberLoans(req: Request) async throws -> Response {
        let memberID = try req.parameters.require("memberID", as: UUID.self)
        
        guard let member = try await Member.find(memberID, on: req.db) else {
                    throw Abort(.notFound, reason: "Member not found")
                }
        
        let loans = try await Loan.query(on: req.db)
                    .filter(\.$member.$id == memberID)
                    .all()
        
        let loanDTOs = loans.map { $0.toDTO() }
                return try await loanDTOs.encodeResponse(for: req)
    }
}
