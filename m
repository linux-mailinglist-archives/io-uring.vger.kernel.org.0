Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DDD20E243
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 00:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390233AbgF2VDp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Jun 2020 17:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731131AbgF2TMq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Jun 2020 15:12:46 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84AC7C008600
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 03:14:51 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id q15so14818593wmj.2
        for <io-uring@vger.kernel.org>; Mon, 29 Jun 2020 03:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=tNlxLmKpUyrbeS+Wc0grPyBnlxNPV+3eJTjotL68xqo=;
        b=NWLrHmHUkvGmMyiDEGaZgh09S6N/ZfBZPtiW6Dr0jP85y1w4iBMzG4fR0Ykcnr3O5h
         rCKFmN7ZpGiqTCblg29MhZIuIr6LJcqHOS9nRxmiLz8PGwAw0/Bkw3HWU0YPiWxr1WGZ
         egHY62U+HAf08vnBRswbBSI6Z4rI/0/ZYU+SVmU4Km2PqEd3OKiM5h/LYpc0bbpBTPgB
         CH09kJcRs4EC4BB2J1pwUvnvcytQu9UaYUz2kewnjxY3vv+VG7z9Pk0l9yvpUJFklDRI
         vLhLgHlZE5mDgCCCvgkRk0d6B7EVfjhLpbptjVwuyXFRt/hT4rb+SyRVd6S7p9MX+Wy0
         9MVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tNlxLmKpUyrbeS+Wc0grPyBnlxNPV+3eJTjotL68xqo=;
        b=o+9ZADvHs8nWfxEreoQyD90DbxosBAjVP0mx5FA/luadINymva7NnB/FfjJLOmvpPE
         tPBCx7VIaPIWN2CbIBhbsu3jvCDqU7l23jfrc0pCXX4maFXwMFCsNdgSxOwUunWuB7kF
         nWawaqFG2QpFBkzrY78xQ5UTxYSN/MI9qLhXIc+Z8L1eTtl6OkHCWCvsXQY4qSb3M185
         Dk3bdW62J+tzqL9GKSLXhx0YAqJekELaXkn6rS5IbpEd+Nd/qUMQU68pg1TUCRSXQ6Jb
         H6QIyY86YvMEq4E7SAWE08MeL83dhyLgSPzCvlQtNtgMh77s/VDQBSrTOXql/ZGD0lbm
         scFg==
X-Gm-Message-State: AOAM530sUz7qvuD/8S9dGa/ymgubfdM/CH4i3V4UgGkjvHVSWoO42oMA
        PAxrWoLbC4IyiNCoxym7jMTHDG/6
X-Google-Smtp-Source: ABdhPJxzTsfsG+2CMRGDVa3gUwK1nQL7AdOx6+SaLHeVq1dGhA/dqBjmm6QrwIaWIMp79eo0eBA59g==
X-Received: by 2002:a1c:9e4c:: with SMTP id h73mr6295229wme.177.1593425690186;
        Mon, 29 Jun 2020 03:14:50 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id a12sm37807233wrv.41.2020.06.29.03.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 03:14:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/5] io_uring: kill REQ_F_TIMEOUT_NOSEQ
Date:   Mon, 29 Jun 2020 13:13:02 +0300
Message-Id: <598abe53799e914b2ee0725f1443405e933de817.1593424923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593424923.git.asml.silence@gmail.com>
References: <cover.1593424923.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are too many useless flags, kill REQ_F_TIMEOUT_NOSEQ, which can be
easily infered from req.timeout itself.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 159882906a24..40996f25822e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -532,7 +532,6 @@ enum {
 	REQ_F_NOWAIT_BIT,
 	REQ_F_LINK_TIMEOUT_BIT,
 	REQ_F_ISREG_BIT,
-	REQ_F_TIMEOUT_NOSEQ_BIT,
 	REQ_F_COMP_LOCKED_BIT,
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_OVERFLOW_BIT,
@@ -575,8 +574,6 @@ enum {
 	REQ_F_LINK_TIMEOUT	= BIT(REQ_F_LINK_TIMEOUT_BIT),
 	/* regular file */
 	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
-	/* no timeout sequence */
-	REQ_F_TIMEOUT_NOSEQ	= BIT(REQ_F_TIMEOUT_NOSEQ_BIT),
 	/* completion under lock */
 	REQ_F_COMP_LOCKED	= BIT(REQ_F_COMP_LOCKED_BIT),
 	/* needs cleanup */
@@ -1010,6 +1007,11 @@ static void io_ring_ctx_ref_free(struct percpu_ref *ref)
 	complete(&ctx->ref_comp);
 }
 
+static inline bool io_is_timeout_noseq(struct io_kiocb *req)
+{
+	return !req->timeout.off;
+}
+
 static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 {
 	struct io_ring_ctx *ctx;
@@ -1222,7 +1224,7 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
 							struct io_kiocb, list);
 
-		if (req->flags & REQ_F_TIMEOUT_NOSEQ)
+		if (io_is_timeout_noseq(req))
 			break;
 		if (req->timeout.target_seq != ctx->cached_cq_tail
 					- atomic_read(&ctx->cq_timeouts))
@@ -5064,8 +5066,7 @@ static int io_timeout(struct io_kiocb *req)
 	 * timeout event to be satisfied. If it isn't set, then this is
 	 * a pure timeout request, sequence isn't used.
 	 */
-	if (!off) {
-		req->flags |= REQ_F_TIMEOUT_NOSEQ;
+	if (io_is_timeout_noseq(req)) {
 		entry = ctx->timeout_list.prev;
 		goto add;
 	}
@@ -5080,7 +5081,7 @@ static int io_timeout(struct io_kiocb *req)
 	list_for_each_prev(entry, &ctx->timeout_list) {
 		struct io_kiocb *nxt = list_entry(entry, struct io_kiocb, list);
 
-		if (nxt->flags & REQ_F_TIMEOUT_NOSEQ)
+		if (io_is_timeout_noseq(nxt))
 			continue;
 		/* nxt.seq is behind @tail, otherwise would've been completed */
 		if (off >= nxt->timeout.target_seq - tail)
-- 
2.24.0

