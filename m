Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9118D45FCF9
	for <lists+io-uring@lfdr.de>; Sat, 27 Nov 2021 06:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241709AbhK0GBJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Nov 2021 01:01:09 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20508 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239959AbhK0F7G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Nov 2021 00:59:06 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 1AR2xwZU019591
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 21:55:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ewaqU2t7m6J/wYYlU7WE+7Hm8wgdez9pYRYBbpwdhzY=;
 b=e5sRVQBiPmaXTERdbeR0vcT6eZwR9Uu7o2xW/fgcjqdSHYP7AtAhTq/upa5pnLLreTYJ
 8oaRPPetspw6I0qtkIPrdjsgyPY+hgxMF9c5wI18AEipOfqB9nB9P00drtvRkhKkkHuC
 wRsouj3sde9VbJ4D0WTFBzelbITEQiPjZQY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3ckcc48fru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 21:55:52 -0800
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 26 Nov 2021 21:55:51 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 5B71B6F661AA; Fri, 26 Nov 2021 21:55:41 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
CC:     <shr@fb.com>, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 3/3] io_uring: add support for getdents64
Date:   Fri, 26 Nov 2021 21:55:35 -0800
Message-ID: <20211127055535.2976876-5-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211127055535.2976876-1-shr@fb.com>
References: <20211127055535.2976876-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: _C6R-gCnVPpaoFlcJkMFawSR_jl7IgqA
X-Proofpoint-ORIG-GUID: _C6R-gCnVPpaoFlcJkMFawSR_jl7IgqA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-27_02,2021-11-25_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=918
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111270031
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds support for getdents64 to io_uring.

Signed-off-by: Stefan Roesch <shr@fb.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 52 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 53 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 08b1b3de9b3f..8fdff4745742 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -691,6 +691,13 @@ struct io_hardlink {
 	int				flags;
 };
=20
+struct io_getdents {
+	struct file			*file;
+	struct linux_dirent64 __user	*dirent;
+	unsigned int			count;
+	loff_t				pos;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -856,6 +863,7 @@ struct io_kiocb {
 		struct io_mkdir		mkdir;
 		struct io_symlink	symlink;
 		struct io_hardlink	hardlink;
+		struct io_getdents	getdents;
 	};
=20
 	u8				opcode;
@@ -1105,6 +1113,9 @@ static const struct io_op_def io_op_defs[] =3D {
 	[IORING_OP_MKDIRAT] =3D {},
 	[IORING_OP_SYMLINKAT] =3D {},
 	[IORING_OP_LINKAT] =3D {},
+	[IORING_OP_GETDENTS] =3D {
+		.needs_file		=3D 1,
+	},
 };
=20
 /* requests with any of those set should undergo io_disarm_next() */
@@ -3971,6 +3982,42 @@ static int io_linkat(struct io_kiocb *req, unsigne=
d int issue_flags)
 	return 0;
 }
=20
+static int io_getdents_prep(struct io_kiocb *req, const struct io_uring_=
sqe *sqe)
+{
+	struct io_getdents *getdents =3D &req->getdents;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->rw_flags || sqe->buf_index)
+		return -EINVAL;
+
+	getdents->pos =3D READ_ONCE(sqe->off);
+	getdents->dirent =3D u64_to_user_ptr(READ_ONCE(sqe->addr));
+	getdents->count =3D READ_ONCE(sqe->len);
+
+	return 0;
+}
+
+static int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_getdents *getdents =3D &req->getdents;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	ret =3D vfs_getdents(req->file, getdents->dirent, getdents->count, getd=
ents->pos);
+	if (ret < 0) {
+		if (ret =3D=3D -ERESTARTSYS)
+			ret =3D -EINTR;
+
+		req_set_fail(req);
+	}
+
+	io_req_complete(req, ret);
+	return 0;
+}
+
 static int io_shutdown_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -6486,6 +6533,8 @@ static int io_req_prep(struct io_kiocb *req, const =
struct io_uring_sqe *sqe)
 		return io_symlinkat_prep(req, sqe);
 	case IORING_OP_LINKAT:
 		return io_linkat_prep(req, sqe);
+	case IORING_OP_GETDENTS:
+		return io_getdents_prep(req, sqe);
 	}
=20
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6771,6 +6820,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsig=
ned int issue_flags)
 	case IORING_OP_LINKAT:
 		ret =3D io_linkat(req, issue_flags);
 		break;
+	case IORING_OP_GETDENTS:
+		ret =3D io_getdents(req, issue_flags);
+		break;
 	default:
 		ret =3D -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 787f491f0d2a..57dc88db5793 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -143,6 +143,7 @@ enum {
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
+	IORING_OP_GETDENTS,
=20
 	/* this goes last, obviously */
 	IORING_OP_LAST,
--=20
2.30.2

