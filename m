Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F413E453B
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbhHIMFf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbhHIMFe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:34 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDFEC061799
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:14 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id q11so2882134wrr.9
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+UDE8Me2G4AnNaP6tSvTLjQ5UK1nsABeKMQTiszlmDM=;
        b=bC27VRatrFXNSFlLkdCQvK2dzoO1TE+L/R/nLUjKf4/P57xJu7u7sf4iHxwu0nx6pF
         nkvLmL0tmkGc/HtOMIRf9K+Fw1ycRVZHzbblL9cny2NfvsryFlYXtdUNlnuhdyGnvaTO
         RNRAK+foYgaHIRTOItQgKMkNTk8vbQ24FD9XMmTwyCpJKeIzk6HLxCM82BMtzog2UXmn
         9yz1XgiLdhRTNAjvmYt1JMecb0OMrBV1J+YfPn7NDHpzCZTNXjX1+uxDD+7bfVk/K72j
         Y2DTwssE+/rKoMkaJVWjnX1lgLDBZnLIqR2vCcg3/TBDu2bITySSvyqBnef9GNpwd8p9
         ykZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+UDE8Me2G4AnNaP6tSvTLjQ5UK1nsABeKMQTiszlmDM=;
        b=bKrIyFCSEbd3EO6VuegtmysF+hdH4Z8OcrASUm0eRV+5pxVJ1mNOqLuN8mANJt+ebO
         F5CE4+IFAGKnSEJ0cJ9iAEBZfwwWh7GIrKgG8r0w+n0J0sWNZt1fDjXPVGmwnGtaiHQS
         N3wRnmnOCcj1TA7SSC1iztmc/dgW692m+0OEqFup4mDmCXoWv7Rad1yNsH782uHUp8sC
         ISG3ZM5Uw1w9Y1XQVVixjCMDqk1jpDtwiJd4lIXQYjJO0fGY99GucxQFAZp8+LXjJmic
         8CV6qarT65N6evNZ4z4XfBYOb+I+okecnswG4E3H9SUXZVto1QDV9MOnMeElqAUQqdT2
         SZ5w==
X-Gm-Message-State: AOAM533U5IhATa4tngk/aqkZPHbXWg1+Z+X7dUjgJLJkRmks4VEljcf9
        TODUUdSS2gXe40OKNtw87hbqUVQyE1Q=
X-Google-Smtp-Source: ABdhPJzWlhpAojKoVV84dRKei3RfQmocoHDjFXD/ikMCU7lhANOb+JaAzF6fMIX5H/TM8IAF0Jt8TA==
X-Received: by 2002:adf:ed51:: with SMTP id u17mr24291165wro.416.1628510712843;
        Mon, 09 Aug 2021 05:05:12 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/28] io_uring: add more locking annotations for submit
Date:   Mon,  9 Aug 2021 13:04:10 +0100
Message-Id: <128ec4185e26fbd661dd3a424aa66108ee8ff951.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add more annotations for submission path functions holding ->uring_lock.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 911a223a90e1..0f49736cd2b4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2130,6 +2130,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 }
 
 static void io_submit_flush_completions(struct io_ring_ctx *ctx)
+	__must_hold(&req->ctx->uring_lock)
 {
 	struct io_comp_state *cs = &ctx->submit_state.comp;
 	int i, nr = cs->nr;
@@ -6474,6 +6475,7 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 }
 
 static void __io_queue_sqe(struct io_kiocb *req)
+	__must_hold(&req->ctx->uring_lock)
 {
 	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
 	int ret;
@@ -6517,6 +6519,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 }
 
 static inline void io_queue_sqe(struct io_kiocb *req)
+	__must_hold(&req->ctx->uring_lock)
 {
 	if (unlikely(req->ctx->drain_active) && io_drain_req(req))
 		return;
@@ -6561,6 +6564,7 @@ static inline bool io_check_restriction(struct io_ring_ctx *ctx,
 
 static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		       const struct io_uring_sqe *sqe)
+	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_state *state;
 	unsigned int sqe_flags;
@@ -6624,6 +6628,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			 const struct io_uring_sqe *sqe)
+	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_link *link = &ctx->submit_state.link;
 	int ret;
@@ -6756,6 +6761,7 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 }
 
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
+	__must_hold(&ctx->uring_lock)
 {
 	struct io_uring_task *tctx;
 	int submitted = 0;
-- 
2.32.0

