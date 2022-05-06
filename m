Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA7251D1CD
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 09:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387084AbiEFHEz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 03:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386888AbiEFHEv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 03:04:51 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F0E4DF52;
        Fri,  6 May 2022 00:01:08 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id k1so6565338pll.4;
        Fri, 06 May 2022 00:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jHfXPlMnu+cF/Ne1J4JISZj0/qHHaO/EGUdUthQ8P50=;
        b=ClRlm7Jeu2S19jE//djbOkHvQs7fSPPS9xD2IEQl2aJDc8eT2zehyNymRDfN6FDkVr
         aSpZGRuPf15auLxO+3gQzy6I/h7aJ1UPGrqJZKbJE9QN54S5q7oCVjIk1BCGWvUpZphA
         J39lBnYKChg+JBplECHXtiBjBh+HyML66Um3Kj3T1TWDIv9keWWd6ni3dfWWtvT9zI2T
         dtBNFkNXSXblJvccZqRgd4Uxeda3uzdIOtkCFne8y6YeSWkTX0qnGNDNAQiqYgwOyJp4
         TOGoOYIRATndN7HbwWhBaMayD7gMGDvUaiT0g6yfSGJYmLTe00fsNF+bN9Ep8rGMJxxo
         rvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jHfXPlMnu+cF/Ne1J4JISZj0/qHHaO/EGUdUthQ8P50=;
        b=lO8mM2oWLfK10mntU+ar72yI3TLpLV1/C2CMC50nTqO/1kvBJw9+UNPwUIAlJpbEyV
         fjo1uOTdGTH/nKVlSkoYFil8kx3kKI7zPUqaSru34TxdmRipPpeSOiKzTxM09kLE59vv
         WBYGBdZY7GRe7FdN4Z40RwZKuyWxzV1fpymU58fiNak2TDOVMw9CnfdadDaKVg9HUxYu
         bdAtLfEffwSKCcOrN3KxhtDKJTRxGvcXX2Bcur5xhmOtin/3MZosgGWWC50ZBbj5WXlt
         hkmN3OQRQfukDqCdPSP17dFrBud6si8t0Wc3xTHvS/faQvXu1HliqGuwUN2JXr2+cCkd
         Vr/A==
X-Gm-Message-State: AOAM533RZXt3fHuLuqmtfcj6H3TppKI4KgECAtsPcTnTbyt6hXlwz26a
        Penh0MfEfJip86wAkFl5Cv/Gc1y6dEM=
X-Google-Smtp-Source: ABdhPJy6+kbqk/0tT6Y3X/ztGGuFJFowIrduB7+lS9dMFWQXywhqWTqOyhukad1jRPfbpRjG77pdbg==
X-Received: by 2002:a17:902:ecc4:b0:15e:a670:6056 with SMTP id a4-20020a170902ecc400b0015ea6706056mr2083042plh.108.1651820468384;
        Fri, 06 May 2022 00:01:08 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id bh2-20020a170902a98200b0015e8d4eb2desm813112plb.296.2022.05.06.00.01.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 May 2022 00:01:08 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] io_uring: let fast poll support multishot
Date:   Fri,  6 May 2022 15:01:00 +0800
Message-Id: <20220506070102.26032-4-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220506070102.26032-1-haoxu.linux@gmail.com>
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

For operations like accept, multishot is a useful feature, since we can
reduce a number of accept sqe. Let's integrate it to fast poll, it may
be good for other operations in the future.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io_uring.c | 41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8ebb1a794e36..d33777575faf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5952,7 +5952,7 @@ static void io_poll_remove_entries(struct io_kiocb *req)
  * either spurious wakeup or multishot CQE is served. 0 when it's done with
  * the request, then the mask is stored in req->cqe.res.
  */
-static int io_poll_check_events(struct io_kiocb *req, bool locked)
+static int io_poll_check_events(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int v;
@@ -5981,17 +5981,26 @@ static int io_poll_check_events(struct io_kiocb *req, bool locked)
 
 		/* multishot, just fill an CQE and proceed */
 		if (req->cqe.res && !(req->apoll_events & EPOLLONESHOT)) {
-			__poll_t mask = mangle_poll(req->cqe.res & req->apoll_events);
-			bool filled;
-
-			spin_lock(&ctx->completion_lock);
-			filled = io_fill_cqe_aux(ctx, req->cqe.user_data, mask,
-						 IORING_CQE_F_MORE);
-			io_commit_cqring(ctx);
-			spin_unlock(&ctx->completion_lock);
-			if (unlikely(!filled))
-				return -ECANCELED;
-			io_cqring_ev_posted(ctx);
+			if (req->flags & REQ_F_APOLL_MULTISHOT) {
+				io_tw_lock(req->ctx, locked);
+				if (likely(!(req->task->flags & PF_EXITING)))
+					io_queue_sqe(req);
+				else
+					return -EFAULT;
+			} else {
+				__poll_t mask = mangle_poll(req->cqe.res &
+							    req->apoll_events);
+				bool filled;
+
+				spin_lock(&ctx->completion_lock);
+				filled = io_fill_cqe_aux(ctx, req->cqe.user_data,
+							 mask, IORING_CQE_F_MORE);
+				io_commit_cqring(ctx);
+				spin_unlock(&ctx->completion_lock);
+				if (unlikely(!filled))
+					return -ECANCELED;
+				io_cqring_ev_posted(ctx);
+			}
 		} else if (req->cqe.res) {
 			return 0;
 		}
@@ -6010,7 +6019,7 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	ret = io_poll_check_events(req, *locked);
+	ret = io_poll_check_events(req, locked);
 	if (ret > 0)
 		return;
 
@@ -6035,7 +6044,7 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	ret = io_poll_check_events(req, *locked);
+	ret = io_poll_check_events(req, locked);
 	if (ret > 0)
 		return;
 
@@ -6275,7 +6284,7 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
-	__poll_t mask = EPOLLONESHOT | POLLERR | POLLPRI;
+	__poll_t mask = POLLERR | POLLPRI;
 	int ret;
 
 	if (!def->pollin && !def->pollout)
@@ -6284,6 +6293,8 @@ static int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 		return IO_APOLL_ABORTED;
 	if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
 		return IO_APOLL_ABORTED;
+	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
+		mask |= EPOLLONESHOT;
 
 	if (def->pollin) {
 		mask |= POLLIN | POLLRDNORM;
-- 
2.36.0

