Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4EF3DA721
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237794AbhG2PGp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237212AbhG2PGp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:45 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A69C061765
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:40 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id m12so2557114wru.12
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=XscRglXl2BIjZN+Fv+vJBw4QVRQsFG3yY471i8MV3WE=;
        b=bp49KIfvavoXPz2nSTLPWq8TY2/e5VeNK5CLSKLMMhnonTeUhFG/CLAs+jFv+6XNcI
         cCGwokiMbih9AdIZicujJ6GhhkI19Mf09WQboR9h5AeuQpU/xXUF+3U7v3yPj3WTX4nl
         YD5pA5UcHkNwGmJg6pPYXS7nb7WiXhA2fevgOacu+3C0Gh6Ls0SCXyrd0Ajwo0IRDohe
         zUnWRBVHCfos4HZ2Dcaak1eTB4oLd1jbGnxmkVubheAqQSPkiSySBYxXUBTla8IRRT++
         em2hiSXtuHK8cbdF2WwzwVZhXgKwJZlJb30t2IGeil2yToDjWEnFJ8I/kj7rE2pfdhwi
         XUQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XscRglXl2BIjZN+Fv+vJBw4QVRQsFG3yY471i8MV3WE=;
        b=eYW3PssdEiAtXKbHcU2TICmu0Pj7KQrEq9DkaPzULRW9MgQyMuD1wqDiKqNOUyu4rh
         KF53lWnQX90J6jWe+EkT35Fdbd4mX72G/9T70fitDQGiuTYNGwakplvUkWrhkgTjRkp0
         sxBEtKIEVhRRzj8YWQWIUr2TZMrLJuQa3GOcDY7VgGjbc5Lv2lIzjBL1jslt4u0yCr1S
         PhArWVG+cc4tCW+d2en+wvQs1A8QRsuBVXrvH1c8c4W2MLnghe7vn06ybt7whVb2naoG
         6hTfUCcKEQt4YrQuwF25DKGpqrcLtQQFZnrGqN5P8E8d4y3z5QhSxCmTNa3KMg59BVoS
         Pp8g==
X-Gm-Message-State: AOAM533QyilmizsvyTpAXTodhf0tWY0I9SvW1XH1D8D3eFQgh9F4mXkw
        wMPoJLp3OgmnfLHznzDYYSg=
X-Google-Smtp-Source: ABdhPJwVpZPzqp0+9svr0tARLnNR+1WLOJUekxDkntdDYY8rrqgTtOaZDdPtX5wQGudn0wi+QCk92Q==
X-Received: by 2002:a5d:4951:: with SMTP id r17mr5289360wrs.208.1627571199541;
        Thu, 29 Jul 2021 08:06:39 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 19/23] io_uring: use inflight_entry instead of compl.list
Date:   Thu, 29 Jul 2021 16:05:46 +0100
Message-Id: <ca9a57c5e941e1d276d99a9fe6a6fa085526b63c.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

req->compl.list is used to cache freed requests, and so can't overlap in
time with req->inflight_entry. So, use inflight_entry to link requests
and remove compl.list.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e690aec77543..6d843a956570 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -676,7 +676,6 @@ struct io_unlink {
 
 struct io_completion {
 	struct file			*file;
-	struct list_head		list;
 	u32				cflags;
 };
 
@@ -1669,7 +1668,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 		}
 		io_dismantle_req(req);
 		io_put_task(req->task, 1);
-		list_add(&req->compl.list, &ctx->locked_free_list);
+		list_add(&req->inflight_entry, &ctx->locked_free_list);
 		ctx->locked_free_nr++;
 	} else {
 		if (!percpu_ref_tryget(&ctx->refs))
@@ -1760,9 +1759,9 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 	nr = state->free_reqs;
 	while (!list_empty(&cs->free_list)) {
 		struct io_kiocb *req = list_first_entry(&cs->free_list,
-						struct io_kiocb, compl.list);
+					struct io_kiocb, inflight_entry);
 
-		list_del(&req->compl.list);
+		list_del(&req->inflight_entry);
 		state->reqs[nr++] = req;
 		if (nr == ARRAY_SIZE(state->reqs))
 			break;
@@ -1832,7 +1831,7 @@ static void __io_free_req(struct io_kiocb *req)
 	io_put_task(req->task, 1);
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-	list_add(&req->compl.list, &ctx->locked_free_list);
+	list_add(&req->inflight_entry, &ctx->locked_free_list);
 	ctx->locked_free_nr++;
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
@@ -2139,7 +2138,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 	if (state->free_reqs != ARRAY_SIZE(state->reqs))
 		state->reqs[state->free_reqs++] = req;
 	else
-		list_add(&req->compl.list, &state->comp.free_list);
+		list_add(&req->inflight_entry, &state->comp.free_list);
 }
 
 static void io_submit_flush_completions(struct io_ring_ctx *ctx)
@@ -8639,10 +8638,10 @@ static void io_req_cache_free(struct list_head *list, struct task_struct *tsk)
 {
 	struct io_kiocb *req, *nxt;
 
-	list_for_each_entry_safe(req, nxt, list, compl.list) {
+	list_for_each_entry_safe(req, nxt, list, inflight_entry) {
 		if (tsk && req->task != tsk)
 			continue;
-		list_del(&req->compl.list);
+		list_del(&req->inflight_entry);
 		kmem_cache_free(req_cachep, req);
 	}
 }
-- 
2.32.0

