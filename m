Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2B96EE79E
	for <lists+io-uring@lfdr.de>; Tue, 25 Apr 2023 20:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234454AbjDYSjp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Apr 2023 14:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbjDYSjo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Apr 2023 14:39:44 -0400
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CD4146CC
        for <io-uring@vger.kernel.org>; Tue, 25 Apr 2023 11:39:43 -0700 (PDT)
Received: by devbig1114.prn1.facebook.com (Postfix, from userid 425415)
        id 3793B442E9BE; Tue, 25 Apr 2023 11:18:51 -0700 (PDT)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org
Subject: [PATCH v10 1/5] io-uring: move io_wait_queue definition to header file
Date:   Tue, 25 Apr 2023 11:18:41 -0700
Message-Id: <20230425181845.2813854-2-shr@devkernel.io>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230425181845.2813854-1-shr@devkernel.io>
References: <20230425181845.2813854-1-shr@devkernel.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This moves the definition of the io_wait_queue structure to the header
file so it can be also used from other files.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 io_uring/io_uring.c | 21 ---------------------
 io_uring/io_uring.h | 22 ++++++++++++++++++++++
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3d43df8f1e4e..efbd6c9c56e5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2516,33 +2516,12 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsig=
ned int nr)
 	return ret;
 }
=20
-struct io_wait_queue {
-	struct wait_queue_entry wq;
-	struct io_ring_ctx *ctx;
-	unsigned cq_tail;
-	unsigned nr_timeouts;
-	ktime_t timeout;
-};
-
 static inline bool io_has_work(struct io_ring_ctx *ctx)
 {
 	return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq) ||
 	       !llist_empty(&ctx->work_llist);
 }
=20
-static inline bool io_should_wake(struct io_wait_queue *iowq)
-{
-	struct io_ring_ctx *ctx =3D iowq->ctx;
-	int dist =3D READ_ONCE(ctx->rings->cq.tail) - (int) iowq->cq_tail;
-
-	/*
-	 * Wake up if we have enough events, or if a timeout occurred since we
-	 * started waiting. For timeouts, we always want to return to userspace=
,
-	 * regardless of event count.
-	 */
-	return dist >=3D 0 || atomic_read(&ctx->cq_timeouts) !=3D iowq->nr_time=
outs;
-}
-
 static int io_wake_function(struct wait_queue_entry *curr, unsigned int =
mode,
 			    int wake_flags, void *key)
 {
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 25515d69d205..5f04bd47562a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -41,6 +41,28 @@ enum {
 	IOU_STOP_MULTISHOT	=3D -ECANCELED,
 };
=20
+struct io_wait_queue {
+	struct wait_queue_entry wq;
+	struct io_ring_ctx *ctx;
+	unsigned cq_tail;
+	unsigned nr_timeouts;
+	ktime_t timeout;
+
+};
+
+static inline bool io_should_wake(struct io_wait_queue *iowq)
+{
+	struct io_ring_ctx *ctx =3D iowq->ctx;
+	int dist =3D READ_ONCE(ctx->rings->cq.tail) - (int) iowq->cq_tail;
+
+	/*
+	 * Wake up if we have enough events, or if a timeout occurred since we
+	 * started waiting. For timeouts, we always want to return to userspace=
,
+	 * regardless of event count.
+	 */
+	return dist >=3D 0 || atomic_read(&ctx->cq_timeouts) !=3D iowq->nr_time=
outs;
+}
+
 struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow=
);
 bool io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
--=20
2.39.1

