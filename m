Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30497328B27
	for <lists+io-uring@lfdr.de>; Mon,  1 Mar 2021 19:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238585AbhCAS3T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Mar 2021 13:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239643AbhCAS0j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Mar 2021 13:26:39 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E303C0617A7
        for <io-uring@vger.kernel.org>; Mon,  1 Mar 2021 10:24:50 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id d15so1961472wrv.5
        for <io-uring@vger.kernel.org>; Mon, 01 Mar 2021 10:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QH/ZSRSORcsdTbWbXfRhsvYT/1SoWAirgAvGrjORiCU=;
        b=LTi8MNGSjeZO2BNIYKkkvzO/LenI0+thuKRPmSKEefiIzbm7BUfRZ4aOvvOaB8qeZD
         R66GXPEVH2RKXmOm0NJnlCdR3uxQ11CKE2bjFksPGchX+i2QLgX7Yme1Y8ZwLC9ksg4K
         bNaOL6vsKfntkY+TF+NyVNMwbg+cdDM+Z9VE/q9ZTQv4QdhoUjwvH/A4vO0ELMyA4/XN
         qgMQ0D3RR1ieIwK4OpTwKL0TnB9bUQSuLWLdumUOn0LTVwFFkuHXLBiObWl6EbOFtCvl
         rF0YVHrcwLRbi3Bo7PaD++vWZy/piVGYjxl7uZ1loHbX1wH9nWzzrWr+XaFm03hLKZbo
         gfKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QH/ZSRSORcsdTbWbXfRhsvYT/1SoWAirgAvGrjORiCU=;
        b=sJI0Ko5h0PoYxuL8RXK4XVDwZzKaUFc1YKmkFCnU0Z5s23Vv1DN3A7olBGEEqZq+bF
         TJ8e3AgKvPXkCAmH/DhzCF70MdHF+EXZgPCTAid4/uVEBPeMhbnWq3sW4h8yAps1003C
         GdQ7mlrb/inxBmX3QWi0hRKbv7trx5qbp26+vK6Md4POmQY+ZR2QCwthsMF+XkHTOqWJ
         kDePSpbWnC0AxJCqRk+5+RkZNM3Ir3nj5+I3r0qVaXkLL/sSPCRJ2KRyA8DJmQuIAiLa
         96WV0F296yaO34zcEc8TaLD60AVwQoVzkI5jF0SM0wFGTHJEgfGR+0fumPbqbqO9FReY
         BevA==
X-Gm-Message-State: AOAM532vZW5jozn4KVJbC1zw9XBGEZq0GmEdfjziLPvdUOcsj1iaCHn5
        w5Mrfan3LN0LfxndmyroFja7goprXlG2xw==
X-Google-Smtp-Source: ABdhPJx4zTAebVmiYTliQ7jJgCAgPH8hiafcMOZ5Zqv76yyvsaqkhTpZMue3H1cmR/Og4QHvM3UHsw==
X-Received: by 2002:a5d:44d2:: with SMTP id z18mr18260802wrr.26.1614623088586;
        Mon, 01 Mar 2021 10:24:48 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.35])
        by smtp.gmail.com with ESMTPSA id q25sm125146wmq.15.2021.03.01.10.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 10:24:48 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: inline io_req_clean_work()
Date:   Mon,  1 Mar 2021 18:20:46 +0000
Message-Id: <93270e2c3de2afb2a5125ebcb4b1f15bb5cfc44e.1614622683.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614622683.git.asml.silence@gmail.com>
References: <cover.1614622683.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline io_req_clean_work(), less code and easier to analyse
tctx dependencies and refs usage.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 34d0fd4a933b..3d8c99c46127 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1167,22 +1167,6 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 	return false;
 }
 
-static void io_req_clean_work(struct io_kiocb *req)
-{
-	if (req->flags & REQ_F_INFLIGHT) {
-		struct io_ring_ctx *ctx = req->ctx;
-		struct io_uring_task *tctx = req->task->io_uring;
-		unsigned long flags;
-
-		spin_lock_irqsave(&ctx->inflight_lock, flags);
-		list_del(&req->inflight_entry);
-		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
-		req->flags &= ~REQ_F_INFLIGHT;
-		if (atomic_read(&tctx->in_idle))
-			wake_up(&tctx->wait);
-	}
-}
-
 static void io_req_track_inflight(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1671,7 +1655,19 @@ static void io_dismantle_req(struct io_kiocb *req)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
 	if (req->fixed_rsrc_refs)
 		percpu_ref_put(req->fixed_rsrc_refs);
-	io_req_clean_work(req);
+
+	if (req->flags & REQ_F_INFLIGHT) {
+		struct io_ring_ctx *ctx = req->ctx;
+		struct io_uring_task *tctx = req->task->io_uring;
+		unsigned long flags;
+
+		spin_lock_irqsave(&ctx->inflight_lock, flags);
+		list_del(&req->inflight_entry);
+		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
+		req->flags &= ~REQ_F_INFLIGHT;
+		if (atomic_read(&tctx->in_idle))
+			wake_up(&tctx->wait);
+	}
 }
 
 static inline void io_put_task(struct task_struct *task, int nr)
-- 
2.24.0

