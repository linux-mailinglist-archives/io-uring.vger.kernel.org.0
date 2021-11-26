Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC4745F03D
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 15:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352782AbhKZPDF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 10:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239892AbhKZPBF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 10:01:05 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517AFC06139E
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 06:38:27 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id u18so19120573wrg.5
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 06:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8yZOYKzRgBcV9OhAngIzjFkKSoTrdiVJnMn/b+utoX8=;
        b=cLbOtu6S0PKX+vgK5y6cjMKngKYLh/pTrwIoVxzaZvtH82hTITxDGXlosl6llOlZ9U
         UzYkxRbtmb040KSA+2J65RB4vhEeHXZDKWbcGoKwBMC5+8j6mog7AzFYr+cSG0Oyoyev
         Zn2325kkC1hGklZeoUJiArkz/0EjFkpNiJJlgbZTGWXuM4tCcKvlr98Nn/q/5YOxs0HZ
         2bFHFsO5I2gk/KZyGtP/jjyFUq4OzKyxVWX5vGDgkGtjVeNkd0kvdX+ShNQ59f1cOXgV
         ogMKUMG7TXSYj33ubN+DD01m+MhdBrtng7RvY2NXrcwn0By8mOH2UhnIJ1tkzIOw9PB3
         AnIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8yZOYKzRgBcV9OhAngIzjFkKSoTrdiVJnMn/b+utoX8=;
        b=ewREkQwdyO8ZNdk2j4g7zmENPzl0j2AFV50Dng/IBum5m2y6xxO+IuG3xW/s2WCGDm
         aVCiHfZC3gBRF2LXwFjUfbClFBLkq6pEv3NBOkzeiGmH3R+PV5dicbzcaRD0gsj3aAr5
         Pr0EPyk0FmlPtrFba2NTgjZooLnTn9yTaryCT6MV5GdQ/VGg/iujqG6c/c7G8O4L0/WK
         CdR8dgg0g2UXPgEqKCwW3X8g77oQUz5Ot4033rsh+F/7rKq8KUhwKTYoGJVqtt+cjhUy
         k95IwnQQnc8UzdgFTv/xpm4I53cpfjguVLxfIry/JuZ2lr+d5wrU5UFBz2+1ogvSXnJr
         4ZqQ==
X-Gm-Message-State: AOAM533Pn9l4tcEo0gqf3xoj/9WhqnFwXOrg4gcT1wToMYda8Z7XJmAH
        prVZYq55cmIJI/zcltDHp+1bHZoZosI=
X-Google-Smtp-Source: ABdhPJxKEWIhA4OPlr81Sm2oeinc1u4F9K+7/MAk+9yepwECYiMNkGGHQ/vu+WUheNzHDoxW7TKfQg==
X-Received: by 2002:adf:f0c8:: with SMTP id x8mr14871048wro.290.1637937505656;
        Fri, 26 Nov 2021 06:38:25 -0800 (PST)
Received: from 127.0.0.1localhost (82-132-231-175.dab.02.net. [82.132.231.175])
        by smtp.gmail.com with ESMTPSA id j134sm6588640wmj.3.2021.11.26.06.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 06:38:25 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/2] io_uring: fix link traversal locking
Date:   Fri, 26 Nov 2021 14:38:15 +0000
Message-Id: <397f7ebf3f4171f1abe41f708ac1ecb5766f0b68.1637937097.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1637937097.git.asml.silence@gmail.com>
References: <cover.1637937097.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING: inconsistent lock state
5.16.0-rc2-syzkaller #0 Not tainted
inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
ffff888078e11418 (&ctx->timeout_lock
){?.+.}-{2:2}
, at: io_timeout_fn+0x6f/0x360 fs/io_uring.c:5943
{HARDIRQ-ON-W} state was registered at:
  [...]
  spin_unlock_irq include/linux/spinlock.h:399 [inline]
  __io_poll_remove_one fs/io_uring.c:5669 [inline]
  __io_poll_remove_one fs/io_uring.c:5654 [inline]
  io_poll_remove_one+0x236/0x870 fs/io_uring.c:5680
  io_poll_remove_all+0x1af/0x235 fs/io_uring.c:5709
  io_ring_ctx_wait_and_kill+0x1cc/0x322 fs/io_uring.c:9534
  io_uring_release+0x42/0x46 fs/io_uring.c:9554
  __fput+0x286/0x9f0 fs/file_table.c:280
  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
  exit_task_work include/linux/task_work.h:32 [inline]
  do_exit+0xc14/0x2b40 kernel/exit.c:832

674ee8e1b4a41 ("io_uring: correct link-list traversal locking") fixed a
data race but introduced a possible deadlock and inconsistentcy in irq
states. E.g.

io_poll_remove_all()
    spin_lock_irq(timeout_lock)
    io_poll_remove_one()
        spin_lock/unlock_irq(poll_lock);
    spin_unlock_irq(timeout_lock)

Another type of problem is freeing a request while holding
->timeout_lock, which may leads to a deadlock in
io_commit_cqring() -> io_flush_timeouts() and other places.

Having 3 nested locks is also too ugly. Add io_match_task_safe(), which
would briefly take and release timeout_lock for race prevention inside,
so the actuall request cancellation / free / etc. code doesn't have it
taken.

Reported-by: syzbot+ff49a3059d49b0ca0eec@syzkaller.appspotmail.com
Reported-by: syzbot+847f02ec20a6609a328b@syzkaller.appspotmail.com
Reported-by: syzbot+3368aadcd30425ceb53b@syzkaller.appspotmail.com
Reported-by: syzbot+51ce8887cdef77c9ac83@syzkaller.appspotmail.com
Reported-by: syzbot+3cb756a49d2f394a9ee3@syzkaller.appspotmail.com
Fixes: 674ee8e1b4a41 ("io_uring: correct link-list traversal locking")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 60 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7dd112d44adf..75841b919dce 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1278,6 +1278,7 @@ static void io_refs_resurrect(struct percpu_ref *ref, struct completion *compl)
 
 static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 			  bool cancel_all)
+	__must_hold(&req->ctx->timeout_lock)
 {
 	struct io_kiocb *req;
 
@@ -1293,6 +1294,44 @@ static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 	return false;
 }
 
+static bool io_match_linked(struct io_kiocb *head)
+{
+	struct io_kiocb *req;
+
+	io_for_each_link(req, head) {
+		if (req->flags & REQ_F_INFLIGHT)
+			return true;
+	}
+	return false;
+}
+
+/*
+ * As io_match_task() but protected against racing with linked timeouts.
+ * User must not hold timeout_lock.
+ */
+static bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
+			       bool cancel_all)
+{
+	bool matched;
+
+	if (task && head->task != task)
+		return false;
+	if (cancel_all)
+		return true;
+
+	if (head->flags & REQ_F_LINK_TIMEOUT) {
+		struct io_ring_ctx *ctx = head->ctx;
+
+		/* protect against races with linked timeouts */
+		spin_lock_irq(&ctx->timeout_lock);
+		matched = io_match_linked(head);
+		spin_unlock_irq(&ctx->timeout_lock);
+	} else {
+		matched = io_match_linked(head);
+	}
+	return matched;
+}
+
 static inline bool req_has_async_data(struct io_kiocb *req)
 {
 	return req->flags & REQ_F_ASYNC_DATA;
@@ -5699,17 +5738,15 @@ static __cold bool io_poll_remove_all(struct io_ring_ctx *ctx,
 	int posted = 0, i;
 
 	spin_lock(&ctx->completion_lock);
-	spin_lock_irq(&ctx->timeout_lock);
 	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
 		struct hlist_head *list;
 
 		list = &ctx->cancel_hash[i];
 		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
-			if (io_match_task(req, tsk, cancel_all))
+			if (io_match_task_safe(req, tsk, cancel_all))
 				posted += io_poll_remove_one(req);
 		}
 	}
-	spin_unlock_irq(&ctx->timeout_lock);
 	spin_unlock(&ctx->completion_lock);
 
 	if (posted)
@@ -9565,19 +9602,8 @@ static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_task_cancel *cancel = data;
-	bool ret;
 
-	if (!cancel->all && (req->flags & REQ_F_LINK_TIMEOUT)) {
-		struct io_ring_ctx *ctx = req->ctx;
-
-		/* protect against races with linked timeouts */
-		spin_lock_irq(&ctx->timeout_lock);
-		ret = io_match_task(req, cancel->task, cancel->all);
-		spin_unlock_irq(&ctx->timeout_lock);
-	} else {
-		ret = io_match_task(req, cancel->task, cancel->all);
-	}
-	return ret;
+	return io_match_task_safe(req, cancel->task, cancel->all);
 }
 
 static __cold bool io_cancel_defer_files(struct io_ring_ctx *ctx,
@@ -9588,14 +9614,12 @@ static __cold bool io_cancel_defer_files(struct io_ring_ctx *ctx,
 	LIST_HEAD(list);
 
 	spin_lock(&ctx->completion_lock);
-	spin_lock_irq(&ctx->timeout_lock);
 	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
-		if (io_match_task(de->req, task, cancel_all)) {
+		if (io_match_task_safe(de->req, task, cancel_all)) {
 			list_cut_position(&list, &ctx->defer_list, &de->list);
 			break;
 		}
 	}
-	spin_unlock_irq(&ctx->timeout_lock);
 	spin_unlock(&ctx->completion_lock);
 	if (list_empty(&list))
 		return false;
-- 
2.34.0

