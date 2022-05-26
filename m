Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4F55352AD
	for <lists+io-uring@lfdr.de>; Thu, 26 May 2022 19:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348381AbiEZRj1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 May 2022 13:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348288AbiEZRjN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 May 2022 13:39:13 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197AC996A6
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:39:13 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24QFNanm023171
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:39:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=QH4r+VUDqXluEqZvZRr1nBur/lZ6NB5gKdOPalXnQRE=;
 b=SeUsrQ85lfAXsjPit475diaXGDDWGisIOqXJd5RtDH0iJCDnc4IVB4FKThriXa11/8gy
 bLIYkMq7QLoUaUqCNHjH13YvnalZxj9R2G2t0GQoH3hFJPaHKI0wk+rUGRcCUocAuO5E
 /Dn0NbKz1WeRK6MxBmLuDfB6nvdr5fHzXrg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g93upxw6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 26 May 2022 10:39:12 -0700
Received: from twshared8508.05.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 26 May 2022 10:39:11 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 90D90FA621DE; Thu, 26 May 2022 10:38:45 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [PATCH v6 09/16] fs: Add async write file modification handling.
Date:   Thu, 26 May 2022 10:38:33 -0700
Message-ID: <20220526173840.578265-10-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220526173840.578265-1-shr@fb.com>
References: <20220526173840.578265-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: f673KriKBpadAqbZgjs0WEEBCJTRq_QM
X-Proofpoint-GUID: f673KriKBpadAqbZgjs0WEEBCJTRq_QM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-26_09,2022-05-25_02,2022-02-23_01
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
---
 fs/inode.c         | 43 +++++++++++++++++++++++++++++++++++++++++--
 include/linux/fs.h |  1 +
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index c44573a32c6a..4503bed063e7 100644
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
index 407ad5004f54..2d9b3afcb4a5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2384,6 +2384,7 @@ static inline void file_accessed(struct file *file)
 }
=20
 extern int file_modified(struct file *file);
+int kiocb_modified(struct kiocb *iocb);
=20
 int sync_inode_metadata(struct inode *inode, int wait);
=20
--=20
2.30.2

