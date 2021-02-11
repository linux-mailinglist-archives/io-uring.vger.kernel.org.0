Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDD731925A
	for <lists+io-uring@lfdr.de>; Thu, 11 Feb 2021 19:35:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhBKSfM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 13:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbhBKSdF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 13:33:05 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D6EC061788
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 10:32:18 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id g10so5203711wrx.1
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 10:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=6hsOFnxYgfPDDHA16zwINWueucEfzi/rZSmopAdE1sU=;
        b=NJICZ/whDpv19bpB+qwkviREhClOUATtZSiGNA639Y7Y42tXldEF1CQUoH1gOErLHO
         aOBBQJZEI9Vo5Q1IzMd11mljQ56heB8XymtmPrDG2wwfYw7/Zqnb8k0aoOG2mPPbDb4S
         7j+8xfi021YJnyncbRyeAyuN/Fuelz9WWuKgJvQDzr0/BYEVQhRtrsfofv7o8ngjPBP8
         RVPtUP23OXAlptIKhSbfDPP4JwnlelK7CSjyBGxHFGxNY832G7qdNW+Lgrvq0GAtAJRb
         dtyP27XcLsDEoRptJ42YTRKq02hu7XL8hWx5cITqav+kghyoH5J+wPSEmHGmCwRyZYdT
         Dxqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6hsOFnxYgfPDDHA16zwINWueucEfzi/rZSmopAdE1sU=;
        b=tHsuyulEq4nhSsMTnSbDoUlnmylEas2UgAIl7ud4NI9iHWHcfQkks27qKK5cvpNi1I
         8VR/OkdHGant3R1ttDMIDN8EsNxoghXg0JgJdm8T4MEJzwes2NoWjrReu1D1AqT+4fqL
         yJN9ibAomKkBbyPSXDWRvGnaLHS7frGF0Dn7ggZMBDKjltY4jdSd8+wsl21/ohzD7DFR
         Sbrm9V1OC/ro05icHcexy6Q37J2+tcFDLW/v6R1JO0mjapwirP3KXfy8erqDt5pDGDlr
         /PbKtck2lfOJ7BGgP0L+fubCF5WItqqT+GVChyvzXdLrpgDOvgC0KDRXCns/2QZAs+W/
         ox6w==
X-Gm-Message-State: AOAM5307/ztA74MG8W218ZHAirvpzd5dkPbahmbh+uL2+P5Eds1DtUmG
        XisuertqwJpBtjR5ZsBMn7E=
X-Google-Smtp-Source: ABdhPJwfe1Hg1zfn0xvVOFaDkfmZ5GQJOYI30pLrrvwfjJiW3teF2iw+ngxoNtKII21i//eu4SBbFg==
X-Received: by 2002:adf:c6c1:: with SMTP id c1mr7011349wrh.326.1613068337131;
        Thu, 11 Feb 2021 10:32:17 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id a17sm6501595wrx.63.2021.02.11.10.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 10:32:16 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: simplify iopoll reissuing
Date:   Thu, 11 Feb 2021 18:28:21 +0000
Message-Id: <a005b6f6715af880cb16d127b12fa2f62b7005a9.1613067783.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613067782.git.asml.silence@gmail.com>
References: <cover.1613067782.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't stash -EAGAIN'ed iopoll requests into a list to reissue it later,
do it eagerly. It removes overhead on keeping and checking that list,
and allows in case of failure for these requests to be completed through
normal iopoll completion path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0d612e9f7dda..3df27ce5938c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1026,8 +1026,7 @@ static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
 static void init_fixed_file_ref_node(struct io_ring_ctx *ctx,
 				     struct fixed_rsrc_ref_node *ref_node);
 
-static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
-			     unsigned int issue_flags);
+static bool io_rw_reissue(struct io_kiocb *req, long res);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req, int nr);
@@ -2555,17 +2554,6 @@ static inline bool io_run_task_work(void)
 	return false;
 }
 
-static void io_iopoll_queue(struct list_head *again)
-{
-	struct io_kiocb *req;
-
-	do {
-		req = list_first_entry(again, struct io_kiocb, inflight_entry);
-		list_del(&req->inflight_entry);
-		__io_complete_rw(req, -EAGAIN, 0, 0);
-	} while (!list_empty(again));
-}
-
 /*
  * Find and free completed poll iocbs
  */
@@ -2574,7 +2562,6 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 {
 	struct req_batch rb;
 	struct io_kiocb *req;
-	LIST_HEAD(again);
 
 	/* order with ->result store in io_complete_rw_iopoll() */
 	smp_rmb();
@@ -2584,13 +2571,13 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		int cflags = 0;
 
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
+		list_del(&req->inflight_entry);
+
 		if (READ_ONCE(req->result) == -EAGAIN) {
-			req->result = 0;
 			req->iopoll_completed = 0;
-			list_move_tail(&req->inflight_entry, &again);
-			continue;
+			if (io_rw_reissue(req, -EAGAIN))
+				continue;
 		}
-		list_del(&req->inflight_entry);
 
 		if (req->flags & REQ_F_BUFFER_SELECTED)
 			cflags = io_put_rw_kbuf(req);
@@ -2605,9 +2592,6 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	io_commit_cqring(ctx);
 	io_cqring_ev_posted_iopoll(ctx);
 	io_req_free_batch_finish(ctx, &rb);
-
-	if (!list_empty(&again))
-		io_iopoll_queue(&again);
 }
 
 static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
-- 
2.24.0

