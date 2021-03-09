Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2336331BD1
	for <lists+io-uring@lfdr.de>; Tue,  9 Mar 2021 01:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhCIAma (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 19:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbhCIAmG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 19:42:06 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3386C06174A
        for <io-uring@vger.kernel.org>; Mon,  8 Mar 2021 16:42:05 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id b18so13363270wrn.6
        for <io-uring@vger.kernel.org>; Mon, 08 Mar 2021 16:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=8SAn4WZ1fOieO9wkvpmIao05evRe35rZYFIjbjZwP04=;
        b=uTEZ4X1AEOCUJ9weYq+Kz7RsCCbnDVQsB864qKQ9ynASx6oQBFBuktun94vfj5OMKC
         +WEIGnwM7Ap3J/NOoOzldMxubj+ecfAHNLqA8ut/wCkKoxu85q+Q5zwZ6HORzjoZkZuL
         OpPk36MsUI8eJFg17lDr6kG052L8zW0mMX04kIlDZCVaM3lBBlkLc1lLtFvB40cEnVC4
         TdAlUWZCLo6aHAS73r36h7/SFbimpqHtMiraK2InD7IFCKunWbkJHwb2vC0thQu4uALJ
         XO5dwL69TnKn0iZv2QUbX12A0C3VdnGv3JTL9NUXJYph3aQ1gfRxzB9KOprwbeeR4A0e
         yLAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8SAn4WZ1fOieO9wkvpmIao05evRe35rZYFIjbjZwP04=;
        b=PfN7IyRY71Ze/sZLqbdiu11IOotGdgLhRdaGE+GR0JFsPDCrm+E4Qcfgo9shr3OpUo
         a38I+cGcKZwyPI4KEVeTA5Yxr2cZsZ0hJawbmPvpDINEDUVtnkWGcqYsCsjDgiC1xUtW
         S7XR2ME97bzhgfJOz/YxmeNZ0/UJGKVQoIgy9jka/L/tE4hIJEulcs01JAuueFh5NyhB
         9KWdIyMz9JrlC4Q1OJUydYpSIHp44aAwyU7SRI4nLkZa1CFbx26zGSzB1ark2Uufe9qk
         Qls84aYeOCnhJXJjIQ/pOsUYnI/nEwhy2xX/vse4kZwcCHCFYTqooXUvuUVgQvtYl9Er
         DtdQ==
X-Gm-Message-State: AOAM532SCnKMjpYWsfcyNOelGO6V4aB0WwXiLTIq3vtt4jQ40zabl71+
        fyX+HVcEWMYmTJdc5wmXlCY=
X-Google-Smtp-Source: ABdhPJyi4eA630l8bqXo/UBEA0RIWl9cWvGUCQzpswQVAmkRC3OhPDyS+NESCroX4M62fkmni8SRcg==
X-Received: by 2002:adf:cf11:: with SMTP id o17mr16655750wrj.391.1615250524687;
        Mon, 08 Mar 2021 16:42:04 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.144])
        by smtp.gmail.com with ESMTPSA id 3sm23918131wry.72.2021.03.08.16.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 16:42:04 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: fix complete_post races for linked req
Date:   Tue,  9 Mar 2021 00:37:59 +0000
Message-Id: <5672a62f3150ee7c55849f40c0037655c4f2840f.1615250156.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615250156.git.asml.silence@gmail.com>
References: <cover.1615250156.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Calling io_queue_next() after spin_unlock in io_req_complete_post()
races with the other side extracting and reusing this request. Hand
coded parts of io_req_find_next() considering that io_disarm_next()
and io_req_task_queue() have (and safe) to be called with
completion_lock held.

It already does io_commit_cqring() and io_cqring_ev_posted(), so just
reuse it for post io_disarm_next().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b4fa6fb371c5..87a71fda5745 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -986,6 +986,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_UNLINKAT] = {},
 };
 
+static bool io_disarm_next(struct io_kiocb *req);
 static void io_uring_del_task_file(unsigned long index);
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
@@ -1526,15 +1527,14 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 	__io_cqring_fill_event(req, res, 0);
 }
 
-static inline void io_req_complete_post(struct io_kiocb *req, long res,
-					unsigned int cflags)
+static void io_req_complete_post(struct io_kiocb *req, long res,
+				 unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 	__io_cqring_fill_event(req, res, cflags);
-	io_commit_cqring(ctx);
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
@@ -1542,19 +1542,26 @@ static inline void io_req_complete_post(struct io_kiocb *req, long res,
 	if (refcount_dec_and_test(&req->refs)) {
 		struct io_comp_state *cs = &ctx->submit_state.comp;
 
+		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
+			if (req->flags & (REQ_F_LINK_TIMEOUT | REQ_F_FAIL_LINK))
+				io_disarm_next(req);
+			if (req->link) {
+				io_req_task_queue(req->link);
+				req->link = NULL;
+			}
+		}
 		io_dismantle_req(req);
 		io_put_task(req->task, 1);
 		list_add(&req->compl.list, &cs->locked_free_list);
 		cs->locked_free_nr++;
 	} else
 		req = NULL;
+	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
-
 	io_cqring_ev_posted(ctx);
-	if (req) {
-		io_queue_next(req);
+
+	if (req)
 		percpu_ref_put(&ctx->refs);
-	}
 }
 
 static void io_req_complete_state(struct io_kiocb *req, long res,
-- 
2.24.0

