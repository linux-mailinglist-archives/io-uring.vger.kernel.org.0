Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AE621E3C4
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2020 01:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgGMXn6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 19:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726768AbgGMXn5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 19:43:57 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9EBC061794;
        Mon, 13 Jul 2020 16:43:56 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id rk21so19468140ejb.2;
        Mon, 13 Jul 2020 16:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=AQ59hBww2K7N+eQ6R6wFF6Z+SK5DzT4zGxt9Mv/aFmo=;
        b=cmkFJQ2BxxvxUD4N7FIpmExHP9WCkQuXlJoH709aZl8ChIkT7MQxUfgljM79Jr0wSB
         ZFsm92Z6JczErc2rDbokZZt2/sm9ChbxvVZDV94qstrv0FSq7bh+CAOuEApbB8pXKWap
         83RQM7WVMV/I+w3Bb/GPIZXaHl4ytWbzkCZNIPjHSTGpLh0smcA3uFpMPTIVc6NWoVZK
         MEkvhuysbwh/3o9Czj8q7XmkA0SO9vTjzOhzj8w11xKStGkxvBx8eSK8DPHmQMJOiw30
         QdOlOqtIX+nynUdWRpmCH2ejU0GntJ142xtdQp/9Gv0Qo29nYmVdTaODHSHDj58i0Ty5
         UIOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AQ59hBww2K7N+eQ6R6wFF6Z+SK5DzT4zGxt9Mv/aFmo=;
        b=iIzPtgKdSlWsWfwf1WLF/Rpq6JkzGb5V1tE8sXI/vF7a1bWAsswrkrx1oxrw5C6AER
         U1SayxpQIL716hJFkdhLOE2oe2GvdTcKAPxm9AsPxrLAIOw9u26i/0Cd5k8Zep3uWv6s
         g8dPqQDE16YQZHH9yIIwHgBLlbZMoh8nOBK77Vo4IOK4jBVm2mTt7Kp6NHwz76rbRVCH
         ElO/hSiBrarSYFDetgUWj24v5qM+iiYHGuJc3TjTVxfZCfaiVE9ZxaseC9M3HtE7AsoX
         XOq8IWZ81zmdNUgBdf5WxBIBdjwnO/YpO4MJdQnTNTQfiL8Nh9c7q7m1t4sU6IKwB/3H
         trqg==
X-Gm-Message-State: AOAM5326Axu2dctcRU9rXyJxdVWfqZg6kXxux9/739tpdXuMznENy4+c
        Hf1eJoLq3yABqU72HKMis/M=
X-Google-Smtp-Source: ABdhPJzdkMKwAr1aiD1+3rrTXDfCXrX1mowAFUECBXqYL3SsYkCzRnSIV6rhozxw5LmIVPTpshM50A==
X-Received: by 2002:a17:906:6558:: with SMTP id u24mr1893542ejn.364.1594683835417;
        Mon, 13 Jul 2020 16:43:55 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id a13sm12964712edk.58.2020.07.13.16.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 16:43:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] io_uring: batch free in batched completion
Date:   Tue, 14 Jul 2020 02:41:54 +0300
Message-Id: <2c4f704c045d000a26a526eaaac1af8a68216b90.1594683622.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594683622.git.asml.silence@gmail.com>
References: <cover.1594683622.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_submit_flush_completions() already does batching, hence also bundle
freeing reusing batch_free from iopoll.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3277a06e2fb6..6f767781351f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1795,6 +1795,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 
 static void io_submit_flush_completions(struct io_comp_state *cs)
 {
+	struct req_batch rb;
 	struct io_kiocb *req;
 	struct io_ring_ctx *ctx = cs->ctx;
 	int i, nr = cs->nr;
@@ -1808,8 +1809,13 @@ static void io_submit_flush_completions(struct io_comp_state *cs)
 	spin_unlock_irq(&ctx->completion_lock);
 	io_cqring_ev_posted(ctx);
 
-	for (i = 0; i < nr; ++i)
-		io_put_req(cs->reqs[i]);
+	rb.to_free = 0;
+	for (i = 0; i < nr; ++i) {
+		req = cs->reqs[i];
+		if (refcount_dec_and_test(&req->refs))
+			io_req_free_batch(&rb, req);
+	}
+	io_req_free_batch_finish(ctx, &rb);
 	cs->nr = 0;
 }
 
-- 
2.24.0

