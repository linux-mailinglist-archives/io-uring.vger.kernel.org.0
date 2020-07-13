Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3FC321E3C9
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2020 01:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgGMXoH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 19:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbgGMXn7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 19:43:59 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDEEC061794;
        Mon, 13 Jul 2020 16:43:58 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id f12so19447265eja.9;
        Mon, 13 Jul 2020 16:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7FE6Gq0R+rbH37mVjTE37qvA0VNf6iTNJ2JVteVF6QY=;
        b=ChjWzhUTFd3ZWontlFJUbIF1bCDJZWVrCnVutln+mX2nl95ya2shljj1f1hqfyJOmP
         BNNsbGFDrEGeYn/hZNLG3tydF2lKzNXrNvf+er/gNd6Bs+7D85rTOEkPtAwCK03tG3ly
         rxfZJiLbUKrOAgYMsnmHfVjtu9XlLbX178S77sZDICn+EnR4IytJ9BVKUQ2SbhG28n7s
         LlO84BOizTGlKehwTr8dKmICV7sApijJCBhP7XvCzZm/UVQDZQPukhrEal8BYxWTGloL
         uHtUrdrOe44pdqe5UonTt2lSKPFyr8WbA33WehsX47NZ0SZsKWpncj+ML5B7oRwtdU9e
         6cOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7FE6Gq0R+rbH37mVjTE37qvA0VNf6iTNJ2JVteVF6QY=;
        b=JCkk4s/VUZ4ijGjiHRtVS52h8zAc1iPu2v8E9lecG6hMp783nMJkVy98wPUlfKqxUG
         ty9hu0ShQGNZU3GtcKTVNxWondRGrkCgC4MJWbBjFlg/ezZp0My/govpXor0bCN5jwRM
         ZlFmvkZvNogfCNkc5cDvH9J14hRItmw6JohXLkGLRbaApMkonT5mGB1k1ikXWun/dXqB
         4v/Lks9c5xK58TsQC6voH9JfSEZO0t18H6zb6L5N6s8PZwtjsILddW8MGtIb9adSUXma
         GYkrM5fTzLvmsL5MEAVwEIdXRMepDoXAxNiSA68wD0kXhxDZW8030tqYtMFrqcSem1ET
         Zzwg==
X-Gm-Message-State: AOAM530b10UhypvOFytlDEKFZZmrHPjySv0NfDRZUKDRDL9AmKnUoQHp
        +v3tVPJOm1GBVpJFgf++b15x1mbO
X-Google-Smtp-Source: ABdhPJyCydA993JsuDAmn2drmLzjH1PmbTOTUxyKBVW5K902aURzPlnlRHO0JYKt1ahzZndqQg8Bvg==
X-Received: by 2002:a17:906:4dd4:: with SMTP id f20mr2127738ejw.170.1594683837571;
        Mon, 13 Jul 2020 16:43:57 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id a13sm12964712edk.58.2020.07.13.16.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 16:43:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] io_uring: batch put_task_struct()
Date:   Tue, 14 Jul 2020 02:41:56 +0300
Message-Id: <15a2db7fa57e5e78ed2677d21bb70dd3d32f8deb.1594683622.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594683622.git.asml.silence@gmail.com>
References: <cover.1594683622.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Each put_task_struct() is an atomic_dec. Do that in batches.

Tested io_uring-bench(iopoll,QD=128) with a custom nullblk, where
added ->iopoll() is not optimised at all:

before: 529504 IOPS
after: 	538415 IOPS
diff:	~1.8%

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6f767781351f..3216cc00061b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1761,8 +1761,18 @@ static void io_free_req(struct io_kiocb *req)
 struct req_batch {
 	void *reqs[IO_IOPOLL_BATCH];
 	int to_free;
+
+	struct task_struct	*task;
+	int			task_refs;
 };
 
+static void io_init_req_batch(struct req_batch *rb)
+{
+	rb->to_free = 0;
+	rb->task_refs = 0;
+	rb->task = NULL;
+}
+
 static void __io_req_free_batch_flush(struct io_ring_ctx *ctx,
 				      struct req_batch *rb)
 {
@@ -1776,6 +1786,10 @@ static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
 {
 	if (rb->to_free)
 		__io_req_free_batch_flush(ctx, rb);
+	if (rb->task) {
+		put_task_struct_many(rb->task, rb->task_refs);
+		rb->task = NULL;
+	}
 }
 
 static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
@@ -1787,6 +1801,16 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 	if (req->flags & REQ_F_LINK_HEAD)
 		io_queue_next(req);
 
+	if (req->flags & REQ_F_TASK_PINNED) {
+		if (req->task != rb->task && rb->task) {
+			put_task_struct_many(rb->task, rb->task_refs);
+			rb->task = req->task;
+			rb->task_refs = 0;
+		}
+		rb->task_refs++;
+		req->flags &= ~REQ_F_TASK_PINNED;
+	}
+
 	io_dismantle_req(req);
 	rb->reqs[rb->to_free++] = req;
 	if (unlikely(rb->to_free == ARRAY_SIZE(rb->reqs)))
@@ -1809,7 +1833,7 @@ static void io_submit_flush_completions(struct io_comp_state *cs)
 	spin_unlock_irq(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
 
-	rb.to_free = 0;
+	io_init_req_batch(&rb);
 	for (i = 0; i < nr; ++i) {
 		req = cs->reqs[i];
 		if (refcount_dec_and_test(&req->refs))
@@ -1973,7 +1997,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	/* order with ->result store in io_complete_rw_iopoll() */
 	smp_rmb();
 
-	rb.to_free = 0;
+	io_init_req_batch(&rb);
 	while (!list_empty(done)) {
 		int cflags = 0;
 
-- 
2.24.0

