SELECT System.Timestamp AS WindowEnd, COUNT(*) AS FraudulentCalls
INTO "PhoneCallRefData"
FROM "PhoneStream" CS1 TIMESTAMP BY CallRecTime
JOIN "PhoneStream" CS2 TIMESTAMP BY CallRecTime
ON CS1.CallingIMSI = CS2.CallingIMSI
AND DATEDIFF(ss, CS1, CS2) BETWEEN 1 AND 5
WHERE CS1.SwitchNum != CS2.SwitchNum
GROUP BY TumblingWindow(Duration(second, 1))
