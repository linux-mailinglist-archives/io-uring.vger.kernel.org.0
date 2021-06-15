Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3033A7E2C
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 14:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhFOM3m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 08:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhFOM3m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 08:29:42 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DC1C061574
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 05:27:36 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id a11so18109773wrt.13
        for <io-uring@vger.kernel.org>; Tue, 15 Jun 2021 05:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=oCKNS0yGU8tfJZ2Eh2+LGSaf4Plk5eoJiuDjxj/L+oI=;
        b=YyiZ8Y3Ag0hIXOohw50sFfplK15cz011kpapXfiSN4A3K7XxbTogmLcXHc290dR0ue
         0sw6SR7eb9B+PHY5COP4S3Wx6Qzwqov3tZQ0uqg7BKT/C3USmh3Nkrp+OlWr5NMd9pRC
         Q4fpAGpnabPx3alGrT2a2iSYP3TaRg3XtrORF/kXwqk0thtZV6mzm9QwtAsC4iqYI6/Q
         sEVV35xzSjsB85pIWvWO77Yk36uZY+oVo3upT5N9a2AQOsBrkolG+Vg/ymPD+3j1hHBM
         JUcwNab15tDTTiDaBUT9EVZFQPIBcbBc8VMm6bO+IekpvKAw6nNRsljwcRG8yRihPJbA
         3IQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oCKNS0yGU8tfJZ2Eh2+LGSaf4Plk5eoJiuDjxj/L+oI=;
        b=eVAruyzMLgYevg6KA+X9pB8CdjfDZK1bpat03ggjvG/A9Xc9lkDIpkfUDGWhCgg6Fg
         a/8GJgO/jbFXMUz32F89TmI7kYuClNh25puAO2TLCztfSn8BjE0xqZmuYnW43EipVXHu
         K9j9VVvvbsnnBNdeNnU5azH6tFNBuyjn40JiJ09Kd+f5nHZltAMQoLQUl/E2lqkveqGD
         jjj6+sJri6zwvM5QJnyMpOCKSaYyH2GcULzRl5Dhsnz8mzGbExtVicbVVK7FqnWN0YTR
         c7xCv12GDUhDy78vnmeopSTZ1JBUQxr8V2zkoTHIAcmKVLuNnGzVB4FnbHTpy7l6D7vF
         DhcQ==
X-Gm-Message-State: AOAM533Sq7CCEWrWwpeeM7lAhMLMl/EcKMLVYGMtQ20zSQetPAPPTFvv
        SQJkyWMJ4UQRZMNffrY/i2RHSuq1LT7pTImb
X-Google-Smtp-Source: ABdhPJy2s5oJGpnR6elczXUdYC5OH052pXIIHSKw5fJsd0dz6csBfV2YQca7FSFMjK90y9LAxy6w/A==
X-Received: by 2002:adf:cd8d:: with SMTP id q13mr19892391wrj.78.1623760055334;
        Tue, 15 Jun 2021 05:27:35 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id k5sm17595372wmk.11.2021.06.15.05.27.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 05:27:34 -0700 (PDT)
Subject: Re: [PATCH 5.14 00/12] for-next optimisations
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1623709150.git.asml.silence@gmail.com>
Message-ID: <15ce41b5-b0b2-d315-e4e0-4a5f52187ad7@gmail.com>
Date:   Tue, 15 Jun 2021 13:27:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <cover.1623709150.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/21 11:37 PM, Pavel Begunkov wrote:
> There are two main lines intervened. The first one is pt.2 of ctx field
> shuffling for better caching. There is a couple of things left on that
> front.
> 
> The second is optimising (assumably) rarely used offset-based timeouts
> and draining. There is a downside (see 12/12), which will be fixed
> later. In plans to queue a task_work clearing drain_used (under
> uring_lock) from io_queue_deferred() once all drainee are gone.

There is a much better way to disable it back: in io_drain_req().
The series is good to go, I'll patch on top later.

> nops(batch=32):
>     15.9 MIOPS vs 17.3 MIOPS
> nullblk (irqmode=2 completion_nsec=0 submit_queues=16), no merges, no stat
>     1002 KIOPS vs 1050 KIOPS
> 
> Though the second test is very slow comparing to what I've seen before,
> so might be not represantative.
> 
> Pavel Begunkov (12):
>   io_uring: keep SQ pointers in a single cacheline
>   io_uring: move ctx->flags from SQ cacheline
>   io_uring: shuffle more fields into SQ ctx section
>   io_uring: refactor io_get_sqe()
>   io_uring: don't cache number of dropped SQEs
>   io_uring: optimise completion timeout flushing
>   io_uring: small io_submit_sqe() optimisation
>   io_uring: clean up check_overflow flag
>   io_uring: wait heads renaming
>   io_uring: move uring_lock location
>   io_uring: refactor io_req_defer()
>   io_uring: optimise non-drain path
> 
>  fs/io_uring.c | 226 +++++++++++++++++++++++++-------------------------
>  1 file changed, 111 insertions(+), 115 deletions(-)
> 

-- 
Pavel Begunkov
