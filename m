Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AE525CEAB
	for <lists+io-uring@lfdr.de>; Fri,  4 Sep 2020 02:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgIDAEh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Sep 2020 20:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbgIDAEf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Sep 2020 20:04:35 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577ABC061245
        for <io-uring@vger.kernel.org>; Thu,  3 Sep 2020 17:04:35 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d19so3373332pgl.10
        for <io-uring@vger.kernel.org>; Thu, 03 Sep 2020 17:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sd/r0Ut/X1co1R3u72XJcdAohW3HHZAGmeJWg3sgfpc=;
        b=x9jFp0zeU0NkSObTbG65NeBFgtUrx1Hk5wBT92AQfKY3ngp/2sL8pDz7piJxJeIPHB
         rm/UXc07obOGSafdmZFkY0kIfQUIZBDBmfTkedEDl2aH9YfGUIKkk06QS5Z8OgMFL4hO
         Fo6l/TxTCGoOLiCGWIO+ELFC3T8C5LKQtyRzNbhmhTMwQSJD51YxoeC5vXFFOq2P0o7R
         i/5NCMPOOZFutrXTpHBBRifvuzaw1j0qitPvUsR2Uydw8rBn3JaeyIJP4OJb2chkSf8n
         8OPjgH7lFPNvKLw5yaDb2pQyUb8jlmhN9ymKJOANxF1O+p1uk4QIJ1luN+hAZ2fbunGQ
         +eBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sd/r0Ut/X1co1R3u72XJcdAohW3HHZAGmeJWg3sgfpc=;
        b=HOX2yzkiBDDBCDe307P1lR2dtjSW7SJjKjSrrBzjXjmInqokK8vErjgjwEFaGEuOVZ
         ik/CTi/oC1OYFcwFuc8Rq+VhbF4MzXb31Yye9+YN51NH28csD7uc1vig5kz1mdPBWJj3
         Q3ZzrMxoilPEPbxkY27A7Epg22/5PJMCZmN2d6ar/I3QduyV4bNhkE5RlQUP52mM4z84
         +Tlh7Z/Drz02LDJ10fyfBm4xCA28pNvcFnCqGIH3y0oDy5ocWcYVT8DU6LXJpP4nIf0f
         5qPWrXXm5e143mu8znCz0/DFUCwVz9Ag7dx6UB93KXwZ0kj9AGvLdA/CVVpHiSJwgR38
         yAbw==
X-Gm-Message-State: AOAM530W3AYgjon+6YWiiGwBxSYs9ywxzK1Dj+7HIwffaVjhVh5K1CKm
        XK0mo5W01ZIXvDaxAa5NRxQkbe6oHqDVhvsA
X-Google-Smtp-Source: ABdhPJyyQSHi6xk4gCH3+/jPlV7+6f2/aWWMET1yUEgE1c5zFYwy95QhsUwhFiOOHXBj1Z+6ZImlVA==
X-Received: by 2002:aa7:98cc:: with SMTP id e12mr6027425pfm.66.1599177874597;
        Thu, 03 Sep 2020 17:04:34 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id v8sm18894482pju.1.2020.09.03.17.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 17:04:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: separate ring/file creation from descriptor install
Date:   Thu,  3 Sep 2020 18:02:28 -0600
Message-Id: <20200904000229.90868-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904000229.90868-2-axboe@kernel.dk>
References: <20200904000229.90868-1-axboe@kernel.dk>
 <20200904000229.90868-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As soon as the descriptor is installed, we could potentially have
someone close it. Separate the getting of the anon file and fd from
the descriptor installation, so we can use the fd before we finally
install it at the end.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fc824b94c7ca..79bc148c0f51 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8616,7 +8616,7 @@ static int io_allocate_scq_urings(struct io_ring_ctx *ctx,
  * fd to gain access to the SQ/CQ ring details. If UNIX sockets are enabled,
  * we have to tie this fd to a socket for file garbage collection purposes.
  */
-static int io_uring_get_fd(struct io_ring_ctx *ctx)
+static int io_uring_get_fd(struct io_ring_ctx *ctx, struct file **fptr)
 {
 	struct file *file;
 	int ret;
@@ -8643,7 +8643,7 @@ static int io_uring_get_fd(struct io_ring_ctx *ctx)
 #if defined(CONFIG_UNIX)
 	ctx->ring_sock->file = file;
 #endif
-	fd_install(ret, file);
+	*fptr = file;
 	return ret;
 err:
 #if defined(CONFIG_UNIX)
@@ -8658,8 +8658,9 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 {
 	struct user_struct *user = NULL;
 	struct io_ring_ctx *ctx;
+	struct file *file;
 	bool limit_mem;
-	int ret;
+	int ret, fd = -1;
 
 	if (!entries)
 		return -EINVAL;
@@ -8737,6 +8738,13 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
+	/* Only gets the ring fd, doesn't install it in the file table */
+	fd = io_uring_get_fd(ctx, &file);
+	if (fd < 0) {
+		ret = fd;
+		goto err;
+	}
+
 	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
@@ -8772,16 +8780,9 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 		goto err;
 	}
 
-	/*
-	 * Install ring fd as the very last thing, so we don't risk someone
-	 * having closed it before we finish setup
-	 */
-	ret = io_uring_get_fd(ctx);
-	if (ret < 0)
-		goto err;
-
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
-	return ret;
+	fd_install(fd, file);
+	return fd;
 err:
 	/*
 	 * Our wait-and-kill does do this, but we need it done before we
@@ -8789,7 +8790,18 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	 * files could be done as soon as we exit here.
 	 */
 	io_finish_async(ctx);
-	io_ring_ctx_wait_and_kill(ctx);
+
+	/*
+	 * Final fput() will call release and free everything, so if we're
+	 * failing beyond having gotten a file and fd, just let normal
+	 * release off fput() free things.
+	 */
+	if (fd >= 0) {
+		fput(file);
+		put_unused_fd(fd);
+	} else {
+		io_ring_ctx_wait_and_kill(ctx);
+	}
 	return ret;
 }
 
-- 
2.28.0

