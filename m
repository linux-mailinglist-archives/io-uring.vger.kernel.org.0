Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00B71DDC10
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 02:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgEVATy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 May 2020 20:19:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38682 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbgEVATx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 May 2020 20:19:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M0HZJn083402;
        Fri, 22 May 2020 00:19:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Vnw68zE05X0y/pyBNWifQ+Rv6IumyyJrStcXmpMb3fw=;
 b=TIMvFjOm5brM+MLddvXebN91T8WT+g+Ku0Ubx/Uqya3LHsEA2TveEd5rOaV8H9JdHMYS
 QI5hB7FJ1VM9Bi7vBghRBS+IiOW0ovogt/Jn3NnhzAHpnOLMklwMQH7FH9oWVxGrtwHv
 I/L4G9Spe2W0bAjM88rC9wY26P40ew0JsvipINN9Uj/J/h/Tfqk0IR2R4voAoW3lNgaP
 wZEzf8sgT6jRs9YCXYeW+EGGwrGobCdT5BDimpPNX7zf/zFAg4fHFzphbQ9G/b4UOjRz
 Rc/uuAmOzlkUpQdzChU59HQ8ir+9nobM9XO/qu4bCfnhRslAls1+9HKcQycbYU8K+XoQ eQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3127krk9nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 00:19:51 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M0IagC119693;
        Fri, 22 May 2020 00:19:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 314gma598r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 00:19:51 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04M0Joch022332;
        Fri, 22 May 2020 00:19:50 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 17:19:50 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/2] statx: allow the system call to be invoked from the kernel
Date:   Thu, 21 May 2020 17:19:36 -0700
Message-Id: <1590106777-5826-2-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590106777-5826-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1590106777-5826-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=1
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220000
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
index aaa946d..37055a4 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -203,3 +203,5 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
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

