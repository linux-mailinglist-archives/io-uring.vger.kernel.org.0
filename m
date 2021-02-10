Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09AA315B08
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234010AbhBJAUi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234475AbhBJALY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:11:24 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E10C06121D
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 16:07:32 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id j21so339327wmj.0
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=apD0RU9ZXGOYeix8ngPPkcssR8+S/nnzKkWylVumhMk=;
        b=VAU+5EAViCIUtuOQ8ea4riHEpRujtG9M7Obv6IYEpmg4nLFwwBo/OXnWBqa0ud92i+
         7lKAlMlhHxK/v4NsD9SUDFNH3NkZyGclxMfozBIgJsp7+hOF/5uj5pK4GpO3T9I6N9ae
         gtgXpnhMAxT9fJTH8cYNBNMFctsQp8hab9KsJiszPVL52B5YldVD8PryTE/gW6M6VXyV
         kzQeCpoFJCO+Hm+SIDdQpMs5bk0J/s7QZE/3q8Wv39FBgDtVYPcUBbNJbKfyBFGDTxRg
         27K6W4k97X0wqVDTTCp2FhH6oGegxVPbLK4BniKLEjyUcdX4lVI702vBWy4EeYRdwQQO
         hg6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=apD0RU9ZXGOYeix8ngPPkcssR8+S/nnzKkWylVumhMk=;
        b=a5zdXJMxQrczERMXf0H1iUMkbjb7KEMmtQHaKcgjRBv8Qu7/ADk2FalzbzTlX4stRn
         ynFnR9kpRL1iXEjOcQ/1kiaMqZAMW8fOInZS64kcdMphRvVtYsVjU3NNNRl2EBSmu5Ca
         f4zdg/UBcr1mTa+CJfVhd2QnuvVVVHy9Ok9g5kHLo+AKRWs+UtJbb7qt9KaY5Nf6smcy
         F7AnmWNdgsL6RKlMrZZDrsH075VKyMOPH43aLSUx1fV86hZJeC/QY+H7HuWALK/IDfU3
         YshqlOU7+UxyRMXjeurvitwaArHsMlqSpayDrI5bRN951ui6NcKSCMvlb7CVwhYZsEwH
         GAFw==
X-Gm-Message-State: AOAM530tk6Kt8OLv/qOqxE43KW0AbCmdO59vyosRc4qUDTBUZs/Pkl7i
        ujNhyjEl88OauetqCoF4hI0=
X-Google-Smtp-Source: ABdhPJwq2Qn6XoyIIrZ+UXGRllek+OZY8v2GF7nYt5wnQoZWeiEVzbz10XlBjYo6acVQ1of52fl/zA==
X-Received: by 2002:a1c:7910:: with SMTP id l16mr489956wme.34.1612915651114;
        Tue, 09 Feb 2021 16:07:31 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id n15sm391082wrx.2.2021.02.09.16.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:07:30 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 16/17] io_uring: take comp_state from ctx
Date:   Wed, 10 Feb 2021 00:03:22 +0000
Message-Id: <3a53fc00ebc913e7d25b6d88034843cf5e642d91.1612915326.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612915326.git.asml.silence@gmail.com>
References: <cover.1612915326.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_queue_sqe() is always called with a non-NULL comp_state, which is
taken directly from context. Don't pass it around but infer from ctx.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f58a5459d6e3..64d3f3e2e93d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1042,7 +1042,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 static void __io_clean_op(struct io_kiocb *req);
 static struct file *io_file_get(struct io_submit_state *state,
 				struct io_kiocb *req, int fd, bool fixed);
-static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs);
+static void __io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
 
 static int io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
@@ -2301,7 +2301,7 @@ static void __io_req_task_submit(struct io_kiocb *req)
 	if (!ctx->sqo_dead &&
 	    !__io_sq_thread_acquire_mm(ctx) &&
 	    !__io_sq_thread_acquire_files(ctx))
-		__io_queue_sqe(req, &ctx->submit_state.comp);
+		__io_queue_sqe(req);
 	else
 		__io_req_task_cancel(req, -EFAULT);
 	mutex_unlock(&ctx->uring_lock);
@@ -6558,14 +6558,12 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 	return nxt;
 }
 
-static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
+static void __io_queue_sqe(struct io_kiocb *req)
 {
 	struct io_kiocb *linked_timeout;
 	const struct cred *old_creds = NULL;
-	int ret, issue_flags = IO_URING_F_NONBLOCK;
+	int ret;
 
-	if (cs)
-		issue_flags |= IO_URING_F_COMPLETE_DEFER;
 again:
 	linked_timeout = io_prep_linked_timeout(req);
 
@@ -6580,7 +6578,7 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 			old_creds = override_creds(req->work.identity->creds);
 	}
 
-	ret = io_issue_sqe(req, issue_flags);
+	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
@@ -6600,9 +6598,12 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 	} else if (likely(!ret)) {
 		/* drop submission reference */
 		if (req->flags & REQ_F_COMPLETE_INLINE) {
+			struct io_ring_ctx *ctx = req->ctx;
+			struct io_comp_state *cs = &ctx->submit_state.comp;
+
 			cs->reqs[cs->nr++] = req;
 			if (cs->nr == IO_COMPL_BATCH)
-				io_submit_flush_completions(cs, req->ctx);
+				io_submit_flush_completions(cs, ctx);
 			req = NULL;
 		} else {
 			req = io_put_req_find_next(req);
@@ -6628,8 +6629,7 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 		revert_creds(old_creds);
 }
 
-static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			 struct io_comp_state *cs)
+static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	int ret;
 
@@ -6654,18 +6654,17 @@ static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			if (unlikely(ret))
 				goto fail_req;
 		}
-		__io_queue_sqe(req, cs);
+		__io_queue_sqe(req);
 	}
 }
 
-static inline void io_queue_link_head(struct io_kiocb *req,
-				      struct io_comp_state *cs)
+static inline void io_queue_link_head(struct io_kiocb *req)
 {
 	if (unlikely(req->flags & REQ_F_FAIL_LINK)) {
 		io_put_req(req);
 		io_req_complete(req, -ECANCELED);
 	} else
-		io_queue_sqe(req, NULL, cs);
+		io_queue_sqe(req, NULL);
 }
 
 struct io_submit_link {
@@ -6674,7 +6673,7 @@ struct io_submit_link {
 };
 
 static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			 struct io_submit_link *link, struct io_comp_state *cs)
+			 struct io_submit_link *link)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
@@ -6712,7 +6711,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 		/* last request of a link, enqueue the link */
 		if (!(req->flags & (REQ_F_LINK | REQ_F_HARDLINK))) {
-			io_queue_link_head(head, cs);
+			io_queue_link_head(head);
 			link->head = NULL;
 		}
 	} else {
@@ -6727,7 +6726,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			link->head = req;
 			link->last = req;
 		} else {
-			io_queue_sqe(req, sqe, cs);
+			io_queue_sqe(req, sqe);
 		}
 	}
 
@@ -6968,7 +6967,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 					true, ctx->flags & IORING_SETUP_SQPOLL);
-		err = io_submit_sqe(req, sqe, &link, &ctx->submit_state.comp);
+		err = io_submit_sqe(req, sqe, &link);
 		if (err)
 			goto fail_req;
 	}
@@ -6983,7 +6982,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		put_task_struct_many(current, unused);
 	}
 	if (link.head)
-		io_queue_link_head(link.head, &ctx->submit_state.comp);
+		io_queue_link_head(link.head);
 	io_submit_state_end(&ctx->submit_state, ctx);
 
 	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
-- 
2.24.0

