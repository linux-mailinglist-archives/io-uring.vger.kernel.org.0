Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99DC0637549
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 10:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiKXJgj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 04:36:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiKXJge (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 04:36:34 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521E8122954
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:33 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 2ANHsBM4030099
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=jmOelkJnNh5qVKmW4sT7iMOybubcd1zgJvtXLSygZ1o=;
 b=nReQ+TAg5X4FaP3daLRc47xEeQO+jpRY5nvtXch9uAh+SGEMvpX19J272cJMig633xrW
 FooAwTVxnMfozRhE9IGF682VdLiCNgm/eBrjFODDt9dA5JPOPMkoEoBTB1kzEYZqXD1X
 D1ZAkGp76+lQMdO/cHXFM1egPBJqoiO4UTh56HjcXPHevzp/Th3IzqZC//+qiDz0fUMQ
 Vc8ItCHgY9+sr71prX3gAMWxqg6+gmDPK3fSNy8/rHebXUg9dPe8qF0IbcCtsgZFP8Bv
 F7T+a9+HkX3aPK784neqA+td8nM8FRgESjeajFCY2PIOX8SiMFAvvn4td+0lZ8W5DFZ2 jw== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net (PPS) with ESMTPS id 3m1c7rhj33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 01:36:32 -0800
Received: from twshared41876.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 24 Nov 2022 01:36:31 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id E93EAA173A16; Thu, 24 Nov 2022 01:36:20 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v3 5/9] io_uring: add io_aux_cqe which allows deferred completion
Date:   Thu, 24 Nov 2022 01:35:55 -0800
Message-ID: <20221124093559.3780686-6-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221124093559.3780686-1-dylany@meta.com>
References: <20221124093559.3780686-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: IfeZgjiiZen9I_TWB9DLPdhWtuLubLZS
X-Proofpoint-ORIG-GUID: IfeZgjiiZen9I_TWB9DLPdhWtuLubLZS
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

Use the just introduced deferred post cqe completion state when possible
in io_aux_cqe. If not possible fallback to io_post_aux_cqe.

This introduces a complication because of allow_overflow. For deferred
completions we cannot know without locking the completion_lock if it will
overflow (and even if we locked it, another post could sneak in and cause
this cqe to be in overflow).
However since overflow protection is mostly a best effort defence in dept=
h
to prevent infinite loops of CQEs for poll, just checking the overflow bi=
t
is going to be good enough and will result in at most 16 (array size of
deferred cqes) overflows.

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Dylan Yudaken <dylany@meta.com>
---
 io_uring/io_uring.c | 34 ++++++++++++++++++++++++++++++++++
 io_uring/io_uring.h |  2 ++
 io_uring/net.c      |  7 ++++---
 io_uring/poll.c     |  4 ++--
 4 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 53b61b5cde80..4f48e8a919a2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -830,6 +830,40 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx,
 	return filled;
 }
=20
+bool io_aux_cqe(struct io_ring_ctx *ctx, bool defer, u64 user_data, s32 =
res, u32 cflags,
+		bool allow_overflow)
+{
+	struct io_uring_cqe *cqe;
+	unsigned int length;
+
+	if (!defer)
+		return io_post_aux_cqe(ctx, user_data, res, cflags, allow_overflow);
+
+	length =3D ARRAY_SIZE(ctx->submit_state.cqes);
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	if (ctx->submit_state.cqes_count =3D=3D length) {
+		io_cq_lock(ctx);
+		__io_flush_post_cqes(ctx);
+		/* no need to flush - flush is deferred */
+		spin_unlock(&ctx->completion_lock);
+	}
+
+	/* For defered completions this is not as strict as it is otherwise,
+	 * however it's main job is to prevent unbounded posted completions,
+	 * and in that it works just as well.
+	 */
+	if (!allow_overflow && test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_c=
q))
+		return false;
+
+	cqe =3D &ctx->submit_state.cqes[ctx->submit_state.cqes_count++];
+	cqe->user_data =3D user_data;
+	cqe->res =3D res;
+	cqe->flags =3D cflags;
+	return true;
+}
+
 static void __io_req_complete_post(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx =3D req->ctx;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index a26d5aa7f3f3..dd02adf3d0df 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -36,6 +36,8 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_=
data, s32 res, u32 cflags
 		     bool allow_overflow);
 bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u3=
2 cflags,
 		     bool allow_overflow);
+bool io_aux_cqe(struct io_ring_ctx *ctx, bool defer, u64 user_data, s32 =
res, u32 cflags,
+		bool allow_overflow);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
=20
 static inline void io_req_complete_post_tw(struct io_kiocb *req, bool *l=
ocked)
diff --git a/io_uring/net.c b/io_uring/net.c
index 0de6f78ad978..90342dcb6b1d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -601,8 +601,8 @@ static inline bool io_recv_finish(struct io_kiocb *re=
q, int *ret,
 	}
=20
 	if (!mshot_finished) {
-		if (io_post_aux_cqe(req->ctx, req->cqe.user_data, *ret,
-				    cflags | IORING_CQE_F_MORE, true)) {
+		if (io_aux_cqe(req->ctx, issue_flags & IO_URING_F_COMPLETE_DEFER,
+			       req->cqe.user_data, *ret, cflags | IORING_CQE_F_MORE, true)) {
 			io_recv_prep_retry(req);
 			return false;
 		}
@@ -1320,7 +1320,8 @@ int io_accept(struct io_kiocb *req, unsigned int is=
sue_flags)
=20
 	if (ret < 0)
 		return ret;
-	if (io_post_aux_cqe(ctx, req->cqe.user_data, ret, IORING_CQE_F_MORE, tr=
ue))
+	if (io_aux_cqe(ctx, issue_flags & IO_URING_F_COMPLETE_DEFER,
+		       req->cqe.user_data, ret, IORING_CQE_F_MORE, true))
 		goto retry;
=20
 	return -ECANCELED;
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 4bd43e6f5b72..922c1a366c41 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -252,8 +252,8 @@ static int io_poll_check_events(struct io_kiocb *req,=
 bool *locked)
 			__poll_t mask =3D mangle_poll(req->cqe.res &
 						    req->apoll_events);
=20
-			if (!io_post_aux_cqe(ctx, req->cqe.user_data,
-					     mask, IORING_CQE_F_MORE, false)) {
+			if (!io_aux_cqe(ctx, *locked, req->cqe.user_data,
+					mask, IORING_CQE_F_MORE, false)) {
 				io_req_set_res(req, mask, 0);
 				return IOU_POLL_REMOVE_POLL_USE_RES;
 			}
--=20
2.30.2

