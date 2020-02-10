Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1E9F158479
	for <lists+io-uring@lfdr.de>; Mon, 10 Feb 2020 21:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbgBJU44 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Feb 2020 15:56:56 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:37459 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726563AbgBJU44 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Feb 2020 15:56:56 -0500
Received: by mail-io1-f65.google.com with SMTP id k24so9221385ioc.4
        for <io-uring@vger.kernel.org>; Mon, 10 Feb 2020 12:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qz6E4QMsFWmTa6W/EzOqZd8xuXxPAhoPz2Td7OH9JGk=;
        b=d04KNhDHIz7BYtXMPI/RZp99nHZe8sYqqAATb2cEbMbmsaRZt52j2u8YW5/B7FD4+1
         +JSsUwEoIgy35jrTzJwNpPT9gHGWM/yyzJXnkF8vkNCdoillwRPrluNOQp8LL/Y2/yrw
         6bbf6lJZU8o4y2ycA3VqpgBKgE8g2MRCD3NPGotM3BPTMoOiZX+V7ilj8Vw6mx5gf7E6
         gBGU4G88p4/4whz+NzPm9OWhT01hC2heatL6e5WKpuO10dTA/oPUSiz9waT8MmW8wGK7
         DSW+zgYrlxCPYDC8sUIi9y7BNFJ+Wf9TueXkRfNbneKv3k4Z2oKjb3tqT9EClwwX6/kj
         bcaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qz6E4QMsFWmTa6W/EzOqZd8xuXxPAhoPz2Td7OH9JGk=;
        b=IGsf0+j71jS1xtjTt2knigC2Vbt8nlSujKvfNMXuIyXER+OBayOdMuvZzzMz9siMr8
         qp0v0iCaVxtjfa6lklEXG9lSUtjnZH3vzIXnYIBLhDnGNlNnRPZy/AD1l5qOrpD0fvFF
         6bDlmj5E/S2i/qb4tYhiVKB/wPP8Sr9MuFFoZYB5nJom9/A4HE5ZVs+IZPIJj+EJtoWv
         k8gTaDC0/hGFeGee0luAz8ioZiGCWFkrbgBsdcRe84HrhDsf6m4aGYcMlkQMZ+xTxrfd
         8xVKsrAmxEDFZWV8OoiiruangkLEfrC01bxGZ5dqBQ0w5TgCfZ3j4Zt3MvK4A6llSvv2
         yMkA==
X-Gm-Message-State: APjAAAWu6YEIqVq35VbRhXVsjyKCanJ61E7R2ooq77Q9pxoDUr+xvVnG
        0ekxfZz+1H8ud9uZy++LqolH83J1h2A=
X-Google-Smtp-Source: APXvYqziaRA+aNN9zgd2/VLl/1Glpt1+Blo5sdT9msVxoTagMTeckLr8sWIsxBqprQ0SGOeos79y6g==
X-Received: by 2002:a02:c4da:: with SMTP id h26mr11904224jaj.47.1581368215037;
        Mon, 10 Feb 2020 12:56:55 -0800 (PST)
Received: from localhost.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c4sm391479ioa.72.2020.02.10.12.56.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2020 12:56:54 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: allow POLL_ADD with double poll_wait() users
Date:   Mon, 10 Feb 2020 13:56:50 -0700
Message-Id: <20200210205650.14361-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210205650.14361-1-axboe@kernel.dk>
References: <20200210205650.14361-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some file descriptors use separate waitqueues for their f_ops->poll()
handler, most commonly one for read and one for write. The io_uring
poll implementation doesn't work with that, as the 2nd poll_wait()
call will cause the io_uring poll request to -EINVAL.

This is particularly a problem now that pipes were switched to using
multiple wait queues (commit 0ddad21d3e99), but it also affects tty
devices and /dev/random as well. This is a big problem for event loops
where some file descriptors work, and others don't.

With this fix, io_uring handles multiple waitqueues.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 70 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 123e6424a050..72bc378edebc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3439,10 +3439,27 @@ static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
 #endif
 }
 
+static void io_poll_remove_double(struct io_kiocb *req)
+{
+	struct io_poll_iocb *poll = (struct io_poll_iocb *) req->io;
+
+	if (poll && poll->head) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&poll->head->lock, flags);
+		list_del_init(&poll->wait.entry);
+		if (poll->wait.private)
+			refcount_dec(&req->refs);
+		spin_unlock_irqrestore(&poll->head->lock, flags);
+	}
+}
+
 static void io_poll_remove_one(struct io_kiocb *req)
 {
 	struct io_poll_iocb *poll = &req->poll;
 
+	io_poll_remove_double(req);
+
 	spin_lock(&poll->head->lock);
 	WRITE_ONCE(poll->canceled, true);
 	if (!list_empty(&poll->wait.entry)) {
@@ -3678,10 +3695,39 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	if (mask && !(mask & poll->events))
 		return 0;
 
+	io_poll_remove_double(req);
 	__io_poll_wake(req, &req->poll, mask);
 	return 1;
 }
 
+static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
+			       int sync, void *key)
+{
+	struct io_kiocb *req = wait->private;
+	struct io_poll_iocb *poll = (void *) req->io;
+	__poll_t mask = key_to_poll(key);
+	bool done = true;
+	int ret;
+
+	/* for instances that support it check for an event match first: */
+	if (mask && !(mask & poll->events))
+		return 0;
+
+	if (req->poll.head) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&req->poll.head->lock, flags);
+		done = list_empty(&req->poll.wait.entry);
+		if (!done)
+			list_del_init(&req->poll.wait.entry);
+		spin_unlock_irqrestore(&req->poll.head->lock, flags);
+	}
+	if (!done)
+		__io_poll_wake(req, poll, mask);
+	refcount_dec(&req->refs);
+	return ret;
+}
+
 struct io_poll_table {
 	struct poll_table_struct pt;
 	struct io_kiocb *req;
@@ -3692,15 +3738,33 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 			       struct poll_table_struct *p)
 {
 	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
+	struct io_kiocb *req = pt->req;
+	struct io_poll_iocb *poll = &req->poll;
 
-	if (unlikely(pt->req->poll.head)) {
-		pt->error = -EINVAL;
-		return;
+	/*
+	 * If poll->head is already set, it's because the file being polled
+	 * use multiple waitqueues for poll handling (eg one for read, one
+	 * for write). Setup a separate io_poll_iocb if this happens.
+	 */
+	if (unlikely(poll->head)) {
+		poll = kmalloc(sizeof(*poll), GFP_ATOMIC);
+		if (!poll) {
+			pt->error = -ENOMEM;
+			return;
+		}
+		poll->done = false;
+		poll->canceled = false;
+		poll->events = req->poll.events;
+		INIT_LIST_HEAD(&poll->wait.entry);
+		init_waitqueue_func_entry(&poll->wait, io_poll_double_wake);
+		refcount_inc(&req->refs);
+		poll->wait.private = req;
+		req->io = (void *) poll;
 	}
 
 	pt->error = 0;
-	pt->req->poll.head = head;
-	add_wait_queue(head, &pt->req->poll.wait);
+	poll->head = head;
+	add_wait_queue(head, &poll->wait);
 }
 
 static void io_poll_req_insert(struct io_kiocb *req)
@@ -3777,6 +3841,7 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
 	}
 	if (mask) { /* no async, we'd stolen it */
 		ipt.error = 0;
+		io_poll_remove_double(req);
 		io_poll_complete(req, mask, 0);
 	}
 	spin_unlock_irq(&ctx->completion_lock);
-- 
2.25.0

