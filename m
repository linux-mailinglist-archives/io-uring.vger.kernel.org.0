Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6283640C8E
	for <lists+io-uring@lfdr.de>; Fri,  2 Dec 2022 18:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbiLBRsz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Dec 2022 12:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233845AbiLBRsu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Dec 2022 12:48:50 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0690DDEA52
        for <io-uring@vger.kernel.org>; Fri,  2 Dec 2022 09:48:48 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id bx10so8979026wrb.0
        for <io-uring@vger.kernel.org>; Fri, 02 Dec 2022 09:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kvcrquw/9FE/9ZLzt/8g/wNbT1LMb7RcF1Pe1u97K48=;
        b=Ki3Us8hfMsI+Jh8WW3Wo6nHe8mnJ5JQW4bYPSdyyLNjlhYOy9id+JjpBZSw0jKoNTB
         m0AIxgbvR8FEVryFXHvCRcrjBJsImIZYrU0lPLrRFRgH4Frj5E7O9sD/QnODtTvMxJWe
         uLb5n+PF07dJY0BI5MpVEIGGptDZbCsAqTw0/Cw6oe9Ccf/rZaoXbXmrL5lVjGIPLjPq
         j0Eejq9yP91emqadUbpioYXWRvCwDgBAQRS08MYCWU6as7+ABM7pnPlMSAH6EAJ/DJBr
         G5MoyE7NNBH3AcCmsSX3U9GPP4+KNHWMXt/Rfcpz368CJhIKJ9E5Mt48CLWmpGepis9C
         jlgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kvcrquw/9FE/9ZLzt/8g/wNbT1LMb7RcF1Pe1u97K48=;
        b=Cu72ti8Emlq+GMt0W+eNpCo/RwX3XBCQMWdT76xP0eX+hELJgusYawBjDL/JcQaFgS
         lFe52o2zHvM0cPEAI5w8l3qa0dB2JYdy05vZnfXm8KEjl7ZnAgIsk8SGacCAhgiGw7k3
         VoleNLvxRixXQEdc8r51RaupJjBkOGWIG0CPBhKRdTdPwHbo7A0yF0sd1ZKnh4xveNE8
         JoEakEYF5Zl/Rh3NlM7MbVYvkQii0XrZd3iSxYiNZR5pkLT7lAOxIWtZcgd8K2ndrt0u
         OpeBNd+ngzATd2EBMHCmTdZYQ/DZ7C3lT3VWjO6eLLcusfjUz697ZVk7vPesgE9Rf45t
         zdxg==
X-Gm-Message-State: ANoB5pnrhin57FTIevaxelpUnmiBXpagtxYv0dKZXrj9y8WDjnmV8AP4
        2XpWxFBZ5pisKd75NY4WcIiqxP+q9/4=
X-Google-Smtp-Source: AA0mqf7rtIBg7OrX3c2nG3hxxIZtX66XNKotrz1eQKfhjibmS1HIXLq855jVjuaPZwcxn7sz76zkrQ==
X-Received: by 2002:adf:f9c7:0:b0:242:4d2e:4547 with SMTP id w7-20020adff9c7000000b002424d2e4547mr572126wrr.535.1670003326285;
        Fri, 02 Dec 2022 09:48:46 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:a57e])
        by smtp.gmail.com with ESMTPSA id i1-20020adfaac1000000b002238ea5750csm9368585wrc.72.2022.12.02.09.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 09:48:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/4] io_uring: protect cq_timeouts with timeout_lock
Date:   Fri,  2 Dec 2022 17:47:22 +0000
Message-Id: <9c79544dd6cf5c4018cb1bab99cf481a93ea46ef.1670002973.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670002973.git.asml.silence@gmail.com>
References: <cover.1670002973.git.asml.silence@gmail.com>
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

Read cq_timeouts in io_flush_timeouts() only after taking the
timeout_lock, as it's protected by it. There are many places where we
also grab ->completion_lock, but for instance io_timeout_fn() doesn't
and still modifies cq_timeouts.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/timeout.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 5b4bc93fd6e0..4c6a5666541c 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -72,10 +72,12 @@ static bool io_kill_timeout(struct io_kiocb *req, int status)
 __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->completion_lock)
 {
-	u32 seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	u32 seq;
 	struct io_timeout *timeout, *tmp;
 
 	spin_lock_irq(&ctx->timeout_lock);
+	seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+
 	list_for_each_entry_safe(timeout, tmp, &ctx->timeout_list, list) {
 		struct io_kiocb *req = cmd_to_io_kiocb(timeout);
 		u32 events_needed, events_got;
-- 
2.38.1

