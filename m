Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86CC5417CAF
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348488AbhIXVCl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346614AbhIXVCb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:31 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A9CC061613
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:57 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id bx4so40994661edb.4
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=JNopz4Pbv48nu5ltQbOdNLSNNQovgTzDBMbIcFiff2o=;
        b=EOq2shhj/o1VLwClVP4Uvqd7njZV9qTDjKZ0s9S6w6MnlvUANE4BnL657t5eEHJnal
         uK8rsqEozMrr4y6x+rUJoO1+jTd1zt+Pc09tC2kdUP9DP4XfkMMOedSMcqvoNjkP6KT5
         Avbq3xBDOY6RQzzYUjCkjnPpuLd2wj0GIdsT3NZQrl7M8rnGoPIRReE/qloCePKB4vyI
         M4WyrNoMyLD6BPnXomVHaXR5c0d2FiMK0N9zSBGwIgMtYgO85iG3AxaQ9KaDeLc1G1eX
         b83X1Bh0lMBH+rkq325XUtxXj/ijR7W/jDVzjSaL24LZB6QzJ+9wyTP8ddDU/PTI6som
         bZKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JNopz4Pbv48nu5ltQbOdNLSNNQovgTzDBMbIcFiff2o=;
        b=s2DT8CWDKqG68OT1yjpmAmQV2iEnlIL0EKtypYSbyujPBZW4K5mUB8+3h8zk6ze+0P
         mdQrCjZSQVa5z5PysGpXnjFT3/KVjO9tabDKWC+7E2zZ+2BS5wo8XmRv2b6wkNae4D2/
         ++pMZGKtgkNgz83A1wxAy9mqwvOGArNYeDRfvhchMAN+5TSlmz7oBPgj7z1ThI10wscH
         M5HzcOzjCRtdHPFzIZ0EuIjwrwzTqwiAtpYnYt8B0tYR3FgqxQq84ChJs+P+lFVdV4RJ
         KqK/1Z6LzoJ1r0KYkNDucTnPCW4pbK+/wqwHiKCK432oH/dXT3nrEXrU86tigH3rxtho
         5n0Q==
X-Gm-Message-State: AOAM531Patjn/d1vYepIDr5Lg5EupTElqLWmU6OiI4bfVcz+s8akxv1l
        Ym0rUsYVgATb8k8wF7NjWsOMhLG7X1I=
X-Google-Smtp-Source: ABdhPJw17wKPMj3yF2b/ph+7k6ASzxhFbGfFcvnIHK6nN3dGV0GUOSm5MTP4/60rWB0v1Bh9HtZkgg==
X-Received: by 2002:a05:6402:142e:: with SMTP id c14mr7350227edx.209.1632517256459;
        Fri, 24 Sep 2021 14:00:56 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:00:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 08/24] io_uring: split iopoll loop
Date:   Fri, 24 Sep 2021 21:59:48 +0100
Message-Id: <a7f6fd27a94845e5dc925a47a4a9765a92e514fb.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The main loop of io_do_iopoll() iterates and does ->iopoll() until it
meets a first completed request, then it continues from that position
and splices requests to pass them through io_iopoll_complete().

Split the loop in two for clearness, iopolling and reaping completed
requests from the list.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e29f75bc69ae..0e683d0f5b73 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2446,6 +2446,12 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, struct list_head *done)
 	io_req_free_batch_finish(ctx, &rb);
 }
 
+/* same as "continue" but starts from the pos, not next to it */
+#define list_for_each_entry_safe_resume(pos, n, head, member) 		\
+	for (n = list_next_entry(pos, member);				\
+	     !list_entry_is_head(pos, head, member);			\
+	     pos = n, n = list_next_entry(n, member))
+
 static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	struct io_kiocb *req, *tmp;
@@ -2459,7 +2465,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 	 */
 	spin = !ctx->poll_multi_queue && !force_nonspin;
 
-	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, inflight_entry) {
+	list_for_each_entry(req, &ctx->iopoll_list, inflight_entry) {
 		struct kiocb *kiocb = &req->rw.kiocb;
 		int ret;
 
@@ -2468,12 +2474,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		 * If we find a request that requires polling, break out
 		 * and complete those lists first, if we have entries there.
 		 */
-		if (READ_ONCE(req->iopoll_completed)) {
-			list_move_tail(&req->inflight_entry, &done);
-			nr_events++;
-			continue;
-		}
-		if (!list_empty(&done))
+		if (READ_ONCE(req->iopoll_completed))
 			break;
 
 		ret = kiocb->ki_filp->f_op->iopoll(kiocb, spin);
@@ -2483,15 +2484,20 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 			spin = false;
 
 		/* iopoll may have completed current req */
-		if (READ_ONCE(req->iopoll_completed)) {
-			list_move_tail(&req->inflight_entry, &done);
-			nr_events++;
-		}
+		if (READ_ONCE(req->iopoll_completed))
+			break;
 	}
 
-	if (!list_empty(&done))
-		io_iopoll_complete(ctx, &done);
+	list_for_each_entry_safe_resume(req, tmp, &ctx->iopoll_list,
+					inflight_entry) {
+		if (!READ_ONCE(req->iopoll_completed))
+			break;
+		list_move_tail(&req->inflight_entry, &done);
+		nr_events++;
+	}
 
+	if (nr_events)
+		io_iopoll_complete(ctx, &done);
 	return nr_events;
 }
 
-- 
2.33.0

