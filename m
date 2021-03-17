Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABADF33F58B
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 17:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbhCQQaR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 12:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbhCQQ3v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 12:29:51 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8538BC061760
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:51 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id u10so2070988ilb.0
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UZdCO5aVCibJ7yVRYTKgeJkLtPb0IA6mabScvjzuTi0=;
        b=Tojz5Zon+h2cl6IJ4vYa33RBkNxXZ4q2g+0gkmEaPq+T2uWcEI2qdG2R57i861W1FV
         IUXCZXLa6H0zrn/rxu/UAa7jC49bzk+wWbIIioHUNMmJrKS3/qKl4ew8xXOKsjm4f++Y
         v1dATv56PspCpAlQQa4jaIXuzaMhtDP1vF8e13sQwF18TKYp/xqmAXvCLXFWcCstOTE5
         H4k16EpsfOH3ZyUeIDv4NsR3b5XmUlNtAVGQs462gpP9dVhuEwW2m6lqQPrsBhdd/fwQ
         CDteUaTPN7RL7JqUhM8s5MmKoMQsq74eG/Ri+iWSE+GGQ/S4HAd+XR5zdK6ywOa1oJsv
         W+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UZdCO5aVCibJ7yVRYTKgeJkLtPb0IA6mabScvjzuTi0=;
        b=AMTIyM3EH4d4pikOQO2YZc/pUUBWBOwRb0+GnOS5cA1ctomHXOL9cfrp5sTlLJfs6V
         QTUpp72sWC0r/IL3UvsqB3pQMaB30NI26QW8PBT903SOirqBKiuJCzfmAzF1Idl3clkb
         bIRa6N0A+0CtXoKwTj2QAKpWkU1l4ZeypuvKOzA8lLgEcLKAgkZ0eVV9InVv28I7F/zr
         a4XhW9rbCnywZ6igDP+58WjcRdJUuGU1FB1nDpYnsNvq/gu77XsSL8ZhPl+wcnSGYp/M
         fK5juFpkGqwSJDQNke9qEvyyc5bFDKfgmFtDGbKV8f9JOTk9rldEjZc5SBhQh8pXlyT8
         0fYg==
X-Gm-Message-State: AOAM533uAufIrR1qIZZ7YjtqkMjSmbwa7iYMok98AJbzXbvovdwdPgfu
        rTaJkafzv8ZFLZgevhq5v8nMrhWQt4gyMg==
X-Google-Smtp-Source: ABdhPJy8NCFTHt5dar0EhVKhcykt1NGJfxrZR4NOiyUU3pNgtYnoVY6jhY4n8x4YdrZNGwwirWrlhQ==
X-Received: by 2002:a92:da82:: with SMTP id u2mr8081728iln.301.1615998590826;
        Wed, 17 Mar 2021 09:29:50 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h1sm11164271ilo.64.2021.03.17.09.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 09:29:50 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/9] io_uring: abstract out a io_poll_find_helper()
Date:   Wed, 17 Mar 2021 10:29:42 -0600
Message-Id: <20210317162943.173837-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210317162943.173837-1-axboe@kernel.dk>
References: <20210317162943.173837-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We'll need this helper for another purpose, for now just abstract it
out and have io_poll_cancel() use it for lookups.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8a37a62c04f9..8ed363bd95aa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5298,7 +5298,7 @@ static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	return posted != 0;
 }
 
-static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
+static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, __u64 sqe_addr)
 {
 	struct hlist_head *list;
 	struct io_kiocb *req;
@@ -5307,12 +5307,23 @@ static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
 	hlist_for_each_entry(req, list, hash_node) {
 		if (sqe_addr != req->user_data)
 			continue;
-		if (io_poll_remove_one(req))
-			return 0;
-		return -EALREADY;
+		return req;
 	}
 
-	return -ENOENT;
+	return NULL;
+}
+
+static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
+{
+	struct io_kiocb *req;
+
+	req = io_poll_find(ctx, sqe_addr);
+	if (!req)
+		return -ENOENT;
+	if (io_poll_remove_one(req))
+		return 0;
+
+	return -EALREADY;
 }
 
 static int io_poll_remove_prep(struct io_kiocb *req,
-- 
2.31.0

