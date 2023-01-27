Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31C6367E71A
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 14:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjA0Nwy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 08:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233005AbjA0Nwx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 08:52:53 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354E31352E
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 05:52:51 -0800 (PST)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RDg8Lj002707
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 05:52:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=A5KRGpqpwXGUVWT5TS8r4pbKUq02uBqfeR/Crula408=;
 b=QnULjCHt0BVd9hVxCvF7zN2LDEtgEMm8B+WSiMKn4Jyu7W5QZ/RuHpDUVhyOydFDTd5h
 +X4a3hgBW6VAoE7EG8cSI2t8IYAJ571fhZDFVUsFQcgCiftjIxuPgI/Mtap9zWovm/wV
 oK6D5rgQyf3YgQ+Irf1L5dlVoYEaakMQbRdQexbtWrFCATfjtsCEFsuANLTqhOzgfYW+
 cp9p5z2dg3eONRg4StvBdV1aOaaSXWjwaJsoMTm51zO4M8e5q9DtSBH/GunsHBg6Z/T2
 KCE9UH5A07GCft3hWWGOUKnUkhowiDZeG/JXsXMPQaovKgfI8TNP90LRKgGIJJykIkoI EA== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nbw3dne8h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 05:52:50 -0800
Received: from twshared6233.02.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Fri, 27 Jan 2023 05:52:46 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 016D3EA28121; Fri, 27 Jan 2023 05:52:34 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 2/4] io_uring: for requests that require async, force it
Date:   Fri, 27 Jan 2023 05:52:25 -0800
Message-ID: <20230127135227.3646353-3-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230127135227.3646353-1-dylany@meta.com>
References: <20230127135227.3646353-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 1AOUGd8ZzSyNjya6m4jruKxyYQ-2x1nx
X-Proofpoint-GUID: 1AOUGd8ZzSyNjya6m4jruKxyYQ-2x1nx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_08,2023-01-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some requests require being run async as they do not support
non-blocking. Instead of trying to issue these requests, getting -EAGAIN
and then queueing them for async issue, rather just force async upfront.

Add WARN_ON_ONCE to make sure surprising code paths do not come up,
however in those cases the bug would end up being a blocking
io_uring_enter(2) which should not be critical.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/advise.c |  4 ++--
 io_uring/fs.c     | 20 ++++++++++----------
 io_uring/net.c    |  4 ++--
 io_uring/splice.c |  7 +++----
 io_uring/statx.c  |  4 ++--
 io_uring/sync.c   | 14 ++++++++------
 io_uring/xattr.c  | 14 ++++++--------
 7 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/io_uring/advise.c b/io_uring/advise.c
index 449c6f14649f..cf600579bffe 100644
--- a/io_uring/advise.c
+++ b/io_uring/advise.c
@@ -39,6 +39,7 @@ int io_madvise_prep(struct io_kiocb *req, const struct =
io_uring_sqe *sqe)
 	ma->addr =3D READ_ONCE(sqe->addr);
 	ma->len =3D READ_ONCE(sqe->len);
 	ma->advice =3D READ_ONCE(sqe->fadvise_advice);
+	req->flags |=3D REQ_F_FORCE_ASYNC;
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -51,8 +52,7 @@ int io_madvise(struct io_kiocb *req, unsigned int issue=
_flags)
 	struct io_madvise *ma =3D io_kiocb_to_cmd(req, struct io_madvise);
 	int ret;
=20
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
=20
 	ret =3D do_madvise(current->mm, ma->addr, ma->len, ma->advice);
 	io_req_set_res(req, ret, 0);
diff --git a/io_uring/fs.c b/io_uring/fs.c
index 7100c293c13a..f6a69a549fd4 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -74,6 +74,7 @@ int io_renameat_prep(struct io_kiocb *req, const struct=
 io_uring_sqe *sqe)
 	}
=20
 	req->flags |=3D REQ_F_NEED_CLEANUP;
+	req->flags |=3D REQ_F_FORCE_ASYNC;
 	return 0;
 }
=20
@@ -82,8 +83,7 @@ int io_renameat(struct io_kiocb *req, unsigned int issu=
e_flags)
 	struct io_rename *ren =3D io_kiocb_to_cmd(req, struct io_rename);
 	int ret;
=20
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
=20
 	ret =3D do_renameat2(ren->old_dfd, ren->oldpath, ren->new_dfd,
 				ren->newpath, ren->flags);
@@ -123,6 +123,7 @@ int io_unlinkat_prep(struct io_kiocb *req, const stru=
ct io_uring_sqe *sqe)
 		return PTR_ERR(un->filename);
=20
 	req->flags |=3D REQ_F_NEED_CLEANUP;
+	req->flags |=3D REQ_F_FORCE_ASYNC;
 	return 0;
 }
=20
@@ -131,8 +132,7 @@ int io_unlinkat(struct io_kiocb *req, unsigned int is=
sue_flags)
 	struct io_unlink *un =3D io_kiocb_to_cmd(req, struct io_unlink);
 	int ret;
=20
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
=20
 	if (un->flags & AT_REMOVEDIR)
 		ret =3D do_rmdir(un->dfd, un->filename);
@@ -170,6 +170,7 @@ int io_mkdirat_prep(struct io_kiocb *req, const struc=
t io_uring_sqe *sqe)
 		return PTR_ERR(mkd->filename);
=20
 	req->flags |=3D REQ_F_NEED_CLEANUP;
+	req->flags |=3D REQ_F_FORCE_ASYNC;
 	return 0;
 }
=20
@@ -178,8 +179,7 @@ int io_mkdirat(struct io_kiocb *req, unsigned int iss=
ue_flags)
 	struct io_mkdir *mkd =3D io_kiocb_to_cmd(req, struct io_mkdir);
 	int ret;
=20
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
=20
 	ret =3D do_mkdirat(mkd->dfd, mkd->filename, mkd->mode);
=20
@@ -220,6 +220,7 @@ int io_symlinkat_prep(struct io_kiocb *req, const str=
uct io_uring_sqe *sqe)
 	}
=20
 	req->flags |=3D REQ_F_NEED_CLEANUP;
+	req->flags |=3D REQ_F_FORCE_ASYNC;
 	return 0;
 }
=20
@@ -228,8 +229,7 @@ int io_symlinkat(struct io_kiocb *req, unsigned int i=
ssue_flags)
 	struct io_link *sl =3D io_kiocb_to_cmd(req, struct io_link);
 	int ret;
=20
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
=20
 	ret =3D do_symlinkat(sl->oldpath, sl->new_dfd, sl->newpath);
=20
@@ -265,6 +265,7 @@ int io_linkat_prep(struct io_kiocb *req, const struct=
 io_uring_sqe *sqe)
 	}
=20
 	req->flags |=3D REQ_F_NEED_CLEANUP;
+	req->flags |=3D REQ_F_FORCE_ASYNC;
 	return 0;
 }
=20
@@ -273,8 +274,7 @@ int io_linkat(struct io_kiocb *req, unsigned int issu=
e_flags)
 	struct io_link *lnk =3D io_kiocb_to_cmd(req, struct io_link);
 	int ret;
=20
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
=20
 	ret =3D do_linkat(lnk->old_dfd, lnk->oldpath, lnk->new_dfd,
 				lnk->newpath, lnk->flags);
diff --git a/io_uring/net.c b/io_uring/net.c
index 90326b279965..aeb1d016e2e9 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -90,6 +90,7 @@ int io_shutdown_prep(struct io_kiocb *req, const struct=
 io_uring_sqe *sqe)
 		return -EINVAL;
=20
 	shutdown->how =3D READ_ONCE(sqe->len);
+	req->flags |=3D REQ_F_FORCE_ASYNC;
 	return 0;
 }
=20
@@ -99,8 +100,7 @@ int io_shutdown(struct io_kiocb *req, unsigned int iss=
ue_flags)
 	struct socket *sock;
 	int ret;
=20
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
=20
 	sock =3D sock_from_file(req->file);
 	if (unlikely(!sock))
diff --git a/io_uring/splice.c b/io_uring/splice.c
index 53e4232d0866..2a4bbb719531 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -34,6 +34,7 @@ static int __io_splice_prep(struct io_kiocb *req,
 	if (unlikely(sp->flags & ~valid_flags))
 		return -EINVAL;
 	sp->splice_fd_in =3D READ_ONCE(sqe->splice_fd_in);
+	req->flags |=3D REQ_F_FORCE_ASYNC;
 	return 0;
 }
=20
@@ -52,8 +53,7 @@ int io_tee(struct io_kiocb *req, unsigned int issue_fla=
gs)
 	struct file *in;
 	long ret =3D 0;
=20
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
=20
 	if (sp->flags & SPLICE_F_FD_IN_FIXED)
 		in =3D io_file_get_fixed(req, sp->splice_fd_in, issue_flags);
@@ -94,8 +94,7 @@ int io_splice(struct io_kiocb *req, unsigned int issue_=
flags)
 	struct file *in;
 	long ret =3D 0;
=20
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
=20
 	if (sp->flags & SPLICE_F_FD_IN_FIXED)
 		in =3D io_file_get_fixed(req, sp->splice_fd_in, issue_flags);
diff --git a/io_uring/statx.c b/io_uring/statx.c
index d8fc933d3f59..abb874209caa 100644
--- a/io_uring/statx.c
+++ b/io_uring/statx.c
@@ -48,6 +48,7 @@ int io_statx_prep(struct io_kiocb *req, const struct io=
_uring_sqe *sqe)
 	}
=20
 	req->flags |=3D REQ_F_NEED_CLEANUP;
+	req->flags |=3D REQ_F_FORCE_ASYNC;
 	return 0;
 }
=20
@@ -56,8 +57,7 @@ int io_statx(struct io_kiocb *req, unsigned int issue_f=
lags)
 	struct io_statx *sx =3D io_kiocb_to_cmd(req, struct io_statx);
 	int ret;
=20
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
=20
 	ret =3D do_statx(sx->dfd, sx->filename, sx->flags, sx->mask, sx->buffer=
);
 	io_req_set_res(req, ret, 0);
diff --git a/io_uring/sync.c b/io_uring/sync.c
index 64e87ea2b8fb..255f68c37e55 100644
--- a/io_uring/sync.c
+++ b/io_uring/sync.c
@@ -32,6 +32,8 @@ int io_sfr_prep(struct io_kiocb *req, const struct io_u=
ring_sqe *sqe)
 	sync->off =3D READ_ONCE(sqe->off);
 	sync->len =3D READ_ONCE(sqe->len);
 	sync->flags =3D READ_ONCE(sqe->sync_range_flags);
+	req->flags |=3D REQ_F_FORCE_ASYNC;
+
 	return 0;
 }
=20
@@ -41,8 +43,7 @@ int io_sync_file_range(struct io_kiocb *req, unsigned i=
nt issue_flags)
 	int ret;
=20
 	/* sync_file_range always requires a blocking context */
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
=20
 	ret =3D sync_file_range(req->file, sync->off, sync->len, sync->flags);
 	io_req_set_res(req, ret, 0);
@@ -62,6 +63,7 @@ int io_fsync_prep(struct io_kiocb *req, const struct io=
_uring_sqe *sqe)
=20
 	sync->off =3D READ_ONCE(sqe->off);
 	sync->len =3D READ_ONCE(sqe->len);
+	req->flags |=3D REQ_F_FORCE_ASYNC;
 	return 0;
 }
=20
@@ -72,8 +74,7 @@ int io_fsync(struct io_kiocb *req, unsigned int issue_f=
lags)
 	int ret;
=20
 	/* fsync always requires a blocking context */
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
=20
 	ret =3D vfs_fsync_range(req->file, sync->off, end > 0 ? end : LLONG_MAX=
,
 				sync->flags & IORING_FSYNC_DATASYNC);
@@ -91,6 +92,7 @@ int io_fallocate_prep(struct io_kiocb *req, const struc=
t io_uring_sqe *sqe)
 	sync->off =3D READ_ONCE(sqe->off);
 	sync->len =3D READ_ONCE(sqe->addr);
 	sync->mode =3D READ_ONCE(sqe->len);
+	req->flags |=3D REQ_F_FORCE_ASYNC;
 	return 0;
 }
=20
@@ -100,8 +102,8 @@ int io_fallocate(struct io_kiocb *req, unsigned int i=
ssue_flags)
 	int ret;
=20
 	/* fallocate always requiring blocking context */
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+
 	ret =3D vfs_fallocate(req->file, sync->mode, sync->off, sync->len);
 	if (ret >=3D 0)
 		fsnotify_modify(req->file);
diff --git a/io_uring/xattr.c b/io_uring/xattr.c
index 6201a9f442c6..e1c810e0b85a 100644
--- a/io_uring/xattr.c
+++ b/io_uring/xattr.c
@@ -75,6 +75,7 @@ static int __io_getxattr_prep(struct io_kiocb *req,
 	}
=20
 	req->flags |=3D REQ_F_NEED_CLEANUP;
+	req->flags |=3D REQ_F_FORCE_ASYNC;
 	return 0;
 }
=20
@@ -109,8 +110,7 @@ int io_fgetxattr(struct io_kiocb *req, unsigned int i=
ssue_flags)
 	struct io_xattr *ix =3D io_kiocb_to_cmd(req, struct io_xattr);
 	int ret;
=20
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
=20
 	ret =3D do_getxattr(mnt_idmap(req->file->f_path.mnt),
 			req->file->f_path.dentry,
@@ -127,8 +127,7 @@ int io_getxattr(struct io_kiocb *req, unsigned int is=
sue_flags)
 	struct path path;
 	int ret;
=20
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
=20
 retry:
 	ret =3D filename_lookup(AT_FDCWD, ix->filename, lookup_flags, &path, NU=
LL);
@@ -174,6 +173,7 @@ static int __io_setxattr_prep(struct io_kiocb *req,
 	}
=20
 	req->flags |=3D REQ_F_NEED_CLEANUP;
+	req->flags |=3D REQ_F_FORCE_ASYNC;
 	return 0;
 }
=20
@@ -222,8 +222,7 @@ int io_fsetxattr(struct io_kiocb *req, unsigned int i=
ssue_flags)
 {
 	int ret;
=20
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
=20
 	ret =3D __io_setxattr(req, issue_flags, &req->file->f_path);
 	io_xattr_finish(req, ret);
@@ -237,8 +236,7 @@ int io_setxattr(struct io_kiocb *req, unsigned int is=
sue_flags)
 	struct path path;
 	int ret;
=20
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
=20
 retry:
 	ret =3D filename_lookup(AT_FDCWD, ix->filename, lookup_flags, &path, NU=
LL);
--=20
2.30.2

