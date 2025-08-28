#import the modules and libraries
import boto3
from pprint import pprint
#open management console 
aws_management_console = boto3.session.Session(profile_name="default")

#open iam console
# iam_console = aws_management_console.resource("iam")
iam_console_client = aws_management_console.client(service_name = "iam")

#list all users using client object
# for each_user in iam_console_client.list_users()["Users"]:
#     print(each_user["UserName"])



response = iam_console_client.list_users()
for each_user in response["Users"]:
    print(each_user["UserName"])
    print(f"username: {each_user['UserName']}, userId: {each_user['UserId']}, createdon: {each_user['CreateDate']}")
# pprint(result['Users'])   
# dictory how to refer the key value in the dictiory  , {} curly brace ,花括号一般就是dictionary. 读取dictionary的值
#  然后 users 里面是一个list  使用for loop 打印eachi_user

#  use boto3 documentation to get more information  https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/iam/client/list_users.html
# for each_user in iam_console_client.list_users()["Users"]:
#     print(f"username: {each_user['UserName']}, userId: {each_user['UserId']}, createdon: {each_user['CreatedDate']}")     
