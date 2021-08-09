
# AWS S3 mutiple files downloading tool

A brief description of how to use this windows shell script

## Environment Variables

To run this project, you will need to add the following environment variables to the bat. file

Please replace {bucketName} with your aws s3 bucket name in line 13, 14, 15

`bucketName`



  
## Run Locally

Install aws cli version 2

```bash
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /

```

Run command in windows terminal

Sample command: 

```bash
S3fileDownload 2020-02-03 2020-02-04 all 3
```
  
## Documentation

Valid command: 

**script_name** +

**parameter1** : start date (2020-02-03) +

**parameter2** : end date (2020-02-04) +

**parameter3** : file format (supported  file type: all files, valid argument: all, csv ,attachment )

**parameter4** : prefered downloading frequency(how many files you would like to download at once): (valid value: 1~10)

**Note** :  parameter4:configure the amount of files that you would like to download at the same time(it can be use to improve the download speed)  
