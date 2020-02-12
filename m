Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6AAD15B1CA
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2020 21:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgBLUZV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Feb 2020 15:25:21 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:40782 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbgBLUZV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Feb 2020 15:25:21 -0500
Received: by mail-io1-f66.google.com with SMTP id x1so3774984iop.7
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2020 12:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uh3CnZqh5+iYahvhOKmcFE5WYny8TTBYfkBSLwInOZU=;
        b=CAPCq/t0dE5SjxEpEtSh9ts+fa/l7YmBw8/ogNyGsDuZkiD+7pb52RHVIPCCQev1FZ
         YmVdFeSZI/IietwESxO0a5zuMBpCz4Cjc40XHv+cZ1J06xs714ILzfJBYi8ziwfYDa5X
         YidVLRom0FvUKrbBro0FeNvfz4rI2l5erKOy111fNNllKxg0k4yOdhbXeo0510/lgCF4
         f7IzRCdQULfoSX9Tn4fx3fgFdFuTlo3O65uY3/s/2AjVrAfm52cillFUX+uRxNLKDU/T
         IkHXfRV4F2Pi/xhhESFrR2EqbMviMtFNjZ0iElk9LbdsB2oTdKQ6dRNuvL/A+5DS3BdT
         PsIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uh3CnZqh5+iYahvhOKmcFE5WYny8TTBYfkBSLwInOZU=;
        b=aLsYkOQB8SvKOQ89obMd+/flpIH57+9KmIaxiXOxBA1TDBLu0du7ELExNdqVVfhKCH
         wIIDEOJV8x1T3f1myFhDuvyRHWyeWyDkc5EknDH44B+du137SUVePLn+K/56w8nogMNc
         P+sojIfImNIeiXjy1t1VwVp27/+mYNbrcQ2pV1wK9APEVlEFflinIe9Vg/t5g1ASLi4q
         3UXyuOLWLplWUE6Q00VrMi8sNsGbTMZjzGO7yj7fT1c47eoQM8MRsD41oiMKGEKfjHJk
         wF5D1Sz+1vCRk+Uv+LzVR+csUhXAjnV3mjYvU7aFxjE2EQwOKqzuNWORDJEFeXNf50Hc
         veMw==
X-Gm-Message-State: APjAAAV+3gtKv2/6UFGZdBwMfnTm/d+QRcmTweH5K4eNPO9Y8wfMxUHm
        pqUhb/5OUCwz5S5opdxrMvET7cmE+vQ=
X-Google-Smtp-Source: APXvYqyxhV2730d2CdRlxY9uT6ekNf9ltMIDgMO8oSx3wwnBpqyjakgVnSh5miaMWfBuBEd1faqOAA==
X-Received: by 2002:a02:9203:: with SMTP id x3mr19712991jag.62.1581539119837;
        Wed, 12 Feb 2020 12:25:19 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 203sm37938ilb.42.2020.02.12.12.25.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 12:25:19 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: allow POLL_ADD with double poll_wait() users
Date:   Wed, 12 Feb 2020 13:25:15 -0700
Message-Id: <20200212202515.15299-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200212202515.15299-1-axboe@kernel.dk>
References: <20200212202515.15299-1-axboe@kernel.dk>
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
 fs/io_uring.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 74 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9cd2ce3b8ad9..9f00f30e1790 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3440,10 +3440,27 @@ static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
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
@@ -3679,10 +3696,38 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
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
+	return 1;
+}
+
 struct io_poll_table {
 	struct poll_table_struct pt;
 	struct io_kiocb *req;
@@ -3693,15 +3738,38 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
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
+		/* already have a 2nd entry, fail a third attempt */
+		if (req->io) {
+			pt->error = -EINVAL;
+			return;
+		}
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
@@ -3778,6 +3846,7 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
 	}
 	if (mask) { /* no async, we'd stolen it */
 		ipt.error = 0;
+		io_poll_remove_double(req);
 		io_poll_complete(req, mask, 0);
 	}
 	spin_unlock_irq(&ctx->completion_lock);
-- 
2.25.0

