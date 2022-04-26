Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBF35105B8
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 19:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349265AbiDZRrR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 13:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353595AbiDZRrP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 13:47:15 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA06A183240
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:06 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QGQTVr003393
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+WNxfbgx5KplNQxILus6+cfK8Ur0YvLuT9aWWjF0PNM=;
 b=PSN+MFz5/TGIG15H4ZKgPAhVr+GPLFFt16AoWbGSIqe1+0qGfSF5u2dEfcVwjXbxCxCZ
 HD9spi/LttKnCjC2T71fmfSrVOvKfX1WrNqWxAe5Yp23aboswFsl6ucv29PYkZmx7cTK
 Yfxo/KcYFPHfPcVhukTZr7hISzn9qZuSymA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fp6a352pe-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 10:44:06 -0700
Received: from twshared13345.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 10:44:02 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 9BB50E2D4861; Tue, 26 Apr 2022 10:43:40 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>
Subject: [RFC PATCH v1 07/18] fs: split off need_remove_file_privs() do_remove_file_privs()
Date:   Tue, 26 Apr 2022 10:43:24 -0700
Message-ID: <20220426174335.4004987-8-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220426174335.4004987-1-shr@fb.com>
References: <20220426174335.4004987-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Sgen28DxzGu0PGXxJJmoE7cmwkfuUXCX
X-Proofpoint-ORIG-GUID: Sgen28DxzGu0PGXxJJmoE7cmwkfuUXCX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_05,2022-04-26_02,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This splits off the function need_remove_file_privs() from the function
do_remove_file_privs() from the function file_remove_privs().

No intended functional changes in this patch.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/inode.c         | 56 +++++++++++++++++++++++++++++++---------------
 include/linux/fs.h |  3 +++
 2 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 9d9b422504d1..79c5702ef7c3 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2010,17 +2010,8 @@ static int __remove_privs(struct user_namespace *m=
nt_userns,
 	return notify_change(mnt_userns, dentry, &newattrs, NULL);
 }
=20
-/*
- * Remove special file priviledges (suid, capabilities) when file is wri=
tten
- * to or truncated.
- */
-int file_remove_privs(struct file *file)
+int need_file_remove_privs(struct inode *inode, struct dentry *dentry)
 {
-	struct dentry *dentry =3D file_dentry(file);
-	struct inode *inode =3D file_inode(file);
-	int kill;
-	int error =3D 0;
-
 	/*
 	 * Fast path for nothing security related.
 	 * As well for non-regular files, e.g. blkdev inodes.
@@ -2030,16 +2021,37 @@ int file_remove_privs(struct file *file)
 	if (IS_NOSEC(inode) || !S_ISREG(inode->i_mode))
 		return 0;
=20
-	kill =3D dentry_needs_remove_privs(dentry);
-	if (kill < 0)
-		return kill;
-	if (kill)
-		error =3D __remove_privs(file_mnt_user_ns(file), dentry, kill);
+	return dentry_needs_remove_privs(dentry);
+}
+
+int do_file_remove_privs(struct file *file, struct inode *inode,
+			struct dentry *dentry, int kill)
+{
+	int error =3D 0;
+
+	error =3D __remove_privs(file_mnt_user_ns(file), dentry, kill);
 	if (!error)
 		inode_has_no_xattr(inode);
=20
 	return error;
 }
+
+/*
+ * Remove special file privileges (suid, capabilities) when file is writ=
ten
+ * to or truncated.
+ */
+int file_remove_privs(struct file *file)
+{
+	struct dentry *dentry =3D file_dentry(file);
+	struct inode *inode =3D file_inode(file);
+	int kill;
+
+	kill =3D need_file_remove_privs(inode, dentry);
+	if (kill <=3D 0)
+		return kill;
+
+	return do_file_remove_privs(file, inode, dentry, kill);
+}
 EXPORT_SYMBOL(file_remove_privs);
=20
 /**
@@ -2094,14 +2106,22 @@ EXPORT_SYMBOL(file_update_time);
 int file_modified(struct file *file)
 {
 	int err;
+	int ret;
+	struct dentry *dentry =3D file_dentry(file);
+	struct inode *inode =3D file_inode(file);
=20
 	/*
 	 * Clear the security bits if the process is not being run by root.
 	 * This keeps people from modifying setuid and setgid binaries.
 	 */
-	err =3D file_remove_privs(file);
-	if (err)
-		return err;
+	ret =3D need_file_remove_privs(inode, dentry);
+	if (ret < 0) {
+		return ret;
+	} else if (ret > 0) {
+		ret =3D do_file_remove_privs(file, inode, dentry, ret);
+		if (ret)
+			return ret;
+	}
=20
 	if (unlikely(file->f_mode & FMODE_NOCMTIME))
 		return 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3b479d02e210..c2992d12601f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2381,6 +2381,9 @@ static inline void file_accessed(struct file *file)
 		touch_atime(&file->f_path);
 }
=20
+extern int need_file_remove_privs(struct inode *inode, struct dentry *de=
ntry);
+extern int do_file_remove_privs(struct file *file, struct inode *inode,
+				struct dentry *dentry, int kill);
 extern int file_modified(struct file *file);
=20
 int sync_inode_metadata(struct inode *inode, int wait);
--=20
2.30.2

