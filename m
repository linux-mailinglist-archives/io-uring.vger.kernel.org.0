Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4DD54ECAA
	for <lists+io-uring@lfdr.de>; Thu, 16 Jun 2022 23:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379138AbiFPVd0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jun 2022 17:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379143AbiFPVdZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jun 2022 17:33:25 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566A14991B
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 14:33:24 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GKPWTb032033
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 14:33:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=hg9mOHqe8lbN/Pa620EqWCYSM90BEn33RivumAhrzAE=;
 b=GWyZVaw3xkTWIdDstvRPeaNMsgXRLrr6bDzOW8PdCq+1iFfqL029ldH6mu+hFJEjJKwz
 GL2WTmUE/XPfJrMit0PUZI8ekIaVJEtlWzUm9cSZSFpQvRUU0ryT4N05QoC6+mI2drwP
 5otmHRVP3fstAcl19jN+ipx2hzUV8l5Cpac= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gqxc5yk64-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 16 Jun 2022 14:33:23 -0700
Received: from twshared17349.03.ash7.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 16 Jun 2022 14:33:20 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id C98EA108B70AF; Thu, 16 Jun 2022 14:22:23 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>, <axboe@kernel.dk>, <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>
Subject: [PATCH v9 09/14] fs: Split off inode_needs_update_time and __file_update_time
Date:   Thu, 16 Jun 2022 14:22:16 -0700
Message-ID: <20220616212221.2024518-10-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220616212221.2024518-1-shr@fb.com>
References: <20220616212221.2024518-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: B5l15Qpfz8UZaAy1UZApsa3drbCGpAu4
X-Proofpoint-ORIG-GUID: B5l15Qpfz8UZaAy1UZApsa3drbCGpAu4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-16_18,2022-06-16_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This splits off the functions inode_needs_update_time() and
__file_update_time() from the function file_update_time().

This is required to support async buffered writes.
No intended functional changes in this patch.

Signed-off-by: Stefan Roesch <shr@fb.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/inode.c | 76 +++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 50 insertions(+), 26 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index a2e18379c8a6..ff726d99ecc7 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2049,35 +2049,18 @@ int file_remove_privs(struct file *file)
 }
 EXPORT_SYMBOL(file_remove_privs);
=20
-/**
- *	file_update_time	-	update mtime and ctime time
- *	@file: file accessed
- *
- *	Update the mtime and ctime members of an inode and mark the inode
- *	for writeback.  Note that this function is meant exclusively for
- *	usage in the file write path of filesystems, and filesystems may
- *	choose to explicitly ignore update via this function with the
- *	S_NOCMTIME inode flag, e.g. for network filesystem where these
- *	timestamps are handled by the server.  This can return an error for
- *	file systems who need to allocate space in order to update an inode.
- */
-
-int file_update_time(struct file *file)
+static int inode_needs_update_time(struct inode *inode, struct timespec6=
4 *now)
 {
-	struct inode *inode =3D file_inode(file);
-	struct timespec64 now;
 	int sync_it =3D 0;
-	int ret;
=20
 	/* First try to exhaust all avenues to not sync */
 	if (IS_NOCMTIME(inode))
 		return 0;
=20
-	now =3D current_time(inode);
-	if (!timespec64_equal(&inode->i_mtime, &now))
+	if (!timespec64_equal(&inode->i_mtime, now))
 		sync_it =3D S_MTIME;
=20
-	if (!timespec64_equal(&inode->i_ctime, &now))
+	if (!timespec64_equal(&inode->i_ctime, now))
 		sync_it |=3D S_CTIME;
=20
 	if (IS_I_VERSION(inode) && inode_iversion_need_inc(inode))
@@ -2086,15 +2069,50 @@ int file_update_time(struct file *file)
 	if (!sync_it)
 		return 0;
=20
-	/* Finally allowed to write? Takes lock. */
-	if (__mnt_want_write_file(file))
-		return 0;
+	return sync_it;
+}
+
+static int __file_update_time(struct file *file, struct timespec64 *now,
+			int sync_mode)
+{
+	int ret =3D 0;
+	struct inode *inode =3D file_inode(file);
=20
-	ret =3D inode_update_time(inode, &now, sync_it);
-	__mnt_drop_write_file(file);
+	/* try to update time settings */
+	if (!__mnt_want_write_file(file)) {
+		ret =3D inode_update_time(inode, now, sync_mode);
+		__mnt_drop_write_file(file);
+	}
=20
 	return ret;
 }
+
+/**
+ * file_update_time - update mtime and ctime time
+ * @file: file accessed
+ *
+ * Update the mtime and ctime members of an inode and mark the inode for
+ * writeback. Note that this function is meant exclusively for usage in
+ * the file write path of filesystems, and filesystems may choose to
+ * explicitly ignore updates via this function with the _NOCMTIME inode
+ * flag, e.g. for network filesystem where these imestamps are handled
+ * by the server. This can return an error for file systems who need to
+ * allocate space in order to update an inode.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int file_update_time(struct file *file)
+{
+	int ret;
+	struct inode *inode =3D file_inode(file);
+	struct timespec64 now =3D current_time(inode);
+
+	ret =3D inode_needs_update_time(inode, &now);
+	if (ret <=3D 0)
+		return ret;
+
+	return __file_update_time(file, &now, ret);
+}
 EXPORT_SYMBOL(file_update_time);
=20
 /**
@@ -2111,6 +2129,8 @@ EXPORT_SYMBOL(file_update_time);
 int file_modified(struct file *file)
 {
 	int ret;
+	struct inode *inode =3D file_inode(file);
+	struct timespec64 now =3D current_time(inode);
=20
 	/*
 	 * Clear the security bits if the process is not being run by root.
@@ -2123,7 +2143,11 @@ int file_modified(struct file *file)
 	if (unlikely(file->f_mode & FMODE_NOCMTIME))
 		return 0;
=20
-	return file_update_time(file);
+	ret =3D inode_needs_update_time(inode, &now);
+	if (ret <=3D 0)
+		return ret;
+
+	return __file_update_time(file, &now, ret);
 }
 EXPORT_SYMBOL(file_modified);
=20
--=20
2.30.2

