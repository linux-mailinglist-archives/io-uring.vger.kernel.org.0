Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16833F35CC
	for <lists+io-uring@lfdr.de>; Fri, 20 Aug 2021 23:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239861AbhHTVCA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Aug 2021 17:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbhHTVCA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Aug 2021 17:02:00 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0726EC061575
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 14:01:22 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so16885594otf.6
        for <io-uring@vger.kernel.org>; Fri, 20 Aug 2021 14:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GuQP5Vq50BdAe/DB0eVsKX1zy4bMMWwFOLi7CZbQQEg=;
        b=JmXrGmR/PWjaxXiOqVNGORCF/FEjhXjme5tTvS2elTM35qSOSA9HixkiB4i65wSmBa
         Ij59IpqGmtAwmphMEl1CWiqdUwxoBPm3D+SVXgOu6rDZJcUmI1RpLcHb/ApkdWAoSr3l
         0h1qVXhANIPUp+xKzUv9VFZrM2dk2SGmi+1chpVMkleXlyNYsAhO9oAPVL2RlswQjdT4
         YljXt1MHKolGwffxVfSwcv9WXnG+KhjSoEP7kzoe48jQQOgMrjYY7UTkf1SWmhWYBfzB
         HIA+4dcfm1gu4xuvvouXnQhRoknKI1hcCzMxNJVUHbEICM5VntFDlDruuyRPsJUYQhFO
         nxBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GuQP5Vq50BdAe/DB0eVsKX1zy4bMMWwFOLi7CZbQQEg=;
        b=D0ru8irUe04N5sknOL8dGkwAUUNwnpcQR8uuRsS22xY6/qfSWtLZg1uMW1JdCqEWe/
         CAW8VX1JXVqjr/cGn4J4xW9JVxwTPUWl9WZUuly/zEJNMU4XlGGCo7oOxl+Y56PpnSEu
         B2i50j6GufJPmcy01tZ5oxk+SK1gD/E5k1UOBFbPoM3KC8vFZUA/342NAJ41lfi1/Xr+
         +7o8yrPS3khGXZzBffuNrmL/1EkUAumLg1ZnO855HsPwx2DziNqK+GWI7jsVaaIgoLFT
         MXFDVvFBnTnmKnVPJrgFlDCBiJECGq/tjaOJR3H+D+HQFHSbIAQJWcMyaCfiXQqKR8qo
         5AHw==
X-Gm-Message-State: AOAM533QVd0KaCRnhFasJ8kkUteEuvQhrlFiPgHswO1e7if5572WqQdS
        7BEpK7RqCB0KMG7ILaWsQu3bmg==
X-Google-Smtp-Source: ABdhPJw01Dko5OuxfKuTvGxyBbPH/eMZuWnkV5KJs1WYOLyggrK4YX05IMUv9i24pK6oFGExR3aShw==
X-Received: by 2002:a05:6808:1449:: with SMTP id x9mr4373205oiv.14.1629493281403;
        Fri, 20 Aug 2021 14:01:21 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id bg9sm1730777oib.26.2021.08.20.14.01.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 14:01:20 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix xa_alloc_cycle() error return value check
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>
References: <5ba45180-8f41-5a1f-dd23-a1fc0c52fd37@kernel.dk>
Message-ID: <fc798a75-0b80-7fd7-9059-2072896038af@kernel.dk>
Date:   Fri, 20 Aug 2021 15:01:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5ba45180-8f41-5a1f-dd23-a1fc0c52fd37@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/21 2:57 PM, Jens Axboe wrote:
> We currently check for ret != 0 to indicate error, but '1' is a valid
> return and just indicates that the allocation succeeded with a wrap.
> Correct the check to be for < 0, like it was before the xarray
> conversion.
> 
> Cc: stable@vger.kernel.org
> Fixes: 61cf93700fe6 ("io_uring: Convert personality_idr to XArray")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Gah, included a debug patch, not the fix. Here's the right one.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 979941bcd15a..a2e20a6fbfed 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9843,10 +9843,11 @@ static int io_register_personality(struct io_ring_ctx *ctx)
 
 	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
 			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
-	if (!ret)
-		return id;
-	put_cred(creds);
-	return ret;
+	if (ret < 0) {
+		put_cred(creds);
+		return ret;
+	}
+	return id;
 }
 
 static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,

-- 
Jens Axboe

