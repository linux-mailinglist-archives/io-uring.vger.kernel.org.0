Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7B50315AF6
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbhBJATD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234374AbhBJAJO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:09:14 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869ABC06178C
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 16:07:22 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id 190so326164wmz.0
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QRbs/KONpvPOK19fFxSmpi8or+GtUrkcedGN7ZxP2kM=;
        b=OrhcVL7v1D/efDe3DylMfoun7RsN6x10JYp5IjchoOxmPMPGDnPM8ytLErVQZD2HMH
         sgnDmALyg34zam+DELM2wSKQ5II10k6Dp2v0qjtAQg3i7WZ85QyDTvF4bzKYWhMs7bSp
         kkbSetSsrKoLMvYl+dQ1xumqeA4RVMlq6NoIlZqS0bsR7MydGt5Hu8EkSgbV718gKm8C
         ozTX7uOp/g/b/ivsITiRzf7sh2kNxWXopP8RoxBdN38ehSArmu1CaA5uDvZqMghgTaDj
         ojvCUaTvD+iBi2AQemJg+/oYugNlfIzHiav5kDUl8WifCOAUyuVo7aPqEWIkpNAoUwem
         5Wcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QRbs/KONpvPOK19fFxSmpi8or+GtUrkcedGN7ZxP2kM=;
        b=Bqne1jPISmwFpX8aHlbQvTYyKYrlL7an5GIBlIR3AOkGkvBX0OvaXTttc4IE0otI7H
         5fodU4z6xsjM3vDsHHOzBIg0mXf4ajmLLkdwpf/0qIJCyP+DHPGAlo8xqAA5X7N8YO5u
         Rf3+DJ2WtqeSbCQw/VuFHxTN6VokgUBHF7DrwZslmdYKUhGrZ83aZmd9+1+keYuSdLMV
         eqldwLHF7x8AT2s6PdVKnWBHQVdSZTPq6u8pzKYMYYaBjB3arM12wesCgbH7RUKwocZg
         bvJh2k32W+scJHuftPuj5pY7JD/Lz75kqeSSTNJXWb65SUt/etFVgrBDGn62isjXO+k7
         /p+w==
X-Gm-Message-State: AOAM530MSeHkUt+HBp8zfefVJcgxOVUWh1K+z6jJm+sbGeAu678yXdEB
        n28aQ8YXlJCz0oy5UQ5BjAiXHl5jIphnhA==
X-Google-Smtp-Source: ABdhPJzPF06tINVV5zbQzEyeQHMcw1S7W1CPNV0aqgphdPe/p+CFGBI/UHOjXSJ8t//zJ2wlWU4XIw==
X-Received: by 2002:a1c:730a:: with SMTP id d10mr448752wmb.53.1612915640985;
        Tue, 09 Feb 2021 16:07:20 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id n15sm391082wrx.2.2021.02.09.16.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:07:20 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/17] io_uring: don't reinit submit state every time
Date:   Wed, 10 Feb 2021 00:03:12 +0000
Message-Id: <981dd2c55f41829a34231ef9367790b047da60dd.1612915326.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612915326.git.asml.silence@gmail.com>
References: <cover.1612915326.git.asml.silence@gmail.com>
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
index f0cc5ccd6fe4..7076564aa944 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1294,6 +1294,7 @@ static inline bool io_is_timeout_noseq(struct io_kiocb *req)
 
 static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 {
+	struct io_submit_state *submit_state;
 	struct io_ring_ctx *ctx;
 	int hash_bits;
 
@@ -1345,6 +1346,12 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
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
@@ -6667,8 +6674,10 @@ static void io_submit_state_end(struct io_submit_state *state,
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
@@ -6678,10 +6687,6 @@ static void io_submit_state_start(struct io_submit_state *state,
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

