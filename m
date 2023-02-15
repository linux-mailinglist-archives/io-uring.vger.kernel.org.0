Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFE069828D
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 18:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjBORp0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 12:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjBORpX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 12:45:23 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB163C785
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 09:45:14 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id 24C2671625B0; Wed, 15 Feb 2023 09:45:01 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org
Subject: [PATCH v9 1/5] io-uring: move io_wait_queue definition to header file
Date:   Wed, 15 Feb 2023 09:44:48 -0800
Message-Id: <20230215174452.3373598-2-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230215174452.3373598-1-shr@devkernel.io>
References: <20230215174452.3373598-1-shr@devkernel.io>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP autolearn=no autolearn_force=no
        version=3.4.6
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
index 0e42160a3051..5d6aa783fb97 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2468,33 +2468,12 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsig=
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
index 2711865f1e19..021f9af37c74 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -27,6 +27,28 @@ enum {
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
2.30.2

