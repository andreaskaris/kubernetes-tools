/*
 Build with: go run churn.go
 Run with: ./churn 600
 This would run a for loop for 600ms and will then sleep for 400ms and would hence yield 60% CPU utilization in top
*/

package main

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Println("Provide runtime in ms")
		os.Exit(1)
	}
	runtimeMs, err := strconv.Atoi(os.Args[1])
	if err != nil || runtimeMs < 1 || runtimeMs > 999 {
		fmt.Println("Provide runtime > 0 and < 1000")
		os.Exit(1)
	}
	sleeptimeMs := 1000 - runtimeMs

	pid := os.Getpid()
	fmt.Printf("Our PID is: %d\n", pid)
	fmt.Printf("Run for %dms every 1000ms\n", runtimeMs)

	c := make(chan bool)
	for true {
		time.Sleep(time.Millisecond * time.Duration(sleeptimeMs))
		fmt.Printf("s")
		go func(c chan bool) {
			for true {
				select {
				case signal := <-c:
					fmt.Printf("e")
					if signal {
						return
					}
				default:
					//fmt.Printf(".")
					continue
				}
			}
		}(c)
		time.Sleep(time.Millisecond * time.Duration(runtimeMs))
		c <- true
	}
}
