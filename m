Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC96D345C5F
	for <lists+io-uring@lfdr.de>; Tue, 23 Mar 2021 11:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhCWK5A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Mar 2021 06:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhCWK4r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Mar 2021 06:56:47 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE03AC061574
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 03:56:46 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id z2so20292785wrl.5
        for <io-uring@vger.kernel.org>; Tue, 23 Mar 2021 03:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W2e4V6btT8f2fSGHoqTZewbhbBDL/D51RLeXyK9qpWc=;
        b=B/IqVRo0nQ+7k7KJFMizVVc+heQSKYOb6rC/gFDAz5j5glriebwrh4VwYlknO15eBH
         0HeDwpMQDwzkBS1bUA/bN9LrERAwtPnK17GCqegloO2KrwLSmZtMs90V/iE3R+hQxXOP
         zDiiFh3Wn7bDbGH4N6ZH1YV7RMEupK6fxKdIKgEmR3GmV0hKRcrA6Q88NwOWauaBvVD/
         KGDBOxkb9Ighua+Ytb/5mjVqtc2bTJWPsnKl0o802WGh9YCTeJYG/lvXED4qXK3O8kJs
         BYE6P8x6bONu8+yCpVyKsIBg4XntWqI2eF5JggmA48UEjrf7z/8RyHgGy0qmd8i0l197
         AOug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W2e4V6btT8f2fSGHoqTZewbhbBDL/D51RLeXyK9qpWc=;
        b=LAjkEjxdBIPCHcMUs3z/0Q60eti49lJbQ8cj9JDRNSk9DTm1wrF9e8ataXMatM/KuW
         GsoodZyQQ9HPnqXWXmfiUTNepCPoGsvHQp1xR+HQxaBywGui6/cx98ow2rtwJxzwb5AK
         gLV6Wa3jWfLzKtDVUqp2POZ64SVKSnDyTDffWQJMeYR5/3OXp0rPQtmwiGj3vEzyyOZ1
         D6oEFp6DlHVp+l5guWKHqWUsaSyR79JTsKJByhB+SEmR1YzXGdnj3pk5nV5FxX+pizZb
         q7RAlgMWWABz2jYTN686XAb2wEYpfh+CVdoISHpfPPaYClqA9vJnqZExYtlPzDsuI4Ee
         1PGw==
X-Gm-Message-State: AOAM531GVMcI7s/Xs+EnRoB/zOUqj+Bu94FzZCrgAtbUl8PUKaDeAy4S
        KAeXZu3s+b6I/LAieftQvHk=
X-Google-Smtp-Source: ABdhPJy1b2eRV1zWvSlkLU4N8ciRVGZiOzcN1bfttOQ3ekUJJqoOu19fup5MXkmbggnBHuoWCOpZhA==
X-Received: by 2002:adf:fa41:: with SMTP id y1mr3274696wrr.256.1616497005414;
        Tue, 23 Mar 2021 03:56:45 -0700 (PDT)
Received: from localhost.localdomain ([85.255.234.182])
        by smtp.gmail.com with ESMTPSA id t8sm23212059wrr.10.2021.03.23.03.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 03:56:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+e3a3f84f5cecf61f0583@syzkaller.appspotmail.com
Subject: [PATCH 5.12] io_uring: do ctx sqd ejection in a clear context
Date:   Tue, 23 Mar 2021 10:52:38 +0000
Message-Id: <e90df88b8ff2cabb14a7534601d35d62ab4cb8c7.1616496707.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING: CPU: 1 PID: 27907 at fs/io_uring.c:7147 io_sq_thread_park+0xb5/0xd0 fs/io_uring.c:7147
CPU: 1 PID: 27907 Comm: iou-sqp-27905 Not tainted 5.12.0-rc4-syzkaller #0
RIP: 0010:io_sq_thread_park+0xb5/0xd0 fs/io_uring.c:7147
Call Trace:
 io_ring_ctx_wait_and_kill+0x214/0x700 fs/io_uring.c:8619
 io_uring_release+0x3e/0x50 fs/io_uring.c:8646
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 io_run_task_work fs/io_uring.c:2238 [inline]
 io_run_task_work fs/io_uring.c:2228 [inline]
 io_uring_try_cancel_requests+0x8ec/0xc60 fs/io_uring.c:8770
 io_uring_cancel_sqpoll+0x1cf/0x290 fs/io_uring.c:8974
 io_sqpoll_cancel_cb+0x87/0xb0 fs/io_uring.c:8907
 io_run_task_work_head+0x58/0xb0 fs/io_uring.c:1961
 io_sq_thread+0x3e2/0x18d0 fs/io_uring.c:6763
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

May happen that last ctx ref is killed in io_uring_cancel_sqpoll(), so
fput callback (i.e. io_uring_release()) is enqueued through task_work,
and run by same cancellation. As it's deeply nested we can't do parking
or taking sqd->lock there, because its state is unclear. So avoid
ctx ejection from sqd list from io_ring_ctx_wait_and_kill() and do it
in a clear context in io_ring_exit_work().

Reported-by: syzbot+e3a3f84f5cecf61f0583@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f3ae83a2d7bc..8c5789b96dbb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8564,6 +8564,14 @@ static void io_ring_exit_work(struct work_struct *work)
 	struct io_tctx_node *node;
 	int ret;
 
+	/* prevent SQPOLL from submitting new requests */
+	if (ctx->sq_data) {
+		io_sq_thread_park(ctx->sq_data);
+		list_del_init(&ctx->sqd_list);
+		io_sqd_update_thread_idle(ctx->sq_data);
+		io_sq_thread_unpark(ctx->sq_data);
+	}
+
 	/*
 	 * If we're doing polled IO and end up having requests being
 	 * submitted async (out-of-line), then completions can come in while
@@ -8615,14 +8623,6 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		io_unregister_personality(ctx, index);
 	mutex_unlock(&ctx->uring_lock);
 
-	/* prevent SQPOLL from submitting new requests */
-	if (ctx->sq_data) {
-		io_sq_thread_park(ctx->sq_data);
-		list_del_init(&ctx->sqd_list);
-		io_sqd_update_thread_idle(ctx->sq_data);
-		io_sq_thread_unpark(ctx->sq_data);
-	}
-
 	io_kill_timeouts(ctx, NULL, NULL);
 	io_poll_remove_all(ctx, NULL, NULL);
 
-- 
2.24.0

