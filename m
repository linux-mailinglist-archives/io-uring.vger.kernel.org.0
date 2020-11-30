Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56B32C8DC9
	for <lists+io-uring@lfdr.de>; Mon, 30 Nov 2020 20:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbgK3TPW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Nov 2020 14:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729807AbgK3TPU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Nov 2020 14:15:20 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48897C0613D2
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 11:14:40 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id x22so404943wmc.5
        for <io-uring@vger.kernel.org>; Mon, 30 Nov 2020 11:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5wVCA5zAhJi3ibB8xv0prhXjM4A9dYlnDof9db2GeA8=;
        b=CTY96zYJeEwsJk8lHc41GpNrZDK/531RPtmXdWSXYVFo9VpR3hoJtYCgzfD1KCcF2n
         syKEmezRsX2+MNo6YdYvDHPwkez105F3CrMKQ5aVEJLJ1yBnOsF8mXmdIie/Ui8LTmqb
         1gx/ZXS71ySpcOvNkCqvbOiJnkkbKQ1gTZ3IgyZcf1mLACK5yPJvIA7tCZ8GdP9Rxhqa
         JGRw5HWHKqK2pqByw82+qNS1MTwg6Y/aAPUnI44QbTg7c2HPdtBMwbL9k/34taZhXoQA
         EWS+UzyggvXxdRfcsa8O3E+WmS1q7OEYmQozBiIU9qkUyYaKJz66gdW5cn9nCbIp9ZBS
         VIxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5wVCA5zAhJi3ibB8xv0prhXjM4A9dYlnDof9db2GeA8=;
        b=ihfTsTdUTuggw2rwG2pqz/992wlZGHwzbWJm0JHSa4BTKqnOrdJJxswyqMkWkYft2I
         6er0IoL4g1pWoBHC94PhJ+B+dj3gaaT30mHFEpB0v57ci3T0lirkH1VVAyps2m/0JPjJ
         gPMF9WURR/F1XPO8vhuChVPmaa4A5FUIspHpKL/RmoXmY9q6OIXxNObjapt4QU5AFEjH
         k4H2RSTRrK6lWyNNPK/HRlUJSc/P7N5IspZaQDYr9K3Mt8TxDhqmY228OEUoseD/g5hO
         l1SAgxVXCnBSbHu7OAsktQYZVwNQgXg3kJqoRfVK0YQIBE68mpxAVamUkB2SGYg3Alxl
         omhA==
X-Gm-Message-State: AOAM531pRxgkcBJ051tZ0ZtramEvNTv5JrE57SH8DgJrmxJd4qSDfWKV
        N4mafanBBNYSXKOC7fycOug=
X-Google-Smtp-Source: ABdhPJxWZXoa3eumqN3DRqR64n8sqosyFi3mFkM0XGZ5gMvbJqY8yplxQuxUKXRSnPuK72Xmcc0WKg==
X-Received: by 2002:a7b:c954:: with SMTP id i20mr351910wml.56.1606763679077;
        Mon, 30 Nov 2020 11:14:39 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id d3sm28690657wrr.2.2020.11.30.11.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 11:14:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 1/2] io_uring: restructure io_timeout_cancel()
Date:   Mon, 30 Nov 2020 19:11:15 +0000
Message-Id: <965774063ec076e54e5bfb50391bf82e766c0bd8.1606763416.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1606763415.git.asml.silence@gmail.com>
References: <cover.1606763415.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add io_timeout_extract() helper, which searches and disarms timeouts,
but doesn't complete them. No functional changes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 12e641c61708..bffcbec6c9be 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5639,24 +5639,10 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-static int __io_timeout_cancel(struct io_kiocb *req)
-{
-	struct io_timeout_data *io = req->async_data;
-	int ret;
-
-	ret = hrtimer_try_to_cancel(&io->timer);
-	if (ret == -1)
-		return -EALREADY;
-	list_del_init(&req->timeout.list);
-
-	req_set_fail_links(req);
-	io_cqring_fill_event(req, -ECANCELED);
-	io_put_req_deferred(req, 1);
-	return 0;
-}
-
-static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
+static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
+					   __u64 user_data)
 {
+	struct io_timeout_data *io;
 	struct io_kiocb *req;
 	int ret = -ENOENT;
 
@@ -5668,9 +5654,27 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 	}
 
 	if (ret == -ENOENT)
-		return ret;
+		return ERR_PTR(ret);
+
+	io = req->async_data;
+	ret = hrtimer_try_to_cancel(&io->timer);
+	if (ret == -1)
+		return ERR_PTR(-EALREADY);
+	list_del_init(&req->timeout.list);
+	return req;
+}
 
-	return __io_timeout_cancel(req);
+static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
+{
+	struct io_kiocb *req = io_timeout_extract(ctx, user_data);
+
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+
+	req_set_fail_links(req);
+	io_cqring_fill_event(req, -ECANCELED);
+	io_put_req_deferred(req, 1);
+	return 0;
 }
 
 static int io_timeout_remove_prep(struct io_kiocb *req,
-- 
2.24.0

