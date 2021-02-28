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

func churnProcessor(runtimeMs int) {
	fmt.Printf("Run for %dms every 1000ms\n", runtimeMs)
	sleeptimeMs := 1000 - runtimeMs

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

func main() {
	if len(os.Args) != 2 {
		fmt.Println("Provide runtime in ms")
		os.Exit(1)
	}
	totalRuntimeMs, err := strconv.Atoi(os.Args[1])
	if err != nil || totalRuntimeMs < 1 {
		fmt.Println("Provide runtime > 0")
		os.Exit(1)
	}

	pid := os.Getpid()
	fmt.Printf("Our PID is: %d\n", pid)
	fmt.Printf("Run for %dms every 1000ms (cumulative runtime of all threads)\n", totalRuntimeMs)

	for i := 0; i < totalRuntimeMs/1000; i++ {
		go churnProcessor(1000)
	}
	if totalRuntimeMs%1000 != 0 {
		go churnProcessor(totalRuntimeMs % 1000)
	}
	select {} // sleep forever
}
