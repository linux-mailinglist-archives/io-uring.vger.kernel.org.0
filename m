Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9AD528AF0
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 18:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343941AbiEPQtC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 12:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343506AbiEPQs7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 12:48:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76AC3CA4E
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:48 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24GFibhK016165
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ytINONjGb5g4AiCRPvl5zx2CjqhigNhOPZAk5ycuIEA=;
 b=V888tU8+rnxpRIkcK3Cwp13O4l7V8oOfFVTGIoGFzwDAqgLEkkMXYnKKk/7g90kgrdsc
 ZH3Uro3vm96cMB2mrgi1alyLZJDeITvN2aESHDbuTNz68yp4+AHReFVru0mDC4gT9te2
 sccT0oQAk5zlKD3c6Va6fp0KPzuMw3P+IQc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3g27x9b0e9-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:47 -0700
Received: from twshared10276.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 16 May 2022 09:48:46 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 652D9F146DDD; Mon, 16 May 2022 09:48:25 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v2 07/16] fs: split off need_file_update_time and do_file_update_time
Date:   Mon, 16 May 2022 09:47:09 -0700
Message-ID: <20220516164718.2419891-8-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220516164718.2419891-1-shr@fb.com>
References: <20220516164718.2419891-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 04LLA28-qNA2J95_4MJZRU_ilSmE98_h
X-Proofpoint-ORIG-GUID: 04LLA28-qNA2J95_4MJZRU_ilSmE98_h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 fs/inode.c | 71 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 24 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index a6d70a1983f8..1d0b02763e98 100644
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
+static int need_file_update_time(struct inode *inode, struct file *file,
+				struct timespec64 *now)
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
@@ -2091,15 +2078,49 @@ int file_update_time(struct file *file)
 	if (!sync_it)
 		return 0;
=20
+	return sync_it;
+}
+
+static int do_file_update_time(struct inode *inode, struct file *file,
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
@@ -2108,6 +2129,7 @@ int file_modified(struct file *file)
 	int ret;
 	struct dentry *dentry =3D file_dentry(file);
 	struct inode *inode =3D file_inode(file);
+	struct timespec64 now =3D current_time(inode);
=20
 	/*
 	 * Clear the security bits if the process is not being run by root.
@@ -2122,10 +2144,11 @@ int file_modified(struct file *file)
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
--=20
2.30.2

