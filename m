Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F8B61383D
	for <lists+io-uring@lfdr.de>; Mon, 31 Oct 2022 14:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbiJaNl4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 Oct 2022 09:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiJaNly (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 Oct 2022 09:41:54 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2ACB101F8
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:53 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VDF6UW002501
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=xGpRXxs6UtO1K5TkrTC+htpfAkBhM3I2QzU0IEJz/Ag=;
 b=IvyFGRS/BeoKSwmt4u4S75z3mwr6dc43yimy6gz3RDtWr8laLx9lTgpa09M8JyVxCsmD
 BndZ7g5EUa7SLQAE3FljYFOZjIzr0yfreBcB6NhACAjUnzaAt2F4tFE+3W6bGx7VmV0I
 CIDa/YjitibNQB+U5EEfnaNJzpzhO3vNXO5xWun7A9BieWsW+QgMMQB91hQqQhUZ489C
 ydwJMqeBMgEJzthldCNwlWfKIYUo9a/7T/Eu6O3ESacZsVfDWxcaGLQVUYYzf+cDlXeL
 N+cTH1T4bwQX1Uv8gi2VhsRmsrNyCpqxqKQg5P/p7MFBv4zMaR5axI0hicOGxHmBgzKO qw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kh19te02b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 31 Oct 2022 06:41:53 -0700
Received: from twshared2001.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 31 Oct 2022 06:41:52 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id D31E18A19658; Mon, 31 Oct 2022 06:41:35 -0700 (PDT)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 07/12] io_uring: split send_zc specific struct out of io_sr_msg
Date:   Mon, 31 Oct 2022 06:41:21 -0700
Message-ID: <20221031134126.82928-8-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221031134126.82928-1-dylany@meta.com>
References: <20221031134126.82928-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: tRxzuhAf_HcsQAGaucUpqSb7-frsLvdi
X-Proofpoint-ORIG-GUID: tRxzuhAf_HcsQAGaucUpqSb7-frsLvdi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_15,2022-10-31_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Split out the specific sendzc parts of struct io_sr_msg as other opcodes
are going to be specialized.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/net.c | 77 +++++++++++++++++++++++++++-----------------------
 1 file changed, 42 insertions(+), 35 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 15dea91625e2..f4638e79a022 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -63,10 +63,14 @@ struct io_sr_msg {
 	/* initialised and used only by !msg send variants */
 	u16				addr_len;
 	void __user			*addr;
-	/* used only for send zerocopy */
-	struct io_kiocb 		*notif;
 };
=20
+struct io_send_zc_msg {
+	struct io_sr_msg	sr;
+	struct io_kiocb		*notif;
+};
+
+
 #define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
=20
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sq=
e)
@@ -910,7 +914,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_=
flags)
=20
 void io_send_zc_cleanup(struct io_kiocb *req)
 {
-	struct io_sr_msg *zc =3D io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_send_zc_msg *zc =3D io_kiocb_to_cmd(req, struct io_send_zc_ms=
g);
 	struct io_async_msghdr *io;
=20
 	if (req_has_async_data(req)) {
@@ -927,8 +931,9 @@ void io_send_zc_cleanup(struct io_kiocb *req)
=20
 int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe=
)
 {
-	struct io_sr_msg *zc =3D io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_send_zc_msg *zc =3D io_kiocb_to_cmd(req, struct io_send_zc_ms=
g);
 	struct io_ring_ctx *ctx =3D req->ctx;
+	struct io_sr_msg *sr =3D &zc->sr;
 	struct io_kiocb *notif;
=20
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
@@ -937,8 +942,8 @@ int io_send_zc_prep(struct io_kiocb *req, const struc=
t io_uring_sqe *sqe)
 	if (req->flags & REQ_F_CQE_SKIP)
 		return -EINVAL;
=20
-	zc->flags =3D READ_ONCE(sqe->ioprio);
-	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
+	sr->flags =3D READ_ONCE(sqe->ioprio);
+	if (sr->flags & ~(IORING_RECVSEND_POLL_FIRST |
 			  IORING_RECVSEND_FIXED_BUF))
 		return -EINVAL;
 	notif =3D zc->notif =3D io_alloc_notif(ctx);
@@ -948,7 +953,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struc=
t io_uring_sqe *sqe)
 	notif->cqe.res =3D 0;
 	notif->cqe.flags =3D IORING_CQE_F_NOTIF;
 	req->flags |=3D REQ_F_NEED_CLEANUP;
-	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
+	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
 		unsigned idx =3D READ_ONCE(sqe->buf_index);
=20
 		if (unlikely(idx >=3D ctx->nr_user_bufs))
@@ -961,26 +966,26 @@ int io_send_zc_prep(struct io_kiocb *req, const str=
uct io_uring_sqe *sqe)
 	if (req->opcode =3D=3D IORING_OP_SEND_ZC) {
 		if (READ_ONCE(sqe->__pad3[0]))
 			return -EINVAL;
-		zc->addr =3D u64_to_user_ptr(READ_ONCE(sqe->addr2));
-		zc->addr_len =3D READ_ONCE(sqe->addr_len);
+		sr->addr =3D u64_to_user_ptr(READ_ONCE(sqe->addr2));
+		sr->addr_len =3D READ_ONCE(sqe->addr_len);
 	} else {
 		if (unlikely(sqe->addr2 || sqe->file_index))
 			return -EINVAL;
-		if (unlikely(zc->flags & IORING_RECVSEND_FIXED_BUF))
+		if (unlikely(sr->flags & IORING_RECVSEND_FIXED_BUF))
 			return -EINVAL;
 	}
=20
-	zc->buf =3D u64_to_user_ptr(READ_ONCE(sqe->addr));
-	zc->len =3D READ_ONCE(sqe->len);
-	zc->msg_flags =3D READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
-	if (zc->msg_flags & MSG_DONTWAIT)
+	sr->buf =3D u64_to_user_ptr(READ_ONCE(sqe->addr));
+	sr->len =3D READ_ONCE(sqe->len);
+	sr->msg_flags =3D READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
+	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |=3D REQ_F_NOWAIT;
=20
-	zc->done_io =3D 0;
+	sr->done_io =3D 0;
=20
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
-		zc->msg_flags |=3D MSG_CMSG_COMPAT;
+		sr->msg_flags |=3D MSG_CMSG_COMPAT;
 #endif
 	return 0;
 }
@@ -1046,7 +1051,8 @@ static int io_sg_from_iter(struct sock *sk, struct =
sk_buff *skb,
 int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct sockaddr_storage __address;
-	struct io_sr_msg *zc =3D io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_send_zc_msg *zc =3D io_kiocb_to_cmd(req, struct io_send_zc_ms=
g);
+	struct io_sr_msg *sr =3D &zc->sr;
 	struct msghdr msg;
 	struct iovec iov;
 	struct socket *sock;
@@ -1064,42 +1070,42 @@ int io_send_zc(struct io_kiocb *req, unsigned int=
 issue_flags)
 	msg.msg_controllen =3D 0;
 	msg.msg_namelen =3D 0;
=20
-	if (zc->addr) {
+	if (sr->addr) {
 		if (req_has_async_data(req)) {
 			struct io_async_msghdr *io =3D req->async_data;
=20
 			msg.msg_name =3D &io->addr;
 		} else {
-			ret =3D move_addr_to_kernel(zc->addr, zc->addr_len, &__address);
+			ret =3D move_addr_to_kernel(sr->addr, sr->addr_len, &__address);
 			if (unlikely(ret < 0))
 				return ret;
 			msg.msg_name =3D (struct sockaddr *)&__address;
 		}
-		msg.msg_namelen =3D zc->addr_len;
+		msg.msg_namelen =3D sr->addr_len;
 	}
=20
 	if (!(req->flags & REQ_F_POLLED) &&
-	    (zc->flags & IORING_RECVSEND_POLL_FIRST))
+	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return io_setup_async_addr(req, &__address, issue_flags);
=20
-	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
+	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
 		ret =3D io_import_fixed(WRITE, &msg.msg_iter, req->imu,
-					(u64)(uintptr_t)zc->buf, zc->len);
+					(u64)(uintptr_t)sr->buf, sr->len);
 		if (unlikely(ret))
 			return ret;
 		msg.sg_from_iter =3D io_sg_from_iter;
 	} else {
-		ret =3D import_single_range(WRITE, zc->buf, zc->len, &iov,
+		ret =3D import_single_range(WRITE, sr->buf, sr->len, &iov,
 					  &msg.msg_iter);
 		if (unlikely(ret))
 			return ret;
-		ret =3D io_notif_account_mem(zc->notif, zc->len);
+		ret =3D io_notif_account_mem(zc->notif, sr->len);
 		if (unlikely(ret))
 			return ret;
 		msg.sg_from_iter =3D io_sg_from_iter_iovec;
 	}
=20
-	msg_flags =3D zc->msg_flags | MSG_ZEROCOPY;
+	msg_flags =3D sr->msg_flags | MSG_ZEROCOPY;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		msg_flags |=3D MSG_DONTWAIT;
 	if (msg_flags & MSG_WAITALL)
@@ -1114,9 +1120,9 @@ int io_send_zc(struct io_kiocb *req, unsigned int i=
ssue_flags)
 			return io_setup_async_addr(req, &__address, issue_flags);
=20
 		if (ret > 0 && io_net_retry(sock, msg.msg_flags)) {
-			zc->len -=3D ret;
-			zc->buf +=3D ret;
-			zc->done_io +=3D ret;
+			sr->len -=3D ret;
+			sr->buf +=3D ret;
+			sr->done_io +=3D ret;
 			req->flags |=3D REQ_F_PARTIAL_IO;
 			return io_setup_async_addr(req, &__address, issue_flags);
 		}
@@ -1126,9 +1132,9 @@ int io_send_zc(struct io_kiocb *req, unsigned int i=
ssue_flags)
 	}
=20
 	if (ret >=3D 0)
-		ret +=3D zc->done_io;
-	else if (zc->done_io)
-		ret =3D zc->done_io;
+		ret +=3D sr->done_io;
+	else if (sr->done_io)
+		ret =3D sr->done_io;
=20
 	/*
 	 * If we're in io-wq we can't rely on tw ordering guarantees, defer
@@ -1144,8 +1150,9 @@ int io_send_zc(struct io_kiocb *req, unsigned int i=
ssue_flags)
=20
 int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_sr_msg *sr =3D io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_send_zc_msg *zc =3D io_kiocb_to_cmd(req, struct io_send_zc_ms=
g);
 	struct io_async_msghdr iomsg, *kmsg;
+	struct io_sr_msg *sr =3D &zc->sr;
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret =3D 0;
@@ -1175,7 +1182,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned in=
t issue_flags)
 	if (flags & MSG_WAITALL)
 		min_ret =3D iov_iter_count(&kmsg->msg.msg_iter);
=20
-	kmsg->msg.msg_ubuf =3D &io_notif_to_data(sr->notif)->uarg;
+	kmsg->msg.msg_ubuf =3D &io_notif_to_data(zc->notif)->uarg;
 	kmsg->msg.sg_from_iter =3D io_sg_from_iter_iovec;
 	ret =3D __sys_sendmsg_sock(sock, &kmsg->msg, flags);
=20
@@ -1209,7 +1216,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned in=
t issue_flags)
 	 * flushing notif to io_send_zc_cleanup()
 	 */
 	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
-		io_notif_flush(sr->notif);
+		io_notif_flush(zc->notif);
 		req->flags &=3D ~REQ_F_NEED_CLEANUP;
 	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
--=20
2.30.2

