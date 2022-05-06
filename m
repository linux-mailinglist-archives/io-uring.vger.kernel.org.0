Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3264D51D1C9
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 09:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387030AbiEFHEt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 03:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386883AbiEFHEr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 03:04:47 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A8D4D63F;
        Fri,  6 May 2022 00:01:05 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id x18so6567984plg.6;
        Fri, 06 May 2022 00:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2AGe5Fmx04dYyhCcUtd7dBWkTmPQ4OwhfuehIUMvDJ4=;
        b=OKbex0vmp7kWmxvwwJRScYXYCARzcyb0nJnHPf3sRu+k66EkOQ06HAMncYe+24pUxi
         TyHl+M13kcUJRh/zR0NBQaYQTmQZA8J7i8PsjJjy4KGMZsQu7qJjcaskP605ZycJAZJV
         wymev/cUEgPhmDG92TcNn0+wTBmJYyiNAebidcEQK8oIJnwL2hLYrg09wF7L1VovvPoC
         zepjJFdTM8C15D0JR86tP09qy/GM/PKCA10/X5c+fXeTeMcw4x16T/nnm0RE/8aLjIx5
         TWx3E1BBeoHH0/lP0hyEldXkHok5Wn4+coS4tC6Rq0HOauwHZICaMWl7avu0jdACO9Zs
         F2TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2AGe5Fmx04dYyhCcUtd7dBWkTmPQ4OwhfuehIUMvDJ4=;
        b=F0LxwupG29IYTRgeu8q9ro3DHSEqdPwf12xz82veuS8zLHUlw+qG/fA7cDpzoCNONi
         j+1jEhrh+MohrhJEK8CjezzjCgGYcaQZ4db4VW3ON0NF99Ql5rmPO6urzNnQcv94pgDT
         6LLjDb1nJ9lAThVYwr0cwsX5u1y2L8ZY+gkBXlS8MRdGRPCYIQDWk+2xRLeVaVUiRNID
         BSCEmQDczxE5e8KIcuefNtCSLSnqzlZCGcwAkEyB2G/9rSWbyBhS6s7Fp/A4poI3Sxwz
         6ek1Rtx7ttJWgZGddE0bgccLs4qULrmXQYKJ5oo+ybfLP0uJ0BYraPJa2y/13m+jeooy
         lSBw==
X-Gm-Message-State: AOAM531giu2qywdHvIkqvUjp6b6RL0BM+iYBAksHJseMEEyb4MyQeQ4J
        w+iXpmdufhG80y2g7nKp7WXOsiOXyDU=
X-Google-Smtp-Source: ABdhPJwR/XbbxF8XjQQ5FK4kHIN7brTqpFYIY68SsdK91qG+YI+35sIDAaeLeTNGZD53eUaBxQuscA==
X-Received: by 2002:a17:902:868e:b0:15a:7c9d:b11f with SMTP id g14-20020a170902868e00b0015a7c9db11fmr2214171plo.151.1651820464993;
        Fri, 06 May 2022 00:01:04 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id bh2-20020a170902a98200b0015e8d4eb2desm813112plb.296.2022.05.06.00.01.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 May 2022 00:01:04 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] io_uring: add REQ_F_APOLL_MULTISHOT for requests
Date:   Fri,  6 May 2022 15:00:59 +0800
Message-Id: <20220506070102.26032-3-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220506070102.26032-1-haoxu.linux@gmail.com>
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
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

From: Hao Xu <howeyxu@tencent.com>

Add a flag to indicate multishot mode for fast poll. currently only
accept use it, but there may be more operations leveraging it in the
future.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1e7466079af7..8ebb1a794e36 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -808,6 +808,7 @@ enum {
 	REQ_F_SINGLE_POLL_BIT,
 	REQ_F_DOUBLE_POLL_BIT,
 	REQ_F_PARTIAL_IO_BIT,
+	REQ_F_APOLL_MULTISHOT_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
@@ -872,6 +873,8 @@ enum {
 	REQ_F_DOUBLE_POLL	= BIT(REQ_F_DOUBLE_POLL_BIT),
 	/* request has already done partial IO */
 	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
+	/* fast poll multishot mode */
+	REQ_F_APOLL_MULTISHOT	= BIT(REQ_F_APOLL_MULTISHOT_BIT),
 };
 
 struct async_poll {
-- 
2.36.0

