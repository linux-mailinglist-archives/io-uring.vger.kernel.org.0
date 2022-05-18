Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28F652C4F3
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 23:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242784AbiERU6P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 16:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242719AbiERU6O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 16:58:14 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E1F224A6D
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 13:58:11 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id s23so3623675iog.13
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 13:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=azbd1abROtgweJN6zdFM9rmUK7md1SqXvt0jJoWC3e0=;
        b=m31RpxprfgvqbBsk9p+jcqzePwkTbi6gAqUyBxe/YTZFyEYDJN3YkFCz3o+d6Hm6EL
         IvrxkMi6yNm1dxGEcEh1tUZEjdjPlTr0ljRGFvDcbxOxh2UdahUQfFpWzl2nbdUaGpJS
         KJRHwLLSwDnunByE/JdNbyygYKMTa62EbmY2u46AkJmi5yj3A/l0eaXVQIauA/OAJ4kQ
         C4d/2zDIkceM6XAB/J+miO7c3fZriSOEfI7SBxNADoG7LN+39vyc2ptweFWdgkqUGqSJ
         lheGzF1dXIK2mZV4xKcua3mBy4C8wmbIehlEHgnhRsfBVKvYWcWnn9zlk2SkUL6qZdsy
         MHpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=azbd1abROtgweJN6zdFM9rmUK7md1SqXvt0jJoWC3e0=;
        b=ZcCN8mFjZxNghUkJa7bPfVn5ax2MjCOEQIyEB3zXg9/wQc2Tyn+2+djR48vpYmRvgc
         Wa6sskFBg3Wb44HHya6xJvskQMGj8j+/+XvYwQT5SsSZSga6EI6bnT6lgCQbuHGrVQiB
         IGaTdiepKzXjuUi2MIDSr62aqdZneqcX6T8eJgCwz/mi1YCD/5PLUDeISUOgIbDiQDYg
         TsVBWRFH6RvnZc33qMbg/LSAzP7fPl2Tj5wYNGYG9Dp/7kCfwub1ZmVuHNyxbRhYeyAy
         Ne2yMda1QdpqYzK40oS8S6w9imCMRcggqjeyYZUgn6E0oZHYrXvN5gBuL1hSG5K3u04i
         hQMw==
X-Gm-Message-State: AOAM533TLpvVvygeM0fibIR8qTazk1j4NCux/fdl7iFnn8i1+pt0VsjA
        NiRDoFu9VEMSNJMKHAMLQvgcq10HRoGKsA==
X-Google-Smtp-Source: ABdhPJz7e7BfvJh/1wNrGxFqVbyIVRoCAZBBvEZTcKaRSrZwvbC4aAxFcFfmYGkSYBX8A6eclPrkTA==
X-Received: by 2002:a6b:ed0f:0:b0:657:b1ff:be52 with SMTP id n15-20020a6bed0f000000b00657b1ffbe52mr738242iog.34.1652907490482;
        Wed, 18 May 2022 13:58:10 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id bo25-20020a056638439900b0032e211cff48sm147563jab.102.2022.05.18.13.58.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 13:58:09 -0700 (PDT)
Message-ID: <a82c956e-2d75-90b8-cf2f-d07c96666859@kernel.dk>
Date:   Wed, 18 May 2022 14:58:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: [PATCH v2] io_uring: initialize io_buffer_list head when shared ring
 is unregistered
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring <io-uring@vger.kernel.org>
References: <6d49f50d-52ca-a12e-8f7e-99db5b97ff9f@kernel.dk>
In-Reply-To: <6d49f50d-52ca-a12e-8f7e-99db5b97ff9f@kernel.dk>
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

We use ->buf_pages != 0 to tell if this is a shared buffer ring or a
classic provided buffer group. If we unregister the shared ring and
then attempt to use it, buf_pages is zero yet the classic list head
isn't properly initialized. This causes io_buffer_select() to think
that we have classic buffers available, but then we crash when we try
and get one from the list.

Just initialize the list if we unregister a shared buffer ring, leaving
it in a sane state for either re-registration or for attempting to use
it.

Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2: do it in the place where we clear buf_nr_pages, that's safer and
    cleaner.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a210a2c0429d..24d56b2a0637 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4969,6 +4969,8 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 		kvfree(bl->buf_pages);
 		bl->buf_pages = NULL;
 		bl->buf_nr_pages = 0;
+		/* make sure it's seen as empty */
+		INIT_LIST_HEAD(&bl->buf_list);
 		return i;
 	}
 

-- 
Jens Axboe

