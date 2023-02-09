Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03C6691429
	for <lists+io-uring@lfdr.de>; Fri, 10 Feb 2023 00:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjBIXC1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 18:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbjBIXCY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 18:02:24 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7374E5EBDD
        for <io-uring@vger.kernel.org>; Thu,  9 Feb 2023 15:02:17 -0800 (PST)
Received: by dev0134.prn3.facebook.com (Postfix, from userid 425415)
        id BBA906AB6777; Thu,  9 Feb 2023 15:02:01 -0800 (PST)
From:   Stefan Roesch <shr@devkernel.io>
To:     io-uring@vger.kernel.org, kernel-team@fb.com
Cc:     shr@devkernel.io, axboe@kernel.dk, ammarfaizi2@gnuweeb.org,
        Olivier Langlois <olivier@trillion01.com>
Subject: [PATCH v8 5/7] io-uring: add sqpoll support for napi busy poll
Date:   Thu,  9 Feb 2023 15:01:42 -0800
Message-Id: <20230209230144.465620-6-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230209230144.465620-1-shr@devkernel.io>
References: <20230209230144.465620-1-shr@devkernel.io>
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

This adds the sqpoll support to the io-uring napi.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
Suggested-by: Olivier Langlois <olivier@trillion01.com>
---
 io_uring/napi.c   | 25 +++++++++++++++++++++++++
 io_uring/napi.h   |  2 ++
 io_uring/sqpoll.c |  4 ++++
 3 files changed, 31 insertions(+)

diff --git a/io_uring/napi.c b/io_uring/napi.c
index c9e2afae382d..038957b46a0e 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -278,4 +278,29 @@ void io_napi_end_busy_loop(struct io_ring_ctx *ctx, =
struct io_wait_queue *iowq,
 		io_napi_merge_lists(ctx, napi_list);
 }
=20
+/*
+ * io_napi_sqpoll_busy_poll() - busy poll loop for sqpoll
+ * @ctx: pointer to io-uring context structure
+ * @napi_list: pointer to head of napi list
+ *
+ * Splice of the napi list and execute the napi busy poll loop.
+ */
+int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx, struct list_head *=
napi_list)
+{
+	int ret =3D 0;
+
+	spin_lock(&ctx->napi_lock);
+	list_splice_init(&ctx->napi_list, napi_list);
+	spin_unlock(&ctx->napi_lock);
+
+	if (!list_empty(napi_list) &&
+	    READ_ONCE(ctx->napi_busy_poll_to) > 0 &&
+	    io_napi_busy_loop(napi_list, ctx->napi_prefer_busy_poll)) {
+		io_napi_merge_lists(ctx, napi_list);
+		ret =3D 1;
+	}
+
+	return ret;
+}
+
 #endif
diff --git a/io_uring/napi.h b/io_uring/napi.h
index 0672592cfb79..23a6df32805f 100644
--- a/io_uring/napi.h
+++ b/io_uring/napi.h
@@ -23,6 +23,7 @@ void io_napi_adjust_busy_loop_timeout(struct io_ring_ct=
x *ctx,
 			struct timespec64 *ts);
 void io_napi_end_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue=
 *iowq,
 			struct list_head *napi_list);
+int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx, struct list_head *=
napi_list);
=20
 #else
=20
@@ -43,6 +44,7 @@ static inline void io_napi_add(struct io_kiocb *req)
 #define io_napi_setup_busy_loop(ctx, iowq, napi_list) do {} while (0)
 #define io_napi_adjust_busy_loop_timeout(ctx, iowq, napi_list, ts) do {}=
 while (0)
 #define io_napi_end_busy_loop(ctx, iowq, napi_list) do {} while (0)
+#define io_napi_sqpoll_busy_poll(ctx, napi_list) (0)
=20
 #endif
=20
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 0119d3f1a556..90fdbd87434a 100644
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
@@ -168,6 +169,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bo=
ol cap_entries)
 {
 	unsigned int to_submit;
 	int ret =3D 0;
+	NAPI_LIST_HEAD(local_napi_list);
=20
 	to_submit =3D io_sqring_entries(ctx);
 	/* if we're handling multiple rings, cap submit size for fairness */
@@ -193,6 +195,8 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bo=
ol cap_entries)
 			ret =3D io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
=20
+		ret +=3D io_napi_sqpoll_busy_poll(ctx, &local_napi_list);
+
 		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
 			wake_up(&ctx->sqo_sq_wait);
 		if (creds)
--=20
2.30.2

