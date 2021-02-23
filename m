Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245A13223FF
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 03:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhBWCBR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 21:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbhBWCBO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 21:01:14 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507B6C061356
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 18:00:01 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id u14so21022602wri.3
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 18:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=B662l08IK11z/2XTkPIuAUjgOURK3qMB8FyZJkpGDCQ=;
        b=IQgj6tbp1VppAVB3lGTHnww8/qjfBqJskXaPXJEj6FXw6Huw7fmfB1U2WsCQmYbB37
         fWo5A4h0FvzdCJYmae1nG0CLvzP/QfNcSTQ3YNihic+S5bkX9DN7pHu45/tDm6WQDxup
         B0l9DeqeUXQ3LBa0t4NdJ4Do4upZOs1NWe6RU5C9k8dzpfg42MYMCHNev/RKDY13/GLP
         ibNYQRUc42zrvh1TIdLKy4I1B3kbiW4+vUesX0B64T6zvDwla5LZ89co/0ZJIhzOrZGk
         vKxcrnkzNMJu6+eXLe+qS/ompiRiLmFJJoN5Q4pCQcWTgiF1MVwSuTozyfgr8A/fYFhU
         oZNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B662l08IK11z/2XTkPIuAUjgOURK3qMB8FyZJkpGDCQ=;
        b=eCxO40bjcITLNykLC8AVeINY619RcjAuUUjTQR1eWaOqCys1YUvUNP/NnK4jig8mOd
         RREfQ8ZDnp1jUJevnNc0/Apsd0snAetE7j8/3ThxeChk7mU56f7bepw2fnQXmtm15DnT
         oD3fUX4IRg/7WOXPkTzgjCibTbjAtVXResF8K3IK+oLAVlcXIAVA+OGXK1omMAgBHdcb
         QBbKe20J07p1hGlCvOsk4nTolXD3DdIMofDCus9lpy2fLd8BleCcWYKSlCgDLMkonKq8
         FiGzrgmmBG2LoS02kYeMpT5nb6HJH5WNm2QG4Rbjio9Ir4Io16XkDImcKvfjqKj4U9+o
         +nhg==
X-Gm-Message-State: AOAM530L+LBbRUDOTgi1j6Y0UFWrgmIriwUtb9leeGi/VuhZH+PpRySS
        I2Wq8TWqHEqvuARSKkmmgMHk3JBpolQ=
X-Google-Smtp-Source: ABdhPJy5vA/t3kzlP1gED4CXj6OFu6Ch2TWZT5B8xvrIHI3KyOjXZoLkl4bEXBOVAozRw2HoYpAf5w==
X-Received: by 2002:a05:6000:2aa:: with SMTP id l10mr24228069wry.368.1614045600174;
        Mon, 22 Feb 2021 18:00:00 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id 4sm32425501wrr.27.2021.02.22.17.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 17:59:59 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 13/13] io_uring: simplify io_resubmit_prep()
Date:   Tue, 23 Feb 2021 01:55:48 +0000
Message-Id: <9db072e0a64d51c4f77d850d381e9b021dcf30bd.1614045169.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614045169.git.asml.silence@gmail.com>
References: <cover.1614045169.git.asml.silence@gmail.com>
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
index 34cd1b9545c1..97002de5e0d2 100644
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
 
@@ -2454,35 +2450,8 @@ static void kiocb_end_write(struct io_kiocb *req)
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

