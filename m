Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D58E721E190
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 22:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgGMUje (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 16:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgGMUje (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 16:39:34 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029EDC061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:34 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id y10so18962876eje.1
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 13:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=X01g7HfEFVygugSf7sx9KK92FjEM3+iEN3wu7B7htSI=;
        b=MD04VOrkAzpUxMBDpu+dMlsZKWgjcus63J9bOE7jJjw5atzTGBHo2S4sTuKYG8ej/U
         1SPAaAdhm2Po8To4y7ZrdkOgGg/pWbi8GMNLvFP/emjZkjMXI0/QsYXls6jEL/KxQLfR
         Dz8cIj4TeJpbzWIXLUAdUXjwMg67xsdFYxtYqJPVomGMee7lLVHVZ2Uglwvx5vm0sIuB
         grurQ+SpyN7XZbrU4IFXlaJPL79NelOumqQ5b8UsWcRdzuEy0EnWkdg9j9uRVqEZfO2q
         tIOIZf/PMmnHdI4q0u6naU4Y5uwgPyC/c3Oiqa8YHit2ZEPtxAPS699rJhfCR2V5VTQI
         tiow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X01g7HfEFVygugSf7sx9KK92FjEM3+iEN3wu7B7htSI=;
        b=s0fMIGDpe3J2NpTUYEX5oTqfDxRkuFlgESwydSbZJCl0Sae0t+lPiOKOiSMwGICgUm
         MUo9nsL373yTmauaTsTguZYL1Irqstc63fljtgDMnXesqqHVaOitOKFZPFx2r7fPF0fg
         +1IbLDXYNfptW2i22ZCpLuKqEQQvVejGLJERdnkVBYptjugjhitWWw7dtYoV9whifVR8
         83GXvGDtTbQgoP/Kg8iHozkQiy0DCv6Vfm917noqb/tLgyGk6RYudjhNt4A+lLNz1xkN
         wvgA0pEMfCAtK25oZFVaHIV4dSWaO0KX+NZsimzye/p77YfnZj3uFtkcxDO5CJtBNKoL
         EaOg==
X-Gm-Message-State: AOAM5310uRm83p71jHCHWaEpsP6bwFk94AeisVQ0g9lQUNQf/uGeUu+0
        UEXbY6STILm8VMyCYQZNn02jTnby
X-Google-Smtp-Source: ABdhPJyv71Uc91Cd0lBlBczn+hOeebX1vg0APCDi5Hdu/pI6JGYrY/VXO1QMT1P3DB8vNh6i80zcPg==
X-Received: by 2002:a17:907:411b:: with SMTP id nw19mr1481233ejb.84.1594672772665;
        Mon, 13 Jul 2020 13:39:32 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id m14sm10491855ejx.80.2020.07.13.13.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 13:39:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 8/9] io_uring: remove sequence from io_kiocb
Date:   Mon, 13 Jul 2020 23:37:15 +0300
Message-Id: <f4d92a1791405921170ce3a7612ea7ce69cae68b.1594670798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594670798.git.asml.silence@gmail.com>
References: <cover.1594670798.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->sequence is used only for deferred (i.e. DRAIN) requests, but
initialised for every request. Remove req->sequence from io_kiocb
together with its initialisation in io_init_req().

Replace it with a new field in struct io_defer_entry, that will be
calculated only when needed in io_req_defer(), which is a slow path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 44 ++++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 672eb57565dc..e70129fac6db 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -638,6 +638,7 @@ struct io_kiocb {
 	u8				iopoll_completed;
 
 	u16				buf_index;
+	u32				result;
 
 	struct io_ring_ctx	*ctx;
 	unsigned int		flags;
@@ -645,8 +646,6 @@ struct io_kiocb {
 	struct task_struct	*task;
 	unsigned long		fsize;
 	u64			user_data;
-	u32			result;
-	u32			sequence;
 
 	struct list_head	link_list;
 
@@ -677,6 +676,7 @@ struct io_kiocb {
 struct io_defer_entry {
 	struct list_head	list;
 	struct io_kiocb		*req;
+	u32			seq;
 };
 
 #define IO_IOPOLL_BATCH			8
@@ -1089,13 +1089,13 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	return NULL;
 }
 
-static inline bool req_need_defer(struct io_kiocb *req)
+static bool req_need_defer(struct io_kiocb *req, u32 seq)
 {
 	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
 		struct io_ring_ctx *ctx = req->ctx;
 
-		return req->sequence != ctx->cached_cq_tail
-					+ atomic_read(&ctx->cached_cq_overflow);
+		return seq != ctx->cached_cq_tail
+				+ atomic_read(&ctx->cached_cq_overflow);
 	}
 
 	return false;
@@ -1240,7 +1240,7 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
 						struct io_defer_entry, list);
 
-		if (req_need_defer(de->req))
+		if (req_need_defer(de->req, de->seq))
 			break;
 		list_del_init(&de->list);
 		/* punt-init is done before queueing for defer */
@@ -5374,14 +5374,35 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	return ret;
 }
 
+static u32 io_get_sequence(struct io_kiocb *req)
+{
+	struct io_kiocb *pos;
+	struct io_ring_ctx *ctx = req->ctx;
+	u32 total_submitted, nr_reqs = 1;
+
+	if (req->flags & REQ_F_LINK_HEAD)
+		list_for_each_entry(pos, &req->link_list, link_list)
+			nr_reqs++;
+
+	total_submitted = ctx->cached_sq_head - ctx->cached_sq_dropped;
+	return total_submitted - nr_reqs;
+}
+
 static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_defer_entry *de;
 	int ret;
+	u32 seq;
 
 	/* Still need defer if there is pending req in defer list. */
-	if (!req_need_defer(req) && list_empty_careful(&ctx->defer_list))
+	if (likely(list_empty_careful(&ctx->defer_list) &&
+		!(req->flags & REQ_F_IO_DRAIN)))
+		return 0;
+
+	seq = io_get_sequence(req);
+	/* Still a chance to pass the sequence check */
+	if (!req_need_defer(req, seq) && list_empty_careful(&ctx->defer_list))
 		return 0;
 
 	if (!req->io) {
@@ -5397,7 +5418,7 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -ENOMEM;
 
 	spin_lock_irq(&ctx->completion_lock);
-	if (!req_need_defer(req) && list_empty(&ctx->defer_list)) {
+	if (!req_need_defer(req, seq) && list_empty(&ctx->defer_list)) {
 		spin_unlock_irq(&ctx->completion_lock);
 		kfree(de);
 		return 0;
@@ -5405,6 +5426,7 @@ static int io_req_defer(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	trace_io_uring_defer(ctx, req, req->user_data);
 	de->req = req;
+	de->seq = seq;
 	list_add_tail(&de->list, &ctx->defer_list);
 	spin_unlock_irq(&ctx->completion_lock);
 	return -EIOCBQUEUED;
@@ -6181,12 +6203,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	unsigned int sqe_flags;
 	int id;
 
-	/*
-	 * All io need record the previous position, if LINK vs DARIN,
-	 * it can be used to mark the position of the first IO in the
-	 * link list.
-	 */
-	req->sequence = ctx->cached_sq_head - ctx->cached_sq_dropped;
 	req->opcode = READ_ONCE(sqe->opcode);
 	req->user_data = READ_ONCE(sqe->user_data);
 	req->io = NULL;
-- 
2.24.0

