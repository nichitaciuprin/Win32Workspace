' Windows Installer script viewer for use with Windows Scripting Host CScript.exe only
' For use with Windows Scripting Host, CScript.exe or WScript.exe
' Copyright (c) Microsoft Corporation. All rights reserved.
' Demonstrates the use of the special database processing mode for viewing script files
'
Option Explicit

Const msiOpenDatabaseModeListScript = 5

' Check arg count, and display help if argument not present or contains ?
Dim argCount:argCount = Wscript.Arguments.Count
If argCount > 0 Then If InStr(1, Wscript.Arguments(0), "?", vbTextCompare) > 0 Then argCount = 0
If argCount = 0 Then
	Wscript.Echo "Windows Installer Script Viewer for Windows Scripting Host (CScript.exe)" &_
		vbNewLine & " Argument is path to installer execution script" &_
		vbNewLine &_
		vbNewLine & "Copyright (C) Microsoft Corporation.  All rights reserved."
	Wscript.Quit 1
End If

' Cannot run with GUI script host, as listing is performed to standard out
If UCase(Mid(Wscript.FullName, Len(Wscript.Path) + 2, 1)) = "W" Then
	Wscript.Echo "Cannot use WScript.exe - must use CScript.exe with this program"
	Wscript.Quit 2
End If

Dim installer, view, database, record, fieldCount, template, index, field
On Error Resume Next
Set installer = CreateObject("WindowsInstaller.Installer") : CheckError
Set database = installer.Opendatabase(Wscript.Arguments(0), msiOpenDatabaseModeListScript) : CheckError
Set view = database.Openview("")
view.Execute : CheckError
Do
   Set record = view.Fetch
   If record Is Nothing Then Exit Do
   fieldCount = record.FieldCount
   template = record.StringData(0)
   index = InstrRev(template, "[") + 1
   If (index > 1) Then
      field = Int(Mid(template, index, InstrRev(template, "]") - index))
      If field < fieldCount Then
         template = Left(template, Len(template) - 1)
         While field < fieldCount
            field = field + 1
            template = template & ",[" & field & "]"
         Wend
         record.StringData(0) = template & ")"
      End If
   End If
   Wscript.Echo record.FormatText
Loop
Wscript.Quit 0

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
'' SIG '' MIIl3AYJKoZIhvcNAQcCoIIlzTCCJckCAQExDzANBglg
'' SIG '' hkgBZQMEAgEFADB3BgorBgEEAYI3AgEEoGkwZzAyBgor
'' SIG '' BgEEAYI3AgEeMCQCAQEEEE7wKRaZJ7VNj+Ws4Q8X66sC
'' SIG '' AQACAQACAQACAQACAQAwMTANBglghkgBZQMEAgEFAAQg
'' SIG '' yGbucx5C9ty0NdJlcwpY0JNDXmCZOM9FQgmr4/kXaQOg
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
'' SIG '' jgd7JXFEqwZq5tTG3yOalnXFMYIZzTCCGckCAQEwgZUw
'' SIG '' fjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
'' SIG '' b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1p
'' SIG '' Y3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWlj
'' SIG '' cm9zb2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMAITMwAA
'' SIG '' BI8LuXzfev9KVwAAAAAEjzANBglghkgBZQMEAgEFAKCC
'' SIG '' AQQwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYK
'' SIG '' KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZI
'' SIG '' hvcNAQkEMSIEICM1o7gzYsS+pp2C6d0mLCxT/Z30fa3B
'' SIG '' p+PDJHTWK6/cMDwGCisGAQQBgjcKAxwxLgwsc1BZN3hQ
'' SIG '' QjdoVDVnNUhIcll0OHJETFNNOVZ1WlJ1V1phZWYyZTIy
'' SIG '' UnM1ND0wWgYKKwYBBAGCNwIBDDFMMEqgJIAiAE0AaQBj
'' SIG '' AHIAbwBzAG8AZgB0ACAAVwBpAG4AZABvAHcAc6EigCBo
'' SIG '' dHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vd2luZG93czAN
'' SIG '' BgkqhkiG9w0BAQEFAASCAQBeffip2SpFIpzvDQoPQoNL
'' SIG '' t8jDVKvlzkLAAIk3+lVf+z+Lh2UR1zG5PfzwQNzMHOX9
'' SIG '' d0a0ne2FWH34be8qUxvxRs0rj0XPDjHCPhpPiqeTA53U
'' SIG '' 1WlOWzeiT5w6rC6d6d79QMR05fRCA5IKN9rmH0Xgi+Os
'' SIG '' kWkUBM2L0ciCQKqowLv/698QHgqf4fMUgpa9ruy/RwBz
'' SIG '' IuS/PdCg8VP4f0umZprj7Hbk1dp93p+Qve1zEGrnsyR7
'' SIG '' IYm+HfHwkuxklUf618g3tpOVW9Hyz4rvVrT3Wl2nyQNF
'' SIG '' KK6Nf/eIlv/pLl1lEqnXhYliFc748Njf6isUxt1lI1gv
'' SIG '' YBBg0os8lGIBoYIXADCCFvwGCisGAQQBgjcDAwExghbs
'' SIG '' MIIW6AYJKoZIhvcNAQcCoIIW2TCCFtUCAQMxDzANBglg
'' SIG '' hkgBZQMEAgEFADCCAVEGCyqGSIb3DQEJEAEEoIIBQASC
'' SIG '' ATwwggE4AgEBBgorBgEEAYRZCgMBMDEwDQYJYIZIAWUD
'' SIG '' BAIBBQAEIGuSKET8VpZ4q04dtIGIBhnjFfS2hx7vQOR3
'' SIG '' Rzn2uLTDAgZjSGaT8bkYEzIwMjIxMDIwMDQxNTQyLjYx
'' SIG '' MVowBIACAfSggdCkgc0wgcoxCzAJBgNVBAYTAlVTMRMw
'' SIG '' EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
'' SIG '' b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
'' SIG '' b24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVyaWNhIE9w
'' SIG '' ZXJhdGlvbnMxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNO
'' SIG '' OkVBQ0UtRTMxNi1DOTFEMSUwIwYDVQQDExxNaWNyb3Nv
'' SIG '' ZnQgVGltZS1TdGFtcCBTZXJ2aWNloIIRVzCCBwwwggT0
'' SIG '' oAMCAQICEzMAAAGawHWixCFtPoUAAQAAAZowDQYJKoZI
'' SIG '' hvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
'' SIG '' Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
'' SIG '' BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQG
'' SIG '' A1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIw
'' SIG '' MTAwHhcNMjExMjAyMTkwNTE3WhcNMjMwMjI4MTkwNTE3
'' SIG '' WjCByjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
'' SIG '' bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
'' SIG '' FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMc
'' SIG '' TWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEmMCQG
'' SIG '' A1UECxMdVGhhbGVzIFRTUyBFU046RUFDRS1FMzE2LUM5
'' SIG '' MUQxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1w
'' SIG '' IFNlcnZpY2UwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAw
'' SIG '' ggIKAoICAQDacgasKiu3ZGEU/mr6A5t9oXAgbsCJq0Nn
'' SIG '' Ou+54zZPt9Y/trEHSTlpE2n4jua4VnadE4sf2Ng8xfUx
'' SIG '' DQPO4Vb/3UHhhdHiCnLoUIsW3wtE2OPzHFhAcUNzxuSp
'' SIG '' k667om4o/GcaPlwiIN4ZdDxSOz6ojSNT9azsKXwQFAcu
'' SIG '' 4c9tsvXiul99sifC3s2dEEJ0/BhyHiJAwscU4N2nm1UD
'' SIG '' f4uMAfC1B7SBQZL30ssPyiUjU7gIijr1IRlBAdBYmiyR
'' SIG '' 0F7RJvzy+diwjm0Isj3f8bsVIq9gZkUWxxFkKZLfByle
'' SIG '' Eo4BMmRMZE9+AfTprQne6mcjtVAdBLRKXvXjLSXPR6h5
'' SIG '' 4pttsShKaV3IP6Dp6bXRf2Gb2CfdVSxty3HHAUyZXuFw
'' SIG '' guIV2OW3gF3kFQK3uL6QZvN8a6KB0hto06V98Otey1OT
'' SIG '' Ovn1mRnAvVu4Wj8f1dc+9cOPdPgtFz4cd37mRRPEkAdX
'' SIG '' 2YaeTgpcNExa+jCbOSN++VtNScxwu4AjPoTfQjuQ+L1p
'' SIG '' 8SMZfggT8khaXaWWZ9vLvO7PIwIZ4b2SK3/XmWpk0Ama
'' SIG '' Tha5QG0fu5uvd4YZ/xLuI/kiwHWcTykviAZOlwkrnsoY
'' SIG '' ZJJ03RsIAWv6UHnYjAI8G3UgCFFlAm0nguQ3rIX54pmu
'' SIG '' jS83lgrm1YqbL2Lrlhmi98Mk2ktCHCXKRwIDAQABo4IB
'' SIG '' NjCCATIwHQYDVR0OBBYEFF+2nlnwnNtR6aVZvQqVyK02
'' SIG '' K9FwMB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1
'' SIG '' GelyMF8GA1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cu
'' SIG '' bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29m
'' SIG '' dCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNy
'' SIG '' bDBsBggrBgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0
'' SIG '' dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2Vy
'' SIG '' dHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
'' SIG '' MDIwMTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwEwYDVR0l
'' SIG '' BAwwCgYIKwYBBQUHAwgwDQYJKoZIhvcNAQELBQADggIB
'' SIG '' AAATu4fMRtRH20+nNzGAXFxdXEpRPTfbM0LJDeNe4QCx
'' SIG '' j0FM+wrJdu6UKrM2wQuO31UDcQ4nrUJBe81N6W2RvEa8
'' SIG '' xNXjbO0qzNitwUfOVLeZp6HVGcNTtYEMAvK9k//0daBF
'' SIG '' xbp04BzMaIyaHRy7y/K/zZ9ckEw7jF9VsJqlrwqkx9Hq
'' SIG '' I/IBsCpJdlTtKBl/+LRbD8tWvw6FDrSkv/IDiKcarPE0
'' SIG '' BU6//bFXvZ5/h7diE13dqv5DPU5Kn499HvUOAcHG31gr
'' SIG '' /TJPEftqqK40dfpB+1bBPSzAef58rJxRJXNJ661GbOZ5
'' SIG '' e64EuyIQv0Vo5ZptaWZiftQ5pgmztaZCuNIIvxPHCyvI
'' SIG '' AjmSfRuX7Uyke0k29rSTruRsBVIsifG39gldsbyjOvkD
'' SIG '' N7S3pJtTwJV0ToC4VWg00kpunk72PORup31ahW99fU3j
'' SIG '' xBh2fHjiefjZUa08d/nQQdLWCzadttpkZvCgH/dc8Mts
'' SIG '' 2CwrcxCPZ5p9VuGcqyFhK2I6PS0POnMuf70R3lrl5Y87
'' SIG '' dO8f4Kv83bkhq5g+IrY5KvLcIEER5kt5uuorpWzJmBNG
'' SIG '' B+62OVNMz92YJFl/Lt+NvkGFTuGZy96TLMPdLcrNSpPG
'' SIG '' V5qHqnHlr/wUz9UAViTKJArvSbvk/siU7mi29oqRxb0a
'' SIG '' hB4oYVPNuv7ccHTBGqNNGol4MIIHcTCCBVmgAwIBAgIT
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
'' SIG '' BmoQtB1VM1izoXBm8qGCAs4wggI3AgEBMIH4oYHQpIHN
'' SIG '' MIHKMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
'' SIG '' Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
'' SIG '' TWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxN
'' SIG '' aWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMSYwJAYD
'' SIG '' VQQLEx1UaGFsZXMgVFNTIEVTTjpFQUNFLUUzMTYtQzkx
'' SIG '' RDElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAg
'' SIG '' U2VydmljZaIjCgEBMAcGBSsOAwIaAxUAAbquMnUCam/m
'' SIG '' 7Ox1Uv/GNs1jmu+ggYMwgYCkfjB8MQswCQYDVQQGEwJV
'' SIG '' UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
'' SIG '' UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
'' SIG '' cmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1T
'' SIG '' dGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQUFAAIFAOb6
'' SIG '' zdwwIhgPMjAyMjEwMjAwMzI2MjBaGA8yMDIyMTAyMTAz
'' SIG '' MjYyMFowdzA9BgorBgEEAYRZCgQBMS8wLTAKAgUA5vrN
'' SIG '' 3AIBADAKAgEAAgIBrgIB/zAHAgEAAgIRrzAKAgUA5vwf
'' SIG '' XAIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZ
'' SIG '' CgMCoAowCAIBAAIDB6EgoQowCAIBAAIDAYagMA0GCSqG
'' SIG '' SIb3DQEBBQUAA4GBADqznRD9gttfs+LqZlWYI9GgJ+qp
'' SIG '' BeQLYI5a4SfbzdUNakCNiXc/AQDiCHQ1UJfbswcslY4j
'' SIG '' yj5kr5LSYyu+DolPPTyeWvkrVUWziQ+l8BlSXVOzx1vf
'' SIG '' Pv/vhb4ysKfh8fsozsqesh5czkSZiUKfkWVSxwQlDeb8
'' SIG '' DzNQAcpD026dMYIEDTCCBAkCAQEwgZMwfDELMAkGA1UE
'' SIG '' BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNV
'' SIG '' BAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
'' SIG '' b3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
'' SIG '' bWUtU3RhbXAgUENBIDIwMTACEzMAAAGawHWixCFtPoUA
'' SIG '' AQAAAZowDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3
'' SIG '' DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0BCQQx
'' SIG '' IgQgZGdZxN9cv0oL74MfmWh/EwhH2Xu4TqQpLnzLTw+n
'' SIG '' HCAwgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCAB
'' SIG '' TkDjOBEUfZnligJiL539Lx+nsr/NFVTnKFX030iNYDCB
'' SIG '' mDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpX
'' SIG '' YXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYD
'' SIG '' VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNV
'' SIG '' BAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEw
'' SIG '' AhMzAAABmsB1osQhbT6FAAEAAAGaMCIEIGPAjJVDSOHx
'' SIG '' 9tW2MmgfIgtBJfVAHc2fplkc++/UCzihMA0GCSqGSIb3
'' SIG '' DQEBCwUABIICAGw5u6ki8Qi130FuJ60r5ea49MDJ83ML
'' SIG '' Bu04vUYiOetGk7vmAS6bF+j0wytxuM7uNUVgbYOhkv5h
'' SIG '' VwqlbNUPQI34aF6wGXQJTHnmm2d7lLvaOV5gc/3hCDzQ
'' SIG '' B1bOhhrtkfsEE/4i+b4UIYSaIA3QIqTIJJSKDNdzjhCj
'' SIG '' o1InzShWTuELijZXyyZCtvOfzr+51jyoHptjqSX0oqi7
'' SIG '' 4dgMBup38dWiWh17e+3zce8Y9RrjOUSEAEr5RHsPerH7
'' SIG '' KLetfYTD3eiYGE+WGqxzQJ8/eUGkEfWrqhPUfX/7nBaB
'' SIG '' h6uy9x9ppRCZlQS0LSe4CkuItWPL1c67zVAckGtGsYAY
'' SIG '' zZ+uKDzWXi7eS6rYImpy77ilf7sVv0p4so0t2R8xr/sc
'' SIG '' kuII/BOenWQkP7N+RjmG84xwE8FRnuuw4X646pxyG44Z
'' SIG '' hPNWF4zFDRoHwe50XnhRQgocFDj4CtJIOC/Tg83QPGCM
'' SIG '' JDgqzGzDOotyl5jChyQBjUz2WyWhAbtcLXd0Tc+R+06j
'' SIG '' YNQ237x9TbPzQeAsrEdjY0l5/lL7vjAvvsSdh1Qhgaco
'' SIG '' 6BxkCJKNC5mi1DJfbyVa2XUu9bC8jrSDardnLrRCv4yG
'' SIG '' RY2XWVL0b/8X5TSSeDmUSwXNBxWOcvaJoB62qY+t8T50
'' SIG '' NKt11ATHX5umYvg6mRZs742zdcVWNA64NZ8d
'' SIG '' End signature block
