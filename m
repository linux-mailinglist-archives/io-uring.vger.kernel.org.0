Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94ED3516486
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 15:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345720AbiEANSW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 09:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244714AbiEANSV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 09:18:21 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E9121278
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 06:14:55 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id p7-20020a05600c358700b00393e80c59daso6838755wmq.0
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 06:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=wGvWTA7UTGCuzp4vaaTrcp0XZxn3arcBlXx2YP3/ovQ=;
        b=esKecL6Bv2lF401F+vvJ2Q/cw1SzRQepwFweMnlg5cw4DMrpMDkgKCaHhNo6OVIS+7
         ailUm1PS0aGE78XtNZ7oLV6tXbwEbIYa6UG1t0DNJwe8ZoRbO5whzIqW/iAnuPZHTzJ2
         chmuiWna+xXs+VORT/MNy/pPf3KGOlA+G5Ld4eaLS0fQxo+1KqFGT67rmyztsVDlk+nn
         l2fSXuDz+tP6GMJTI2bxmGa1BoYkjhUbYyd5u4fLps2bkcPXlr5rED7/88t1yXD6QGhv
         eCMg1a+vTChXlwee0qRmbFTTJPCO+sSWWHXK+3CqP+nEB3dUXhZCVdrXtRfkl4Lj+neh
         IzrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wGvWTA7UTGCuzp4vaaTrcp0XZxn3arcBlXx2YP3/ovQ=;
        b=RrDSczHzqNxxohV1LLln1UD+D1Z0foBCtHHpFJRreczuL8yMT3C41CtiOgwXm273XR
         HHaNpNVSHkzMeuxJTriUemQJbb3DKa/aEJYQB1FUG07od0eF/4+/bBbbu5ytdxvPIkf/
         MJBGcupEKuQUV6UOm3dl/VIQ+PMWZFX5p4wp0E4/Uqx7TqajnGAdJE2Ra//c1NJ/MLnW
         0xaEX/WIwYzGxUnJY98aLYjs9Pm5vTxI+T5+h+/d0bSQSWQdNyVhFsVJML88CNjfTLYV
         xxpw/FalDrZncYo47ksFx7pk7v1KZvkr/s2ioHoGyC0X4+XTiYco86mYgEnlE/SwVPax
         eqGA==
X-Gm-Message-State: AOAM53161zcl6UWN4vfeBZUlK6Bn5PCTdyqJp816o7Cm7+dTvo3U16NH
        1xW1i9JZODx0FbaZhyQXdX9j9xW+27k=
X-Google-Smtp-Source: ABdhPJxgORnFwWE1Iya51DiW3XOEN5orGe3smo0/lvv7SWOzqQv4s2K1q1ewZqIbZKhfR73FjrCENw==
X-Received: by 2002:a7b:c403:0:b0:38e:7c57:9af7 with SMTP id k3-20020a7bc403000000b0038e7c579af7mr7191237wmi.144.1651410894122;
        Sun, 01 May 2022 06:14:54 -0700 (PDT)
Received: from [192.168.43.77] (82-132-230-158.dab.02.net. [82.132.230.158])
        by smtp.gmail.com with ESMTPSA id p3-20020adfaa03000000b0020c5253d8dcsm4827099wrd.40.2022.05.01.06.14.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 May 2022 06:14:53 -0700 (PDT)
Message-ID: <69fc3830-8b2e-7b40-ad68-394c7c9fbf60@gmail.com>
Date:   Sun, 1 May 2022 14:14:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCHSET v2 RFC 0/11] Add support for ring mapped provided
 buffers
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20220429175635.230192-1-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220429175635.230192-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/22 18:56, Jens Axboe wrote:
> Hi,
> 
> This series builds to adding support for a different way of doing
> provided buffers. The interesting bits here are patch 11, which also has
> some performance numbers an an explanation of it.

Jens, would be great if you can CC me for large changes, you know
how it's with mailing lists nowadays...

1) reading "io_uring: abstract out provided buffer list selection"

Let's move io_ring_submit_unlock() to where the lock call is.
In the end, it's only confusing and duplicates unlock in
io_ring_buffer_select() and io_provided_buffer_select().

2) As it's a new API, let's do bucket selection right, I quite
don't like io_buffer_get_list(). We can replace "bgid" with
indexes into an array and let the userspace to handle indexing.
Most likely it knows the index right away or can implement indexes
lookup with as many tricks and caching it needs.


> Patches 1..5 are cleanups that should just applied separately, I
> think the clean up the existing code quite nicely.
> 
> Patch 6 is a generic optimization for the buffer list lookups.
> 
> Patch 7 adds NOP support for provided buffers, just so that we can
> benchmark the last change.
> 
> Patches 8..10 are prep for patch 11.
> 
> Patch 11 finally adds the feature.
> 
> This passes the full liburing suite - obviously this just means that it
> didn't break anything existing (that I know of), the only test case for
> the ring buffers is the nop peak benchmark referenced in patch 11.
> 
> v2:	- Minor optimizations
> 	- Fix 4k PAGE_SIZE assumption
> 	- Style cleanup
> 
> Can also be found in my git repo, for-5.19/io_uring-pbuf branch:
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.19/io_uring-pbuf
> 
>   fs/io_uring.c                 | 463 +++++++++++++++++++++++++---------
>   include/uapi/linux/io_uring.h |  26 ++
>   2 files changed, 370 insertions(+), 119 deletions(-)
> 

-- 
Pavel Begunkov
