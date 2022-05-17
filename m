Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CB352A0E9
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 13:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242156AbiEQL7k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 07:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241059AbiEQL7h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 07:59:37 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792D83D1D5
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 04:59:32 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id pq9-20020a17090b3d8900b001df622bf81dso2025790pjb.3
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 04:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6bJrUMEtSXW29jAE/Fjd7T3L0w+l4E7RzwnxxvWAHe8=;
        b=UdBUPa4BMmyVFV5X3dWdrK5zqOmwHha1ptAMFhb8SL2rLlIo8AJ7FPnik2YMvmrMNJ
         ssOSsgM68lwN9ni0KROmiFhQhUGA4jnWcKve9u9NTZpMUEVLpXWNcVVL9TtHdm1lsm3n
         8uKLB1B12pw89azmhp4NoaMee8WYe+e+VwTeAtWTf8Pz03PxTue+HF3uKTRzwN3yRtZ/
         74yg+cjsn0uG9sn7dwxBFMdcvwg59p+fgSXVCoTD9+jXrR3Be2M3d5CB3IDo5qSkoSHC
         OOhgfXy1WNDCDYuk069fDYph/30/E8H01USHxlHNJteGyXNMele7XSZHxfA/Agdm4/pW
         KuyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6bJrUMEtSXW29jAE/Fjd7T3L0w+l4E7RzwnxxvWAHe8=;
        b=Ll/RqwNHS6nt/f1X+yE442FvFPZzOzJiNsTFwD4jNItQ3zxXW0v+Pzs249ADSSej+7
         rMccUvTDBGCD0tUtlNzyNWOHmf8COEn1cn6dh83rb4FzoC9bWwGgJrZAJaa8PE5AwVzi
         Vg4tMrm1yPwwLmLHRwNOJw7k3ebOPmlNqY409PKyqORuXrGt/osYczVDWcYba6wNm5+J
         15FDS4jhMe38TYUizl8nhHz6QKTWyM/icY8ope9bc/YC5c1WcdAEHG16ihdWgsF9CYwb
         qT9hZvxkQp4xNjl6+JzVMtXyN+EotsHUqTABcnGuUnR7tsWwYNqHOw0sgeDdHsGKKU6s
         MCSg==
X-Gm-Message-State: AOAM531xR/c5jxhmKvMPLpoQCXA6SrpHhdN6nwx1xN9uLuz7oBZs7Ocd
        4wRhd3YhvOw9RX784QfV0h1YAQ==
X-Google-Smtp-Source: ABdhPJwDn9mKzuaqQbJzdWhprI6qSVJpv42TdCp8EjfKceUOQHBlOuV1qwFmHJTb0yOW2zx4jDf/cg==
X-Received: by 2002:a17:90a:de02:b0:1df:3f94:811c with SMTP id m2-20020a17090ade0200b001df3f94811cmr12865265pjv.112.1652788771667;
        Tue, 17 May 2022 04:59:31 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c17-20020a17090ab29100b001dc7623950csm1481322pjr.11.2022.05.17.04.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 04:59:30 -0700 (PDT)
Message-ID: <97cba3e1-4ef7-0a17-8456-e0787d6702c6@kernel.dk>
Date:   Tue, 17 May 2022 05:59:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [REPORT] Use-after-free Read in __fdget_raw in v5.10.y
Content-Language: en-US
To:     Lee Jones <lee.jones@linaro.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <YoOJ/T4QRKC+fAZE@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YoOJ/T4QRKC+fAZE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/22 5:41 AM, Lee Jones wrote:
> Good afternoon Jens, Pavel, et al.,
> 
> Not sure if you are presently aware, but there appears to be a
> use-after-free issue affecting the io_uring worker driver (fs/io-wq.c)
> in Stable v5.10.y.
> 
> The full sysbot report can be seen below [0].
> 
> The C-reproducer has been placed below that [1].
> 
> I had great success running this reproducer in an infinite loop.
> 
> My colleague reverse-bisected the fixing commit to:
> 
>   commit fb3a1f6c745ccd896afadf6e2d6f073e871d38ba
>   Author: Jens Axboe <axboe@kernel.dk>
>   Date:   Fri Feb 26 09:47:20 2021 -0700
> 
>        io-wq: have manager wait for all workers to exit
> 
>        Instead of having to wait separately on workers and manager, just have
>        the manager wait on the workers. We use an atomic_t for the reference
>        here, as we need to start at 0 and allow increment from that. Since the
>        number of workers is naturally capped by the allowed nr of processes,
>        and that uses an int, there is no risk of overflow.
> 
>        Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
>     fs/io-wq.c | 30 ++++++++++++++++++++++--------
>     1 file changed, 22 insertions(+), 8 deletions(-)

Does this fix it:

commit 886d0137f104a440d9dfa1d16efc1db06c9a2c02
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Mar 5 12:59:30 2021 -0700

    io-wq: fix race in freeing 'wq' and worker access

Looks like it didn't make it into 5.10-stable, but we can certainly
rectify that.

-- 
Jens Axboe

