Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FD121C851
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 11:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgGLJnL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 05:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgGLJnL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 05:43:11 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7FE9C061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 02:43:10 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id e22so8148523edq.8
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 02:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=z/pVl1uFnj8o3N2VyN7qO9ZIbGHBM9oSZejWNrunZ/k=;
        b=Vf+RYSVXSxWmQGcQ2lLbXG3CtHyzJ9tzi0neidst6oSmQv9dGOv2dxpLs25lELsS98
         QRDx1IBv0KapGQ8/UIXvpIxJP2BecXh8lHhIgbEjQQ1gyDnlTB6dXlIE9CB5PWEuvN9E
         8fexxZySpGI/BskqFlQm7AtRG20z2MRR6NF76dXUrp68+zV7fvbdTOA9j5UStcrVXEYP
         WUPOiEGA4nhbkgWaqRgyWlil4vlW4VvfO997sTMcqKEsikPY59ac8CILZbyrwdzVDMi+
         uwVAjdmnM/0jSFzT/rzoWopD/smoB5fcmQjxzThkx6OPmSQfV4a2/Eg7xAg5cwYUn/pO
         N6UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z/pVl1uFnj8o3N2VyN7qO9ZIbGHBM9oSZejWNrunZ/k=;
        b=WeYi9WgYQdCRDNYUeczzXyK6NRR4bp/IUrgNy9doTufIH8OB5g8nC5ny+n07E9DsGN
         GCpdWC2uaG5Ggv6de25Hql9APFek5LF3FyMftLqz9M35/oQ/qx5/DUXakmodQJ1Qe4cW
         P2R9VDXmWEbdGF0ClZ0lNuaX9A0G1G+oNeuC39jzusl8Y43SZeHNUy+OSUgcNgiVaJaS
         E0dvo3ITKW7IE2yVcD7HpKkbZU+hAdDI8VfgbximMpiwVpJpAtXFFLwVdrYkBcLauho6
         S/sY6L5IGpMscsLE/KJ7KGRZ+p2EpKeJs1BjwoPiipyKhDBFO9EIVSgQ50UwHqc3v5e2
         +HJA==
X-Gm-Message-State: AOAM533+zYo2ZOJoVs4e2zs6vmpSb50J4TvxjPXa4qlMwhabc1ERgD9E
        MrqtVjLvgJ07zrDMlWLHQVFO0ohY
X-Google-Smtp-Source: ABdhPJzJRDthhiv2EqBLiOmr+u1Rae2sXkm3778BvidRgAUp4pEaBSubG2K+NYMl1pNHs3zLIjyd1Q==
X-Received: by 2002:a05:6402:1246:: with SMTP id l6mr55095690edw.224.1594546989356;
        Sun, 12 Jul 2020 02:43:09 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id a8sm7283718ejp.51.2020.07.12.02.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 02:43:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/9] io_uring: rename ctx->poll into ctx->iopoll
Date:   Sun, 12 Jul 2020 12:41:08 +0300
Message-Id: <3cf4fcc91411d678f33e3cb5756cc43d3cfa16dc.1594546078.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594546078.git.asml.silence@gmail.com>
References: <cover.1594546078.git.asml.silence@gmail.com>
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
index 2316e6b840b3..669a131c22ec 100644
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
@@ -1059,7 +1059,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
 	spin_lock_init(&ctx->completion_lock);
-	INIT_LIST_HEAD(&ctx->poll_list);
+	INIT_LIST_HEAD(&ctx->iopoll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	init_waitqueue_head(&ctx->inflight_wait);
@@ -2003,7 +2003,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	spin = !ctx->poll_multi_file && *nr_events < min;
 
 	ret = 0;
-	list_for_each_entry_safe(req, tmp, &ctx->poll_list, list) {
+	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, list) {
 		struct kiocb *kiocb = &req->rw.kiocb;
 
 		/*
@@ -2045,7 +2045,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 static int io_iopoll_getevents(struct io_ring_ctx *ctx, unsigned int *nr_events,
 				long min)
 {
-	while (!list_empty(&ctx->poll_list) && !need_resched()) {
+	while (!list_empty(&ctx->iopoll_list) && !need_resched()) {
 		int ret;
 
 		ret = io_do_iopoll(ctx, nr_events, min);
@@ -2068,7 +2068,7 @@ static void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 		return;
 
 	mutex_lock(&ctx->uring_lock);
-	while (!list_empty(&ctx->poll_list)) {
+	while (!list_empty(&ctx->iopoll_list)) {
 		unsigned int nr_events = 0;
 
 		io_do_iopoll(ctx, &nr_events, 0);
@@ -2285,12 +2285,12 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
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
@@ -2301,9 +2301,9 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
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
@@ -6327,11 +6327,11 @@ static int io_sq_thread(void *data)
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
@@ -6360,7 +6360,7 @@ static int io_sq_thread(void *data)
 			 * more IO, we should wait for the application to
 			 * reap events and wake us up.
 			 */
-			if (!list_empty(&ctx->poll_list) || need_resched() ||
+			if (!list_empty(&ctx->iopoll_list) || need_resched() ||
 			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
 			    !percpu_ref_is_dying(&ctx->refs))) {
 				io_run_task_work();
@@ -6373,13 +6373,13 @@ static int io_sq_thread(void *data)
 
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

