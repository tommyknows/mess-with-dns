package main

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestParseMX(t *testing.T) {
	jsonString := `{"Hdr":{"Name":"example.com.","Rrtype":15,"Class":1,"Ttl":3600,"Rdlength":0},"Preference":10,"Mx":"mail.example.com."}`
	x, _ := ParseRecord([]byte(jsonString))
	assert.Equal(t, x.String(), "example.com.	3600	IN	MX	10 mail.example.com.")
}

func TestReadFromDb(t *testing.T) {
	record, err := ReadFromDB("example.com.", 15, 3600, `{"Preference": 10, "Mx": "mail.example.com."}`)
	if err != nil {
		t.Errorf("error: %s", err)
	}
	assert.Equal(t, record.String(), "example.com.	3600	IN	MX	10 mail.example.com.")
}
