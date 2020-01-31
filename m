Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7456F14E83B
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 06:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgAaFZB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 00:25:01 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37212 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbgAaFZB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 00:25:01 -0500
Received: by mail-pg1-f193.google.com with SMTP id q127so2851319pga.4
        for <io-uring@vger.kernel.org>; Thu, 30 Jan 2020 21:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=cTZJjbub+t4whVe2OqpYAc4XOoLzdddWMo7ijJTomFM=;
        b=KduraYKzYhqELCevVnUJhvvWJEm7+o/w27ZI61EFQAhiIiheeoIqgnXLzC6hC+8Y1V
         sGsrNNBUDt0pL/TEZPs97hNbYua3UI9oSdJBAEGYCONXVrsUwFVLgbswDWtjnZQ7nDwe
         9txtJx7n3dg2/o4VwfI5CJsNFB+0umss8Kdfwp6xv7/O5DiVQDACQZda3X/DpvJS8+cs
         5W0EjQnBvqEWhRGxxwn0YUbknAYmLBBgxkcJxh6QuW3zbtKzl/LCbthMQGeoOp1l0oif
         9iIDibskLYFeWL8gCBYjNFfq3aEY/NWt3MIm3Hmq72tZ3tHUcvuSY/hdoHbdwfqzKKs1
         duIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=cTZJjbub+t4whVe2OqpYAc4XOoLzdddWMo7ijJTomFM=;
        b=FJ51Sw4XcIGkw62v0GcKA7bHz9bupZw/WtliYZqHWnTWnKVs0lpaNMuOSmiDPLqFqT
         5EE8N9n2SMZp6HWGTf27B+YLEgFumdd3KUp9v7FIhVaM28DpvzhyuFWFS1E5aMapiPxz
         wisYa9PPyZBi+XQe4ED7uQ81Vn6w7tjiC6GylT598Yll6QpjgB4nVP5tN/1EKrhzT+Lz
         1zCFVI/ZU85E/4IU0F89kR4BRgd8+mzug/PRUhsIjlxWvJJyp/62Nv2FQfSjSRjTBxXi
         IQAMTh4UwGvmGCFtVoKmtHSC+/y9rb6v/yPCWd9MqVt3nYTQwCs9oygXE4ky5rxEOFSy
         Qerg==
X-Gm-Message-State: APjAAAWYRPOKpPi+YXiF+1aDtWGyYKIPh4ARDryVjvb2A7Ihg92Ryc/f
        bGb2IRq1z98TCk0OVgMlamdyQdcYJzg=
X-Google-Smtp-Source: APXvYqxt2iYVgBm/1p7mu//DOKCkZvwyZhwHwrVOunRNrKeYCnKqyv4EWPEmHJEpHz5v7AakbcVFvg==
X-Received: by 2002:a63:4d4c:: with SMTP id n12mr8730380pgl.212.1580448299040;
        Thu, 30 Jan 2020 21:24:59 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id a185sm8406581pge.15.2020.01.30.21.24.58
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 21:24:58 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: prevent eventfd recursion on poll
Message-ID: <73f985c9-66df-3a80-3aee-05c89a35faad@kernel.dk>
Date:   Thu, 30 Jan 2020 22:24:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we register an eventfd with io_uring for completion notification,
and then subsequently does a poll for that very descriptor, then we
can trigger a deadlock scenario. Once a request completes and signals
the eventfd context, that will in turn trigger the poll command to
complete. When that poll request completes, it'll try trigger another
event on the eventfd, but this time off the path led us to complete
the poll in the first place. The result is a deadlock in eventfd,
as it tries to ctx->wqh.lock in a nested fashion.

Check if the file in question for the poll request is our eventfd
context, and if it is, don't trigger a nested event for the poll
completion.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

We're holding the file here, so checking ->private_data is fine.
It's a bit iffy in that it implies knowledge that this is where
eventfd stores the ctx. We could potentially make that helper in
eventfd, if needed.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ac5340fdcdfe..5788c2139c72 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1025,16 +1025,21 @@ static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
 	return io_wq_current_is_worker() || in_interrupt();
 }
 
-static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
+static void __io_cqring_ev_posted(struct io_ring_ctx *ctx, bool no_evfd)
 {
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 	if (waitqueue_active(&ctx->sqo_wait))
 		wake_up(&ctx->sqo_wait);
-	if (ctx->cq_ev_fd && io_should_trigger_evfd(ctx))
+	if (!no_evfd && ctx->cq_ev_fd && io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
 }
 
+static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
+{
+	__io_cqring_ev_posted(ctx, false);
+}
+
 /* Returns true if there are no backlogged entries after the flush */
 static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 {
@@ -3586,13 +3591,27 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 
 		if (llist_empty(&ctx->poll_llist) &&
 		    spin_trylock_irqsave(&ctx->completion_lock, flags)) {
+			bool no_evfd = false;
+
 			hash_del(&req->hash_node);
 			io_poll_complete(req, mask, 0);
 			req->flags |= REQ_F_COMP_LOCKED;
+
+			/*
+			 * If the file triggering the poll is our eventfd
+			 * context, then don't trigger another event for this
+			 * request. If we do, we can recurse, as this poll
+			 * request may be triggered by a completion that
+			 * signaled our eventfd.
+			 */
+			if (ctx->cq_ev_fd &&
+			    req->file->private_data == ctx->cq_ev_fd)
+				no_evfd = true;
+
 			io_put_req(req);
 			spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
-			io_cqring_ev_posted(ctx);
+			__io_cqring_ev_posted(ctx, no_evfd);
 			req = NULL;
 		} else {
 			req->result = mask;

-- 
Jens Axboe

