Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCEB1DF4D8
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 06:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387565AbgEWEbp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 May 2020 00:31:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36118 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387430AbgEWEbn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 May 2020 00:31:43 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N4VfB5015315;
        Sat, 23 May 2020 04:31:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=mWgNTQumQ1encShq6SogN6drXIr1/uryGkMcf27ofJ4=;
 b=zKrtr+tBkK+GLVbkzFwDFkwTEwU/42CAwv3yt39oJK44txwAmu/1vXt7uEDmwz510lKV
 wsTFcpRQSWH/fTncRiyuOM9Fz7fRnR4rBMku/EdoTiUC7jJ8ESEBdYHPoe3fG4AoYD6N
 FsoOi/34/ulTKGdYtARGC3P5kNqpsdmkFzR5Ynkxge/3Zqmi8nljHUeYvZe1NC3RyXDW
 y+Ejy8/myJ/yeqQcqzdQRK//wRYuMV597/os6EJSCNU7z3qqOwIO4Vqpf9V0A7ne0spZ
 NVbrKCbU81lJgSeLiFX6s/qzuZidmGveTFwVv5tuRzd5LKq7dB4I4PBndzCRO9S2zSkP Sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 316vfn010w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 04:31:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N4Tng3043501;
        Sat, 23 May 2020 04:31:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 316u5gw4qx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 04:31:41 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04N4Vcrv013966;
        Sat, 23 May 2020 04:31:38 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 21:31:38 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 0/4] io_uring: call statx directly
Date:   Fri, 22 May 2020 21:31:15 -0700
Message-Id: <1590208279-33811-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=3 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230035
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=3
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005230036
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

v1 -> v2

- Separate statx and open in io_kiocb 
- Remove external declarations for unused statx interfaces

This patch set is a fix for the liburing statx test failure.

The test fails with a "Miscompare between io_uring and statx" error
because the statx system call path has additional processing in vfs_statx():

        stat->result_mask |= STATX_MNT_ID;
        if (path.mnt->mnt_root == path.dentry)
                stat->attributes |= STATX_ATTR_MOUNT_ROOT;
        stat->attributes_mask |= STATX_ATTR_MOUNT_ROOT;

which then results in different result_mask values.

Allowing the system call to be invoked directly simplifies the io_uring
interface and avoids potential future incompatibilities.  I'm not sure
if there was other reasoning fort not doing so initially.

One issue I cannot account for is the difference in "used" memory reported
by free(1) after running the statx a large (10000) number of times.

The difference is significant ~100k and doesn't really change after
dropping caches.

I enabled memory leak detection and couldn't see anything related to the test.

Bijan Mottahedeh (4):
  io_uring: add io_statx structure
  statx: allow system call to be invoked from io_uring
  io_uring: call statx directly
  statx: hide interfaces no longer used by io_uring

 fs/internal.h |  4 ++--
 fs/io_uring.c | 72 +++++++++++++++--------------------------------------------
 fs/stat.c     | 37 +++++++++++++++++-------------
 3 files changed, 42 insertions(+), 71 deletions(-)

-- 
1.8.3.1

