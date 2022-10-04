Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1425F3B5E
	for <lists+io-uring@lfdr.de>; Tue,  4 Oct 2022 04:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJDCYs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Oct 2022 22:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiJDCYp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Oct 2022 22:24:45 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C37DF3B
        for <io-uring@vger.kernel.org>; Mon,  3 Oct 2022 19:24:07 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id u10so19087026wrq.2
        for <io-uring@vger.kernel.org>; Mon, 03 Oct 2022 19:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=LagCFMsq/pbO15dGj6Ro0r9Zdt9uYmQFCFdKQuiIgzc=;
        b=VO1+M1/5IrxUtQHykJT19IIXsJO+vMdedlAOBQ0EO+sN2RRO6ICEzZa1mK1kFTiWWs
         a+IDhvpivF6xrtHU5HiG/Zj4giaau3fDCVQSMMoaswCxyR1mntXxzXyANL7pWjkRaE4n
         j8vjXLkfzUygj7ru7xnnYdw7Oy0hAxp4tg+dYBboHoTYAYQiXyVYEP7+jOfmeZTqhelu
         tpuCPl32iLqTvL8iCT0jSGrPzZg0B2aV+9freS5f0+W0mhdYt0okhzXc7v93jKEwkdYf
         tOA//ukhuRV3UcBV6WyZjIjEhMRyEqY32K0t2o4Og62VY5kUYVPwWGUTenMUj5ZxhJmA
         9srQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=LagCFMsq/pbO15dGj6Ro0r9Zdt9uYmQFCFdKQuiIgzc=;
        b=08OMznPLhy/7RvC176tDuYgch5o2jpDLlUbkMZoOl+A2wRwAEdgh6X+V0NfGIUiALo
         qBnT7CEWu88RAw2war1vVmiW6yy90yZzvQLoFp5st5RT+DfuAmXc1Ag/wQQIzZhyuzd+
         8ef7KV+YVgAaFP4dtsPicrhECyZsSiPDlwGgWFar7NajslASMDJcqvnAZhfJ/4Bg16pF
         I2kBzeefBEpBLaWJHP6RIPZ0e6/4MlG+E9Qu2BN0UQgU6SvU7qva8J973xiL0ymNZITc
         fsBK7a2p/pp1PSU1xTE8aYZuyrqxx3YWXRNjPYWhNbsUCOX31R5YHe54Kr+QFR7osRXd
         TyTA==
X-Gm-Message-State: ACrzQf0NnQDMUoPEv/K/C4/j/c8VGGDgCLEIvmj4zBn1F9Ly9Pv2hGCk
        uUKeV+HDcp0GTh6YyKySdHeCr3StxSg=
X-Google-Smtp-Source: AMsMyM4YR2RK1PmnSfh88mqgiHuwnFxVVApxZZJRMKtl7lDekFiE+KOjDuiKri7869FcHc4opE+CPA==
X-Received: by 2002:a05:6000:1f11:b0:22e:3057:e9d0 with SMTP id bv17-20020a0560001f1100b0022e3057e9d0mr7561904wrb.351.1664850015002;
        Mon, 03 Oct 2022 19:20:15 -0700 (PDT)
Received: from 127.0.0.1localhost (188.30.232.152.threembb.co.uk. [188.30.232.152])
        by smtp.gmail.com with ESMTPSA id k16-20020a5d5250000000b0022ca921dc67sm11302803wrc.88.2022.10.03.19.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 19:20:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.1 1/1] io_uring: correct pinned_vm accounting
Date:   Tue,  4 Oct 2022 03:19:08 +0100
Message-Id: <6d798f65ed4ab8db3664c4d3397d4af16ca98846.1664849932.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.3
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

->mm_account should be released only after we free all registered
buffers, otherwise __io_sqe_buffers_unregister() will see a NULL
->mm_account and skip locked_vm accounting.

Cc: <Stable@vger.kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 62d1f55fde55..73b841d4cfd0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2585,12 +2585,6 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
-
-	if (ctx->mm_account) {
-		mmdrop(ctx->mm_account);
-		ctx->mm_account = NULL;
-	}
-
 	io_rsrc_refs_drop(ctx);
 	/* __io_rsrc_put_work() may need uring_lock to progress, wait w/o it */
 	io_wait_rsrc_data(ctx->buf_data);
@@ -2633,6 +2627,10 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 	WARN_ON_ONCE(ctx->notif_slots || ctx->nr_notif_slots);
 
+	if (ctx->mm_account) {
+		mmdrop(ctx->mm_account);
+		ctx->mm_account = NULL;
+	}
 	io_mem_free(ctx->rings);
 	io_mem_free(ctx->sq_sqes);
 
-- 
2.37.3

