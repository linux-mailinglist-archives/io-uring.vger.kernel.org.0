Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A6D4E5592
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 16:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244773AbiCWPqJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 11:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243898AbiCWPqE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 11:46:04 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30803BBDA
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:44:34 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22NDenXn017075
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:44:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=9m+9AJdyLmZbVuqJluL+bc/Zq21nF0BEFjp9BqKXTN8=;
 b=cYw863xw6yxOpbeEnDCr4MVV00xVLTIW9fe6J7r/h3Nx3CRSrwNKrHJ3fVDpqJzvteDp
 sO0St5Mm29U+SQPnWr++WEKFa2Sz3lbfFNp+nbKXmAEF4R7CQ2ZKt1EBA1Uc5U44lMJX
 jKMiO1X08nO4yFBQoA8bu1k+BXxFTW9vYJg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eyc9wu3gk-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:44:34 -0700
Received: from twshared21672.25.frc3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 23 Mar 2022 08:44:32 -0700
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 8AABFCA024C9; Wed, 23 Mar 2022 08:44:22 -0700 (PDT)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <viro@zeniv.linux.org.uk>, <christian.brauner@ubuntu.com>,
        <shr@fb.com>
Subject: [PATCH v13 3/4] io_uring: add fsetxattr and setxattr support
Date:   Wed, 23 Mar 2022 08:44:19 -0700
Message-ID: <20220323154420.3301504-4-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220323154420.3301504-1-shr@fb.com>
References: <20220323154420.3301504-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: XWgfOKaBY7LgB-63FiHT2qlubWfsCTqQ
X-Proofpoint-ORIG-GUID: XWgfOKaBY7LgB-63FiHT2qlubWfsCTqQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-23_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support to io_uring for the fsetxattr and setxattr API.

Signed-off-by: Stefan Roesch <shr@fb.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 fs/io_uring.c                 | 165 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |   6 +-
 2 files changed, 170 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 496a2af7d12c..d71073be91c2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -82,6 +82,7 @@
 #include <linux/tracehook.h>
 #include <linux/audit.h>
 #include <linux/security.h>
+#include <linux/xattr.h>
=20
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -755,6 +756,12 @@ struct io_async_rw {
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
@@ -901,6 +908,7 @@ struct io_kiocb {
 		struct io_symlink	symlink;
 		struct io_hardlink	hardlink;
 		struct io_msg		msg;
+		struct io_xattr		xattr;
 	};
=20
 	u8				opcode;
@@ -1154,6 +1162,10 @@ static const struct io_op_def io_op_defs[] =3D {
 	[IORING_OP_MSG_RING] =3D {
 		.needs_file		=3D 1,
 	},
+	[IORING_OP_FSETXATTR] =3D {
+		.needs_file =3D 1
+	},
+	[IORING_OP_SETXATTR] =3D {},
 };
=20
 /* requests with any of those set should undergo io_disarm_next() */
@@ -4094,6 +4106,144 @@ static int io_renameat(struct io_kiocb *req, unsi=
gned int issue_flags)
 	return 0;
 }
=20
+static inline void __io_xattr_finish(struct io_kiocb *req)
+{
+	struct io_xattr *ix =3D &req->xattr;
+
+	if (ix->filename)
+		putname(ix->filename);
+
+	kfree(ix->ctx.kname);
+	kvfree(ix->ctx.kvalue);
+}
+
+static void io_xattr_finish(struct io_kiocb *req, int ret)
+{
+	req->flags &=3D ~REQ_F_NEED_CLEANUP;
+
+	__io_xattr_finish(req);
+	if (ret < 0)
+		req_set_fail(req);
+
+	io_req_complete(req, ret);
+}
+
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
+	ix->ctx.cvalue =3D u64_to_user_ptr(READ_ONCE(sqe->addr2));
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
+static int io_fsetxattr(struct io_kiocb *req, unsigned int issue_flags)
+{
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	ret =3D __io_setxattr(req, issue_flags, &req->file->f_path);
+	io_xattr_finish(req, ret);
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
+	ret =3D filename_lookup(AT_FDCWD, ix->filename, lookup_flags, &path, NU=
LL);
+	if (!ret) {
+		ret =3D __io_setxattr(req, issue_flags, &path);
+		path_put(&path);
+		if (retry_estale(ret, lookup_flags)) {
+			lookup_flags |=3D LOOKUP_REVAL;
+			goto retry;
+		}
+	}
+
+	io_xattr_finish(req, ret);
+	return 0;
+}
+
 static int io_unlinkat_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -6985,6 +7135,10 @@ static int io_req_prep(struct io_kiocb *req, const=
 struct io_uring_sqe *sqe)
 		return io_linkat_prep(req, sqe);
 	case IORING_OP_MSG_RING:
 		return io_msg_ring_prep(req, sqe);
+	case IORING_OP_FSETXATTR:
+		return io_fsetxattr_prep(req, sqe);
+	case IORING_OP_SETXATTR:
+		return io_setxattr_prep(req, sqe);
 	}
=20
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -7130,6 +7284,10 @@ static void io_clean_op(struct io_kiocb *req)
 			if (req->statx.filename)
 				putname(req->statx.filename);
 			break;
+		case IORING_OP_SETXATTR:
+		case IORING_OP_FSETXATTR:
+			__io_xattr_finish(req);
+			break;
 		}
 	}
 	if ((req->flags & REQ_F_POLLED) && req->apoll) {
@@ -7275,6 +7433,12 @@ static int io_issue_sqe(struct io_kiocb *req, unsi=
gned int issue_flags)
 	case IORING_OP_MSG_RING:
 		ret =3D io_msg_ring(req, issue_flags);
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
@@ -11927,6 +12091,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
 	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
+	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
=20
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=3D
 		     sizeof(struct io_uring_rsrc_update));
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index d2be4eb22008..68d003d49f14 100644
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
@@ -145,6 +147,8 @@ enum {
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
 	IORING_OP_MSG_RING,
+	IORING_OP_FSETXATTR,
+	IORING_OP_SETXATTR,
=20
 	/* this goes last, obviously */
 	IORING_OP_LAST,
--=20
2.30.2

