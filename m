Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FECA29D566
	for <lists+io-uring@lfdr.de>; Wed, 28 Oct 2020 23:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbgJ1WAh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Oct 2020 18:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729465AbgJ1WAg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Oct 2020 18:00:36 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC513C0613CF
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 15:00:36 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id s7so1097546iol.12
        for <io-uring@vger.kernel.org>; Wed, 28 Oct 2020 15:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=oIiMKyVH7I+11bBb7ij4oT5WaaLdVWTb2tVtmKofqAc=;
        b=A3ic9+qbk2hF99lu50qNUbuo9o0fgKoyGXr+S0XgbGU7HH1DvJMiAlKKKkV63UNskk
         SwbWxTz31a3DPWlj025PI8L+/viYOoSNIGBorHWmWMKBZPyGOrOsbV/9b4hea6+8FGkX
         3TbRnwG3C2/99pVjHEr+ZnE8/GzYy4QR4kyBeOuZCFeuy85VsArycx81Sjm4AqyVmuCB
         dNdzd8DmaEmKxk2IpYn+DkCn/Exl6vi0yZSprorBLadFuqbiov1rZ23nYZogR/0Cbn+I
         lUhZefHY9Tij9/KMSCx9LwCgb2Q8oUoXe9X19/A+vxOkXQQMBXx1ik1Te4aIXWhZXjad
         yIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=oIiMKyVH7I+11bBb7ij4oT5WaaLdVWTb2tVtmKofqAc=;
        b=jH3gJW1Pytn3VAbmLe22EFkVgGF7Mc7SYLhNvWTPdKNeHpk6UXkT/CxeX3u/5RSb30
         VvNpEZ6Ktv9T3HmJRnJd8w/2y+xfFZ6fKj5rln4oafm04UNGaVxhnB1H3i/CGdZd5E3L
         mVwnEzGUOymGFjD1mzlWVm71rCwTubdQyQKi0/9FQIOlt8l05litG9XnAzDHwZKEDEQw
         U8EeudyZFtS6WSrfYhfAsbLjwDNF7vSLaVnmy0z8Ped+EnJfGwF8bwf+CT9IKqcRLuER
         hNr1b79h2p/DiRf7BM3ch4ea+p4LveMW0IRhKxBltlES9eEhHXhdgkdsQGKn23xk/n5z
         J3yw==
X-Gm-Message-State: AOAM532qT58+XLEAik7R+vMk/pNIQQAREnvX5C+7tWEbhjMfJY9dpC9U
        VpEZCuxz2LCx9ZI2zUjEernbfFGIOc4fsg==
X-Google-Smtp-Source: ABdhPJwCM0F3ebmakzxAOxH9YuruySETqFz4ndGZtJrChFe4fuHDG3PboI9UeOS3VWlhFwBo56F//Q==
X-Received: by 2002:a6b:b5c2:: with SMTP id e185mr6399266iof.106.1603897851585;
        Wed, 28 Oct 2020 08:10:51 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b1sm493673iog.14.2020.10.28.08.10.50
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 08:10:50 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: only plug when appropriate
Message-ID: <54b696f3-0808-dbb3-084c-49d3d2d5f888@kernel.dk>
Date:   Wed, 28 Oct 2020 09:10:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We unconditionally call blk_start_plug() when starting the IO
submission, but we only really should do that if we have more than 1
request to submit AND we're potentially dealing with block based storage
underneath. For any other type of request, it's just a waste of time to
do so.

Add a ->plug bit to io_op_def and set it for read/write requests. We
could make this more precise and check the file itself as well, but it
doesn't matter that much and would quickly become more expensive.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3e1774d3187c..60cd740e5e3e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -748,6 +748,8 @@ struct io_submit_state {
 	void			*reqs[IO_IOPOLL_BATCH];
 	unsigned int		free_reqs;
 
+	bool			plug_started;
+
 	/*
 	 * Batch completion logic
 	 */
@@ -780,6 +782,8 @@ struct io_op_def {
 	unsigned		buffer_select : 1;
 	/* must always have async data allocated */
 	unsigned		needs_async_data : 1;
+	/* should block plug */
+	unsigned		plug : 1;
 	/* size of async data needed, if any */
 	unsigned short		async_size;
 	unsigned		work_flags;
@@ -793,6 +797,7 @@ static const struct io_op_def io_op_defs[] = {
 		.pollin			= 1,
 		.buffer_select		= 1,
 		.needs_async_data	= 1,
+		.plug			= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
 	},
@@ -802,6 +807,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.needs_async_data	= 1,
+		.plug			= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG |
 						IO_WQ_WORK_FSIZE,
@@ -814,6 +820,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
+		.plug			= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.work_flags		= IO_WQ_WORK_BLKCG | IO_WQ_WORK_MM,
 	},
@@ -822,6 +829,7 @@ static const struct io_op_def io_op_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
+		.plug			= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.work_flags		= IO_WQ_WORK_BLKCG | IO_WQ_WORK_FSIZE |
 						IO_WQ_WORK_MM,
@@ -905,6 +913,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
+		.plug			= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
 	},
@@ -912,6 +921,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
+		.plug			= 1,
 		.async_size		= sizeof(struct io_async_rw),
 		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG |
 						IO_WQ_WORK_FSIZE,
@@ -6534,7 +6544,8 @@ static void io_submit_state_end(struct io_submit_state *state)
 {
 	if (!list_empty(&state->comp.list))
 		io_submit_flush_completions(&state->comp);
-	blk_finish_plug(&state->plug);
+	if (state->plug_started)
+		blk_finish_plug(&state->plug);
 	io_state_file_put(state);
 	if (state->free_reqs)
 		kmem_cache_free_bulk(req_cachep, state->free_reqs, state->reqs);
@@ -6546,7 +6557,7 @@ static void io_submit_state_end(struct io_submit_state *state)
 static void io_submit_state_start(struct io_submit_state *state,
 				  struct io_ring_ctx *ctx, unsigned int max_ios)
 {
-	blk_start_plug(&state->plug);
+	state->plug_started = false;
 	state->comp.nr = 0;
 	INIT_LIST_HEAD(&state->comp.list);
 	state->comp.ctx = ctx;
@@ -6688,6 +6699,16 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	req->flags |= sqe_flags;
 
+	/*
+	 * Plug now if we have more than 1 IO left after this, and the target
+	 * is potentially a read/write to block based storage.
+	 */
+	if (!state->plug_started && state->ios_left > 1 &&
+	    io_op_defs[req->opcode].plug) {
+		blk_start_plug(&state->plug);
+		state->plug_started = true;
+	}
+
 	if (!io_op_defs[req->opcode].needs_file)
 		return 0;
 
-- 
Jens Axboe

