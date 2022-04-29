Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F8E514949
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 14:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359010AbiD2Mbh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 08:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359135AbiD2Mbe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 08:31:34 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D66C8BFD
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:15 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 15so6412943pgf.4
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 05:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s1aQQkuSDQXOHpc3mIklo5H8JCbuSWvxUlKkJqnZOwU=;
        b=K1GmWDroTpc6qp4pKiSHNGCQ213sO/h/TVfUSJrhBNjmaAgsvJtL/IptURy00yyRN8
         5TIcCzFQhNeJ/wb7sTwNY5WOPhNaQbrsqO1qDoaGdos+FlbPccoNcN3lT30bvffw2qF2
         3AUbcqES7mp6qLyb6X7uOA2guoLMrDEWu6+FUjOnnrNRoyJdV8WkJJf908dpBFed7quG
         hXTNCmkJoEyoXbapmdfaHHW6jdnN8gPm/hxo7GM/HVSzYhhAs+dWDP2D0QpdcOAzINC+
         2fFxn17KYVsBq/4YhC1jExEtCgdJO++4yl3bu0xY3H0yXuOqX1LLoZwesnBNohVChEgk
         ZuVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s1aQQkuSDQXOHpc3mIklo5H8JCbuSWvxUlKkJqnZOwU=;
        b=FCUuW2rsZIaxBB92y/GgaHvmhhKgp2t0OOjDgxk6oXGeL012hoX+pl4ItAbdqLfJ8M
         djzF2xDgEJLCVm+XK54j2cULD1aMP8IKrSqdL+pyjw4FQAtkAFEDp7/kCvkTRGPnjuqY
         1nIVN3Q8q7f+GOQ2Jr2uShN6jQ3OJKAf/Emqu7bN0WDDOPbP+QZiaUDZ5UKpX7ZLsHiO
         QjOQYEbAfwStvQ2LzZLKI0sky48q6kJPL2+Ot0sMGesvlUAYnH+JMbVid9DYUokaUd3N
         Vwazjv8Mptb0trPGGrOYCW7Nh+fmWs/10xW5gJGWouFXrMIWr6x3Tto9L3OlrXchhAZo
         DVMw==
X-Gm-Message-State: AOAM533e6NVYbNh2XUtLTGba0cC9ILGtYu1R7FU7bj4claP8/HTANxtH
        T0J+QGlNID+s5FAI0CwFojU3a+W6hK7Fv313
X-Google-Smtp-Source: ABdhPJxIirNgamrdCUpz7sjh1mzSksA3cS1iL/KtfwaUOR6TzyLOFqVJX3uaZkJBLBwPa+dJl6h64A==
X-Received: by 2002:a63:2cd4:0:b0:39d:8636:3808 with SMTP id s203-20020a632cd4000000b0039d86363808mr32016607pgs.290.1651235295094;
        Fri, 29 Apr 2022 05:28:15 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o26-20020a629a1a000000b0050d5d7a02b8sm2895837pfe.192.2022.04.29.05.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 05:28:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/10] io_uring: add buffer selection support to IORING_OP_NOP
Date:   Fri, 29 Apr 2022 06:27:59 -0600
Message-Id: <20220429122803.41101-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429122803.41101-1-axboe@kernel.dk>
References: <20220429122803.41101-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Obviously not really useful since it's not transferring data, but it
is helpful in benchmarking overhead of provided buffers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 50d48d3e05b7..c9f06aac4a53 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1052,7 +1052,9 @@ struct io_op_def {
 };
 
 static const struct io_op_def io_op_defs[] = {
-	[IORING_OP_NOP] = {},
+	[IORING_OP_NOP] = {
+		.buffer_select		= 1,
+	},
 	[IORING_OP_READV] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
@@ -4907,11 +4909,20 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	void __user *buf;
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
-	__io_req_complete(req, issue_flags, 0, 0);
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		size_t len = 1;
+
+		buf = io_buffer_select(req, &len, issue_flags);
+		if (IS_ERR(buf))
+			return PTR_ERR(buf);
+	}
+
+	__io_req_complete(req, issue_flags, 0, io_put_kbuf(req, issue_flags));
 	return 0;
 }
 
-- 
2.35.1

