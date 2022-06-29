Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A08560387
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 16:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbiF2OnL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 10:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233719AbiF2OnK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 10:43:10 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0745E3B3CA;
        Wed, 29 Jun 2022 07:43:07 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 9so15522185pgd.7;
        Wed, 29 Jun 2022 07:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vU9PWXYSCVwK2HD98Bi9RXzfkNEc3MlCdXuIzL8BLjM=;
        b=kV6S0dTR7qBF+hKPQ4ZyGIcqI/5ELsMXybZok4HWcmFXwY6P6QV4iPlXVSLEPRaGH/
         Iig55w+hsRJAHCFCrBJAILTTA+vKZKvTNJYKLnEm/WKetu74Wcfv5uSOHO7bwL4Xj94w
         MdUpmSNHIfPjReEJDpXlqxM8RQH4+NmoT2JZYHKSKXWVpzYx6XKPZjGxRAmA5b7V2M39
         DhfrUP/FUcM4HAvEAkeRNBKfSo9+nOv57NvwpCDPA8in/8KLRayUVAlQVH93YwYKm+k4
         SOlaf+srh5BWUw5z1WZDVle+XnGifU9ofYhZ71JAPRl5yi9S6n6bYv06fKt+qmFWJ34I
         uung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vU9PWXYSCVwK2HD98Bi9RXzfkNEc3MlCdXuIzL8BLjM=;
        b=RVyJ634VQeRpYzlHmVtKkA8CB+b9AfxoZ9cPvbcyS2b59Q6/2Rk23E+Zbl3gYVqXys
         1pcKCA1LN7N3uvlECRRq6s54/v/D1OILI0thf+BrEX6EZjxZFNM2+84aCuYovgSI6UTh
         ow+PBBznYScTCYbJoZ6rlqYLwmMyBpwBekMhACfr6e46Dk/RQjdH9BeOmMywfdBaUCYS
         p19UM3tpZ+QLSYstTL141yiBxImI3IIP08rt/psafVm14qOjP2XSfYifXcKSYgj2CnH+
         vDGMI9AZgJdp5wCXV9Z0niAi/6IA8B/fT2bFEcJSN+ACWN+xX4GzxQ2wq6sxXljW7Nm+
         Pn9A==
X-Gm-Message-State: AJIora8TydAOlSBX2wU7owaLYmhJAMqOlBDeD6EiJ302eWl1geO/Nlq5
        bpQcwbk8OuvJMpJQ5l4EQJ8=
X-Google-Smtp-Source: AGRyM1tTC4orWU2Ewm4QQZVIWuJehACk8lYduRmIED3i2KCEQFlwCQ+ueZSQPJe2kj+JW1Ga4eOuXw==
X-Received: by 2002:a05:6a00:16c7:b0:520:6ede:2539 with SMTP id l7-20020a056a0016c700b005206ede2539mr10524571pfc.46.1656513787518;
        Wed, 29 Jun 2022 07:43:07 -0700 (PDT)
Received: from KORANTLI-MB0.tencent.com ([203.205.141.11])
        by smtp.gmail.com with ESMTPSA id cq13-20020a17090af98d00b001eeeb40092fsm2224281pjb.21.2022.06.29.07.43.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 29 Jun 2022 07:43:07 -0700 (PDT)
From:   korantwork@gmail.com
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xinghui Li <korantli@tencent.com>
Subject: [PATCH] io_uring: fix a typo in comment
Date:   Wed, 29 Jun 2022 22:43:01 +0800
Message-Id: <20220629144301.9308-1-korantwork@gmail.com>
X-Mailer: git-send-email 2.36.1
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

From: Xinghui Li <korantli@tencent.com>

fix a typo in comment in io_allocate_scq_urings.
sane -> same.

Signed-off-by: Xinghui Li <korantli@tencent.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d3ee4fc532fa..af17adf3fa79 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -12284,7 +12284,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	struct io_rings *rings;
 	size_t size, sq_array_offset;
 
-	/* make sure these are sane, as we already accounted them */
+	/* make sure these are same, as we already accounted them */
 	ctx->sq_entries = p->sq_entries;
 	ctx->cq_entries = p->cq_entries;
 
-- 
2.36.1

