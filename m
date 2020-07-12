Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F9421C854
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 11:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgGLJnQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 05:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgGLJnQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 05:43:16 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B565AC061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 02:43:15 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id ga4so10869821ejb.11
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 02:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=OlumJQvuJnx0tbLAUXlbsy0XrQpZtFRPbPJKOsXm+Ew=;
        b=qno0KELClj4fjP0/Tw4Q3bKyN3dU+NqQoYxcfkqo4MOoEWwdjkOYht+vACkes8OPFz
         nk0tMJgvnpryApxJ+82PfEU1h9Hk4796RpP563XxalrnHqwp9o1mO5yRB0o/gstbehFT
         E/SwrJzbgVUCG3XH9qZJ8sOhqa/hIMEc6LQHYPElkV2kiUJurhhca4JK4/M9MGAadGs8
         IBzObfsWGaAVc5O0HL/nJY+CooTCP8mHQn8TaPmiFAzC7PVJucogyXC+NSs3RRwca9Bl
         rILTghJBFl6qFiFDwf0JrgpWIzn4hwDumLo5uBNSWJivZjrQgADtmTkLhx10ChZ/ZtKW
         MVng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OlumJQvuJnx0tbLAUXlbsy0XrQpZtFRPbPJKOsXm+Ew=;
        b=I0V15ljzd8L864eYKhki/F0P3xJ0yUIsCmMiKJYg8aRDyKQsyPTEZlhtkyX/HiPzVo
         huQayLPt0IfN3tmC+lzE8sa5u6kDZYy5lnfaK/jJjal/3yul0IAA+0RmZfTtDbOf/GGk
         IEMY2pL/dCEFMMf8fgRogimF5+tgeReQfpF4hzP5f1fFnbWtFkVZKy7cjg6vOXYf/t5z
         y0v3B5KbSxYol5cgGOX8dukf5/l1IGw3Qr0UFRKXBbFWARBecW1p99g03Aqdh/kd7tza
         v+dU/NMHEQX9dzHlr4uIteN34b5lq4xtQRos8c13V7DPW98gftXCWtyMNA703OeKiK8w
         PZQg==
X-Gm-Message-State: AOAM532khKds6/g47eTKVrWvTUewOFgdwIfT9wqqpSr+aLDRQzwM2mSR
        zCAcZ86BaLMnWT9I/ja86mvnrA8u
X-Google-Smtp-Source: ABdhPJzaEtXVIUYCLi+bENFG9/C8ktsPGDcFbgvIr2mZB+oZsVCOGVdjQMXQutP09XcEZiJUuV8Vmg==
X-Received: by 2002:a17:906:488:: with SMTP id f8mr67646581eja.215.1594546994409;
        Sun, 12 Jul 2020 02:43:14 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id a8sm7283718ejp.51.2020.07.12.02.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 02:43:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/9] io_uring: add req->timeout.list
Date:   Sun, 12 Jul 2020 12:41:11 +0300
Message-Id: <f8bc5e189bbc28e9b59afcc2f33f12f53f31ac3a.1594546078.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594546078.git.asml.silence@gmail.com>
References: <cover.1594546078.git.asml.silence@gmail.com>
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
index 88c3092399e2..81e7bb226dbd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -396,6 +396,7 @@ struct io_timeout {
 	int				flags;
 	u32				off;
 	u32				target_seq;
+	struct list_head		list;
 };
 
 struct io_rw {
@@ -1209,7 +1210,7 @@ static void io_kill_timeout(struct io_kiocb *req)
 	ret = hrtimer_try_to_cancel(&req->io->timeout.timer);
 	if (ret != -1) {
 		atomic_inc(&req->ctx->cq_timeouts);
-		list_del_init(&req->list);
+		list_del_init(&req->timeout.list);
 		req->flags |= REQ_F_COMP_LOCKED;
 		io_cqring_fill_event(req, 0);
 		io_put_req(req);
@@ -1221,7 +1222,7 @@ static void io_kill_timeouts(struct io_ring_ctx *ctx)
 	struct io_kiocb *req, *tmp;
 
 	spin_lock_irq(&ctx->completion_lock);
-	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, list)
+	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list)
 		io_kill_timeout(req);
 	spin_unlock_irq(&ctx->completion_lock);
 }
@@ -1244,7 +1245,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 {
 	while (!list_empty(&ctx->timeout_list)) {
 		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
-							struct io_kiocb, list);
+						struct io_kiocb, timeout.list);
 
 		if (io_is_timeout_noseq(req))
 			break;
@@ -1252,7 +1253,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 					- atomic_read(&ctx->cq_timeouts))
 			break;
 
-		list_del_init(&req->list);
+		list_del_init(&req->timeout.list);
 		io_kill_timeout(req);
 	}
 }
@@ -5006,8 +5007,8 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	 * We could be racing with timeout deletion. If the list is empty,
 	 * then timeout lookup already found it and will be handling it.
 	 */
-	if (!list_empty(&req->list))
-		list_del_init(&req->list);
+	if (!list_empty(&req->timeout.list))
+		list_del_init(&req->timeout.list);
 
 	io_cqring_fill_event(req, -ETIME);
 	io_commit_cqring(ctx);
@@ -5024,9 +5025,9 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
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
@@ -5146,7 +5147,8 @@ static int io_timeout(struct io_kiocb *req)
 	 * the one we need first.
 	 */
 	list_for_each_prev(entry, &ctx->timeout_list) {
-		struct io_kiocb *nxt = list_entry(entry, struct io_kiocb, list);
+		struct io_kiocb *nxt = list_entry(entry, struct io_kiocb,
+						  timeout.list);
 
 		if (io_is_timeout_noseq(nxt))
 			continue;
@@ -5155,7 +5157,7 @@ static int io_timeout(struct io_kiocb *req)
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

