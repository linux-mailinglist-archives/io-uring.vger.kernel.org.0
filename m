Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0DD47C3F7
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 17:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239922AbhLUQkR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Dec 2021 11:40:17 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43358 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239923AbhLUQkQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Dec 2021 11:40:16 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BLAv0Cp031091
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 08:40:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=maKUEsrXreQEdv70dvYM6PyPTmWdehj8lma5Y9RMvj4=;
 b=n/pXlxvqAoTUmTIpvklC/JtW3D3gTFgu4N9a1XObr99a4V4T3dcdXig26edoSqxHW4JS
 OfNmMrjof3tSoo94wXHn95WuvCeGxKuJyoq3vx0sC+qC5wRCnm97YueGoy9QDzPac+ob
 8QaoxQESYuDWMd2SZhJ7XyouPcaRiRHscD4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d3dm82bm0-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 08:40:16 -0800
Received: from twshared18912.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 08:40:13 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id AD4C585BEA6A; Tue, 21 Dec 2021 08:40:07 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <shr@fb.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH v7 2/3] fs: split off vfs_getdents function of getdents64 syscall
Date:   Tue, 21 Dec 2021 08:40:03 -0800
Message-ID: <20211221164004.119663-3-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211221164004.119663-1-shr@fb.com>
References: <20211221164004.119663-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Le18y4bURk-s9x2-ZhgoDUEdBw_HpBU1
X-Proofpoint-ORIG-GUID: Le18y4bURk-s9x2-ZhgoDUEdBw_HpBU1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-21_04,2021-12-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxlogscore=879
 suspectscore=0 malwarescore=0 clxscore=1015 bulkscore=0 impostorscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112210082
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This splits off the vfs_getdents function from the getdents64 system
call. This allows io_uring to call the vfs_getdents function.

Signed-off-by: Stefan Roesch <shr@fb.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/internal.h |  8 ++++++++
 fs/readdir.c  | 36 ++++++++++++++++++++++++++++--------
 2 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 7979ff8d168c..432ea3ce76ec 100644
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
+		 unsigned int count, loff_t *pos);
diff --git a/fs/readdir.c b/fs/readdir.c
index c1e6612e0f47..1b1fade87525 100644
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
@@ -359,22 +360,25 @@ static int filldir64(struct dir_context *ctx, const=
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
+ * @pos     : file pos
+ */
+int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent=
,
+		 unsigned int count, loff_t *pos)
 {
-	struct fd f;
 	struct getdents_callback64 buf =3D {
 		.ctx.actor =3D filldir64,
+		.ctx.pos =3D *pos,
 		.count =3D count,
 		.current_dir =3D dirent
 	};
 	int error;
=20
-	f =3D fdget_pos(fd);
-	if (!f.file)
-		return -EBADF;
-
-	error =3D iterate_dir(f.file, &buf.ctx, &f.file->f_pos);
+	error =3D iterate_dir(file, &buf.ctx, pos);
 	if (error >=3D 0)
 		error =3D buf.error;
 	if (buf.prev_reclen) {
@@ -391,6 +395,22 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 	return error;
 }
=20
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
+	error =3D vfs_getdents(f.file, dirent, count, &f.file->f_pos);
+
+	fdput_pos(f);
+	return error;
+ }
+
 #ifdef CONFIG_COMPAT
 struct compat_old_linux_dirent {
 	compat_ulong_t	d_ino;
--=20
2.30.2

