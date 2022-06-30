Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C25E556161E
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbiF3JSw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234223AbiF3JSZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:18:25 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBAD40E46
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:20 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25U7SrSb021278
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ame4x0RcQmOHiswa6Sk5WXAT+aXNUGv/3T7h/wTdNZs=;
 b=Zc27u357+uW6f3Z4tQQk9+xy4xUxERjIYWC9NnpkzKKy9eRE+mbtRWMiV+8AJ2u58T0n
 THMHzg6voXW+oKUbMlYEHJgNOPOID53EnbmCbvyu4dBnZlyXT8EXnJW8PLY9c4Ktb6ky
 +Ds4dKikeu2e6NP6JWNrJXLRp4gOmRwuVFk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h17fmgg4b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:17:20 -0700
Received: from twshared18317.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Thu, 30 Jun 2022 02:17:19 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id CE7AB2599FE1; Thu, 30 Jun 2022 02:14:08 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        <io-uring@vger.kernel.org>
CC:     <Kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 10/12] io_uring: multishot recv
Date:   Thu, 30 Jun 2022 02:12:29 -0700
Message-ID: <20220630091231.1456789-11-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220630091231.1456789-1-dylany@fb.com>
References: <20220630091231.1456789-1-dylany@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: y5GEqDfw4-mbs_oALbw9bpYBH0JK1J-i
X-Proofpoint-ORIG-GUID: y5GEqDfw4-mbs_oALbw9bpYBH0JK1J-i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-30_05,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Support multishot receive for io_uring.
Typical server applications will run a loop where for each recv CQE it
requeues another recv/recvmsg.

This can be simplified by using the existing multishot functionality
combined with io_uring's provided buffers.
The API is to add the IORING_RECV_MULTISHOT flag to the SQE. CQEs will
then be posted (with IORING_CQE_F_MORE flag set) when data is available
and is read. Once an error occurs or the socket ends, the multishot will
be removed and a completion without IORING_CQE_F_MORE will be posted.

The benefit to this is that the recv is much more performant.
 * Subsequent receives are queued up straight away without requiring the
   application to finish a processing loop.
 * If there are more data in the socket (sat the provided buffer size is
   smaller than the socket buffer) then the data is immediately
   returned, improving batching.
 * Poll is only armed once and reused, saving CPU cycles

Signed-off-by: Dylan Yudaken <dylany@fb.com>
---
 include/uapi/linux/io_uring.h |   5 ++
 io_uring/net.c                | 102 +++++++++++++++++++++++++++++-----
 2 files changed, 94 insertions(+), 13 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
index 05addde13df8..405bb5a67d47 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -260,8 +260,13 @@ enum io_uring_op {
  *				or receive and arm poll if that yields an
  *				-EAGAIN result, arm poll upfront and skip
  *				the initial transfer attempt.
+ *
+ * IORING_RECV_MULTISHOT	Multishot recv. Sets IORING_CQE_F_MORE if
+ *				the handler will continue to report
+ *				CQEs on behalf of the same SQE.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
+#define IORING_RECV_MULTISHOT	(1U << 1)
=20
 /*
  * accept flags stored in sqe->ioprio
diff --git a/io_uring/net.c b/io_uring/net.c
index 75761f48c959..3394825f74fd 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -389,6 +389,8 @@ int io_recvmsg_prep_async(struct io_kiocb *req)
 	return ret;
 }
=20
+#define RECVMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECV_MULTISHO=
T)
+
 int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe=
)
 {
 	struct io_sr_msg *sr =3D io_kiocb_to_cmd(req);
@@ -399,13 +401,22 @@ int io_recvmsg_prep(struct io_kiocb *req, const str=
uct io_uring_sqe *sqe)
 	sr->umsg =3D u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len =3D READ_ONCE(sqe->len);
 	sr->flags =3D READ_ONCE(sqe->addr2);
-	if (sr->flags & ~IORING_RECVSEND_POLL_FIRST)
+	if (sr->flags & ~(RECVMSG_FLAGS))
 		return -EINVAL;
 	sr->msg_flags =3D READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |=3D REQ_F_NOWAIT;
 	if (sr->msg_flags & MSG_ERRQUEUE)
 		req->flags |=3D REQ_F_CLEAR_POLLIN;
+	if (sr->flags & IORING_RECV_MULTISHOT) {
+		if (!(req->flags & REQ_F_BUFFER_SELECT))
+			return -EINVAL;
+		if (sr->msg_flags & MSG_WAITALL)
+			return -EINVAL;
+		if (req->opcode =3D=3D IORING_OP_RECV && sr->len)
+			return -EINVAL;
+		req->flags |=3D REQ_F_APOLL_MULTISHOT;
+	}
=20
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
@@ -415,6 +426,48 @@ int io_recvmsg_prep(struct io_kiocb *req, const stru=
ct io_uring_sqe *sqe)
 	return 0;
 }
=20
+static inline void io_recv_prep_retry(struct io_kiocb *req)
+{
+	struct io_sr_msg *sr =3D io_kiocb_to_cmd(req);
+
+	sr->done_io =3D 0;
+	sr->len =3D 0; /* get from the provided buffer */
+}
+
+/*
+ * Finishes io_recv and io_recvmsg.
+ *
+ * Returns true if it is actually finished, or false if it should run
+ * again (for multishot).
+ */
+static inline bool io_recv_finish(struct io_kiocb *req, int *ret, unsign=
ed int cflags)
+{
+	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
+		io_req_set_res(req, *ret, cflags);
+		*ret =3D IOU_OK;
+		return true;
+	}
+
+	if (*ret > 0) {
+		if (io_post_aux_cqe(req->ctx, req->cqe.user_data, *ret,
+				    cflags | IORING_CQE_F_MORE, false)) {
+			io_recv_prep_retry(req);
+			return false;
+		}
+		/*
+		 * Otherwise stop multishot but use the current result.
+		 * Probably will end up going into overflow, but this means
+		 * we cannot trust the ordering anymore
+		 */
+	}
+
+	io_req_set_res(req, *ret, cflags);
+
+	if (req->flags & REQ_F_POLLED)
+		*ret =3D IOU_STOP_MULTISHOT;
+	return true;
+}
+
 int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr =3D io_kiocb_to_cmd(req);
@@ -424,6 +477,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int iss=
ue_flags)
 	unsigned flags;
 	int ret, min_ret =3D 0;
 	bool force_nonblock =3D issue_flags & IO_URING_F_NONBLOCK;
+	size_t len =3D sr->len;
=20
 	sock =3D sock_from_file(req->file);
 	if (unlikely(!sock))
@@ -442,16 +496,17 @@ int io_recvmsg(struct io_kiocb *req, unsigned int i=
ssue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return io_setup_async_msg(req, kmsg);
=20
+retry_multishot:
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
=20
-		buf =3D io_buffer_select(req, &sr->len, issue_flags);
+		buf =3D io_buffer_select(req, &len, issue_flags);
 		if (!buf)
 			return -ENOBUFS;
 		kmsg->fast_iov[0].iov_base =3D buf;
-		kmsg->fast_iov[0].iov_len =3D sr->len;
+		kmsg->fast_iov[0].iov_len =3D len;
 		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->fast_iov, 1,
-				sr->len);
+				len);
 	}
=20
 	flags =3D sr->msg_flags;
@@ -463,8 +518,15 @@ int io_recvmsg(struct io_kiocb *req, unsigned int is=
sue_flags)
 	kmsg->msg.msg_get_inq =3D 1;
 	ret =3D __sys_recvmsg_sock(sock, &kmsg->msg, sr->umsg, kmsg->uaddr, fla=
gs);
 	if (ret < min_ret) {
-		if (ret =3D=3D -EAGAIN && force_nonblock)
-			return io_setup_async_msg(req, kmsg);
+		if (ret =3D=3D -EAGAIN && force_nonblock) {
+			ret =3D io_setup_async_msg(req, kmsg);
+			if (ret =3D=3D -EAGAIN && (req->flags & IO_APOLL_MULTI_POLLED) =3D=3D
+					       IO_APOLL_MULTI_POLLED) {
+				io_kbuf_recycle(req, issue_flags);
+				return IOU_ISSUE_SKIP_COMPLETE;
+			}
+			return ret;
+		}
 		if (ret =3D=3D -ERESTARTSYS)
 			ret =3D -EINTR;
 		if (ret > 0 && io_net_retry(sock, flags)) {
@@ -491,8 +553,11 @@ int io_recvmsg(struct io_kiocb *req, unsigned int is=
sue_flags)
 	cflags =3D io_put_kbuf(req, issue_flags);
 	if (kmsg->msg.msg_inq)
 		cflags |=3D IORING_CQE_F_SOCK_NONEMPTY;
-	io_req_set_res(req, ret, cflags);
-	return IOU_OK;
+
+	if (!io_recv_finish(req, &ret, cflags))
+		goto retry_multishot;
+
+	return ret;
 }
=20
 int io_recv(struct io_kiocb *req, unsigned int issue_flags)
@@ -505,6 +570,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_=
flags)
 	unsigned flags;
 	int ret, min_ret =3D 0;
 	bool force_nonblock =3D issue_flags & IO_URING_F_NONBLOCK;
+	size_t len =3D sr->len;
=20
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
@@ -514,16 +580,17 @@ int io_recv(struct io_kiocb *req, unsigned int issu=
e_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
=20
+retry_multishot:
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
=20
-		buf =3D io_buffer_select(req, &sr->len, issue_flags);
+		buf =3D io_buffer_select(req, &len, issue_flags);
 		if (!buf)
 			return -ENOBUFS;
 		sr->buf =3D buf;
 	}
=20
-	ret =3D import_single_range(READ, sr->buf, sr->len, &iov, &msg.msg_iter=
);
+	ret =3D import_single_range(READ, sr->buf, len, &iov, &msg.msg_iter);
 	if (unlikely(ret))
 		goto out_free;
=20
@@ -543,8 +610,14 @@ int io_recv(struct io_kiocb *req, unsigned int issue=
_flags)
=20
 	ret =3D sock_recvmsg(sock, &msg, flags);
 	if (ret < min_ret) {
-		if (ret =3D=3D -EAGAIN && force_nonblock)
+		if (ret =3D=3D -EAGAIN && force_nonblock) {
+			if ((req->flags & IO_APOLL_MULTI_POLLED) =3D=3D IO_APOLL_MULTI_POLLED=
) {
+				io_kbuf_recycle(req, issue_flags);
+				return IOU_ISSUE_SKIP_COMPLETE;
+			}
+
 			return -EAGAIN;
+		}
 		if (ret =3D=3D -ERESTARTSYS)
 			ret =3D -EINTR;
 		if (ret > 0 && io_net_retry(sock, flags)) {
@@ -570,8 +643,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue=
_flags)
 	cflags =3D io_put_kbuf(req, issue_flags);
 	if (msg.msg_inq)
 		cflags |=3D IORING_CQE_F_SOCK_NONEMPTY;
-	io_req_set_res(req, ret, cflags);
-	return IOU_OK;
+
+	if (!io_recv_finish(req, &ret, cflags))
+		goto retry_multishot;
+
+	return ret;
 }
=20
 int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
--=20
2.30.2

