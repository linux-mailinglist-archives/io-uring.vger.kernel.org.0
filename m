Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC3335D517
	for <lists+io-uring@lfdr.de>; Tue, 13 Apr 2021 04:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241534AbhDMCDZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Apr 2021 22:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240831AbhDMCDZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Apr 2021 22:03:25 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87571C061574
        for <io-uring@vger.kernel.org>; Mon, 12 Apr 2021 19:03:06 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id x7so14769961wrw.10
        for <io-uring@vger.kernel.org>; Mon, 12 Apr 2021 19:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=JeFz+lmXcjVpyElCUwnX9oIcPADby33iJPGlltemOTk=;
        b=FWE2rGzRpvKHq0nHJWjcfrQ8wdc9Br8/6NktSuPWNzwzzjI3R24CVTtWnyLi5vSwNl
         CXW7KqnbQ9JsK81z9nVgL7XjpOzTyq2sjHMWCA3XDqKEmuWDVvYEhAA6305gg4di4+tY
         L1wvfiYVl4mCnb8U0sdKhlTX4xW3xL6KTsm7vtfk0brY+GeLzrYmp86BT72q5bRT20Bx
         C5Ugvo3ZuVHUN11fjyhZOZdSdaQDIQQubTfzn/2IlO6Idgz7mtCyItOixvAwUFcZasg0
         O8TeRdvchaPDjK/jfhaQ5lpMccm0HIYrUhwMurEzsCw85fNzPDhUSfhBe2lgHn3e9Ryv
         aFdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JeFz+lmXcjVpyElCUwnX9oIcPADby33iJPGlltemOTk=;
        b=I946hXmD4mJQoCaSPDhEtJlgZcjSoEQ/Du6aso5ElrNbZ16/te9oTdQY6/ajrYMUsU
         z9xJXQnarpmetrHMp4EXWUZkKaiJCPwr+5f5Y1SqBG6Evyzoqy1mlWNASkMlp/16S2QL
         TD0CdVMMHY+cuvLIaxfeE+Kv1dd3KA6/aufDEamc4xvLnCdGqa3Ma6o+eD6JyfkX0wx+
         GspHfrWxN0NoN8Xez3zBpJFYzwKho+cnEK/V8StC7rMMEEpFHrNjFRFigrcrWFxKPBre
         DIj4Lebn9jqF8pm194QyNaey+syjw9GpS6zh6i3Xsk3C46DqiYliqKW/8sRH3oCBPW8B
         BKXA==
X-Gm-Message-State: AOAM531bAZJGoMhZ4LkWzx8QqPIb1OZziswYEK61UbiEGSNK7ZS98h+7
        X/tqaEGFap+l56hCLGSOE4QsTQTNrLU=
X-Google-Smtp-Source: ABdhPJzKYXxdh/AXX54xr4YhNgIMZaDy632hM2msTU/+ZogefuY6wP3ZTphOv3ktBJNA18rdHVylLg==
X-Received: by 2002:a5d:6d05:: with SMTP id e5mr32849548wrq.324.1618279385348;
        Mon, 12 Apr 2021 19:03:05 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.208])
        by smtp.gmail.com with ESMTPSA id k7sm18771331wrw.64.2021.04.12.19.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 19:03:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/9] io_uring: split poll and poll update structures
Date:   Tue, 13 Apr 2021 02:58:40 +0100
Message-Id: <b2f74d64ffebb57a648f791681af086c7211e3a4.1618278933.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618278933.git.asml.silence@gmail.com>
References: <cover.1618278933.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

struct io_poll_iocb became pretty nasty combining also update fields.
Split them, so we would have more clarity to it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 55 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 32 insertions(+), 23 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 429ee5fd9044..a0f207e62e32 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -490,15 +490,16 @@ struct io_poll_iocb {
 	__poll_t			events;
 	bool				done;
 	bool				canceled;
+	struct wait_queue_entry		wait;
+};
+
+struct io_poll_update {
+	struct file			*file;
+	u64				old_user_data;
+	u64				new_user_data;
+	__poll_t			events;
 	bool				update_events;
 	bool				update_user_data;
-	union {
-		struct wait_queue_entry	wait;
-		struct {
-			u64		old_user_data;
-			u64		new_user_data;
-		};
-	};
 };
 
 struct io_poll_remove {
@@ -715,6 +716,7 @@ enum {
 	REQ_F_COMPLETE_INLINE_BIT,
 	REQ_F_REISSUE_BIT,
 	REQ_F_DONT_REISSUE_BIT,
+	REQ_F_POLL_UPDATE_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_ASYNC_READ_BIT,
 	REQ_F_ASYNC_WRITE_BIT,
@@ -762,6 +764,8 @@ enum {
 	REQ_F_REISSUE		= BIT(REQ_F_REISSUE_BIT),
 	/* don't attempt request reissue, see io_rw_reissue() */
 	REQ_F_DONT_REISSUE	= BIT(REQ_F_DONT_REISSUE_BIT),
+	/* switches between poll and poll update */
+	REQ_F_POLL_UPDATE	= BIT(REQ_F_POLL_UPDATE_BIT),
 	/* supports async reads */
 	REQ_F_ASYNC_READ	= BIT(REQ_F_ASYNC_READ_BIT),
 	/* supports async writes */
@@ -791,6 +795,7 @@ struct io_kiocb {
 		struct file		*file;
 		struct io_rw		rw;
 		struct io_poll_iocb	poll;
+		struct io_poll_update	poll_update;
 		struct io_poll_remove	poll_remove;
 		struct io_accept	accept;
 		struct io_sync		sync;
@@ -4989,7 +4994,6 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
 	poll->head = NULL;
 	poll->done = false;
 	poll->canceled = false;
-	poll->update_events = poll->update_user_data = false;
 #define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
 	/* mask in events that we always want/need */
 	poll->events = events | IO_POLL_UNMASK;
@@ -5366,7 +5370,6 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 
 static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_poll_iocb *poll = &req->poll;
 	u32 events, flags;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
@@ -5383,20 +5386,26 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 #endif
 	if (!(flags & IORING_POLL_ADD_MULTI))
 		events |= EPOLLONESHOT;
-	poll->update_events = poll->update_user_data = false;
+	events = demangle_poll(events) |
+				(events & (EPOLLEXCLUSIVE|EPOLLONESHOT));
 
 	if (flags & (IORING_POLL_UPDATE_EVENTS|IORING_POLL_UPDATE_USER_DATA)) {
-		poll->old_user_data = READ_ONCE(sqe->addr);
-		poll->update_events = flags & IORING_POLL_UPDATE_EVENTS;
-		poll->update_user_data = flags & IORING_POLL_UPDATE_USER_DATA;
-		if (poll->update_user_data)
-			poll->new_user_data = READ_ONCE(sqe->off);
+		struct io_poll_update *poll_upd = &req->poll_update;
+
+		req->flags |= REQ_F_POLL_UPDATE;
+		poll_upd->events = events;
+		poll_upd->old_user_data = READ_ONCE(sqe->addr);
+		poll_upd->update_events = flags & IORING_POLL_UPDATE_EVENTS;
+		poll_upd->update_user_data = flags & IORING_POLL_UPDATE_USER_DATA;
+		if (poll_upd->update_user_data)
+			poll_upd->new_user_data = READ_ONCE(sqe->off);
 	} else {
+		struct io_poll_iocb *poll = &req->poll;
+
+		poll->events = events;
 		if (sqe->off || sqe->addr)
 			return -EINVAL;
 	}
-	poll->events = demangle_poll(events) |
-				(events & (EPOLLEXCLUSIVE|EPOLLONESHOT));
 	return 0;
 }
 
@@ -5434,7 +5443,7 @@ static int io_poll_update(struct io_kiocb *req)
 	int ret;
 
 	spin_lock_irq(&ctx->completion_lock);
-	preq = io_poll_find(ctx, req->poll.old_user_data);
+	preq = io_poll_find(ctx, req->poll_update.old_user_data);
 	if (!preq) {
 		ret = -ENOENT;
 		goto err;
@@ -5464,13 +5473,13 @@ static int io_poll_update(struct io_kiocb *req)
 		return 0;
 	}
 	/* only mask one event flags, keep behavior flags */
-	if (req->poll.update_events) {
+	if (req->poll_update.update_events) {
 		preq->poll.events &= ~0xffff;
-		preq->poll.events |= req->poll.events & 0xffff;
+		preq->poll.events |= req->poll_update.events & 0xffff;
 		preq->poll.events |= IO_POLL_UNMASK;
 	}
-	if (req->poll.update_user_data)
-		preq->user_data = req->poll.new_user_data;
+	if (req->poll_update.update_user_data)
+		preq->user_data = req->poll_update.new_user_data;
 
 	spin_unlock_irq(&ctx->completion_lock);
 
@@ -5489,7 +5498,7 @@ static int io_poll_update(struct io_kiocb *req)
 
 static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 {
-	if (!req->poll.update_events && !req->poll.update_user_data)
+	if (!(req->flags & REQ_F_POLL_UPDATE))
 		return __io_poll_add(req);
 	return io_poll_update(req);
 }
-- 
2.24.0

