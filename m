Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FA61DF4D9
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 06:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387559AbgEWEbp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 May 2020 00:31:45 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:36132 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387565AbgEWEbo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 May 2020 00:31:44 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N4VfiA015312;
        Sat, 23 May 2020 04:31:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=c5JGZPji4xsDwy+7rWcQ1WL/L1ADRtsD1VFwUwKdSp0=;
 b=Jp99Px/49v31s3LI7tolW/rLjv/uR5k0grjmCaIzlcqpEvQ1ardvMBIpTJh7i8YrLTRq
 UnEceV93ej2un0JerRl36jwJ0DBGamCf69DIeZG5WwPG8K2y7ItHe5UbztHWsSAhjqQw
 qBHgRAbGMq9AX2nsOPbkRma2EcINudELdTxgOPuen6i8QRQRQSpyDL4Pqk43Jkm6cRQK
 5KSHPCHQEBtZwa4k+3u6MMrvzLGni8iFiT31oBmbCbvR3Ifs4et03C2AWykFJqMFKZse
 jIrynz2I6XSHy2vIXXUjLUD0Ij+HLnFVEwDwrbLUAyLff2i05HXjGVx/CheJDyNjc/Mq aw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 316vfn010u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 04:31:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N4SZdg077514;
        Sat, 23 May 2020 04:31:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 316rxr2wjd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 04:31:40 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04N4Vdmb029791;
        Sat, 23 May 2020 04:31:39 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 21:31:38 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 2/4] statx: allow system call to be invoked from io_uring
Date:   Fri, 22 May 2020 21:31:17 -0700
Message-Id: <1590208279-33811-3-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590208279-33811-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1590208279-33811-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 phishscore=0 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005230035
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=1
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005230036
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a prepatory patch to allow io_uring to invoke statx directly.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/internal.h |  2 ++
 fs/stat.c     | 32 +++++++++++++++++++-------------
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index c9ff00f..614a559 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -201,3 +201,5 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
  */
 unsigned vfs_stat_set_lookup_flags(unsigned *lookup_flags, int flags);
 int cp_statx(const struct kstat *stat, struct statx __user *buffer);
+int do_statx(int dfd, const char __user *filename, unsigned flags,
+	     unsigned int mask, struct statx __user *buffer);
diff --git a/fs/stat.c b/fs/stat.c
index 3213d1b..bc5d2e81 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -577,6 +577,24 @@ static long cp_new_stat64(struct kstat *stat, struct stat64 __user *statbuf)
 	return copy_to_user(buffer, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
 
+int do_statx(int dfd, const char __user *filename, unsigned flags,
+	     unsigned int mask, struct statx __user *buffer)
+{
+	struct kstat stat;
+	int error;
+
+	if (mask & STATX__RESERVED)
+		return -EINVAL;
+	if ((flags & AT_STATX_SYNC_TYPE) == AT_STATX_SYNC_TYPE)
+		return -EINVAL;
+
+	error = vfs_statx(dfd, filename, flags, &stat, mask);
+	if (error)
+		return error;
+
+	return cp_statx(&stat, buffer);
+}
+
 /**
  * sys_statx - System call to get enhanced stats
  * @dfd: Base directory to pathwalk from *or* fd to stat.
@@ -593,19 +611,7 @@ static long cp_new_stat64(struct kstat *stat, struct stat64 __user *statbuf)
 		unsigned int, mask,
 		struct statx __user *, buffer)
 {
-	struct kstat stat;
-	int error;
-
-	if (mask & STATX__RESERVED)
-		return -EINVAL;
-	if ((flags & AT_STATX_SYNC_TYPE) == AT_STATX_SYNC_TYPE)
-		return -EINVAL;
-
-	error = vfs_statx(dfd, filename, flags, &stat, mask);
-	if (error)
-		return error;
-
-	return cp_statx(&stat, buffer);
+	return do_statx(dfd, filename, flags, mask, buffer);
 }
 
 #ifdef CONFIG_COMPAT
-- 
1.8.3.1

