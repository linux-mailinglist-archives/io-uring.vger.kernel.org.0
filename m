Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C521634234F
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 18:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhCSR1H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 13:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbhCSR06 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 13:26:58 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A56C06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:26:58 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id b2-20020a7bc2420000b029010be1081172so5662580wmj.1
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=M90rq9T8X/Y+9EWDAXBn2+/aYL+3nX5w7olnhJyqtAQ=;
        b=pr/KeCl7zi4pYBQQHti8HMgXLZ9djULl7PjsVzaoKq5DSXHtyw6F9WVS5ZC6g8T6EP
         q27pyzXgo5jWl4Zd+u/lE9nDIv+EWUpJKM7wepzoiJodlF1TUSPYF9LJosy9B1hmaY2r
         4/iP/5vq+HI8xRmFYFhl67qTAI5quazS1L7n3tr7jD27mklwyKOmoqEDK/p+W3xKeA1a
         4R4CV2nrJFSQgFaWXY2zHZhoco9iTe/E57omQ/xcGDf57V9l4j/DCp2E75UJnrZByQeF
         zyjnstUK7UtkTGcp2PTmvhs5diZuDOXcGfce597Kk9ArpBjMK9YSLViyCBxHUtupTUUA
         vLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M90rq9T8X/Y+9EWDAXBn2+/aYL+3nX5w7olnhJyqtAQ=;
        b=jw9WT3FXqGr+ra31hwLF2FShVvKDL6rPLpKPxgTCjRC9UInUzpki8ziapNlfh5mRw+
         qsAM06inIuWKJ3JLXNi0pLiee00lmYOlsob4WlBm6d1DJEea31JDjeOcxe25wcSdp2QC
         KophK7FlvJ76NKJC8BBrFGrMKwD6wWd46qkyUTxwpS2kYV7g1pSFqdtloCbq9f/dTTjD
         nNA9F+o3jcu1EsYoUBb2r7xG/RCUVbIbpqUFWg0CsbaS+RDPjP6AgfN2K+N1fvi1QxXU
         Mf1/6gHghLqv+4fDoOt6UTP2Xz1AM3Bw1lkAZcY4rc0Rl8KCJ0Esjq8DQeg2rYEtkeQi
         4aXw==
X-Gm-Message-State: AOAM533BmeyOR4idOJRwujAOzSG4HFcBsoGoNxenj6aWnzCmQofGBx25
        5aPlqeCTkUWB5va46TPHhys=
X-Google-Smtp-Source: ABdhPJy0xezx9lxwh2lr2CLWqQNvAflVjGloY5ZvMsVHXgIHRRTKFiG+HYQENpg3SIXm50zvocvAGw==
X-Received: by 2002:a05:600c:614:: with SMTP id o20mr4603617wmm.66.1616174816983;
        Fri, 19 Mar 2021 10:26:56 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id i8sm7112943wmi.6.2021.03.19.10.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 10:26:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/16] io_uring: refactor io_flush_cached_reqs()
Date:   Fri, 19 Mar 2021 17:22:35 +0000
Message-Id: <b09223872634c5de15a1701df99898d217839594.1616167719.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616167719.git.asml.silence@gmail.com>
References: <cover.1616167719.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Emphasize that return value of io_flush_cached_reqs() depends on number
of requests in the cache. It looks nicer and might help tools from
false-negative analyses.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c29f96e3111d..e4c92498a0af 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1647,11 +1647,12 @@ static void io_req_complete_failed(struct io_kiocb *req, long res)
 	io_req_complete_post(req, res, 0);
 }
 
+/* Returns true IFF there are requests in the cache */
 static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 	struct io_comp_state *cs = &state->comp;
-	struct io_kiocb *req = NULL;
+	int nr;
 
 	/*
 	 * If we have more than a batch's worth of requests in our IRQ side
@@ -1665,16 +1666,19 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 		spin_unlock_irq(&ctx->completion_lock);
 	}
 
+	nr = state->free_reqs;
 	while (!list_empty(&cs->free_list)) {
-		req = list_first_entry(&cs->free_list, struct io_kiocb,
-					compl.list);
+		struct io_kiocb *req = list_first_entry(&cs->free_list,
+						struct io_kiocb, compl.list);
+
 		list_del(&req->compl.list);
-		state->reqs[state->free_reqs++] = req;
-		if (state->free_reqs == ARRAY_SIZE(state->reqs))
+		state->reqs[nr++] = req;
+		if (nr == ARRAY_SIZE(state->reqs))
 			break;
 	}
 
-	return req != NULL;
+	state->free_reqs = nr;
+	return nr != 0;
 }
 
 static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
-- 
2.24.0

