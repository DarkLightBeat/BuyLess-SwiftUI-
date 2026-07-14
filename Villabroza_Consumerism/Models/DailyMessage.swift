import Foundation

struct DailyMessage: Identifiable, Equatable {
    let id: UUID
    let challenge: String
    let quote: String
    let author: String
    let savings: Double // Added savings property
    
    init(id: UUID = UUID(), challenge: String, quote: String, author: String, savings: Double) {
        self.id = id
        self.challenge = challenge
        self.quote = quote
        self.author = author
        self.savings = savings
    }
}

let dailyMessages: [DailyMessage] = [
    DailyMessage(
        challenge: "Before buying anything today, wait 10 minutes and ask yourself: Do I really need this?",
        quote: "The things you own end up owning you.",
        author: "Chuck Palahniuk",
        savings: 5.0
    ),
    DailyMessage(
        challenge: "Today, unfollow social media accounts that make you want to buy things you don't need.",
        quote: "The secret of happiness is not found in seeking more, but in developing the capacity to enjoy less.",
        author: "Socrates",
        savings: 10.0
    ),
    DailyMessage(
        challenge: "Write down everything you want to buy today, then revisit the list tomorrow.",
        quote: "The more you own, the more it owns you.",
        author: "Henry Rollins",
        savings: 7.0
    ),
    DailyMessage(
        challenge: "Instead of buying something new today, try to repair something you already own.",
        quote: "Simplicity is the ultimate sophistication.",
        author: "Leonardo da Vinci",
        savings: 8.0
    ),
    DailyMessage(
        challenge: "Calculate how many hours you need to work to buy that item you want.",
        quote: "Too many people spend money they haven't earned, to buy things they don't want, to impress people they don't like.",
        author: "Will Rogers",
        savings: 12.0
    ),
    DailyMessage(
        challenge: "Today, try the 24-hour rule: Wait 24 hours before making any non-essential purchase.",
        quote: "The ability to simplify means to eliminate the unnecessary so that the necessary may speak.",
        author: "Hans Hofmann",
        savings: 6.0
    ),
    DailyMessage(
        challenge: "Make a list of 5 free activities you enjoy, and do one of them today instead of shopping.",
        quote: "Life is not about having everything. It's about finding meaning in everything.",
        author: "Unknown",
        savings: 4.0
    ),
    DailyMessage(
        challenge: "Take photos of everything you own in one category (like shoes). Are you surprised by how much you have?",
        quote: "Collect moments, not things.",
        author: "Paulo Coelho",
        savings: 3.0
    ),
    DailyMessage(
        challenge: "Today, find three items you haven't used in months and donate them.",
        quote: "The greatest wealth is to live content with little.",
        author: "Plato",
        savings: 15.0
    ),
    DailyMessage(
        challenge: "Create a wishlist today and revisit it after 30 days. See if you still want those items.",
        quote: "Happiness is not in money, but in the joy of achievement.",
        author: "Eleanor Roosevelt",
        savings: 2.0
    ),
    DailyMessage(
        challenge: "Try a 'no-spend' day challenge today. Only use what you already have.",
        quote: "It is not how much you have that makes you happy or unhappy, it is how much you want.",
        author: "William Shakespeare",
        savings: 20.0
    ),
    DailyMessage(
        challenge: "Before each purchase today, ask: 'Will this matter to me in one year?'",
        quote: "The best things in life aren't things.",
        author: "Art Buchwald",
        savings: 1.0
    ),
    DailyMessage(
        challenge: "Calculate your hourly wage and convert item prices into hours of work required.",
        quote: "Time is money, but money isn't worth your time.",
        author: "Joshua Fields Millburn",
        savings: 9.0
    ),
    DailyMessage(
        challenge: "Today, practice mindful spending by using only cash - no cards.",
        quote: "Wealth consists not in having great possessions, but in having few wants.",
        author: "Epictetus",
        savings: 11.0
    )
]
