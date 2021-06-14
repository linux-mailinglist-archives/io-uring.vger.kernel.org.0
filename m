Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364013A721B
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 00:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhFNWkJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 18:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhFNWkJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 18:40:09 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D546C0613A2
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:37:58 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id f16-20020a05600c1550b02901b00c1be4abso418767wmg.2
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=LFbm/7KKwcVUTAvNdYmnJW7NAY89hVYyKmdwBv0+x54=;
        b=bsgQkMf+oRuZ2CfmzBJP2nrufuFGazKz3/sZXDvsTmThM716vTrcdE66S4WGVEbCzv
         0AM+0fOf10XKSg+WaVpAdrgOuCafvLu/imGxI0ePMtqqPnXgtdRg1+go+LeRY7KbiWIo
         YP9abP0N0XEVoL4s+qr9mJE0OiB0RgTDhAEueXv3zps48674H6vHeSclMpsd/8KARN4r
         ybp5+eLMIewnlCRHkmIq4IJAfR2HgwuDi1CJnr+dYNUluByvRKQtCS2WwBHxKfIRiYz0
         8SKj5LjBc9edvHgDGqKZkFtOsAmpnpLOfHuTBptyeM5eKf25YuUqxOwr99XP5He2yFPC
         Af5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LFbm/7KKwcVUTAvNdYmnJW7NAY89hVYyKmdwBv0+x54=;
        b=GnKnBfPIAXhzUZ+EnJk9MngqFzT6jNoodwN1WGOniPm8dshGLLNCSfaZaOBhz/ZEhf
         LVETFQnxlbxaT55Fnuzc3MdjCs8WboUkc2fl6CPGXIH9LNhei7N01dSaimmCpDRXyYRe
         AlW1VYQlx3ntixDnQjE8vgqX6uxA1M8v3NhrM8k9VW+6OqzhmpK+6vw23Rs08l84mU58
         beajG3sz3JI1hIZVBoYkDvtZGhJ7AdZeEaQKGC6r1BPDKVqICZDP13hETbeLJUDdJjOK
         rpvL9Spm3hlsD9dR3wH7h8QpFTztpYiYcblg795sK/btFpHIPJQcwQxQSybEQobi8BY1
         16iQ==
X-Gm-Message-State: AOAM532UuAr8GUCQiWC2KvoJVM/8K/AJCirkG9NAl9G3cEzosoEH5noV
        CH/+/vN7KMFwEhnt0nkSvcY=
X-Google-Smtp-Source: ABdhPJzklSN1oxaDryTglUrZKApYafxKclGgmYHc013YV/jZqf7ymGzMT0j8BRV21nyGUKtiDudltg==
X-Received: by 2002:a1c:41c5:: with SMTP id o188mr1491639wma.60.1623710277075;
        Mon, 14 Jun 2021 15:37:57 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id x3sm621074wmj.30.2021.06.14.15.37.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:37:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/12] io_uring: optimise completion timeout flushing
Date:   Mon, 14 Jun 2021 23:37:25 +0100
Message-Id: <e4892ec68b71a69f92ffbea4a1499be3ec0d463b.1623709150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623709150.git.asml.silence@gmail.com>
References: <cover.1623709150.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_commit_cqring() might be very hot and we definitely don't want to
touch ->timeout_list there, because 1) it's shared with the submission
side so might lead to cache bouncing and 2) may need to load an extra
cache line, especially for IRQ completions.

We're interested in it at the completion side only when there are
offset-mode timeouts, which are not so popular. Replace
list_empty(->timeout_list) hot path check with a new one-way flag, which
is set when we prepare the first offset-mode timeout.

note: the flag sits in the same line as briefly used after ->rings

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6dd14f4aa5f1..fbf3b2149a4c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -351,6 +351,7 @@ struct io_ring_ctx {
 		unsigned int		drain_next: 1;
 		unsigned int		eventfd_async: 1;
 		unsigned int		restricted: 1;
+		unsigned int		off_timeout_used: 1;
 	} ____cacheline_aligned_in_smp;
 
 	/* submission data */
@@ -1318,12 +1319,12 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 {
 	u32 seq;
 
-	if (list_empty(&ctx->timeout_list))
+	if (likely(!ctx->off_timeout_used))
 		return;
 
 	seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
 
-	do {
+	while (!list_empty(&ctx->timeout_list)) {
 		u32 events_needed, events_got;
 		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
 						struct io_kiocb, timeout.list);
@@ -1345,8 +1346,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 
 		list_del_init(&req->timeout.list);
 		io_kill_timeout(req, 0);
-	} while (!list_empty(&ctx->timeout_list));
-
+	}
 	ctx->cq_last_tm_flush = seq;
 }
 
@@ -5651,6 +5651,8 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		return -EINVAL;
 
 	req->timeout.off = off;
+	if (unlikely(off && !req->ctx->off_timeout_used))
+		req->ctx->off_timeout_used = true;
 
 	if (!req->async_data && io_alloc_async_data(req))
 		return -ENOMEM;
-- 
2.31.1

