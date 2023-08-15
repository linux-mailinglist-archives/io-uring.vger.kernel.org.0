Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D6477D12F
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238922AbjHORdi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238921AbjHORdU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:33:20 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18F41BDF
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:18 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-99bcf2de59cso740605866b.0
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692120797; x=1692725597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kqrlD+pi9UzvW3ZlyidGj+8pb9+oKgMml6JbnDHNb4M=;
        b=o/363iN0dmQx4AoCSpF4WDtzf7bGX6WNw1FUZsM2UzgJZCOpAcfCNC6PlBKD8mNuAO
         jIxKCluGhN/gIsD0YISCPJ15dteEhKUyiWaO9aETAHW9H9g7t231q5vbUmB9Ejw7pe74
         U21/A3XAm+s0KiK6cu8bgpECtizAcpDLK/d7D/1hW2CgOtsq8uy9yzb+apC3gX/SzKqg
         woSTjDJQbazzVX6iK1LI/g66YqI+F61/vyFaWXJZgslsq5UdjsLYRKPii7t9Xzsw0alM
         Rqv1WvzJu4ODVSfiozqS2HACXm1NCaI9Et+HKvLaRWVAWaCJw6vzSjUuHGrgDDrlZPqF
         U20g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692120797; x=1692725597;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kqrlD+pi9UzvW3ZlyidGj+8pb9+oKgMml6JbnDHNb4M=;
        b=Kl6ZujPsfagpBNTwMn5wn4Rqhv+EPrzwSH8hjLMVArNs2uksGDKZaBeTaa4vYm+A2K
         9rjb08q2tT4qrP6QzG44kCGi1Ij040bYaIO7SwOdlKPYFfd1o+OIIn/WDX5wo7N8+oGw
         cPcSt2Bg4JH9pp4OxSm3e1K/NUdSfDIh4c9gQe8/8WBxRw8abQjbL4r5Yas6yyi8Ues1
         SGBl23MF5RYpLurU8DGl0SxcPYVez+eRcw0PEGzpRb7cCCcC14HGgd+/+nt3UlqtuPXO
         Cz4HQvb923uCIGZjzZtTzMp3b6SB2aVrxd2Airl1oppxwht+Q9+GzJmpOKOBkveQYr04
         8hLg==
X-Gm-Message-State: AOJu0Yw+AW6EkN6KCsGFhujJrJ+3TQI2VK6IgEaZmK9JTA6SYrr+iq5t
        2FYXO798e1U1gH9FwpUj2dn1xVZefLU=
X-Google-Smtp-Source: AGHT+IHrU3/yqt1LOrErz0gfYYdyHnHZrYcW0lij1h2t3/GgTm0tQVaLnjWNjzKxKEHs+wV9J/HuFw==
X-Received: by 2002:a17:906:5358:b0:993:e809:b9ff with SMTP id j24-20020a170906535800b00993e809b9ffmr10736047ejo.21.1692120796727;
        Tue, 15 Aug 2023 10:33:16 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6d35])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm7269878ejc.157.2023.08.15.10.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 10:33:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 02/16] io_uring: cqe init hardening
Date:   Tue, 15 Aug 2023 18:31:31 +0100
Message-ID: <731ecc625e6e67900ebe8c821b3d3647850e0bea.1692119257.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692119257.git.asml.silence@gmail.com>
References: <cover.1692119257.git.asml.silence@gmail.com>
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

io_kiocb::cqe stores the completion info which we'll memcpy to
userspace, and we rely on callbacks and other later steps to populate
it with right values. We have never had problems with that, but it would
still be safer to zero it on allocation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e189158ebbdd..4d27655be3a6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1056,7 +1056,7 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
 	req->link = NULL;
 	req->async_data = NULL;
 	/* not necessary, but safer to zero */
-	req->cqe.res = 0;
+	memset(&req->cqe, 0, sizeof(req->cqe));
 }
 
 static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
-- 
2.41.0

