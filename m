Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875FB52C7BF
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 01:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbiERXiJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 19:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231575AbiERXiG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 19:38:06 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74315939F1
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:44 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IN6AdT017366
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=LjQjeu05KJ6rwhAZwVJii+/tlMhhh5HkUUbhHoJms8c=;
 b=qOgnI2YbIv9/5s9m6mk6DoODtHG46NDgGVf3KaJrf8F2X+rm16Y6aE0mOIWrtI4PYm3o
 Tx1p4Awqz05hIkpwB1r/ToZl1YT4Iesd70+If1NeiO58HGiwrmVB0GX9eidlQh5xbw+0
 7A/uGNqma9LqocbvWyNWD9kyIsoC8dZeitg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4ck0m9vj-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 16:37:44 -0700
Received: from twshared8307.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 18 May 2022 16:37:38 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id C6D65F3ED85D; Wed, 18 May 2022 16:37:12 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v3 06/18] fs: Split off remove_needs_file_privs() __remove_file_privs()
Date:   Wed, 18 May 2022 16:36:57 -0700
Message-ID: <20220518233709.1937634-7-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518233709.1937634-1-shr@fb.com>
References: <20220518233709.1937634-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: iAVReF_yaXPJ5o-69CHHDFnODbxmaree
X-Proofpoint-ORIG-GUID: iAVReF_yaXPJ5o-69CHHDFnODbxmaree
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

