Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B3D52C7AA
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 01:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiERXhc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 19:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiERXhb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 19:37:31 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998F764715
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:29 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IN6CrQ013698
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=4Gs4vhLGOpR5fcqmlVRzzwre6v2yRJXtVCNsF05UpCw=;
 b=eEB8ByU2Los9/rLy8D8jn0Nsf8J4vbxEiBpGl/CicapiPmHCNEM4Y6KVdaI7hWynze1d
 rJzW2GCdwxGmzrVh+wtUk3Hq9Er78K/AumPLLZvfW26Oc5nTsL9LF/4TUTqVR6SY5ErP
 HDO3BcZvXxtsXuNDUdLWpg5jrJb49+AC1TY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4d823xhh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:29 -0700
Received: from twshared19572.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 18 May 2022 16:37:28 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id CEC84F3ED85F; Wed, 18 May 2022 16:37:12 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v3 07/18] fs: Split off file_needs_update_time and __file_update_time
Date:   Wed, 18 May 2022 16:36:58 -0700
Message-ID: <20220518233709.1937634-8-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518233709.1937634-1-shr@fb.com>
References: <20220518233709.1937634-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: FaAXI9Nn0-pME8f2lkE4vZQzat-FmFi7
X-Proofpoint-ORIG-GUID: FaAXI9Nn0-pME8f2lkE4vZQzat-FmFi7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
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

This splits off the functions file_needs_update_time() and
__file_update_time() from the function file_update_time().

This is required to support async buffered writes.
No intended functional changes in this patch.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/inode.c | 75 +++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 49 insertions(+), 26 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 1bb8b7db836f..4bb7f583cc6b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2059,35 +2059,19 @@ int file_remove_privs(struct file *file)
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
+static int file_needs_update_time(struct inode *inode, struct file *file=
,
+				struct timespec64 *now)
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
@@ -2096,15 +2080,49 @@ int file_update_time(struct file *file)
 	if (!sync_it)
 		return 0;
=20
-	/* Finally allowed to write? Takes lock. */
-	if (__mnt_want_write_file(file))
-		return 0;
+	return sync_it;
+}
+
+static int __file_update_time(struct inode *inode, struct file *file,
+			struct timespec64 *now, int sync_mode)
+{
+	int ret =3D 0;
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
+ /**
+  * file_update_time - update mtime and ctime time
+  * @file: file accessed
+  *
+  * Update the mtime and ctime members of an inode and mark the inode fo=
r
+  * writeback. Note that this function is meant exclusively for usage in
+  * the file write path of filesystems, and filesystems may choose to
+  * explicitly ignore updates via this function with the _NOCMTIME inode
+  * flag, e.g. for network filesystem where these imestamps are handled
+  * by the server. This can return an error for file systems who need to
+  * allocate space in order to update an inode.
+  *
+  * Return: 0 on success, negative errno on failure.
+  */
+int file_update_time(struct file *file)
+{
+	int ret;
+	struct inode *inode =3D file_inode(file);
+	struct timespec64 now =3D current_time(inode);
+
+	ret =3D file_needs_update_time(inode, file, &now);
+	if (ret <=3D 0)
+		return ret;
+
+	return __file_update_time(inode, file, &now, ret);
+}
 EXPORT_SYMBOL(file_update_time);
=20
 /**
@@ -2123,6 +2141,7 @@ int file_modified(struct file *file)
 	int ret;
 	struct dentry *dentry =3D file_dentry(file);
 	struct inode *inode =3D file_inode(file);
+	struct timespec64 now =3D current_time(inode);
=20
 	/*
 	 * Clear the security bits if the process is not being run by root.
@@ -2141,7 +2160,11 @@ int file_modified(struct file *file)
 	if (unlikely(file->f_mode & FMODE_NOCMTIME))
 		return 0;
=20
-	return file_update_time(file);
+	ret =3D file_needs_update_time(inode, file, &now);
+	if (ret <=3D 0)
+		return ret;
+
+	return __file_update_time(inode, file, &now, ret);
 }
 EXPORT_SYMBOL(file_modified);
=20
--=20
2.30.2

