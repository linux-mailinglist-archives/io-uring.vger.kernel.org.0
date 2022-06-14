Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402DF54B10F
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242808AbiFNMeg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355284AbiFNMeX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:34:23 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BF94BBB1
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:31:02 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id m32-20020a05600c3b2000b0039756bb41f2so4707111wms.3
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zrn7uBYKLng0XHi7RMiiU3T4m2AfPpnQM1wA3OWR3wg=;
        b=RQ9uiRkk3D2d/Y/TWEyhipyB3ehxQ2F7AQAlyRPIs8S+p1XK9FGVsQW+GyVeBbDNoE
         0XThRMrJNj6SvYNBR7YlbujC7oaCGo0q30X0Db+3eR1sTS8qkMLMYneGW+j/dAVbUI9S
         Sgoyo2RPVMHCStYXmxM4r8wDLfX0jrC9C6MGsOYTyoC11klP3LzrPOjlvWnBSrJG4+Aw
         4f6e8dBgMogvMeFp+hveCdiaAKZI+Q2BQBjDFWW3J41P4pAzESQiCEKhioNddHAsz5Xe
         HgxcI1/2/dZqAVLQBCXZu2euhrmKU3eE3wRr3+wgAawZJRYYVs5E46GPSWmBBjJ0+g/R
         6SIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zrn7uBYKLng0XHi7RMiiU3T4m2AfPpnQM1wA3OWR3wg=;
        b=gyGzWrSfH978ZN3ewaxVkZ0j56XeILoU/TaeUXeFkcKt4GlWF/bgp8L1eQEKLasXyF
         mkfHtomVoJLQ14qsii+O+uQ0E/T4q2Yw8r7yUxa7sxhWZSNBiJ5+1oMPqW7GaACof06Z
         dptlSNLCggxDa8EM6yK/Sw8v0+jUgozazLg227BTLLk9jRXR5uCqo0BPMtJ+zhdzRTSZ
         owCHinRSXXfqY1KruWO6pLYCpH7HGYYv5LEmDs4b5+abbOFLBGynf+G7UoOqboQAt6I7
         p0lxJ2R3AdSmeeoQ91C7Vi6hxCkDCdt9VMsUqLOOkB5gMUkbzOjmGriGuihgig/02Hnm
         hL0g==
X-Gm-Message-State: AOAM533hXXHmLb86+P9USGbPKdslbMze2aIuf4EdVn03Yo63N0QKiM3P
        vYCuI2bybc9Sd5WpNCB902koUrJvPB+t0A==
X-Google-Smtp-Source: ABdhPJxF0R7zhHAezwx4KhdekrUB1Wo/7YUbjq7q12zEC42mFrR2mQvNAIGGAxCjALf/TiQBXzOPNw==
X-Received: by 2002:a05:600c:3d18:b0:39c:474c:eb with SMTP id bh24-20020a05600c3d1800b0039c474c00ebmr3891085wmb.87.1655209860406;
        Tue, 14 Jun 2022 05:31:00 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 20/25] io_uring: use state completion infra for poll reqs
Date:   Tue, 14 Jun 2022 13:29:58 +0100
Message-Id: <8ef49e3c8619395fe2d5d7e00e69f0af8d5cc9e2.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655209709.git.asml.silence@gmail.com>
References: <cover.1655209709.git.asml.silence@gmail.com>
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

Use io_req_task_complete() for poll request completions, so it can
utilise state completions and save lots of unnecessary locking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index ad25a964d4ed..2688201e872a 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -234,12 +234,8 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 
 	io_poll_remove_entries(req);
 	io_poll_req_delete(req, ctx);
-	spin_lock(&ctx->completion_lock);
-	req->cqe.flags = 0;
-	__io_req_complete_post(req);
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
+	io_req_set_res(req, req->cqe.res, 0);
+	io_req_task_complete(req, locked);
 }
 
 static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
-- 
2.36.1

