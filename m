Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E05621E18A
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 22:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgGMUjW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 16:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgGMUjV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 16:39:21 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94F6C061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:20 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id g20so14960281edm.4
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0Ly/TPbPtQ58soEUE9nYtcBpPjh1cp1TeLUAEeB0mns=;
        b=T3tI4s+uidt/vWiOrA+3rKc+L5tImueskI2M3zSzyItsOejRSkCKsha9UOuIvCPiFK
         xofuGlQytzjnVjGRE6Z+Eyl8ajy0tfn4VWgQBbJDCkv3NIr/tUePOfMT0/XCuDXfGJD+
         exLRK4jNZcpqmgrqtYL/IrXP8rFNd92f6Wp5g4ejMjG5qEpWC0wEBuPvH3GAtrnUAQNp
         UwRh3MMr1KvRqp1+HlKmLXkT9ULDGssVCIFfvunzhFWpYsyXkUTEwbYwknmfOQqlXJgj
         SKaVBMyThDpduu9gbHK3s/cK4wGPi/XPofrSJTDQL7r6DNWKoriJ/KshVbPJIoiOg6nl
         wR4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Ly/TPbPtQ58soEUE9nYtcBpPjh1cp1TeLUAEeB0mns=;
        b=i4sA5pHwRQrkG/U91GkX11fvGiZoUSD1zKa3FfXR/IYVzUXZHcQhc0dvTsygkb/G1W
         rb5wJ2fMrfcxQiuACsDGoLK2utpwc4Wlvo5D4Q6ap+p/lONKrnfkWsd8Jps9xbha1cKv
         gIKaICImcfer0af0ICer2DBuBKPENbLd2zsf2QMiYduZnJuSBw7RVTzpzl32amlvgO6s
         XueDeL/UcrCcN8H8yMK5jT2t4jZdJx0X4iUQUp/4vevjoYMsCHFJ/gEwUH7xsdGbwMuv
         Afgbfb/DVXCxdTNq7tf/1OhMdbh3hhmURCVEI+kyoJxYtfNBI1of6RivA9s38n2kNnHR
         Y4TA==
X-Gm-Message-State: AOAM530ONlcO13ZSR+JLU5aRt2zsVqqg4R15ZMGji26rvF2iDsk2YBgl
        39r47JFdaxTC2/9JH/c6n4IFa2Aq
X-Google-Smtp-Source: ABdhPJyQhBQR67eKeWj/xshEVSUCre348Tve7w+YnKaygJqbpk45PKEwaLh/L470TWu9xdpE7xGFww==
X-Received: by 2002:a05:6402:1c10:: with SMTP id ck16mr1218510edb.72.1594672759365;
        Mon, 13 Jul 2020 13:39:19 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id m14sm10491855ejx.80.2020.07.13.13.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:39:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 2/9] io_uring: rename ctx->poll into ctx->iopoll
Date:   Mon, 13 Jul 2020 23:37:09 +0300
Message-Id: <22d0205f20b587b10bd19f051a6f58e353152bb1.1594670798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594670798.git.asml.silence@gmail.com>
References: <cover.1594670798.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It supports both polling and I/O polling. Rename ctx->poll to clearly
show that it's only in I/O poll case.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b60307a69599..03bb8a69d09c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -320,12 +320,12 @@ struct io_ring_ctx {
 		spinlock_t		completion_lock;
 
 		/*
-		 * ->poll_list is protected by the ctx->uring_lock for
+		 * ->iopoll_list is protected by the ctx->uring_lock for
 		 * io_uring instances that don't use IORING_SETUP_SQPOLL.
 		 * For SQPOLL, only the single threaded io_sq_thread() will
 		 * manipulate the list, hence no extra locking is needed there.
 		 */
-		struct list_head	poll_list;
+		struct list_head	iopoll_list;
 		struct hlist_head	*cancel_hash;
 		unsigned		cancel_hash_bits;
 		bool			poll_multi_file;
@@ -1063,7 +1063,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
 	spin_lock_init(&ctx->completion_lock);
-	INIT_LIST_HEAD(&ctx->poll_list);
+	INIT_LIST_HEAD(&ctx->iopoll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	init_waitqueue_head(&ctx->inflight_wait);
@@ -2008,7 +2008,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	spin = !ctx->poll_multi_file && *nr_events < min;
 
 	ret = 0;
-	list_for_each_entry_safe(req, tmp, &ctx->poll_list, list) {
+	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, list) {
 		struct kiocb *kiocb = &req->rw.kiocb;
 
 		/*
@@ -2050,7 +2050,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 static int io_iopoll_getevents(struct io_ring_ctx *ctx, unsigned int *nr_events,
 				long min)
 {
-	while (!list_empty(&ctx->poll_list) && !need_resched()) {
+	while (!list_empty(&ctx->iopoll_list) && !need_resched()) {
 		int ret;
 
 		ret = io_do_iopoll(ctx, nr_events, min);
@@ -2073,7 +2073,7 @@ static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 		return;
 
 	mutex_lock(&ctx->uring_lock);
-	while (!list_empty(&ctx->poll_list)) {
+	while (!list_empty(&ctx->iopoll_list)) {
 		unsigned int nr_events = 0;
 
 		io_do_iopoll(ctx, &nr_events, 0);
@@ -2290,12 +2290,12 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 	 * how we do polling eventually, not spinning if we're on potentially
 	 * different devices.
 	 */
-	if (list_empty(&ctx->poll_list)) {
+	if (list_empty(&ctx->iopoll_list)) {
 		ctx->poll_multi_file = false;
 	} else if (!ctx->poll_multi_file) {
 		struct io_kiocb *list_req;
 
-		list_req = list_first_entry(&ctx->poll_list, struct io_kiocb,
+		list_req = list_first_entry(&ctx->iopoll_list, struct io_kiocb,
 						list);
 		if (list_req->file != req->file)
 			ctx->poll_multi_file = true;
@@ -2306,9 +2306,9 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 	 * it to the front so we find it first.
 	 */
 	if (READ_ONCE(req->iopoll_completed))
-		list_add(&req->list, &ctx->poll_list);
+		list_add(&req->list, &ctx->iopoll_list);
 	else
-		list_add_tail(&req->list, &ctx->poll_list);
+		list_add_tail(&req->list, &ctx->iopoll_list);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) &&
 	    wq_has_sleeper(&ctx->sqo_wait))
@@ -6306,11 +6306,11 @@ static int io_sq_thread(void *data)
 	while (!kthread_should_park()) {
 		unsigned int to_submit;
 
-		if (!list_empty(&ctx->poll_list)) {
+		if (!list_empty(&ctx->iopoll_list)) {
 			unsigned nr_events = 0;
 
 			mutex_lock(&ctx->uring_lock);
-			if (!list_empty(&ctx->poll_list) && !need_resched())
+			if (!list_empty(&ctx->iopoll_list) && !need_resched())
 				io_do_iopoll(ctx, &nr_events, 0);
 			else
 				timeout = jiffies + ctx->sq_thread_idle;
@@ -6339,7 +6339,7 @@ static int io_sq_thread(void *data)
 			 * more IO, we should wait for the application to
 			 * reap events and wake us up.
 			 */
-			if (!list_empty(&ctx->poll_list) || need_resched() ||
+			if (!list_empty(&ctx->iopoll_list) || need_resched() ||
 			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
 			    !percpu_ref_is_dying(&ctx->refs))) {
 				io_run_task_work();
@@ -6352,13 +6352,13 @@ static int io_sq_thread(void *data)
 
 			/*
 			 * While doing polled IO, before going to sleep, we need
-			 * to check if there are new reqs added to poll_list, it
-			 * is because reqs may have been punted to io worker and
-			 * will be added to poll_list later, hence check the
-			 * poll_list again.
+			 * to check if there are new reqs added to iopoll_list,
+			 * it is because reqs may have been punted to io worker
+			 * and will be added to iopoll_list later, hence check
+			 * the iopoll_list again.
 			 */
 			if ((ctx->flags & IORING_SETUP_IOPOLL) &&
-			    !list_empty_careful(&ctx->poll_list)) {
+			    !list_empty_careful(&ctx->iopoll_list)) {
 				finish_wait(&ctx->sqo_wait, &wait);
 				continue;
 			}
-- 
2.24.0

