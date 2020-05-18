Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B0E1D6E34
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2020 02:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgERAGY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 20:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbgERAGY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 20:06:24 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22894C061A0C
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 17:06:24 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id a13so1930195pls.8
        for <io-uring@vger.kernel.org>; Sun, 17 May 2020 17:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=pUCSigDlet1rXMB134rWH5anninjyWJp0STM9Q7T2nw=;
        b=Ww2xhlVU7tMO4dbSjxE1fQepjD9dUIMsI/3Jwaw+ONVvVWZSBzL1P4nvHe/TVKzk/a
         kZ1MD/g4pXGs9dE7WAmsxO/2LShAD0WqAlkzUbstKrkv2eD2IVJDyE6dy1QPCDpEu3NP
         wJk5BpliBEpMhH8IxrFeBSz8EgkG6eNid7VjXLtDnEk+/W9aBkJBFF60wJ8ybQgP/Kb8
         Z99YO3H5GFBmIFoTu9e9OidDngvt3+XGiguhtCMIjgbdOQlvZbVfjhKJGKT+97vNwWQi
         jjVSdwHrdywJ1GVMIjtkxNRP8URBpLV33zbBSFC/Ysi6/JVHGZkh+3P+OkJybX2edyLF
         FBbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=pUCSigDlet1rXMB134rWH5anninjyWJp0STM9Q7T2nw=;
        b=tHn1gpuPdQiA1qaHArLvgzJ2mxvNPYNJMe2YPG4GWvD8Ti2hgpSmqajr1QYU6sctyi
         cmBWzwoIWj32sbrT9nlD6pUr/77CaYV5LsyvjQTD9zA8hmW3c+bWCGyQl9wcqmIN5xHY
         HyZfmQhfqC6I4Tw/YIcDmLuZSA3RIE3WpNQ0Bad1cKaDisimdMRLgswbnAzWGDFK7Bd2
         rK+/+7kDKMsrIsdHCWwmOyFgVjqT/iPeKnIPMe4UklL+z8QYIL1WOZtc8TaMoYM6XMrE
         XoXqKW9NovW2nWx7n75oEg+9j4jB24K/FqbBvqVHsgODuI6VWrUCHnh/R89r/ZmVTVjv
         vCcQ==
X-Gm-Message-State: AOAM532ZSZxzd6NQ6w1ovUuZqn0dXODH6d/l6EoCQSfKedNMZFJlQErK
        kiUslcbSM3MvVIHd18yNRdpYQxQuIfc=
X-Google-Smtp-Source: ABdhPJweeQE7pTnauhrz7mw5kVVGglTGe0Q0SGPAfAdq703WCNdVm54h5aLo4Dj9T1fcltzk+M6nRA==
X-Received: by 2002:a17:902:c403:: with SMTP id k3mr14042256plk.12.1589760383287;
        Sun, 17 May 2020 17:06:23 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:91d6:39a4:5ac7:f84a? ([2605:e000:100e:8c61:91d6:39a4:5ac7:f84a])
        by smtp.gmail.com with ESMTPSA id k10sm7117912pfa.163.2020.05.17.17.06.22
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 May 2020 17:06:22 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: async task poll trigger cleanup
Message-ID: <a0c564e2-14e8-a70d-a171-f695ec62fb31@kernel.dk>
Date:   Sun, 17 May 2020 18:06:21 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the request is still hashed in io_async_task_func(), then it cannot
have been canceled and it's pointless to check. So save that check.
Likewise, for the poll state, if we're freeing apoll, don't bother
marking it as done.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1317a4478994..4c73ed76cac7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4354,7 +4354,7 @@ static void io_async_task_func(struct callback_head *cb)
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
 	struct async_poll *apoll = req->apoll;
 	struct io_ring_ctx *ctx = req->ctx;
-	bool canceled;
+	bool canceled = false;
 
 	trace_io_uring_task_run(req->ctx, req->opcode, req->user_data);
 
@@ -4363,34 +4363,33 @@ static void io_async_task_func(struct callback_head *cb)
 		return;
 	}
 
-	if (hash_hashed(&req->hash_node))
+	/* If req is still hashed, it cannot have been canceled. Don't check. */
+	if (hash_hashed(&req->hash_node)) {
 		hash_del(&req->hash_node);
-
-	canceled = READ_ONCE(apoll->poll.canceled);
-	if (canceled) {
-		io_cqring_fill_event(req, -ECANCELED);
-		io_commit_cqring(ctx);
+	} else {
+		canceled = READ_ONCE(apoll->poll.canceled);
+		if (canceled) {
+			io_cqring_fill_event(req, -ECANCELED);
+			io_commit_cqring(ctx);
+		}
 	}
 
 	spin_unlock_irq(&ctx->completion_lock);
 
 	/* restore ->work in case we need to retry again */
 	memcpy(&req->work, &apoll->work, sizeof(req->work));
+	kfree(apoll);
 
-	if (canceled) {
-		kfree(apoll);
+	if (!canceled) {
+		__set_current_state(TASK_RUNNING);
+		mutex_lock(&ctx->uring_lock);
+		__io_queue_sqe(req, NULL);
+		mutex_unlock(&ctx->uring_lock);
+	} else {
 		io_cqring_ev_posted(ctx);
 		req_set_fail_links(req);
 		io_double_put_req(req);
-		return;
 	}
-
-	__set_current_state(TASK_RUNNING);
-	mutex_lock(&ctx->uring_lock);
-	__io_queue_sqe(req, NULL);
-	mutex_unlock(&ctx->uring_lock);
-
-	kfree(apoll);
 }
 
 static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
@@ -4496,7 +4495,6 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 					io_async_wake);
 	if (ret) {
 		ipt.error = 0;
-		apoll->poll.done = true;
 		/* only remove double add if we did it here */
 		if (!had_io)
 			io_poll_remove_double(req);
-- 
2.26.2

-- 
Jens Axboe

