' Windows Installer utility to execute SQL statements against an installer database
' For use with Windows Scripting Host, CScript.exe or WScript.exe
' Copyright (c) Microsoft Corporation. All rights reserved.
' Demonstrates the script-driven database queries and updates
'
Option Explicit

Const msiOpenDatabaseModeReadOnly = 0
Const msiOpenDatabaseModeTransact = 1

Dim argNum, argCount:argCount = Wscript.Arguments.Count
If (argCount < 2) Then
	Wscript.Echo "Windows Installer utility to execute SQL queries against an installer database." &_
		vbLf & " The 1st argument specifies the path to the MSI database, relative or full path" &_
		vbLf & " Subsequent arguments specify SQL queries to execute - must be in double quotes" &_
		vbLf & " SELECT queries will display the rows of the result list specified in the query" &_
		vbLf & " Binary data columns selected by a query will not be displayed" &_
		vblf &_
		vblf & "Copyright (C) Microsoft Corporation.  All rights reserved."
	Wscript.Quit 1
End If

' Scan arguments for valid SQL keyword and to determine if any update operations
Dim openMode : openMode = msiOpenDatabaseModeReadOnly
For argNum = 1 To argCount - 1
	Dim keyword : keyword = Wscript.Arguments(argNum)
	Dim keywordLen : keywordLen = InStr(1, keyword, " ", vbTextCompare)
	If (keywordLen) Then keyword = UCase(Left(keyword, keywordLen - 1))
	If InStr(1, "UPDATE INSERT DELETE CREATE ALTER DROP", keyword, vbTextCompare) Then
		openMode = msiOpenDatabaseModeTransact
	ElseIf keyword <> "SELECT" Then
		Fail "Invalid SQL statement type: " & keyword
	End If
Next

' Connect to Windows installer object
On Error Resume Next
Dim installer : Set installer = Nothing
Set installer = Wscript.CreateObject("WindowsInstaller.Installer") : CheckError

' Open database
Dim databasePath:databasePath = Wscript.Arguments(0)
Dim database : Set database = installer.OpenDatabase(databasePath, openMode) : CheckError

' Process SQL statements
Dim query, view, record, message, rowData, columnCount, delim, column
For argNum = 1 To argCount - 1
	query = Wscript.Arguments(argNum)
	Set view = database.OpenView(query) : CheckError
	view.Execute : CheckError
	If Ucase(Left(query, 6)) = "SELECT" Then
		Do
			Set record = view.Fetch
			If record Is Nothing Then Exit Do
			columnCount = record.FieldCount
			rowData = Empty
			delim = "  "
			For column = 1 To columnCount
				If column = columnCount Then delim = vbLf
				rowData = rowData & record.StringData(column) & delim
			Next
			message = message & rowData
		Loop
	End If
Next
If openMode = msiOpenDatabaseModeTransact Then database.Commit
If Not IsEmpty(message) Then Wscript.Echo message
Wscript.Quit 0

Sub CheckError
	Dim message, errRec
	If Err = 0 Then Exit Sub
	message = Err.Source & " " & Hex(Err) & ": " & Err.Description
	If Not installer Is Nothing Then
		Set errRec = installer.LastErrorRecord
		If Not errRec Is Nothing Then message = message & vbLf & errRec.FormatText
	End If
	Fail message
End Sub

Sub Fail(message)
	Wscript.Echo message
	Wscript.Quit 2
End Sub

'' SIG '' Begin signature block
'' SIG '' MIIl2QYJKoZIhvcNAQcCoIIlyjCCJcYCAQExDzANBglg
'' SIG '' hkgBZQMEAgEFADB3BgorBgEEAYI3AgEEoGkwZzAyBgor
'' SIG '' BgEEAYI3AgEeMCQCAQEEEE7wKRaZJ7VNj+Ws4Q8X66sC
'' SIG '' AQACAQACAQACAQACAQAwMTANBglghkgBZQMEAgEFAAQg
'' SIG '' 4Xv5+5ronXWl5cvPsyZzr63fsdqLVPGyNx2CnUPSw9mg
'' SIG '' ggtnMIIE7zCCA9egAwIBAgITMwAABI8LuXzfev9KVwAA
'' SIG '' AAAEjzANBgkqhkiG9w0BAQsFADB+MQswCQYDVQQGEwJV
'' SIG '' UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
'' SIG '' UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
'' SIG '' cmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQgQ29kZSBT
'' SIG '' aWduaW5nIFBDQSAyMDEwMB4XDTIyMDUxMjIwNDcwNFoX
'' SIG '' DTIzMDUxMTIwNDcwNFowdDELMAkGA1UEBhMCVVMxEzAR
'' SIG '' BgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
'' SIG '' bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
'' SIG '' bjEeMBwGA1UEAxMVTWljcm9zb2Z0IENvcnBvcmF0aW9u
'' SIG '' MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
'' SIG '' rFg6I4sFMZksBRKLHGkPdpolDVGDvZHl4O+++GZTrC3L
'' SIG '' EanR0YLQILO3WPPIwvJtKIdYjCIodj8WW1zol9CGIuCB
'' SIG '' U9+iNyYC/VwR4NcBSoRX73JQoxhkK9UmlV6alaRI7BLX
'' SIG '' JU6yXXg+c+z1TFbMsmBDZM0c76cIjA0/B+UEl4UNPy1W
'' SIG '' 7nR95LWq+6VbMErXrGhL5q7uW8HPCHiu1Px/URbATCLU
'' SIG '' XFhJ/7zXgEW3RGwqwiblwp9rnPCcsmKiXi6SJdpEbMhc
'' SIG '' p+FZHGrSEUKvmTGx0eeElkRyCwtIJhz+IzImcH+GOcSc
'' SIG '' uK8HmiXdF7V8Ws2tb17h/14YGfk4kvTluwIDAQABo4IB
'' SIG '' bjCCAWowHwYDVR0lBBgwFgYKKwYBBAGCNz0GAQYIKwYB
'' SIG '' BQUHAwMwHQYDVR0OBBYEFNjsHfbiAnqmDcu6Bqgh77Q9
'' SIG '' ne7NMEUGA1UdEQQ+MDykOjA4MR4wHAYDVQQLExVNaWNy
'' SIG '' b3NvZnQgQ29ycG9yYXRpb24xFjAUBgNVBAUTDTIzMDg2
'' SIG '' NSs0NzA1NjEwHwYDVR0jBBgwFoAU5vxfe7siAFjkck61
'' SIG '' 9CF0IzLm76wwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDov
'' SIG '' L2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVj
'' SIG '' dHMvTWljQ29kU2lnUENBXzIwMTAtMDctMDYuY3JsMFoG
'' SIG '' CCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0cDov
'' SIG '' L3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWND
'' SIG '' b2RTaWdQQ0FfMjAxMC0wNy0wNi5jcnQwDAYDVR0TAQH/
'' SIG '' BAIwADANBgkqhkiG9w0BAQsFAAOCAQEAply9JxwlaV3T
'' SIG '' C5ZdD1PSra9eTQjYsru5tLVPOEcXJQMSP5UfZe2dAzV/
'' SIG '' tyHT8as/XD2cK4YKZmHW3W5LdQzkaPS+rF4W7L5qylGW
'' SIG '' gKlZN1GEMz904vo1Y5pA90PfkSTth8UoRf03682EZLUx
'' SIG '' FMMvzIdA3iNtPnYp4b0n/cwZSf8YpxE1wFoqi0xKLtRN
'' SIG '' 3n/u7LNmhlMOv3eJ9yU0UPUnEHGEpFIgtlagmFaRllHu
'' SIG '' 1PojPSBYA0BeaGK89U8QmqxL5JRgXxm+oUTLNBZMZV91
'' SIG '' W6Pczb778rDwNF5TrjHyGXx1aRqzNcHEU+a62gO5U3mz
'' SIG '' /cI1Lr9VqU8W3Nn9MIZ0qDCCBnAwggRYoAMCAQICCmEM
'' SIG '' UkwAAAAAAAMwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNV
'' SIG '' BAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYD
'' SIG '' VQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQg
'' SIG '' Q29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29mdCBS
'' SIG '' b290IENlcnRpZmljYXRlIEF1dGhvcml0eSAyMDEwMB4X
'' SIG '' DTEwMDcwNjIwNDAxN1oXDTI1MDcwNjIwNTAxN1owfjEL
'' SIG '' MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
'' SIG '' EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
'' SIG '' c29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
'' SIG '' b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMDCCASIwDQYJ
'' SIG '' KoZIhvcNAQEBBQADggEPADCCAQoCggEBAOkOZFB5Z7XE
'' SIG '' 4/0JAEyelKz3VmjqRNjPxVhPqaV2fG1FutM5krSkHvn5
'' SIG '' ZYLkF9KP/UScCOhlk84sVYS/fQjjLiuoQSsYt6JLbklM
'' SIG '' axUH3tHSwokecZTNtX9LtK8I2MyI1msXlDqTziY/7Ob+
'' SIG '' NJhX1R1dSfayKi7VhbtZP/iQtCuDdMorsztG4/BGScEX
'' SIG '' ZlTJHL0dxFViV3L4Z7klIDTeXaallV6rKIDN1bKe5QO1
'' SIG '' Y9OyFMjByIomCll/B+z/Du2AEjVMEqa+Ulv1ptrgiwtI
'' SIG '' d9aFR9UQucboqu6Lai0FXGDGtCpbnCMcX0XjGhQebzfL
'' SIG '' GTOAaolNo2pmY3iT1TDPlR8CAwEAAaOCAeMwggHfMBAG
'' SIG '' CSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBTm/F97uyIA
'' SIG '' WORyTrX0IXQjMubvrDAZBgkrBgEEAYI3FAIEDB4KAFMA
'' SIG '' dQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUw
'' SIG '' AwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvX
'' SIG '' zpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3Js
'' SIG '' Lm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9N
'' SIG '' aWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYIKwYB
'' SIG '' BQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3
'' SIG '' Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0Nl
'' SIG '' ckF1dF8yMDEwLTA2LTIzLmNydDCBnQYDVR0gBIGVMIGS
'' SIG '' MIGPBgkrBgEEAYI3LgMwgYEwPQYIKwYBBQUHAgEWMWh0
'' SIG '' dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9QS0kvZG9jcy9D
'' SIG '' UFMvZGVmYXVsdC5odG0wQAYIKwYBBQUHAgIwNB4yIB0A
'' SIG '' TABlAGcAYQBsAF8AUABvAGwAaQBjAHkAXwBTAHQAYQB0
'' SIG '' AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIB
'' SIG '' ABp071dPKXvEFoV4uFDTIvwJnayCl/g0/yosl5US5eS/
'' SIG '' z7+TyOM0qduBuNweAL7SNW+v5X95lXflAtTx69jNTh4b
'' SIG '' YaLCWiMa8IyoYlFFZwjjPzwek/gwhRfIOUCm1w6zISnl
'' SIG '' paFpjCKTzHSY56FHQ/JTrMAPMGl//tIlIG1vYdPfB9XZ
'' SIG '' cgAsaYZ2PVHbpjlIyTdhbQfdUxnLp9Zhwr/ig6sP4Gub
'' SIG '' ldZ9KFGwiUpRpJpsyLcfShoOaanX3MF+0Ulwqratu3JH
'' SIG '' Yxf6ptaipobsqBBEm2O2smmJBsdGhnoYP+jFHSHVe/kC
'' SIG '' Iy3FQcu/HUzIFu+xnH/8IktJim4V46Z/dlvRU3mRhZ3V
'' SIG '' 0ts9czXzPK5UslJHasCqE5XSjhHamWdeMoz7N4XR3HWF
'' SIG '' nIfGWleFwr/dDY+Mmy3rtO7PJ9O1Xmn6pBYEAackZ3PP
'' SIG '' TU+23gVWl3r36VJN9HcFT4XG2Avxju1CCdENduMjVngi
'' SIG '' Jja+yrGMbqod5IXaRzNij6TJkTNfcR5Ar5hlySLoQiEl
'' SIG '' ihwtYNk3iUGJKhYP12E8lGhgUu/WR5mggEDuFYF3Ppzg
'' SIG '' UxgaUB04lZseZjMTJzkXeIc2zk7DX7L1PUdTtuDl2wth
'' SIG '' PSrXkizON1o+QEIxpB8QCMJWnL8kXVECnWp50hfT2sGU
'' SIG '' jgd7JXFEqwZq5tTG3yOalnXFMYIZyjCCGcYCAQEwgZUw
'' SIG '' fjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
'' SIG '' b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1p
'' SIG '' Y3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWlj
'' SIG '' cm9zb2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMAITMwAA
'' SIG '' BI8LuXzfev9KVwAAAAAEjzANBglghkgBZQMEAgEFAKCC
'' SIG '' AQQwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYK
'' SIG '' KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZI
'' SIG '' hvcNAQkEMSIEIJOiYJa6ler9w7Z0AEG+numUSJoIdJs/
'' SIG '' 2T8qo6aw8v27MDwGCisGAQQBgjcKAxwxLgwsc1BZN3hQ
'' SIG '' QjdoVDVnNUhIcll0OHJETFNNOVZ1WlJ1V1phZWYyZTIy
'' SIG '' UnM1ND0wWgYKKwYBBAGCNwIBDDFMMEqgJIAiAE0AaQBj
'' SIG '' AHIAbwBzAG8AZgB0ACAAVwBpAG4AZABvAHcAc6EigCBo
'' SIG '' dHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vd2luZG93czAN
'' SIG '' BgkqhkiG9w0BAQEFAASCAQASjyq/mmfjgeu+aRJvRQyH
'' SIG '' 62IaLLLCVCCtJNhyg6qUYlCWjg+R3MCUph7Y3Dsqi75s
'' SIG '' d5ojRixIMyLxi4IU8fg/3RwylBoLy/yds4sb9KLVeJIp
'' SIG '' VKV4+tPG45adLTFlyu1sx/VKtaWf0pQI42CNiEoQkNTG
'' SIG '' JWm0GqJYAjf0XEhOahvtOcnWezP/Gyi0NIgQCj2slDxM
'' SIG '' a4TFcCzd+h1CyVl2lm+azFQE13rNooP+NcZUeqzQumOm
'' SIG '' KQPdtEaKYgJEvQPtW2Rz19soznHHU3Wa0ASZDkv1VJ9z
'' SIG '' eQJ7QFlLSGXqJA0dOCdbu7jKNLwguvRSNl2a5/FMkLYH
'' SIG '' fVax/EsKL+tCoYIW/TCCFvkGCisGAQQBgjcDAwExghbp
'' SIG '' MIIW5QYJKoZIhvcNAQcCoIIW1jCCFtICAQMxDzANBglg
'' SIG '' hkgBZQMEAgEFADCCAVEGCyqGSIb3DQEJEAEEoIIBQASC
'' SIG '' ATwwggE4AgEBBgorBgEEAYRZCgMBMDEwDQYJYIZIAWUD
'' SIG '' BAIBBQAEIFRh2kIVhQAgOzHe+VWKWjgjJgAdmVSVhQVY
'' SIG '' NExZB2tKAgZjR/eTNZUYEzIwMjIxMDIwMDQxNTQxLjU3
'' SIG '' MlowBIACAfSggdCkgc0wgcoxCzAJBgNVBAYTAlVTMRMw
'' SIG '' EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
'' SIG '' b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
'' SIG '' b24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVyaWNhIE9w
'' SIG '' ZXJhdGlvbnMxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNO
'' SIG '' OjNCQkQtRTMzOC1FOUExMSUwIwYDVQQDExxNaWNyb3Nv
'' SIG '' ZnQgVGltZS1TdGFtcCBTZXJ2aWNloIIRVDCCBwwwggT0
'' SIG '' oAMCAQICEzMAAAGd/onl+Xu7TMAAAQAAAZ0wDQYJKoZI
'' SIG '' hvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
'' SIG '' Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
'' SIG '' BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQG
'' SIG '' A1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIw
'' SIG '' MTAwHhcNMjExMjAyMTkwNTE5WhcNMjMwMjI4MTkwNTE5
'' SIG '' WjCByjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
'' SIG '' bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
'' SIG '' FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMc
'' SIG '' TWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEmMCQG
'' SIG '' A1UECxMdVGhhbGVzIFRTUyBFU046M0JCRC1FMzM4LUU5
'' SIG '' QTExJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1w
'' SIG '' IFNlcnZpY2UwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAw
'' SIG '' ggIKAoICAQDgEWh60BxJFuR+mlFuFCtG3mR2XHNCfPMT
'' SIG '' Xcp06YewAtS1bbGzK7hDC1JRMethcmiKM/ebdCcG6v6k
'' SIG '' 4lQyLlSaHmHkIUC5pNEtlutzpsVN+jo+Nbdyu9w0BMh4
'' SIG '' KzfduLdxbda1VztKDSXjE3eEl5Of+5hY3pHoJX9Nh/5r
'' SIG '' 4tc4Nvqt9tvVcYeIxpchZ81AK3+UzpA+hcR6HS67XA8+
'' SIG '' cQUB1fGyRoVh1sCu0+ofdVDcWOG/tcSKtJch+eRAVDe7
'' SIG '' IRm84fPsPTFz2dIJRJA/PUaZR+3xW4Fd1ZbLNa/wMbq3
'' SIG '' vaYtKogaSZiiCyUxU7mwoA32iyTcGHC7hH8MgZWVOEBu
'' SIG '' 7CfNvMyrsR8Quvu3m91Dqsc5gZHMxvgeAO9LLiaaU+kl
'' SIG '' YmFWQvLXpilS1iDXb/82+TjwGtxEnc8x/EvLkk7Ukj4u
'' SIG '' KZ6J8ynlgPhPRqejcoKlHsKgxWmD3wzEXW1a09d1L2Io
'' SIG '' 004w01i31QAMB/GLhgmmMIE5Z4VI2Jlh9sX2nkyh5QOn
'' SIG '' YOznECk4za9cIdMKP+sde2nhvvcSdrGXQ8fWO/+N1mjT
'' SIG '' 0SIkX41XZjm+QMGR03ta63pfsj3g3E5a1r0o9aHgcuph
'' SIG '' W0lwrbBA/TGMo5zC8Z5WI+Rwpr0MAiDZGy5h2+uMx/2+
'' SIG '' /F4ZiyKauKXqd7rIl1seAYQYxKQ4SemB0QIDAQABo4IB
'' SIG '' NjCCATIwHQYDVR0OBBYEFNbfEI3hKujMnF4Rgdvay4rZ
'' SIG '' G1XkMB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1
'' SIG '' GelyMF8GA1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cu
'' SIG '' bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29m
'' SIG '' dCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNy
'' SIG '' bDBsBggrBgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0
'' SIG '' dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2Vy
'' SIG '' dHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
'' SIG '' MDIwMTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwEwYDVR0l
'' SIG '' BAwwCgYIKwYBBQUHAwgwDQYJKoZIhvcNAQELBQADggIB
'' SIG '' AIbHcpxLt2h0LNJ334iCNZYsta2Eant9JUeipwebFIwQ
'' SIG '' Mij7SIQ83iJ4Y4OL5YwlppwvF516AhcHevYMScY6NAXS
'' SIG '' AGhp5xYtkEckeV6gNbcp3C4I3yotWvDd9KQCh7LdIhpi
'' SIG '' YCde0SF4N5JRZUHXIMczvNhe8+dEuiCnS1sWiGPUFzNJ
'' SIG '' fsAcNs1aBkHItaSxM0AVHgZfgK8R2ihVktirxwYG0T9o
'' SIG '' 1h0BkRJ3PfuJF+nOjt1+eFYYgq+bOLQs/SdgY4DbUVfr
'' SIG '' tLdEg2TbS+siZw4dqzM+tLdye5XGyJlKBX7aIs4xf1Hh
'' SIG '' 1ymMX24YJlm8vyX+W4x8yytPmziNHtshxf7lKd1Pm7t+
'' SIG '' 7UUzi8QBhby0vYrfrnoW1Kws+z34uoc2+D2VFxrH39xq
'' SIG '' /8KbeeBpuL5++CipoZQsd5QO5Ni81nBlwi/71JsZDEom
'' SIG '' so/k4JioyvVAM2818CgnsNJnMZZSxM5kyeRdYh9IbjGd
'' SIG '' PddPVcv0kPKrNalPtRO4ih0GVkL/a4BfEBtXDeEUIsM4
'' SIG '' A00QehD+ESV3I0UbW+b4NTmbRcjnVFk5t6nuK/FoFQc5
'' SIG '' N4XueYAOw2mMDhAoFE+2xtTHk2ewd9xGkbFDl2b6u/Fb
'' SIG '' hsUb5+XoP0PdJ3FTNP6G/7Vr4sIOxar4PpY674aQCiMS
'' SIG '' ywwtIWOoqRS/OP/rSjF9E/xfMIIHcTCCBVmgAwIBAgIT
'' SIG '' MwAAABXF52ueAptJmQAAAAAAFTANBgkqhkiG9w0BAQsF
'' SIG '' ADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
'' SIG '' bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
'' SIG '' FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMp
'' SIG '' TWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9y
'' SIG '' aXR5IDIwMTAwHhcNMjEwOTMwMTgyMjI1WhcNMzAwOTMw
'' SIG '' MTgzMjI1WjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMK
'' SIG '' V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
'' SIG '' A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYD
'' SIG '' VQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
'' SIG '' MDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIB
'' SIG '' AOThpkzntHIhC3miy9ckeb0O1YLT/e6cBwfSqWxOdcjK
'' SIG '' NVf2AX9sSuDivbk+F2Az/1xPx2b3lVNxWuJ+Slr+uDZn
'' SIG '' hUYjDLWNE893MsAQGOhgfWpSg0S3po5GawcU88V29YZQ
'' SIG '' 3MFEyHFcUTE3oAo4bo3t1w/YJlN8OWECesSq/XJprx2r
'' SIG '' rPY2vjUmZNqYO7oaezOtgFt+jBAcnVL+tuhiJdxqD89d
'' SIG '' 9P6OU8/W7IVWTe/dvI2k45GPsjksUZzpcGkNyjYtcI4x
'' SIG '' yDUoveO0hyTD4MmPfrVUj9z6BVWYbWg7mka97aSueik3
'' SIG '' rMvrg0XnRm7KMtXAhjBcTyziYrLNueKNiOSWrAFKu75x
'' SIG '' qRdbZ2De+JKRHh09/SDPc31BmkZ1zcRfNN0Sidb9pSB9
'' SIG '' fvzZnkXftnIv231fgLrbqn427DZM9ituqBJR6L8FA6PR
'' SIG '' c6ZNN3SUHDSCD/AQ8rdHGO2n6Jl8P0zbr17C89XYcz1D
'' SIG '' TsEzOUyOArxCaC4Q6oRRRuLRvWoYWmEBc8pnol7XKHYC
'' SIG '' 4jMYctenIPDC+hIK12NvDMk2ZItboKaDIV1fMHSRlJTY
'' SIG '' uVD5C4lh8zYGNRiER9vcG9H9stQcxWv2XFJRXRLbJbqv
'' SIG '' UAV6bMURHXLvjflSxIUXk8A8FdsaN8cIFRg/eKtFtvUe
'' SIG '' h17aj54WcmnGrnu3tz5q4i6tAgMBAAGjggHdMIIB2TAS
'' SIG '' BgkrBgEEAYI3FQEEBQIDAQABMCMGCSsGAQQBgjcVAgQW
'' SIG '' BBQqp1L+ZMSavoKRPEY1Kc8Q/y8E7jAdBgNVHQ4EFgQU
'' SIG '' n6cVXQBeYl2D9OXSZacbUzUZ6XIwXAYDVR0gBFUwUzBR
'' SIG '' BgwrBgEEAYI3TIN9AQEwQTA/BggrBgEFBQcCARYzaHR0
'' SIG '' cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9Eb2Nz
'' SIG '' L1JlcG9zaXRvcnkuaHRtMBMGA1UdJQQMMAoGCCsGAQUF
'' SIG '' BwMIMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsG
'' SIG '' A1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1Ud
'' SIG '' IwQYMBaAFNX2VsuP6KJcYmjRPZSQW9fOmhjEMFYGA1Ud
'' SIG '' HwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwubWljcm9zb2Z0
'' SIG '' LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1
'' SIG '' dF8yMDEwLTA2LTIzLmNybDBaBggrBgEFBQcBAQROMEww
'' SIG '' SgYIKwYBBQUHMAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0
'' SIG '' LmNvbS9wa2kvY2VydHMvTWljUm9vQ2VyQXV0XzIwMTAt
'' SIG '' MDYtMjMuY3J0MA0GCSqGSIb3DQEBCwUAA4ICAQCdVX38
'' SIG '' Kq3hLB9nATEkW+Geckv8qW/qXBS2Pk5HZHixBpOXPTEz
'' SIG '' tTnXwnE2P9pkbHzQdTltuw8x5MKP+2zRoZQYIu7pZmc6
'' SIG '' U03dmLq2HnjYNi6cqYJWAAOwBb6J6Gngugnue99qb74p
'' SIG '' y27YP0h1AdkY3m2CDPVtI1TkeFN1JFe53Z/zjj3G82jf
'' SIG '' ZfakVqr3lbYoVSfQJL1AoL8ZthISEV09J+BAljis9/kp
'' SIG '' icO8F7BUhUKz/AyeixmJ5/ALaoHCgRlCGVJ1ijbCHcNh
'' SIG '' cy4sa3tuPywJeBTpkbKpW99Jo3QMvOyRgNI95ko+ZjtP
'' SIG '' u4b6MhrZlvSP9pEB9s7GdP32THJvEKt1MMU0sHrYUP4K
'' SIG '' WN1APMdUbZ1jdEgssU5HLcEUBHG/ZPkkvnNtyo4JvbMB
'' SIG '' V0lUZNlz138eW0QBjloZkWsNn6Qo3GcZKCS6OEuabvsh
'' SIG '' VGtqRRFHqfG3rsjoiV5PndLQTHa1V1QJsWkBRH58oWFs
'' SIG '' c/4Ku+xBZj1p/cvBQUl+fpO+y/g75LcVv7TOPqUxUYS8
'' SIG '' vwLBgqJ7Fx0ViY1w/ue10CgaiQuPNtq6TPmb/wrpNPgk
'' SIG '' NWcr4A245oyZ1uEi6vAnQj0llOZ0dFtq0Z4+7X6gMTN9
'' SIG '' vMvpe784cETRkPHIqzqKOghif9lwY1NNje6CbaUFEMFx
'' SIG '' BmoQtB1VM1izoXBm8qGCAsswggI0AgEBMIH4oYHQpIHN
'' SIG '' MIHKMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
'' SIG '' Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
'' SIG '' TWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxN
'' SIG '' aWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMSYwJAYD
'' SIG '' VQQLEx1UaGFsZXMgVFNTIEVTTjozQkJELUUzMzgtRTlB
'' SIG '' MTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAg
'' SIG '' U2VydmljZaIjCgEBMAcGBSsOAwIaAxUAt+lDSRX92KFy
'' SIG '' ij71Jn20CoSyyuCggYMwgYCkfjB8MQswCQYDVQQGEwJV
'' SIG '' UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
'' SIG '' UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
'' SIG '' cmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1T
'' SIG '' dGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQUFAAIFAOb7
'' SIG '' BzgwIhgPMjAyMjEwMjAwNzMxMDRaGA8yMDIyMTAyMTA3
'' SIG '' MzEwNFowdDA6BgorBgEEAYRZCgQBMSwwKjAKAgUA5vsH
'' SIG '' OAIBADAHAgEAAgITLTAHAgEAAgITgDAKAgUA5vxYuAIB
'' SIG '' ADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMC
'' SIG '' oAowCAIBAAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3
'' SIG '' DQEBBQUAA4GBAH7sUzjDHtsCfI2mSeDj0GDREAffs5jA
'' SIG '' DGivlR5UvB6lbTPqrFcWKfzviVtgBSlSN+G3tLLmDVFS
'' SIG '' tbXxxcNW+NNLzBEapO4se1ibSj5N61JX0FwKX2eh17aR
'' SIG '' w/d35Q30AhOpNBHZ2XWcsgsK179YGJkhdxrDAacqXda9
'' SIG '' YP6N6T6mMYIEDTCCBAkCAQEwgZMwfDELMAkGA1UEBhMC
'' SIG '' VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
'' SIG '' B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
'' SIG '' b3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUt
'' SIG '' U3RhbXAgUENBIDIwMTACEzMAAAGd/onl+Xu7TMAAAQAA
'' SIG '' AZ0wDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJ
'' SIG '' AzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0BCQQxIgQg
'' SIG '' jjMIyTY1FF1PHKwMR2D4lAPyJQWK91+ChkibmhnwzLYw
'' SIG '' gfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCD1HmOt
'' SIG '' 4IqgT4A0n4JblX/fzFLyEu4OBDOb+mpMlYdFoTCBmDCB
'' SIG '' gKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
'' SIG '' aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
'' SIG '' ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMT
'' SIG '' HU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMz
'' SIG '' AAABnf6J5fl7u0zAAAEAAAGdMCIEIN2sMGoDXS/5+DGL
'' SIG '' EhDcnzOYncpcy9shJQOo6IgTkNKDMA0GCSqGSIb3DQEB
'' SIG '' CwUABIICAFONqWIwwyBc9OIvNpa9APU6+GEheQ/YsK/j
'' SIG '' z5fiiA2Q6x1v56Bt2jGYPM2YYu8/uF++RqlM4qQkLZYA
'' SIG '' BF+ggJlNmDkVcOG6DJEL9Kqgf0vS4nznb3yTBMXiSvVx
'' SIG '' xrG9YG/Lvywv2RuHZhufx6bJpPhd374fxrr0mUz/C16l
'' SIG '' ZPeTsBppHu7/Oumhkw5nLmiQt0dqU5z/9Zo7NLpbzLCZ
'' SIG '' F73qeAssZlK24rKax5MWu2fOxtgN/b8P5qPqm/4umwvM
'' SIG '' tUj/OUw+MaXd5Ux/pZASg7aCvIidbusz115zIl+XA3wX
'' SIG '' nFaWUj2oW5HxP/N80AzIgFwK9atTj3heE7Qg81DNkNZ/
'' SIG '' goBiD5TOFl0+4BiGnEs29xW3AeSsnuKLlmKYa47y17n7
'' SIG '' Ll92M1pmkgh4aVIszhMPf4wKETPnfhoWWX53UwCNwoU/
'' SIG '' h5u5x2KauuWXUoz0MmyBn4vzp3syB59H7ZhsalVptvwt
'' SIG '' /znYQxyr2pnxHzPIleFMhsUbLoAiibBjNrkW2K43u0Im
'' SIG '' ldd1Vmf43m9BYBGcfP45xyMp/1p5OZg2WdXpoCgl9g+l
'' SIG '' S6TWuJc5hKFKf0psScqmQWVe0iZw9MWojTwu5X7FcyPa
'' SIG '' YBid1bz3/kwnF5KIOVsQg2sYGgxXWApq3IOs8FdR9RKf
'' SIG '' gZiKJz1s8FMT6hn33hsz6s1sYC4hkoWH
'' SIG '' End signature block
