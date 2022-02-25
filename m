Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B674C4E15
	for <lists+io-uring@lfdr.de>; Fri, 25 Feb 2022 19:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbiBYSyU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Feb 2022 13:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233511AbiBYSyT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Feb 2022 13:54:19 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EB1188866
        for <io-uring@vger.kernel.org>; Fri, 25 Feb 2022 10:53:44 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21PIanDu015155
        for <io-uring@vger.kernel.org>; Fri, 25 Feb 2022 10:53:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=EGZu11JSKSJ42boAazYwLmSpG05t42IvO0g8PC1STYM=;
 b=qJYtFn+ea3E2wOLDIoHGWtMVNqF64cd5Wro/ZjF49tTZovGaXiM90HMealpx9Ls353MU
 TlVIbnYLYrztjHqYsQbP3SEi54ibdlGerRYXgCqQN7fu5pcxYe4S4C28fe61HjLYxBhA
 XPf+VdET0CiHTS7oWq5DtmenFF8RMIUpr1A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eesktm9s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 25 Feb 2022 10:53:44 -0800
Received: from twshared1433.06.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Feb 2022 10:53:36 -0800
Received: by devvm225.atn0.facebook.com (Postfix, from userid 425415)
        id 560F4B52F88D; Fri, 25 Feb 2022 10:53:28 -0800 (PST)
From:   Stefan Roesch <shr@fb.com>
To:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     <viro@zeniv.linux.org.uk>, <shr@fb.com>, <rostedt@goodmis.org>,
        <m.szyprowski@samsung.com>
Subject: [PATCH v4 1/1] io-uring: Make statx API stable
Date:   Fri, 25 Feb 2022 10:53:26 -0800
Message-ID: <20220225185326.1373304-2-shr@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220225185326.1373304-1-shr@fb.com>
References: <20220225185326.1373304-1-shr@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: C88x-tMjYGaI0zqli1Mo5WqMMcCm4G0m
X-Proofpoint-GUID: C88x-tMjYGaI0zqli1Mo5WqMMcCm4G0m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_10,2022-02-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 adultscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 bulkscore=0 phishscore=0
 mlxscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=903
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202250107
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

One of the key architectual tenets is to keep the parameters for
io-uring stable. After the call has been submitted, its value can
be changed. Unfortunaltely this is not the case for the current statx
implementation.

IO-Uring change:
This changes replaces the const char * filename pointer in the io_statx
structure with a struct filename *. In addition it also creates the
filename object during the prepare phase.

With this change, the opcode also needs to invoke cleanup, so the
filename object gets freed after processing the request.

fs change:
This replaces the const char* __user filename parameter in the two
functions do_statx and vfs_statx with a struct filename *. In addition
to be able to correctly construct a filename object a new helper
function getname_statx_lookup_flags is introduced. The function makes
sure that do_statx and vfs_statx is invoked with the correct lookup flags=
.

Signed-off-by: Stefan Roesch <shr@fb.com>
---
 fs/internal.h |  4 +++-
 fs/io_uring.c | 22 ++++++++++++++++++++--
 fs/stat.c     | 49 +++++++++++++++++++++++++++++++++++--------------
 3 files changed, 58 insertions(+), 17 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 8590c973c2f4..56c0477f4215 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -184,7 +184,9 @@ int sb_init_dio_done_wq(struct super_block *sb);
 /*
  * fs/stat.c:
  */
-int do_statx(int dfd, const char __user *filename, unsigned flags,
+
+int getname_statx_lookup_flags(int flags);
+int do_statx(int dfd, struct filename *filename, unsigned int flags,
 	     unsigned int mask, struct statx __user *buffer);
=20
 /*
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 77b9c7e4793b..28b09b163df1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -642,7 +642,7 @@ struct io_statx {
 	int				dfd;
 	unsigned int			mask;
 	unsigned int			flags;
-	const char __user		*filename;
+	struct filename			*filename;
 	struct statx __user		*buffer;
 };
=20
@@ -4721,6 +4721,8 @@ static int io_fadvise(struct io_kiocb *req, unsigne=
d int issue_flags)
=20
 static int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe=
 *sqe)
 {
+	const char __user *path;
+
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index || sqe->splice_fd_in)
@@ -4730,10 +4732,22 @@ static int io_statx_prep(struct io_kiocb *req, co=
nst struct io_uring_sqe *sqe)
=20
 	req->statx.dfd =3D READ_ONCE(sqe->fd);
 	req->statx.mask =3D READ_ONCE(sqe->len);
-	req->statx.filename =3D u64_to_user_ptr(READ_ONCE(sqe->addr));
+	path =3D u64_to_user_ptr(READ_ONCE(sqe->addr));
 	req->statx.buffer =3D u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	req->statx.flags =3D READ_ONCE(sqe->statx_flags);
=20
+	req->statx.filename =3D getname_flags(path,
+					getname_statx_lookup_flags(req->statx.flags),
+					NULL);
+
+	if (IS_ERR(req->statx.filename)) {
+		int ret =3D PTR_ERR(req->statx.filename);
+
+		req->statx.filename =3D NULL;
+		return ret;
+	}
+
+	req->flags |=3D REQ_F_NEED_CLEANUP;
 	return 0;
 }
=20
@@ -6708,6 +6722,10 @@ static void io_clean_op(struct io_kiocb *req)
 			putname(req->hardlink.oldpath);
 			putname(req->hardlink.newpath);
 			break;
+		case IORING_OP_STATX:
+			if (req->statx.filename)
+				putname(req->statx.filename);
+			break;
 		}
 	}
 	if ((req->flags & REQ_F_POLLED) && req->apoll) {
diff --git a/fs/stat.c b/fs/stat.c
index 28d2020ba1f4..7f734be0e57e 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -184,6 +184,20 @@ int vfs_fstat(int fd, struct kstat *stat)
 	return error;
 }
=20
+int getname_statx_lookup_flags(int flags)
+{
+	int lookup_flags =3D 0;
+
+	if (!(flags & AT_SYMLINK_NOFOLLOW))
+		lookup_flags |=3D LOOKUP_FOLLOW;
+	if (!(flags & AT_NO_AUTOMOUNT))
+		lookup_flags |=3D LOOKUP_AUTOMOUNT;
+	if (flags & AT_EMPTY_PATH)
+		lookup_flags |=3D LOOKUP_EMPTY;
+
+	return lookup_flags;
+}
+
 /**
  * vfs_statx - Get basic and extra attributes by filename
  * @dfd: A file descriptor representing the base dir for a relative file=
name
@@ -199,26 +213,19 @@ int vfs_fstat(int fd, struct kstat *stat)
  *
  * 0 will be returned on success, and a -ve error code if unsuccessful.
  */
-static int vfs_statx(int dfd, const char __user *filename, int flags,
+static int vfs_statx(int dfd, struct filename *filename, int flags,
 	      struct kstat *stat, u32 request_mask)
 {
 	struct path path;
-	unsigned lookup_flags =3D 0;
+	unsigned int lookup_flags =3D getname_statx_lookup_flags(flags);
 	int error;
=20
 	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT | AT_EMPTY_PATH |
 		      AT_STATX_SYNC_TYPE))
 		return -EINVAL;
=20
-	if (!(flags & AT_SYMLINK_NOFOLLOW))
-		lookup_flags |=3D LOOKUP_FOLLOW;
-	if (!(flags & AT_NO_AUTOMOUNT))
-		lookup_flags |=3D LOOKUP_AUTOMOUNT;
-	if (flags & AT_EMPTY_PATH)
-		lookup_flags |=3D LOOKUP_EMPTY;
-
 retry:
-	error =3D user_path_at(dfd, filename, lookup_flags, &path);
+	error =3D filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (error)
 		goto out;
=20
@@ -240,8 +247,15 @@ static int vfs_statx(int dfd, const char __user *fil=
ename, int flags,
 int vfs_fstatat(int dfd, const char __user *filename,
 			      struct kstat *stat, int flags)
 {
-	return vfs_statx(dfd, filename, flags | AT_NO_AUTOMOUNT,
-			 stat, STATX_BASIC_STATS);
+	int ret;
+	int statx_flags =3D flags | AT_NO_AUTOMOUNT;
+	struct filename *name;
+
+	name =3D getname_flags(filename, getname_statx_lookup_flags(statx_flags=
), NULL);
+	ret =3D vfs_statx(dfd, name, statx_flags, stat, STATX_BASIC_STATS);
+	putname(name);
+
+	return ret;
 }
=20
 #ifdef __ARCH_WANT_OLD_STAT
@@ -602,7 +616,7 @@ cp_statx(const struct kstat *stat, struct statx __use=
r *buffer)
 	return copy_to_user(buffer, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
=20
-int do_statx(int dfd, const char __user *filename, unsigned flags,
+int do_statx(int dfd, struct filename *filename, unsigned int flags,
 	     unsigned int mask, struct statx __user *buffer)
 {
 	struct kstat stat;
@@ -636,7 +650,14 @@ SYSCALL_DEFINE5(statx,
 		unsigned int, mask,
 		struct statx __user *, buffer)
 {
-	return do_statx(dfd, filename, flags, mask, buffer);
+	int ret;
+	struct filename *name;
+
+	name =3D getname_flags(filename, getname_statx_lookup_flags(flags), NUL=
L);
+	ret =3D do_statx(dfd, name, flags, mask, buffer);
+	putname(name);
+
+	return ret;
 }
=20
 #ifdef CONFIG_COMPAT
--=20
2.30.2

