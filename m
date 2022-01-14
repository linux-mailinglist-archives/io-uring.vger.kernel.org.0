Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F287B48E995
	for <lists+io-uring@lfdr.de>; Fri, 14 Jan 2022 13:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234681AbiANMAR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Jan 2022 07:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbiANMAQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Jan 2022 07:00:16 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49766C061574
        for <io-uring@vger.kernel.org>; Fri, 14 Jan 2022 04:00:16 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id l4so5840961wmq.3
        for <io-uring@vger.kernel.org>; Fri, 14 Jan 2022 04:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+1uoSoXCv01sSrv9GnqjB4cAHx5uzmHn1bzyib6GLeU=;
        b=Wjzu4YXDHbUkrVZhxtM6WadmWhrjFzy9ntCZdHmURLxlt6EsjREc1xYkm9oHGmH/3d
         d7+egRtHlzwaWBs90BRiHXzTu9GgqGZnjf9zV8vnUW92WTmjJtoZX94ATNzByKKLpht+
         pW9zu0rGT5MuHrs9ey+Pxd0rq6Eqo29PPo7uHat9obrZcNjxNetKvqe9FBXdMemqn43e
         6qVRIgSldw4cOXLwmZnuTQW+Ke4hjEKVWXFw1UXrrW/ZQ2rszwg9I0oPkfhMTJef06Br
         zuSFSpJu1H1kmVgesrc+rZhWWVOoVrmSpgghO3ewjV9V6ZIlSaQsxfeQ5HGSgAmmi9TT
         Zs6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+1uoSoXCv01sSrv9GnqjB4cAHx5uzmHn1bzyib6GLeU=;
        b=h3vySV8Zb/GkaGyocf9cnahMPHMmReno6b4F2vdBplQ/AtR0FS2C5+ekPE0Nwiu4WY
         A4ac+z6u3sEBe6SkuHZB8rSpWOC2j1HuRJrE/cviLKMjAoKvctkbEkcDjYohOrnsvzhj
         oW681DNnCjL6K/vJY7ks4gMNW9ccBGCWXtkDjIVlzplI1nmEeA6d5Lbvl8DYoyNEBYuT
         f4YNHLHicBMmMk34k7Y0QCmdVAiTnmBEHN3sWmb5cECm5edW3aJ4R8v39qcfU3XBmhPm
         1AT/g2XKpVwG3P+QVrJ0uJsY898Ateb8pLGg9uRLttw4Kx2XSJ4p/g5UQmaeX3Pyjlor
         j4pA==
X-Gm-Message-State: AOAM532weIKDo4SNOM6+NxncoSMbzDG07YmNfGmMrWRSYgVgcj7e9uY5
        oL6c39g447nKd6wt/ALp+judOR3jFCM=
X-Google-Smtp-Source: ABdhPJxLQ0zuMmAmpcyeesbPStvbpHg6gsEGSEtbSV2sRZhNMpI302LbmxXa99eNY4J1d5SvNsM3Mg==
X-Received: by 2002:a05:600c:3d0c:: with SMTP id bh12mr11786544wmb.66.1642161614602;
        Fri, 14 Jan 2022 04:00:14 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.103])
        by smtp.gmail.com with ESMTPSA id m20sm4668054wms.4.2022.01.14.04.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 04:00:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Eric Biggers <ebiggers@google.com>,
        syzbot+5426c7ed6868c705ca14@syzkaller.appspotmail.com
Subject: [PATCH] io_uring: fix UAF due to missing POLLFREE handling
Date:   Fri, 14 Jan 2022 11:59:10 +0000
Message-Id: <4ed56b6f548f7ea337603a82315750449412748a.1642161259.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fixes a problem described in 50252e4b5e989
("aio: fix use-after-free due to missing POLLFREE handling")
and copies the approach used there.

In short, we have to forcibly eject a poll entry when we meet POLLFREE.
We can't rely on io_poll_get_ownership() as can't wait for potentially
running tw handlers, so we use the fact that wqs are RCU freed. See
Eric's patch and comments for more details.

Reported-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20211209010455.42744-6-ebiggers@kernel.org
Reported-and-tested-by: syzbot+5426c7ed6868c705ca14@syzkaller.appspotmail.com
Fixes: 221c5eb233823 ("io_uring: add support for IORING_OP_POLL")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 60 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 51 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fa3277844d2e..bc424af1833b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5462,12 +5462,14 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
 
 static inline void io_poll_remove_entry(struct io_poll_iocb *poll)
 {
-	struct wait_queue_head *head = poll->head;
+	struct wait_queue_head *head = smp_load_acquire(&poll->head);
 
-	spin_lock_irq(&head->lock);
-	list_del_init(&poll->wait.entry);
-	poll->head = NULL;
-	spin_unlock_irq(&head->lock);
+	if (head) {
+		spin_lock_irq(&head->lock);
+		list_del_init(&poll->wait.entry);
+		poll->head = NULL;
+		spin_unlock_irq(&head->lock);
+	}
 }
 
 static void io_poll_remove_entries(struct io_kiocb *req)
@@ -5475,10 +5477,26 @@ static void io_poll_remove_entries(struct io_kiocb *req)
 	struct io_poll_iocb *poll = io_poll_get_single(req);
 	struct io_poll_iocb *poll_double = io_poll_get_double(req);
 
-	if (poll->head)
-		io_poll_remove_entry(poll);
-	if (poll_double && poll_double->head)
+	/*
+	 * While we hold the waitqueue lock and the waitqueue is nonempty,
+	 * wake_up_pollfree() will wait for us.  However, taking the waitqueue
+	 * lock in the first place can race with the waitqueue being freed.
+	 *
+	 * We solve this as eventpoll does: by taking advantage of the fact that
+	 * all users of wake_up_pollfree() will RCU-delay the actual free.  If
+	 * we enter rcu_read_lock() and see that the pointer to the queue is
+	 * non-NULL, we can then lock it without the memory being freed out from
+	 * under us.
+	 *
+	 * Keep holding rcu_read_lock() as long as we hold the queue lock, in
+	 * case the caller deletes the entry from the queue, leaving it empty.
+	 * In that case, only RCU prevents the queue memory from being freed.
+	 */
+	rcu_read_lock();
+	io_poll_remove_entry(poll);
+	if (poll_double)
 		io_poll_remove_entry(poll_double);
+	rcu_read_unlock();
 }
 
 /*
@@ -5618,13 +5636,37 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 						 wait);
 	__poll_t mask = key_to_poll(key);
 
+	if (unlikely(mask & POLLFREE)) {
+		io_poll_mark_cancelled(req);
+		/* we have to kick tw in case it's not already */
+		io_poll_execute(req, 0);
+
+		/*
+		 * If the waitqueue is being freed early but someone is already
+		 * holds ownership over it, we have to tear down the request as
+		 * best we can. That means immediately removing the request from
+		 * its waitqueue and preventing all further accesses to the
+		 * waitqueue via the request.
+		 */
+		list_del_init(&poll->wait.entry);
+
+		/*
+		 * Careful: this *must* be the last step, since as soon
+		 * as req->head is NULL'ed out, the request can be
+		 * completed and freed, since aio_poll_complete_work()
+		 * will no longer need to take the waitqueue lock.
+		 */
+		smp_store_release(&poll->head, NULL);
+		return 1;
+	}
+
 	/* for instances that support it check for an event match first */
 	if (mask && !(mask & poll->events))
 		return 0;
 
 	if (io_poll_get_ownership(req)) {
 		/* optional, saves extra locking for removal in tw handler */
-		if (mask && poll->events & EPOLLONESHOT) {
+		if (mask && (poll->events & EPOLLONESHOT)) {
 			list_del_init(&poll->wait.entry);
 			poll->head = NULL;
 		}
-- 
2.34.1

