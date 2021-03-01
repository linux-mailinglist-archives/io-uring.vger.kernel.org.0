Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69F8328B2C
	for <lists+io-uring@lfdr.de>; Mon,  1 Mar 2021 19:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239814AbhCAS3z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Mar 2021 13:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239854AbhCAS1Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Mar 2021 13:27:16 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1E2C0617AA
        for <io-uring@vger.kernel.org>; Mon,  1 Mar 2021 10:24:51 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id n4so158146wmq.3
        for <io-uring@vger.kernel.org>; Mon, 01 Mar 2021 10:24:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=4Z+Sd0Zti0Hp79FYi9p0x5GGPq9frrpGunjs66QWsYk=;
        b=GRjOPUPrqPhfCaYiGrRGuk4J6vih80RCBu0WYHKCFCYUR9vRbVsk3nxk/RhQMcrUBE
         qHN9DGLjfG07A3WXC/8CiWQ7YFJqQM0J612qoViqsbF6RbvBGXeQMfjkGxY7zzUElpcA
         dxw9vRjFmo514NBdXsV5L1DCWfQTDmlgfiBKvys82A7vn/OFTMrtRW++SDmGzcrMmu9A
         Q5bbS0fe8Nz4eh54EwWW0EX4KDMIkxuN5TJS6Ps8fo9/AOGcWAP0VCRRe6QeBkinHq1q
         46uyn82vsV6JRH2Yt+wR+v52VSxzxtJajRRezyPzt+M7XeQPhcOH1xDRwEBVVFKs1YY0
         8CGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Z+Sd0Zti0Hp79FYi9p0x5GGPq9frrpGunjs66QWsYk=;
        b=soYwM9Knx1Artke21gH5NN+1tALkNz8h2T43ExSp+/IIUtgGmcsVfxjTHZQWyM+Tdo
         3E48EVM41vH1aC+JdAGSbVIanSQ1qeJcN6Hb//Oez5gJ68nDVUiyzFeSCazA2cx+vwb3
         dufXZf/+UKXSf1yFuN7Qq+UGvKwbUVj5Pi1wrhSvn06LnD4czmN3NyhQ68pvrF6ZzyqI
         Q13CxLV6uP35YYjMJJ5M6UFCGHWff2WUWtTisDGOXP9eH8N/oE3E6KHtM3g2YxA39t8L
         VfiCtRHBFNrQajoU8fd2zbvqT8kRc6ZkieanGJRfCH1P3y6quvFyR8mzRHDYeRM8hdmW
         md1Q==
X-Gm-Message-State: AOAM533C46l+KEbZyNuleFzNl2WXQhHDGvZ9Lr4CHE5GCZi8RdshMWus
        qw1WB9UfzL/JuUR0qYQbeP4=
X-Google-Smtp-Source: ABdhPJzzOTNT47vbPVynsfuXMnhk7mo5ZFDOU4exkulQGXSDQEuRCvUNOqSXOXXQ08wwO9drxsFxOw==
X-Received: by 2002:a1c:b70b:: with SMTP id h11mr210907wmf.10.1614623090398;
        Mon, 01 Mar 2021 10:24:50 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.35])
        by smtp.gmail.com with ESMTPSA id q25sm125146wmq.15.2021.03.01.10.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 10:24:50 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/4] io_uring: remove extra in_idle wake up
Date:   Mon,  1 Mar 2021 18:20:48 +0000
Message-Id: <ec4616bacc4f4928eb34fe64ef162978eacbd62f.1614622683.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614622683.git.asml.silence@gmail.com>
References: <cover.1614622683.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_dismantle_req() is always followed by io_put_task(), which already do
proper in_idle wake ups, so we can skip waking the owner task in
io_dismantle_req(). The rules are simpler now, do io_put_task() shortly
after ending a request, and it will be fine.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 411323dc43bb..e9215477426d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1649,18 +1649,16 @@ static void io_dismantle_req(struct io_kiocb *req)
 
 	if (req->flags & REQ_F_INFLIGHT) {
 		struct io_ring_ctx *ctx = req->ctx;
-		struct io_uring_task *tctx = req->task->io_uring;
 		unsigned long flags;
 
 		spin_lock_irqsave(&ctx->inflight_lock, flags);
 		list_del(&req->inflight_entry);
 		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 		req->flags &= ~REQ_F_INFLIGHT;
-		if (atomic_read(&tctx->in_idle))
-			wake_up(&tctx->wait);
 	}
 }
 
+/* must to be called somewhat shortly after putting a request */
 static inline void io_put_task(struct task_struct *task, int nr)
 {
 	struct io_uring_task *tctx = task->io_uring;
-- 
2.24.0

