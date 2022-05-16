Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B19528AFF
	for <lists+io-uring@lfdr.de>; Mon, 16 May 2022 18:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343892AbiEPQtQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 May 2022 12:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343887AbiEPQs7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 May 2022 12:48:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460A63CA60
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:51 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24GFibhR016165
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=nn8G7Ds29e/TyBQLDgMvrLljDSKFPZQcqVlG8gvOL4c=;
 b=D7koE7U2o9BghY8UeNYKKZU4q+dyXMYIXbe+N77lQOlwRFPVh0eW6N75u1OPI27x43Gf
 4ejEmBQL0NsZp2W5+/bNHAiiLQ4dvfroZywAH4JkHqMfIZrpkP4vD+1sg5l4kmBaO9S4
 +7nm5mU6U3oT6AmRe9S8cl58PEYDBQfiW04= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3g27x9b0e9-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 16 May 2022 09:48:50 -0700
Received: from twshared10276.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 16 May 2022 09:48:46 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 70F2FF146DE1; Mon, 16 May 2022 09:48:25 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        <linux-mm@kvack.org>, <linux-xfs@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, <david@fromorbit.com>, <jack@suse.cz>
Subject: [RFC PATCH v2 09/16] xfs: enable async write file modification handling.
Date:   Mon, 16 May 2022 09:47:11 -0700
Message-ID: <20220516164718.2419891-10-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220516164718.2419891-1-shr@fb.com>
References: <20220516164718.2419891-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 8x82HQ1wyQaqlW1gVrL7xQbBKeVWmg21
X-Proofpoint-ORIG-GUID: 8x82HQ1wyQaqlW1gVrL7xQbBKeVWmg21
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

This modifies xfs write checks to return -EAGAIN if the request either
requires to remove privileges or needs to update the file modification
time. This is required for async buffered writes, so the request gets
handled in the io worker.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/inode.c         | 19 ++++++++++++++++++-
 fs/xfs/xfs_file.c  |  2 +-
 include/linux/fs.h |  1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index fd18b2c1b7c4..40941feaec8d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2126,6 +2126,13 @@ EXPORT_SYMBOL(file_update_time);
=20
 /* Caller must hold the file's inode lock */
 int file_modified(struct file *file)
+{
+	return file_modified_async(file, 0);
+}
+EXPORT_SYMBOL(file_modified);
+
+/* Caller must hold the file's inode lock */
+int file_modified_async(struct file *file, int flags)
 {
 	int ret;
 	struct dentry *dentry =3D file_dentry(file);
@@ -2140,6 +2147,9 @@ int file_modified(struct file *file)
 	if (ret < 0) {
 		return ret;
 	} else if (ret > 0) {
+		if (flags & IOCB_NOWAIT)
+			return -EAGAIN;
+
 		ret =3D do_file_remove_privs(file, inode, dentry, ret);
 		if (ret)
 			return ret;
@@ -2148,10 +2158,17 @@ int file_modified(struct file *file)
 	ret =3D need_file_update_time(inode, file, &now);
 	if (ret <=3D 0)
 		return ret;
+	if (flags & IOCB_NOWAIT) {
+		if (IS_PENDING_TIME(inode))
+			return 0;
+
+		inode->i_flags |=3D S_PENDING_TIME;
+		return -EAGAIN;
+	}
=20
 	return do_file_update_time(inode, file, &now, ret);
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
index 3da641dfa6d9..5f3aaf61fb4b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2385,6 +2385,7 @@ static inline void file_accessed(struct file *file)
 }
=20
 extern int file_modified(struct file *file);
+extern int file_modified_async(struct file *file, int flags);
=20
 int sync_inode_metadata(struct inode *inode, int wait);
=20
--=20
2.30.2

