' Windows Installer utility to applay a transform to an installer database
' For use with Windows Scripting Host, CScript.exe or WScript.exe
' Copyright (c) Microsoft Corporation. All rights reserved.
' Demonstrates use of Database.ApplyTransform and MsiDatabaseApplyTransform
'
Option Explicit

' Error conditions that may be suppressed when applying transforms
Const msiTransformErrorAddExistingRow         = 1 'Adding a row that already exists. 
Const msiTransformErrorDeleteNonExistingRow   = 2 'Deleting a row that doesn't exist. 
Const msiTransformErrorAddExistingTable       = 4 'Adding a table that already exists. 
Const msiTransformErrorDeleteNonExistingTable = 8 'Deleting a table that doesn't exist. 
Const msiTransformErrorUpdateNonExistingRow  = 16 'Updating a row that doesn't exist. 
Const msiTransformErrorChangeCodePage       = 256 'Transform and database code pages do not match 

Const msiOpenDatabaseModeReadOnly     = 0
Const msiOpenDatabaseModeTransact     = 1
Const msiOpenDatabaseModeCreate       = 3

If (Wscript.Arguments.Count < 2) Then
	Wscript.Echo "Windows Installer database tranform application utility" &_
		vbNewLine & " 1st argument is the path to an installer database" &_
		vbNewLine & " 2nd argument is the path to the transform file to apply" &_
		vbNewLine & " 3rd argument is optional set of error conditions to suppress:" &_
		vbNewLine & "     1 = adding a row that already exists" &_
		vbNewLine & "     2 = deleting a row that doesn't exist" &_
		vbNewLine & "     4 = adding a table that already exists" &_
		vbNewLine & "     8 = deleting a table that doesn't exist" &_
		vbNewLine & "    16 = updating a row that doesn't exist" &_
		vbNewLine & "   256 = mismatch of database and transform codepages" &_
		vbNewLine &_
		vbNewLine & "Copyright (C) Microsoft Corporation.  All rights reserved."
	Wscript.Quit 1
End If

' Connect to Windows Installer object
On Error Resume Next
Dim installer : Set installer = Nothing
Set installer = Wscript.CreateObject("WindowsInstaller.Installer") : CheckError

' Open database and apply transform
Dim database : Set database = installer.OpenDatabase(Wscript.Arguments(0), msiOpenDatabaseModeTransact) : CheckError
Dim errorConditions:errorConditions = 0
If Wscript.Arguments.Count >= 3 Then errorConditions = CLng(Wscript.Arguments(2))
Database.ApplyTransform Wscript.Arguments(1), errorConditions : CheckError
Database.Commit : CheckError

Sub CheckError
	Dim message, errRec
	If Err = 0 Then Exit Sub
	message = Err.Source & " " & Hex(Err) & ": " & Err.Description
	If Not installer Is Nothing Then
		Set errRec = installer.LastErrorRecord
		If Not errRec Is Nothing Then message = message & vbNewLine & errRec.FormatText
	End If
	Wscript.Echo message
	Wscript.Quit 2
End Sub

'' SIG '' Begin signature block
'' SIG '' MIIl6gYJKoZIhvcNAQcCoIIl2zCCJdcCAQExDzANBglg
'' SIG '' hkgBZQMEAgEFADB3BgorBgEEAYI3AgEEoGkwZzAyBgor
'' SIG '' BgEEAYI3AgEeMCQCAQEEEE7wKRaZJ7VNj+Ws4Q8X66sC
'' SIG '' AQACAQACAQACAQACAQAwMTANBglghkgBZQMEAgEFAAQg
'' SIG '' ocXRzPIBsTOs40BugTYvo1tESbFrFB3U6AbYVQhStNmg
'' SIG '' ggt2MIIE/jCCA+agAwIBAgITMwAABJFkYvO3PuIMzQAA
'' SIG '' AAAEkTANBgkqhkiG9w0BAQsFADB+MQswCQYDVQQGEwJV
'' SIG '' UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
'' SIG '' UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
'' SIG '' cmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQgQ29kZSBT
'' SIG '' aWduaW5nIFBDQSAyMDEwMB4XDTIyMDUxMjIwNDcwNloX
'' SIG '' DTIzMDUxMTIwNDcwNlowdDELMAkGA1UEBhMCVVMxEzAR
'' SIG '' BgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
'' SIG '' bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
'' SIG '' bjEeMBwGA1UEAxMVTWljcm9zb2Z0IENvcnBvcmF0aW9u
'' SIG '' MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
'' SIG '' nhY/7ygo8W4MElNZXT0OpOrlxnQff1zsTzysiYv//AUr
'' SIG '' fumkbUy6UltTyoPS2nmxcpKZq5ndvC9ph9JE9BH7Z1FO
'' SIG '' YhQLmffNb2khVqXR2iNccz+CQup1mOaIBH/v4n6TZKBx
'' SIG '' Nngq4HLZlAcufVovvc1nR6poleFgVK+PscmHu66fZRkp
'' SIG '' BrWEhSU0oCaw8Z4vjCTthnOgkBpIQWv/9A3dv4ibaRJL
'' SIG '' hVIYyY3Pj7YwJ9uS7cgMDn5WbI9UftI5Kr+q6nqSi7ZL
'' SIG '' fA0r+wHMEv8IDhdggKAGPlbkK0MVMOAhabEvK0l9atR7
'' SIG '' uRCEc5ibanwBdD9A6P0/CDNox996YGhziwIDAQABo4IB
'' SIG '' fTCCAXkwHwYDVR0lBBgwFgYKKwYBBAGCNz0GAQYIKwYB
'' SIG '' BQUHAwMwHQYDVR0OBBYEFMha1AwF7LjeoDKigJPMy/aN
'' SIG '' OlovMFQGA1UdEQRNMEukSTBHMS0wKwYDVQQLEyRNaWNy
'' SIG '' b3NvZnQgSXJlbGFuZCBPcGVyYXRpb25zIExpbWl0ZWQx
'' SIG '' FjAUBgNVBAUTDTIzMDg2NSs0NzA1NjMwHwYDVR0jBBgw
'' SIG '' FoAU5vxfe7siAFjkck619CF0IzLm76wwVgYDVR0fBE8w
'' SIG '' TTBLoEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQuY29t
'' SIG '' L3BraS9jcmwvcHJvZHVjdHMvTWljQ29kU2lnUENBXzIw
'' SIG '' MTAtMDctMDYuY3JsMFoGCCsGAQUFBwEBBE4wTDBKBggr
'' SIG '' BgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3NvZnQuY29t
'' SIG '' L3BraS9jZXJ0cy9NaWNDb2RTaWdQQ0FfMjAxMC0wNy0w
'' SIG '' Ni5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsF
'' SIG '' AAOCAQEAEsvDfuS0pi0W8ZJXkxSiVYQD44KJKhJkA2Q6
'' SIG '' vlJX1AS6V4GcIpriVUsgGmPAuuJAO8NMiIuYyArzwSnl
'' SIG '' sRtrzSNu7sSz3c4SO8T0hxkSBwJ1w6o9V8BhBH0eIDlF
'' SIG '' 2e3vCH3uL49TUXdo0aNhoudG0W4/xbV1RUEtKf5RyNWC
'' SIG '' JYPJOddok0tr+O/QJxeDVLYikPyWLdYi3J4/cqpBivTG
'' SIG '' GtJSDoBm3MODycAvFWY/qZgJwpil38cwjbhBXxXBEvgL
'' SIG '' HhlEsAnSc4//+KDQy23KUjElf0VeHmjqa7N75PpEeTCx
'' SIG '' GKw98zDnQ6w1g0gpa6c5VYYadlHCXfyYGJ8S3VI8BDCC
'' SIG '' BnAwggRYoAMCAQICCmEMUkwAAAAAAAMwDQYJKoZIhvcN
'' SIG '' AQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpX
'' SIG '' YXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYD
'' SIG '' VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xMjAwBgNV
'' SIG '' BAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmljYXRlIEF1
'' SIG '' dGhvcml0eSAyMDEwMB4XDTEwMDcwNjIwNDAxN1oXDTI1
'' SIG '' MDcwNjIwNTAxN1owfjELMAkGA1UEBhMCVVMxEzARBgNV
'' SIG '' BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
'' SIG '' HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEo
'' SIG '' MCYGA1UEAxMfTWljcm9zb2Z0IENvZGUgU2lnbmluZyBQ
'' SIG '' Q0EgMjAxMDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
'' SIG '' AQoCggEBAOkOZFB5Z7XE4/0JAEyelKz3VmjqRNjPxVhP
'' SIG '' qaV2fG1FutM5krSkHvn5ZYLkF9KP/UScCOhlk84sVYS/
'' SIG '' fQjjLiuoQSsYt6JLbklMaxUH3tHSwokecZTNtX9LtK8I
'' SIG '' 2MyI1msXlDqTziY/7Ob+NJhX1R1dSfayKi7VhbtZP/iQ
'' SIG '' tCuDdMorsztG4/BGScEXZlTJHL0dxFViV3L4Z7klIDTe
'' SIG '' XaallV6rKIDN1bKe5QO1Y9OyFMjByIomCll/B+z/Du2A
'' SIG '' EjVMEqa+Ulv1ptrgiwtId9aFR9UQucboqu6Lai0FXGDG
'' SIG '' tCpbnCMcX0XjGhQebzfLGTOAaolNo2pmY3iT1TDPlR8C
'' SIG '' AwEAAaOCAeMwggHfMBAGCSsGAQQBgjcVAQQDAgEAMB0G
'' SIG '' A1UdDgQWBBTm/F97uyIAWORyTrX0IXQjMubvrDAZBgkr
'' SIG '' BgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMC
'' SIG '' AYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV
'' SIG '' 9lbLj+iiXGJo0T2UkFvXzpoYxDBWBgNVHR8ETzBNMEug
'' SIG '' SaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtp
'' SIG '' L2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0w
'' SIG '' Ni0yMy5jcmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUF
'' SIG '' BzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtp
'' SIG '' L2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNy
'' SIG '' dDCBnQYDVR0gBIGVMIGSMIGPBgkrBgEEAYI3LgMwgYEw
'' SIG '' PQYIKwYBBQUHAgEWMWh0dHA6Ly93d3cubWljcm9zb2Z0
'' SIG '' LmNvbS9QS0kvZG9jcy9DUFMvZGVmYXVsdC5odG0wQAYI
'' SIG '' KwYBBQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AUABvAGwA
'' SIG '' aQBjAHkAXwBTAHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJ
'' SIG '' KoZIhvcNAQELBQADggIBABp071dPKXvEFoV4uFDTIvwJ
'' SIG '' nayCl/g0/yosl5US5eS/z7+TyOM0qduBuNweAL7SNW+v
'' SIG '' 5X95lXflAtTx69jNTh4bYaLCWiMa8IyoYlFFZwjjPzwe
'' SIG '' k/gwhRfIOUCm1w6zISnlpaFpjCKTzHSY56FHQ/JTrMAP
'' SIG '' MGl//tIlIG1vYdPfB9XZcgAsaYZ2PVHbpjlIyTdhbQfd
'' SIG '' UxnLp9Zhwr/ig6sP4GubldZ9KFGwiUpRpJpsyLcfShoO
'' SIG '' aanX3MF+0Ulwqratu3JHYxf6ptaipobsqBBEm2O2smmJ
'' SIG '' BsdGhnoYP+jFHSHVe/kCIy3FQcu/HUzIFu+xnH/8IktJ
'' SIG '' im4V46Z/dlvRU3mRhZ3V0ts9czXzPK5UslJHasCqE5XS
'' SIG '' jhHamWdeMoz7N4XR3HWFnIfGWleFwr/dDY+Mmy3rtO7P
'' SIG '' J9O1Xmn6pBYEAackZ3PPTU+23gVWl3r36VJN9HcFT4XG
'' SIG '' 2Avxju1CCdENduMjVngiJja+yrGMbqod5IXaRzNij6TJ
'' SIG '' kTNfcR5Ar5hlySLoQiElihwtYNk3iUGJKhYP12E8lGhg
'' SIG '' Uu/WR5mggEDuFYF3PpzgUxgaUB04lZseZjMTJzkXeIc2
'' SIG '' zk7DX7L1PUdTtuDl2wthPSrXkizON1o+QEIxpB8QCMJW
'' SIG '' nL8kXVECnWp50hfT2sGUjgd7JXFEqwZq5tTG3yOalnXF
'' SIG '' MYIZzDCCGcgCAQEwgZUwfjELMAkGA1UEBhMCVVMxEzAR
'' SIG '' BgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
'' SIG '' bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
'' SIG '' bjEoMCYGA1UEAxMfTWljcm9zb2Z0IENvZGUgU2lnbmlu
'' SIG '' ZyBQQ0EgMjAxMAITMwAABJFkYvO3PuIMzQAAAAAEkTAN
'' SIG '' BglghkgBZQMEAgEFAKCCAQQwGQYJKoZIhvcNAQkDMQwG
'' SIG '' CisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisG
'' SIG '' AQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIC0J+qPZFDgw
'' SIG '' EyiEvrJozTxVjbdsdwcOYM5GWgUyuLG4MDwGCisGAQQB
'' SIG '' gjcKAxwxLgwsc1BZN3hQQjdoVDVnNUhIcll0OHJETFNN
'' SIG '' OVZ1WlJ1V1phZWYyZTIyUnM1ND0wWgYKKwYBBAGCNwIB
'' SIG '' DDFMMEqgJIAiAE0AaQBjAHIAbwBzAG8AZgB0ACAAVwBp
'' SIG '' AG4AZABvAHcAc6EigCBodHRwOi8vd3d3Lm1pY3Jvc29m
'' SIG '' dC5jb20vd2luZG93czANBgkqhkiG9w0BAQEFAASCAQCM
'' SIG '' Caft1x59kCLXUHqUo+nYztXwpbtJf02THAODh+6W2kxT
'' SIG '' eNfLLDjLjICKL6cWBKlaX1OHt8bLncNfWb4PZ/ZFPeDJ
'' SIG '' CfX4yb6bbr4xZmlJ9SW2ppHHNr2R5xtFY9V7DeplWn3p
'' SIG '' 1rAP12ZTvPKDsu4dU8plenR30ljlbsuxg8YeOQjfgi0h
'' SIG '' iFPgzvPGyJ2GwCGompEpNBeaMf5IoYZtEMW7UR0WjTYd
'' SIG '' hULBTNdvwZEFP0oKLk/q/5fvDNi6TU/+C6Nip3iXbmL3
'' SIG '' KKjMKAllrhoywrozAvfJatZNHlFtyFTS0YL9UGNc7q4b
'' SIG '' 6hJMA/jlQjzcdFO6mfhM4OwwGOB2JCXdoYIW/zCCFvsG
'' SIG '' CisGAQQBgjcDAwExghbrMIIW5wYJKoZIhvcNAQcCoIIW
'' SIG '' 2DCCFtQCAQMxDzANBglghkgBZQMEAgEFADCCAVAGCyqG
'' SIG '' SIb3DQEJEAEEoIIBPwSCATswggE3AgEBBgorBgEEAYRZ
'' SIG '' CgMBMDEwDQYJYIZIAWUDBAIBBQAEIJlKEbuJdS67hW3T
'' SIG '' n0qViHKljHSx8lw2BG5Rg6jizo/hAgZjSAyWSU0YEjIw
'' SIG '' MjIxMDIwMDQxNTQ1LjM4WjAEgAIB9KCB0KSBzTCByjEL
'' SIG '' MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
'' SIG '' EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
'' SIG '' c29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9z
'' SIG '' b2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEmMCQGA1UECxMd
'' SIG '' VGhhbGVzIFRTUyBFU046N0JGMS1FM0VBLUI4MDgxJTAj
'' SIG '' BgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZp
'' SIG '' Y2WgghFXMIIHDDCCBPSgAwIBAgITMwAAAZ8rRTUVCC5L
'' SIG '' XQABAAABnzANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQG
'' SIG '' EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
'' SIG '' BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
'' SIG '' cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGlt
'' SIG '' ZS1TdGFtcCBQQ0EgMjAxMDAeFw0yMTEyMDIxOTA1MjJa
'' SIG '' Fw0yMzAyMjgxOTA1MjJaMIHKMQswCQYDVQQGEwJVUzET
'' SIG '' MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVk
'' SIG '' bW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
'' SIG '' aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBP
'' SIG '' cGVyYXRpb25zMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVT
'' SIG '' Tjo3QkYxLUUzRUEtQjgwODElMCMGA1UEAxMcTWljcm9z
'' SIG '' b2Z0IFRpbWUtU3RhbXAgU2VydmljZTCCAiIwDQYJKoZI
'' SIG '' hvcNAQEBBQADggIPADCCAgoCggIBAKT1eXxNUbKJkC/O
'' SIG '' by0Hh8s/TOcvzzdgMgbTeOzX9bMJogJcOzSReUnf05Rn
'' SIG '' B4EVr9XyXbuaUGPItkO1ODdbx1A5EO6d+ftLNkSgWaVd
'' SIG '' pJhxCHIMxXmCHGLqWHzLc1XVM0cZgvNqhCa0F64VKUQf
'' SIG '' 3CnqsL+xErsY+s6fXtcAbOj7/IXLsN9aAhDjdffm63bR
'' SIG '' NKFR5gOuzkY5Wkenui6pBhFOm76UBoId+ry2v4sWojKO
'' SIG '' mS/HFvcdzHpWO17Q08foacgJPzg/FZgrt6hrkDFuxNSp
'' SIG '' ZDKJa2sajJDJc/jIgp9NRg+2xMUKLXiK4k2vfJEaOjhT
'' SIG '' U4dlTbIaZZ4Kt1xwmCRvLqTY3kCFFi8oet48+HmhYdjT
'' SIG '' WDxNyTFXiHiKWiq9ppgaHccM9Y/DgqgrITLtAca5krWo
'' SIG '' CSF5aIpfaoTR41Fa6aYIo+F1wXd1xWJUj1opeG3LjMzv
'' SIG '' q2xSNx0K2cblUgjp5Tp3NwvpgWnS8yXsk8jfL0ivH2wE
'' SIG '' SJWZKKAzZMNlThFQhsUi0PrQMljM0fSsa7YO/f0//Q7C
'' SIG '' jHfs/dl+8HmMB6DoH5IFIPRrCL5/rUkWtVz9Rnzdb7m2
'' SIG '' Aj/TFwsZYcE10SJtIXU0V+tXQo8Ip+L2IPYGRCAxiLTY
'' SIG '' JjwTe6z5TJgDg0VhxYmmNpwEoAF4MF2RjUE98aDOyRoq
'' SIG '' EgaF2jH1AgMBAAGjggE2MIIBMjAdBgNVHQ4EFgQUYjTy
'' SIG '' 1R4TFitIDi7o39lqx9YdyGEwHwYDVR0jBBgwFoAUn6cV
'' SIG '' XQBeYl2D9OXSZacbUzUZ6XIwXwYDVR0fBFgwVjBUoFKg
'' SIG '' UIZOaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9w
'' SIG '' cy9jcmwvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBD
'' SIG '' QSUyMDIwMTAoMSkuY3JsMGwGCCsGAQUFBwEBBGAwXjBc
'' SIG '' BggrBgEFBQcwAoZQaHR0cDovL3d3dy5taWNyb3NvZnQu
'' SIG '' Y29tL3BraW9wcy9jZXJ0cy9NaWNyb3NvZnQlMjBUaW1l
'' SIG '' LVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcnQwDAYDVR0T
'' SIG '' AQH/BAIwADATBgNVHSUEDDAKBggrBgEFBQcDCDANBgkq
'' SIG '' hkiG9w0BAQsFAAOCAgEAHYooKTw76Rnz6b1s9dAgCaj7
'' SIG '' rFsoNoqQxHf/zYDxdUAxr1Gki1gmR2S1r4LpkhUGxkQB
'' SIG '' EmQqdalgmKLIYFXc+Y+ggw/nMVuvQFgsyiUMlky0fcyJ
'' SIG '' 9UEP02Sdg0qD4ZtbJoA+zxVnpQPcJHOOhVnY9sdEf5Q6
'' SIG '' XZhz9ybUhHcGW+OVw3DKSnMEZSd0BF5+7ON9FJ8H50HO
'' SIG '' aUVj50wTz4nc6+94ytohzOdKuWvjoZcyhYYm3SEEk1/g
'' SIG '' bklmrJd7yfzPbJHmmgva6IxHOohdfWvAIheFws8WBIo3
'' SIG '' +8nGvEeIX0HJWKi5/iMJwPw7aY73i2gJKosRG6h1J711
'' SIG '' DuqspUGicOhhYDH5bRcYBfapqhmaoS6ftBvyGfI3JWsn
'' SIG '' YLZ9nABjbKJfdkyAsZSukNGglZ0/61zlJLopnV/DKEv8
'' SIG '' oCCOI0+9QGK7s8XgsfHlNEVTsdle+ClkOfnGS2RdmJ0D
'' SIG '' hLbo1mwxLKDHRHWddXfJtjcl2U19ERO3pIh9B0LFFflh
'' SIG '' Rsjk12+5UyLLmgHduV+E+A0nKjSp2aQcoTak3hzyLD1K
'' SIG '' tqOdZwzRtQTGsOQ2pzBqrXUPPBzSUMZfXiCeMZFuCGXo
'' SIG '' cuwPuPHHT5u7Mkcpk/MZ1MswUqhJ0l5XilT+3d09t1Tb
'' SIG '' UdLrQTHYinZN0Z+C1L087NVpMDhS5y6SVuNmRCKF+DYw
'' SIG '' ggdxMIIFWaADAgECAhMzAAAAFcXna54Cm0mZAAAAAAAV
'' SIG '' MA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzET
'' SIG '' MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVk
'' SIG '' bW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
'' SIG '' aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0
'' SIG '' aWZpY2F0ZSBBdXRob3JpdHkgMjAxMDAeFw0yMTA5MzAx
'' SIG '' ODIyMjVaFw0zMDA5MzAxODMyMjVaMHwxCzAJBgNVBAYT
'' SIG '' AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
'' SIG '' EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
'' SIG '' cG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1l
'' SIG '' LVN0YW1wIFBDQSAyMDEwMIICIjANBgkqhkiG9w0BAQEF
'' SIG '' AAOCAg8AMIICCgKCAgEA5OGmTOe0ciELeaLL1yR5vQ7V
'' SIG '' gtP97pwHB9KpbE51yMo1V/YBf2xK4OK9uT4XYDP/XE/H
'' SIG '' ZveVU3Fa4n5KWv64NmeFRiMMtY0Tz3cywBAY6GB9alKD
'' SIG '' RLemjkZrBxTzxXb1hlDcwUTIcVxRMTegCjhuje3XD9gm
'' SIG '' U3w5YQJ6xKr9cmmvHaus9ja+NSZk2pg7uhp7M62AW36M
'' SIG '' EBydUv626GIl3GoPz130/o5Tz9bshVZN7928jaTjkY+y
'' SIG '' OSxRnOlwaQ3KNi1wjjHINSi947SHJMPgyY9+tVSP3PoF
'' SIG '' VZhtaDuaRr3tpK56KTesy+uDRedGbsoy1cCGMFxPLOJi
'' SIG '' ss254o2I5JasAUq7vnGpF1tnYN74kpEeHT39IM9zfUGa
'' SIG '' RnXNxF803RKJ1v2lIH1+/NmeRd+2ci/bfV+Autuqfjbs
'' SIG '' Nkz2K26oElHovwUDo9Fzpk03dJQcNIIP8BDyt0cY7afo
'' SIG '' mXw/TNuvXsLz1dhzPUNOwTM5TI4CvEJoLhDqhFFG4tG9
'' SIG '' ahhaYQFzymeiXtcodgLiMxhy16cg8ML6EgrXY28MyTZk
'' SIG '' i1ugpoMhXV8wdJGUlNi5UPkLiWHzNgY1GIRH29wb0f2y
'' SIG '' 1BzFa/ZcUlFdEtsluq9QBXpsxREdcu+N+VLEhReTwDwV
'' SIG '' 2xo3xwgVGD94q0W29R6HXtqPnhZyacaue7e3PmriLq0C
'' SIG '' AwEAAaOCAd0wggHZMBIGCSsGAQQBgjcVAQQFAgMBAAEw
'' SIG '' IwYJKwYBBAGCNxUCBBYEFCqnUv5kxJq+gpE8RjUpzxD/
'' SIG '' LwTuMB0GA1UdDgQWBBSfpxVdAF5iXYP05dJlpxtTNRnp
'' SIG '' cjBcBgNVHSAEVTBTMFEGDCsGAQQBgjdMg30BATBBMD8G
'' SIG '' CCsGAQUFBwIBFjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
'' SIG '' b20vcGtpb3BzL0RvY3MvUmVwb3NpdG9yeS5odG0wEwYD
'' SIG '' VR0lBAwwCgYIKwYBBQUHAwgwGQYJKwYBBAGCNxQCBAwe
'' SIG '' CgBTAHUAYgBDAEEwCwYDVR0PBAQDAgGGMA8GA1UdEwEB
'' SIG '' /wQFMAMBAf8wHwYDVR0jBBgwFoAU1fZWy4/oolxiaNE9
'' SIG '' lJBb186aGMQwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDov
'' SIG '' L2NybC5taWNyb3NvZnQuY29tL3BraS9jcmwvcHJvZHVj
'' SIG '' dHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3JsMFoG
'' SIG '' CCsGAQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0cDov
'' SIG '' L3d3dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNS
'' SIG '' b29DZXJBdXRfMjAxMC0wNi0yMy5jcnQwDQYJKoZIhvcN
'' SIG '' AQELBQADggIBAJ1VffwqreEsH2cBMSRb4Z5yS/ypb+pc
'' SIG '' FLY+TkdkeLEGk5c9MTO1OdfCcTY/2mRsfNB1OW27DzHk
'' SIG '' wo/7bNGhlBgi7ulmZzpTTd2YurYeeNg2LpypglYAA7AF
'' SIG '' vonoaeC6Ce5732pvvinLbtg/SHUB2RjebYIM9W0jVOR4
'' SIG '' U3UkV7ndn/OOPcbzaN9l9qRWqveVtihVJ9AkvUCgvxm2
'' SIG '' EhIRXT0n4ECWOKz3+SmJw7wXsFSFQrP8DJ6LGYnn8Atq
'' SIG '' gcKBGUIZUnWKNsIdw2FzLixre24/LAl4FOmRsqlb30mj
'' SIG '' dAy87JGA0j3mSj5mO0+7hvoyGtmW9I/2kQH2zsZ0/fZM
'' SIG '' cm8Qq3UwxTSwethQ/gpY3UA8x1RtnWN0SCyxTkctwRQE
'' SIG '' cb9k+SS+c23Kjgm9swFXSVRk2XPXfx5bRAGOWhmRaw2f
'' SIG '' pCjcZxkoJLo4S5pu+yFUa2pFEUep8beuyOiJXk+d0tBM
'' SIG '' drVXVAmxaQFEfnyhYWxz/gq77EFmPWn9y8FBSX5+k77L
'' SIG '' +DvktxW/tM4+pTFRhLy/AsGConsXHRWJjXD+57XQKBqJ
'' SIG '' C4822rpM+Zv/Cuk0+CQ1ZyvgDbjmjJnW4SLq8CdCPSWU
'' SIG '' 5nR0W2rRnj7tfqAxM328y+l7vzhwRNGQ8cirOoo6CGJ/
'' SIG '' 2XBjU02N7oJtpQUQwXEGahC0HVUzWLOhcGbyoYICzjCC
'' SIG '' AjcCAQEwgfihgdCkgc0wgcoxCzAJBgNVBAYTAlVTMRMw
'' SIG '' EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
'' SIG '' b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
'' SIG '' b24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVyaWNhIE9w
'' SIG '' ZXJhdGlvbnMxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNO
'' SIG '' OjdCRjEtRTNFQS1CODA4MSUwIwYDVQQDExxNaWNyb3Nv
'' SIG '' ZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMKAQEwBwYFKw4D
'' SIG '' AhoDFQB0Xa6YH/LLDEUsVMLysn0W/1z2t6CBgzCBgKR+
'' SIG '' MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5n
'' SIG '' dG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
'' SIG '' aWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1p
'' SIG '' Y3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqG
'' SIG '' SIb3DQEBBQUAAgUA5vschjAiGA8yMDIyMTAyMDA5MDE1
'' SIG '' OFoYDzIwMjIxMDIxMDkwMTU4WjB3MD0GCisGAQQBhFkK
'' SIG '' BAExLzAtMAoCBQDm+xyGAgEAMAoCAQACAhGFAgH/MAcC
'' SIG '' AQACAhHPMAoCBQDm/G4GAgEAMDYGCisGAQQBhFkKBAIx
'' SIG '' KDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAI
'' SIG '' AgEAAgMBhqAwDQYJKoZIhvcNAQEFBQADgYEAqRtVG5yb
'' SIG '' wFNb3tjHIDdFvn6REdgKtumhcAX8QYDP4KdNIN0zLNIE
'' SIG '' +AvaJrpxA9ARegbF8mS47MRglVlaqOkLTqi3iRP/s5qp
'' SIG '' N7k6Qhsr+rju54DD62lCrjiWBE+okOqiDfJ4XNbFEF8N
'' SIG '' 5spUjnGNaKaMtvCoSEn6VRRGqb2+JDUxggQNMIIECQIB
'' SIG '' ATCBkzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
'' SIG '' aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
'' SIG '' ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQD
'' SIG '' Ex1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAIT
'' SIG '' MwAAAZ8rRTUVCC5LXQABAAABnzANBglghkgBZQMEAgEF
'' SIG '' AKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEE
'' SIG '' MC8GCSqGSIb3DQEJBDEiBCBHvhL4IBuczkOfvPr1EO63
'' SIG '' f04KrhSVkVe8/xiz8ECzqzCB+gYLKoZIhvcNAQkQAi8x
'' SIG '' geowgecwgeQwgb0EIIbxXimiJ4mepedXPA1R6N4qAsl8
'' SIG '' Qfs/6OynLDdLfFzaMIGYMIGApH4wfDELMAkGA1UEBhMC
'' SIG '' VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
'' SIG '' B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
'' SIG '' b3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUt
'' SIG '' U3RhbXAgUENBIDIwMTACEzMAAAGfK0U1FQguS10AAQAA
'' SIG '' AZ8wIgQghyAFa5L47h0sxu5pACGbi4m4r36tOCCad2HL
'' SIG '' 68Vmq9gwDQYJKoZIhvcNAQELBQAEggIAKZKSwrtSvxyj
'' SIG '' M8i0ie/ZTFEVKst5LnYFnlW+q5BcIK0Xo4fZ9Fg/uxyX
'' SIG '' C2qErCfrkdYlPIMmxqGy8Z4lB+RMSBxX4GizBrlqOOUi
'' SIG '' sWBCeEL1bquuTFZ4YPhTtBXfJ3DtovVuKo5aS9XY3uPN
'' SIG '' gWtcz5BYEdM2K5fcO2MVJb0b9pf8+u6S2SrM9I3hRA9Z
'' SIG '' XF3JfoaMC1f8wlHKGp+D93DSQ7TuLx1dCqRNlaL2UI9Y
'' SIG '' nFzwkaBZVaCm+n7zu9DStKyDiBMvZwN5qkyVGTHFeL9v
'' SIG '' mw+ZkuP+LpODC12QW9AulkuVxQpsh13/ATmaaeNBohT6
'' SIG '' 1ijtKW1ftFjKb5equmcj2Br/tkiKW/s5XRo/nxudxMUW
'' SIG '' EO7A082q4N7uECSris91Zc5WMRUDmifLAIkGt7qdGz16
'' SIG '' NQOCvHW1R4rvajX+PD1mJXMzxwXP9R9HcOeYbNg1uDuB
'' SIG '' bNnr3b5Do1iawukaxVNR0js0V0eXvDdWvcH/vsNchj39
'' SIG '' t0zclskMQIUPIO7RZMNaQ1k4iYtBMFIquKrZEiUNUjPM
'' SIG '' bl41LrmbkmFF18ZQZZDqQdW7eH3B3fPupHvp/CUsG65T
'' SIG '' AZRzpZOWxOqSkfqVz7Mv/NmOd8fZvP+2r2rHZkSfcSkA
'' SIG '' AH8vY0fOnMEOe2czuZPGAghd7reUP8QcfUw6dO6h9/Ot
'' SIG '' J6+N6FbOS4A=
'' SIG '' End signature block
