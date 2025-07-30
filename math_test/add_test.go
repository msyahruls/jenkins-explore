package math_test

import (
	"jenkins-explore/math"
	"testing"
)

func TestAdd(t *testing.T) {
	result := math.Add(2, 3)
	expected := 5

	if result != expected {
		t.Errorf("Expected %d but got %d", expected, result)
	}
}
