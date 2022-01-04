Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8E4484856
	for <lists+io-uring@lfdr.de>; Tue,  4 Jan 2022 20:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbiADTJ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Jan 2022 14:09:56 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42734 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234866AbiADTJz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Jan 2022 14:09:55 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 204GFelw023023
        for <io-uring@vger.kernel.org>; Tue, 4 Jan 2022 11:09:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=NqwQI2FxmLjiA7unCu/qyOUCFDQKyMH5Z2MbJPFWkec=;
 b=NtAXfAdcFkGGDwk+13N/sRASsFARKVcd573Qb5kdf73Ucwh42OxdrJEF3QDY4nkZ0RCv
 C2V4/EpGftnEub4LYMySQD/kBYf5DHbWDrviGduhW5SPmOahTF2mh3qMs7xWENE3TKtb
 ePrHAP11O9zWv4Qg0/B7AXX0XIQuABoXVIM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dcaerddga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 04 Jan 2022 11:09:55 -0800
Received: from twshared0654.04.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 4 Jan 2022 11:09:53 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id C93F98FC8E1F; Tue,  4 Jan 2022 11:09:38 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <torvalds@linux-foundation.org>, <christian.brauner@ubuntu.com>,
        <shr@fb.com>
Subject: [PATCH v11 4/4] io_uring: add fgetxattr and getxattr support
Date:   Tue, 4 Jan 2022 11:09:36 -0800
Message-ID: <20220104190936.3085647-5-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220104190936.3085647-1-shr@fb.com>
References: <20220104190936.3085647-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: wvUQCDzza9aT-f1MwwplwYPTVNYJJHHc
X-Proofpoint-ORIG-GUID: wvUQCDzza9aT-f1MwwplwYPTVNYJJHHc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-04_09,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 mlxlogscore=787 spamscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201040126
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support to io_uring for the fgetxattr and getxattr API.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/io_uring.c                 | 133 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |   2 +
 2 files changed, 135 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2d1eb276a648..a16073e151f4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1130,6 +1130,10 @@ static const struct io_op_def io_op_defs[] =3D {
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
@@ -3921,6 +3925,123 @@ static void io_xattr_finish(struct io_kiocb *req,=
 int ret)
 	io_req_complete(req, ret);
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
+	ix->ctx.kvalue =3D NULL;
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
+	io_xattr_finish(req, ret);
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
+	ret =3D filename_lookup(AT_FDCWD, ix->filename, lookup_flags, &path, NU=
LL);
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
+
+	io_xattr_finish(req, ret);
+	return 0;
+}
+
 static int __io_setxattr_prep(struct io_kiocb *req,
 			const struct io_uring_sqe *sqe)
 {
@@ -6777,6 +6898,10 @@ static int io_req_prep(struct io_kiocb *req, const=
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
@@ -6920,6 +7045,8 @@ static void io_clean_op(struct io_kiocb *req)
 			break;
 		case IORING_OP_SETXATTR:
 		case IORING_OP_FSETXATTR:
+		case IORING_OP_GETXATTR:
+		case IORING_OP_FGETXATTR:
 			__io_xattr_finish(req);
 			break;
 		}
@@ -7073,6 +7200,12 @@ static int io_issue_sqe(struct io_kiocb *req, unsi=
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

