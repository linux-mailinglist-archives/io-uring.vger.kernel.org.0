Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1973C553ED3
	for <lists+io-uring@lfdr.de>; Wed, 22 Jun 2022 01:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiFUXBR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jun 2022 19:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354570AbiFUXBP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jun 2022 19:01:15 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533691E3F1
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 16:01:11 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j24so202736wrb.11
        for <io-uring@vger.kernel.org>; Tue, 21 Jun 2022 16:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0bWN01KDsEtX3px5S5dycuW8Av5BE9tOjbj4Zfv5AN8=;
        b=YeVjH9CPFWBiPpKKP35U4UyXqK5bs/aCplRrCY8Pau0oprbJdQRrazlN1/UiaD0Aef
         ysBxXyLBG+pnr6TR8tfYjWINONXyNphQPyd4bGYFGiHKGJfU+DToyhlCnFLIy4qK54N1
         glxukjXpvTUsjb6LZ1ibDnEY8fash3pxNNoMm8h23ud+Bc+MZ3bG7qSpNOp0w1gs+SXJ
         QJqDzKib4dzqZowZ7vTcsDahnaQiRqTxcF8joACgPMlK8pevyq0adrcyxPMwkrrGODvl
         4z3eTXNvkupGHZIjVifODxRSzSr/sRW+6KKwc7d3T307lVmicRofHBLlFYK+GYMj2XEH
         F7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0bWN01KDsEtX3px5S5dycuW8Av5BE9tOjbj4Zfv5AN8=;
        b=drfyZBOOwvwlVit9K5p4ACp1Js6yRYVlMLTN8Dfj4pqM7OQpDkc0BnRCxIRERC0HoQ
         zCy1ecZjWDvLl9SPSC7ZmpFa4LucSFPRSWbQ4OCBgty3v/IHIeLjrxgSIQRcLYNWu2nj
         eSxO+WOcd25q/BTqg3qXKxtZnPUFdrUhOzxhQjKA5rlxuDcEq+3YrHVYATP615QdotnL
         gh3BFHiwK2D+rF5FSa/ljbMCorfia+RnAld33J4aQuvvGkqBedEm6hRlUnPuM2oOaU03
         UC386ySOQd+1usm7k7qvQld4UonInj/2PeKuYs+NeLmZlzwI2EmtwadE/7GtXkR03YLf
         ndgw==
X-Gm-Message-State: AJIora+jNIspLSDKqkO5o1Gt9h1hXf7J6iBsUQIIIlaBjKz8ArYdV3mc
        6JmSDSYzhgVA7ptmM0W62RBTvbKeNew7MxEb
X-Google-Smtp-Source: AGRyM1ssh9izaB49b/HERb/lzllvntfVZSo3Pt5gzGWFudaeLvApG3aS/y8OEO/Tadzq4QIN9T6aag==
X-Received: by 2002:a05:6000:1542:b0:218:549a:2a8e with SMTP id 2-20020a056000154200b00218549a2a8emr297171wry.314.1655852469598;
        Tue, 21 Jun 2022 16:01:09 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id q2-20020a05600000c200b0021b8ea5c7bdsm7630462wrx.42.2022.06.21.16.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 16:01:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.19 1/3] io_uring: fail links when poll fails
Date:   Wed, 22 Jun 2022 00:00:35 +0100
Message-Id: <a78aad962460f9fdfe4aa4c0b62425c88f9415bc.1655852245.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655852245.git.asml.silence@gmail.com>
References: <cover.1655852245.git.asml.silence@gmail.com>
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

Don't forget to cancel all linked requests of poll request when
__io_arm_poll_handler() failed.

Fixes: aa43477b04025 ("io_uring: poll rework")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dffa85d4dc7a..d5ea3c6167b5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7405,6 +7405,8 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 	ipt.pt._qproc = io_poll_queue_proc;
 
 	ret = __io_arm_poll_handler(req, &req->poll, &ipt, poll->events);
+	if (!ret && ipt.error)
+		req_set_fail(req);
 	ret = ret ?: ipt.error;
 	if (ret)
 		__io_req_complete(req, issue_flags, ret, 0);
-- 
2.36.1

