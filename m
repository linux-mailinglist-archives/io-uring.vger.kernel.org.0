Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D94674551
	for <lists+io-uring@lfdr.de>; Thu, 19 Jan 2023 22:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjASV5f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Jan 2023 16:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjASV4l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Jan 2023 16:56:41 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2617BC75A;
        Thu, 19 Jan 2023 13:36:58 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30JLT7pn020883;
        Thu, 19 Jan 2023 21:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=tgi0NHzFNTC2PXd/dVfjBLhMgv4GasaIfpQj+AgfFvQ=;
 b=VuNaj5XRR9ji4hLVETEoWTdKeXHyCJ7cw4VkvHQWQ8LM5OOqsf+3J/ur/a2Fuj+UNgEH
 4M93MXU6KUfrSMHzVLbEsdnS2VPcq5QQmNR1bqgYB5BifSEbeoVIYkdh00rJzRi2uMGL
 Jd5yY3kLI1riyKNW4V6cL5Hb/4lE4c+e9rJwg3EndmT2n7sk4rmmvHEoRsK1h/JRuBez
 3lcMYaBX9++ht1JXM6JwOdcSsDNBRVbk2M494MYzvcKKNW9ks8qIcJq0At8oAJ7a+zFB
 NzVW5xC1Fad7LBBozDtWNWfrFxUc3S9vcUY9+T+Ihmuz7DV2l0wDPukkNh0CCPSMRnCq xw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3medkfa7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 21:36:57 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30JLMIDA000844;
        Thu, 19 Jan 2023 21:36:56 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3n74d1sr5k-1;
        Thu, 19 Jan 2023 21:36:56 +0000
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Phoronix pts fio io_uring test regression report on upstream v6.1 and v5.15
Date:   Thu, 19 Jan 2023 13:36:55 -0800
Message-Id: <20230119213655.2528828-1-saeed.mirzamohammadi@oracle.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-19_14,2023-01-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301190181
X-Proofpoint-ORIG-GUID: sroxozAO160FyyCZvFR2G8tBCv8kRI6v
X-Proofpoint-GUID: sroxozAO160FyyCZvFR2G8tBCv8kRI6v
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,
 
I'm reporting a performance regression after the commit below on phoronix pts/fio test and with the config that is added in the end of this email:

Link: https://lore.kernel.org/all/20210913131123.597544850@linuxfoundation.org/

commit 7b3188e7ed54102a5dcc73d07727f41fb528f7c8
Author: Jens Axboe axboe@kernel.dk
Date:   Mon Aug 30 19:37:41 2021 -0600
 
    io_uring: IORING_OP_WRITE needs hash_reg_file set
 
We observed regression on the latest v6.1.y and v5.15.y upstream kernels (Haven't tested other stable kernels). We noticed that performance regression improved 45% after the revert of the commit above.
 
All of the benchmarks below have experienced around ~45% regression.
phoronix-pts-fio-1.15.0-RandomWrite-EngineIO_uring-BufferedNo-DirectYes-BlockSize4KB-MB-s_xfs
phoronix-pts-fio-1.15.0-SequentialWrite-EngineIO_uring-BufferedNo-DirectYes-BlockSize4KB-MB-s_xfs
phoronix-pts-fio-1.15.0-SequentialWrite-EngineIO_uring-BufferedYes-DirectNo-BlockSize4KB-MB-s_xfs
 
We tend to see this regression on 4KB BlockSize tests.
 
We tried out changing force_async but that has no effect on the result. Also, backported a modified version of the patch mentioned here (https://lkml.org/lkml/2022/7/20/854) but that didn't affect performance.
 
Do you have any suggestions on any fixes or what else we can try to narrow down the issue?
 
Thanks a bunch,
Saeed
--------
 
Here is more info on the benchmark and system:
 
Here is the config for fio:
[global]
rw=randwrite
ioengine=io_uring
iodepth=64
size=1g
direct=1
buffered=0
startdelay=5
force_async=4
ramp_time=5
runtime=20
time_based
disk_util=0
clat_percentiles=0
disable_lat=1
disable_clat=1
disable_slat=1
filename=/data/fiofile
[test]
name=test
bs=4k
stonewall
 
df -Th output (file is on /data/):
Filesystem                 Type      Size  Used Avail Use% Mounted on
devtmpfs                   devtmpfs  252G     0  252G   0% /dev
tmpfs                      tmpfs     252G     0  252G   0% /dev/shm
tmpfs                      tmpfs     252G   18M  252G   1% /run
tmpfs                      tmpfs     252G     0  252G   0% /sys/fs/cgroup
/dev/mapper/ocivolume-root xfs        89G   17G   73G  19% /
/dev/mapper/ocivolume-oled xfs        10G  143M  9.9G   2% /var/oled
/dev/sda2                  xfs      1014M  643M  372M  64% /boot
/dev/sda1                  vfat      100M  5.0M   95M   6% /boot/efi
tmpfs                      tmpfs      51G     0   51G   0% /run/user/0
tmpfs                      tmpfs      51G     0   51G   0% /run/user/987
/dev/mapper/tank-lvm       xfs       100G  1.8G   99G   2% /data
