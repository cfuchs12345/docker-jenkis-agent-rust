# docker-jenkis-agent-rust
A Docker image for a Jenkins Agent that can build Rust projects

This project can be used to build a docker image which acts as a Jenkins agent.
The image contains a Rust installation so that this agent can be used to build other Rust projects in Jenkins.

There is also a Jenkinsfile that can be used to build the image within Jenkins itself (for example, I use my other agent in the project "docker-jenkis-agent-docker" to also build the rust Jenkins image).
