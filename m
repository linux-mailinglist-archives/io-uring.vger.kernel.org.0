Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1C8330D35
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 13:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhCHMSk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 07:18:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhCHMSQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 07:18:16 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFA0C06174A
        for <io-uring@vger.kernel.org>; Mon,  8 Mar 2021 04:18:16 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id i9so5872106wml.0
        for <io-uring@vger.kernel.org>; Mon, 08 Mar 2021 04:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4hk8YPTbD9MAJu6QjIAD0VpkIA8XgxlOXzORbxAHL+c=;
        b=WtWvTer5J7E7asnpLtS0guxd9JV2p1CmT7ZpqgxS5L5quKY9LKcSjwyHRI2eUatEV7
         5psz+XiTxXDcckrjbywyywAf1jXolfTz2XNdfBnAwBdZxRxPf9iTApl/DToJNvwCJk9K
         ejLdhbC2jnyVn3y7j1GwwwbbhmEgw0wIiPXmdOLBAi+6CANpRKH3E0DSS9jBxviSU8iH
         egdIIQFKr4M6qQDUpB6FA0wIJXNp4uIHiQ1Hd+EGHs06t4utrE1O5z/h/5FxZr6kXfZU
         ROkUg4S2mGhlwjJTP/tGahuH4KqYMtCpnMVkKJPJdZxyrqlp9XZ/rrIz/9KJetqIhydH
         kMTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4hk8YPTbD9MAJu6QjIAD0VpkIA8XgxlOXzORbxAHL+c=;
        b=MntDKkHKhEqqUX9QjYNK/fqW3gckMCedgstrMH32CyBPwn7SHvRUdFKgo49n1GpPAR
         YsF1tFXH+4hLclGMarEKDB/zaOq0MK2CxXiTcbV02mBFCkWPY8F5a3iPTUDYTMMfS9hE
         zsNRl27KnENk4/ADXYpB8F0BrJd4HgIwP9GwV8TR3jqq3KE5rYZwP3xG5p0dR6nw34QH
         t2Yu5iyqsmzwYEDK4/d7Fnqly72J5KG18Ow7Pfah2dClmuH9BIzg8pGuLH9OxBPViWl+
         Qiy8HnG+Oj9kMOUiJBu1gTx668+1jRnp1qfFb3YkVI4FByppUXJDoeSsMvBrB5U1+47V
         s4Tw==
X-Gm-Message-State: AOAM531EgufTZVFqSSho/DHtEJ4x6gQP+OON+VjKd9bzBlGQdCP6REpG
        rKBuaO8vzwrxkDuakcBOBOI=
X-Google-Smtp-Source: ABdhPJxIuhWmxShJspA2UlERqDNoW7/Fy/NUJ6tH8wq2mqb53Y5XTD6IwX03f3eEqv0QrFPMDpjy6g==
X-Received: by 2002:a1c:7fd8:: with SMTP id a207mr21365028wmd.40.1615205895323;
        Mon, 08 Mar 2021 04:18:15 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.144])
        by smtp.gmail.com with ESMTPSA id j16sm51357951wmi.2.2021.03.08.04.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 04:18:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12] io_uring: fix unrelated ctx reqs cancellation
Date:   Mon,  8 Mar 2021 12:14:14 +0000
Message-Id: <b34efa4aeca7473d884f204961839b30a292e2fa.1615205524.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io-wq now is per-task, so cancellations now should match against
request's ctx.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

p.s. have a test for it, but will in a bundle after another problem gets
solved.

 fs/io_uring.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9a7cb641210a..5c6a54520be0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5574,22 +5574,30 @@ static int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+struct io_cancel_data {
+	struct io_ring_ctx *ctx;
+	u64 user_data;
+};
+
 static bool io_cancel_cb(struct io_wq_work *work, void *data)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_cancel_data *cd = data;
 
-	return req->user_data == (unsigned long) data;
+	return req->ctx == cd->ctx && req->user_data == cd->user_data;
 }
 
-static int io_async_cancel_one(struct io_uring_task *tctx, void *sqe_addr)
+static int io_async_cancel_one(struct io_uring_task *tctx, u64 user_data,
+			       struct io_ring_ctx *ctx)
 {
+	struct io_cancel_data data = { .ctx = ctx, .user_data = user_data, };
 	enum io_wq_cancel cancel_ret;
 	int ret = 0;
 
-	if (!tctx->io_wq)
+	if (!tctx || !tctx->io_wq)
 		return -ENOENT;
 
-	cancel_ret = io_wq_cancel_cb(tctx->io_wq, io_cancel_cb, sqe_addr, false);
+	cancel_ret = io_wq_cancel_cb(tctx->io_wq, io_cancel_cb, &data, false);
 	switch (cancel_ret) {
 	case IO_WQ_CANCEL_OK:
 		ret = 0;
@@ -5612,8 +5620,7 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	unsigned long flags;
 	int ret;
 
-	ret = io_async_cancel_one(req->task->io_uring,
-					(void *) (unsigned long) sqe_addr);
+	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
 	if (ret != -ENOENT) {
 		spin_lock_irqsave(&ctx->completion_lock, flags);
 		goto done;
-- 
2.24.0

