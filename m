Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71A8510E63
	for <lists+io-uring@lfdr.de>; Wed, 27 Apr 2022 04:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343798AbiD0BxZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Apr 2022 21:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234615AbiD0BxX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Apr 2022 21:53:23 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7397415FC1
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 18:50:12 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id m14-20020a17090a34ce00b001d5fe250e23so533503pjf.3
        for <io-uring@vger.kernel.org>; Tue, 26 Apr 2022 18:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f5COvJUbvjw7GvbNCbnWAK63RvEtdrYpgw3+45PvfRE=;
        b=JAjx+hCXRViImn6MN48SwtAEarZZZ6ESp5tDjk04DlRq8Qg3+7KmbpqeW77t/yx1Lv
         2XGPg9I3pcgdoom3k7c5NRXAcdyjpKfvkmDj+eGp08kjrXlNObVpoBBIjsTMLKfj/s+z
         WoRzA9XeAYL+T1nSK1nYWJOZfCJJyBCjLR22TAGKaqqPfcCqn8VdLvoq6M7ztw2teJHI
         vMkunrgGfgu08Fp1bhXfEXBk9PnOAFrdl3uedmYBAem9sEhmOrg20E+bmMr5zkTjBJT5
         sjJH2fHxpT7Xltf8x3o+Pg1F9pJBpyjIg+dIO7kl2xlEfY3DbUeGsAM11IQQZZ20NqU0
         a1+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f5COvJUbvjw7GvbNCbnWAK63RvEtdrYpgw3+45PvfRE=;
        b=l3RQSGtWrnbFlJo+7kPMjuoAeJ8HXV56uc98rH4QZ/cMquUUHKOikE/Iceb1tPTeGH
         cq5WJfYqONGtDrlr1Vc0nCsnuHkaFMLyD1y7RU05neNg5bHRUjrGU7eOMuEb8zB5T/+l
         3gwwjXfzywYI8ISm4WEXPSItxWCdckRg1Mk9iq0VkTKy/MVCgON++qnDoDB48Bl0bMHw
         vk/v2G6VnPvvEliqkn+qyWuPHcTEb/T7tNawS5NON+i3ne2icOW0H8y3Rwmw2KVU+1I2
         JOsikQ8SJ3Zt2ZfxuxWwMAirQSnEsxXBV3cTNA+gVvHZayuHRokKecWKzN8lfQio/Jrt
         CasQ==
X-Gm-Message-State: AOAM533emJuCljyQHPvN3OluLjqA1aLbx8TY/zwIu5xwI5IHgOWaT1MZ
        3V2LyBDNw0wCWTusHpkVVZYhlQnahIRhw6fB
X-Google-Smtp-Source: ABdhPJwrbPw0HyJ37bdDsAk9BYy49eHHMnL3Gh904YHkeesOnwkpnoahJ1tvJhdOkM8KoBFroGhuyw==
X-Received: by 2002:a17:903:110c:b0:14d:8859:5c8 with SMTP id n12-20020a170903110c00b0014d885905c8mr25939395plh.156.1651024211590;
        Tue, 26 Apr 2022 18:50:11 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j2-20020a17090a734200b001cd4989febcsm4554547pjs.8.2022.04.26.18.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 18:50:11 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: check reserved fields for recv/recvmsg
Date:   Tue, 26 Apr 2022 19:50:07 -0600
Message-Id: <20220427015007.321603-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427015007.321603-1-axboe@kernel.dk>
References: <20220427015007.321603-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We should check unused fields for non-zero and -EINVAL if they are set,
making it consistent with other opcodes.

Fixes: aa1fa28fc73e ("io_uring: add support for recvmsg()")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 072fe4e9985f..f1a9595ba4c2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5535,6 +5535,8 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
+	if (unlikely(sqe->addr2 || sqe->file_index))
+		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
-- 
2.35.1

