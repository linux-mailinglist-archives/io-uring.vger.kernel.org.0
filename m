Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E07D417CB7
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348500AbhIXVCo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348470AbhIXVCi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:38 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29841C061613
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:05 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id v18so5597291edc.11
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=y2juA+/a5isqpgAsyhBb/L0oK/zQE/nbDrxjKyIaIok=;
        b=NE/PcxOe+2lKOT8Y3Xr8yJ62zlIzN7HXtPc0fllx3jhmjA2ezldGMSk44uccMAOEw5
         8vlbITwA02rA13Uws3KciGuZHpxTM0GBteCoL4PD92g9e0+4UDLZgv7FDSe46XOWwR31
         9MHi9/TazxzxeQMNqGGJmFJ8iQ9pVT4u9plM4hTv0n+Qkx3hhCWDqtB6MHW1w+pt3Dif
         cofQJJinHKtFvbUI2xeoCQ3e+IPhHlGTgdVH/i1TUOLJOfvTvejziTGJ8Js8Gn6FmQ5L
         gNM4l9XMwyUg8qO2l+OmaQK7jHM85ca4V2lpz1M0UvyKNKkEMEXBVAsnik4VGA1s5WQl
         mBbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y2juA+/a5isqpgAsyhBb/L0oK/zQE/nbDrxjKyIaIok=;
        b=shaGRuMc5yRJx2hkXSH1QYCrVnuRdz5FRuxRef6uz0gGx8jxA2ABmJ8PP3CwlSykwQ
         hYVFgu9FUVmODlGCrwbiQLEOTveVsC4MXS+00AtygQb8BVSS/WiEa80WcZcXGdyxd4Df
         pj2pOxKBJjtppKuvpdZ6BwICe4uk1sMCn0gdycVlfmfuUbgTnGoNAb5XXJE+JiOfWLx3
         NA5Nqe5Qb7GrykfKN2Nck4JVq4ok5EenI3T9js4mSxbDBq6BzvnD+q+Siz6ymyOunJX8
         f1FFLczQV4EUzk28tWWlifznY094scqEwnERnOh3x4Jit+CJpYAJ6/3sBc5oa7reLTxK
         3OSA==
X-Gm-Message-State: AOAM532kWbmQUct9QoGwfAlQDk8VY3k4eeVMDsfcGRvtG9PirIeK09Cs
        n/uBsp+2woVuO1B/EajSiVF7HQ+c4vE=
X-Google-Smtp-Source: ABdhPJzFINfM0QfklBiiPW7cZOMZ8xkgcYcVSb4xMYCrjEhzJ/brB5GnlPlsBV0GiG5IYCMuzFa9fg==
X-Received: by 2002:a17:906:3693:: with SMTP id a19mr13690814ejc.237.1632517263685;
        Fri, 24 Sep 2021 14:01:03 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:01:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 17/24] io_uring: remove drain_active check from hot path
Date:   Fri, 24 Sep 2021 21:59:57 +0100
Message-Id: <d7e7ddc63c15e8a300833132abb3eb8fd3918aef.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->ctx->active_drain is a bit too expensive, partially because of two
dereferences. Do a trick, if we see it set in io_init_req(), set
REQ_F_FORCE_ASYNC and it automatically goes through a slower path where
we can catch it. It's nearly free to do in io_init_req() because there
is already ->restricted check and it's in the same byte of a bitmask.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 53 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 271d921508f8..25f6096269c5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6446,23 +6446,15 @@ static bool io_drain_req(struct io_kiocb *req)
 	int ret;
 	u32 seq;
 
-	if (req->flags & REQ_F_FAIL) {
-		io_req_complete_fail_submit(req);
-		return true;
-	}
-
-	/*
-	 * If we need to drain a request in the middle of a link, drain the
-	 * head request and the next request/link after the current link.
-	 * Considering sequential execution of links, IOSQE_IO_DRAIN will be
-	 * maintained for every request of our link.
-	 */
-	if (ctx->drain_next) {
-		req->flags |= REQ_F_IO_DRAIN;
-		ctx->drain_next = false;
-	}
 	/* not interested in head, start from the first linked */
 	io_for_each_link(pos, req->link) {
+		/*
+		 * If we need to drain a request in the middle of a link, drain
+		 * the head request and the next request/link after the current
+		 * link. Considering sequential execution of links,
+		 * IOSQE_IO_DRAIN will be maintained for every request of our
+		 * link.
+		 */
 		if (pos->flags & REQ_F_IO_DRAIN) {
 			ctx->drain_next = true;
 			req->flags |= REQ_F_IO_DRAIN;
@@ -6954,13 +6946,12 @@ static void __io_queue_sqe(struct io_kiocb *req)
 static inline void io_queue_sqe(struct io_kiocb *req)
 	__must_hold(&req->ctx->uring_lock)
 {
-	if (unlikely(req->ctx->drain_active) && io_drain_req(req))
-		return;
-
 	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL)))) {
 		__io_queue_sqe(req);
 	} else if (req->flags & REQ_F_FAIL) {
 		io_req_complete_fail_submit(req);
+	} else if (unlikely(req->ctx->drain_active) && io_drain_req(req)) {
+		return;
 	} else {
 		int ret = io_req_prep_async(req);
 
@@ -6980,9 +6971,6 @@ static inline bool io_check_restriction(struct io_ring_ctx *ctx,
 					struct io_kiocb *req,
 					unsigned int sqe_flags)
 {
-	if (likely(!ctx->restricted))
-		return true;
-
 	if (!test_bit(req->opcode, ctx->restrictions.sqe_op))
 		return false;
 
@@ -7023,11 +7011,28 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
 		    !io_op_defs[req->opcode].buffer_select)
 			return -EOPNOTSUPP;
-		if (sqe_flags & IOSQE_IO_DRAIN)
+		if (sqe_flags & IOSQE_IO_DRAIN) {
+			struct io_submit_link *link = &ctx->submit_state.link;
+
 			ctx->drain_active = true;
+			req->flags |= REQ_F_FORCE_ASYNC;
+			if (link->head)
+				link->head->flags |= IOSQE_IO_DRAIN | REQ_F_FORCE_ASYNC;
+		}
+	}
+	if (unlikely(ctx->restricted || ctx->drain_active || ctx->drain_next)) {
+		if (ctx->restricted && !io_check_restriction(ctx, req, sqe_flags))
+			return -EACCES;
+		/* knock it to the slow queue path, will be drained there */
+		if (ctx->drain_active)
+			req->flags |= REQ_F_FORCE_ASYNC;
+		/* if there is no link, we're at "next" request and need to drain */
+		if (unlikely(ctx->drain_next) && !ctx->submit_state.link.head) {
+			ctx->drain_next = false;
+			ctx->drain_active = true;
+			req->flags |= REQ_F_FORCE_ASYNC | IOSQE_IO_DRAIN;
+		}
 	}
-	if (!io_check_restriction(ctx, req, sqe_flags))
-		return -EACCES;
 
 	personality = READ_ONCE(sqe->personality);
 	if (personality) {
-- 
2.33.0

