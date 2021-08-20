Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06373F35C8
	for <lists+io-uring@lfdr.de>; Fri, 20 Aug 2021 22:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhHTU6i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 16:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbhHTU6h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 16:58:37 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6BFC061575
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 13:57:59 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id i8-20020a056830402800b0051afc3e373aso5630713ots.5
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 13:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=cvrb39HyCxNjoDrKeGtyQcBkhvQyc0OSXr79aXRT7p4=;
        b=Zp3EDoYRT0nNkgN+dLzCJTUsUtYYW+Zt0UJXpoLd3xpJx/+rATvvN0RVCmuFoqANsP
         /tWAFmCoPAMIOIpoYUfcV+D3UWEh1jlH5WFjBzBWulSvrnsPGrL7X0xlRHTG61+ZlPpy
         fBFHiTEt6oVrdt8SRD8cKyD734BExMWyhDOBq1lsQ52qsn2AVLzKwtaAqmH98FsulXtJ
         LmLBpBwD8elQBunTf3WFP6TEvs7LzRnAHw2k8jAeVJU9hl5umZB5qUe4juRaNGnDkflo
         3jTDZmWGuWIqjNYhAy+H0yPj/4FG85L4M9Vqrb427lDZtE7SbI4+nWQRBmG8aVqnreKC
         q3/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=cvrb39HyCxNjoDrKeGtyQcBkhvQyc0OSXr79aXRT7p4=;
        b=ZueHGe0f0C6uQvPJ6g4jljOZzp5k04EwrXe7Gx5oZunZi0qRkkG5/bfTw84V91PqPk
         s/xDZwNKoelQUwma6YRqXVIERaduWsca8Sr+Z2o5SGuZ21ubq95FictVJxxpkE5v7Dp2
         rcQCoXnBc1O0UDJ7Lkj+RQdRPcUSCXvyyQDkEOt62MLKcafvBo0wUYXhzUGBVphvycGT
         DT83eX97fngTYxDroEo4PkpMAuIYVMRljXg/OgvMHoZiDUlHbW6ezeH+ZeL2Gs/0aN3e
         7HBDxxuK8bdWEP7f7ZUKOBKWH8vj/DYzt1/VxSoILzHN/MyqjbFkvp2BULdYlG0426zD
         pDcA==
X-Gm-Message-State: AOAM532Vt/inbxkAipBtI5JoSU+pr8iyAUx5Uu06FKha0XjF1htM/7FA
        MUi4IywqztWa7lM4ATF+cg9cKw==
X-Google-Smtp-Source: ABdhPJxuBrNRsJRt6hGYQGLKX+rLtALRLaTu8Z6x5s9GwiS8Gcq2oCn3QTvSKh0Ug36P8pcJRWA++A==
X-Received: by 2002:a9d:7759:: with SMTP id t25mr10718665otl.245.1629493078830;
        Fri, 20 Aug 2021 13:57:58 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u127sm1729630oib.16.2021.08.20.13.57.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 13:57:58 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix xa_alloc_cycle() error return value check
Message-ID: <5ba45180-8f41-5a1f-dd23-a1fc0c52fd37@kernel.dk>
Date:   Fri, 20 Aug 2021 14:57:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently check for ret != 0 to indicate error, but '1' is a valid
return and just indicates that the allocation succeeded with a wrap.
Correct the check to be for < 0, like it was before the xarray
conversion.

Cc: stable@vger.kernel.org
Fixes: 61cf93700fe6 ("io_uring: Convert personality_idr to XArray")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 979941bcd15a..60851908ed6f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9843,7 +9843,7 @@ static int io_register_personality(struct io_ring_ctx *ctx)
 
 	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
 			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
-	if (!ret)
+	if (ret < 0)
 		return id;
 	put_cred(creds);
 	return ret;

-- 
Jens Axboe

