# Define the contact lists
$one = Get-Content ~\Desktop\1.csv -Raw | ConvertFrom-Csv # Old list of contacts
$two = Get-Content ~\Desktop\2.csv -Raw | ConvertFrom-Csv # New list of contacts
"one count: $( $one.count ), two count: $( $two.count ), diff: $( $two.count - $one.count )"

# Validate that contact objects in both contact lists have identical properties
$props1 = $one[0].psobject.members | ? { $_.MemberType -eq 'NoteProperty' } | % { $_.Name } | Sort-Object
$props2 = $two[0].psobject.members | ? { $_.MemberType -eq 'NoteProperty' } | % { $_.Name } | Sort-Object
"props count: $( $props1.count ), props2 count: $( $prop2.count ), diff: $( $props2.count - $props1.count )"
if ($props1.count -ne $props2.count) {
    throw "Properties of contacts in both lists do not match."
}
for ($i = 0; $i -le $props1.count; $i++) {
    if ($props1[$i] -ne $props2[$i]) {
        throw "Contact property '$( $props[$i] )' in first contact list does not match second contact list"
    }
}

# Build hashtables for faster search. The hashtable key is a comma-delimited list of values of all properties of the contact object
$hash1 = [ordered]@{}
foreach ($o in $one) {
    #$key = ($props1 | % { "$_`:$( $o.$_ )" }) -join ','
    $key = ($props1 | % { $o.$_ }) -join ','
    if ($hash1.Contains($key)) {
        Write-Warning "onehash already contains key: $key"
    }else {
        $hash1[$key] = $o
    }
}
$hash2 = [ordered]@{}
foreach ($o in $two) {
    #$key = ($props1 | % { "$_`:$( $o.$_ )" }) -join ','
    $key = ($props1 | % { $o.$_ }) -join ','
    if ($hash2.Contains($key)) {
        Write-Warning "two already contains key: $key"
    }else {
        $hash2[$key] = $o
    }
}
$ok = $hash1.keys
$tk = $hash2.keys
"onehash count: $( $ok.count ), twohash count: $( $tk.count ), diff: $( $tk.count - $ok.count )"

# Get non-duplicates keys
$tk | ? { $_ -in $ok }

# Get duplicates keys
$tk | ? { $_ -notin $ok }

# Search for any contact field
#$ok | ? { $_ -match '1234567' } # E.g. phone number
#$tk | ? { $_ -match 'foobar' } # E.g. name

