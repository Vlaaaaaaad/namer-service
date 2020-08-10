package namer

import (
	"encoding/json"
	"github.com/google/go-cmp/cmp"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestNamerHandler(t *testing.T) {
	req, err := http.NewRequest("GET", "/", nil)
	if err != nil {
		t.Fatal(err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(NameHandler)

	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got '%v' want '%v'",
			status, http.StatusOK)
	}

	want := nameResponse{
		Name: "world",
	}

	got := nameResponse{}
	err = json.NewDecoder(rr.Body).Decode(&got)
	if err != nil {
		t.Fatal(err)
	}

	// if expected.Status != response.Status {
	if diff := cmp.Diff(want, got); diff != "" {
		t.Errorf("readyHandler mismatch (-want +got):\n%s", diff)
	}
}
