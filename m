Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E5F351BE2
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237013AbhDASLo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 14:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236519AbhDASH0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 14:07:26 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A824AC00458B
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:36 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id w203-20020a1c49d40000b029010c706d0642so3999844wma.0
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=NmExFTpGFaKKTwHwMhh2BP9udcIgF9lVL9NcWszLAcg=;
        b=L1rlZNlORtrz/6eWFqBu7LmPfHV2vQVbsH7CFjiC3GehLyDzqhuPJIhccrhaIrrmzi
         FZmVUGCi89pfSKDe6uztiC+LLeJiFwzmigM3Lj7bG+o4EmfO6x5caeFm3OrLmq+7hvFn
         XKt+rulvL/WP2IREvIpZ/TXFtmospq7Edbymxo1OlEzFNyK9hpJfWiOt31r3uBDrIf0f
         fTHm0OYqvuxhcjmSSdVFHOVmiU+TDikT8CVuRIB57hmVwzXstNCOySW+yJdMw/73nUag
         7c3HbaGsR5FCYqXAjgBK/tL28UCs2daWkZCZw39O1//49sNXTJp84xblSdFXLSXUxzoe
         NXEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NmExFTpGFaKKTwHwMhh2BP9udcIgF9lVL9NcWszLAcg=;
        b=U1HLSpKeUMIc5BJMkIXzVFmEP0Ny9vQE2p9FyAE+uU+ht/i52VblClp+uCil7ZWG25
         HNYc64KH6SprE2onecG0gmFLxx/aeRPKUET0aNLrGP+rmSgv4o+rOmCz5CGSUaZ46Okl
         QbfKdlV/c28NwzbL2nO9WikS/9QhIiIuhnuGPOZj0md+MojlacmOAQd/s6eg/1WtWu5j
         J/gO55hkQxGMUi/hyh+Lq1JiqxLjOxCA1BwmMPQiHSeTbFMLPyApi3d9zE+cB+AP9zy8
         9CnwadLhoOoucFZ2TQxHERHjsbcJxVv4533aq3YmfYG7nWCPAiwaDCI3jI1X6JI0ReVK
         6v6A==
X-Gm-Message-State: AOAM533+Pwx2YCD8We6uIcOxSon9WHVBTYoSbWT141dyBGOQsjnGXE0k
        9TvdWms6zHBeJkoKWehY57M=
X-Google-Smtp-Source: ABdhPJzXT/3R2EpNgJkYU/oolklDYAb7JwW1orAmJRA3oQ2/rTHrKnqyUfW5kx0/1GVucjftKd7lYA==
X-Received: by 2002:a7b:c195:: with SMTP id y21mr8400376wmi.178.1617288515521;
        Thu, 01 Apr 2021 07:48:35 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 18/26] io_uring: lock annotate timeouts and poll
Date:   Thu,  1 Apr 2021 15:43:57 +0100
Message-Id: <2345325643093d41543383ba985a735aeb899eac.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add timeout and poll ->comletion_lock annotations for Sparse, makes life
easier while looking at the functions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 352c231571dd..683db49a766e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4865,6 +4865,7 @@ static struct io_poll_iocb *io_poll_get_single(struct io_kiocb *req)
 }
 
 static void io_poll_remove_double(struct io_kiocb *req)
+	__must_hold(&req->ctx->completion_lock)
 {
 	struct io_poll_iocb *poll = io_poll_get_double(req);
 
@@ -4883,6 +4884,7 @@ static void io_poll_remove_double(struct io_kiocb *req)
 }
 
 static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
+	__must_hold(&req->ctx->completion_lock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned flags = IORING_CQE_F_MORE;
@@ -5188,6 +5190,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 
 static bool __io_poll_remove_one(struct io_kiocb *req,
 				 struct io_poll_iocb *poll, bool do_cancel)
+	__must_hold(&req->ctx->completion_lock)
 {
 	bool do_complete = false;
 
@@ -5206,6 +5209,7 @@ static bool __io_poll_remove_one(struct io_kiocb *req,
 }
 
 static bool io_poll_remove_waitqs(struct io_kiocb *req)
+	__must_hold(&req->ctx->completion_lock)
 {
 	bool do_complete;
 
@@ -5229,6 +5233,7 @@ static bool io_poll_remove_waitqs(struct io_kiocb *req)
 }
 
 static bool io_poll_remove_one(struct io_kiocb *req)
+	__must_hold(&req->ctx->completion_lock)
 {
 	bool do_complete;
 
@@ -5272,6 +5277,7 @@ static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 }
 
 static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, __u64 sqe_addr)
+	__must_hold(&ctx->completion_lock)
 {
 	struct hlist_head *list;
 	struct io_kiocb *req;
@@ -5287,6 +5293,7 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, __u64 sqe_addr)
 }
 
 static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
+	__must_hold(&ctx->completion_lock)
 {
 	struct io_kiocb *req;
 
@@ -5493,6 +5500,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 
 static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
 					   __u64 user_data)
+	__must_hold(&ctx->completion_lock)
 {
 	struct io_timeout_data *io;
 	struct io_kiocb *req;
@@ -5517,6 +5525,7 @@ static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
 }
 
 static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
+	__must_hold(&ctx->completion_lock)
 {
 	struct io_kiocb *req = io_timeout_extract(ctx, user_data);
 
@@ -5531,6 +5540,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 
 static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 			     struct timespec64 *ts, enum hrtimer_mode mode)
+	__must_hold(&ctx->completion_lock)
 {
 	struct io_kiocb *req = io_timeout_extract(ctx, user_data);
 	struct io_timeout_data *data;
-- 
2.24.0

