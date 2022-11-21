Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEAF9631E9B
	for <lists+io-uring@lfdr.de>; Mon, 21 Nov 2022 11:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiKUKmK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Nov 2022 05:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiKUKmJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Nov 2022 05:42:09 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30387B08DD
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:42:08 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AKKvIub006656
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:42:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=HwgaHRmiIMIwClOOrtv+vxnBg6LeAzsV7GXTaGlkfao=;
 b=Zq6zkarrbxUhc+fL4C3Lcxqy0xlY5k+ZIOxHuAWWsMeU5myd7vM/bBoa78H8Mg90dSm4
 306dJIRGO+FKWfxlv4ZonLKTrQo6pGhZGVG8xSOFAmdMRyiUc4nxRkf8kqLl6JjU/NyN
 MBq+n2AbbEvQYMgrR+GBF9CGERvgdreoXr5ltGH11Z3TGQMnS/my3m/3RK8bjXStz/vW
 3ZRXGjYOh5R5w3S2QMD4U6efpBOMVYy6p3efP32mcFGgztrvOxS1fw9oAtAG52sIWCKj
 rGwLIvhGTgq7b2fuRm/wsfNFc9j2HozHykzl2BaqgPqOMRRPZr93OVXyc30hW9nLW+am Wg== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kxw4xuncb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 21 Nov 2022 02:42:07 -0800
Received: from twshared10308.07.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 02:42:06 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id A0AAF9E66F84; Mon, 21 Nov 2022 02:03:56 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 09/10] io_uring: allow io_post_aux_cqe to defer completion
Date:   Mon, 21 Nov 2022 02:03:52 -0800
Message-ID: <20221121100353.371865-10-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221121100353.371865-1-dylany@meta.com>
References: <20221121100353.371865-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: -WZqH707qgXkRR51rBBYa2Dk2atxoxOs
X-Proofpoint-ORIG-GUID: -WZqH707qgXkRR51rBBYa2Dk2atxoxOs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_06,2022-11-18_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use the just introduced deferred post cqe completion state when possible
in io_post_aux_cqe.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 21 ++++++++++++++++++++-
 io_uring/io_uring.h |  2 +-
 io_uring/msg_ring.c | 10 ++++++----
 io_uring/net.c      | 15 ++++++++-------
 io_uring/poll.c     |  2 +-
 io_uring/rsrc.c     |  4 ++--
 6 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c797f9a75dfe..5c240d01278a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -845,11 +845,30 @@ static void __io_flush_post_cqes(struct io_ring_ctx=
 *ctx)
 	state->cqes_count =3D 0;
 }
=20
-bool io_post_aux_cqe(struct io_ring_ctx *ctx,
+bool io_post_aux_cqe(struct io_ring_ctx *ctx, bool defer,
 		     u64 user_data, s32 res, u32 cflags)
 {
 	bool filled;
=20
+	if (defer) {
+		unsigned int length =3D ARRAY_SIZE(ctx->submit_state.cqes);
+		struct io_uring_cqe *cqe;
+
+		lockdep_assert_held(&ctx->uring_lock);
+
+		if (ctx->submit_state.cqes_count =3D=3D length) {
+			io_cq_lock(ctx);
+			__io_flush_post_cqes(ctx);
+			/* no need to flush - flush is deferred */
+			spin_unlock(&ctx->completion_lock);
+		}
+
+		cqe  =3D ctx->submit_state.cqes + ctx->submit_state.cqes_count++;
+		cqe->user_data =3D user_data;
+		cqe->res =3D res;
+		cqe->flags =3D cflags;
+		return true;
+	}
 	io_cq_lock(ctx);
 	filled =3D io_fill_cqe_aux(ctx, user_data, res, cflags);
 	io_cq_unlock_post(ctx);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index bfe1b5488c25..979a223286bd 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -31,7 +31,7 @@ int __io_run_local_work(struct io_ring_ctx *ctx, bool *=
locked);
 int io_run_local_work(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
-bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags);
+bool io_post_aux_cqe(struct io_ring_ctx *ctx, bool defer, u64 user_data,=
 s32 res, u32 cflags);
 bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
=20
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index afb543aab9f6..c5e831e3dcfc 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -23,7 +23,7 @@ struct io_msg {
 	u32 flags;
 };
=20
-static int io_msg_ring_data(struct io_kiocb *req)
+static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_fla=
gs)
 {
 	struct io_ring_ctx *target_ctx =3D req->file->private_data;
 	struct io_msg *msg =3D io_kiocb_to_cmd(req, struct io_msg);
@@ -31,7 +31,8 @@ static int io_msg_ring_data(struct io_kiocb *req)
 	if (msg->src_fd || msg->dst_fd || msg->flags)
 		return -EINVAL;
=20
-	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+	if (io_post_aux_cqe(target_ctx, false,
+			    msg->user_data, msg->len, 0))
 		return 0;
=20
 	return -EOVERFLOW;
@@ -116,7 +117,8 @@ static int io_msg_send_fd(struct io_kiocb *req, unsig=
ned int issue_flags)
 	 * completes with -EOVERFLOW, then the sender must ensure that a
 	 * later IORING_OP_MSG_RING delivers the message.
 	 */
-	if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+	if (!io_post_aux_cqe(target_ctx, false,
+			     msg->user_data, msg->len, 0))
 		ret =3D -EOVERFLOW;
 out_unlock:
 	io_double_unlock_ctx(ctx, target_ctx, issue_flags);
@@ -153,7 +155,7 @@ int io_msg_ring(struct io_kiocb *req, unsigned int is=
sue_flags)
=20
 	switch (msg->cmd) {
 	case IORING_MSG_DATA:
-		ret =3D io_msg_ring_data(req);
+		ret =3D io_msg_ring_data(req, issue_flags);
 		break;
 	case IORING_MSG_SEND_FD:
 		ret =3D io_msg_send_fd(req, issue_flags);
diff --git a/io_uring/net.c b/io_uring/net.c
index a1a0b8f223e0..8c5154b05344 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -592,8 +592,8 @@ static inline void io_recv_prep_retry(struct io_kiocb=
 *req)
  * Returns true if it is actually finished, or false if it should run
  * again (for multishot).
  */
-static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
-				  unsigned int cflags, bool mshot_finished)
+static inline bool io_recv_finish(struct io_kiocb *req, unsigned int iss=
ue_flags,
+				  int *ret, unsigned int cflags, bool mshot_finished)
 {
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
 		io_req_set_res(req, *ret, cflags);
@@ -602,8 +602,8 @@ static inline bool io_recv_finish(struct io_kiocb *re=
q, int *ret,
 	}
=20
 	if (!mshot_finished) {
-		if (io_post_aux_cqe(req->ctx, req->cqe.user_data, *ret,
-				    cflags | IORING_CQE_F_MORE)) {
+		if (io_post_aux_cqe(req->ctx, issue_flags & IO_URING_F_COMPLETE_DEFER,
+				    req->cqe.user_data, *ret, cflags | IORING_CQE_F_MORE)) {
 			io_recv_prep_retry(req);
 			return false;
 		}
@@ -801,7 +801,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int iss=
ue_flags)
 	if (kmsg->msg.msg_inq)
 		cflags |=3D IORING_CQE_F_SOCK_NONEMPTY;
=20
-	if (!io_recv_finish(req, &ret, cflags, mshot_finished))
+	if (!io_recv_finish(req, issue_flags, &ret, cflags, mshot_finished))
 		goto retry_multishot;
=20
 	if (mshot_finished) {
@@ -900,7 +900,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_=
flags)
 	if (msg.msg_inq)
 		cflags |=3D IORING_CQE_F_SOCK_NONEMPTY;
=20
-	if (!io_recv_finish(req, &ret, cflags, ret <=3D 0))
+	if (!io_recv_finish(req, issue_flags, &ret, cflags, ret <=3D 0))
 		goto retry_multishot;
=20
 	return ret;
@@ -1323,7 +1323,8 @@ int io_accept(struct io_kiocb *req, unsigned int is=
sue_flags)
=20
 	if (ret < 0)
 		return ret;
-	if (io_post_aux_cqe(ctx, req->cqe.user_data, ret, IORING_CQE_F_MORE))
+	if (io_post_aux_cqe(ctx, issue_flags & IO_URING_F_COMPLETE_DEFER,
+			    req->cqe.user_data, ret, IORING_CQE_F_MORE))
 		goto retry;
 	return -ECANCELED;
 }
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 2b77d18a67a7..c4865dd58862 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -245,7 +245,7 @@ static int io_poll_check_events(struct io_kiocb *req,=
 bool *locked)
 			__poll_t mask =3D mangle_poll(req->cqe.res &
 						    req->apoll_events);
=20
-			if (!io_post_aux_cqe(ctx, req->cqe.user_data,
+			if (!io_post_aux_cqe(ctx, *locked, req->cqe.user_data,
 					     mask, IORING_CQE_F_MORE))
 				return -ECANCELED;
 		} else {
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 133608200769..f37cdd8cfc95 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -170,10 +170,10 @@ static void __io_rsrc_put_work(struct io_rsrc_node =
*ref_node)
 		if (prsrc->tag) {
 			if (ctx->flags & IORING_SETUP_IOPOLL) {
 				mutex_lock(&ctx->uring_lock);
-				io_post_aux_cqe(ctx, prsrc->tag, 0, 0);
+				io_post_aux_cqe(ctx, false, prsrc->tag, 0, 0);
 				mutex_unlock(&ctx->uring_lock);
 			} else {
-				io_post_aux_cqe(ctx, prsrc->tag, 0, 0);
+				io_post_aux_cqe(ctx, false, prsrc->tag, 0, 0);
 			}
 		}
=20
--=20
2.30.2

