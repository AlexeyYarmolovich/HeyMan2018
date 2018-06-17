//
//  Exchange.swift
//  HeyMan2018
//
//  Created by Artsiom Grintsevich on 17.06.2018.
//  Copyright © 2018 HeyMan. All rights reserved.
//

import SwiftyJSON

let mtbankRates = """
{
    "exchange": [
    {
    "rate": "2.0020",
    "abbreviation": "USD"
    },
    {
    "rate": "2.3240",
    "abbreviation": "EUR"
    },
    {
    "abbreviation": "RUB",
    "rate": "3.2050"
    },
    {
    "abbreviation": "AUD",
    "rate": 1.4932
    },
    {
    "abbreviation": "BGN",
    "rate": 1.1865
    },
    {
    "abbreviation": "UAH",
    "rate": 7.5913
    },
    {
    "abbreviation": "DKK",
    "rate": 3.1149
    },
    {
    "abbreviation": "PLN",
    "rate": 5.4257
    },
    {
    "abbreviation": "IRR",
    "rate": 4.7276
    },
    {
    "abbreviation": "ISK",
    "rate": 1.8731
    },
    {
    "abbreviation": "JPY",
    "rate": 1.81
    },
    {
    "abbreviation": "CAD",
    "rate": 1.5218
    },
    {
    "abbreviation": "CNY",
    "rate": 3.116
    },
    {
    "abbreviation": "KWD",
    "rate": 6.6105
    },
    {
    "abbreviation": "MDL",
    "rate": 1.1909
    },
    {
    "abbreviation": "NZD",
    "rate": 1.3896
    },
    {
    "abbreviation": "NOK",
    "rate": 2.4581
    },
    {
    "abbreviation": "XDR",
    "rate": 2.8465
    },
    {
    "abbreviation": "SGD",
    "rate": 1.4851
    },
    {
    "abbreviation": "KGS",
    "rate": 2.9293
    },
    {
    "abbreviation": "KZT",
    "rate": 5.9412
    },
    {
    "abbreviation": "TRY",
    "rate": 4.2177
    },
    {
    "abbreviation": "GBP",
    "rate": 2.6563
    },
    {
    "abbreviation": "CZK",
    "rate": 9.0215
    },
    {
    "abbreviation": "SEK",
    "rate": 2.2809
    },
    {
    "abbreviation": "CHF",
    "rate": 2.0066
    }
    ]
}
"""

let priorRates = """
{
"exchange": [
{
"abbreviation": "USD",
"rate": "2,011"
},
{
"abbreviation": "EUR",
"rate": "2.333"
},
{
"abbreviation": "RUB",
"rate": "3.26"
},
{
"abbreviation": "AUD",
"rate": 1.4932
},
{
"abbreviation": "BGN",
"rate": 1.1865
},
{
"abbreviation": "UAH",
"rate": 7.5913
},
{
"abbreviation": "DKK",
"rate": 3.1149
},
{
"abbreviation": "PLN",
"rate": 5.4257
},
{
"abbreviation": "IRR",
"rate": 4.7276
},
{
"abbreviation": "ISK",
"rate": 1.8731
},
{
"abbreviation": "JPY",
"rate": 1.81
},
{
"abbreviation": "CAD",
"rate": 1.5218
},
{
"abbreviation": "CNY",
"rate": 3.116
},
{
"abbreviation": "KWD",
"rate": 6.6105
},
{
"abbreviation": "MDL",
"rate": 1.1909
},
{
"abbreviation": "NZD",
"rate": 1.3896
},
{
"abbreviation": "NOK",
"rate": 2.4581
},
{
"abbreviation": "XDR",
"rate": 2.8465
},
{
"abbreviation": "SGD",
"rate": 1.4851
},
{
"abbreviation": "KGS",
"rate": 2.9293
},
{
"abbreviation": "KZT",
"rate": 5.9412
},
{
"abbreviation": "TRY",
"rate": 4.2177
},
{
"abbreviation": "GBP",
"rate": 2.6563
},
{
"abbreviation": "CZK",
"rate": 9.0215
},
{
"abbreviation": "SEK",
"rate": 2.2809
},
{
"abbreviation": "CHF",
"rate": 2.0066
}
]
}
"""

class Exchange {
    
    //для бест чоиса амаунт не важен пусть будет 100, пеймент метод с наименьшим значением возвращаемым бест чоис
    static func exchange(amount: Double, paymentMethod: PaymentMethod, fromCurrency: ExchangeCurrency) -> Double {
        if (paymentMethod.currency == fromCurrency.currency) {
            return amount
        }
        
        switch paymentMethod.type {
        case .visa:
            let usdExchange = getExchangeCurrency(bank: paymentMethod.bank, currency: .usd)!
            
            if (paymentMethod.currency != .usd) {
                let newAmount = exchange(amount: amount, fromCurrency: fromCurrency, toCurrency: usdExchange)
                let cardExchange = getExchangeCurrency(bank: paymentMethod.bank, currency: paymentMethod.currency)!
                return exchange(amount: newAmount, fromCurrency: fromCurrency, toCurrency: cardExchange)
            } else {
                return exchange(amount: amount, fromCurrency: fromCurrency, toCurrency: usdExchange)
            }
        case .master:
            let eurExchange = getExchangeCurrency(bank: paymentMethod.bank, currency: .eur)!
            
            if (paymentMethod.currency != .eur) {
                let newAmount = exchange(amount: amount, fromCurrency: fromCurrency, toCurrency: eurExchange)
                let cardExchange = getExchangeCurrency(bank: paymentMethod.bank, currency: paymentMethod.currency)!
                return exchange(amount: newAmount, fromCurrency: fromCurrency, toCurrency: cardExchange)
            } else {
                return exchange(amount: amount, fromCurrency: fromCurrency, toCurrency: eurExchange)
            }
        }
    }
    
    static func exchange(amount: Double, fromCurrency: ExchangeCurrency, toCurrency: ExchangeCurrency) -> Double {
        return amount * fromCurrency.rate / toCurrency.rate
    }
    
    static func getExchangeCurrency(bank: Bank, currency: Currency) -> ExchangeCurrency? {
        switch bank {
        case .mtb:
            guard let json = try? JSON(data: mtbankRates.data(using: .utf8)!) else { return nil }
            return json.arrayValue.map { ExchangeCurrency(json: $0) }.filter { $0 != nil }.map { $0! }.first { $0.currency == currency }
        case .prior:
            guard let json = try? JSON(data: priorRates.data(using: .utf8)!) else { return nil }
            return json.arrayValue.map { ExchangeCurrency(json: $0) }.filter { $0 != nil }.map { $0! }.first { $0.currency == currency }
        }
    }
    
}




