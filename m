Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA31447C3F6
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 17:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239933AbhLUQkQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Dec 2021 11:40:16 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42366 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236558AbhLUQkQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Dec 2021 11:40:16 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BL3eClq012473
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 08:40:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=v6H7J6W/w1VbLShf2yyGkjgJa1r6SwYUwh/CcB64iEg=;
 b=Gn4lGpo/ANbrEuZf7NMpjCs9HrPCRj+lS73LeQud+Hnt9QMqAHepzSa9dWwUuvTe7CHQ
 mq59LAYdwfaJ3sYCfQLoADl9PlfHakvvJDT8JaNsXjDzarWGixygfdCSeQlUfH21HjoP
 8xPomko5re0Qv0JWDNe1oCHCwiAE1SMgyZc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d377gcd26-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 21 Dec 2021 08:40:15 -0800
Received: from twshared4941.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 08:40:14 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id A770E85BEA68; Tue, 21 Dec 2021 08:40:07 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <torvalds@linux-foundation.org>, <shr@fb.com>
Subject: [PATCH v7 1/3] fs: add offset parameter to iterate_dir function
Date:   Tue, 21 Dec 2021 08:40:02 -0800
Message-ID: <20211221164004.119663-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211221164004.119663-1-shr@fb.com>
References: <20211221164004.119663-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: BrCbbXrZSmA9uOAFr278W2H50jBI70Hz
X-Proofpoint-GUID: BrCbbXrZSmA9uOAFr278W2H50jBI70Hz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-21_04,2021-12-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 adultscore=0
 mlxlogscore=911 spamscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112210082
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This change adds the offset parameter to the iterate_dir
function. The offset paramater allows the caller to specify
the offset position.

This change is required to support getdents in io_uring.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 arch/alpha/kernel/osf_sys.c |  2 +-
 fs/ecryptfs/file.c          |  2 +-
 fs/exportfs/expfs.c         |  2 +-
 fs/ksmbd/smb2pdu.c          |  3 ++-
 fs/ksmbd/vfs.c              |  4 ++--
 fs/nfsd/nfs4recover.c       |  2 +-
 fs/nfsd/vfs.c               |  2 +-
 fs/overlayfs/readdir.c      |  6 +++---
 fs/readdir.c                | 28 ++++++++++++++++++----------
 include/linux/fs.h          |  2 +-
 10 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 8bbeebb73cf0..cf68c459bca6 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -162,7 +162,7 @@ SYSCALL_DEFINE4(osf_getdirentries, unsigned int, fd,
 	if (!arg.file)
 		return -EBADF;
=20
-	error =3D iterate_dir(arg.file, &buf.ctx);
+	error =3D iterate_dir(arg.file, &buf.ctx, &arg.file->f_pos);
 	if (error >=3D 0)
 		error =3D buf.error;
 	if (count !=3D buf.count)
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 18d5b91cb573..b68f1945e615 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -109,7 +109,7 @@ static int ecryptfs_readdir(struct file *file, struct=
 dir_context *ctx)
 		.sb =3D inode->i_sb,
 	};
 	lower_file =3D ecryptfs_file_to_lower(file);
-	rc =3D iterate_dir(lower_file, &buf.ctx);
+	rc =3D iterate_dir(lower_file, &buf.ctx, &lower_file->f_pos);
 	ctx->pos =3D buf.ctx.pos;
 	if (rc < 0)
 		goto out;
diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 0106eba46d5a..654e2d4b1d4f 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -323,7 +323,7 @@ static int get_name(const struct path *path, char *na=
me, struct dentry *child)
 	while (1) {
 		int old_seq =3D buffer.sequence;
=20
-		error =3D iterate_dir(file, &buffer.ctx);
+		error =3D iterate_dir(file, &buffer.ctx, &file->f_pos);
 		if (buffer.found) {
 			error =3D 0;
 			break;
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 49c9da37315c..fd4cb995d06d 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -3925,7 +3925,8 @@ int smb2_query_dir(struct ksmbd_work *work)
 	dir_fp->readdir_data.private		=3D &query_dir_private;
 	set_ctx_actor(&dir_fp->readdir_data.ctx, __query_dir);
=20
-	rc =3D iterate_dir(dir_fp->filp, &dir_fp->readdir_data.ctx);
+	rc =3D iterate_dir(dir_fp->filp, &dir_fp->readdir_data.ctx,
+			&dir_fp->filp->f_pos);
 	if (rc =3D=3D 0)
 		restart_ctx(&dir_fp->readdir_data.ctx);
 	if (rc =3D=3D -ENOSPC)
diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index 19d36393974c..5b8e23d3c846 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1136,7 +1136,7 @@ int ksmbd_vfs_empty_dir(struct ksmbd_file *fp)
 	set_ctx_actor(&readdir_data.ctx, __dir_empty);
 	readdir_data.dirent_count =3D 0;
=20
-	err =3D iterate_dir(fp->filp, &readdir_data.ctx);
+	err =3D iterate_dir(fp->filp, &readdir_data.ctx, &fp->filp->f_pos);
 	if (readdir_data.dirent_count > 2)
 		err =3D -ENOTEMPTY;
 	else
@@ -1186,7 +1186,7 @@ static int ksmbd_vfs_lookup_in_dir(struct path *dir=
, char *name, size_t namelen)
 	if (IS_ERR(dfilp))
 		return PTR_ERR(dfilp);
=20
-	ret =3D iterate_dir(dfilp, &readdir_data.ctx);
+	ret =3D iterate_dir(dfilp, &readdir_data.ctx, &dfilp->f_pos);
 	if (readdir_data.dirent_count > 0)
 		ret =3D 0;
 	fput(dfilp);
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index 6fedc49726bf..79a2799891e4 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -307,7 +307,7 @@ nfsd4_list_rec_dir(recdir_func *f, struct nfsd_net *n=
n)
 		return status;
 	}
=20
-	status =3D iterate_dir(nn->rec_file, &ctx.ctx);
+	status =3D iterate_dir(nn->rec_file, &ctx.ctx, &nn->rec_file->f_pos);
 	inode_lock_nested(d_inode(dir), I_MUTEX_PARENT);
=20
 	list_for_each_entry_safe(entry, tmp, &ctx.names, list) {
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index c99857689e2c..085864c25318 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1980,7 +1980,7 @@ static __be32 nfsd_buffered_readdir(struct file *fi=
le, struct svc_fh *fhp,
 		buf.used =3D 0;
 		buf.full =3D 0;
=20
-		host_err =3D iterate_dir(file, &buf.ctx);
+		host_err =3D iterate_dir(file, &buf.ctx, &file->f_pos);
 		if (buf.full)
 			host_err =3D 0;
=20
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 150fdf3bc68d..52167ff9e513 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -306,7 +306,7 @@ static inline int ovl_dir_read(struct path *realpath,
 	do {
 		rdd->count =3D 0;
 		rdd->err =3D 0;
-		err =3D iterate_dir(realfile, &rdd->ctx);
+		err =3D iterate_dir(realfile, &rdd->ctx, &realfile->f_pos);
 		if (err >=3D 0)
 			err =3D rdd->err;
 	} while (!err && rdd->count);
@@ -722,7 +722,7 @@ static int ovl_iterate_real(struct file *file, struct=
 dir_context *ctx)
 			return PTR_ERR(rdt.cache);
 	}
=20
-	err =3D iterate_dir(od->realfile, &rdt.ctx);
+	err =3D iterate_dir(od->realfile, &rdt.ctx, &od->realfile->f_pos);
 	ctx->pos =3D rdt.ctx.pos;
=20
 	return err;
@@ -753,7 +753,7 @@ static int ovl_iterate(struct file *file, struct dir_=
context *ctx)
 		      OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent))))) {
 			err =3D ovl_iterate_real(file, ctx);
 		} else {
-			err =3D iterate_dir(od->realfile, ctx);
+			err =3D iterate_dir(od->realfile, ctx, &od->realfile->f_pos);
 		}
 		goto out;
 	}
diff --git a/fs/readdir.c b/fs/readdir.c
index 09e8ed7d4161..c1e6612e0f47 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -36,8 +36,13 @@
 	unsafe_copy_to_user(dst, src, len, label);		\
 } while (0)
=20
-
-int iterate_dir(struct file *file, struct dir_context *ctx)
+/**
+ * iterate_dir - iterate over directory
+ * @file    : pointer to file struct of directory
+ * @ctx     : pointer to directory ctx structure
+ * @pos     : file offset
+ */
+int iterate_dir(struct file *file, struct dir_context *ctx, loff_t *pos)
 {
 	struct inode *inode =3D file_inode(file);
 	bool shared =3D false;
@@ -60,12 +65,15 @@ int iterate_dir(struct file *file, struct dir_context=
 *ctx)
=20
 	res =3D -ENOENT;
 	if (!IS_DEADDIR(inode)) {
-		ctx->pos =3D file->f_pos;
+		ctx->pos =3D *pos;
+
 		if (shared)
 			res =3D file->f_op->iterate_shared(file, ctx);
 		else
 			res =3D file->f_op->iterate(file, ctx);
-		file->f_pos =3D ctx->pos;
+
+		*pos =3D ctx->pos;
+
 		fsnotify_access(file);
 		file_accessed(file);
 	}
@@ -190,7 +198,7 @@ SYSCALL_DEFINE3(old_readdir, unsigned int, fd,
 	if (!f.file)
 		return -EBADF;
=20
-	error =3D iterate_dir(f.file, &buf.ctx);
+	error =3D iterate_dir(f.file, &buf.ctx, &f.file->f_pos);
 	if (buf.result)
 		error =3D buf.result;
=20
@@ -283,7 +291,7 @@ SYSCALL_DEFINE3(getdents, unsigned int, fd,
 	if (!f.file)
 		return -EBADF;
=20
-	error =3D iterate_dir(f.file, &buf.ctx);
+	error =3D iterate_dir(f.file, &buf.ctx, &f.file->f_pos);
 	if (error >=3D 0)
 		error =3D buf.error;
 	if (buf.prev_reclen) {
@@ -366,7 +374,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 	if (!f.file)
 		return -EBADF;
=20
-	error =3D iterate_dir(f.file, &buf.ctx);
+	error =3D iterate_dir(f.file, &buf.ctx, &f.file->f_pos);
 	if (error >=3D 0)
 		error =3D buf.error;
 	if (buf.prev_reclen) {
@@ -379,7 +387,7 @@ SYSCALL_DEFINE3(getdents64, unsigned int, fd,
 		else
 			error =3D count - buf.count;
 	}
-	fdput_pos(f);
+
 	return error;
 }
=20
@@ -448,7 +456,7 @@ COMPAT_SYSCALL_DEFINE3(old_readdir, unsigned int, fd,
 	if (!f.file)
 		return -EBADF;
=20
-	error =3D iterate_dir(f.file, &buf.ctx);
+	error =3D iterate_dir(f.file, &buf.ctx, &f.file->f_pos);
 	if (buf.result)
 		error =3D buf.result;
=20
@@ -534,7 +542,7 @@ COMPAT_SYSCALL_DEFINE3(getdents, unsigned int, fd,
 	if (!f.file)
 		return -EBADF;
=20
-	error =3D iterate_dir(f.file, &buf.ctx);
+	error =3D iterate_dir(f.file, &buf.ctx, &f.file->f_pos);
 	if (error >=3D 0)
 		error =3D buf.error;
 	if (buf.prev_reclen) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6b8dc1a78df6..e1becbe86b07 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3340,7 +3340,7 @@ const char *simple_get_link(struct dentry *, struct=
 inode *,
 			    struct delayed_call *);
 extern const struct inode_operations simple_symlink_inode_operations;
=20
-extern int iterate_dir(struct file *, struct dir_context *);
+extern int iterate_dir(struct file *, struct dir_context *, loff_t *pos)=
;
=20
 int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat=
,
 		int flags);
--=20
2.30.2

