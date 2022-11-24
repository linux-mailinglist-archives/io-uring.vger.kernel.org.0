Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2039C637551
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 10:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiKXJgt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 04:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiKXJgq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 04:36:46 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2B412296E
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:44 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 2ANHsBhW030115
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=iN/SL2jD0KHAuMW4C6ATqB31yLcyixW7ZJWCOlrAY5A=;
 b=faPKYbxoWBsXMLAkii4rfbrOoheZ7MEyy1tJv9CQvB5mdv8nukVgRx8UDk1U/jovNqe8
 HArKxqoopaCtkP9ydELrPKbyuu2pHLkWwdkq/lY6lgv7KNT1j6Zu9cFKravxzVJCOlmZ
 LIJ8QZVSKob3HVEGAqG0CZhNdKumZ41KM6DLv7JmFOYtDYohQLOvrobCsfzW4GrXcne+
 9bQdVc5Ke1Rax/bRDz8qUCGZGYLHEQVyh+2Vk0jHvUvj+hC8p3thGejpMPAIvLiw2bR0
 LuYPZHC7VCApKz43Wiam/LzzFUgvLHPm4QHdozYvRF4DML8dt+Ypsbll0rSDBbyIXOG3 Bw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3m1c7rhj3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:44 -0800
Received: from twshared2003.08.ash9.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 01:36:42 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 0DBEFA173A1C; Thu, 24 Nov 2022 01:36:21 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v3 8/9] io_uring: remove overflow param from io_post_aux_cqe
Date:   Thu, 24 Nov 2022 01:35:58 -0800
Message-ID: <20221124093559.3780686-9-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221124093559.3780686-1-dylany@meta.com>
References: <20221124093559.3780686-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: PYPK1MMlYVAhvatOFneQsLjc29HVoRt1
X-Proofpoint-ORIG-GUID: PYPK1MMlYVAhvatOFneQsLjc29HVoRt1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_07,2022-11-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The only call sites which would not allow overflow are also call sites
which would use the io_aux_cqe as they care about ordering.

So remove this parameter from io_post_aux_cqe.

Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 12 ++++++++----
 io_uring/io_uring.h |  3 +--
 io_uring/msg_ring.c |  4 ++--
 io_uring/rsrc.c     |  4 ++--
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e937e5d68b22..f0e5ae7740cf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -820,9 +820,8 @@ static void __io_flush_post_cqes(struct io_ring_ctx *=
ctx)
 	state->cqes_count =3D 0;
 }
=20
-bool io_post_aux_cqe(struct io_ring_ctx *ctx,
-		     u64 user_data, s32 res, u32 cflags,
-		     bool allow_overflow)
+static bool __io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s3=
2 res, u32 cflags,
+			      bool allow_overflow)
 {
 	bool filled;
=20
@@ -832,6 +831,11 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx,
 	return filled;
 }
=20
+bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags)
+{
+	return __io_post_aux_cqe(ctx, user_data, res, cflags, true);
+}
+
 bool io_aux_cqe(struct io_ring_ctx *ctx, bool defer, u64 user_data, s32 =
res, u32 cflags,
 		bool allow_overflow)
 {
@@ -839,7 +843,7 @@ bool io_aux_cqe(struct io_ring_ctx *ctx, bool defer, =
u64 user_data, s32 res, u32
 	unsigned int length;
=20
 	if (!defer)
-		return io_post_aux_cqe(ctx, user_data, res, cflags, allow_overflow);
+		return __io_post_aux_cqe(ctx, user_data, res, cflags, allow_overflow);
=20
 	length =3D ARRAY_SIZE(ctx->submit_state.cqes);
=20
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 46694f40bf72..dcb8e3468f1d 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -32,8 +32,7 @@ int __io_run_local_work(struct io_ring_ctx *ctx, bool *=
locked);
 int io_run_local_work(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
 void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags);
-bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags,
-		     bool allow_overflow);
+bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags);
 bool io_aux_cqe(struct io_ring_ctx *ctx, bool defer, u64 user_data, s32 =
res, u32 cflags,
 		bool allow_overflow);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
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
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 187f1c83e779..133608200769 100644
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

