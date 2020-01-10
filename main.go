package main

import (
	"context"
	"github.com/micro/go-micro"
	pb "github.com/thrucker/user-service/proto/user"
	"log"
)

const topic = "user.created"

type Subscriber struct{}

func (sub *Subscriber) Process(ctx context.Context, user *pb.User) error {
	log.Println("Picked up a new message")
	return sendEmail(user)
}

func main() {
	srv := micro.NewService(
		micro.Name("go.micro.srv.email"),
		micro.Version("latest"),
	)

	srv.Init()

	err := micro.RegisterSubscriber(topic, srv.Server(), new(Subscriber))
	if err != nil {
		log.Fatalln(err)
	}

	if err := srv.Run(); err != nil {
		log.Fatalln(err)
	}
}

func sendEmail(user *pb.User) error {
	log.Println("Sending email to:", user.Email)
	return nil
}
