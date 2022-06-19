Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A55DA550A2F
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 13:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbiFSL0p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 07:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiFSL0p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 07:26:45 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF446153
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 04:26:43 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id o37-20020a05600c512500b0039c4ba4c64dso6446453wms.2
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 04:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rMRvtbDCNHQBxhNWxo2d+tDiG3EmaLK8r3Cs02zPJ2o=;
        b=DmkY7i7OHUmYtcFyFDD9M9a2S964GRO1KAWAtU79Zhvnfty4eNo9Q1kL+SfyMhPyNH
         2+a25tAG6sG+lIRtDKUTfT2rJ/flo0dqMC0DpW+4HdfJwGQv9eMxek+R4Iew7vBbhhr0
         XczsbO2hQYCxynTZoX4iRQrJu4wF5Ma35BQCnYyZpdP2+pm5v8FIeya91JgiCaVaHj3c
         LKzP4oVR2cren+hY6+A4OxZhb3nS24FOILE1h2pvVOBwkbZAuHEiXtidca8REZ0bN9oy
         upbsHvWrgBYNbJUbuP7GCNtYA00Y5F/zvco00n51CLUj6kZXsHY0fAXTFkuP2rJtdmkg
         3/rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rMRvtbDCNHQBxhNWxo2d+tDiG3EmaLK8r3Cs02zPJ2o=;
        b=AVlWkuwv0iejTbUgQWkrGywxkZKQ+x6OngtB6X0zAzjit4PBQxb0N0k6XXTJkhdzvo
         PDJMvsKWUO1Tj46OWLqiYbBDjSNg+qem0RMnakyJGpMsX/KXH9yH+S4rXkrYN5tlH1yH
         wWvau7VUYmxCgrP5NhQ1Pk9Fi/D2G3gL8YdhUr0bTkHrGvb6pmXm7uQrN6WaxY01LVBt
         jVqdN1dkYt3acFw6ajjNGLOq+o+KGQXdFJW+QQfX7/dTNlumsMejkROINfOYAP2kGyBv
         mGJaTU2X8uBJmYIDbI9vHElphX0k6o/ycFDR9j+jX4pVGta6uQIJ8Vzp6k3YGxApVmxM
         rFXQ==
X-Gm-Message-State: AOAM533zQHcHw1lzFImZHO68sW71hYC9+CJqpN5FCeYW0iQf2ZQRAE7q
        qNkMUrDG/XJyrQ2o9F6rU/t+tHZhkBB/eA==
X-Google-Smtp-Source: ABdhPJxK5Zy30n3VZoiwCyWecgMTWIAW635maQ/GcRWq0Bc5+mmBcb4L70Mvov4+hqTYINGgXEEryQ==
X-Received: by 2002:a05:600c:4f81:b0:39c:809c:8a9e with SMTP id n1-20020a05600c4f8100b0039c809c8a9emr30391906wmq.39.1655638002126;
        Sun, 19 Jun 2022 04:26:42 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id y14-20020adfee0e000000b002119c1a03e4sm9921653wrn.31.2022.06.19.04.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 04:26:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/7] io_uring: remove extra io_commit_cqring()
Date:   Sun, 19 Jun 2022 12:26:04 +0100
Message-Id: <f2481e32375e749be89c42e4804268b608722cef.1655637157.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655637157.git.asml.silence@gmail.com>
References: <cover.1655637157.git.asml.silence@gmail.com>
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

We don't post events in __io_commit_cqring_flush() anymore but send all
requests to tw, so no need to do io_commit_cqring() there.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 37084fe3cc07..9e02c4a950ef 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -480,7 +480,6 @@ void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 			io_flush_timeouts(ctx);
 		if (ctx->drain_active)
 			io_queue_deferred(ctx);
-		io_commit_cqring(ctx);
 		spin_unlock(&ctx->completion_lock);
 	}
 	if (ctx->has_evfd)
-- 
2.36.1

