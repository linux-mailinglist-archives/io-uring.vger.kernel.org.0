Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 066C66E0FFB
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 16:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbjDMO26 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Apr 2023 10:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbjDMO25 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Apr 2023 10:28:57 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B049740
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:28:56 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id e16so1100000wra.6
        for <io-uring@vger.kernel.org>; Thu, 13 Apr 2023 07:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681396135; x=1683988135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nDHHjHbDhUeYee8/gBhjE43x0PfM6JmFgWG0GA+SmFM=;
        b=V1zHw5gi4IzQQzwksT2aM0B6DaftIE6zn4lVJPamARwOhykbst1jgSWMMo9s4gCjKx
         U14POX2ARYt4Y5B46gpnnkEr3OkUUmYiFH5Aoeu2EhkT1GMoOexci/Wrxfb9R3y4UhZc
         ZzW28QhHxsdcneDY+DC7WesW4RSj14e9e5NqnAJZpRytavWkUjMY8wm8nLucMxHL+n6S
         LVbVASMce66hL7SNZsKKyaqvgRxpfqkg4/S43Y2HqHUpwi9+R/INMiWBJ6z2asUkyrQC
         wUicTCSp8QqMZJqfTvVKF5hHoDCyFat+Tr6MQW2PkgErGbDmZdTc23yJT3bs5ucqLG3U
         zboQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681396135; x=1683988135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nDHHjHbDhUeYee8/gBhjE43x0PfM6JmFgWG0GA+SmFM=;
        b=AmkfaFQhbl7r/LplHFmXK6y/gD5iSMTXHChRTF7hZgVGPo7PjzopCnPz65m92lO7To
         LdM75uo0fxu7hRQA5tJzLEtdlxlfc5lwT2g8nr9q4P6mjdONdAa6M7cdY5qCY9beldWA
         M76pTlnd0QVcMcqdWaAZSzXAz6jpmojPUPLEHDczUWqvtTdM0yNrxJ2P9ojib+Ghg5ub
         35qXMxvDKhd5JV+wlbAxZGOBuV4Z3vWWrrcr1ROLHNgbCiZgi1yUhGqxP0p0T8KKJVyc
         W8w7aXr0h7/KPQ9EYc+KuqalLn3jwjteNqyLv6O+qIeyifugPv4YlhHWLH6G1aX7wzXW
         Nu9w==
X-Gm-Message-State: AAQBX9f+C1iqDmsh5Sjh9P2G+AbYzRZUAXBD8ONNDcHE3inlgqsEHqSu
        z1nWmK0wug+Paop4gyFM48IDhqC++iU=
X-Google-Smtp-Source: AKy350Y3isKABC9FPT6KXyr1zvnwFPttY6l0BiXRTejl4UrKxSgZZsADcVnPWP6OlgRbD5mQcaRpkA==
X-Received: by 2002:adf:eed0:0:b0:2d7:9206:488d with SMTP id a16-20020adfeed0000000b002d79206488dmr1668793wrp.36.1681396134758;
        Thu, 13 Apr 2023 07:28:54 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.97.186.threembb.co.uk. [94.196.97.186])
        by smtp.gmail.com with ESMTPSA id z14-20020adff1ce000000b002f28de9f73bsm1387391wro.55.2023.04.13.07.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 07:28:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 01/10] io_uring/rsrc: use nospec'ed indexes
Date:   Thu, 13 Apr 2023 15:28:05 +0100
Message-Id: <f02fafc5a9c0dd69be2b0618c38831c078232ff0.1681395792.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681395792.git.asml.silence@gmail.com>
References: <cover.1681395792.git.asml.silence@gmail.com>
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

We use array_index_nospec() for registered buffer indexes, but don't use
it while poking into rsrc tags, fix that.

Fixes: 634d00df5e1cf ("io_uring: add full-fledged dynamic buffers support")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 11058e20bdcc..3c1538b8c8f4 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -517,7 +517,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		}
 
 		ctx->user_bufs[i] = imu;
-		*io_get_tag_slot(ctx->buf_data, offset) = tag;
+		*io_get_tag_slot(ctx->buf_data, i) = tag;
 	}
 
 	if (needs_switch)
-- 
2.40.0

