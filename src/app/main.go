package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"time"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"
)

func main() {
	log.Printf("starting philip-app\n")

	// HACK: getting current namespace
	// Apparently this is the way: see https://github.com/kubernetes-client/python/issues/363
	var namespace string
	{
		b, err := ioutil.ReadFile("/var/run/secrets/kubernetes.io/serviceaccount/namespace")
		if err != nil {
			log.Fatal(err)
		}

		namespace = string(b)
		log.Printf("namespace is: %s", namespace)
	}

	// in-cluster config
	config, err := rest.InClusterConfig()
	if err != nil {
		log.Fatal(err)
	}

	// clientset
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		log.Fatal(err)
	}

	deps, err := clientset.AppsV1().Deployments(namespace).List(metav1.ListOptions{})
	if err != nil {
		log.Printf(err.Error())
	}

	for i, dep := range deps.Items {
		fmt.Printf("deployment %d. %s\n", i, dep.GetName())
	}

	for {
		time.Sleep(10)
	}
}
