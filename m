Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F0D52C5A6
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 23:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243227AbiERVgf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 17:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243226AbiERVge (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 17:36:34 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62341312B6
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 14:36:32 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so4713085pjb.1
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 14:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=GCrsoYoJogRw4suK6Mtl2SFfz8POK/GVn4txr+5xPAM=;
        b=A67y/eFMCiFRtcXbuLlQGXKgI8P3NBLyGlKTk5twtaYl1ZT3J96/oUuOojF9kL9ROV
         xLPBG/HQvUZIsDCvFPY6YV0gdOSJoU7CBVJIdiFEThRaUT9mvrkswD1Qorib7KPtC9+C
         xQp0VK+BMK/SXkfvE/PrAdz3mL1Dq8Nl7qPjp0T359jI3iMn0IYIlZh53CZvN4I1Yy+1
         DkHtTbPSi+I1IDQZm/LRCDPes1mFxbH5xArbkvJB1emgNEUhLX4v3uxwiwFE/Zsp0Go/
         b+hN59DJ0gabqIzk3/4m7X+6WaS7kIMTPgFxgfhz+LAFuYtjTgwE0Qpl8BxbtVFaxxQJ
         WSXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=GCrsoYoJogRw4suK6Mtl2SFfz8POK/GVn4txr+5xPAM=;
        b=OlMFPpvvxLUC4LMtSTi+Lr8W1uaVDyRU2Qsd6uF4+PiNac+ns+QIG+owJsN6U/38yT
         UVYtIAobLyUQA5LANI6aq2xghlLHgskG5YN54RdxYg/Ngo+DWzz7exZWEnucMckEoJ+a
         TvD3R59XgsE8U7PVGfypAOiytRQSg0sQ73ev/k7vamG8Kpfb9ybpRHCXcx0NiMtOC8bk
         VjzVQKyHp/ITV1O81oPDgtpivFmwM5prfGvwPh6K/bPxREOW0yyAP76qmNlc0NDvetlf
         NTsuYsq4XAJ7oiepryUipDCF6wDhv3XJS+Ap3sbczCb6Nnh0D3ynElW4P4SBCaiF4Szv
         kCYw==
X-Gm-Message-State: AOAM530+G7msb3UZ+aF71Xd3f7TVEHnwEp25Sz4+OvYIoKj938abrOdC
        Cb7e3FKSW/jxG0xgP9FyITU4fQ9V/lfC8g==
X-Google-Smtp-Source: ABdhPJzLzXJ6mnSHd0RbY9qlClFWvLlqGvLomm3xwHxcMeoCwymbofh8/Bzb7kLALe9wLbXXiuvXHA==
X-Received: by 2002:a17:90b:48d1:b0:1df:4fc8:c2d7 with SMTP id li17-20020a17090b48d100b001df4fc8c2d7mr1471685pjb.45.1652909792032;
        Wed, 18 May 2022 14:36:32 -0700 (PDT)
Received: from ?IPV6:2600:380:7454:420e:4a75:de43:4286:5c17? ([2600:380:7454:420e:4a75:de43:4286:5c17])
        by smtp.gmail.com with ESMTPSA id j7-20020a170902da8700b0015e8d4eb1ffsm2165853plx.73.2022.05.18.14.36.30
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 14:36:31 -0700 (PDT)
Message-ID: <8909354e-4fb2-8a71-cc22-6d8be092f835@kernel.dk>
Date:   Wed, 18 May 2022 15:36:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: disallow mixed provided buffer group registrations
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's nonsensical to register a provided buffer ring, if a classic
provided buffer group with the same ID exists. Depending on the order of
which we decide what type to pick, the other type will never get used.
Explicitly disallow it and return an error if this is attempted.

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 24d56b2a0637..065ea45de29c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -12156,9 +12156,11 @@ static int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	}
 
 	bl = io_buffer_get_list(ctx, reg.bgid);
-	if (bl && bl->buf_nr_pages)
-		return -EEXIST;
-	if (!bl) {
+	if (bl) {
+		/* if mapped buffer ring OR classic exists, don't allow */
+		if (bl->buf_nr_pages || !list_empty(&bl->buf_list))
+			return -EEXIST;
+	} else {
 		bl = kzalloc(sizeof(*bl), GFP_KERNEL);
 		if (!bl)
 			return -ENOMEM;
-- 
Jens Axboe

