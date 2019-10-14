sudo: required
services:
  - docker

before_install:
  - docker build -t jesufrancis31/docker-react-multic-test -f ./client/Dockerfile.dev ./client

script:
  - docker run jesufrancis31/docker-react-multic-test npm test -- --coverage

after_success:
  - docker build -t jesufrancis31/docker-multi-client ./client
  - docker build -t jesufrancis31/docker-multi-nginx ./nginx
  - docker build -t jesufrancis31/docker-multi-server ./server
  - docker build -t jesufrancis31/docker-multi-worker ./worker

#Login to the docker CLI
  - echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_ID" --password-stdin

#Take those images and push them to docker hub

  - docker push jesufrancis31/docker-multi-client
  - docker push jesufrancis31/docker-multi-nginx
  - docker push jesufrancis31/docker-multi-server
  - docker push jesufrancis31/docker-multi-worker
deploy:
   provider: elasticbeanstalk
   region: ap-south-a
   app: docker-react-multi-container
   env: DockerReactMultiContainer-env
   bucket_name: elasticbeanstalk-ap-south-1-334342053018
   bucket_path: docker-react-multi-container
   on:
    branch: master
   access_key_id: 
     secure: $AWS_ACCESS_KEY
   secret_access_key:
      secure: $AWS_SECRET_KEY

