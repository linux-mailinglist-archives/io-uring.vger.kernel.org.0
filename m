Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030BF45FD00
	for <lists+io-uring@lfdr.de>; Sat, 27 Nov 2021 07:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351637AbhK0GIw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Nov 2021 01:08:52 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12100 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244807AbhK0GGv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Nov 2021 01:06:51 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AR30Oig016260
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 22:03:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=quLcGe8M8WkNv4h+9Ale0u3mw4BzXj5UDLOKMkH4Z9I=;
 b=MZDIM3sbMaWrp70ZYzlc9qvXvU0VAe6b1L4W5a7lfRtX2TSxq3nT8dg+ZMxknWpB8+DL
 pNOCy6t4lkosaeaqbM2Omg1T12SkqknuSni6bx55bt4O+7VS2xR5LZK0ovgXrkTLoO1p
 LEqDDdRVQl7t+bN2/f1Fq+S6POmmum7gbh0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3ck3f4jsn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 22:03:37 -0800
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 26 Nov 2021 22:03:36 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 1AFB36F679A8; Fri, 26 Nov 2021 22:03:35 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v5 2/3] fs: split off vfs_getdents function of getdents64 syscall
Date:   Fri, 26 Nov 2021 22:03:25 -0800
Message-ID: <20211127060326.3018505-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211127060326.3018505-1-shr@fb.com>
References: <20211127060326.3018505-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: 94J3-VDLXodr2na5nfXUyhdVeDu0AsIT
X-Proofpoint-GUID: 94J3-VDLXodr2na5nfXUyhdVeDu0AsIT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-27_02,2021-11-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 suspectscore=0 adultscore=0 mlxlogscore=827
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111270032
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

