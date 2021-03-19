Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72DBC342347
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 18:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhCSR1H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 13:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhCSR05 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 13:26:57 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33157C06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:26:57 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e9so9888353wrw.10
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=bZ94p+PVfAyOkrBVNwvio0R3kbYXAJI4jww/A1exxko=;
        b=nRIgz5roHNNnAXod0HOSg/QUoD6lsa8cpU82KM30Og7w0MtPE1pTjrC11a1y7HB341
         CS/YXtd1oU+mbN6OG0qzwYA/+F9H+jc3tkWJ6WIjc+JrqzyL557OSp7u/vTScLKXQ6Lh
         ycjKPaQt7bmaJYaSdVLHaubcU54DbGhVnwlelX6n/vZNUzqwylUy0TZOHbBnrgKM7fU5
         gkHpngzMcpKStHnTpHrpwTLB1btaYeDMjK3Q/cHueCYq+XogA8cz+huz95yj7V1hRIuH
         msoCOjzNmUD/OyXPnb7SUkzEWRSIKZEudy/Ws0ana61pGbTMhIct4yGMTNInwkOgjl4Z
         xI5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bZ94p+PVfAyOkrBVNwvio0R3kbYXAJI4jww/A1exxko=;
        b=ClNfrfynjNbWNuXAiyVVFWaxVsDUGdHcfT4CNSeJTIrrcKQUzZ1pwFsjEhMHDsyEap
         nby/9CH8iy8pSNgt9GPNpVFbLZb+MeBy9PGzWFc0tzRK1Um82wM0PEWzIfp7b/gMGfaq
         VJ3VsUJhkCfJ0hao0zjVvPlVO5vp7nCboWkdSYxB6WsL1VzF/HlFo+WwCDoyM2SYhZQY
         G4VJkL2fs4346tsppS0oOo+DmSF9WQoxX5o3BmOe0kT7itFBe1u+sYkxDhIXOcP29nrw
         Xv+oUr+YxyvRmQMBultZpLX5ti/CeTrNkFH9mQtI2cMDRogmElazvbRmWbpJ+NB4XbT3
         t/Cg==
X-Gm-Message-State: AOAM5331E2Xpl/4qphqCyphiFjBeMs+Dzl57naiLi4OQ00KB92yNX5xh
        BrBrfljnbinUJ5+t1xkWIoM=
X-Google-Smtp-Source: ABdhPJyPX1zvKg7z6AZ6agROVcrGTQ/ExSUwq0Sz1DQY2iUE/ZgJ7WMxGrzUijK9zE+O+eoIhfHZFw==
X-Received: by 2002:a5d:58e8:: with SMTP id f8mr5759306wrd.102.1616174815955;
        Fri, 19 Mar 2021 10:26:55 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id i8sm7112943wmi.6.2021.03.19.10.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 10:26:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/16] io_uring: optimise success case of __io_queue_sqe
Date:   Fri, 19 Mar 2021 17:22:34 +0000
Message-Id: <e4eb47d977a105f5a9792a0b5a2e0b15d6ab0219.1616167719.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616167719.git.asml.silence@gmail.com>
References: <cover.1616167719.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move the case of successfully issued request by doing that check first.
It's not much of a difference, just generates slightly better code for
me.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a5e5c8da1081..c29f96e3111d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6317,15 +6317,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
 	 * doesn't support non-blocking read/write attempts
 	 */
-	if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
-		if (!io_arm_poll_handler(req)) {
-			/*
-			 * Queued up for async execution, worker will release
-			 * submit reference when the iocb is actually submitted.
-			 */
-			io_queue_async_work(req);
-		}
-	} else if (likely(!ret)) {
+	if (likely(!ret)) {
 		/* drop submission reference */
 		if (req->flags & REQ_F_COMPLETE_INLINE) {
 			struct io_ring_ctx *ctx = req->ctx;
@@ -6337,6 +6329,14 @@ static void __io_queue_sqe(struct io_kiocb *req)
 		} else {
 			io_put_req(req);
 		}
+	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
+		if (!io_arm_poll_handler(req)) {
+			/*
+			 * Queued up for async execution, worker will release
+			 * submit reference when the iocb is actually submitted.
+			 */
+			io_queue_async_work(req);
+		}
 	} else {
 		io_req_complete_failed(req, ret);
 	}
-- 
2.24.0

