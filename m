Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4368B15847A
	for <lists+io-uring@lfdr.de>; Mon, 10 Feb 2020 21:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgBJU44 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Feb 2020 15:56:56 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:36934 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbgBJU44 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Feb 2020 15:56:56 -0500
Received: by mail-il1-f194.google.com with SMTP id v13so1506126iln.4
        for <io-uring@vger.kernel.org>; Mon, 10 Feb 2020 12:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5y671uGiDSKHfW8KVEFUs1Gx0eX8vLMJuiKdYZTTxiM=;
        b=wlQuyOeJqbkBDgInYTO9D+VqDpnlLJZ75cIetH47dEfYzrsdUJQq5rkHnWUnpUoa2N
         LvwJHETWnH1tXrYUSldAXrWHiG0ibCGbDc7acTykNRyN5RhxYoRsAiMzqX+4TZHG7/nJ
         /KfLVInjicESq4Bl2EYopIJ0N2WZZPcjUgWkuLndtr6dKHxLpAMIKY9qqtwjCLYpA0oe
         eCL1BPPEtlo2vO7geTcw4H/FaAF+bfnwHQepMj0unzGpxdpk2VQyznd3Gc1yRpI0jtXO
         KGBuuKjVZBGFHCKlt8GbGuq0jnQx/KySfavSyyOPsjSNwUE6C++S5M/olmuk4C7RUA3O
         DAvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5y671uGiDSKHfW8KVEFUs1Gx0eX8vLMJuiKdYZTTxiM=;
        b=Suifknku0lv0wB/72AnS9xoBNmKnIPBplZ2p0nmYEqTywJCFaXOB1GTKyppLtx1ArO
         N553TWTd4YPsa7V63jcTxObK7dmhV+WM9vPJqUMsU4cMGsnRkSe+k2iRvAqRsZ06wg69
         P/JyoAri5L/rsMVWqocH62i2ZwNIBnJhlCLa1ptJ+EZzmLQStuwlbmSvpO2iQl19P1nx
         J6hHbBTctyQUMAmvMKL/oxjabQWWzpxJ7rRLA4vtuGdwKYCOwmh8Taj67l/yuFLsosET
         qLSQUtOxpYuhW/R8+H3HjWe0/jch3FGavXkozmS92wwDMtde2ikxpQJsiGImZazap+4V
         0cIg==
X-Gm-Message-State: APjAAAWolEq7ks0V31bTwBUANIuTpfiBWNyRdeE6r+tZvsAarqW7SsDC
        TEaoQI6YCN62QYjE0uWeyubd/yeBbTo=
X-Google-Smtp-Source: APXvYqwxKiijxjOR62/QuvfPLLAT7TmDx0AHwGnVX7bmb1tGiH2RC7/VFGHuVTWO+nBbTtqTSbWxUg==
X-Received: by 2002:a92:9c0f:: with SMTP id h15mr3081181ili.65.1581368214245;
        Mon, 10 Feb 2020 12:56:54 -0800 (PST)
Received: from localhost.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c4sm391479ioa.72.2020.02.10.12.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 12:56:53 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: abstract out main poll wake handler
Date:   Mon, 10 Feb 2020 13:56:49 -0700
Message-Id: <20200210205650.14361-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210205650.14361-1-axboe@kernel.dk>
References: <20200210205650.14361-1-axboe@kernel.dk>
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
index 3a0f7d190650..123e6424a050 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3621,17 +3621,11 @@ static void io_poll_trigger_evfd(struct io_wq_work **workptr)
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
 
@@ -3641,40 +3635,50 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
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

