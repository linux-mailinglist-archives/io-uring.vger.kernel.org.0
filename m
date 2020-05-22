Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79B01DDC0E
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 02:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgEVATx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 May 2020 20:19:53 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42624 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgEVATx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 May 2020 20:19:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M0Hc2a047113;
        Fri, 22 May 2020 00:19:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=TkIFON2IgZpeHHKLjub7/YpGISvP5nDDyrQMNgGDESw=;
 b=bY2ZSbxF7faubK7FU+v8VjZ6udF2b+YZQrtd7U7YqEvWoWKmafEVfTCx8HFpXTcIJDge
 UKj1QLp1CYrE6ewsd3TJjYnfw4bObV+ZRIANN1pvhWd4idhDyLen82Mx2p+aEM/0rrMg
 eRgG3svIQ4byz0s944psFBxUm2n76cS54i2WMlkpBrifNIcWh9Or6Q9uuDodduH9H2Rs
 Qi3ql4HBQvkSIyPnYmY22eAELTG2Q2vfxFFrCHxA2U4pYxfShsSm9xKFYJdB+jJY7atA
 tJllxzvzNFcsdSj3A7u29govAujINOpqcsInFJ1b5a7u8/ZQOZB91xmO8mCS4N8Q8XcK EA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 31501rhs4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 00:19:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M0JFNg119641;
        Fri, 22 May 2020 00:19:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 312t3cs2tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 00:19:50 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04M0JnVl013855;
        Fri, 22 May 2020 00:19:49 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 17:19:49 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/2] io_uring: call statx directly
Date:   Thu, 21 May 2020 17:19:35 -0700
Message-Id: <1590106777-5826-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=3 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 clxscore=1011 priorityscore=1501 cotscore=-2147483648
 impostorscore=0 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0
 mlxscore=0 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220000
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

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

Bijan Mottahedeh (2):
  statx: allow the system call to be invoked from the kernel
  io_uring: call statx directly

 fs/internal.h |  2 ++
 fs/io_uring.c | 53 +++++++----------------------------------------------
 fs/stat.c     | 32 +++++++++++++++++++-------------
 3 files changed, 28 insertions(+), 59 deletions(-)

-- 
1.8.3.1

