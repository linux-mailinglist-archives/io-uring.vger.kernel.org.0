Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC9E53AFAA
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 00:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbiFAVHS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 17:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiFAVHO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 17:07:14 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0824561629
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 14:07:13 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251HgMO2011588
        for <io-uring@vger.kernel.org>; Wed, 1 Jun 2022 14:07:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=iNcYV+f/9Xb9s2DKDhXxqtFLBfqGp5UatKpqDyVtVPI=;
 b=mbRI2JE8wrEfyVfd+5ioDAnsMcaQEKDqUsnZDez9U0g7Dk3LSDz5C6yZ2cE9abl4VxUg
 CeB2AOlCYRPYM4ybmU6OX1c8PBeUQnzh4zdAmiWQicu6TL0Ad5N/LgRj0S19bnjUCUir
 k1wqxVBKVTGUUQT6iCICejr1+gzJuzTkIcc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ge3wk4ub5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 01 Jun 2022 14:07:13 -0700
Received: from twshared24024.25.frc3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 1 Jun 2022 14:07:11 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id E1DDBFEB23A5; Wed,  1 Jun 2022 14:01:42 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>, <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v7 08/15] fs: add __remove_file_privs() with flags parameter
Date:   Wed, 1 Jun 2022 14:01:34 -0700
Message-ID: <20220601210141.3773402-9-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220601210141.3773402-1-shr@fb.com>
References: <20220601210141.3773402-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: mVckQa25hJLLKoqThBDJmJKbFXGbuN08
X-Proofpoint-ORIG-GUID: mVckQa25hJLLKoqThBDJmJKbFXGbuN08
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_08,2022-06-01_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the function __remove_file_privs, which allows the caller to
pass the kiocb flags parameter.

No intended functional changes in this patch.

Signed-off-by: Stefan Roesch <shr@fb.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/inode.c | 57 +++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 20 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 9d9b422504d1..ac1cf5aa78c8 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2010,36 +2010,43 @@ static int __remove_privs(struct user_namespace *=
mnt_userns,
 	return notify_change(mnt_userns, dentry, &newattrs, NULL);
 }
=20
-/*
- * Remove special file priviledges (suid, capabilities) when file is wri=
tten
- * to or truncated.
- */
-int file_remove_privs(struct file *file)
+static int __file_remove_privs(struct file *file, unsigned int flags)
 {
 	struct dentry *dentry =3D file_dentry(file);
 	struct inode *inode =3D file_inode(file);
+	int error;
 	int kill;
-	int error =3D 0;
=20
-	/*
-	 * Fast path for nothing security related.
-	 * As well for non-regular files, e.g. blkdev inodes.
-	 * For example, blkdev_write_iter() might get here
-	 * trying to remove privs which it is not allowed to.
-	 */
 	if (IS_NOSEC(inode) || !S_ISREG(inode->i_mode))
 		return 0;
=20
 	kill =3D dentry_needs_remove_privs(dentry);
-	if (kill < 0)
+	if (kill <=3D 0)
 		return kill;
-	if (kill)
-		error =3D __remove_privs(file_mnt_user_ns(file), dentry, kill);
+
+	if (flags & IOCB_NOWAIT)
+		return -EAGAIN;
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
+	return __file_remove_privs(file, 0);
+}
 EXPORT_SYMBOL(file_remove_privs);
=20
 /**
@@ -2090,18 +2097,28 @@ int file_update_time(struct file *file)
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
=20
 	/*
 	 * Clear the security bits if the process is not being run by root.
 	 * This keeps people from modifying setuid and setgid binaries.
 	 */
-	err =3D file_remove_privs(file);
-	if (err)
-		return err;
+	ret =3D __file_remove_privs(file, 0);
+	if (ret)
+		return ret;
=20
 	if (unlikely(file->f_mode & FMODE_NOCMTIME))
 		return 0;
--=20
2.30.2

