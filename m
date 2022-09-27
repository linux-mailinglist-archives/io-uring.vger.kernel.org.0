Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22525EB622
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 02:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiI0AOk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 20:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiI0AOj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 20:14:39 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C2412AFF
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 17:14:36 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id bk15so4816252wrb.13
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 17:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=fBrnHn/bzSCaOML05ZUAlbmm6hmaDOm8trEbduJJr94=;
        b=TjzHRN0vcvsFnNlT29dLPId2su4cj2c3JqgOVko1rjIslBDyXpCNACXoBCRtWW69vI
         jo3Ms4BJKcd9ZlIoJSC+oYYXeBQV/QV+vpNVgVoQNUU4J9HZN1LVAVDShJrqxEeYNiAg
         QGHla8fsnA6iiRjwcU1O9nBU9JXuZy2uGzHXg7kYCcGeWfgXygxSH7BblQRFinjWKRTT
         xTWIz8altnZ401CvF1aROYxV9S9LnSWXwZMfQZhij3O7977LI2wCcBsleG/JVXzE3oN+
         osaB6lkF8vOaAg/AXbHb74xFt9YfuYshvSGLnlF1p06RMLQ2WDPzcOABiffRs8G4yDNA
         sR0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=fBrnHn/bzSCaOML05ZUAlbmm6hmaDOm8trEbduJJr94=;
        b=2Hjcm3FuIzqagEXhXjpJbHetsavuTB5o4AfOiS3yVUi9DaWUcH+xIh8ZLF8a3D3KkE
         8UiXTzcFsEJ1h2aixbyTdQgqCZODhVBS7qZ+C+g5/CK40nYm7CjiWUC0GXhOSZsf4PUF
         b5CbBDTJqIL6/7Bx20eco/pHVRAqgPy4frF3mfZwGvimWk9j0RWJ/w+OBEC2/5g0kxV+
         /AtRKlE73R+FSnEAEPCk8L1csWbhqwSOVQ3sSS/LHOFNrV0HlFbWeQUatP4YphwPjyQy
         3+WXDPQeaLaUrDxsEGTTT6vgkcXIpXetX9t+aXgpuEQdv9dHgNKbxndenb+L/SMa6drz
         KFGQ==
X-Gm-Message-State: ACrzQf1GoR562H09buA4uCy5K64pRtseoqPEDB/8sA+S7kAGM8ndN2ay
        Z0N9xjFHqtx5KEIuG6X5z0CHemy1pFg=
X-Google-Smtp-Source: AMsMyM7U7P8DP3/UkAY6wwtnsSR6c4HcA+5HarJiUZ56ETUhpbc4tXGxJo1JfDfXt9gN1ixBSIURaw==
X-Received: by 2002:adf:e4cc:0:b0:22a:d755:aaf7 with SMTP id v12-20020adfe4cc000000b0022ad755aaf7mr15088999wrm.692.1664237674362;
        Mon, 26 Sep 2022 17:14:34 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id r4-20020a05600c320400b003b4de550e34sm53514wmp.40.2022.09.26.17.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 17:14:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/1] io_uring: limit registration w/ SINGLE_ISSUER
Date:   Tue, 27 Sep 2022 01:13:30 +0100
Message-Id: <f52a6a9c8a8990d4a831f73c0571e7406aac2bba.1664237592.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_SETUP_SINGLE_ISSUER restricts what tasks can submit requests.
Extend it to registration as well, so non-owning task can't do
registrations. It's not necessary at the moment but might be useful in
the future.

Cc: <stable@vger.kernel.org> # 6.0
Fixes: 97bbdc06a444 ("io_uring: add IORING_SETUP_SINGLE_ISSUER")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 73ac6948debb..3f6eb3cf07ac 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3890,6 +3890,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	if (WARN_ON_ONCE(percpu_ref_is_dying(&ctx->refs)))
 		return -ENXIO;
 
+	if (ctx->submitter_task && ctx->submitter_task != current)
+		return -EEXIST;
+
 	if (ctx->restricted) {
 		if (opcode >= IORING_REGISTER_LAST)
 			return -EINVAL;
-- 
2.37.2

