Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 982B5443642
	for <lists+io-uring@lfdr.de>; Tue,  2 Nov 2021 20:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhKBTJQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Nov 2021 15:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhKBTJP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Nov 2021 15:09:15 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E22C061714;
        Tue,  2 Nov 2021 12:06:40 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id t21so310883plr.6;
        Tue, 02 Nov 2021 12:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KD6yB5psvZNrJnnHTB8Jxphyebs9ahRXN64rb6cr51A=;
        b=HJWwEhabXC10M7O+A1xQJMQsh+3Jxu0e1iR7fUjKKlzaayM2xzBaKpVM+MHVWJHGkT
         Z0DF/GXs5mWdO2m7g6qgjx06kCJU1RJBooTGX20QURzxHEIfof6o3o84fAdDh2Sw12bX
         bF4+KAwxh7jKYzHAsB79/A9SEXSzO7olgFA/QCeLsyGOfngFmsPgbxbz2rs/gVSt8ytb
         TIn64ENZ7gaMJBEEIaSOZUc7+GWC9QJemYT5wrIoSotqdV2nnR429/o+5cH3/1lg2DPu
         1/LnFPJx1e1FNYlnG4jMDnh+/NRWon3ofvXAtubZXBy9DzUJU3grQmyB/S1CMqXalNhl
         PwoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KD6yB5psvZNrJnnHTB8Jxphyebs9ahRXN64rb6cr51A=;
        b=RtFjJ8kdIJxclRKY6PQgbB6w9yVsbkV6LkU2NNsa01Od7fKh6nX7MpUl7lnDDo7v9W
         EjxFRR34L6eabMEfEtnO2QaP9B1WFjLc7L32tuFiu0XaI6UCydEyL4qlXBYUxxv8/MuE
         hZCG/VVkmiJGfZOy0ceVpSo8HuZZovvm/nUQ6wwFLicFaApaANXZOrXdcut8Dgej4VJq
         IFRq4JiNTlVw2oJ9zb80yRyk5oelZHtXtgewxXXIaoo+wxcdOTa5VpjYfOp2+ZCq9YR5
         7YcbLWS3kRtaTXqYJyFkwG/z1CMKeNJHrBDiy5LMOg1XHh0v5/p7qNAL0wHG+IVPOqZ8
         gc3Q==
X-Gm-Message-State: AOAM532EhIMpTIi6JP5qh0n9oQLX8c0zrhYoXTV8QxyhLjLOpJxpb3wa
        a2PeOq81ktExTx0L6pqwqLNBydl56XM=
X-Google-Smtp-Source: ABdhPJyK7xTvKQ7AKN67iFH+Skn5u9PtC9bWkqglamnr9Y/uUq71uYmwvwjrGtuABNaT1hWI7Ths0A==
X-Received: by 2002:a17:90a:800a:: with SMTP id b10mr9040101pjn.162.1635879999813;
        Tue, 02 Nov 2021 12:06:39 -0700 (PDT)
Received: from localhost.localdomain ([171.224.180.34])
        by smtp.gmail.com with ESMTPSA id on13sm3491528pjb.23.2021.11.02.12.06.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 12:06:39 -0700 (PDT)
From:   Nghia Le <nghialm78@gmail.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     Nghia Le <nghialm78@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, lukas.bulwahn@gmail.com
Subject: [PATCH] io_uring: remove redundant assignment to ret in io_register_iowq_max_workers()
Date:   Wed,  3 Nov 2021 02:05:21 +0700
Message-Id: <20211102190521.28291-1-nghialm78@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After the assignment, only exit path with label 'err' uses ret as
return value. However,before exiting through this path with label 'err',
ret is assigned with the return value of io_wq_max_workers(). Hence, the
initial assignment is redundant and can be removed.

Signed-off-by: Nghia Le <nghialm78@gmail.com>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index acc05ff3aa19..d18f1f46ca83 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10800,7 +10800,6 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	memcpy(ctx->iowq_limits, new_count, sizeof(new_count));
 	ctx->iowq_limits_set = true;
 
-	ret = -EINVAL;
 	if (tctx && tctx->io_wq) {
 		ret = io_wq_max_workers(tctx->io_wq, new_count);
 		if (ret)
-- 
2.25.1

