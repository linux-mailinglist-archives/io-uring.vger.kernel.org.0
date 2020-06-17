Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B8B1FC335
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 03:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgFQBJi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 21:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgFQBJi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 21:09:38 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F24C061573
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 18:09:37 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k2so215590pjs.2
        for <io-uring@vger.kernel.org>; Tue, 16 Jun 2020 18:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=3eiz3SnE/6EIpV0fyvbC1930QWh8RdDe+fFaI3mR9vg=;
        b=HU+mYmIdjVpRZvOx7DBxft5sgddd8PP3v9A5nIfEQLEACnNugfCDV9XPQNSppCscXy
         rMhAWDh9GsSia/lCECyDxgaS31c8+NJdrPdw5VkPRMAD5rBq5yzcFKDSI9clDtRpAtN9
         4cda/IkwGPFRm/GJpxdIyjEaZErNaaW8pC2I0qNFD9IOyeH+Z4zJ+IlupITKuxB4bLTl
         zl8k3RPlNmVKmSZ1vEbflVap0IOptCkhJQhyLNqW52Rczav2u570ilGD2Avk6i9t918a
         1zoCS1+xxWuhIXnwwxaHbvlrfy48DIpdMLGyZZDsattM4r+zJkZGqTYfKloHM+2GpPS3
         DprA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=3eiz3SnE/6EIpV0fyvbC1930QWh8RdDe+fFaI3mR9vg=;
        b=sEkQcUGYl0meEEmWYxr04nwErmCs1QgpZejGzmdjsqs6nwouHB/fubc8p4oMPMoWP5
         oamGwX9EVG9JTwJx1szBv6bZzLRAldVASSPEIlXYSJFUE6AY9WOlvi52DfbJ99BPCA/D
         2OkB3jcXBYSpow7J4UqYP3TxI66jVi/SVE+QGBmhciOQrJFw32UUF9MZtJLGO4iah8wn
         LaRM3Px/jBtscIjVr+Y3dmqlun0DQEAqso2td56T1Yrc5Jykfx8cheT1LHyZmBhgl59f
         HfUxtS9C4Ib+thyrGtvIVB3pXGNroheSkebQHD3Twa9zHXQjQIOZq9GgLyWmXbljk9Mm
         yoWg==
X-Gm-Message-State: AOAM532dLI8Uxuf4hAKm1TOT6ot1s3ZH08Ek1nI9yDJrGfC+PotvSRrZ
        brVX4SYYajkZ1fLvytUyAAGpnbxszVY1Dw==
X-Google-Smtp-Source: ABdhPJzmHCAEcn2hJZCeX8nbiDhwFOwqqPGNKKTvevmEBFQHN4KA4VkZ+2olmxYeWT4VY562rASoaA==
X-Received: by 2002:a17:902:7785:: with SMTP id o5mr4512702pll.288.1592356176764;
        Tue, 16 Jun 2020 18:09:36 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 17sm18629756pfn.19.2020.06.16.18.09.35
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jun 2020 18:09:36 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: acquire 'mm' for task_work for SQPOLL
Message-ID: <e5e1402f-75b6-0c83-0db9-9abdd0ed7466@kernel.dk>
Date:   Tue, 16 Jun 2020 19:09:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we're unlucky with timing, we could be running task_work after
having dropped the memory context in the sq thread. Since dropping
the context requires a runnable task state, we cannot reliably drop
it as part of our check-for-work loop in io_sq_thread(). Instead,
abstract out the mm acquire for the sq thread into a helper, and call
it from the async task work handler.

Cc: stable@vger.kernel.org # v5.7
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 918f70fa34ce..1d2ae07fa14d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4254,6 +4254,28 @@ static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
 	__io_queue_proc(&pt->req->apoll->poll, pt, head);
 }
 
+static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
+{
+	struct mm_struct *mm = current->mm;
+
+	if (mm) {
+		kthread_unuse_mm(mm);
+		mmput(mm);
+	}
+}
+
+static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
+				   struct io_kiocb *req)
+{
+	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
+		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
+			return -EFAULT;
+		kthread_use_mm(ctx->sqo_mm);
+	}
+
+	return 0;
+}
+
 static void io_async_task_func(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
@@ -4288,11 +4310,16 @@ static void io_async_task_func(struct callback_head *cb)
 
 	if (!canceled) {
 		__set_current_state(TASK_RUNNING);
+		if (io_sq_thread_acquire_mm(ctx, req)) {
+			io_cqring_add_event(req, -EFAULT);
+			goto end_req;
+		}
 		mutex_lock(&ctx->uring_lock);
 		__io_queue_sqe(req, NULL);
 		mutex_unlock(&ctx->uring_lock);
 	} else {
 		io_cqring_ev_posted(ctx);
+end_req:
 		req_set_fail_links(req);
 		io_double_put_req(req);
 	}
@@ -5839,11 +5866,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
 
-	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
-		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
-			return -EFAULT;
-		kthread_use_mm(ctx->sqo_mm);
-	}
+	if (unlikely(io_sq_thread_acquire_mm(ctx, req)))
+		return -EFAULT;
 
 	sqe_flags = READ_ONCE(sqe->flags);
 	/* enforce forwards compatibility on users */
@@ -5952,16 +5976,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	return submitted;
 }
 
-static inline void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
-{
-	struct mm_struct *mm = current->mm;
-
-	if (mm) {
-		kthread_unuse_mm(mm);
-		mmput(mm);
-	}
-}
-
 static int io_sq_thread(void *data)
 {
 	struct io_ring_ctx *ctx = data;

-- 
Jens Axboe

