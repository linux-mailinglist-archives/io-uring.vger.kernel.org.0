Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091E46F48AD
	for <lists+io-uring@lfdr.de>; Tue,  2 May 2023 18:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbjEBQyR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 May 2023 12:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234389AbjEBQyM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 May 2023 12:54:12 -0400
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B413A86
        for <io-uring@vger.kernel.org>; Tue,  2 May 2023 09:54:03 -0700 (PDT)
Received: by devbig1114.prn1.facebook.com (Postfix, from userid 425415)
        id 2703E4CF6CC3; Tue,  2 May 2023 09:53:47 -0700 (PDT)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org,
        Olivier Langlois <olivier@trillion01.com>
Subject: [PATCH v12 3/5] io-uring: add sqpoll support for napi busy poll
Date:   Tue,  2 May 2023 09:53:30 -0700
Message-Id: <20230502165332.2075091-4-shr@devkernel.io>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230502165332.2075091-1-shr@devkernel.io>
References: <20230502165332.2075091-1-shr@devkernel.io>
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

This adds the sqpoll support to the io-uring napi.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
Suggested-by: Olivier Langlois <olivier@trillion01.com>
---
 io_uring/napi.c   | 24 ++++++++++++++++++++++++
 io_uring/napi.h   |  2 ++
 io_uring/sqpoll.c |  4 ++++
 3 files changed, 30 insertions(+)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index 76bcabeb7ef0..491d028e8146 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -257,4 +257,28 @@ void __io_napi_busy_loop(struct io_ring_ctx *ctx, st=
ruct io_wait_queue *iowq)
 		io_napi_blocking_busy_loop(ctx, iowq);
 }
=20
+/*
+ * io_napi_sqpoll_busy_poll() - busy poll loop for sqpoll
+ * @ctx: pointer to io-uring context structure
+ *
+ * Splice of the napi list and execute the napi busy poll loop.
+ */
+int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
+{
+	LIST_HEAD(napi_list);
+	bool is_stale =3D false;
+
+	if (!READ_ONCE(ctx->napi_busy_poll_to))
+		return 0;
+	if (list_empty_careful(&ctx->napi_list))
+		return 0;
+
+	rcu_read_lock();
+	is_stale =3D __io_napi_do_busy_loop(ctx, NULL);
+	rcu_read_unlock();
+
+	io_napi_remove_stale(ctx, is_stale);
+	return 1;
+}
+
 #endif
diff --git a/io_uring/napi.h b/io_uring/napi.h
index 1bdf8442081f..0484dfd9a396 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -17,6 +17,7 @@ void __io_napi_add(struct io_ring_ctx *ctx, struct file=
 *file);
 void __io_napi_adjust_timeout(struct io_ring_ctx *ctx,
 		struct io_wait_queue *iowq, struct timespec64 *ts);
 void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *=
iowq);
+int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx);
=20
 static inline bool io_napi(struct io_ring_ctx *ctx)
 {
@@ -77,6 +78,7 @@ static inline void io_napi_add(struct io_kiocb *req)
=20
 #define io_napi_adjust_timeout(ctx, iowq, ts) do {} while (0)
 #define io_napi_busy_loop(ctx, iowq) do {} while (0)
+#define io_napi_sqpoll_busy_poll(ctx) (0)
=20
 #endif
=20
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 9db4bc1f521a..0c8d53ef134a 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -15,6 +15,7 @@
 #include <uapi/linux/io_uring.h>
=20
 #include "io_uring.h"
+#include "napi.h"
 #include "sqpoll.h"
=20
 #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
@@ -193,6 +194,9 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bo=
ol cap_entries)
 			ret =3D io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
=20
+		if (io_napi(ctx))
+			ret +=3D io_napi_sqpoll_busy_poll(ctx);
+
 		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
 			wake_up(&ctx->sqo_sq_wait);
 		if (creds)
--=20
2.39.1

