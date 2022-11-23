Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0CB635B12
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237669AbiKWLHp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237746AbiKWLHI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:07:08 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D251B2DF6
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:54 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 2ANB59KA009094
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=mCk5YgmYT77ygWxC1yw8ZOTOMT0u0chAtLdcatMD1o0=;
 b=g6UOGEasdbhDygdAxZyVbIabF+JKQyFcmXD6FOX/FoMg5RRI4fdT7SA6y9QEYZiwfSNt
 6ybJz64PBr2S7BASdCbjSAWmB7Ti3uNaERdT4h6kFzaJPEhbj+XzoohfIlsFjbaSP58Q
 F2hD3gC5ibK1VeYq5azEcqzfg22XXLJVk12DJ2cA47PEQU6z01D19Z4p4As7/4oer2mP
 svZJMfKuY0VlrS15Fh4as454uYCdQhq4kPpEZvtemvi1A42Ap+UnisU+DCgDaXrytA+r
 gmyano7g0oWRfKH2wFBx82zTtDUM1ofxTtcNGC+6qOJTEKDueWeWZ+Qw2gvBu8GKDA9g sQ== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3m0kkdut8r-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:54 -0800
Received: from twshared0705.02.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 03:06:53 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 15EC2A0804DF; Wed, 23 Nov 2022 03:06:27 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v2 12/13] io_uring: remove overflow param from io_post_aux_cqe
Date:   Wed, 23 Nov 2022 03:06:13 -0800
Message-ID: <20221123110614.3297343-13-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221123110614.3297343-1-dylany@meta.com>
References: <20221123110614.3297343-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: OIWLvfWLm3mGira4uL-JAKKXBn-cw0E-
X-Proofpoint-GUID: OIWLvfWLm3mGira4uL-JAKKXBn-cw0E-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
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
index 6e1139a11fbf..87ea497590b5 100644
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
index 4519d91008de..d61dd9c5030a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -32,8 +32,7 @@ int __io_run_local_work(struct io_ring_ctx *ctx, bool *=
locked);
 int io_run_local_work(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
 void __io_req_complete(struct io_kiocb *req, unsigned issue_flags);
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

