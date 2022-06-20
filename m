Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4EB4550DD6
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 02:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbiFTA0h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 20:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237222AbiFTA0g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 20:26:36 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31755A1B0
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:35 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id m39-20020a05600c3b2700b0039c511ebbacso6978755wms.3
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bMRnPVi0XcPa9YJu7/ow+fUvpoMsSalydaykjjzRIkI=;
        b=WoivE2T3+MTQd2Rs0qw8pfpXmy/ZLIVq+jn1f1D/w75tifzom6kaZxsUfX8ySGXdew
         uUbLPPgteMwzFkdBap9LUBj2TP5lQ9w4vjk+8+AXKLlfhXL25eNfCWUpb8mtxl+OmcZ0
         poxmcLEnUEmgaz8Oe32oGXq5fTzDY+mzU0Gl+vuLFUX0NZj/R2Tr6zrxAlk2X+MLAAM0
         T/bwNiKsy+Uh2Cxe15cWL/rkO1ll7XrqaDi8MYwfW9wWY0iOfyqVE5yhgHNE/FL3sqhD
         QszUnEWCkukRAL1JEcoo3xOTCsy5JwK05oVuJeV90wPC8AUd6FQDCcBoU5IB/zpZaCUP
         wYJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bMRnPVi0XcPa9YJu7/ow+fUvpoMsSalydaykjjzRIkI=;
        b=e3L9eVqdycY5CeuPfOsm9NEcTPq+wg/uQ2jP40Twb4XGiLqiSaumOKo7dpXQMSsLQs
         zuJTxnWPcnLflyx5sPerl3860vD+keORC5aoRH/eDkM5LCh8EN24em0VcRCDVsmpQDfo
         BdjeDluK/RS3Kzn1mFjAT6G9n2OfqLAQp7gm+Qr49p+KRmoC/YAMBH8Yj4yOWpMuw2ER
         vGG7DT0/8JD4D+OgNMeUjhFEswZPkO0RCg8yDHtuiLXIXTpimHmgNpCp/tym/aWnBRPU
         sok+Wf9tJ0wyU9PTbIA7OsL1ydVCdV3Md7ZURhfZdJJht1xcQ1nfDUK8ell0V5Y/qkKq
         A/hg==
X-Gm-Message-State: AJIora+VgW/jd2n+5RLLWStPIg5+bAltb+d5UbZ4e9IkoDm0V3RdqcoF
        3oKCvbIpZF3hVqSzmIOQydOfSL/nfJ2HfA==
X-Google-Smtp-Source: AGRyM1uguAZihHTCb+nDYBODxPvobwep78Hg5lnQKJ1ZeNcIIqYn47DZLeSYufeWQ0V1CCg+havbSA==
X-Received: by 2002:a05:600c:35c2:b0:39b:fa1f:4f38 with SMTP id r2-20020a05600c35c200b0039bfa1f4f38mr21830682wmq.22.1655684793498;
        Sun, 19 Jun 2022 17:26:33 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d4312000000b002167efdd549sm11543807wrq.38.2022.06.19.17.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 17:26:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH for-next 03/10] io_uring: fix io_poll_remove_all clang warnings
Date:   Mon, 20 Jun 2022 01:25:54 +0100
Message-Id: <f11d21dcdf9233e0eeb15fa13b858a05a78eb310.1655684496.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655684496.git.asml.silence@gmail.com>
References: <cover.1655684496.git.asml.silence@gmail.com>
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

clang complains on bitwise operations with bools, add a bit more
verbosity to better show that we want to call io_poll_remove_all_table()
twice but with different arguments.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index d4bfc6d945cf..9af6a34222a9 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -589,8 +589,11 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 			       bool cancel_all)
 	__must_hold(&ctx->uring_lock)
 {
-	return io_poll_remove_all_table(tsk, &ctx->cancel_table, cancel_all) |
-	       io_poll_remove_all_table(tsk, &ctx->cancel_table_locked, cancel_all);
+	bool ret;
+
+	ret = io_poll_remove_all_table(tsk, &ctx->cancel_table, cancel_all);
+	ret |= io_poll_remove_all_table(tsk, &ctx->cancel_table_locked, cancel_all);
+	return ret;
 }
 
 static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
-- 
2.36.1

