# Wordpress running on Elastic BeanStalk & RDS
Elastic BeanStalk is an easy and simple way to run web based applications and benefit the power of AWS.

To ease even more the installation and configuration of our wordpress example we will be using [docker](https://www.docker.io).

## Deploy using the AWS Console
- Make sure there is a default VPC (Console -> VPC -> Create default VPC)
- Create RDS using MySQL (Console -> RDS -> Create Database -> db.t2.small and MySQL)
- Create the Ealistic Beanstalk environment (Console -> Elastic BeanStalk -> Create environment -> Platform: docker, Application Code: Sample Application)
- Once the environment is ready: Configuration -> Software Configuration and add the following environment variables:
`WORDPRESS_DB_HOST` endpoint of your RDS database
`WORDPRESS_DB_USER` master User of your database
`WORDPRESS_DB_PASSWORD` password of your master user
`WORDPRESS_DB_NAME` name of the database you configured in RDS

To have a more detail how de deploy elastic Beanstalk look the following youtube video

****************** HERE YOUTUBE VIDEO ***********************

## Via code
Deploy the following environment via code, this requires to have a shell and have [terraform](https://terraform.io), [aws-cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) configured.

then simply just run the command `make deploy` to delete everything `make destroy`

## Conclusions
Elastic Beanstalk provides very simple functionalities to run a web based application, more configuration can be provided to make the deployment even more resiliant. Please bare in mind that this is not a production ready environment. In order to do so you need to configure high availability for the Servers and for the storage.