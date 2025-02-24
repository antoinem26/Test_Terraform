Terraform:
Lab 1:
Create a new directory
Use the following terraform docker provider:
kreuzwerker/docker
Define an nginx container with terraform, using the nginx official image
Make sure the port is open on 80:8000
Apply your configuration using your local docker engine
Reach your newly spawned nginx container


Lab 2:
Re-use the code from Lab 1
Variabilize your code to make the following parameters configurable:
Image to use
Container memory
Priviledged or not
Number of containers to spawn (container names to generate)
Port to use as starting point (i.e: if defined as 3000, the first container should be reachable on 3000, the next one on 3001, then 3002…)
Turn your terraform code into a terraform module that you will commit on a github repository
Pair with a classmate, create a new repository and try to use the module created by them by referencing it from GitHub

Bonus: Pour chaque nginx container créé, afficher le hostname de votre container docker sur la page d'acceuil du server nginx 
Bonus 2: Mettez de la validation sur vos tf vars