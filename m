Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F1C4646EB
	for <lists+io-uring@lfdr.de>; Wed,  1 Dec 2021 06:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346867AbhLAFzb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Dec 2021 00:55:31 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18606 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346838AbhLAFzW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Dec 2021 00:55:22 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B10XHvg029571
        for <io-uring@vger.kernel.org>; Tue, 30 Nov 2021 21:52:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=9uKO2x7+25CmQzWGTMLpHb3ikl8Ya9gX8x1/o6yiVAU=;
 b=WN3LQ9fXbqR2/NTuzATyyWjHP6ngPeQ3l3ZxBPzeXFb45xZbEtAKrvjgjw2qRaSA3kVx
 XgYoLf/fnQWjeoztaWoIXlePVYAte6XL4bsmmzogRpyPQh/bgG4RVoBRFMFu+V4ozZ8F
 aWPhN49faYlJuscqA2EYXe/b/TgF/vkH1oU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cnuv5tqhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 30 Nov 2021 21:52:01 -0800
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 30 Nov 2021 21:52:00 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 71DBC7227189; Tue, 30 Nov 2021 21:51:46 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <shr@fb.com>
Subject: [PATCH v2 5/5] io_uring: add fgetxattr and getxattr support
Date:   Tue, 30 Nov 2021 21:51:44 -0800
Message-ID: <20211201055144.3141001-6-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211201055144.3141001-1-shr@fb.com>
References: <20211201055144.3141001-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: GIt4iZpXq94tGipq5TKmpxOTqPf9BjSh
X-Proofpoint-ORIG-GUID: GIt4iZpXq94tGipq5TKmpxOTqPf9BjSh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_10,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 impostorscore=0 phishscore=0 mlxscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=742 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112010033
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support to io_uring for the fgetxattr and getxattr API.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/io_uring.c                 | 153 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |   2 +
 2 files changed, 155 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9d977bf243fd..231a021d8eea 100644
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
@@ -3831,6 +3835,136 @@ static int io_renameat(struct io_kiocb *req, unsi=
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
+	ix->ctx.kname =3D kmalloc(XATTR_NAME_MAX + 1, GFP_KERNEL);
+	if (!ix->ctx.kname)
+		return -ENOMEM;
+
+	ret =3D strncpy_from_user(ix->ctx.kname, name, XATTR_NAME_MAX + 1);
+	if (!ret || ret =3D=3D XATTR_NAME_MAX + 1)
+		ret =3D -ERANGE;
+	if (ret < 0) {
+		kfree(ix->ctx.kname);
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
+			ix->ctx.kname,
+			(void __user *)ix->ctx.value,
+			ix->ctx.size);
+
+	req->flags &=3D ~REQ_F_NEED_CLEANUP;
+	kfree(ix->ctx.kname);
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
+	ret =3D do_user_path_at_empty(AT_FDCWD, ix->filename, lookup_flags, &pa=
th);
+	putname(ix->filename);
+	if (!ret) {
+		ret =3D do_getxattr(mnt_user_ns(path.mnt),
+				  path.dentry,
+				  ix->ctx.kname,
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
+	kfree(ix->ctx.kname);
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
@@ -6685,6 +6819,10 @@ static int io_req_prep(struct io_kiocb *req, const=
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
@@ -6832,6 +6970,15 @@ static void io_clean_op(struct io_kiocb *req)
 			putname(req->hardlink.oldpath);
 			putname(req->hardlink.newpath);
 			break;
+
+		case IORING_OP_GETXATTR:
+			if (req->xattr.filename)
+				putname(req->xattr.filename);
+			fallthrough;
+		case IORING_OP_FGETXATTR:
+			kfree(req->xattr.ctx.kname);
+			break;
+
 		case IORING_OP_SETXATTR:
 			if (req->xattr.filename)
 				putname(req->xattr.filename);
@@ -6983,6 +7130,12 @@ static int io_issue_sqe(struct io_kiocb *req, unsi=
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

