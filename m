Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5B932E0A1
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 05:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhCEEWb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 23:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhCEEWa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 23:22:30 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E035C061756
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 20:22:30 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id l22so247862wme.1
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 20:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=lXsZWbZumpLafjqAflHLK0S+rZDW2v8OYuP2o4QqPPw=;
        b=fUpenWzeQWB66uknsevh4fVWbbO4L4V+y6qLJy3BWRiPskq7AOXg/q5ACe4TvhTDKI
         k0lIfwuJdgsvsGgPbOCfDQkP7rLDaoIZQ3f7nM1RTgy1sVSqIou0/hg8gKNtAqwZBtRv
         R49rZUyr7KJv4hsY8AEunGQfXlVOZatcyHh3lQb1BL6hqtpyKDozhTLMkHr7WEm+/kFo
         1Bc/1svmbM0a2FdGQXz21hDvIE5+iiZGJA2sAzWm3bu5fxcRfvI5CRQrgQpi+Zpw8/mV
         PzO2LhXqus0eo2Gi6Cxi6lwQd6EdlWpG8PR6tbZKeSnzmy4/slfU2wGjsUfbOvjLjePI
         rfDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lXsZWbZumpLafjqAflHLK0S+rZDW2v8OYuP2o4QqPPw=;
        b=U/V+xjBf3/IH4W2KhyAeVEuObhfH81eDbdVrQDFM6Cnk+mO5xH4Rd7cq4a37rqcadz
         SJnRu9PCm0lFpC3c/wJvkFrEufp41UUKPKdkDKhHA8P3cpVrJ+kRY700EBvmAW1w619J
         hUoF8uY4ldFyJdPcDjXI8ax/wUPQ/zuf66qakcpk9EqPPKCZwErou6nzribQnDXPzKX8
         r/mPd9eSRi84sWgCMXMSBL6l1pNXEzZqTcZ2AMpAslr7xqRMmhwi/4zx7wtdlzRLmnSS
         faL34Hm1TS/E4w7CxzUg1dD6w/LXyKLVb51DvhWkvJ6xYcZ8x+rtE9edSt1fJly2zAWQ
         li/Q==
X-Gm-Message-State: AOAM532aakM19gV4f38gGZU0MsbWkYBvNuDWP25BBOb2iqu5VyNYcTUl
        DQZkm7AQJK+kg9Lqq/5SpFFym5cPw0b5rQ==
X-Google-Smtp-Source: ABdhPJwEFuG7YFqsoh39aDu+EoMLKgmJ1Yn7FAkmpqpbtnEpzLpT3/ol3yViYZVk0fyPikVnpbrn2A==
X-Received: by 2002:a1c:7901:: with SMTP id l1mr6882631wme.114.1614918149361;
        Thu, 04 Mar 2021 20:22:29 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id z3sm2170446wrs.55.2021.03.04.20.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 20:22:29 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 6/6] io_uring: warn when ring exit takes too long
Date:   Fri,  5 Mar 2021 04:18:24 +0000
Message-Id: <8be1cb441112f568fcc371ad7a4fe23223ac82f1.1614917790.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614917790.git.asml.silence@gmail.com>
References: <cover.1614917790.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We use system_unbound_wq to run io_ring_exit_work(), so it's hard to
monitor whether removal hang or not. Add WARN_ONCE to catch hangs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 92ba3034de64..623563b817f7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8554,6 +8554,8 @@ static void io_ring_exit_work(struct work_struct *work)
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
 	struct io_tctx_exit exit;
 	struct io_tctx_node *node;
+	const u64 bias_ms = MSEC_PER_SEC * 60 * 5;
+	ktime_t start = ktime_get();
 	int ret;
 
 	/*
@@ -8564,10 +8566,13 @@ static void io_ring_exit_work(struct work_struct *work)
 	 */
 	do {
 		io_uring_try_cancel_requests(ctx, NULL, NULL);
+		WARN_ON_ONCE(ktime_ms_delta(ktime_get(), start) > bias_ms);
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 
 	mutex_lock(&ctx->uring_lock);
 	while (!list_empty(&ctx->tctx_list)) {
+		WARN_ON_ONCE(ktime_ms_delta(ktime_get(), start) > bias_ms);
+
 		node = list_first_entry(&ctx->tctx_list, struct io_tctx_node,
 					ctx_node);
 		exit.ctx = ctx;
-- 
2.24.0

