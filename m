Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9246543A5D
	for <lists+io-uring@lfdr.de>; Wed,  8 Jun 2022 19:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbiFHR1e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jun 2022 13:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbiFHR1D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jun 2022 13:27:03 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CDE4B1FA
        for <io-uring@vger.kernel.org>; Wed,  8 Jun 2022 10:24:57 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258FPUVI012115
        for <io-uring@vger.kernel.org>; Wed, 8 Jun 2022 10:24:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=WmQ2cBbK1CQDrQgfjzkAKR20hnuG0grvqYNGjhRWqbw=;
 b=RR8xXVeRH+FLIKBu0tn6gPzY4dbJH8UrvjlUiIreMmZJRFoYnKwAxnd8GkqjMLGlwgnW
 AOf+RC2jDyNxR5C9uz7OQRHKUNWPZDK9mIy7f0/lkPm7UgN23pmWOq11zxHksdPlwb4s
 4N1vvWU6b7n7I2SxqgZ3UoPIfBc3HWx97Ek= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ghw9burfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 08 Jun 2022 10:24:56 -0700
Received: from twshared14818.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 8 Jun 2022 10:24:55 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 9FC00103BFB60; Wed,  8 Jun 2022 10:17:43 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>, <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v8 10/14] fs: Add async write file modification handling.
Date:   Wed, 8 Jun 2022 10:17:37 -0700
Message-ID: <20220608171741.3875418-11-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220608171741.3875418-1-shr@fb.com>
References: <20220608171741.3875418-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: B8ajAR3cr1iYjT7TPywWx5zEZ2IxraKg
X-Proofpoint-ORIG-GUID: B8ajAR3cr1iYjT7TPywWx5zEZ2IxraKg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-08_05,2022-06-07_02,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds a file_modified_async() function to return -EAGAIN if the
request either requires to remove privileges or needs to update the file
modification time. This is required for async buffered writes, so the
request gets handled in the io worker of io-uring.

Signed-off-by: Stefan Roesch <shr@fb.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c         | 45 ++++++++++++++++++++++++++++++++++++++++++---
 include/linux/fs.h |  1 +
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 30b933216c61..7b4c94170a70 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2116,17 +2116,21 @@ int file_update_time(struct file *file)
 EXPORT_SYMBOL(file_update_time);
=20
 /**
- * file_modified - handle mandated vfs changes when modifying a file
+ * file_modified_flags - handle mandated vfs changes when modifying a fi=
le
  * @file: file that was modified
+ * @flags: kiocb flags
  *
  * When file has been modified ensure that special
  * file privileges are removed and time settings are updated.
  *
+ * If IOCB_NOWAIT is set, special file privileges will not be removed an=
d
+ * time settings will not be updated. It will return -EAGAIN.
+ *
  * Context: Caller must hold the file's inode lock.
  *
  * Return: 0 on success, negative errno on failure.
  */
-int file_modified(struct file *file)
+static int file_modified_flags(struct file *file, int flags)
 {
 	int ret;
 	struct inode *inode =3D file_inode(file);
@@ -2136,7 +2140,7 @@ int file_modified(struct file *file)
 	 * Clear the security bits if the process is not being run by root.
 	 * This keeps people from modifying setuid and setgid binaries.
 	 */
-	ret =3D __file_remove_privs(file, 0);
+	ret =3D __file_remove_privs(file, flags);
 	if (ret)
 		return ret;
=20
@@ -2146,11 +2150,46 @@ int file_modified(struct file *file)
 	ret =3D inode_needs_update_time(inode, &now);
 	if (ret <=3D 0)
 		return ret;
+	if (flags & IOCB_NOWAIT)
+		return -EAGAIN;
=20
 	return __file_update_time(file, &now, ret);
 }
+
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
+int file_modified(struct file *file)
+{
+	return file_modified_flags(file, 0);
+}
 EXPORT_SYMBOL(file_modified);
=20
+/**
+ * kiocb_modified - handle mandated vfs changes when modifying a file
+ * @iocb: iocb that was modified
+ *
+ * When file has been modified ensure that special
+ * file privileges are removed and time settings are updated.
+ *
+ * Context: Caller must hold the file's inode lock.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int kiocb_modified(struct kiocb *iocb)
+{
+	return file_modified_flags(iocb->ki_filp, iocb->ki_flags);
+}
+EXPORT_SYMBOL_GPL(kiocb_modified);
+
 int inode_needs_sync(struct inode *inode)
 {
 	if (IS_SYNC(inode))
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bc84847c201e..c0d99b5a166b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2390,6 +2390,7 @@ static inline void file_accessed(struct file *file)
 }
=20
 extern int file_modified(struct file *file);
+int kiocb_modified(struct kiocb *iocb);
=20
 int sync_inode_metadata(struct inode *inode, int wait);
=20
--=20
2.30.2

