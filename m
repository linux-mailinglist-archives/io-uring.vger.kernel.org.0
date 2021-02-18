Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FEC31EEF7
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 19:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhBRSwP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 13:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbhBRSf5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 13:35:57 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F11C061756
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:46 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id f7so2909306wrt.12
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Ka1v7MTDkhCw1BHk/krtD+rP26rR9Ot3uY7WBU4BMNs=;
        b=HzR5J+6T/efkkhhUu1SBw9LsZG7kQdpSv0SCEWhsoocmW9VIOXVIFsU0qrNwf9xthV
         bmMGdZJFYFKXZ7JAUba2iZCOCVM6JoaV47Qk73J7ASWUMtHrpK6ic2aW5snaIrCRXjAW
         g0IWlEXNnpedIaev6VK0SadNohnnFNsFC4pQqp77WfrOcGzVUfIkP1i9YVTmIuI/A+Dd
         aWAsqbO23F3IXLrQMuxrAKyXrX67+94cezHJKrD6rwDNyp0NdPX+HIzF2BGyoisoFaq/
         +N7qNs5L64RhvdnZbrRJoy8/rePIzxDQYCxwzMwrC09RWFoU9rqK821+wb4kw1CqLdnE
         5L1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ka1v7MTDkhCw1BHk/krtD+rP26rR9Ot3uY7WBU4BMNs=;
        b=Ze1/sZy2FFE5HLSDEWoFLEPG8ZzrcsmdiONdsZ0gIjpe15wQX58AB+XmLhs8AYVi8Q
         cu4JgE0ua6xUSloCfvbGKghfjTem5t0OAkZ8Dk2nMCjasrPaDsJVfQjIHCfioHyljMnA
         7sRcO9UIb5/IWKE9TihANJXKkAW7o+nXvooQ8J9f06TYwjF+2gULrv3myceQl+98lKAK
         dZyFtfYmT70Nsk+iNiOZfcCCmSRseKLYR21aOLEyEcZu++yUEHPegC3fnQ1StC1DGDo0
         IF1u/kJfFLUyK9HA7Pn0XXCtzv4bpb648PyzoiZrp888iVmda6pZ/1tAYlFOOjWDSQFe
         X7dg==
X-Gm-Message-State: AOAM533fcz9NTLGx5tPrzv2BEp24IaS2wdCybZms7fcCgWGc6alsgtSJ
        IKjl3dCYDPYRaTvIPIojje34WKJoVKa9FQ==
X-Google-Smtp-Source: ABdhPJzu5avXpqYqakODCS+STTOrZ5WOPFSZSeyBikF4m3QLHQ2biIm3uDA2d9xb2TSsUQecAXlRWg==
X-Received: by 2002:a05:6000:11c4:: with SMTP id i4mr5442686wrx.272.1613673225192;
        Thu, 18 Feb 2021 10:33:45 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id 36sm4034459wrh.94.2021.02.18.10.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 10:33:44 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 01/11] io_uring: kill fictitious submit iteration index
Date:   Thu, 18 Feb 2021 18:29:37 +0000
Message-Id: <47558cad1f81cd93b8c0ab6e820f43c2f1890e63.1613671791.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613671791.git.asml.silence@gmail.com>
References: <cover.1613671791.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

@i and @submitted are very much coupled together, and there is no need
to keep them both. Remove @i, it doesn't change generated binary but
helps to keep a single source of truth.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4352bcea3d9d..32a6c89e69b1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6884,7 +6884,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 {
 	struct io_submit_link link;
-	int i, submitted = 0;
+	int submitted = 0;
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
 	if (test_bit(0, &ctx->sq_check_overflow)) {
@@ -6904,7 +6904,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	io_submit_state_start(&ctx->submit_state, nr);
 	link.head = NULL;
 
-	for (i = 0; i < nr; i++) {
+	while (submitted < nr) {
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
 		int err;
-- 
2.24.0

