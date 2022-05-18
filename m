Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B92E52C234
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 20:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbiERSOn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 14:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234057AbiERSOm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 14:14:42 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFEE16A26B
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 11:14:41 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id s28so3680347wrb.7
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 11:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/5R6vFb6uO5bY91Qmby2x5bJZp2p1cSn+/oVO8NEaRo=;
        b=c2URgCL8iRMd9ouE8OaF5nUrCrrfI5bCUepBnaDfvdufEgTZyfNTj6ktK/kpRnlfT/
         zijRoabNfM4XP4QBW2QAZ+yqdvREMtOY8m7073rZQITYVLbS9s1CBPm8qhEx/BtPenW/
         GtlmMX6mPvmp4meHj0tT6WDHiUL7AoefhKNUKRRL+sFp/Ppworbqe62UL6MmL9xUF/bv
         26jZB76HmV0SrcLVzXmZBA7FFpBsxDwR6CpBWE6XJYs55/bMHgKv2lFnP5Q46GrWNaL8
         hjg7ixZesXWBoMs09seozcE6QTx3wy1T6Yi53O4/DFjYVTkgYi6P6a3UWh628mN4RgF5
         WPsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/5R6vFb6uO5bY91Qmby2x5bJZp2p1cSn+/oVO8NEaRo=;
        b=1sQXMNEEOQT7tDpgZ72Bxx7ohoxMZknSLbNB2EgsRRyHyTJ3XJsslpHGr/uVsiv6+i
         jT40hgaIDbi7956ScU3uzIA8TlAFVInSMkLF+FoSBskzQ5PJFLVmqbDwdzA7ubzPUM6y
         LdjH2YXmUoud2gTYVrT1H8Eb8S1JF9cbMX+TAzUioAk5Iq4bv2GsTTNoZoS6BLFwBowX
         +NOZ4Mh41qC0GE2j41KMjWo0RM8y5GhfZnL20OmKsqd1zQc9rxrDGC9DX2whwASP7LzB
         adKzBkTmOKw8eVbG0Izi42bUoT8E9rIagoA56bRK9Fhrq+zUTlfCHqsOAOHfwCjFefGp
         1ZyA==
X-Gm-Message-State: AOAM5325jdsmbH2XFb3+JKr6p21LUTXzFm6/poG5cbjlgiN2L8T/sJNV
        FsBEXazLoWgXq4FYagjbpPat9h8rgRg=
X-Google-Smtp-Source: ABdhPJxcns6YdxoxYJI8IC2SBJbuiouxnQIug5TKtcfkIYxLeIjQ6qmgJ5/WviwoOdOfy43SC3gQ3g==
X-Received: by 2002:a05:6000:1d83:b0:20c:d508:f55a with SMTP id bk3-20020a0560001d8300b0020cd508f55amr788525wrb.217.1652897679639;
        Wed, 18 May 2022 11:14:39 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.236.31])
        by smtp.gmail.com with ESMTPSA id c25-20020adfa319000000b0020c6b78eb5asm2791949wrb.68.2022.05.18.11.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 11:14:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next] io_uring: add fully sparse buffer registration
Date:   Wed, 18 May 2022 19:13:49 +0100
Message-Id: <66f429e4912fe39fb3318217ff33a2853d4544be.1652879898.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Honour IORING_RSRC_REGISTER_SPARSE not only for direct files but fixed
buffers as well. It makes the rsrc API more consistent.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8b232bde32bf..eeb894abbae4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10141,12 +10141,17 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	}
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
-		ret = io_copy_iov(ctx, &iov, arg, i);
-		if (ret)
-			break;
-		ret = io_buffer_validate(&iov);
-		if (ret)
-			break;
+		if (arg) {
+			ret = io_copy_iov(ctx, &iov, arg, i);
+			if (ret)
+				break;
+			ret = io_buffer_validate(&iov);
+			if (ret)
+				break;
+		} else {
+			memset(&iov, 0, sizeof(iov));
+		}
+
 		if (!iov.iov_base && *io_get_tag_slot(data, i)) {
 			ret = -EINVAL;
 			break;
@@ -11993,7 +11998,7 @@ static __cold int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 		return io_sqe_files_register(ctx, u64_to_user_ptr(rr.data),
 					     rr.nr, u64_to_user_ptr(rr.tags));
 	case IORING_RSRC_BUFFER:
-		if (rr.flags & IORING_RSRC_REGISTER_SPARSE)
+		if (rr.flags & IORING_RSRC_REGISTER_SPARSE && rr.data)
 			break;
 		return io_sqe_buffers_register(ctx, u64_to_user_ptr(rr.data),
 					       rr.nr, u64_to_user_ptr(rr.tags));
@@ -12231,6 +12236,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 
 	switch (opcode) {
 	case IORING_REGISTER_BUFFERS:
+		ret = -EFAULT;
+		if (!arg)
+			break;
 		ret = io_sqe_buffers_register(ctx, arg, nr_args, NULL);
 		break;
 	case IORING_UNREGISTER_BUFFERS:
-- 
2.36.0

