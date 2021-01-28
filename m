Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A35307E38
	for <lists+io-uring@lfdr.de>; Thu, 28 Jan 2021 19:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhA1SjK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jan 2021 13:39:10 -0500
Received: from mail-pj1-f47.google.com ([209.85.216.47]:33104 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbhA1Sh0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jan 2021 13:37:26 -0500
Received: by mail-pj1-f47.google.com with SMTP id lw17so5174959pjb.0
        for <io-uring@vger.kernel.org>; Thu, 28 Jan 2021 10:37:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g5YFZge2ATjblIIwSQhf82b4H7N6/Rm5PzpjONcfd7w=;
        b=EywVP6dg11oHXKjMgXajX3/2YgNBdoRC7r/E4Lk3EnFcoC4xUFFg3kh+r83JpzVh9Y
         yYeHVQNTDy0S08HD1lliLEW/UCi2f7xgrzmN1hgCjY4gt5HVPKoeLreIyaahfivKLx21
         YsHHfbMd9RFMKCSVoTFQtJQRiaTHWikDLplHeLtvUurf497WD3Cg8bIFxEZNRpu85XQZ
         Kd7WuKCTtv1VkfV8s+RAL2dP9eU/AW4qRmXrM4fzSyO26+dPTErz6QMHTiA1jBLBFdsg
         J4Rbu3D6Zaa+pkEI6fakl64pqH022DQNyCwIieyy2BZsJzsHkkEh3ruH1DE4rKk8cpyg
         2Y5g==
X-Gm-Message-State: AOAM533i3LiGbEMzgtdtzTvvmSu+VLHPeLSyY6lA/3Y7AMvQBrgJqXq7
        1jMxWrnG8IBcdjQnqqhTbSb8Tu6T8fk=
X-Google-Smtp-Source: ABdhPJwgj8i8NXOljLaGzp7ayB/K/oaIN3mKrYCuqgANYMOQifM7A2VoLWs/uQl8asuCaGrUiIH7xw==
X-Received: by 2002:a17:90a:9302:: with SMTP id p2mr649884pjo.213.1611859005426;
        Thu, 28 Jan 2021 10:36:45 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7c24:d56f:a477:c88a])
        by smtp.gmail.com with ESMTPSA id a20sm6441954pfo.104.2021.01.28.10.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 10:36:44 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] io_uring: Optimize and improve the hot path
Date:   Thu, 28 Jan 2021 10:36:37 -0800
Message-Id: <20210128183637.7188-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The improvements in this patch are as follows:
- Change several memory barriers into load acquire / store release
  instructions since the latter are faster.
- Ensure that the completion has been reaped from use space by
  using smp_load_acquire() in __io_cqring_events(). Preceding
  __io_cqring_events() with smp_rmb() is not sufficient because the CPU
  may reorder READ_ONCE() in __io_cqring_events() with later memory
  accesses.
- Fix a race between the WRITE_ONCE(req->iopoll_completed, 1) in
  io_complete_rw_iopoll() and req->iopoll_completed = 0 in
  io_sqring_entries() by reading req->iopoll_completed before comparing
  req->result with -EAGAIN.

This patch has been tested by running the liburing test suite.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 fs/io_uring.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c07913ec0cca..2fff7250f0b1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1727,9 +1727,9 @@ static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
 	return io_wq_current_is_worker();
 }
 
-static inline unsigned __io_cqring_events(struct io_ring_ctx *ctx)
+static inline unsigned io_cqring_events(struct io_ring_ctx *ctx)
 {
-	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
+	return ctx->cached_cq_tail - smp_load_acquire(&ctx->rings->cq.head);
 }
 
 static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
@@ -1778,7 +1778,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 	bool all_flushed;
 	LIST_HEAD(list);
 
-	if (!force && __io_cqring_events(ctx) == rings->cq_ring_entries)
+	if (!force && io_cqring_events(ctx) == rings->cq_ring_entries)
 		return false;
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
@@ -2385,13 +2385,6 @@ static void io_double_put_req(struct io_kiocb *req)
 		io_free_req(req);
 }
 
-static unsigned io_cqring_events(struct io_ring_ctx *ctx)
-{
-	/* See comment at the top of this file */
-	smp_rmb();
-	return __io_cqring_events(ctx);
-}
-
 static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
@@ -2457,15 +2450,13 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	struct io_kiocb *req;
 	LIST_HEAD(again);
 
-	/* order with ->result store in io_complete_rw_iopoll() */
-	smp_rmb();
-
 	io_init_req_batch(&rb);
 	while (!list_empty(done)) {
 		int cflags = 0;
 
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
-		if (READ_ONCE(req->result) == -EAGAIN) {
+		if (smp_load_acquire(&req->iopoll_completed) &&
+		    req->result == -EAGAIN) {
 			req->result = 0;
 			req->iopoll_completed = 0;
 			list_move_tail(&req->inflight_entry, &again);
@@ -2514,7 +2505,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		 * If we find a request that requires polling, break out
 		 * and complete those lists first, if we have entries there.
 		 */
-		if (READ_ONCE(req->iopoll_completed)) {
+		if (smp_load_acquire(&req->iopoll_completed)) {
 			list_move_tail(&req->inflight_entry, &done);
 			continue;
 		}
@@ -2526,7 +2517,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 			break;
 
 		/* iopoll may have completed current req */
-		if (READ_ONCE(req->iopoll_completed))
+		if (smp_load_acquire(&req->iopoll_completed))
 			list_move_tail(&req->inflight_entry, &done);
 
 		if (ret && spin)
@@ -2767,10 +2758,9 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 	if (res != -EAGAIN && res != req->result)
 		req_set_fail_links(req);
 
-	WRITE_ONCE(req->result, res);
-	/* order with io_poll_complete() checking ->result */
-	smp_wmb();
-	WRITE_ONCE(req->iopoll_completed, 1);
+	req->result = res;
+	/* order with io_poll_complete() checking ->iopoll_completed */
+	smp_store_release(&req->iopoll_completed, 1);
 }
 
 /*
@@ -2803,7 +2793,7 @@ static void io_iopoll_req_issued(struct io_kiocb *req, bool in_async)
 	 * For fast devices, IO may have already completed. If it has, add
 	 * it to the front so we find it first.
 	 */
-	if (READ_ONCE(req->iopoll_completed))
+	if (smp_load_acquire(&req->iopoll_completed))
 		list_add(&req->inflight_entry, &ctx->iopoll_list);
 	else
 		list_add_tail(&req->inflight_entry, &ctx->iopoll_list);
