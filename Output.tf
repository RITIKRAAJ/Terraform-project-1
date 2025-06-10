
# Output for count

#output "ec2_public_id" {
 # value = aws_instance.my_instance[*].public_ip # When you want to show more ip the you have to put [*] this btw after my_instance 
#}

#output "ec2_public_dns" {
  #value = aws_instance.my_instance[*].public_dns
#}

#output "ec2_private_ip" {
#  value = aws_instance.my_instance[*].private_ip
#} 



# for_each using this type of section

output "ec2_public_ip" {
  value = [
    for key in aws_instance.my_instance : key.public_ip
  ]
}


output "ec2_public_dns" {
  value = [
    for key in aws_instance.my_instance : key.public_dns
  ]
}

output "ec2_private_ip" {
  value = [
    for key in aws_instance.my_instance : key.private_ip
  ]
}
/*
output "ec2_private_ip" {
  value = [
    for instance in aws_instance.my_instance : instance.private_ip
  ]
}
*/
