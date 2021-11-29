Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2030946241B
	for <lists+io-uring@lfdr.de>; Mon, 29 Nov 2021 23:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhK2WQ2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Nov 2021 17:16:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61078 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231255AbhK2WQ0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Nov 2021 17:16:26 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ATIlDAF028423
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 14:13:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=MU9kvJnfQ1hfm+fa97pHqAe6I4k6kxvYAS94gGN7+7E=;
 b=VZ8qzWWprnsKapNjyo7xoAdqa49Vvnc/5WsUfh5+cHUpLRJqNYO4oW++n+2Mwg4YMWm2
 JBvLYbaee6pMxb1t635k5EMXk0Ym6CTFDIQuAaojMVmPkFFNzzxdFQpFLH7o8SUKRoIx
 q32G+nKxQgdX65FhXTAju/U+SekVQ3lTnBg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cn1as32gu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 29 Nov 2021 14:13:08 -0800
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 29 Nov 2021 14:13:07 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id A7289710160E; Mon, 29 Nov 2021 14:12:59 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>
Subject: [PATCH v1 5/5] io_uring: add fgetxattr and getxattr support
Date:   Mon, 29 Nov 2021 14:12:57 -0800
Message-ID: <20211129221257.2536146-6-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129221257.2536146-1-shr@fb.com>
References: <20211129221257.2536146-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: NPEhsWt2wOqHo3xiOQpIq8ciol4cjbhm
X-Proofpoint-ORIG-GUID: NPEhsWt2wOqHo3xiOQpIq8ciol4cjbhm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_11,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 phishscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 mlxlogscore=763 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111290105
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Summary:

This adds support to io_uring for the following API's:
- fgetxattr
- getxattr

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/io_uring.c                 | 152 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |   2 +
 2 files changed, 154 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4a18431e13a3..265024204a59 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1114,6 +1114,10 @@ static const struct io_op_def io_op_defs[] =3D {
 	[IORING_OP_MKDIRAT] =3D {},
 	[IORING_OP_SYMLINKAT] =3D {},
 	[IORING_OP_LINKAT] =3D {},
+	[IORING_OP_FGETXATTR] =3D {
+		.needs_file =3D 1
+	},
+	[IORING_OP_GETXATTR] =3D {},
 	[IORING_OP_FSETXATTR] =3D {
 		.needs_file =3D 1
 	},
@@ -3831,6 +3835,135 @@ static int io_renameat(struct io_kiocb *req, unsi=
gned int issue_flags)
 	return 0;
 }
=20
+static int __io_getxattr_prep(struct io_kiocb *req,
+			      const struct io_uring_sqe *sqe)
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
+	ix->value =3D NULL;
+	name =3D u64_to_user_ptr(READ_ONCE(sqe->addr));
+	ix->ctx.value =3D u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	ix->ctx.size =3D READ_ONCE(sqe->len);
+	ix->ctx.flags =3D READ_ONCE(sqe->xattr_flags);
+
+	if (ix->ctx.flags)
+		return -EINVAL;
+
+	ix->ctx.name =3D kmalloc(XATTR_NAME_MAX + 1, GFP_KERNEL);
+	if (!ix->ctx.name)
+		return -ENOMEM;
+
+	ret =3D strncpy_from_user(ix->ctx.name, name, XATTR_NAME_MAX + 1);
+	if (!ret || ret =3D=3D XATTR_NAME_MAX + 1)
+		ret =3D -ERANGE;
+	if (ret < 0) {
+		kfree(ix->ctx.name);
+		return ret;
+	}
+
+	req->flags |=3D REQ_F_NEED_CLEANUP;
+	return 0;
+}
+
+static int io_fgetxattr_prep(struct io_kiocb *req,
+			     const struct io_uring_sqe *sqe)
+{
+	if (!req->file)
+		return -EBADF;
+
+	return __io_getxattr_prep(req, sqe);
+}
+
+static int io_getxattr_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_xattr *ix =3D &req->xattr;
+	const char __user *path;
+	int ret;
+
+	ret =3D __io_getxattr_prep(req, sqe);
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
+static int io_fgetxattr(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_xattr *ix =3D &req->xattr;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	ret =3D do_getxattr(mnt_user_ns(req->file->f_path.mnt),
+			req->file->f_path.dentry,
+			ix->ctx.name,
+			(void __user *)ix->ctx.value,
+			ix->ctx.size);
+
+	req->flags &=3D ~REQ_F_NEED_CLEANUP;
+	kfree(ix->ctx.name);
+	if (ret < 0)
+		req_set_fail(req);
+
+	io_req_complete(req, ret);
+	return 0;
+}
+
+static int io_getxattr(struct io_kiocb *req, unsigned int issue_flags)
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
+	ret =3D user_path_at_empty(AT_FDCWD, ix->filename, lookup_flags, &path)=
;
+	if (!ret) {
+		ret =3D do_getxattr(mnt_user_ns(path.mnt),
+				  path.dentry,
+				  ix->ctx.name,
+				  (void __user *)ix->ctx.value,
+				  ix->ctx.size);
+
+		path_put(&path);
+		if (retry_estale(ret, lookup_flags)) {
+			lookup_flags |=3D LOOKUP_REVAL;
+			goto retry;
+		}
+	}
+
+	req->flags &=3D ~REQ_F_NEED_CLEANUP;
+	kfree(ix->ctx.name);
+	if (ret < 0)
+		req_set_fail(req);
+
+	io_req_complete(req, ret);
+	return 0;
+}
+
 static int __io_setxattr_prep(struct io_kiocb *req,
 			const struct io_uring_sqe *sqe,
 			struct user_namespace *user_ns)
@@ -6684,6 +6817,10 @@ static int io_req_prep(struct io_kiocb *req, const=
 struct io_uring_sqe *sqe)
 		return io_symlinkat_prep(req, sqe);
 	case IORING_OP_LINKAT:
 		return io_linkat_prep(req, sqe);
+	case IORING_OP_FGETXATTR:
+		return io_fgetxattr_prep(req, sqe);
+	case IORING_OP_GETXATTR:
+		return io_getxattr_prep(req, sqe);
 	case IORING_OP_FSETXATTR:
 		return io_fsetxattr_prep(req, sqe);
 	case IORING_OP_SETXATTR:
@@ -6831,6 +6968,15 @@ static void io_clean_op(struct io_kiocb *req)
 			putname(req->hardlink.oldpath);
 			putname(req->hardlink.newpath);
 			break;
+
+		case IORING_OP_GETXATTR:
+			if (req->xattr.filename)
+				putname(req->xattr.filename);
+			fallthrough;
+		case IORING_OP_FGETXATTR:
+			kfree(req->xattr.ctx.name);
+			break;
+
 		case IORING_OP_SETXATTR:
 			if (req->xattr.filename)
 				putname(req->xattr.filename);
@@ -6982,6 +7128,12 @@ static int io_issue_sqe(struct io_kiocb *req, unsi=
gned int issue_flags)
 	case IORING_OP_LINKAT:
 		ret =3D io_linkat(req, issue_flags);
 		break;
+	case IORING_OP_FGETXATTR:
+		ret =3D io_fgetxattr(req, issue_flags);
+		break;
+	case IORING_OP_GETXATTR:
+		ret =3D io_getxattr(req, issue_flags);
+		break;
 	case IORING_OP_FSETXATTR:
 		ret =3D io_fsetxattr(req, issue_flags);
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index dbf473900da2..cd9160272308 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -145,7 +145,9 @@ enum {
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
+	IORING_OP_FGETXATTR,
 	IORING_OP_FSETXATTR,
+	IORING_OP_GETXATTR,
 	IORING_OP_SETXATTR,
=20
 	/* this goes last, obviously */
--=20
2.30.2

