Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73DD6D60F6
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 14:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234499AbjDDMlB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 08:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbjDDMk6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 08:40:58 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E1AD8;
        Tue,  4 Apr 2023 05:40:54 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id cn12so130059676edb.4;
        Tue, 04 Apr 2023 05:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680612053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F32O348mTkggRcCcK2wkzqvHv1nRgFctuPngecPv3KY=;
        b=dTK7+Kye78JXOJfhcNt8QivolTT8rVP53t8GXXvuGVNhpH8N24pc2EoeSFwmyWZEWs
         AGbEG0jOIjwCTd04Zps0w3m1P+vKhsMcbIpQaYx/Zrk2ki5Hj/jKinjGlb1UgxyYawvr
         p3AWcONqwd/fk4GXL7mvTxJe6ReZNXMoLzDO3C83my3sO4oe2HmM7929WWWspr6KYt1e
         bD4mCFWZHL3XeeRns0BB4yADWqE0M/2s/FfGVoVwH1LoiyW3zyETnRwzGfaBvkXcViLr
         1Ek01KizZI53MjFIa1c0kS/6VfHXob/40V0x06HjYltnfmo1ZN9nfcGBtNkB8oT8HY6x
         58WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680612053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F32O348mTkggRcCcK2wkzqvHv1nRgFctuPngecPv3KY=;
        b=xclh7kU/hzPIeiounBe9iiuXTAFCrDhOE10PH1YsKrriqfq0uSqv/nX6eO2fQaEokW
         Mi+MyRaxE+VHFyMsYVddUPHO38VwZZeqTOeEd0EkowxbBIOgDQialkKYbAMMQYFlw6wU
         k0zJISF92lpAnl5SGTn9jaBAdQYEoV0Ley5k7dHQPcMju5t7O3prWA7EbD51qbXpL3p7
         PxPsuJ2tR06WZBaaMZWKrcDteY+b+GagwhZZYLqU95972zIssm8+dwu6mlX5uJQQbGtG
         hN27Q6UzXx487bAzJIe/uMNkkuA8+32QKA5j9iG0gQNRjl2Xh1DW31ZO7swFjOXivaSQ
         rsPQ==
X-Gm-Message-State: AAQBX9fS03bpcRVXYBuuMpO2Y+vkw1vuQCIrrzqsFhgRHIiBLphsT3po
        rlLCU0KPpV184ZVAUxA70HxM0T44sv8=
X-Google-Smtp-Source: AKy350ZwucnxQ5/rtTCPMzR1qGefdnFGmMlIzYVU32txjma4YkXkJ8UMzJGCIK4aMxU6o/f9kMCfmg==
X-Received: by 2002:a17:906:ee1:b0:862:c1d5:ea1b with SMTP id x1-20020a1709060ee100b00862c1d5ea1bmr2064833eji.8.1680612052843;
        Tue, 04 Apr 2023 05:40:52 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:2b22])
        by smtp.gmail.com with ESMTPSA id g8-20020a170906394800b008cafeec917dsm5978851eje.101.2023.04.04.05.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:40:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/13] io_uring: io_free_req() via tw
Date:   Tue,  4 Apr 2023 13:39:48 +0100
Message-Id: <3a92fe80bb068757e51aaa0b105cfbe8f5dfee9e.1680576071.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1680576071.git.asml.silence@gmail.com>
References: <cover.1680576071.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_free_req() is not often used but nevertheless problematic as there is
no way to know the current context, it may be used from the submission
path or even by an irq handler. Push it to a fresh context using
task_work.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 596af20cddb4..98320f4b0bca 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1116,7 +1116,7 @@ static inline void io_dismantle_req(struct io_kiocb *req)
 		io_put_file(req->file);
 }
 
-__cold void io_free_req(struct io_kiocb *req)
+static __cold void io_free_req_tw(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -1130,6 +1130,12 @@ __cold void io_free_req(struct io_kiocb *req)
 	spin_unlock(&ctx->completion_lock);
 }
 
+__cold void io_free_req(struct io_kiocb *req)
+{
+	req->io_task_work.func = io_free_req_tw;
+	io_req_task_work_add(req);
+}
+
 static void __io_req_find_next_prep(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-- 
2.39.1

