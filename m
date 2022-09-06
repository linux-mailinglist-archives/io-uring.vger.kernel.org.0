Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B3B5AEEF7
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 17:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbiIFPgR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Sep 2022 11:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbiIFPgB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Sep 2022 11:36:01 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DFDB4B7
        for <io-uring@vger.kernel.org>; Tue,  6 Sep 2022 07:45:11 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 286EhglM017303
        for <io-uring@vger.kernel.org>; Tue, 6 Sep 2022 07:45:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=TAWNvJ+djFb3bxmwt95xSnQUTpuR+X6d6FhL6uRiQjE=;
 b=gqi1QoueJEszHaVmJjmMHMsQADi7WDAmm5m80XOwO3/9s4BrFfZzpZnWCy/0OSxE3m6r
 CiOOhszq0gjSWgOnAKF9JE0oIGAIS5a5vFadygS+3BGMz5HeCdWUUpvlBydX7TEVXxbf
 3i7PGK1T/q7fHldnaloAiiTq1bNU2anmivE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3je87gg0ah-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Tue, 06 Sep 2022 07:45:00 -0700
Received: from twshared11415.03.ash7.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Sep 2022 07:44:49 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 692AA5BB4AC4; Tue,  6 Sep 2022 07:44:44 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next] io_uring: allow buffer recycling in READV
Date:   Tue, 6 Sep 2022 07:44:25 -0700
Message-ID: <20220906144425.1458218-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4exHDIW84JPp7uFSky39A7KMtFg3he_Z
X-Proofpoint-GUID: 4exHDIW84JPp7uFSky39A7KMtFg3he_Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-06_07,2022-09-06_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In commit 934447a603b2 ("io_uring: do not recycle buffer in READV") a
temporary fix was put in io_kbuf_recycle to simply never recycle READV
buffers.

Instead of that, rather treat READV with REQ_F_BUFFER_SELECTED the same a=
s
a READ with REQ_F_BUFFER_SELECTED. Since READV requires iov_len of 1 they
are essentially the same.
In order to do this inside io_prep_rw() add some validation to check that
it is in fact only length 1, and also extract the length of the buffer at
prep time.

This allows removal of the io_iov_buffer_select codepaths as they are onl=
y
used from the READV op.

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 io_uring/kbuf.h |   8 ---
 io_uring/rw.c   | 134 +++++++++++++++++++-----------------------------
 2 files changed, 52 insertions(+), 90 deletions(-)

diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index d6af208d109f..c23e15d7d3ca 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -86,14 +86,6 @@ static inline bool io_do_buffer_select(struct io_kiocb=
 *req)
=20
 static inline void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_=
flags)
 {
-	/*
-	 * READV uses fields in `struct io_rw` (len/addr) to stash the selected
-	 * buffer data. However if that buffer is recycled the original request
-	 * data stored in addr is lost. Therefore forbid recycling for now.
-	 */
-	if (req->opcode =3D=3D IORING_OP_READV)
-		return;
-
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		io_kbuf_recycle_legacy(req, issue_flags);
 	if (req->flags & REQ_F_BUFFER_RING)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4a061326c664..214260b943f0 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -33,6 +33,46 @@ static inline bool io_file_supports_nowait(struct io_k=
iocb *req)
 	return req->flags & REQ_F_SUPPORT_NOWAIT;
 }
=20
+#ifdef CONFIG_COMPAT
+static int io_iov_compat_buffer_select_prep(struct io_rw *rw)
+{
+	struct compat_iovec __user *uiov;
+	compat_ssize_t clen;
+
+	uiov =3D u64_to_user_ptr(rw->addr);
+	if (!access_ok(uiov, sizeof(*uiov)))
+		return -EFAULT;
+	if (__get_user(clen, &uiov->iov_len))
+		return -EFAULT;
+	if (clen < 0)
+		return -EINVAL;
+
+	rw->len =3D clen;
+	return 0;
+}
+#endif
+
+static int io_iov_buffer_select_prep(struct io_kiocb *req)
+{
+	struct iovec __user *uiov;
+	struct iovec iov;
+	struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
+
+	if (rw->len !=3D 1)
+		return -EINVAL;
+
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		return io_iov_compat_buffer_select_prep(rw);
+#endif
+
+	uiov =3D u64_to_user_ptr(rw->addr);
+	if (copy_from_user(&iov, uiov, sizeof(*uiov)))
+		return -EFAULT;
+	rw->len =3D iov.iov_len;
+	return 0;
+}
+
 int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
@@ -69,6 +109,16 @@ int io_prep_rw(struct io_kiocb *req, const struct io_=
uring_sqe *sqe)
 	rw->addr =3D READ_ONCE(sqe->addr);
 	rw->len =3D READ_ONCE(sqe->len);
 	rw->flags =3D READ_ONCE(sqe->rw_flags);
+
+	/* Have to do this validation here, as this is in io_read() rw->len mig=
ht
+	 * have chanaged due to buffer selection
+	 */
+	if (req->opcode =3D=3D IORING_OP_READV && req->flags & REQ_F_BUFFER_SEL=
ECT) {
+		ret =3D io_iov_buffer_select_prep(req);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
=20
@@ -273,79 +323,6 @@ static int kiocb_done(struct io_kiocb *req, ssize_t =
ret,
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
=20
-#ifdef CONFIG_COMPAT
-static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
-				unsigned int issue_flags)
-{
-	struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
-	struct compat_iovec __user *uiov;
-	compat_ssize_t clen;
-	void __user *buf;
-	size_t len;
-
-	uiov =3D u64_to_user_ptr(rw->addr);
-	if (!access_ok(uiov, sizeof(*uiov)))
-		return -EFAULT;
-	if (__get_user(clen, &uiov->iov_len))
-		return -EFAULT;
-	if (clen < 0)
-		return -EINVAL;
-
-	len =3D clen;
-	buf =3D io_buffer_select(req, &len, issue_flags);
-	if (!buf)
-		return -ENOBUFS;
-	rw->addr =3D (unsigned long) buf;
-	iov[0].iov_base =3D buf;
-	rw->len =3D iov[0].iov_len =3D (compat_size_t) len;
-	return 0;
-}
-#endif
-
-static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec=
 *iov,
-				      unsigned int issue_flags)
-{
-	struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
-	struct iovec __user *uiov =3D u64_to_user_ptr(rw->addr);
-	void __user *buf;
-	ssize_t len;
-
-	if (copy_from_user(iov, uiov, sizeof(*uiov)))
-		return -EFAULT;
-
-	len =3D iov[0].iov_len;
-	if (len < 0)
-		return -EINVAL;
-	buf =3D io_buffer_select(req, &len, issue_flags);
-	if (!buf)
-		return -ENOBUFS;
-	rw->addr =3D (unsigned long) buf;
-	iov[0].iov_base =3D buf;
-	rw->len =3D iov[0].iov_len =3D len;
-	return 0;
-}
-
-static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *=
iov,
-				    unsigned int issue_flags)
-{
-	struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
-
-	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
-		iov[0].iov_base =3D u64_to_user_ptr(rw->addr);
-		iov[0].iov_len =3D rw->len;
-		return 0;
-	}
-	if (rw->len !=3D 1)
-		return -EINVAL;
-
-#ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
-		return io_compat_import(req, iov, issue_flags);
-#endif
-
-	return __io_iov_buffer_select(req, iov, issue_flags);
-}
-
 static struct iovec *__io_import_iovec(int ddir, struct io_kiocb *req,
 				       struct io_rw_state *s,
 				       unsigned int issue_flags)
@@ -368,7 +345,8 @@ static struct iovec *__io_import_iovec(int ddir, stru=
ct io_kiocb *req,
 	buf =3D u64_to_user_ptr(rw->addr);
 	sqe_len =3D rw->len;
=20
-	if (opcode =3D=3D IORING_OP_READ || opcode =3D=3D IORING_OP_WRITE) {
+	if (opcode =3D=3D IORING_OP_READ || opcode =3D=3D IORING_OP_WRITE ||
+	    (req->flags & REQ_F_BUFFER_SELECT)) {
 		if (io_do_buffer_select(req)) {
 			buf =3D io_buffer_select(req, &sqe_len, issue_flags);
 			if (!buf)
@@ -384,14 +362,6 @@ static struct iovec *__io_import_iovec(int ddir, str=
uct io_kiocb *req,
 	}
=20
 	iovec =3D s->fast_iov;
-	if (req->flags & REQ_F_BUFFER_SELECT) {
-		ret =3D io_iov_buffer_select(req, iovec, issue_flags);
-		if (ret)
-			return ERR_PTR(ret);
-		iov_iter_init(iter, ddir, iovec, 1, iovec->iov_len);
-		return NULL;
-	}
-
 	ret =3D __import_iovec(ddir, buf, sqe_len, UIO_FASTIOV, &iovec, iter,
 			      req->ctx->compat);
 	if (unlikely(ret < 0))

base-commit: a73c11acbf98767f8fb464e463198bc75992ef28
--=20
2.30.2

