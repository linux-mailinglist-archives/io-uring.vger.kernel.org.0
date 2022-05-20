Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D82152F357
	for <lists+io-uring@lfdr.de>; Fri, 20 May 2022 20:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237044AbiETSis (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 May 2022 14:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352996AbiETShy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 May 2022 14:37:54 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE3A195E90
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:51 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KHSadl020010
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=eRv8uAwss7XyRCk6NE/nwLa4/tzHUoenyM8a0++XiQI=;
 b=XQ08eS3KSB4jHhZUb7EAR5qmuBmfVV7iCeEhPidFWmvXxq6GHuvBsVPFCNn8qYXGjrim
 4GDi8zZXS9MWfcjB60aSQnJBukfiaD09V01DDbE/soswPZ451P6BAUIImlBCn4Tpw74s
 7iUnMBBDLoJik3k4YeYKLaeIHpSlGCHIvHs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g60bnn9k8-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 11:37:51 -0700
Received: from twshared24024.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 20 May 2022 11:37:49 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 9ACD6F5E5B37; Fri, 20 May 2022 11:37:16 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>,
        <hch@infradead.org>
Subject: [RFC PATCH v4 11/17] fs: Add async write file modification handling.
Date:   Fri, 20 May 2022 11:36:40 -0700
Message-ID: <20220520183646.2002023-12-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220520183646.2002023-1-shr@fb.com>
References: <20220520183646.2002023-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: _AQVDdRyUvTSjlP7VZO1nryGXAh7KaW3
X-Proofpoint-GUID: _AQVDdRyUvTSjlP7VZO1nryGXAh7KaW3
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

This adds a file_modified_async() function to return -EAGAIN if the
request either requires to remove privileges or needs to update the file
modification time. This is required for async buffered writes, so the
request gets handled in the io worker of io-uring.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/inode.c         | 25 ++++++++++++++++++++++++-
 fs/xfs/xfs_file.c  |  2 +-
 include/linux/fs.h |  1 +
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 4bb7f583cc6b..3a5d0fa468ab 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2137,6 +2137,27 @@ EXPORT_SYMBOL(file_update_time);
  * Return: 0 on success, negative errno on failure.
  */
 int file_modified(struct file *file)
+{
+	return file_modified_async(file, 0);
+}
+EXPORT_SYMBOL(file_modified);
+
+/**
+ * file_modified_async - handle mandated vfs changes when modifying a fi=
le
+ * @file: file that was modified
+ * @flags: kiocb flags
+ *
+ * When file has been modified ensure that special
+ * file privileges are removed and time settings are updated.
+ *
+ * If IOCB_NOWAIT is set, special file privileges will not be removed an=
d
+ * time settings will not be updated. It will return -EAGAIN.
+ *
+ * Context: Caller must hold the file's inode lock.
+ *
+ * Return: 0 on success, negative errno on failure.
+ */
+int file_modified_async(struct file *file, int flags)
 {
 	int ret;
 	struct dentry *dentry =3D file_dentry(file);
@@ -2163,10 +2184,12 @@ int file_modified(struct file *file)
 	ret =3D file_needs_update_time(inode, file, &now);
 	if (ret <=3D 0)
 		return ret;
+	if (flags & IOCB_NOWAIT)
+		return -EAGAIN;
=20
 	return __file_update_time(inode, file, &now, ret);
 }
-EXPORT_SYMBOL(file_modified);
+EXPORT_SYMBOL(file_modified_async);
=20
 int inode_needs_sync(struct inode *inode)
 {
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 5bddb1e9e0b3..793918c83755 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -410,7 +410,7 @@ xfs_file_write_checks(
 		spin_unlock(&ip->i_flags_lock);
=20
 out:
-	return file_modified(file);
+	return file_modified_async(file, iocb->ki_flags);
 }
=20
 static int
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3b479d02e210..9760283af7dc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2382,6 +2382,7 @@ static inline void file_accessed(struct file *file)
 }
=20
 extern int file_modified(struct file *file);
+extern int file_modified_async(struct file *file, int flags);
=20
 int sync_inode_metadata(struct inode *inode, int wait);
=20
--=20
2.30.2

