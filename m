Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7F532D4DB
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 15:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236607AbhCDOFK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 09:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239240AbhCDOE4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 09:04:56 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395F0C0613D9
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 06:03:45 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id f12so23978482wrx.8
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 06:03:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3RExKED1jReMHq/CPctwjQBKJwIGLaSgZ5tfX7nl8Co=;
        b=XXE1WeWylAtNzgo2avolp0QrjZ+j5WP3W2dLpeZQdD9+Gk+dhVrpm7IVQZpvAd9GYu
         8+PNEeN5v/66VJu+gNbrfo/BYHNPCKZ93v5PRIMCxndHqQlJRuTJXHKCZkJUrVyxmPon
         wTf0OXYZGz33gZd9GyXZtWR/5pVmT9/sycOAwLUvDoNiMN3QeVWLI87xksybuCpy318m
         +ydv+yt2gbASM65gePyZgvR1FlTWPth5mAjpKNhGWb/RM+ZsYljrsPctw9Qb4rYoxnIQ
         AlIGiuxhHsM5Z+PIDKg0XlaKZrzUu3dFLLEb2sDsBpnZ+25BC1JhHLQ1lIexkjI7w+mr
         g1dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3RExKED1jReMHq/CPctwjQBKJwIGLaSgZ5tfX7nl8Co=;
        b=htT7/etrDRPb2qT2it0GaKRxO/nCAJiubleHVaioJ/icyIPinZguBf/PWrRIZxHvI4
         2zD92weryKqc4EAJ0O5KBBUwBFgK+3FGgt/j6DOuMm7kaeVHkRbSBlCvA0VSRC1e9Gku
         gqmb11ZlbnJuakAPAh7ybPZhF9nxxyws3ZEw3WUhTyjBppPMECsetgdWem8Zm0pUXtld
         6LUjWwUu2wS66rLnFn7s4EI46eY6Q3q2y9F9ii017+iix48bG08DX8W0Pf88OBuVkTHY
         8zE8FXZRQ4MW+M7Xo8optaVJAhv3uDpQWHn23uS9bAYsVIFNfNbQrZmZowLGYOyQUFgW
         hrHA==
X-Gm-Message-State: AOAM53377QW8Z2glFMqsg+QwKkKySnsvRXPlqoF4HsIv1o+UVgqDicgo
        flCR9Evs82keVNImv/YYupQ=
X-Google-Smtp-Source: ABdhPJwBmbTRy/NOQwt0zrXs8/4R7uXPGWt2JMEoNVwlQzcdNdvLloeIU+r554dm3Mf7GdtIEO54bw==
X-Received: by 2002:a05:6000:1803:: with SMTP id m3mr3793933wrh.50.1614866624036;
        Thu, 04 Mar 2021 06:03:44 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id o124sm9975488wmo.41.2021.03.04.06.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 06:03:42 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 8/8] io_uring: warn when ring exit takes too long
Date:   Thu,  4 Mar 2021 13:59:31 +0000
Message-Id: <4bc9b29f2f5b7952b313be604f43b131a2dfe277.1614866085.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614866085.git.asml.silence@gmail.com>
References: <cover.1614866085.git.asml.silence@gmail.com>
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
index 46a2417187ff..b4820f6261fe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8547,6 +8547,8 @@ static void io_ring_exit_work(struct work_struct *work)
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
 	struct io_tctx_exit exit;
 	struct io_tctx_node *node;
+	const u64 bias_ms = MSEC_PER_SEC * 60 * 5;
+	ktime_t start = ktime_get();
 	int ret;
 
 	/*
@@ -8557,10 +8559,13 @@ static void io_ring_exit_work(struct work_struct *work)
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

