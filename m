Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFFE45FCFB
	for <lists+io-uring@lfdr.de>; Sat, 27 Nov 2021 06:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244426AbhK0GBJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Nov 2021 01:01:09 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17922 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243881AbhK0F7G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Nov 2021 00:59:06 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AR2xkkb018917
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 21:55:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=quLcGe8M8WkNv4h+9Ale0u3mw4BzXj5UDLOKMkH4Z9I=;
 b=Rt9MbbXXTdy6bt6/J07vIMrXmD2f8hJmJzggcA4tdC3WfCE5pggXT/5nIxyqy7mWjxeI
 Jc4Se233an7jnSERXTKuBFQrPbl5K/VPWKuAtZsmgPbbQXCghiuZU2o3Tk+K8sQ8ssHo
 vAijYASbmM3nSWfA2+/YjBa2yjdu8gJlC78= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3ckcc3rg0n-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 21:55:52 -0800
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 26 Nov 2021 21:55:51 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 56A926F661A8; Fri, 26 Nov 2021 21:55:41 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v4 2/3] fs: split off vfs_getdents function of getdents64 syscall
Date:   Fri, 26 Nov 2021 21:55:34 -0800
Message-ID: <20211127055535.2976876-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211127055535.2976876-1-shr@fb.com>
References: <20211127055535.2976876-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: T7F_AsWeQjYBHwDKvY-n34N1WoGOPX7W
X-Proofpoint-ORIG-GUID: T7F_AsWeQjYBHwDKvY-n34N1WoGOPX7W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-27_02,2021-11-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 impostorscore=0 malwarescore=0 mlxscore=0 mlxlogscore=827
 priorityscore=1501 adultscore=0 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111270031
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This splits off the vfs_getdents function from the getdents64 system
call. This allows io_uring to call the function.

Signed-off-by: Stefan Roesch <shr@fb.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/internal.h |  8 ++++++++
 fs/readdir.c  | 37 +++++++++++++++++++++++++++++--------
 2 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 7979ff8d168c..355be993b9f1 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -194,3 +194,11 @@ long splice_file_to_pipe(struct file *in,
 			 struct pipe_inode_info *opipe,
 			 loff_t *offset,
 			 size_t len, unsigned int flags);
+
+/*
+ * fs/readdir.c
+ */
+struct linux_dirent64;
+
+int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent=
,
+		 unsigned int count, s64 pos);
diff --git a/fs/readdir.c b/fs/readdir.c
index e9c197edf73a..5c3af16a6178 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -21,6 +21,7 @@
 #include <linux/unistd.h>
 #include <linux/compat.h>
 #include <linux/uaccess.h>
+#include "internal.h"
=20
 #include <asm/unaligned.h>
=20
@@ -368,22 +369,26 @@ static int filldir64(struct dir_context *ctx, const=
 char *name, int namlen,
 	return -EFAULT;
 }
=20
-SYSCALL_DEFINE3(getdents64, unsigned int, fd,
-		struct linux_dirent64 __user *, dirent, unsigned int, count)
+/**
+ * vfs_getdents - getdents without fdget
+ * @file    : pointer to file struct of directory
+ * @dirent  : pointer to user directory structure
+ * @count   : size of buffer
+ * @ctx_pos : if file pos is used, pass -1,
+ *            if ctx pos is used, pass ctx pos
+ */
+int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent=
,
+		 unsigned int count, s64 ctx_pos)
 {
-	struct fd f;
 	struct getdents_callback64 buf =3D {
 		.ctx.actor =3D filldir64,
+		.ctx.pos =3D ctx_pos,
 		.count =3D count,
 		.current_dir =3D dirent
 	};
 	int error;
=20
-	f =3D fdget_pos(fd);
-	if (!f.file)
-		return -EBADF;
-
-	error =3D iterate_dir(f.file, &buf.ctx);
+	error =3D do_iterate_dir(file, &buf.ctx, ctx_pos < 0);
 	if (error >=3D 0)
 		error =3D buf.error;
 	if (buf.prev_reclen) {
@@ -396,6 +401,22 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 		else
 			error =3D count - buf.count;
 	}
+
+	return error;
+}
+
+SYSCALL_DEFINE3(getdents64, unsigned int, fd,
+		struct linux_dirent64 __user *, dirent, unsigned int, count)
+{
+	struct fd f;
+	int error;
+
+	f =3D fdget_pos(fd);
+	if (!f.file)
+		return -EBADF;
+
+	error =3D vfs_getdents(f.file, dirent, count, -1);
+
 	fdput_pos(f);
 	return error;
 }
--=20
2.30.2

