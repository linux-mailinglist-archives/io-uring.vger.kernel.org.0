Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583F81EE9C1
	for <lists+io-uring@lfdr.de>; Thu,  4 Jun 2020 19:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730268AbgFDRsl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Jun 2020 13:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730094AbgFDRsl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Jun 2020 13:48:41 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BC8C08C5C0
        for <io-uring@vger.kernel.org>; Thu,  4 Jun 2020 10:48:41 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x207so3595120pfc.5
        for <io-uring@vger.kernel.org>; Thu, 04 Jun 2020 10:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2+72omYoL2q4NjVks4UWil+Sa5gI2gRgmz22OQUSSGg=;
        b=LsX1af9ALbQ732hd84qjparaRCvBklohNXgBdOTMScSUqhxirgBFiiF2qwzDiIoP17
         fMaHXqRQoa4NYY9lwja/eopsFfkRsXj8E4caRCd78cSVvYnqcy8Lyxch7pmChYd8B/96
         f5cMOB+OJ5hFRpoSwDbAa3OW8jg81r93yRhNBbzzzg3eLuVC5i2gFk5RQT6+gg/ly/b3
         voV6eiO+Ckzu+rHfgYhp5nAfcp2z1B+/tgspyI3wcH0ULl7SsVkHkVxkl2Pirh7fuJIO
         wXjdpqlqmALGf5mFe9iOwRHojtJrGbrw5bLnci8PVKkvx16dr9Q8YjXOcATa55WgukQZ
         bAjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2+72omYoL2q4NjVks4UWil+Sa5gI2gRgmz22OQUSSGg=;
        b=pfH/jnNKtOlksbblNsVLOHgNEQsUa97V7WC9OgX6ffUhq/rq6+Zuw9FFyLTPLtIL3S
         zD0LU3syjG6kHetrvtZAy3m4L06EMjNNi5XaV6LzuOPbv3xQ+wHto08UCNUjSMEOQAlH
         OpvueyhMV0dGmCP2ZRIrXmc1c4jM5iZVEStBlOceqVW5EOkL2R4oHiYcxXaI3Gp1J6RA
         BQvfR2IH84GA+5mFJXWzV7LxK5URXgC0a1N1MTzGx6VmeMTVoyMBO/XfIkkq55VjR1JD
         atTyF2fgEOxRbk2dWtu0ZoPGlaiW74oOj2rtvfVzMMGlXjbWr87XB+F2SZ/lpj6G9zRw
         oNRQ==
X-Gm-Message-State: AOAM531V4GsXa2Twa3kZfnd4kQDipSp8yMYFgvj5+a84s0GImRKvwpId
        WbC4EYJM0yvrOpeNDValms+lcEr7oxsslg==
X-Google-Smtp-Source: ABdhPJzaAtjffy3Dd7OMJ5atO0rRUV4Ou2m48fRdCf7nGMt4yHnHCn6ylEAiEc1NXG6PUi+FrSh2tA==
X-Received: by 2002:a63:305:: with SMTP id 5mr5368749pgd.74.1591292920359;
        Thu, 04 Jun 2020 10:48:40 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n9sm6044494pjj.23.2020.06.04.10.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 10:48:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: re-issue plug based block requests that failed
Date:   Thu,  4 Jun 2020 11:48:32 -0600
Message-Id: <20200604174832.12905-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200604174832.12905-1-axboe@kernel.dk>
References: <20200604174832.12905-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Mark the plug with nowait == true, which will cause requests to avoid
blocking on request allocation. If they do, we catch them and add them
to the plug list. Once we finish the plug, re-issue requests that got
caught.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 45 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 43 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 625578715d37..04b3571b21e9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1947,12 +1947,31 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res)
 	__io_cqring_add_event(req, res, cflags);
 }
 
+static bool io_rw_reissue(struct io_kiocb *req, long res)
+{
+#ifdef CONFIG_BLOCK
+	struct blk_plug *plug;
+
+	if ((res != -EAGAIN && res != -EOPNOTSUPP) || io_wq_current_is_worker())
+		return false;
+
+	plug = current->plug;
+	if (plug && plug->nowait) {
+		list_add_tail(&req->list, &plug->nowait_list);
+		return true;
+	}
+#endif
+	return false;
+}
+
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
-	io_complete_rw_common(kiocb, res);
-	io_put_req(req);
+	if (!io_rw_reissue(req, res)) {
+		io_complete_rw_common(kiocb, res);
+		io_put_req(req);
+	}
 }
 
 static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
@@ -5789,12 +5808,30 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
+#ifdef CONFIG_BLOCK
+static void io_resubmit_rw(struct list_head *list)
+{
+	struct io_kiocb *req;
+
+	while (!list_empty(list)) {
+		req = list_first_entry(list, struct io_kiocb, list);
+		list_del(&req->list);
+		refcount_inc(&req->refs);
+		io_queue_async_work(req);
+	}
+}
+#endif
+
 /*
  * Batched submission is done, ensure local IO is flushed out.
  */
 static void io_submit_state_end(struct io_submit_state *state)
 {
 	blk_finish_plug(&state->plug);
+#ifdef CONFIG_BLOCK
+	if (unlikely(!list_empty(&state->plug.nowait_list)))
+		io_resubmit_rw(&state->plug.nowait_list);
+#endif
 	io_state_file_put(state);
 	if (state->free_reqs)
 		kmem_cache_free_bulk(req_cachep, state->free_reqs, state->reqs);
@@ -5807,6 +5844,10 @@ static void io_submit_state_start(struct io_submit_state *state,
 				  unsigned int max_ios)
 {
 	blk_start_plug(&state->plug);
+#ifdef CONFIG_BLOCK
+	INIT_LIST_HEAD(&state->plug.nowait_list);
+	state->plug.nowait = true;
+#endif
 	state->free_reqs = 0;
 	state->file = NULL;
 	state->ios_left = max_ios;
-- 
2.27.0

