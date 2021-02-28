Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7003274F3
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 23:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhB1Wkr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 17:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbhB1Wkp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 17:40:45 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49E1C0617AA
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:30 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id u11so6511722wmq.5
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PNVVZaRHwIzXbj+35nVD2QkU3OA3ylxhaJn7nFJ1/3k=;
        b=Y6U53M5OYZKMPWnznsIYFAyRUoK1CXpWuR8ZU/p2nlQBUHZ4jktFsZSXoxyEbRL/yv
         eh4FI93N/1qSZlRJWEzCA1ASygzmKkdRRWZ/r0MeTqYVpBX/ScbABPr3+U1KwuAoMZUT
         YonLJK6sweaXl6e6IsuNrB/UJNrzYgR0tFCz8EmEaqkvJIIzOqUejC/7ZP07Z+8JYlGF
         jaGjYElGWWjhTrQGaNbjR571CsaBQAupBP6NgEElYVAcnWMQE5w4CwdTrDBs/gxaezr4
         XGkov2MioRL977B14XRzUcIKu24BpXIFmHIUayqSvrUxHENem0o+ae80T4LO0Ji7GUrt
         +7tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PNVVZaRHwIzXbj+35nVD2QkU3OA3ylxhaJn7nFJ1/3k=;
        b=K6GkmMOlpfryFg+2WwSm7RNq6YbudQ5Atbx6lqqXbBW9B1KfvgFYhjM6BjY4zkIrZ8
         7tFWOTwKsp9EiUr81GOpkiqgb1JDx0maHdAc0WrV9dJIHw/k24+2jw2m7OF1wnCxpMCx
         tMmYA8+gbP3aZ5HfQhSRXAWjTC4SlKZpB1xtJYFqHA82IXbBIp8oof5JR6cpQO5Wm6ul
         0sq9mFmeuLmvfAtIaBKdJji/yFOe615n2hTgyLscmAXo3nztvARwlR5pBNkFZIUB51Rc
         5+vUYUmgZspoKcHXLVfKBID/klZPgpQnNuozZRHkF6kn4PyG/wXWRNAvLuBLyB7rvE3n
         enVw==
X-Gm-Message-State: AOAM530tmolIadvXA9Q+l/oXZ04oFTHUiBD+TjYa4z4x8QscMldPliEh
        ptWf2668FcoUPMzFYadzYiUKL5L/ubAF0w==
X-Google-Smtp-Source: ABdhPJxQ3hRna768e/Trwg7JupFV8Vb5MeYczbabMbR8Jj9iNYjey0sJCOstbzSVJvOjyGDV4aYDgg==
X-Received: by 2002:a7b:cbc1:: with SMTP id n1mr12976883wmi.30.1614551969410;
        Sun, 28 Feb 2021 14:39:29 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id y62sm22832576wmy.9.2021.02.28.14.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:39:29 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 12/12] io_uring: simplify io_resubmit_prep()
Date:   Sun, 28 Feb 2021 22:35:20 +0000
Message-Id: <d58fcfe96e8f5f6b9eaac0fede115e494b246030.1614551467.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614551467.git.asml.silence@gmail.com>
References: <cover.1614551467.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If not for async_data NULL check, io_resubmit_prep() is already an rw
specific version of io_req_prep_async(), but slower because 1) it always
goes through io_import_iovec() even if following io_setup_async_rw() the
result 2) instead of initialising iovec/iter in-place it does it
on-stack and then copies with io_setup_async_rw().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 37 +++----------------------------------
 1 file changed, 3 insertions(+), 34 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0bdaf5105d11..61697acf3717 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1014,14 +1014,10 @@ static struct file *io_file_get(struct io_submit_state *state,
 static void __io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
 
-static int io_import_iovec(int rw, struct io_kiocb *req, struct iovec **iovec,
-			   struct iov_iter *iter, bool needs_lock);
-static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
-			     const struct iovec *fast_iov,
-			     struct iov_iter *iter, bool force);
 static void io_req_task_queue(struct io_kiocb *req);
 static void io_submit_flush_completions(struct io_comp_state *cs,
 					struct io_ring_ctx *ctx);
+static int io_req_prep_async(struct io_kiocb *req);
 
 static struct kmem_cache *req_cachep;
 
@@ -2404,35 +2400,8 @@ static void kiocb_end_write(struct io_kiocb *req)
 #ifdef CONFIG_BLOCK
 static bool io_resubmit_prep(struct io_kiocb *req)
 {
-	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
-	int rw, ret;
-	struct iov_iter iter;
-
-	/* already prepared */
-	if (req->async_data)
-		return true;
-
-	switch (req->opcode) {
-	case IORING_OP_READV:
-	case IORING_OP_READ_FIXED:
-	case IORING_OP_READ:
-		rw = READ;
-		break;
-	case IORING_OP_WRITEV:
-	case IORING_OP_WRITE_FIXED:
-	case IORING_OP_WRITE:
-		rw = WRITE;
-		break;
-	default:
-		printk_once(KERN_WARNING "io_uring: bad opcode in resubmit %d\n",
-				req->opcode);
-		return false;
-	}
-
-	ret = io_import_iovec(rw, req, &iovec, &iter, false);
-	if (ret < 0)
-		return false;
-	return !io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
+	/* either already prepared or successfully done */
+	return req->async_data || !io_req_prep_async(req);
 }
 #endif
 
-- 
2.24.0

