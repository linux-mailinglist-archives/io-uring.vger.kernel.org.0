Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3D94816AE
	for <lists+io-uring@lfdr.de>; Wed, 29 Dec 2021 21:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhL2Ucv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Dec 2021 15:32:51 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5676 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231773AbhL2Ucs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Dec 2021 15:32:48 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BTHDvBl019782
        for <io-uring@vger.kernel.org>; Wed, 29 Dec 2021 12:32:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Fe4Bl/guYsrziQF+/f1hwBwURZ0w+FJsaDv1L7ooL6U=;
 b=LLFoeczhNzXL+T6kSmKxG8pq/nTtTCXHd/31zg0C0r0AQynttkurjfy3MWvpuXbxbIW5
 TrSF73nTf+uQEZnD2auPPLCRSXa953XDUkEB6S+8tfX2oeiSkjEb2x5KLNxx9S7AVT+F
 K0i8brQvmB1BQs8FDwwPrK4ZPKiH52BK2T8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d883eet63-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 29 Dec 2021 12:32:48 -0800
Received: from twshared21922.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 29 Dec 2021 12:32:42 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 808878C20DF8; Wed, 29 Dec 2021 12:30:04 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <torvalds@linux-foundation.org>, <christian.brauner@ubuntu.com>,
        <shr@fb.com>
Subject: [PATCH v10 4/5] io_uring: add fsetxattr and setxattr support
Date:   Wed, 29 Dec 2021 12:30:01 -0800
Message-ID: <20211229203002.4110839-5-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211229203002.4110839-1-shr@fb.com>
References: <20211229203002.4110839-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: PXqaKz3HqfWaQJNaD47KnUQaD5V5xZnv
X-Proofpoint-GUID: PXqaKz3HqfWaQJNaD47KnUQaD5V5xZnv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-29_06,2021-12-29_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 mlxscore=0 priorityscore=1501 adultscore=0 clxscore=1015 suspectscore=0
 malwarescore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112290111
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support to io_uring for the fsetxattr and setxattr API.

Signed-off-by: Stefan Roesch <shr@fb.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/io_uring.c                 | 164 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |   6 +-
 2 files changed, 169 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c8258c784116..f1b325dd81d5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -82,6 +82,7 @@
 #include <linux/audit.h>
 #include <linux/security.h>
 #include <linux/atomic-ref.h>
+#include <linux/xattr.h>
=20
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -726,6 +727,12 @@ struct io_async_rw {
 	struct wait_page_queue		wpq;
 };
=20
+struct io_xattr {
+	struct file			*file;
+	struct xattr_ctx		ctx;
+	struct filename			*filename;
+};
+
 enum {
 	REQ_F_FIXED_FILE_BIT	=3D IOSQE_FIXED_FILE_BIT,
 	REQ_F_IO_DRAIN_BIT	=3D IOSQE_IO_DRAIN_BIT,
@@ -866,6 +873,7 @@ struct io_kiocb {
 		struct io_symlink	symlink;
 		struct io_hardlink	hardlink;
 		struct io_getdents	getdents;
+		struct io_xattr		xattr;
 	};
=20
 	u8				opcode;
@@ -1118,6 +1126,10 @@ static const struct io_op_def io_op_defs[] =3D {
 	[IORING_OP_GETDENTS] =3D {
 		.needs_file		=3D 1,
 	},
+	[IORING_OP_FSETXATTR] =3D {
+		.needs_file =3D 1
+	},
+	[IORING_OP_SETXATTR] =3D {},
 };
=20
 /* requests with any of those set should undergo io_disarm_next() */
@@ -3887,6 +3899,139 @@ static int io_renameat(struct io_kiocb *req, unsi=
gned int issue_flags)
 	return 0;
 }
=20
+static int __io_setxattr_prep(struct io_kiocb *req,
+			const struct io_uring_sqe *sqe)
+{
+	struct io_xattr *ix =3D &req->xattr;
+	const char __user *name;
+	int ret;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (unlikely(sqe->ioprio))
+		return -EINVAL;
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
+	ix->filename =3D NULL;
+	name =3D u64_to_user_ptr(READ_ONCE(sqe->addr));
+	ix->ctx.value =3D u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	ix->ctx.kvalue =3D NULL;
+	ix->ctx.size =3D READ_ONCE(sqe->len);
+	ix->ctx.flags =3D READ_ONCE(sqe->xattr_flags);
+
+	ix->ctx.kname =3D kmalloc(sizeof(*ix->ctx.kname), GFP_KERNEL);
+	if (!ix->ctx.kname)
+		return -ENOMEM;
+
+	ret =3D setxattr_copy(name, &ix->ctx);
+	if (ret) {
+		kfree(ix->ctx.kname);
+		return ret;
+	}
+
+	req->flags |=3D REQ_F_NEED_CLEANUP;
+	return 0;
+}
+
+static int io_setxattr_prep(struct io_kiocb *req,
+			const struct io_uring_sqe *sqe)
+{
+	struct io_xattr *ix =3D &req->xattr;
+	const char __user *path;
+	int ret;
+
+	ret =3D __io_setxattr_prep(req, sqe);
+	if (ret)
+		return ret;
+
+	path =3D u64_to_user_ptr(READ_ONCE(sqe->addr3));
+
+	ix->filename =3D getname_flags(path, LOOKUP_FOLLOW, NULL);
+	if (IS_ERR(ix->filename)) {
+		ret =3D PTR_ERR(ix->filename);
+		ix->filename =3D NULL;
+	}
+
+	return ret;
+}
+
+static int io_fsetxattr_prep(struct io_kiocb *req,
+			const struct io_uring_sqe *sqe)
+{
+	return __io_setxattr_prep(req, sqe);
+}
+
+static int __io_setxattr(struct io_kiocb *req, unsigned int issue_flags,
+			struct path *path)
+{
+	struct io_xattr *ix =3D &req->xattr;
+	int ret;
+
+	ret =3D mnt_want_write(path->mnt);
+	if (!ret) {
+		ret =3D do_setxattr(mnt_user_ns(path->mnt), path->dentry, &ix->ctx);
+		mnt_drop_write(path->mnt);
+	}
+
+	return ret;
+}
+
+static void __io_setxattr_finish(struct io_kiocb *req, int ret)
+{
+	struct xattr_ctx *ctx =3D &req->xattr.ctx;
+
+	req->flags &=3D ~REQ_F_NEED_CLEANUP;
+
+	kfree(ctx->kname);
+	if (ctx->kvalue)
+		kvfree(ctx->kvalue);
+
+	if (ret < 0)
+		req_set_fail(req);
+
+	io_req_complete(req, ret);
+}
+
+static int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
+{
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	ret =3D __io_setxattr(req, issue_flags, &req->file->f_path);
+	__io_setxattr_finish(req, ret);
+
+	return 0;
+}
+
+static int io_setxattr(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_xattr *ix =3D &req->xattr;
+	unsigned int lookup_flags =3D LOOKUP_FOLLOW;
+	struct path path;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+retry:
+	ret =3D do_user_path_at_empty(AT_FDCWD, ix->filename, lookup_flags, &pa=
th);
+	if (!ret) {
+		ret =3D __io_setxattr(req, issue_flags, &path);
+		path_put(&path);
+		if (retry_estale(ret, lookup_flags)) {
+			lookup_flags |=3D LOOKUP_REVAL;
+			goto retry;
+		}
+	}
+	putname(ix->filename);
+
+	__io_setxattr_finish(req, ret);
+	return 0;
+}
+
 static int io_unlinkat_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -6623,6 +6768,10 @@ static int io_req_prep(struct io_kiocb *req, const=
 struct io_uring_sqe *sqe)
 		return io_linkat_prep(req, sqe);
 	case IORING_OP_GETDENTS:
 		return io_getdents_prep(req, sqe);
+	case IORING_OP_FSETXATTR:
+		return io_fsetxattr_prep(req, sqe);
+	case IORING_OP_SETXATTR:
+		return io_setxattr_prep(req, sqe);
 	}
=20
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6764,6 +6913,14 @@ static void io_clean_op(struct io_kiocb *req)
 			putname(req->hardlink.oldpath);
 			putname(req->hardlink.newpath);
 			break;
+		case IORING_OP_SETXATTR:
+			if (req->xattr.filename)
+				putname(req->xattr.filename);
+			fallthrough;
+		case IORING_OP_FSETXATTR:
+			kfree(req->xattr.ctx.kname);
+			kvfree(req->xattr.ctx.kvalue);
+			break;
 		}
 	}
 	if ((req->flags & REQ_F_POLLED) && req->apoll) {
@@ -6909,6 +7066,12 @@ static int io_issue_sqe(struct io_kiocb *req, unsi=
gned int issue_flags)
 	case IORING_OP_GETDENTS:
 		ret =3D io_getdents(req, issue_flags);
 		break;
+	case IORING_OP_FSETXATTR:
+		ret =3D io_fsetxattr(req, issue_flags);
+		break;
+	case IORING_OP_SETXATTR:
+		ret =3D io_setxattr(req, issue_flags);
+		break;
 	default:
 		ret =3D -EINVAL;
 		break;
@@ -11277,6 +11440,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
+	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
=20
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=3D
 		     sizeof(struct io_uring_rsrc_update));
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 57dc88db5793..c62a8bec8cd4 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -45,6 +45,7 @@ struct io_uring_sqe {
 		__u32		rename_flags;
 		__u32		unlink_flags;
 		__u32		hardlink_flags;
+		__u32		xattr_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -60,7 +61,8 @@ struct io_uring_sqe {
 		__s32	splice_fd_in;
 		__u32	file_index;
 	};
-	__u64	__pad2[2];
+	__u64	addr3;
+	__u64	__pad2[1];
 };
=20
 enum {
@@ -144,6 +146,8 @@ enum {
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
 	IORING_OP_GETDENTS,
+	IORING_OP_FSETXATTR,
+	IORING_OP_SETXATTR,
=20
 	/* this goes last, obviously */
 	IORING_OP_LAST,
--=20
2.30.2

