Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949A41DF4D3
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 06:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387460AbgEWEbo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 May 2020 00:31:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49384 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387559AbgEWEbn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 May 2020 00:31:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N4VgJc106512;
        Sat, 23 May 2020 04:31:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=tMPhRUznemQYR8I0qfmrrxDkqLn+onW192ks+8m3fWI=;
 b=xXH53Mx3ZdmlnnidzgCOS6pusNkEAX7xWMv88ugfyplqTWT55hju4UrGvXq5PFXg67Za
 4N9YF3FqYStC2V1FMo9gs8o/Wfm/yXGf56kTimvaIuwwFqCtsBh1RjUPgL/fecMt4xE1
 5hCC+cnj5XVx8gCVWr06ljdR8bZ211GO2PVE2Z03lIj47AkGr/1vtQGMaX/fjLyXDk+K
 dAHPKdtTRMKdyLYpsbxjtaEHSKM/GAD3c3AkgmDF8bzVgVrOps/i90gEaSx0daKNgiwS
 G/9cz8PNdP4xJA2tOQDmZZMJs1MN27MjxtQhbA15/qVW6AiTq1e8L1nsfvfh8gSH62By yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 316u8qg436-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 04:31:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N4TJ6Y043039;
        Sat, 23 May 2020 04:31:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 316u5gw4rm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 04:31:42 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04N4Vdgf014356;
        Sat, 23 May 2020 04:31:39 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 21:31:39 -0700
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 4/4] statx: hide interfaces no longer used by io_uring
Date:   Fri, 22 May 2020 21:31:19 -0700
Message-Id: <1590208279-33811-5-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1590208279-33811-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1590208279-33811-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=1 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230035
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 cotscore=-2147483648 suspectscore=1
 phishscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005230036
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The io_uring interfaces have been replaced by do_statx() and are no
longer needed.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/internal.h | 2 --
 fs/stat.c     | 5 +++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 614a559..fcb47cc 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -199,7 +199,5 @@ int do_fchownat(int dfd, const char __user *filename, uid_t user, gid_t group,
 /*
  * fs/stat.c:
  */
-unsigned vfs_stat_set_lookup_flags(unsigned *lookup_flags, int flags);
-int cp_statx(const struct kstat *stat, struct statx __user *buffer);
 int do_statx(int dfd, const char __user *filename, unsigned flags,
 	     unsigned int mask, struct statx __user *buffer);
diff --git a/fs/stat.c b/fs/stat.c
index bc5d2e81..44f8ad3 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -156,7 +156,8 @@ int vfs_statx_fd(unsigned int fd, struct kstat *stat,
 }
 EXPORT_SYMBOL(vfs_statx_fd);
 
-inline unsigned vfs_stat_set_lookup_flags(unsigned *lookup_flags, int flags)
+static inline unsigned vfs_stat_set_lookup_flags(unsigned *lookup_flags,
+						 int flags)
 {
 	if ((flags & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT |
 		       AT_EMPTY_PATH | KSTAT_QUERY_FLAGS)) != 0)
@@ -542,7 +543,7 @@ static long cp_new_stat64(struct kstat *stat, struct stat64 __user *statbuf)
 }
 #endif /* __ARCH_WANT_STAT64 || __ARCH_WANT_COMPAT_STAT64 */
 
-noinline_for_stack int
+static noinline_for_stack int
 cp_statx(const struct kstat *stat, struct statx __user *buffer)
 {
 	struct statx tmp;
-- 
1.8.3.1

