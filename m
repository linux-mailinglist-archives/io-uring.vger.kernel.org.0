Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7118615B1C9
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2020 21:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgBLUZV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Feb 2020 15:25:21 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:43334 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727439AbgBLUZV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Feb 2020 15:25:21 -0500
Received: by mail-io1-f68.google.com with SMTP id n21so3757669ioo.10
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2020 12:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5gWgkK4CCVekWJLLW86tj5RqvCBRggiH0AgKOeeYUQk=;
        b=cHEDyq7K2lLUbJCfYsEJiSXTwBcfC6aY7MupY2/5WqIWlygv7Biv8VnGqox9F664O7
         B81dkZZWAxhJwX+TyscwmyhXdr4iMtVi92KkDyEFoUUJvZWfm69HxPi8t/K1ULYLGJ8s
         FGqQDGpO5q0oW3jfL1NYBll/ViZOf/Priz1ekZ/ZY43s8DJjKSC11GnIE/bQT9RBldO7
         cDbyAfy2V3xpxCeTZKDZ74IdlpMR1AAF1v7HvXZ2QtSc8RHHEavy3GlZeE3CBzBPVhNv
         FceyFfdH9PYhTL8bYJdcThLvfpsXGma+RsOvCNakBAkhg07brUmFtQbNGJITYNbGZIGR
         A19g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5gWgkK4CCVekWJLLW86tj5RqvCBRggiH0AgKOeeYUQk=;
        b=K+yRq0dY9pB6N0sMxetkjFhE7ej8+FGr3Y9F0sTRLwn8x6AooM06Do76r+Ysk0CguT
         RjLj/KygBQ9Ch4ofCxq04Frb3Gy6Q3WcvPz7W2wNa2NvQgIxKCgoqwnEvx/RY/aCy5/3
         /7n/oBZ4RsPPoKQf709JBkbwfU/BAUua/scuUo+89HId+OzFIl+BgULdagbaU0uAs8PB
         FWWSC3UJXYf2NwptUoWv+2ejTrpRhJdVrjNnaA87+O46+kNb29uS+Emopdkh7Bp8wQax
         YKpqmUKEGuFDNKpHzqF5EmyinukqSsnsz7o/j8H+DuqVUNbFosZPbWoFBgEdxpuFp13c
         QNTA==
X-Gm-Message-State: APjAAAVtHi2ROrOsb4RrTl348EYQbj6FzbXkbU4i8wvFXN0aLB59K7+n
        Q38Eo2L6Gh+zZ+hK2RcLYhEihwfgLCE=
X-Google-Smtp-Source: APXvYqymDb2EAPhY3Rg2+77C/X/GBfFMs3MQOeZ9Lac/h364g8aLF4XTjZxv9umg0D+IAMUFMkDv1w==
X-Received: by 2002:a6b:b48e:: with SMTP id d136mr18448607iof.243.1581539119029;
        Wed, 12 Feb 2020 12:25:19 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 203sm37938ilb.42.2020.02.12.12.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 12:25:18 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: abstract out main poll wake handler
Date:   Wed, 12 Feb 2020 13:25:14 -0700
Message-Id: <20200212202515.15299-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200212202515.15299-1-axboe@kernel.dk>
References: <20200212202515.15299-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for having multiple poll waitqueues, abstract out the
main wake handler so we can call it with the desired data.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 74 +++++++++++++++++++++++++++------------------------
 1 file changed, 39 insertions(+), 35 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 08ffeb7df4f5..9cd2ce3b8ad9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3622,17 +3622,11 @@ static void io_poll_trigger_evfd(struct io_wq_work **workptr)
 	io_put_req(req);
 }
 
-static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
-			void *key)
+static void __io_poll_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
+			   __poll_t mask)
 {
-	struct io_kiocb *req = wait->private;
-	struct io_poll_iocb *poll = &req->poll;
 	struct io_ring_ctx *ctx = req->ctx;
-	__poll_t mask = key_to_poll(key);
-
-	/* for instances that support it check for an event match first: */
-	if (mask && !(mask & poll->events))
-		return 0;
+	unsigned long flags;
 
 	list_del_init(&poll->wait.entry);
 
@@ -3642,40 +3636,50 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	 * If we have a link timeout we're going to need the completion_lock
 	 * for finalizing the request, mark us as having grabbed that already.
 	 */
-	if (mask) {
-		unsigned long flags;
+	if (llist_empty(&ctx->poll_llist) && !req->io &&
+	    spin_trylock_irqsave(&ctx->completion_lock, flags)) {
+		bool trigger_ev;
 
-		if (llist_empty(&ctx->poll_llist) &&
-		    spin_trylock_irqsave(&ctx->completion_lock, flags)) {
-			bool trigger_ev;
-
-			hash_del(&req->hash_node);
-			io_poll_complete(req, mask, 0);
+		hash_del(&req->hash_node);
+		io_poll_complete(req, mask, 0);
 
-			trigger_ev = io_should_trigger_evfd(ctx);
-			if (trigger_ev && eventfd_signal_count()) {
-				trigger_ev = false;
-				req->work.func = io_poll_trigger_evfd;
-			} else {
-				req->flags |= REQ_F_COMP_LOCKED;
-				io_put_req(req);
-				req = NULL;
-			}
-			spin_unlock_irqrestore(&ctx->completion_lock, flags);
-			__io_cqring_ev_posted(ctx, trigger_ev);
+		trigger_ev = io_should_trigger_evfd(ctx);
+		if (trigger_ev && eventfd_signal_count()) {
+			trigger_ev = false;
+			req->work.func = io_poll_trigger_evfd;
 		} else {
-			req->result = mask;
-			req->llist_node.next = NULL;
-			/* if the list wasn't empty, we're done */
-			if (!llist_add(&req->llist_node, &ctx->poll_llist))
-				req = NULL;
-			else
-				req->work.func = io_poll_flush;
+			req->flags |= REQ_F_COMP_LOCKED;
+			io_put_req(req);
+			req = NULL;
 		}
+		spin_unlock_irqrestore(&ctx->completion_lock, flags);
+		__io_cqring_ev_posted(ctx, trigger_ev);
+	} else {
+		req->result = mask;
+		req->llist_node.next = NULL;
+		/* if the list wasn't empty, we're done */
+		if (!llist_add(&req->llist_node, &ctx->poll_llist))
+			req = NULL;
+		else
+			req->work.func = io_poll_flush;
 	}
+
 	if (req)
 		io_queue_async_work(req);
+}
+
+static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
+			void *key)
+{
+	struct io_kiocb *req = wait->private;
+	struct io_poll_iocb *poll = &req->poll;
+	__poll_t mask = key_to_poll(key);
+
+	/* for instances that support it check for an event match first: */
+	if (mask && !(mask & poll->events))
+		return 0;
 
+	__io_poll_wake(req, &req->poll, mask);
 	return 1;
 }
 
-- 
2.25.0

