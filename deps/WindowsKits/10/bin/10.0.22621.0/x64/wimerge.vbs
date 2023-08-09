' Windows Installer database utility to merge data from another database              
' For use with Windows Scripting Host, CScript.exe or WScript.exe
' Copyright (c) Microsoft Corporation. All rights reserved.
' Demonstrates the use of the Database.Merge method and MsiDatabaseMerge API
'
Option Explicit

Const msiOpenDatabaseModeReadOnly     = 0
Const msiOpenDatabaseModeTransact     = 1
Const msiOpenDatabaseModeCreate       = 3
Const ForAppending = 8
Const ForReading = 1
Const ForWriting = 2
Const TristateTrue = -1

Dim argCount:argCount = Wscript.Arguments.Count
Dim iArg:iArg = 0
If (argCount < 2) Then
	Wscript.Echo "Windows Installer database merge utility" &_
		vbNewLine & " 1st argument is the path to MSI database (installer package)" &_
		vbNewLine & " 2nd argument is the path to database containing data to merge" &_
		vbNewLine & " 3rd argument is the optional table to contain the merge errors" &_
		vbNewLine & " If 3rd argument is not present, the table _MergeErrors is used" &_
		vbNewLine & "  and that table will be dropped after displaying its contents." &_
		vbNewLine &_
		vbNewLine & "Copyright (C) Microsoft Corporation.  All rights reserved."
	Wscript.Quit 1
End If

' Connect to Windows Installer object
On Error Resume Next
Dim installer : Set installer = Nothing
Set installer = Wscript.CreateObject("WindowsInstaller.Installer") : CheckError

' Open databases and merge data
Dim database1 : Set database1 = installer.OpenDatabase(WScript.Arguments(0), msiOpenDatabaseModeTransact) : CheckError
Dim database2 : Set database2 = installer.OpenDatabase(WScript.Arguments(1), msiOpenDatabaseModeReadOnly) : CheckError
Dim errorTable : errorTable = "_MergeErrors"
If argCount >= 3 Then errorTable = WScript.Arguments(2)
Dim hasConflicts:hasConflicts = database1.Merge(database2, errorTable) 'Old code returns void value, new returns boolean
If hasConflicts <> True Then hasConflicts = CheckError 'Temp for old Merge function that returns void
If hasConflicts <> 0 Then
	Dim message, line, view, record
	Set view = database1.OpenView("Select * FROM `" & errorTable & "`") : CheckError
	view.Execute
	Do
		Set record = view.Fetch
		If record Is Nothing Then Exit Do
		line = record.StringData(1) & " table has " & record.IntegerData(2) & " conflicts"
		If message = Empty Then message = line Else message = message & vbNewLine & line
	Loop
	Set view = Nothing
	Wscript.Echo message
End If
If argCount < 3 And hasConflicts Then database1.OpenView("DROP TABLE `" & errorTable & "`").Execute : CheckError
database1.Commit : CheckError
Quit 0

Function CheckError
	Dim message, errRec
	CheckError = 0
	If Err = 0 Then Exit Function
	message = Err.Source & " " & Hex(Err) & ": " & Err.Description
	If Not installer Is Nothing Then
		Set errRec = installer.LastErrorRecord
		If Not errRec Is Nothing Then message = message & vbNewLine & errRec.FormatText : CheckError = errRec.IntegerData(1)
	End If
	If CheckError = 2268 Then Err.Clear : Exit Function
	Wscript.Echo message
	Wscript.Quit 2
End Function

'' SIG '' Begin signature block
'' SIG '' MIIl2QYJKoZIhvcNAQcCoIIlyjCCJcYCAQExDzANBglg
'' SIG '' hkgBZQMEAgEFADB3BgorBgEEAYI3AgEEoGkwZzAyBgor
'' SIG '' BgEEAYI3AgEeMCQCAQEEEE7wKRaZJ7VNj+Ws4Q8X66sC
'' SIG '' AQACAQACAQACAQACAQAwMTANBglghkgBZQMEAgEFAAQg
'' SIG '' QXX+BeRpnj5/3w9MZiLTEbzssoFPyxBqr0/6QcQWjb+g
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
'' SIG '' hvcNAQkEMSIEIH1k2sAhRI5EbNBoPewCutWA8VNMasrc
'' SIG '' WJVdk25WCsPPMDwGCisGAQQBgjcKAxwxLgwsc1BZN3hQ
'' SIG '' QjdoVDVnNUhIcll0OHJETFNNOVZ1WlJ1V1phZWYyZTIy
'' SIG '' UnM1ND0wWgYKKwYBBAGCNwIBDDFMMEqgJIAiAE0AaQBj
'' SIG '' AHIAbwBzAG8AZgB0ACAAVwBpAG4AZABvAHcAc6EigCBo
'' SIG '' dHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vd2luZG93czAN
'' SIG '' BgkqhkiG9w0BAQEFAASCAQAnXwfZ1pK7QlTfp9BMRhzq
'' SIG '' CscwIacHJvhKSZO0emWBK56KbaxXcTlOpfFyL0ERhPFe
'' SIG '' KaI4e5qtFYZ6Zh+kbJXulrt6sjmjOuqrLDHn6lTgvgXN
'' SIG '' Efu6ggH851XSBDzNSxX3ByL+pqoWaokub5iHEAPKxUF4
'' SIG '' sAztIOaUmRXutEJ0oOr6SO1wKorp/Dm5u+QYfGIqrdiu
'' SIG '' aVySKUagHcYWope3lxrpQgj2jzMg5xQOPKVcL1spOBxV
'' SIG '' YMk6Kh8kJd/J0IX4DK9XF90WGmE5ZFpxlp+EQ8yeALlZ
'' SIG '' 3mdmCWM4PI+H/NptnPwf8xAc4/aCIexACE1mcrek1z4+
'' SIG '' Jyqh6TxRN3xYoYIW/TCCFvkGCisGAQQBgjcDAwExghbp
'' SIG '' MIIW5QYJKoZIhvcNAQcCoIIW1jCCFtICAQMxDzANBglg
'' SIG '' hkgBZQMEAgEFADCCAVEGCyqGSIb3DQEJEAEEoIIBQASC
'' SIG '' ATwwggE4AgEBBgorBgEEAYRZCgMBMDEwDQYJYIZIAWUD
'' SIG '' BAIBBQAEIOMrE95jTczoLGwD4EWP+O7ayul5tM7iCiRv
'' SIG '' poKvO1/LAgZjSFPLAT8YEzIwMjIxMDIwMDQxNTQxLjE4
'' SIG '' MVowBIACAfSggdCkgc0wgcoxCzAJBgNVBAYTAlVTMRMw
'' SIG '' EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
'' SIG '' b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
'' SIG '' b24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVyaWNhIE9w
'' SIG '' ZXJhdGlvbnMxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNO
'' SIG '' OjIyNjQtRTMzRS03ODBDMSUwIwYDVQQDExxNaWNyb3Nv
'' SIG '' ZnQgVGltZS1TdGFtcCBTZXJ2aWNloIIRVDCCBwwwggT0
'' SIG '' oAMCAQICEzMAAAGYdrOMxdAFoQEAAQAAAZgwDQYJKoZI
'' SIG '' hvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
'' SIG '' Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
'' SIG '' BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQG
'' SIG '' A1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIw
'' SIG '' MTAwHhcNMjExMjAyMTkwNTE1WhcNMjMwMjI4MTkwNTE1
'' SIG '' WjCByjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
'' SIG '' bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
'' SIG '' FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMc
'' SIG '' TWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEmMCQG
'' SIG '' A1UECxMdVGhhbGVzIFRTUyBFU046MjI2NC1FMzNFLTc4
'' SIG '' MEMxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1w
'' SIG '' IFNlcnZpY2UwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAw
'' SIG '' ggIKAoICAQDG1JWsVksp8xG4sLMnfxfit3ShI+7G1MfT
'' SIG '' T+5XvQzuAOe8r5MRAFITTmjFxzoLFfmaxLvPVlmDgkDi
'' SIG '' 0rqsOs9Al9jVwYSFVF/wWC2+B76OysiyRjw+NPj5A4cm
'' SIG '' MhPqIdNkRLCE+wtuI/wCaq3/Lf4koDGudIcEYRgMqqTo
'' SIG '' OOUIV4e7EdYb3k9rYPN7SslwsLFSp+Fvm/Qcy5KqfkmM
'' SIG '' X4S3oJx7HdiQhKbK1C6Zfib+761bmrdPLT6eddlnywls
'' SIG '' 7hCrIIuFtgUbUj6KJIZn1MbYY8hrAM59tvLpeGmFW3Gj
'' SIG '' eBAmvBxAn7o9Lp2nykT1w9I0s9ddwpFnjLT2PK74GDSs
'' SIG '' xFUZG1UtLypi/kZcg9WenPAZpUtPFfO5Mtif8Ja8jXXL
'' SIG '' IP6K+b5LiQV8oIxFSBfgFN7/TL2tSSfQVcvqX1mcSOrx
'' SIG '' /tsgq3L6YAxI6Pl4h1zQrcAmToypEoPYNc/RlSBk6ljm
'' SIG '' NyNDsX3gtK8p6c7HCWUhF+YjMgfanQmMjUYsbjdEsCyL
'' SIG '' 6QAojZ0f6kteN4cV6obFwcUEviYygWbedaT86OGe9LEO
'' SIG '' xPuhzgFv2ZobVr0J8hl1FVdcZFbfFN/gdjHZ/ncDDqLN
'' SIG '' WgcoMoEhwwzo7FAObqKaxfB5zCBqYSj45miNO5g3hP8A
'' SIG '' gC0eSCHl3rK7JPMr1B+8JTHtwRkSKz/+cwIDAQABo4IB
'' SIG '' NjCCATIwHQYDVR0OBBYEFG6RhHKNpsg3mgons7LR5YHT
'' SIG '' zeE3MB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1
'' SIG '' GelyMF8GA1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cu
'' SIG '' bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29m
'' SIG '' dCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNy
'' SIG '' bDBsBggrBgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0
'' SIG '' dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2Vy
'' SIG '' dHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
'' SIG '' MDIwMTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwEwYDVR0l
'' SIG '' BAwwCgYIKwYBBQUHAwgwDQYJKoZIhvcNAQELBQADggIB
'' SIG '' ACT6B6F33i/89zXTgqQ8L6CYMHx9BiaHOV+wk53JOriC
'' SIG '' zeaLjYgRyssJhmnnJ/CdHa5qjcSwvRptWpZJPVK5sxhO
'' SIG '' IjRBPgs/3+ER0vS87IA+aGbf7NF7LZZlxWPOl/yFBg9q
'' SIG '' Z3tpOGOohQInQn5zpV23hWopaN4c49jGJHLPAfy9u7+Z
'' SIG '' SGQuw14CsW/XRLELHT18I60W0uKOBa5Pm2ViohMovcbp
'' SIG '' NUCEERqIO9WPwzIwMRRw34/LgjuslHJop+/1Ve/CfyNq
'' SIG '' weUmwepQHJrd+wTLUlgm4ENbXF6i52jFfYpESwLdAn56
'' SIG '' o/pj+grsd2LrAEPQRyh49rWvI/qZfOhtT2FWmzFw6IJv
'' SIG '' Z7CzT1O+Fc0gIDBNqass5QbmkOkKYy9U7nFA6qn3ZZ+M
'' SIG '' rZMsJTj7gxAf0yMkVqwYWZRk4brY9q8JDPmcfNSjRrVf
'' SIG '' pYyzEVEqemGanmxvDDTzS2wkSBa3zcNwOgYhWBTmJdLg
'' SIG '' yiWJGeqyj1m5bwNgnOw6NzXCiVMzfbztdkqOdTR88LtA
'' SIG '' JGNRjevWjQd5XitGuegSp2mMJglFzRwkncQau1BJsCj/
'' SIG '' 1aDY4oMiO8conkmaWBrYe11QCS896/sZwSdnEUJak0qp
'' SIG '' nBRFB+THRIxIivCKNbxG2QRZ8dh95cOXgo0YvBN5a1p+
'' SIG '' iJ3vNwzneU2AIC7z3rrIbN2fMIIHcTCCBVmgAwIBAgIT
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
'' SIG '' VQQLEx1UaGFsZXMgVFNTIEVTTjoyMjY0LUUzM0UtNzgw
'' SIG '' QzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAg
'' SIG '' U2VydmljZaIjCgEBMAcGBSsOAwIaAxUA8ywe/iF5M8fI
'' SIG '' U2aT6yQ3vnPpV5OggYMwgYCkfjB8MQswCQYDVQQGEwJV
'' SIG '' UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
'' SIG '' UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
'' SIG '' cmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1T
'' SIG '' dGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQUFAAIFAOb6
'' SIG '' uyMwIhgPMjAyMjEwMjAwMjA2MjdaGA8yMDIyMTAyMTAy
'' SIG '' MDYyN1owdDA6BgorBgEEAYRZCgQBMSwwKjAKAgUA5vq7
'' SIG '' IwIBADAHAgEAAgIRkzAHAgEAAgIR6DAKAgUA5vwMowIB
'' SIG '' ADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMC
'' SIG '' oAowCAIBAAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3
'' SIG '' DQEBBQUAA4GBAGl7s0iEtMsTrkY10lSe0MTg0p8c7rRB
'' SIG '' fJVK1h8ivjW9LLpyIoqkbWOpo82qKW9oG6PZD4JqfS0C
'' SIG '' pClslEqCuxOjqzHvcFOF4dnRrNxXNWoStAcXjyqtQLWm
'' SIG '' RMb3kBtTb/PGF8syCTBb4zogJiwfI4dZt4l2q41RHwzg
'' SIG '' h0bqO1pIMYIEDTCCBAkCAQEwgZMwfDELMAkGA1UEBhMC
'' SIG '' VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
'' SIG '' B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
'' SIG '' b3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUt
'' SIG '' U3RhbXAgUENBIDIwMTACEzMAAAGYdrOMxdAFoQEAAQAA
'' SIG '' AZgwDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJ
'' SIG '' AzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0BCQQxIgQg
'' SIG '' ZkdTEBdFpIuCui/mocH+0FU+trKUgQoaEMg2iKibTn0w
'' SIG '' gfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCC/ps4G
'' SIG '' OTn/9wO1NhHM9Qfe0loB3slkw1FF3r+bh21WxDCBmDCB
'' SIG '' gKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
'' SIG '' aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
'' SIG '' ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMT
'' SIG '' HU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMz
'' SIG '' AAABmHazjMXQBaEBAAEAAAGYMCIEIKDQcZgaMp/UNf8U
'' SIG '' iqvy731fPESL936OEm4+LH/yynilMA0GCSqGSIb3DQEB
'' SIG '' CwUABIICAE9ZqZmbFxuqdsCISKt+yFZnqNXWGtCpZRcB
'' SIG '' LzlF9fV8a5eSmFVJJdciSklGd2vEnBrbXkgvKJU/O/3U
'' SIG '' EaYdkJFpeFmkZ/mZZDRYcxrL9rSXmbsm2MktcM0byye1
'' SIG '' U7wbZBzZpDxl8WpH+3S/+1hr33nDHmmPVwMNAE9RiUKV
'' SIG '' NRwqGSOw3mqPtex1LyZyacHeXXxePr59Im3NFmDm7z+l
'' SIG '' oHkBZJAgR+FLN7XVZOReS9RlC+qP9vDCvxj9BNJI8GZK
'' SIG '' DKm7/M8c1Rq9+DsQpaEjyu5rnwPT7HTfiavTdvTR4pGa
'' SIG '' ZJNTGyjxoLsH+PdM50ojNCGYB/qOTv8D5jSvPV3Gfyf9
'' SIG '' lMHv/av1P3WcfapVmlYde5bCcJky9fdC49mB/s9hAG0Q
'' SIG '' itjY5sc/Ja4FQs8bv1BJ594ZCfpGmdikbAw5CPvlZqnD
'' SIG '' aPz5Gs1R6Curuz88dM8XjyKzyNmCj1+Xi1T7CCq3z5Zb
'' SIG '' GLufpDhzHQUui4DcdnPri2UuToZq/L3YcjXxDPqWGoI5
'' SIG '' Q+cR7SroOhx6TmMyZq8sHfB15b6VQhyeYOemaDwEsg7Z
'' SIG '' f40vKVH0FrfVRfizdB4Zc3NNX76GPfZqoKuAh4nXyFTY
'' SIG '' dNflR6caOWgWK8+ym+URJC7XCvNXB3HNvHPMFix/Hm9d
'' SIG '' 0vX34vyel8nw2ql8IVL2uineIqdEw96w
'' SIG '' End signature block
