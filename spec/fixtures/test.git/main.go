package main

import (
	"errors"
	"time"
)

func main() {
	withUnusedParam("part", "a")
	withUnusedParam("part", "b")

	for {
		select {
		case <-time.After(1 * time.Microsecond):
		}
	}

	ErrFunction()
}

func ExportedWithoutComment(value string) string { //
	return value
}

// ErrFunction has the sole purpose of simulating unchecked errors
func ErrFunction() error {
	return errors.New("Simulated failure")
}

func withUnusedParam(prefix string, param string) string {
	return prefix + param
}

func statiCheckUnused(value string) string {
	return value
}
