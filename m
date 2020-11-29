Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63BFB2C7A2D
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 18:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725468AbgK2RQK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 Nov 2020 12:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgK2RQJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 Nov 2020 12:16:09 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A0FC0613D2
        for <io-uring@vger.kernel.org>; Sun, 29 Nov 2020 09:15:29 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id r3so11999711wrt.2
        for <io-uring@vger.kernel.org>; Sun, 29 Nov 2020 09:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5wVCA5zAhJi3ibB8xv0prhXjM4A9dYlnDof9db2GeA8=;
        b=dm2Cb30JTWOlY3vLkQSA0IUuDubvAuyi+txOkWEhjRFOcKb48iXERzid1eU1u+aDpr
         I/HkyWVUxHCsKOsSyYojqsLW9xNW2ittdhlAOZbUrkk7dXqAEno+IplbMsMnVL1bS/WX
         EDO0oEisNu7RRb3MX9e0DYvYsEicS1JDlK8P8X30BTyCDh/FGITfYpzFelspXXBYdojo
         EvsihNdZmAvkEhPngNVMJ9VhdsCRcmUv8xGH+vK0/AJjaetLa6NCEoiR0QpOykLxrAbk
         asUIegERkolrKlH5+WJjaRHW+tQon4pPeM4SyrgKPW6T9lEciaZWb39i2TEeJUnUKAmK
         Gmvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5wVCA5zAhJi3ibB8xv0prhXjM4A9dYlnDof9db2GeA8=;
        b=Wj19SOiXVw5HnfeZCItktGu4TvD+CVACw97vn8yh8OFM9WJgdBeJxu8kXczyhULNZM
         EI0b0X1irOunf3Kh7ApfHVVD7d0qUeIIiyc6CpIKIQnK/9yax8jra3K6hUxPy9Z6b8S1
         7XdoKm1mAYchKQFwZUIsGua4KyqmJ3viT6+cFeK9EDqujDmCNCGKHP/UInrigA83uDwZ
         umQG3VNrjN3tCB2aTxBtmyEV1Io6rTTGRw7EmW2K9oVtuDuQCggsw5kVHaovXMgse51B
         USsve9MQZlAFMfrEZuLC4+NxWFMi4GrBlfYxnIcsitg9ct7ZQBFqvZ8V7BNvJecoJ1fa
         hNxw==
X-Gm-Message-State: AOAM5320SHRy2bZoRZU7TrYZK92Z+tftVEtsJzad7fDrQuRKi5NKd7x2
        S8NJPy66nlorApWofiknEyQ=
X-Google-Smtp-Source: ABdhPJwZo+4sQioxulXqDc22gOEq6FNTG5aIRyuHVfIZ+0nk/gaidCW3lmg1QzUVjuZb2SXaUWxIyw==
X-Received: by 2002:a5d:4408:: with SMTP id z8mr24098206wrq.204.1606670128054;
        Sun, 29 Nov 2020 09:15:28 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id b4sm23312035wmc.1.2020.11.29.09.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 09:15:27 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: restructure io_timeout_cancel()
Date:   Sun, 29 Nov 2020 17:12:05 +0000
Message-Id: <fd52cfd984a41b35537bc89f425913f6af993c21.1606669225.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1606669225.git.asml.silence@gmail.com>
References: <cover.1606669225.git.asml.silence@gmail.com>
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

