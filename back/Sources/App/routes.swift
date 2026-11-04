import Vapor

func routes(_ app: Application) throws {
    try app.register(collection: GameController())
    try app.register(collection: MemberController())
    try app.register(collection: LoanController())
}
