Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF045105B1
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 19:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353458AbiDZRrM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 13:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350732AbiDZRrH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 13:47:07 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BD3182B36
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:00 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGQSSg024604
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:43:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+afQfK4CT3eBlKnjt62h4RtRoU2YgtSppm+Z9dUCHYQ=;
 b=KO7YM2X6fVZ4BVJPYi4SSSIb9fy4LtrbQWtubnPaoeUNV0JfcUFTH3ZLMCTD8WMkqAXZ
 s+LByzPwwgiV93BndtG/AKuUFOUHIPWMBW5KvdlDF4qIRya9ZD0yvGoYf4F4+bRRO1V+
 Zbd27EHAHf+6zZTKTTId0dGsyyCHSd13jdw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fn1ge03fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:43:59 -0700
Received: from twshared10896.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 10:43:58 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id A2809E2D4863; Tue, 26 Apr 2022 10:43:40 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>
Subject: [RFC PATCH v1 08/18] fs: split off need_file_update_time and do_file_update_time
Date:   Tue, 26 Apr 2022 10:43:25 -0700
Message-ID: <20220426174335.4004987-9-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426174335.4004987-1-shr@fb.com>
References: <20220426174335.4004987-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Uh8EJjE2onYq0SF_SFM5D4M325EHZJl_
X-Proofpoint-GUID: Uh8EJjE2onYq0SF_SFM5D4M325EHZJl_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This splits off the functions need_file_update_time() and
do_file_update_time() from the function file_update_time().

This is required to support async buffered writes.
No intended functional changes in this patch.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/inode.c         | 72 ++++++++++++++++++++++++++++++----------------
 include/linux/fs.h |  5 ++++
 2 files changed, 52 insertions(+), 25 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 79c5702ef7c3..64047bb0b9f8 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2054,35 +2054,22 @@ int file_remove_privs(struct file *file)
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
+int need_file_update_time(struct inode *inode, struct file *file,
+			struct timespec64 *now)
 {
-	struct inode *inode =3D file_inode(file);
-	struct timespec64 now;
 	int sync_it =3D 0;
-	int ret;
+
+	if (unlikely(file->f_mode & FMODE_NOCMTIME))
+		return 0;
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
@@ -2091,24 +2078,58 @@ int file_update_time(struct file *file)
 	if (!sync_it)
 		return 0;
=20
+	return sync_it;
+}
+
+int do_file_update_time(struct inode *inode, struct file *file,
+			struct timespec64 *now, int sync_mode)
+{
+	int ret;
+
 	/* Finally allowed to write? Takes lock. */
 	if (__mnt_want_write_file(file))
 		return 0;
=20
-	ret =3D inode_update_time(inode, &now, sync_it);
+	ret =3D inode_update_time(inode, now, sync_mode);
 	__mnt_drop_write_file(file);
=20
 	return ret;
 }
+
+/**
+ *	file_update_time	-	update mtime and ctime time
+ *	@file: file accessed
+ *
+ *	Update the mtime and ctime members of an inode and mark the inode
+ *	for writeback.  Note that this function is meant exclusively for
+ *	usage in the file write path of filesystems, and filesystems may
+ *	choose to explicitly ignore update via this function with the
+ *	S_NOCMTIME inode flag, e.g. for network filesystem where these
+ *	timestamps are handled by the server.  This can return an error for
+ *	file systems who need to allocate space in order to update an inode.
+ */
+
+int file_update_time(struct file *file)
+{
+	int err;
+	struct inode *inode =3D file_inode(file);
+	struct timespec64 now =3D current_time(inode);
+
+	err =3D need_file_update_time(inode, file, &now);
+	if (err < 0)
+		return err;
+
+	return do_file_update_time(inode, file, &now, err);
+}
 EXPORT_SYMBOL(file_update_time);
=20
 /* Caller must hold the file's inode lock */
 int file_modified(struct file *file)
 {
-	int err;
 	int ret;
 	struct dentry *dentry =3D file_dentry(file);
 	struct inode *inode =3D file_inode(file);
+	struct timespec64 now =3D current_time(inode);
=20
 	/*
 	 * Clear the security bits if the process is not being run by root.
@@ -2123,10 +2144,11 @@ int file_modified(struct file *file)
 			return ret;
 	}
=20
-	if (unlikely(file->f_mode & FMODE_NOCMTIME))
-		return 0;
+	ret =3D need_file_update_time(inode, file, &now);
+	if (ret <=3D 0)
+		return ret;
=20
-	return file_update_time(file);
+	return do_file_update_time(inode, file, &now, ret);
 }
 EXPORT_SYMBOL(file_modified);
=20
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c2992d12601f..e268a1a50357 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2384,6 +2384,11 @@ static inline void file_accessed(struct file *file=
)
 extern int need_file_remove_privs(struct inode *inode, struct dentry *de=
ntry);
 extern int do_file_remove_privs(struct file *file, struct inode *inode,
 				struct dentry *dentry, int kill);
+extern int need_file_update_time(struct inode *inode, struct file *file,
+				struct timespec64 *now);
+extern int do_file_update_time(struct inode *inode, struct file *file,
+			struct timespec64 *now, int sync_mode);
+
 extern int file_modified(struct file *file);
=20
 int sync_inode_metadata(struct inode *inode, int wait);
--=20
2.30.2

