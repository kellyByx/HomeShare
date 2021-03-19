CREATE VIEW [dbo].[V_GetRandom]
	AS SELECT FLOOR(RAND()*10) AS RandomValue

	-- Rappel on le met dans une vue car random ne peut pas etre use dans une fonction ("regle de chez sqlServer").