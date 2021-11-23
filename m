Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E8245AAF7
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 19:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239700AbhKWSNb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 13:13:31 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10650 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239690AbhKWSNb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 13:13:31 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AND8UNs024576
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 10:10:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=F2BKqoEO+e9sn1K58C/k0qmyAVxy4W22ZCzTFZhQazE=;
 b=nX2l/Mh32yoD2U0TQs1FU3LXel4z/BUqAhaUlHrhgrf5GcVqllGCzC7PjMX9JCDjthZn
 fqACnulLhUTGNI/V0VsvyyPw+XOCKoxJ8F+UawKOB/+4/v3XM652T5aApPQqPgg6hXZo
 gyY5Vph8crpxDHxtQA/8TCLHheaNwNR7RKQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3ch0wxaa46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 23 Nov 2021 10:10:22 -0800
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 23 Nov 2021 10:10:16 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 0C5046CCDB41; Tue, 23 Nov 2021 10:10:13 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>
Subject: [PATCH v1 1/3] fs: add parameter use_fpos to iterate_dir function
Date:   Tue, 23 Nov 2021 10:10:08 -0800
Message-ID: <20211123181010.1607630-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211123181010.1607630-1-shr@fb.com>
References: <20211123181010.1607630-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: 3JTrty9g76GyR0YVFCPQXo_5cH5swF7N
X-Proofpoint-ORIG-GUID: 3JTrty9g76GyR0YVFCPQXo_5cH5swF7N
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-23_06,2021-11-23_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=960
 spamscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 phishscore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111230089
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds the use_fpos parameter to the iterate_dir function.
If use_fpos is true it uses the file position in the file
structure (existing behavior). If use_fpos is false, it uses
the pos in the context structure.

This change is required to support getdents in io_uring.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/exportfs/expfs.c    |  2 +-
 fs/nfsd/nfs4recover.c  |  2 +-
 fs/nfsd/vfs.c          |  2 +-
 fs/overlayfs/readdir.c |  6 +++---
 fs/readdir.c           | 28 ++++++++++++++++++++--------
 include/linux/fs.h     |  2 +-
 6 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 0106eba46d5a..0f303356f907 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -323,7 +323,7 @@ static int get_name(const struct path *path, char *na=
me, struct dentry *child)
 	while (1) {
 		int old_seq =3D buffer.sequence;
=20
-		error =3D iterate_dir(file, &buffer.ctx);
+		error =3D iterate_dir(file, &buffer.ctx, true);
 		if (buffer.found) {
 			error =3D 0;
 			break;
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 6fedc49726bf..013b1a3530c9 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -307,7 +307,7 @@ nfsd4_list_rec_dir(recdir_func *f, struct nfsd_net *n=
n)
 		return status;
 	}
=20
-	status =3D iterate_dir(nn->rec_file, &ctx.ctx);
+	status =3D iterate_dir(nn->rec_file, &ctx.ctx, true);
 	inode_lock_nested(d_inode(dir), I_MUTEX_PARENT);
=20
 	list_for_each_entry_safe(entry, tmp, &ctx.names, list) {
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index c99857689e2c..cd7a7d783fa7 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1980,7 +1980,7 @@ static __be32 nfsd_buffered_readdir(struct file *fi=
le, struct svc_fh *fhp,
 		buf.used =3D 0;
 		buf.full =3D 0;
=20
-		host_err =3D iterate_dir(file, &buf.ctx);
+		host_err =3D iterate_dir(file, &buf.ctx, true);
 		if (buf.full)
 			host_err =3D 0;
=20
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 150fdf3bc68d..089150315942 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -306,7 +306,7 @@ static inline int ovl_dir_read(struct path *realpath,
 	do {
 		rdd->count =3D 0;
 		rdd->err =3D 0;
-		err =3D iterate_dir(realfile, &rdd->ctx);
+		err =3D iterate_dir(realfile, &rdd->ctx, true);
 		if (err >=3D 0)
 			err =3D rdd->err;
 	} while (!err && rdd->count);
@@ -722,7 +722,7 @@ static int ovl_iterate_real(struct file *file, struct=
 dir_context *ctx)
 			return PTR_ERR(rdt.cache);
 	}
=20
-	err =3D iterate_dir(od->realfile, &rdt.ctx);
+	err =3D iterate_dir(od->realfile, &rdt.ctx, true);
 	ctx->pos =3D rdt.ctx.pos;
=20
 	return err;
@@ -753,7 +753,7 @@ static int ovl_iterate(struct file *file, struct dir_=
context *ctx)
 		      OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent))))) {
 			err =3D ovl_iterate_real(file, ctx);
 		} else {
-			err =3D iterate_dir(od->realfile, ctx);
+			err =3D iterate_dir(od->realfile, ctx, true);
 		}
 		goto out;
 	}
diff --git a/fs/readdir.c b/fs/readdir.c
index 09e8ed7d4161..8ea5b5f45a78 100644
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
@@ -36,8 +37,14 @@
 	unsafe_copy_to_user(dst, src, len, label);		\
 } while (0)
=20
-
-int iterate_dir(struct file *file, struct dir_context *ctx)
+/**
+ * iterate_dir - iterate over directory
+ * @file    : pointer to file struct of directory
+ * @ctx     : pointer to directory ctx structure
+ * @use_fpos: true : use file offset
+ *            false: use pos in ctx structure
+ */
+int iterate_dir(struct file *file, struct dir_context *ctx, bool use_fpo=
s)
 {
 	struct inode *inode =3D file_inode(file);
 	bool shared =3D false;
@@ -60,12 +67,17 @@ int iterate_dir(struct file *file, struct dir_context=
 *ctx)
=20
 	res =3D -ENOENT;
 	if (!IS_DEADDIR(inode)) {
-		ctx->pos =3D file->f_pos;
+		if (use_fpos)
+			ctx->pos =3D file->f_pos;
+
 		if (shared)
 			res =3D file->f_op->iterate_shared(file, ctx);
 		else
 			res =3D file->f_op->iterate(file, ctx);
-		file->f_pos =3D ctx->pos;
+
+		if (use_fpos)
+			file->f_pos =3D ctx->pos;
+
 		fsnotify_access(file);
 		file_accessed(file);
 	}
@@ -190,7 +202,7 @@ SYSCALL_DEFINE3(old_readdir, unsigned int, fd,
 	if (!f.file)
 		return -EBADF;
=20
-	error =3D iterate_dir(f.file, &buf.ctx);
+	error =3D iterate_dir(f.file, &buf.ctx, true);
 	if (buf.result)
 		error =3D buf.result;
=20
@@ -283,7 +295,7 @@ SYSCALL_DEFINE3(getdents, unsigned int, fd,
 	if (!f.file)
 		return -EBADF;
=20
-	error =3D iterate_dir(f.file, &buf.ctx);
+	error =3D iterate_dir(f.file, &buf.ctx, true);
 	if (error >=3D 0)
 		error =3D buf.error;
 	if (buf.prev_reclen) {
@@ -448,7 +460,7 @@ COMPAT_SYSCALL_DEFINE3(old_readdir, unsigned int, fd,
 	if (!f.file)
 		return -EBADF;
=20
-	error =3D iterate_dir(f.file, &buf.ctx);
+	error =3D iterate_dir(f.file, &buf.ctx, true);
 	if (buf.result)
 		error =3D buf.result;
=20
@@ -534,7 +546,7 @@ COMPAT_SYSCALL_DEFINE3(getdents, unsigned int, fd,
 	if (!f.file)
 		return -EBADF;
=20
-	error =3D iterate_dir(f.file, &buf.ctx);
+	error =3D iterate_dir(f.file, &buf.ctx, true);
 	if (error >=3D 0)
 		error =3D buf.error;
 	if (buf.prev_reclen) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1cb616fc1105..ba4f49c4ac41 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3343,7 +3343,7 @@ const char *simple_get_link(struct dentry *, struct=
 inode *,
 			    struct delayed_call *);
 extern const struct inode_operations simple_symlink_inode_operations;
=20
-extern int iterate_dir(struct file *, struct dir_context *);
+extern int iterate_dir(struct file *file, struct dir_context *ctx, bool =
use_fpos);
=20
 int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat=
,
 		int flags);
--=20
2.30.2

