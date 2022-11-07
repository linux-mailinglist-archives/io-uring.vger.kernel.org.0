Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C1461F3BD
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 13:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbiKGMw6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 07:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiKGMw5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 07:52:57 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF9CB4A9
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 04:52:56 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A75wKbe029735
        for <io-uring@vger.kernel.org>; Mon, 7 Nov 2022 04:52:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=HDr+4RsGdo+XXgaVFk6OYydLnwmmmOZvWla8izAeGXE=;
 b=IWsfanZ0bdx0kkSFlnAz3iinVNttbUr6Du9bT9LPJAtOboKJF8nqkyEZ8uxg6+NZrUpD
 YkqVFbUO4cv8gqrNqGWlH/K7y/00glMF7I/YhqhIxvh/KY+vmMzeHVTRjj/1nToGL8el
 oAxmTZbzG1VckzYcY5ELpPF0EIMpQfPMHVvZjGVx+6FhV8gQZpqJMhf5m4vxI31fssBm
 L9fDZIvroBtMV7jbeMRSqcG7nOehQMV8KjJtTI/+S+GN34PJyPx/VCs7tG0IamZxbk4B
 SzvmSBbX7Oy8kT2P3wAE3Nit4/fnWk1/qPdrHc3YCH9h+rihoJbt3ret7ZolqOMBmzuj wQ== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3knmxsny26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 04:52:56 -0800
Received: from twshared5476.02.ash7.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 04:52:55 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 53A9890D69EE; Mon,  7 Nov 2022 04:52:45 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next 4/4] io_uring: remove allow_overflow parameter
Date:   Mon, 7 Nov 2022 04:52:36 -0800
Message-ID: <20221107125236.260132-5-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221107125236.260132-1-dylany@meta.com>
References: <20221107125236.260132-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: o9VKWS51CVHWzEAeHr4QXypz5c258kqo
X-Proofpoint-GUID: o9VKWS51CVHWzEAeHr4QXypz5c258kqo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_05,2022-11-07_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It is now always true, so just remove it

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 13 ++++---------
 io_uring/io_uring.h |  6 ++----
 io_uring/msg_ring.c |  4 ++--
 io_uring/net.c      |  4 ++--
 io_uring/poll.c     |  2 +-
 io_uring/rsrc.c     |  4 ++--
 6 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index db0dec120f09..47631cab6517 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -773,8 +773,7 @@ struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx =
*ctx, bool overflow)
 	return &rings->cqes[off];
 }
=20
-bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags,
-		     bool allow_overflow)
+bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags)
 {
 	struct io_uring_cqe *cqe;
=20
@@ -800,20 +799,16 @@ bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 u=
ser_data, s32 res, u32 cflags
 		return true;
 	}
=20
-	if (allow_overflow)
-		return io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
-
-	return false;
+	return io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
 }
=20
 bool io_post_aux_cqe(struct io_ring_ctx *ctx,
-		     u64 user_data, s32 res, u32 cflags,
-		     bool allow_overflow)
+		     u64 user_data, s32 res, u32 cflags)
 {
 	bool filled;
=20
 	io_cq_lock(ctx);
-	filled =3D io_fill_cqe_aux(ctx, user_data, res, cflags, allow_overflow)=
;
+	filled =3D io_fill_cqe_aux(ctx, user_data, res, cflags);
 	io_cq_unlock_post(ctx);
 	return filled;
 }
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e99a79f2df9b..d14534a2f8e7 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -33,10 +33,8 @@ void io_req_complete_failed(struct io_kiocb *req, s32 =
res);
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
 void io_req_complete_post(struct io_kiocb *req);
 void __io_req_complete_post(struct io_kiocb *req);
-bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags,
-		     bool allow_overflow);
-bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags,
-		     bool allow_overflow);
+bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags);
+bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
=20
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *n=
pages);
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 90d2fc6fd80e..afb543aab9f6 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -31,7 +31,7 @@ static int io_msg_ring_data(struct io_kiocb *req)
 	if (msg->src_fd || msg->dst_fd || msg->flags)
 		return -EINVAL;
=20
-	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0, true))
+	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
 		return 0;
=20
 	return -EOVERFLOW;
@@ -116,7 +116,7 @@ static int io_msg_send_fd(struct io_kiocb *req, unsig=
ned int issue_flags)
 	 * completes with -EOVERFLOW, then the sender must ensure that a
 	 * later IORING_OP_MSG_RING delivers the message.
 	 */
-	if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0, true))
+	if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
 		ret =3D -EOVERFLOW;
 out_unlock:
 	io_double_unlock_ctx(ctx, target_ctx, issue_flags);
diff --git a/io_uring/net.c b/io_uring/net.c
index 4b79b61f5597..a1a0b8f223e0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -603,7 +603,7 @@ static inline bool io_recv_finish(struct io_kiocb *re=
q, int *ret,
=20
 	if (!mshot_finished) {
 		if (io_post_aux_cqe(req->ctx, req->cqe.user_data, *ret,
-				    cflags | IORING_CQE_F_MORE, true)) {
+				    cflags | IORING_CQE_F_MORE)) {
 			io_recv_prep_retry(req);
 			return false;
 		}
@@ -1323,7 +1323,7 @@ int io_accept(struct io_kiocb *req, unsigned int is=
sue_flags)
=20
 	if (ret < 0)
 		return ret;
-	if (io_post_aux_cqe(ctx, req->cqe.user_data, ret, IORING_CQE_F_MORE, tr=
ue))
+	if (io_post_aux_cqe(ctx, req->cqe.user_data, ret, IORING_CQE_F_MORE))
 		goto retry;
 	return -ECANCELED;
 }
diff --git a/io_uring/poll.c b/io_uring/poll.c
index e1b8652b670f..d00c8dc76d34 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -244,7 +244,7 @@ static int io_poll_check_events(struct io_kiocb *req,=
 bool *locked)
 						    req->apoll_events);
=20
 			if (!io_post_aux_cqe(ctx, req->cqe.user_data,
-					     mask, IORING_CQE_F_MORE, true))
+					     mask, IORING_CQE_F_MORE))
 				return -ECANCELED;
 		} else {
 			ret =3D io_poll_issue(req, locked);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 55d4ab96fb92..a10c1ea51933 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -170,10 +170,10 @@ static void __io_rsrc_put_work(struct io_rsrc_node =
*ref_node)
 		if (prsrc->tag) {
 			if (ctx->flags & IORING_SETUP_IOPOLL) {
 				mutex_lock(&ctx->uring_lock);
-				io_post_aux_cqe(ctx, prsrc->tag, 0, 0, true);
+				io_post_aux_cqe(ctx, prsrc->tag, 0, 0);
 				mutex_unlock(&ctx->uring_lock);
 			} else {
-				io_post_aux_cqe(ctx, prsrc->tag, 0, 0, true);
+				io_post_aux_cqe(ctx, prsrc->tag, 0, 0);
 			}
 		}
=20
--=20
2.30.2

