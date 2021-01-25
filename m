Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BBB3024BB
	for <lists+io-uring@lfdr.de>; Mon, 25 Jan 2021 13:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbhAYMM1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jan 2021 07:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbhAYMKU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 07:10:20 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755A7C0611C2
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 03:46:19 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id 6so12044547wri.3
        for <io-uring@vger.kernel.org>; Mon, 25 Jan 2021 03:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=jkdARpvwgW6N1HyOGAj26/H0wiqdeffUL78JhEUYqao=;
        b=X4Ye8V6HjNZEX9f8c5Qeisks2vXJQy5/o17pGSmPnp0rHg1oHlAmVRRut1gmAvwgpP
         wgpNjxiqfWgoYS9YoI4tTOGXaF0Nb5+zIsCBs76KNlFmIOhr9OT5PyKKhTrytNdjm7sr
         bN56Zg8QVGhSaCp1FJhB6YKpoPfJPIzUts18QnA9v4PadJ8Q6hWUVradZ738lTdRZBlW
         BViFOfd6XDvP8VIJEVezkrOvD8Vfzef6kQUv9LNGckkUeAsFfLy+B7qKHP6NWsrR9txM
         sq2xDZTaJIskn09Vrocavb68WGhcnR+/jc5a16wlYyE/7OgteBntM8Mj2Jn8gwbNSLL6
         XwTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jkdARpvwgW6N1HyOGAj26/H0wiqdeffUL78JhEUYqao=;
        b=sFJPnMsmATBPjL8D6MwtcO6Wk18vtDkm/MadC+1FDUzNZVC7D/YXI4K0OV6KoQPhpD
         iBZPxQseOA+lWMBsLo58E5Au5zPt092UCUtuyOS4R+ATdGrCOXSCq55WrlB0/U2snsTz
         1tXguhciy3+n2hpIklf5RO0rknxw1+xwQSxScdvM3pig3fNG2JypEtyHNgHADm97GGPc
         FiGP3bVbqbNmnsyWft6Wo43FbXC5ddeRqXf+SADtC+nbcT1976ncrmG+hfrzn6NOItGj
         EOb3oN1BOr0z5sUEcpACTBbI9UfXcazOBtr6ADRp8ejAg2sExD+74j+E6j4em0Fm/1BF
         KjsA==
X-Gm-Message-State: AOAM530r/MyqM60P1tKMki2Va+Cl+SXwTEXHw3bYrxnZQskwAsN1A9jx
        7wDF0ebE8sGiRXOfmni/LJE=
X-Google-Smtp-Source: ABdhPJzmLMv44gl6EzAACJfbf/OrKuNii+WXuIpCQ7IdaETbtRKE0kP4exBtz2r0hp8GTJSJ9VkcrQ==
X-Received: by 2002:a5d:560c:: with SMTP id l12mr436194wrv.417.1611575178295;
        Mon, 25 Jan 2021 03:46:18 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.11])
        by smtp.gmail.com with ESMTPSA id a6sm12571433wru.66.2021.01.25.03.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 03:46:17 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/8] io_uring: don't reinit submit state every time
Date:   Mon, 25 Jan 2021 11:42:24 +0000
Message-Id: <e717707a7e971590ba6517e961819eca060bb3a9.1611573970.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611573970.git.asml.silence@gmail.com>
References: <cover.1611573970.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As now submit_state is retained across syscalls, we can save ourself
from initialising it from ground up for each io_submit_sqes(). Set some
fields during ctx allocation, and just keep them always consistent.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7d811cf0c27b..08d0c8b60c2a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1284,6 +1284,7 @@ static inline bool io_is_timeout_noseq(struct io_kiocb *req)
 
 static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 {
+	struct io_submit_state *submit_state;
 	struct io_ring_ctx *ctx;
 	int hash_bits;
 
@@ -1335,6 +1336,12 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
 	init_llist_head(&ctx->rsrc_put_llist);
+
+	submit_state = &ctx->submit_state;
+	INIT_LIST_HEAD(&submit_state->comp.list);
+	submit_state->comp.nr = 0;
+	submit_state->file_refs = 0;
+	submit_state->free_reqs = 0;
 	return ctx;
 err:
 	if (ctx->fallback_req)
@@ -6703,8 +6710,10 @@ static void io_submit_state_end(struct io_submit_state *state,
 	if (state->plug_started)
 		blk_finish_plug(&state->plug);
 	io_state_file_put(state);
-	if (state->free_reqs)
+	if (state->free_reqs) {
 		kmem_cache_free_bulk(req_cachep, state->free_reqs, state->reqs);
+		state->free_reqs = 0;
+	}
 }
 
 /*
@@ -6714,10 +6723,6 @@ static void io_submit_state_start(struct io_submit_state *state,
 				  unsigned int max_ios)
 {
 	state->plug_started = false;
-	state->comp.nr = 0;
-	INIT_LIST_HEAD(&state->comp.list);
-	state->free_reqs = 0;
-	state->file_refs = 0;
 	state->ios_left = max_ios;
 }
 
-- 
2.24.0

