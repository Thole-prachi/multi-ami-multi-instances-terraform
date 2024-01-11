configuration = [
    {
        "application_name": "Jenkins-master",
        "ami": "ami-079db87dc4c10ac91",
        "no_of_instances": 1,
        "instance_type": "t2.medium",
        "subnet_id": ""
        "vpc_security_group_id": ""  //use list if multiple like []
    },
    {
        "application_name": "jenkins-build",
        "ami": "",
        "no_of_instances": "2",
        "instance_type": "t2.micro",
        "subnet_id": "",
        "vpc_security_group_id": ""

    },
    {
        "application_name": "ansible",
        "ami": "",
        "no_of_instances": "1",
        "subnet_id": "",
        "vpc_security_group_id": ""
    }
]