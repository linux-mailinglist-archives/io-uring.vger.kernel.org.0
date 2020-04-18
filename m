Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1699D1AF2C7
	for <lists+io-uring@lfdr.de>; Sat, 18 Apr 2020 19:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725887AbgDRRV3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Apr 2020 13:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbgDRRV0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Apr 2020 13:21:26 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566A0C061A0C;
        Sat, 18 Apr 2020 10:21:26 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j2so6730493wrs.9;
        Sat, 18 Apr 2020 10:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=opwq7WaemVsGEJNw3wCSS+8VjmvBFuq9wKON3tO4pE8=;
        b=NFhrdY0b5xd8EReKFIhJHKMBtlbDK6n4dbLwv1AEz7zogoE1E5G/BGD+V/FoLrXYAg
         gLi2Quz9eAaQLJmLOzKCgtdgdNdVbT7mWprDUe8CpyFQZKhS6aBeV8zKFZzNCHPvTKe6
         v2vJDsohwq03JnOzZrDCQd/xdlONAlIWh0laxM1VprLTIXc39fsEMt1Kvyrw0pUdZw3j
         sfsaQHQZRJhxoJSajjB/N325IUBapACIm2ZigFpvGxOkeH8+dLyWTNXp3KOhxJ5Dbrov
         0PNTbAPYeNTDk5vA8D+umvEcAxsDqnAtF9djnSwhF/DC/PHms2/RZ087QjHjpdw1Z2yj
         fhVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=opwq7WaemVsGEJNw3wCSS+8VjmvBFuq9wKON3tO4pE8=;
        b=APvKcJqta6suGG6CLx01NST02Kk++TRjhEwsy8EZcGsPyQOQFUdIGxSYnoZNqjn7+L
         601AgLP5/q/Y35RyO7W3Nn4Hu/uiC/0T1RyQgEbMgmkYEcnOZG8CSiE/kheMJIgSBwLw
         y4YRAuL2qctTkLMtttMhrEw7+9pxmoBMySfIOXv5HcB5TVCzBWMUuhoimgfJaGB9K7q8
         firfgWe+XEAk0FElrVpRkbc8V4UFlGfrlw1P7xLdFEF6dSpU+x+saepszDOUPJ4d985t
         9r99DRb8j9dJitV/pcbrq1xO9J7lvJ0MtS5qWj7g4ECQiLbzT6ccj3Rw6upspqkESrSX
         2RQg==
X-Gm-Message-State: AGi0PuYlqB6TgUp1vrKYk6Mi+cCj3leAP3872SMovkWX+67KZX8DVgZv
        TyHcHQXSZ5hXgZrhpOYepW6O0zUy
X-Google-Smtp-Source: APiQypI7GMOOOS78s5pGpgv6Ud1dHvPJHI0i3erQhI/DkAJaavNBqWiQ2OvqhXT+DLOoU28t2ND/7Q==
X-Received: by 2002:adf:82a6:: with SMTP id 35mr9437869wrc.378.1587230484932;
        Sat, 18 Apr 2020 10:21:24 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id b85sm12538247wmb.21.2020.04.18.10.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2020 10:21:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] io_uring: don't trigger timeout with another t-out
Date:   Sat, 18 Apr 2020 20:20:11 +0300
Message-Id: <bcbbaa59d9edd2174c6d6a5303f76dba191b00c8.1587229607.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1587229607.git.asml.silence@gmail.com>
References: <cover.1587229607.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When deciding whether to fire a timeout basing on number of completions,
ignore CQEs emitted by other timeouts.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c34c5dcc90fc..d72f82c09ce3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1098,33 +1098,20 @@ static void io_kill_timeouts(struct io_ring_ctx *ctx)
 	spin_unlock_irq(&ctx->completion_lock);
 }
 
-static inline bool io_check_in_range(u32 pos, u32 start, u32 end)
-{
-	/* if @end < @start, check for [end, MAX_UINT] + [MAX_UINT, start] */
-	return (pos - start) <= (end - start);
-}
-
 static void __io_flush_timeouts(struct io_ring_ctx *ctx)
 {
-	u32 end, start;
-
-	start = end = ctx->cached_cq_tail;
 	do {
 		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
 							struct io_kiocb, list);
 
 		if (req->flags & REQ_F_TIMEOUT_NOSEQ)
 			break;
-		/*
-		 * multiple timeouts may have the same target,
-		 * check that @req is in [first_tail, cur_tail]
-		 */
-		if (!io_check_in_range(req->timeout.target_cq, start, end))
+		if (req->timeout.target_cq != ctx->cached_cq_tail
+					- atomic_read(&ctx->cq_timeouts))
 			break;
 
 		list_del_init(&req->list);
 		io_kill_timeout(req);
-		end = ctx->cached_cq_tail;
 	} while (!list_empty(&ctx->timeout_list));
 }
 
@@ -4688,7 +4675,7 @@ static int io_timeout(struct io_kiocb *req)
 		goto add;
 	}
 
-	tail = ctx->cached_cq_tail;
+	tail = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
 	req->timeout.target_cq = tail + off;
 
 	/*
-- 
2.24.0

