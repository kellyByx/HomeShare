CREATE PROCEDURE [dbo].[SP_Check_Password]
	@login NVARCHAR(16),
	@password NVARCHAR(32)
AS
    DECLARE @hPassword VARBINARY(32)
	DECLARE @salt CHAR(8)
	DECLARE @newPassword VARBINARY(MAX)
	SELECT @salt = salt, @hPassword = Password FROM Membre WHERE login=@login
	SELECT @newPassword = dbo.SF_EncryptedPassword (@password, @salt)

	IF(@newPassword = @hPassword)

    BEGIN
        SELECT[Login], Nom, Prenom, Email, Pays, Telephone
		FROM Membre
		WHERE login=@login

	END 

	--mis en maximum pour etre large
