Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29CF33A8EB
	for <lists+io-uring@lfdr.de>; Mon, 15 Mar 2021 00:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhCNXr7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 14 Mar 2021 19:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhCNXrb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 14 Mar 2021 19:47:31 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E72EC061574
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 16:47:31 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id k8so4816955wrc.3
        for <io-uring@vger.kernel.org>; Sun, 14 Mar 2021 16:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/LQbwsYwof56kIi4XTKfN7sS9l9Ytv7K/0rgi65PQyE=;
        b=scs33diLTqL3vbpMRHLRNhQONstkwdJJuUNU5PP49sck5isrv9oFDwDKZBYCztyb1o
         mQuTOvnBKKFWPQWVgO0hDZZ14CIF9arJUyznXiZ2dLEa/sEOLsTV6BVQZbRLkHCgcyl5
         DWV6WpSLXlgrMkUiEbDif+ElIRRgYEpi7yvm7KE6k2eGay3j8AWk74IuCZtJ41kB6rYf
         Il5ktXDv7NZ40lIZx9QY0efJPUDYnhWmPGAEsWP8W6YIh6k1GhDpNR9nuej/U6094HXg
         wQsp4HL5HnceK7Nw2FYNo4JVAewH0yArWjTWViZKnJj+zrVzSs+SK7JLVf9UIdMvsfWa
         KBqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/LQbwsYwof56kIi4XTKfN7sS9l9Ytv7K/0rgi65PQyE=;
        b=GwFHgWl+ggUAnM83essvc8ndVjzkSBol/Q65Gjd5NA05Sj7qqbOh8KCgssDx+I7x1T
         bP/MPGGgT6+w8cl2ufDPP5PFsfZ5xBfglCN/dxw52xLvaNZDLF6F+wlHrcKwLfeii6pG
         tjITn5c04tqCZiCbtojB9jOuZUc9J3/d18E5tJPoWnewUCvCARFvbCUoePqE4Av4rp/S
         Xo43iQ8M8IT+WeJAz+osial8Xle57ibmypjT7WwglHt8i7sghaY4yYhA8JRdbjWAWOQA
         bB3V9L56n8mVXtAknUXeGKDVF7oFh9qXiAj4GR2NutohTOh2tc4snO490lgp+iX+0Slq
         HJtA==
X-Gm-Message-State: AOAM530ol92CMBpWj7LMhDwHG0zgYmP7C3ckNFTHiGlJwK+w0KHLf0OU
        UdwVMn069ACjQYNO1vzVMF0=
X-Google-Smtp-Source: ABdhPJw8VYvj9YbLnMsAr/i9U7luMVFxsC1hhImnR4UoIO4PnsJ1O+sy4m4XBaYQNBfCm8RTcUL1XQ==
X-Received: by 2002:adf:e64d:: with SMTP id b13mr25212885wrn.204.1615765650095;
        Sun, 14 Mar 2021 16:47:30 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.154])
        by smtp.gmail.com with ESMTPSA id a131sm10805238wmc.48.2021.03.14.16.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 16:47:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12] io_uring: harden iopoll reaping in try_cancel
Date:   Sun, 14 Mar 2021 23:43:26 +0000
Message-Id: <cc9ebbe61a9e0d98d32db20a8f86949ebe822426.1615765375.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615765375.git.asml.silence@gmail.com>
References: <cover.1615765375.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't decide whether to do io_iopoll_try_reap_events() in
io_uring_try_cancel_requests() based on @files, because files
cancellation is not about files anymore but rather requests accounted
with io_req_track_inflight(), e.g. as for requests taking a file
reference to a io_uring file. Even though there is no problem now as
iopoll will fail early enough for io_uring file and io-wq behaves well,
it's safer to always do reaping.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ccd7f09fd449..9fb4bc5f063b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8712,8 +8712,7 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 		}
 
 		/* SQPOLL thread does its own polling */
-		if ((!(ctx->flags & IORING_SETUP_SQPOLL) && !files) ||
-		    (ctx->sq_data && ctx->sq_data->thread == current)) {
+		if (!ctx->sq_data || ctx->sq_data->thread == current) {
 			while (!list_empty_careful(&ctx->iopoll_list)) {
 				io_iopoll_try_reap_events(ctx);
 				ret = true;
-- 
2.24.0

