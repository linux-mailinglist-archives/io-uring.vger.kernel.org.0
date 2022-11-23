Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A93635B0B
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237642AbiKWLHo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237744AbiKWLHI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:07:08 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A9A1B13
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:54 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 2ANB59K9009094
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=s2048-2021-q4;
 bh=Z/qs6/5RRxSeziWegAEgCbtVCatuTGgy+6L8E6H9i1Y=;
 b=eQIvvN2JNVVW1soG4pqRjwxJ/9gvicN46oRtRiU/IMaR60dZHfgjOrtMxjYiok1kwcWy
 IwdIKu/u540Pr8A3Mbogd75graQQJhYNMHpOCTkWpGdYFBAQZK29K4/2krNzH5gcA1Bj
 5b5q3AQy/h/pCww6qt+PuazrR5t2jPXxCwz8/I3FKDRt9UrrjtQUwoq5qA/rDiFUpRfp
 haQOE6uqbzRmyNK/XEwCTuqGKn6RfM3nCA2ni2D/R9ZG2hC1Dwh7VsFYhuCqdIeyWjhl
 WPDvBa/rieaAaNARTB0yH824lhUy0GrHmmO4DWK0qvwHo2hAhGqV2sTjust/V4qvCIBm 4A== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3m0kkdut8r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:06:53 -0800
Received: from twshared2003.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 03:06:52 -0800
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id A93C3A0804D9; Wed, 23 Nov 2022 03:06:27 -0800 (PST)
From:   Dylan Yudaken <dylany@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <kernel-team@fb.com>,
        Dylan Yudaken <dylany@meta.com>
Subject: [PATCH for-next v2 09/13] io_uring: add io_aux_cqe which allows deferred completion
Date:   Wed, 23 Nov 2022 03:06:10 -0800
Message-ID: <20221123110614.3297343-10-dylany@meta.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221123110614.3297343-1-dylany@meta.com>
References: <20221123110614.3297343-1-dylany@meta.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 7g3ZnYyspYyvOIjw2yis4l5CDBysdkhi
X-Proofpoint-GUID: 7g3ZnYyspYyvOIjw2yis4l5CDBysdkhi
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
index 39f80d68d31c..37b195d85f32 100644
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
+	cqe  =3D ctx->submit_state.cqes + ctx->submit_state.cqes_count++;
+	cqe->user_data =3D user_data;
+	cqe->res =3D res;
+	cqe->flags =3D cflags;
+	return true;
+}
+
 static void __io_req_complete_put(struct io_kiocb *req)
 {
 	/*
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 3c3a93493239..e075c4fb70c9 100644
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
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *n=
pages);
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

