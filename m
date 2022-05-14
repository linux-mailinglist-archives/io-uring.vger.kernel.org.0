Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437455271E1
	for <lists+io-uring@lfdr.de>; Sat, 14 May 2022 16:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbiENOUk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 May 2022 10:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbiENOUh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 May 2022 10:20:37 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D412B29C
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:20:34 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d22so10492643plr.9
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/MB3cYHRh72iKQ2NuBm+2JqwCkuwriU5DHURNuTzo4Q=;
        b=g0dr5lRE71lkn3eS8b+u3wYP7rewqhZCS3rdhahWuCFMmV53BThcDs0b7vNutMtwlY
         rvcLCEzbD7oT4me1jZbBNPDUWjcYECVH7N/F+Hud1AAymyB/xHArf9fe7FQd47N/GxMQ
         HYywV19qt9R5OH4OMl3kQJCfqYyAV16DipQ6rxaUKtwUrY/14T2EVaQqlmnsFDNwokcS
         vwrAUbiRqOY4kb94mcwdB6uDvGSSHP96VAMMpEn95UYR11lkBzxUj+yH4cUti0HyhYRo
         PKv/cDcf3txVpHDnN6zV0whz0QYlrFyojjig8D3ZaLSZCftXb2g/HtmoSqxEvUImEUWu
         cbCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/MB3cYHRh72iKQ2NuBm+2JqwCkuwriU5DHURNuTzo4Q=;
        b=AnD9hglu46EdKrZy2qUlu7nVP+TKsrd+CrpMCCFmLShHQEGBlTzkQBrSa3w8iFfmSu
         vZ/6Q2/vwUdYDgGjaMmcZP8K+5MAoGn8O7n5MIhs4hQlWTSpSsjv4RXXYYdtisgzxAtn
         rhxuL0WYzMWX1Uk/YfMgUC7fQWAs/mko2+jG5soKrDsVT3jlrwDXqtaN0191Bz/fJh1N
         IosfB/Szg9DuVkkzRpn1IxGywMVsI9vDsK6PkNWoNeNOlgZhFyTXj6PI4EgC1zuDRuya
         UrJqv0Bam7r2tda4yrt7o4IDlVgLgAKmUwaYTteR58jv3J9gicp/L1txy/BC7jhmT27L
         yxwg==
X-Gm-Message-State: AOAM531LBXMcxGZYCYY88iQYC98BWgUFENMHFFmNayI/EeSdX54YbJfb
        hlhnbmIOzP2erTIvFMhUrNvJBJSokst+Lh9M
X-Google-Smtp-Source: ABdhPJwt2HKYmmEPtVkMdNzMyQyppCg/TodW2i/HrN47f/gjOzxOKM/boh9Ca42JaL4+UPzaEzVNfg==
X-Received: by 2002:a17:902:b906:b0:158:3120:3b69 with SMTP id bf6-20020a170902b90600b0015831203b69mr9190406plb.33.1652538034109;
        Sat, 14 May 2022 07:20:34 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id o15-20020a170902d4cf00b0015e8d4eb27csm3815968plg.198.2022.05.14.07.20.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 May 2022 07:20:33 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 2/4] io_uring: add REQ_F_APOLL_MULTISHOT for requests
Date:   Sat, 14 May 2022 22:20:44 +0800
Message-Id: <20220514142046.58072-3-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220514142046.58072-1-haoxu.linux@gmail.com>
References: <20220514142046.58072-1-haoxu.linux@gmail.com>
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
future. Also add a mask IO_APOLL_MULTI_POLLED which stands for
REQ_F_APOLL_MULTI | REQ_F_POLLED, to make the code short and cleaner.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c4bd0faf0b27..e1e550de5956 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -116,6 +116,8 @@
 #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
 				 IO_REQ_CLEAN_FLAGS)
 
+#define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
+
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
 struct io_uring {
@@ -812,6 +814,7 @@ enum {
 	REQ_F_SINGLE_POLL_BIT,
 	REQ_F_DOUBLE_POLL_BIT,
 	REQ_F_PARTIAL_IO_BIT,
+	REQ_F_APOLL_MULTISHOT_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
@@ -876,6 +879,8 @@ enum {
 	REQ_F_DOUBLE_POLL	= BIT(REQ_F_DOUBLE_POLL_BIT),
 	/* request has already done partial IO */
 	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
+	/* fast poll multishot mode */
+	REQ_F_APOLL_MULTISHOT	= BIT(REQ_F_APOLL_MULTISHOT_BIT),
 };
 
 struct async_poll {
-- 
2.36.0

