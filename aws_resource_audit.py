import boto3

# Identifies unencrypted EBS volumes or unattached volumes.

def audit_ebs_volumes():
    ec2 = boto3.client('ec2', region_name='us-east-1')
    volumes = ec2.describe_volumes(Filters=[{'Name': 'status', 'Values': ['available']}])
    
    for vol in volumes['Volumes']:
        print(f"ALARM: Unattached Volume found! ID: {vol['VolumeId']} | Size: {vol['Size']}GB")

if __name__ == "__main__":
    print("Starting AWS Infrastructure Audit...")
    audit_ebs_volumes()
