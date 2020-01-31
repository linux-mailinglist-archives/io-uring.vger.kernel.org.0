Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 511E314F468
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 23:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgAaWQy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 17:16:54 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50232 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgAaWQx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 17:16:53 -0500
Received: by mail-wm1-f68.google.com with SMTP id a5so9717326wmb.0;
        Fri, 31 Jan 2020 14:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=lu2Xiqkgl7J684IcpCrQ+v+PneCC7C7asFHx4scTo3E=;
        b=dytORbb7Xshs033UjFtE7RlqC1iKKTi2e/fwlvR6I2EH0YSd3SkL4+5ZnDbJf7oWWT
         6ZJ5MiAlVvcufc3wPJQkll0J6qmcL+GaExssFd7RoZqo1XfhnpmMcmndbAm3PX9VzdAU
         8xzbOLRCGaAzrqG3I2v3so/Ikn0sA69mjajFCmpHQPg0WdP2nixcfQypC2pxDSLUw/jb
         hlOvhfDQtj3UHxwxdUY15OERQ8P1u2a5FovDapFeJdS0v6LiXZdeFM00dLlcNGTvLN2O
         HJn2zNAbglFmjaccrqjmnbEpWTYS/PwYZIFH42RrY/O5Xl3vELyiKnwPgbm99RZG/hoI
         WLPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lu2Xiqkgl7J684IcpCrQ+v+PneCC7C7asFHx4scTo3E=;
        b=LDwQGRvyIpGFCMJ+FyM75Xg4Q+Amo/tNLIsdxtfwQa0d2dIiFb6X8NJj0aJm6n1tNm
         mF0jFPKPFI8K3XlM6CVLJW7py3OjyjHHFx8k+M2sq/2HzQus5G8psVV2FtO/ekwpecPZ
         MnTngGpIac6dkSbMHirJqvll/yl3tfzTVEDIZScR/LgHlTMyUGySYqcXx82RQ5FC6Q0V
         98oYBxnGjWoFFiWx+TjRl3ARboJ/sxKugMe374GwecmcDFMExWFG8RB1IVOasA6UyGpV
         iqR5H0KcMOIgsO9+nKfgeLmS0Jl0g8RgVDkrUVgpv+7tJ3l9PZp/EocIfxg2856bpcQ5
         y3EQ==
X-Gm-Message-State: APjAAAXw1UgK+/gesa7KN2sf1teUPbfHzSl/jpt9Zvdoac1tMsea+Gin
        S+4BgqfT4aBSqWMIrTS0ld0=
X-Google-Smtp-Source: APXvYqz9nFroN0Ret7EFrVnUJyYuLdYHM0Yofn4m4GGu0rHemZamj4MFBDlLpWFwi94sTscfB0yPbQ==
X-Received: by 2002:a05:600c:291d:: with SMTP id i29mr14816183wmd.39.1580509011041;
        Fri, 31 Jan 2020 14:16:51 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id e6sm12328001wme.3.2020.01.31.14.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 14:16:50 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/6] io_uring: persistent req bulk allocation cache
Date:   Sat,  1 Feb 2020 01:15:54 +0300
Message-Id: <47dbf2f0f521cc286d0657e337e5fd9fa0a1e4ec.1580508735.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1580508735.git.asml.silence@gmail.com>
References: <cover.1580508735.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Save bulk allocated requests across io_uring_enter(), so lower QD also
could benefit from that. This is not much of an optimisation, and for
current cache sizes would probably affect only offloaded ~QD=1.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cbe639caa096..66742d5772fa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -845,6 +845,23 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	return NULL;
 }
 
+static void io_init_submit_state(struct io_ring_ctx *ctx)
+{
+	struct io_submit_state *state = &ctx->submit_state;
+
+	state->free_reqs = 0;
+	state->cur_req = 0;
+}
+
+static void io_clear_submit_state(struct io_ring_ctx *ctx)
+{
+	struct io_submit_state *state = &ctx->submit_state;
+
+	if (state->free_reqs)
+		kmem_cache_free_bulk(req_cachep, state->free_reqs,
+					&state->reqs[state->cur_req]);
+}
+
 static inline bool __req_need_defer(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1171,10 +1188,9 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx)
 	struct io_submit_state *state = &ctx->submit_state;
 
 	if (!state->free_reqs) {
-		size_t sz;
+		size_t sz = ARRAY_SIZE(state->reqs);
 		int ret;
 
-		sz = min_t(size_t, state->ios_left, ARRAY_SIZE(state->reqs));
 		ret = kmem_cache_alloc_bulk(req_cachep, gfp, sz, state->reqs);
 
 		/*
@@ -4835,9 +4851,6 @@ static void io_submit_end(struct io_ring_ctx *ctx)
 	struct io_submit_state *state = &ctx->submit_state;
 
 	io_file_put(state);
-	if (state->free_reqs)
-		kmem_cache_free_bulk(req_cachep, state->free_reqs,
-					&state->reqs[state->cur_req]);
 	if (state->link)
 		io_queue_link_head(state->link);
 }
@@ -4850,7 +4863,6 @@ static void io_submit_start(struct io_ring_ctx *ctx, unsigned int max_ios,
 {
 	struct io_submit_state *state = &ctx->submit_state;
 
-	state->free_reqs = 0;
 	state->file = NULL;
 	state->ios_left = max_ios;
 
@@ -6247,6 +6259,8 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	if (ctx->sqo_mm)
 		mmdrop(ctx->sqo_mm);
 
+	io_clear_submit_state(ctx);
+
 	io_iopoll_reap_events(ctx);
 	io_sqe_buffer_unregister(ctx);
 	io_sqe_files_unregister(ctx);
@@ -6767,6 +6781,8 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 	if (ret)
 		goto err;
 
+	io_init_submit_state(ctx);
+
 	ret = io_sq_offload_start(ctx, p);
 	if (ret)
 		goto err;
-- 
2.24.0

