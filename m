Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306C421E18D
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 22:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgGMUj0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 16:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgGMUj0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 16:39:26 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50949C061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:26 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id n26so18975439ejx.0
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=KMnQPhFO/ScaGOYmjQ4zeJbto34ct3+ebfOCtCHG9VY=;
        b=Z8XKFW+QnrQog5oRMudKJi7cB5psapnjDayy2UYL4qOHLio6ky8dkHo7Jm0WdP3zbk
         3C8OF5Fm7jDQMeW/jt5sZUG0lTgcrO4XcvdN1M1D7wqv2eMRgEe8OukVdtLK85LdYSH3
         y+XbvKLhnQ4915BCxYfs97z25xkyoqDnXr5PuqsGrwV4fG2QegsAVE8nWSgWxE1/xXxg
         oeoaa2elM8JSaqN5b1QPJW8t54sUb8FIcipskCh373L8BSFzzUWl0WQWtM0aCUYj4pBU
         HAF7k90KIZpr+CO0WBhTgazw6VMVe2kGqnL42qgXV3Sbvp9rHnPz+QJqhatPs0C2wuvb
         G5PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KMnQPhFO/ScaGOYmjQ4zeJbto34ct3+ebfOCtCHG9VY=;
        b=NsbJcN9TfQPMV5RnzhTfvBSdgxPebhXPVHjGIyThB5R8qJqAQVIWFRC/Y8hfxr8eY7
         jzL8JIszxcEC0CfrOOUhZo6pj9fXJhc5fViou9PMhMNdGg0xYzJ+RYjXAYORzgzRNw1Q
         zM9gzll5pr0f6wVV9upgeaaKLWIJGaT5biXVYh0If7lfYik7TuvXOAT6f4VRVPIm4kGw
         vWfyhIvJ+WWXhBOIm6DJcsVA/YwIHxq+l25rkoE8JzewmKsePYqNUnL1ttT8KGPdScA8
         Wv4JE2hORBKGBv7Fy5dh1OuBNjLoXkkCLFFN1EJ7jQzSv/mWJVC7lzIgyTlemZYQuleO
         8G8w==
X-Gm-Message-State: AOAM531pNHVEUW1Qz0P1Rcz+QB81nK4MVfk+Ntc9SExNKtSB0Op+j4XV
        duslyfW0VvHcC8QX7aMHpuQ=
X-Google-Smtp-Source: ABdhPJw+Zn/dkfgO7lZ9FNlJs4wUIhWwjRoktpCiCdVqs7oAe4HvS1MI9VQQUnu3NK/KkkjcPzaOQg==
X-Received: by 2002:a17:906:a081:: with SMTP id q1mr1378154ejy.499.1594672765009;
        Mon, 13 Jul 2020 13:39:25 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id m14sm10491855ejx.80.2020.07.13.13.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:39:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 5/9] io_uring: add req->timeout.list
Date:   Mon, 13 Jul 2020 23:37:12 +0300
Message-Id: <2b6e885c0b05480029e22ddc46bb7b0d3d0c64a2.1594670798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594670798.git.asml.silence@gmail.com>
References: <cover.1594670798.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of using shared req->list, hang timeouts up on their own list
entry. struct io_timeout have enough extra space for it, but if that
will be a problem ->inflight_entry can reused for that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 584ff83cf0a4..b9bd2002db98 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -396,6 +396,7 @@ struct io_timeout {
 	int				flags;
 	u32				off;
 	u32				target_seq;
+	struct list_head		list;
 };
 
 struct io_rw {
@@ -1212,7 +1213,7 @@ static void io_kill_timeout(struct io_kiocb *req)
 	ret = hrtimer_try_to_cancel(&req->io->timeout.timer);
 	if (ret != -1) {
 		atomic_inc(&req->ctx->cq_timeouts);
-		list_del_init(&req->list);
+		list_del_init(&req->timeout.list);
 		req->flags |= REQ_F_COMP_LOCKED;
 		io_cqring_fill_event(req, 0);
 		io_put_req(req);
@@ -1224,7 +1225,7 @@ static void io_kill_timeouts(struct io_ring_ctx *ctx)
 	struct io_kiocb *req, *tmp;
 
 	spin_lock_irq(&ctx->completion_lock);
-	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, list)
+	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list)
 		io_kill_timeout(req);
 	spin_unlock_irq(&ctx->completion_lock);
 }
@@ -1247,7 +1248,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 {
 	while (!list_empty(&ctx->timeout_list)) {
 		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
-							struct io_kiocb, list);
+						struct io_kiocb, timeout.list);
 
 		if (io_is_timeout_noseq(req))
 			break;
@@ -1255,7 +1256,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 					- atomic_read(&ctx->cq_timeouts))
 			break;
 
-		list_del_init(&req->list);
+		list_del_init(&req->timeout.list);
 		io_kill_timeout(req);
 	}
 }
@@ -4980,8 +4981,8 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	 * We could be racing with timeout deletion. If the list is empty,
 	 * then timeout lookup already found it and will be handling it.
 	 */
-	if (!list_empty(&req->list))
-		list_del_init(&req->list);
+	if (!list_empty(&req->timeout.list))
+		list_del_init(&req->timeout.list);
 
 	io_cqring_fill_event(req, -ETIME);
 	io_commit_cqring(ctx);
@@ -4998,9 +4999,9 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 	struct io_kiocb *req;
 	int ret = -ENOENT;
 
-	list_for_each_entry(req, &ctx->timeout_list, list) {
+	list_for_each_entry(req, &ctx->timeout_list, timeout.list) {
 		if (user_data == req->user_data) {
-			list_del_init(&req->list);
+			list_del_init(&req->timeout.list);
 			ret = 0;
 			break;
 		}
@@ -5120,7 +5121,8 @@ static int io_timeout(struct io_kiocb *req)
 	 * the one we need first.
 	 */
 	list_for_each_prev(entry, &ctx->timeout_list) {
-		struct io_kiocb *nxt = list_entry(entry, struct io_kiocb, list);
+		struct io_kiocb *nxt = list_entry(entry, struct io_kiocb,
+						  timeout.list);
 
 		if (io_is_timeout_noseq(nxt))
 			continue;
@@ -5129,7 +5131,7 @@ static int io_timeout(struct io_kiocb *req)
 			break;
 	}
 add:
-	list_add(&req->list, entry);
+	list_add(&req->timeout.list, entry);
 	data->timer.function = io_timeout_fn;
 	hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), data->mode);
 	spin_unlock_irq(&ctx->completion_lock);
-- 
2.24.0

