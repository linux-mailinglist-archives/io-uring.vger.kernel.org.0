Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F4231A532
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 20:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhBLTRx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Feb 2021 14:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbhBLTRl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Feb 2021 14:17:41 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA29C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 11:17:01 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id j11so590711wmi.3
        for <io-uring@vger.kernel.org>; Fri, 12 Feb 2021 11:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bHGwdQPuj+43dpwXuqddn/NJbnD4NuPga+JbrAlGJv0=;
        b=McX3FZeBclPsIkQxErTvn3RXU61d4AQdUF1AeYJ2CYdu0dO7ZEVuZ7ZQM59A7U44Y2
         JwYaw2vV41Jhr8iY0CPk8oNuxcuf10+2H5c4FnRuoRsXcKv1S73qu4vbpULQ9IMY2TvL
         ZS5KWl1o+bFHAPRrN5ewxfxXA2ZgkgeN/u2inWX11yP4JmVvD0OmRkyG8MeRTiUJHdQf
         pt4RJUPl0bN3fRL+F1JI+Ujlkrdnh82H6Ku0l0iNoKWBlMJTp0wekW7rBW2jVTM6w8yn
         RYuRM5Qup1rNTO/Xfg+vQQjm5eVwnKVXTpUelfmhz4MaEAq+xXsBMfveqCkhUunnn98f
         qLsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bHGwdQPuj+43dpwXuqddn/NJbnD4NuPga+JbrAlGJv0=;
        b=FHdhPRz38xU4VtJ9jMgKC3adfVzSaYaY6MSeZdmCo03ezjABRqsAv5+XXwekVC8t+W
         N0l9mB9Fcde1oG95sZVreYFSIKzo5nDQca7Zv70PKPTDrC+ZEBFEW1N/P2GHfcAraUUL
         TDwXZitDPVD7fbVhEWyMJNFnxb32cQiNonJ/Zdxr0knrnbFnNncX0Bvwlpi4ifIm79nf
         8u6VIyZlE++E7WQjz7abKhbqRz1mU1eb5c1UHG+b0CutO8fxpHTJsOJ/XBfrEtDk1iwk
         baTvDxv35z7sb7pJxX7ed8LvMbr21IImpS0xFludqJTXggevrn4mBEWIPXJqCEfHpJLA
         kQGQ==
X-Gm-Message-State: AOAM531xI7VeLyHuVSme/QBGE6WCSNHAqCm33Tw+ZYm166kuRnlmHsDc
        +8wXRFkEFo5VchiDWUaunqKoPCzgHQeTyg==
X-Google-Smtp-Source: ABdhPJwUi6BOBL0CGzwhtYNnUBLZR34InSzEfsGhkdwZBFAzz4Ub9xKa4pEhNz6MOZ250DSlUkbdTQ==
X-Received: by 2002:a1c:4ca:: with SMTP id 193mr3988857wme.178.1613157419833;
        Fri, 12 Feb 2021 11:16:59 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id e12sm3731783wrv.59.2021.02.12.11.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 11:16:59 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH RFC] io_uring: batch rsrc refs put
Date:   Fri, 12 Feb 2021 19:13:07 +0000
Message-Id: <2a090c33163458a9c9f5f77313e7b4433be46bce.1613156887.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Batch putting down rsrc_node refs. Since struct req_batch is used even
more extensively, can shed some extra cycles.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Pretty much a (working) RFC. I wouldn't find any difference with my
setup, but in case you will be striving to close the remaining 5%.

 fs/io_uring.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0fea1342aeef..b7b0d76453ca 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1930,6 +1930,8 @@ static inline void io_req_complete_post(struct io_kiocb *req, long res,
 
 		io_dismantle_req(req);
 		io_put_task(req->task, 1);
+		if (req->fixed_rsrc_refs)
+			percpu_ref_put(req->fixed_rsrc_refs);
 		list_add(&req->compl.list, &cs->locked_free_list);
 		cs->locked_free_nr++;
 	} else
@@ -2044,8 +2046,6 @@ static void io_dismantle_req(struct io_kiocb *req)
 		kfree(req->async_data);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
-	if (req->fixed_rsrc_refs)
-		percpu_ref_put(req->fixed_rsrc_refs);
 	io_req_clean_work(req);
 }
 
@@ -2065,6 +2065,8 @@ static void __io_free_req(struct io_kiocb *req)
 
 	io_dismantle_req(req);
 	io_put_task(req->task, 1);
+	if (req->fixed_rsrc_refs)
+		percpu_ref_put(req->fixed_rsrc_refs);
 
 	kmem_cache_free(req_cachep, req);
 	percpu_ref_put(&ctx->refs);
@@ -2381,6 +2383,9 @@ struct req_batch {
 	struct task_struct	*task;
 	int			task_refs;
 	int			ctx_refs;
+
+	struct percpu_ref	*rsrc_refs;
+	unsigned int		rsrc_refs_nr;
 };
 
 static inline void io_init_req_batch(struct req_batch *rb)
@@ -2388,6 +2393,15 @@ static inline void io_init_req_batch(struct req_batch *rb)
 	rb->task_refs = 0;
 	rb->ctx_refs = 0;
 	rb->task = NULL;
+	rb->rsrc_refs = NULL;
+	rb->rsrc_refs_nr = 0;
+}
+
+static inline void __io_req_batch_flush_rsrc_refs(struct req_batch *rb)
+{
+	/* can get positive ->rsrc_refs_nr with NULL ->rsrc_refs */
+	if (rb->rsrc_refs)
+		percpu_ref_put_many(rb->rsrc_refs, rb->rsrc_refs_nr);
 }
 
 static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
@@ -2397,6 +2411,8 @@ static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
 		io_put_task(rb->task, rb->task_refs);
 	if (rb->ctx_refs)
 		percpu_ref_put_many(&ctx->refs, rb->ctx_refs);
+
+	__io_req_batch_flush_rsrc_refs(rb);
 }
 
 static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
@@ -2413,6 +2429,14 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 	rb->task_refs++;
 	rb->ctx_refs++;
 
+	if (req->fixed_rsrc_refs != rb->rsrc_refs) {
+		__io_req_batch_flush_rsrc_refs(rb);
+		rb->rsrc_refs = req->fixed_rsrc_refs;
+		rb->rsrc_refs_nr = 0;
+	}
+	/* it's ok to increment for NULL rsrc_refs, we'll handle it */
+	rb->rsrc_refs_nr++;
+
 	io_dismantle_req(req);
 	if (state->free_reqs != ARRAY_SIZE(state->reqs))
 		state->reqs[state->free_reqs++] = req;
-- 
2.24.0

