Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29C8B14E78A
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 04:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbgAaDY3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jan 2020 22:24:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59220 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727827AbgAaDY3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jan 2020 22:24:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00V3NeZN134325;
        Fri, 31 Jan 2020 03:24:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2019-08-05;
 bh=e9udwEvAI2f1erE+tmYWEs722/8u1w85VhRstQ7aDXc=;
 b=DYc5XR+aSy6gvSPdhrQzc7pdmKyWFBoppkm1pGTthnICeDmzINIupCxW1n6/s1MSpjvr
 LffyRaGxLKate6tD59AS76jIXqeeCCxAArfKFMUEMvZRP7Son+dWqMFfm5qBtFPxJQ2c
 paEEGxbbWpMrCzoU7iTOeUbla0s56AiApqx2AfvwHHmVrUIVj5aQpbzDFu5YTfKDnAs2
 NUouMo8m/WoakxxVGciApWahYVo+6CiwzD5vZCT+OVML8DKg06yA4P5MNS3UNhyPVbik
 I9dVBzSoOGed6ASEHOtgoBVWBB4Z8PYIao0kBVhqjSKTQCoxdjMkopVYblW5xFfmMjp3 sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xrd3uqvy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 03:24:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00V3OIA5155488;
        Fri, 31 Jan 2020 03:24:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xv9bvmbbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 03:24:25 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00V3NuBq026203;
        Fri, 31 Jan 2020 03:23:56 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jan 2020 19:23:55 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH 0/1] block: Manage bio references so the bio persists until necessary
Date:   Thu, 30 Jan 2020 19:23:41 -0800
Message-Id: <1580441022-59129-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=827
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001310028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=900 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001310028
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch addresses a bio reference count problem encountered while
debugging a different, use-after-free bug with the fio test below.

The original use-after-free bug is still hit however.

[global]
filename=/dev/nvme0n1
rw=randread
bs=4k
direct=1
time_based=1
randrepeat=1
gtod_reduce=1
[fiotest]


fio nvme.fio --readonly --ioengine=io_uring --iodepth 1024 --fixedbufs 
--hipri --numjobs=$1 --runtime=$2

Bijan Mottahedeh (1):
  block: Manage bio references so the bio persists until necessary

 fs/block_dev.c | 78 ++++++++++++++++++++++++++++++----------------------------
 1 file changed, 40 insertions(+), 38 deletions(-)

-- 
1.8.3.1

