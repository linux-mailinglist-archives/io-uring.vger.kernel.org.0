Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A67952F32F
	for <lists+io-uring@lfdr.de>; Fri, 20 May 2022 20:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352917AbiETShl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 May 2022 14:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352925AbiETShg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 May 2022 14:37:36 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54139195935
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:36 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KHT1pA016506
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=LjQjeu05KJ6rwhAZwVJii+/tlMhhh5HkUUbhHoJms8c=;
 b=gC1n0WZzBxoCH+wECZ6OHpXO2phJjsKw0caLbf5hcbDm/QvQFGWdItF+soh3rCPMVpw3
 NV9utU1xIasPiv5kK8jKdtsEvOru5f4B1d2whSGYC8uACCB+Uns/faMnYgy6i33432xR
 D8nCGT0u8IIAyAPo6cVy1QnbDrDmavascTE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g5pj51ugh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:35 -0700
Received: from twshared8307.18.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 20 May 2022 11:37:34 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 8E9BDF5E5B31; Fri, 20 May 2022 11:37:16 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [RFC PATCH v4 09/17] fs: Split off remove_needs_file_privs() __remove_file_privs()
Date:   Fri, 20 May 2022 11:36:38 -0700
Message-ID: <20220520183646.2002023-10-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220520183646.2002023-1-shr@fb.com>
References: <20220520183646.2002023-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: mUpnMi9iHdEe3QD163SGp75JxiY30cpc
X-Proofpoint-ORIG-GUID: mUpnMi9iHdEe3QD163SGp75JxiY30cpc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-20_06,2022-05-20_02,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This splits off the function remove_needs_file_privs() from the function
__remove_file_privs() from the function file_remove_privs().

No intended functional changes in this patch.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/inode.c | 75 +++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 55 insertions(+), 20 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 9d9b422504d1..1bb8b7db836f 100644
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
+static int file_needs_remove_privs(struct inode *inode, struct dentry *d=
entry)
 {
-	struct dentry *dentry =3D file_dentry(file);
-	struct inode *inode =3D file_inode(file);
-	int kill;
-	int error =3D 0;
-
 	/*
 	 * Fast path for nothing security related.
 	 * As well for non-regular files, e.g. blkdev inodes.
@@ -2030,16 +2021,42 @@ int file_remove_privs(struct file *file)
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
+static int __file_remove_privs(struct file *file, struct inode *inode,
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
+/**
+ * file_remove_privs - remove special file privileges (suid, capabilitie=
s)
+ * @file: file to remove privileges from
+ *
+ * When file is modified by a write or truncation ensure that special
+ * file privileges are removed.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int file_remove_privs(struct file *file)
+{
+	struct dentry *dentry =3D file_dentry(file);
+	struct inode *inode =3D file_inode(file);
+	int kill;
+
+	kill =3D file_needs_remove_privs(inode, dentry);
+	if (kill <=3D 0)
+		return kill;
+
+	return __file_remove_privs(file, inode, dentry, kill);
+}
 EXPORT_SYMBOL(file_remove_privs);
=20
 /**
@@ -2090,18 +2107,36 @@ int file_update_time(struct file *file)
 }
 EXPORT_SYMBOL(file_update_time);
=20
-/* Caller must hold the file's inode lock */
+/**
+ * file_modified - handle mandated vfs changes when modifying a file
+ * @file: file that was modified
+ *
+ * When file has been modified ensure that special
+ * file privileges are removed and time settings are updated.
+ *
+ * Context: Caller must hold the file's inode lock.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
 int file_modified(struct file *file)
 {
-	int err;
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
+	ret =3D file_needs_remove_privs(inode, dentry);
+	if (ret < 0)
+		return ret;
+
+	if (ret > 0) {
+		ret =3D __file_remove_privs(file, inode, dentry, ret);
+		if (ret)
+			return ret;
+	}
=20
 	if (unlikely(file->f_mode & FMODE_NOCMTIME))
 		return 0;
--=20
2.30.2

