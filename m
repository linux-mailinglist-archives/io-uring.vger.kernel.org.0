Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A8347E9C4
	for <lists+io-uring@lfdr.de>; Fri, 24 Dec 2021 00:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245307AbhLWXyX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 18:54:23 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1336 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245240AbhLWXyX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 18:54:23 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BNN9Z5C011625
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 15:54:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=JV0m7Qz6NKJtpZHdTnyqaZhhPTc/Oo/IvkTholVOMUg=;
 b=a/vawYJWm7XwadBHgygiCTgyBy5c97+MJTRutUrfCC4/TPatjVfBcP68ARmHMIaX/was
 CFdqz4Emzcl4BNKaZ3ACaExEAabFC7Vw8gaSZAu9EQDridl2YrawqObUVTXtyTzVgJxm
 isu8JFdjpQEvhZGhmiY1/bSx7QJUlKItUXQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d52hn85mg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 15:54:22 -0800
Received: from twshared7500.02.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 15:54:21 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 8969B87DF615; Thu, 23 Dec 2021 15:51:55 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <torvalds@linux-foundation.org>, <christian.brauner@ubuntu.com>,
        <shr@fb.com>
Subject: [PATCH v8 5/5] io_uring: add fgetxattr and getxattr support
Date:   Thu, 23 Dec 2021 15:51:23 -0800
Message-ID: <20211223235123.4092764-6-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211223235123.4092764-1-shr@fb.com>
References: <20211223235123.4092764-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: TlLtHTOuZ4XvwCaFspEFeBf7iHnncI2T
X-Proofpoint-ORIG-GUID: TlLtHTOuZ4XvwCaFspEFeBf7iHnncI2T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-23_04,2021-12-22_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 suspectscore=0 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501
 spamscore=0 mlxscore=0 impostorscore=0 mlxlogscore=705 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112230122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support to io_uring for the fgetxattr and getxattr API.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/io_uring.c                 | 149 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |   2 +
 2 files changed, 151 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 114af3de2120..35414b7159d3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1131,6 +1131,10 @@ static const struct io_op_def io_op_defs[] =3D {
 		.needs_file =3D 1
 	},
 	[IORING_OP_SETXATTR] =3D {},
+	[IORING_OP_FGETXATTR] =3D {
+		.needs_file =3D 1
+	},
+	[IORING_OP_GETXATTR] =3D {},
 };
=20
 /* requests with any of those set should undergo io_disarm_next() */
@@ -3900,6 +3904,134 @@ static int io_renameat(struct io_kiocb *req, unsi=
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
+	ix->ctx.kname =3D kmalloc(sizeof(*ix->ctx.kname), GFP_KERNEL);
+	if (!ix->ctx.kname)
+		return -ENOMEM;
+
+	ret =3D strncpy_from_user(ix->ctx.kname->name, name,
+				sizeof(ix->ctx.kname->name));
+	if (!ret || ret =3D=3D sizeof(ix->ctx.kname->name))
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
+			ix->ctx.kname->name,
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
+	if (!ret) {
+		ret =3D do_getxattr(mnt_user_ns(path.mnt),
+				path.dentry,
+				ix->ctx.kname->name,
+				(void __user *)ix->ctx.value,
+				ix->ctx.size);
+
+		path_put(&path);
+		if (retry_estale(ret, lookup_flags)) {
+			lookup_flags |=3D LOOKUP_REVAL;
+			goto retry;
+		}
+	}
+	putname(ix->filename);
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
 			const struct io_uring_sqe *sqe)
 {
@@ -6774,6 +6906,10 @@ static int io_req_prep(struct io_kiocb *req, const=
 struct io_uring_sqe *sqe)
 		return io_fsetxattr_prep(req, sqe);
 	case IORING_OP_SETXATTR:
 		return io_setxattr_prep(req, sqe);
+	case IORING_OP_FGETXATTR:
+		return io_fgetxattr_prep(req, sqe);
+	case IORING_OP_GETXATTR:
+		return io_getxattr_prep(req, sqe);
 	}
=20
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6923,6 +7059,13 @@ static void io_clean_op(struct io_kiocb *req)
 			kfree(req->xattr.ctx.kname);
 			kvfree(req->xattr.value);
 			break;
+		case IORING_OP_GETXATTR:
+			if (req->xattr.filename)
+				putname(req->xattr.filename);
+			fallthrough;
+		case IORING_OP_FGETXATTR:
+			kfree(req->xattr.ctx.kname);
+			break;
 		}
 	}
 	if ((req->flags & REQ_F_POLLED) && req->apoll) {
@@ -7074,6 +7217,12 @@ static int io_issue_sqe(struct io_kiocb *req, unsi=
gned int issue_flags)
 	case IORING_OP_SETXATTR:
 		ret =3D io_setxattr(req, issue_flags);
 		break;
+	case IORING_OP_FGETXATTR:
+		ret =3D io_fgetxattr(req, issue_flags);
+		break;
+	case IORING_OP_GETXATTR:
+		ret =3D io_getxattr(req, issue_flags);
+		break;
 	default:
 		ret =3D -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index c62a8bec8cd4..efc7ac9b3a6b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -148,6 +148,8 @@ enum {
 	IORING_OP_GETDENTS,
 	IORING_OP_FSETXATTR,
 	IORING_OP_SETXATTR,
+	IORING_OP_FGETXATTR,
+	IORING_OP_GETXATTR,
=20
 	/* this goes last, obviously */
 	IORING_OP_LAST,
--=20
2.30.2

