Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C6C3169EC
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 16:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhBJPRb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Feb 2021 10:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbhBJPRO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Feb 2021 10:17:14 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F78C06178C
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 07:16:08 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id w1so965845ilm.12
        for <io-uring@vger.kernel.org>; Wed, 10 Feb 2021 07:16:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7KiSNvL09Qg07F+J0VuAZLLTmylaAuVEq99QmL67X4w=;
        b=0gZCuosqF6Wla36MlPRFEH4SPJbQdmtnq+Y8vaOL2EjVtQgxe/2xsdL5S0z8k3y/xS
         B/Az1PKADDn++vbv7acO4k9iMRfD9tW8c3xGtDJX9utGx8LJM4WvzhUZZH/+bLFe84ek
         OaUfXCnDvdViTxNdLuAnROQk8awE/raARCyonwIBGhA9ZvblJJ/XS5b2g6SZIhIfS7sf
         NtrW/YJAugGo9nXvWEfOMP7L881JMu+wABYIskyXGQVv8xIwtqzSwWZ5zF39iyiWyf9A
         WSoCfgCgjrUGulP8RGYa4XGq+MuM/giTaYYMXpKGskhFgc7j3uxflWpzh1gKhw8DeIiv
         8kUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7KiSNvL09Qg07F+J0VuAZLLTmylaAuVEq99QmL67X4w=;
        b=FL8gAMtzImzJVH/UpvvuXwuTL8oXH8THaB0HePaFhDhxXMFcvbUPnQEcepg77VIt0f
         RbwdrXPZmJnQUOEKGvGEmRSG4ERYSO6nF/M7bcvYEpVQbJagd3Lc3KqmW1+m7Ixj6v0n
         ilmswl1p00o+Ynx9hwJQ6b/rutALSWJvmzUKnSm54wI2NrSTeKucwNIHFoHhCaTWyMoZ
         jq9KWo6BljyOAIQxAa45uuUrVBvYKAzm2JCmWet8E0lY5OLfhGqr18lr2UxDQ4mX4wHA
         dFrPJl7FV7s7peaPigCsxjEn8r4nQ6yCka1L2QwAnUeOle1qLOonsp09KGyz07mbUDBV
         2fmw==
X-Gm-Message-State: AOAM533U6lyU5ZR/se9S/6M94Gh8zevDyXS2E/R2/OMdaFkhhEBkl9lT
        stncTIiuEIFpVJs5pmy7UC4POF2ro1ZME9D2
X-Google-Smtp-Source: ABdhPJzdOqaysdTAGUZQ4nlHIFS5hsb84ElxrX4M0mD3RpMR8DdjqOjPYsWbCK+RKfMDpS/WslAxBg==
X-Received: by 2002:a05:6e02:1c8d:: with SMTP id w13mr1476813ill.301.1612970167493;
        Wed, 10 Feb 2021 07:16:07 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e23sm1027952ioc.34.2021.02.10.07.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 07:16:07 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: enable kmemcg account for io_uring requests
Date:   Wed, 10 Feb 2021 08:16:03 -0700
Message-Id: <20210210151604.498311-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210210151604.498311-1-axboe@kernel.dk>
References: <20210210151604.498311-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This puts io_uring under the memory cgroups accounting and limits for
requests.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2c7ff0b1b086..bffed6aa5722 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10350,7 +10350,8 @@ static int __init io_uring_init(void)
 
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
-	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
+	req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
+				SLAB_ACCOUNT);
 	return 0;
 };
 __initcall(io_uring_init);
-- 
2.30.0

