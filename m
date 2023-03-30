Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9876D0B62
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 18:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbjC3QeB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 12:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbjC3QeA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 12:34:00 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9371CC38
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 09:33:52 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id m22so8525172ioy.4
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 09:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680194032; x=1682786032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gMKbBw49Mq7WbeToaiSEUPjXYdnrYL8MkWB934evIf4=;
        b=Y7iQw3C0VRJ0X3PGJ3TMy2FTszgLdz7MJ7rgThLCuuTzbleQjMV8U2a04C9LrA/BHr
         zzP1CidwH66nsyZLV5doTsVEbO7DMfzfUEjsfKoMghS42GXrFjvealEIzLdSPb/Y0ZjL
         FcztdQpL7WpSJp0kybNx5HiDVcFMhcEYko0tNy6TWXE8qa/YH6AXQ3ZhXF2tKCq4O7Y0
         64jPzGj1FAGX9L8QueESuVJV1yo58UvcqcwbgRllB+RzK7LSgLJIX4/iKSFpOXx3oQ5n
         HhDelG8mmiPNgwg0lLkTRsDVgECkC03J0mTCSatNn0nTMkRCxelMSrqOAbprIuUuZOCw
         6lzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680194032; x=1682786032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gMKbBw49Mq7WbeToaiSEUPjXYdnrYL8MkWB934evIf4=;
        b=bRK7NQVXc3xzrz3OMC0gm82Pve+6VXIdqCTyofxM2v6LtbDJuNQqIzZrrL7m4z12Xy
         kIXEenNkZgnVIwMcX4dVDfj9Ck0wx1Ed+7WsCifDjt/ADszhZGZES3uiwQ+XeWuTfjDP
         U8y7S40P7sWC6U9HS1zTzSrEgiCRVEWQp1OpzfepMC3OYJP5nEGCFh6kzZrVCxKyq0rQ
         AOxi7u9IL8EzwumEWYT/ZlSikqNN8XFcB/uxiopx+JTYUHPZiyY6e4VYHpgarB5Uo0Vb
         aw4IpfCBB+Rf3gXdFr0S+ChF8NDVCTQF14gkOUIwO/HoUnBh3COxxXz2isLaUQ+8ru9p
         EOrA==
X-Gm-Message-State: AO0yUKUzeJoRsgqnY7/jEj2qMVnV8d7n5STvWHnWKQk3zej24NnZ8Dgn
        vByzukQ03QhMfXg1UdeVpWtP/kYvWmdl5y67Sm4yiQ==
X-Google-Smtp-Source: AK7set8kGaRGBXSgFQUvV4nvNdI03EsCckyfw3kqsLweCb9Y2Ux7ttZefm/uJYtCHyPdKfglE8bFaw==
X-Received: by 2002:a05:6602:72c:b0:719:6a2:99d8 with SMTP id g12-20020a056602072c00b0071906a299d8mr10476924iox.0.1680194031888;
        Thu, 30 Mar 2023 09:33:51 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h21-20020a056638339500b003ff471861a4sm19099jav.90.2023.03.30.09.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 09:33:51 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: get rid of io_preinit_req()
Date:   Thu, 30 Mar 2023 10:33:47 -0600
Message-Id: <20230330163347.1645578-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230330163347.1645578-1-axboe@kernel.dk>
References: <20230330163347.1645578-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just assign where we setup the ring anyway, splitting the init into
two doesn't really buy us anything and it's a bit more fragile. With
this, io_init_req() handles the whole thing while the cacheline is
pulled in anyway.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a0b64831c455..7f5d0b833955 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1034,19 +1034,6 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res)
 	io_req_complete_defer(req);
 }
 
-/*
- * Don't initialise the fields below on every allocation, but do that in
- * advance and keep them valid across allocations.
- */
-static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
-{
-	req->ctx = ctx;
-	req->link = NULL;
-	req->async_data = NULL;
-	/* not necessary, but safer to zero */
-	req->cqe.res = 0;
-}
-
 static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
 					struct io_submit_state *state)
 {
@@ -1097,7 +1084,6 @@ __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 	for (i = 0; i < ret; i++) {
 		struct io_kiocb *req = reqs[i];
 
-		io_preinit_req(req, ctx);
 		io_req_add_to_cache(req, ctx);
 	}
 	return true;
@@ -2172,14 +2158,17 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	int personality;
 	u8 opcode;
 
-	/* req is partially pre-initialised, see io_preinit_req() */
 	req->opcode = opcode = READ_ONCE(sqe->opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	req->flags = sqe_flags = READ_ONCE(sqe->flags);
 	req->cqe.user_data = READ_ONCE(sqe->user_data);
+	req->cqe.res = 0;
+	req->ctx = ctx;
 	req->file = NULL;
 	req->rsrc_node = NULL;
 	req->task = current;
+	req->async_data = NULL;
+	req->link = NULL;
 
 	if (unlikely(opcode >= IORING_OP_LAST)) {
 		req->opcode = 0;
-- 
2.39.2

