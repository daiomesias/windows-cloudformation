# #!/bin/bash
# #The script make a snapshot list and delete the backup older than the limited list (37 snapshot).
# #You need to configure first your AWS access Key with an IAM user provided with the following policy:
# # {
# #     "Version": "2012-10-17",
# #     "Statement": [
# #         {
# #             "Sid": "VisualEditor0",
# #             "Effect": "Allow",
# #             "Action": [
# #                 "ec2:DeleteSnapshot",
# #                 "ec2:DescribeSnapshotAttribute",
# #                 "ec2:DescribeFastSnapshotRestores",
# #                 "ec2:DescribeSnapshots",
# #                 "ec2:DescribeImportSnapshotTasks"
# #             ],
# #             "Resource": "*"
# #         }
# #     ]
# # }



# #aws ec2 describe-snapshots --filters Name=status,Values=completed --query "Snapshots[*].{ID:SnapshotId,Time:StartTime}" 
# #aws ec2 describe-snapshots --filters Name=status,Values=completed --query Snapshots[?StartTime\<=\`$datetrim\`]

# Delete files older than iRetentionDays

37

snapshot de un dia

ultima hora divida en 6
24 horas, 24 snapshots
7 Dias

iRetentionDays = 7 ( probable que sean 8)

aws ec2 describe-snapshots --filters Name=status,Values=completed --query "Snapshots[*].{ID:SnapshotId,Time:StartTime}" 
/root/.local/bin/aws s3 ls --recursive s3://$sBucketName/$sPath/ | while read -r sFile; do
	dCreatedAt=$(echo $sFile | awk {'print $1'})
	dCreatedAt=$(date -d "$dCreatedAt" +%s)
	dOldestDate=$(date -d "$iRetentionDays days ago" +%s)
	if [[ $dCreatedAt -lt $dOldestDate ]]; then
		fileName=$(echo $sFile | awk {'print $4'})
		if [[ $fileName != "" ]]; then
        aws ec2 delete-snapshot --region $region --snapshot-id $snapToDelete --dry-run
			/root/.local/bin/aws s3 rm --quiet s3://$sBucketName/$sPath/$fileName
		fi
	fi
done;










# # Determine whether the OS is Linux or OSX based
# #if [ `uname` == "OSX" ]; then
# #    DateRange=$(date -v-30d +%s) #OSX
# #else
#     DateRange=$(date --date="1300 days ago" +%s)
# #fi


# region="us-west-2"

# date > SnapshotToKeep.txt
# date > SnapshotToDelete.txt

# echo "Snapshot Info"


#            #Create a SnapshotList
#             aws ec2 describe-snapshots --region $region --output json > SnapshotList.txt
            
#             # Separate SnapshotList
#             cat SnapshotList.txt | egrep "StartTime|SnapshotId" | awk -F'"' '{print $4}'  | awk 'NR%2{printf "%s, ",$0;next;}1' > SnapshotList.txt_tmp


# #Read all the SnapshotList and delete the older Snapshots
#                             while read snap
#                             do
#                              echo "working on snap " $snap
#                              raw_date=`echo $snap | cut -d, -f1`
#                              snap_date=`date -d $raw_date +%s`
#                              echo "Snap date is: " $snap_date
#                              echo "Snap to compare is: " $  DateRange
#                              #Compare Current date with each Snapshot date
#                                        if [ $DateRange -gt $snap_date ]
#                                        then
#                                           echo $snap | cut -d, -f2 >> SNAP_TO_DELETE.txt
#                                           snapToDelete=`echo $snap | cut -d, -f2`
#                                           echo "Deleting Snapshot: " $snapToDelete
#                                           aws ec2 delete-snapshot --region $region --snapshot-id $snapToDelete --dry-run
#                                           echo "aws ec2 delete-snapshot --region" $region "--snapshot-id" $snapToDelete --dry-run
#                                        else
#                                           echo $snap | cut -d, -f2 >> SNAP_TO_KEEP.txt
#                                              fi
#                             done < SnapshotList.txt_tmp



Create a snapshotID by date (older than 30 days)

Make a list


Delete the filelist



958719817359