' Windows Installer utility to generate a transform from two databases
' For use with Windows Scripting Host, CScript.exe or WScript.exe
' Copyright (c) Microsoft Corporation. All rights reserved.
' Demonstrates use of Database.GenerateTransform and MsiDatabaseGenerateTransform
'
Option Explicit

Const msiOpenDatabaseModeReadOnly     = 0
Const msiOpenDatabaseModeTransact     = 1
Const msiOpenDatabaseModeCreate       = 3

If Wscript.Arguments.Count < 2 Then
	Wscript.Echo "Windows Installer database tranform generation utility" &_
		vbNewLine & " 1st argument is the path to the original installer database" &_
		vbNewLine & " 2nd argument is the path to the updated installer database" &_
		vbNewLine & " 3rd argument is the path to the transform file to generate" &_
		vbNewLine & " If the 3rd argument is omitted, the databases are only compared" &_
		vbNewLine &_
		vbNewLine & "Copyright (C) Microsoft Corporation.  All rights reserved."
	Wscript.Quit 1
End If

' Connect to Windows Installer object
On Error Resume Next
Dim installer : Set installer = Nothing
Set installer = Wscript.CreateObject("WindowsInstaller.Installer") : CheckError

' Open databases and generate transform
Dim database1 : Set database1 = installer.OpenDatabase(Wscript.Arguments(0), msiOpenDatabaseModeReadOnly) : CheckError
Dim database2 : Set database2 = installer.OpenDatabase(Wscript.Arguments(1), msiOpenDatabaseModeReadOnly) : CheckError
Dim transform:transform = ""  'Simply compare if no output transform file supplied
If Wscript.Arguments.Count >= 3 Then transform = Wscript.Arguments(2)
Dim different:different = Database2.GenerateTransform(Database1, transform) : CheckError
If Not different Then Wscript.Echo "Databases are identical" Else If transform = Empty Then Wscript.Echo "Databases are different"

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
'' SIG '' MIIl6wYJKoZIhvcNAQcCoIIl3DCCJdgCAQExDzANBglg
'' SIG '' hkgBZQMEAgEFADB3BgorBgEEAYI3AgEEoGkwZzAyBgor
'' SIG '' BgEEAYI3AgEeMCQCAQEEEE7wKRaZJ7VNj+Ws4Q8X66sC
'' SIG '' AQACAQACAQACAQACAQAwMTANBglghkgBZQMEAgEFAAQg
'' SIG '' LEOvI1OL4Ms+i8VD+9Lv0JnljZ8+Z42whrFijf9Ua/Cg
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
'' SIG '' MYIZzTCCGckCAQEwgZUwfjELMAkGA1UEBhMCVVMxEzAR
'' SIG '' BgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
'' SIG '' bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
'' SIG '' bjEoMCYGA1UEAxMfTWljcm9zb2Z0IENvZGUgU2lnbmlu
'' SIG '' ZyBQQ0EgMjAxMAITMwAABJFkYvO3PuIMzQAAAAAEkTAN
'' SIG '' BglghkgBZQMEAgEFAKCCAQQwGQYJKoZIhvcNAQkDMQwG
'' SIG '' CisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisG
'' SIG '' AQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIIDfOujaUux4
'' SIG '' sY7Yz/dpKY5kBWGh6QQLo6O/imVcDZaHMDwGCisGAQQB
'' SIG '' gjcKAxwxLgwsc1BZN3hQQjdoVDVnNUhIcll0OHJETFNN
'' SIG '' OVZ1WlJ1V1phZWYyZTIyUnM1ND0wWgYKKwYBBAGCNwIB
'' SIG '' DDFMMEqgJIAiAE0AaQBjAHIAbwBzAG8AZgB0ACAAVwBp
'' SIG '' AG4AZABvAHcAc6EigCBodHRwOi8vd3d3Lm1pY3Jvc29m
'' SIG '' dC5jb20vd2luZG93czANBgkqhkiG9w0BAQEFAASCAQBo
'' SIG '' HquRI3tdAhMcsewqqsjjct3JRVlqYoUTE3llHSp39o1D
'' SIG '' e/dOdfWejWuUrXrGHMndiBzJESmTWHH3x4h03E6BYRyX
'' SIG '' iC+HxeG2ukV65ON4cRJmZS7UYfdK2y4O6nu3/i/nHmfZ
'' SIG '' URzwxkoAZNhd24rwmco0a3XsnLhFNu6lYmYG4vxFu6Ty
'' SIG '' MtYjCWH7CMqTAeiTMO/G/OOaetHsRzqjwpgVMDaK4NFn
'' SIG '' M0DUz4ffDshZ3bV4upbpGLrf41wFkE1UJn4tqVwtfYlR
'' SIG '' pPQWWEyHFhbGkgLiTvBg8dYctuj/tazdZTXNvGrfi8yK
'' SIG '' 4RcqEIUzWn5W2zjZMaXwZTtqwNvRQ8D6oYIXADCCFvwG
'' SIG '' CisGAQQBgjcDAwExghbsMIIW6AYJKoZIhvcNAQcCoIIW
'' SIG '' 2TCCFtUCAQMxDzANBglghkgBZQMEAgEFADCCAVEGCyqG
'' SIG '' SIb3DQEJEAEEoIIBQASCATwwggE4AgEBBgorBgEEAYRZ
'' SIG '' CgMBMDEwDQYJYIZIAWUDBAIBBQAEIIdpZd/rRgoRSgJn
'' SIG '' 8eY/20vxG0XMXIhHNGl4Dt87qXL6AgZjSAyWSPEYEzIw
'' SIG '' MjIxMDIwMDQxNTQ0LjIwN1owBIACAfSggdCkgc0wgcox
'' SIG '' CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
'' SIG '' MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
'' SIG '' b3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jv
'' SIG '' c29mdCBBbWVyaWNhIE9wZXJhdGlvbnMxJjAkBgNVBAsT
'' SIG '' HVRoYWxlcyBUU1MgRVNOOjdCRjEtRTNFQS1CODA4MSUw
'' SIG '' IwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2
'' SIG '' aWNloIIRVzCCBwwwggT0oAMCAQICEzMAAAGfK0U1FQgu
'' SIG '' S10AAQAAAZ8wDQYJKoZIhvcNAQELBQAwfDELMAkGA1UE
'' SIG '' BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNV
'' SIG '' BAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
'' SIG '' b3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
'' SIG '' bWUtU3RhbXAgUENBIDIwMTAwHhcNMjExMjAyMTkwNTIy
'' SIG '' WhcNMjMwMjI4MTkwNTIyWjCByjELMAkGA1UEBhMCVVMx
'' SIG '' EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
'' SIG '' ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3Jh
'' SIG '' dGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2Eg
'' SIG '' T3BlcmF0aW9uczEmMCQGA1UECxMdVGhhbGVzIFRTUyBF
'' SIG '' U046N0JGMS1FM0VBLUI4MDgxJTAjBgNVBAMTHE1pY3Jv
'' SIG '' c29mdCBUaW1lLVN0YW1wIFNlcnZpY2UwggIiMA0GCSqG
'' SIG '' SIb3DQEBAQUAA4ICDwAwggIKAoICAQCk9Xl8TVGyiZAv
'' SIG '' zm8tB4fLP0znL883YDIG03js1/WzCaICXDs0kXlJ39OU
'' SIG '' ZweBFa/V8l27mlBjyLZDtTg3W8dQORDunfn7SzZEoFml
'' SIG '' XaSYcQhyDMV5ghxi6lh8y3NV1TNHGYLzaoQmtBeuFSlE
'' SIG '' H9wp6rC/sRK7GPrOn17XAGzo+/yFy7DfWgIQ43X35ut2
'' SIG '' 0TShUeYDrs5GOVpHp7ouqQYRTpu+lAaCHfq8tr+LFqIy
'' SIG '' jpkvxxb3Hcx6Vjte0NPH6GnICT84PxWYK7eoa5AxbsTU
'' SIG '' qWQyiWtrGoyQyXP4yIKfTUYPtsTFCi14iuJNr3yRGjo4
'' SIG '' U1OHZU2yGmWeCrdccJgkby6k2N5AhRYvKHrePPh5oWHY
'' SIG '' 01g8TckxV4h4iloqvaaYGh3HDPWPw4KoKyEy7QHGuZK1
'' SIG '' qAkheWiKX2qE0eNRWummCKPhdcF3dcViVI9aKXhty4zM
'' SIG '' 76tsUjcdCtnG5VII6eU6dzcL6YFp0vMl7JPI3y9Irx9s
'' SIG '' BEiVmSigM2TDZU4RUIbFItD60DJYzNH0rGu2Dv39P/0O
'' SIG '' wox37P3ZfvB5jAeg6B+SBSD0awi+f61JFrVc/UZ83W+5
'' SIG '' tgI/0xcLGWHBNdEibSF1NFfrV0KPCKfi9iD2BkQgMYi0
'' SIG '' 2CY8E3us+UyYA4NFYcWJpjacBKABeDBdkY1BPfGgzska
'' SIG '' KhIGhdox9QIDAQABo4IBNjCCATIwHQYDVR0OBBYEFGI0
'' SIG '' 8tUeExYrSA4u6N/ZasfWHchhMB8GA1UdIwQYMBaAFJ+n
'' SIG '' FV0AXmJdg/Tl0mWnG1M1GelyMF8GA1UdHwRYMFYwVKBS
'' SIG '' oFCGTmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lv
'' SIG '' cHMvY3JsL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQ
'' SIG '' Q0ElMjAyMDEwKDEpLmNybDBsBggrBgEFBQcBAQRgMF4w
'' SIG '' XAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0
'' SIG '' LmNvbS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGlt
'' SIG '' ZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3J0MAwGA1Ud
'' SIG '' EwEB/wQCMAAwEwYDVR0lBAwwCgYIKwYBBQUHAwgwDQYJ
'' SIG '' KoZIhvcNAQELBQADggIBAB2KKCk8O+kZ8+m9bPXQIAmo
'' SIG '' +6xbKDaKkMR3/82A8XVAMa9RpItYJkdkta+C6ZIVBsZE
'' SIG '' ARJkKnWpYJiiyGBV3PmPoIMP5zFbr0BYLMolDJZMtH3M
'' SIG '' ifVBD9NknYNKg+GbWyaAPs8VZ6UD3CRzjoVZ2PbHRH+U
'' SIG '' Ol2Yc/cm1IR3BlvjlcNwykpzBGUndARefuzjfRSfB+dB
'' SIG '' zmlFY+dME8+J3OvveMraIcznSrlr46GXMoWGJt0hBJNf
'' SIG '' 4G5JZqyXe8n8z2yR5poL2uiMRzqIXX1rwCIXhcLPFgSK
'' SIG '' N/vJxrxHiF9ByViouf4jCcD8O2mO94toCSqLERuodSe9
'' SIG '' dQ7qrKVBonDoYWAx+W0XGAX2qaoZmqEun7Qb8hnyNyVr
'' SIG '' J2C2fZwAY2yiX3ZMgLGUrpDRoJWdP+tc5SS6KZ1fwyhL
'' SIG '' /KAgjiNPvUBiu7PF4LHx5TRFU7HZXvgpZDn5xktkXZid
'' SIG '' A4S26NZsMSygx0R1nXV3ybY3JdlNfRETt6SIfQdCxRX5
'' SIG '' YUbI5NdvuVMiy5oB3blfhPgNJyo0qdmkHKE2pN4c8iw9
'' SIG '' SrajnWcM0bUExrDkNqcwaq11Dzwc0lDGX14gnjGRbghl
'' SIG '' 6HLsD7jxx0+buzJHKZPzGdTLMFKoSdJeV4pU/t3dPbdU
'' SIG '' 21HS60Ex2Ip2TdGfgtS9POzVaTA4UucuklbjZkQihfg2
'' SIG '' MIIHcTCCBVmgAwIBAgITMwAAABXF52ueAptJmQAAAAAA
'' SIG '' FTANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMx
'' SIG '' EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
'' SIG '' ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3Jh
'' SIG '' dGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2Vy
'' SIG '' dGlmaWNhdGUgQXV0aG9yaXR5IDIwMTAwHhcNMjEwOTMw
'' SIG '' MTgyMjI1WhcNMzAwOTMwMTgzMjI1WjB8MQswCQYDVQQG
'' SIG '' EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
'' SIG '' BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
'' SIG '' cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGlt
'' SIG '' ZS1TdGFtcCBQQ0EgMjAxMDCCAiIwDQYJKoZIhvcNAQEB
'' SIG '' BQADggIPADCCAgoCggIBAOThpkzntHIhC3miy9ckeb0O
'' SIG '' 1YLT/e6cBwfSqWxOdcjKNVf2AX9sSuDivbk+F2Az/1xP
'' SIG '' x2b3lVNxWuJ+Slr+uDZnhUYjDLWNE893MsAQGOhgfWpS
'' SIG '' g0S3po5GawcU88V29YZQ3MFEyHFcUTE3oAo4bo3t1w/Y
'' SIG '' JlN8OWECesSq/XJprx2rrPY2vjUmZNqYO7oaezOtgFt+
'' SIG '' jBAcnVL+tuhiJdxqD89d9P6OU8/W7IVWTe/dvI2k45GP
'' SIG '' sjksUZzpcGkNyjYtcI4xyDUoveO0hyTD4MmPfrVUj9z6
'' SIG '' BVWYbWg7mka97aSueik3rMvrg0XnRm7KMtXAhjBcTyzi
'' SIG '' YrLNueKNiOSWrAFKu75xqRdbZ2De+JKRHh09/SDPc31B
'' SIG '' mkZ1zcRfNN0Sidb9pSB9fvzZnkXftnIv231fgLrbqn42
'' SIG '' 7DZM9ituqBJR6L8FA6PRc6ZNN3SUHDSCD/AQ8rdHGO2n
'' SIG '' 6Jl8P0zbr17C89XYcz1DTsEzOUyOArxCaC4Q6oRRRuLR
'' SIG '' vWoYWmEBc8pnol7XKHYC4jMYctenIPDC+hIK12NvDMk2
'' SIG '' ZItboKaDIV1fMHSRlJTYuVD5C4lh8zYGNRiER9vcG9H9
'' SIG '' stQcxWv2XFJRXRLbJbqvUAV6bMURHXLvjflSxIUXk8A8
'' SIG '' FdsaN8cIFRg/eKtFtvUeh17aj54WcmnGrnu3tz5q4i6t
'' SIG '' AgMBAAGjggHdMIIB2TASBgkrBgEEAYI3FQEEBQIDAQAB
'' SIG '' MCMGCSsGAQQBgjcVAgQWBBQqp1L+ZMSavoKRPEY1Kc8Q
'' SIG '' /y8E7jAdBgNVHQ4EFgQUn6cVXQBeYl2D9OXSZacbUzUZ
'' SIG '' 6XIwXAYDVR0gBFUwUzBRBgwrBgEEAYI3TIN9AQEwQTA/
'' SIG '' BggrBgEFBQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQu
'' SIG '' Y29tL3BraW9wcy9Eb2NzL1JlcG9zaXRvcnkuaHRtMBMG
'' SIG '' A1UdJQQMMAoGCCsGAQUFBwMIMBkGCSsGAQQBgjcUAgQM
'' SIG '' HgoAUwB1AGIAQwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMB
'' SIG '' Af8EBTADAQH/MB8GA1UdIwQYMBaAFNX2VsuP6KJcYmjR
'' SIG '' PZSQW9fOmhjEMFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6
'' SIG '' Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1
'' SIG '' Y3RzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNybDBa
'' SIG '' BggrBgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6
'' SIG '' Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWlj
'' SIG '' Um9vQ2VyQXV0XzIwMTAtMDYtMjMuY3J0MA0GCSqGSIb3
'' SIG '' DQEBCwUAA4ICAQCdVX38Kq3hLB9nATEkW+Geckv8qW/q
'' SIG '' XBS2Pk5HZHixBpOXPTEztTnXwnE2P9pkbHzQdTltuw8x
'' SIG '' 5MKP+2zRoZQYIu7pZmc6U03dmLq2HnjYNi6cqYJWAAOw
'' SIG '' Bb6J6Gngugnue99qb74py27YP0h1AdkY3m2CDPVtI1Tk
'' SIG '' eFN1JFe53Z/zjj3G82jfZfakVqr3lbYoVSfQJL1AoL8Z
'' SIG '' thISEV09J+BAljis9/kpicO8F7BUhUKz/AyeixmJ5/AL
'' SIG '' aoHCgRlCGVJ1ijbCHcNhcy4sa3tuPywJeBTpkbKpW99J
'' SIG '' o3QMvOyRgNI95ko+ZjtPu4b6MhrZlvSP9pEB9s7GdP32
'' SIG '' THJvEKt1MMU0sHrYUP4KWN1APMdUbZ1jdEgssU5HLcEU
'' SIG '' BHG/ZPkkvnNtyo4JvbMBV0lUZNlz138eW0QBjloZkWsN
'' SIG '' n6Qo3GcZKCS6OEuabvshVGtqRRFHqfG3rsjoiV5PndLQ
'' SIG '' THa1V1QJsWkBRH58oWFsc/4Ku+xBZj1p/cvBQUl+fpO+
'' SIG '' y/g75LcVv7TOPqUxUYS8vwLBgqJ7Fx0ViY1w/ue10Cga
'' SIG '' iQuPNtq6TPmb/wrpNPgkNWcr4A245oyZ1uEi6vAnQj0l
'' SIG '' lOZ0dFtq0Z4+7X6gMTN9vMvpe784cETRkPHIqzqKOghi
'' SIG '' f9lwY1NNje6CbaUFEMFxBmoQtB1VM1izoXBm8qGCAs4w
'' SIG '' ggI3AgEBMIH4oYHQpIHNMIHKMQswCQYDVQQGEwJVUzET
'' SIG '' MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVk
'' SIG '' bW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
'' SIG '' aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBP
'' SIG '' cGVyYXRpb25zMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVT
'' SIG '' Tjo3QkYxLUUzRUEtQjgwODElMCMGA1UEAxMcTWljcm9z
'' SIG '' b2Z0IFRpbWUtU3RhbXAgU2VydmljZaIjCgEBMAcGBSsO
'' SIG '' AwIaAxUAdF2umB/yywxFLFTC8rJ9Fv9c9reggYMwgYCk
'' SIG '' fjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
'' SIG '' Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
'' SIG '' TWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1N
'' SIG '' aWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDANBgkq
'' SIG '' hkiG9w0BAQUFAAIFAOb7HIYwIhgPMjAyMjEwMjAwOTAx
'' SIG '' NThaGA8yMDIyMTAyMTA5MDE1OFowdzA9BgorBgEEAYRZ
'' SIG '' CgQBMS8wLTAKAgUA5vschgIBADAKAgEAAgIRhQIB/zAH
'' SIG '' AgEAAgIRzzAKAgUA5vxuBgIBADA2BgorBgEEAYRZCgQC
'' SIG '' MSgwJjAMBgorBgEEAYRZCgMCoAowCAIBAAIDB6EgoQow
'' SIG '' CAIBAAIDAYagMA0GCSqGSIb3DQEBBQUAA4GBAKkbVRuc
'' SIG '' m8BTW97YxyA3Rb5+kRHYCrbpoXAF/EGAz+CnTSDdMyzS
'' SIG '' BPgL2ia6cQPQEXoGxfJkuOzEYJVZWqjpC06ot4kT/7Oa
'' SIG '' qTe5OkIbK/q47ueAw+tpQq44lgRPqJDqog3yeFzWxRBf
'' SIG '' DebKVI5xjWimjLbwqEhJ+lUURqm9viQ1MYIEDTCCBAkC
'' SIG '' AQEwgZMwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
'' SIG '' c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
'' SIG '' BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UE
'' SIG '' AxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAC
'' SIG '' EzMAAAGfK0U1FQguS10AAQAAAZ8wDQYJYIZIAWUDBAIB
'' SIG '' BQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRAB
'' SIG '' BDAvBgkqhkiG9w0BCQQxIgQgdMaIppIcoxflGDZ0OFrS
'' SIG '' DfLhVhHt15L0Wtk5TjfYOv0wgfoGCyqGSIb3DQEJEAIv
'' SIG '' MYHqMIHnMIHkMIG9BCCG8V4poieJnqXnVzwNUejeKgLJ
'' SIG '' fEH7P+jspyw3S3xc2jCBmDCBgKR+MHwxCzAJBgNVBAYT
'' SIG '' AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
'' SIG '' EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
'' SIG '' cG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1l
'' SIG '' LVN0YW1wIFBDQSAyMDEwAhMzAAABnytFNRUILktdAAEA
'' SIG '' AAGfMCIEIIcgBWuS+O4dLMbuaQAhm4uJuK9+rTggmndh
'' SIG '' y+vFZqvYMA0GCSqGSIb3DQEBCwUABIICAB+pRIPbU6wB
'' SIG '' voyvpc97CP2ioclvvlw2j8vRf2S2fia+PGS9kxF4zPvs
'' SIG '' kvvtQCqDSflDOdBKuWTIcpOrqBGq1Dddb+9ydgV2xPC0
'' SIG '' rK54AntmmpZzUeurj/VgR9j1pIOyLNmKaYNR7PzAAXNK
'' SIG '' hJ9IRiqTJH8yCCd7A9uDYnvuopK0++ygEdjHafcDOK9U
'' SIG '' pc/W0XsIreM//iroSnfHTZ6X4GgIbsniQTZv+vlfrlqw
'' SIG '' PhGlTok43gcSy7stnJJa8tlQ0yiKxaT0gjn9wU8er3Nw
'' SIG '' bxslVIEyVpGFgfyM68jJEmdMs7Naq0P8zM8lEicbqq2+
'' SIG '' 77QPf+yTHZcqXC9gLHlckBM1iBhHqGfwBS8u/v6RBaAu
'' SIG '' rL4Db4OxXTqAVlmb2MfPGejCKYJxY0fL2sj5zZXiaMfj
'' SIG '' jWwt1oMC/q+r8htFwhnSA03P2M2cqfEwtVAWBAG2Jwfe
'' SIG '' rI1uw6V1f7fj/RgSp+m4tXwMn2+df+8IdMbxibBpf+8o
'' SIG '' tWDG+SfahEd1qDphDCW/W+BHI+OWSNuJh0J88asMfoCw
'' SIG '' on7yn/eTeaOltfT0L5zRJ0YJNYQ5m+XscpuyIjK4VtWI
'' SIG '' 9MOGDQniGfJYdNlLWkx/jDAF2X9x4r4DtQBVx5D+l/Rt
'' SIG '' ygZZZrU6I23Qq8Z8MxwM6Xkcr8Jn1YOHs2wKpGa4//SW
'' SIG '' 1nhH4pyMNyyM
'' SIG '' End signature block
