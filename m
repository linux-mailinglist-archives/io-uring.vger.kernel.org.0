Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD401F0BF3
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2020 16:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgFGOhe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Jun 2020 10:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726493AbgFGOhe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Jun 2020 10:37:34 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169DBC08C5C3
        for <io-uring@vger.kernel.org>; Sun,  7 Jun 2020 07:37:34 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id b201so7363124pfb.0
        for <io-uring@vger.kernel.org>; Sun, 07 Jun 2020 07:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=e3MwtDOTxbOR7lPYLTdmQGe808qHDBniGvSTepYtqvs=;
        b=IxFkowZYbVO5oYaB3JlNqJyrkUVf5M3JQhPA5kkN9RXaomk/wKQQx8SaH/FFt12dwu
         Ut0e0vEuzI6trkek87aYAibOmQNEK1pLEh+lpFSIk78PaM/IrHFQWLMl5tXdsvx9KCco
         ix7rohyasSjEd0Ekc/Gh+hU0bG0xk2f5ay4Qv8VeCJy/wxTNb7c7JP1JoOhkPpEiMpdL
         lgUGFVUBPAXOIjoLm0i/1FEbF5KSIdMEPZwSGzTnGkRLBZknqJVnVyLfiqs4fQf0KKBk
         Q/tAvegDgAzuQT/c50pzthuXbSNyST6Q3FsD+QFj1hlTU736Bk76NO5lEZ/zZgcXIidi
         LQbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e3MwtDOTxbOR7lPYLTdmQGe808qHDBniGvSTepYtqvs=;
        b=cJwY/QGQTa3oD8FoiYbx6y31k4qdyDVMSB3HnPxk5G1Bm3u7UOCoYt/hN6POlWjV+3
         Zee53LKxCptug39dZeiEM0FijuHugaltpV/gs6MJhpU/XHQYPtqPcRsDAT2nLS5sO8Y6
         rUhOQH9FDH5kGp1dunQq9KdjajXhOlCYHOkxgSiF2UuOABowbHRQRmFc4g4nSzbKKJe/
         AFGwl7J9UwknIcjfITtVC6Z8vwzSPFhvmtCZ7Q45JFeoWmR/DTFxTlMdvwzNvurR1xHM
         gxj/GAtZQqEcuU+fkuvdDyGkhDuLt3flfwTPs3OOrIoNVsJ6GDrEmC88rUw75DZfxkFS
         o/Tw==
X-Gm-Message-State: AOAM533HhRntqgQHLNPFOGI1dtBr0mX3Re+NG67mw5tX4qLaTmgPQux6
        8pLEVz7ME6Plf4L6PLMVYHd017vBmmHuSw==
X-Google-Smtp-Source: ABdhPJzMB7SOW76GXhxzQWmrBOEW5Ev+uliclYVdBqBbmdD2uVA80SlQyn2UBHFcuv36+YDfPmgFGQ==
X-Received: by 2002:a65:5349:: with SMTP id w9mr17068580pgr.281.1591540653048;
        Sun, 07 Jun 2020 07:37:33 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o25sm3764132pgn.84.2020.06.07.07.37.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 07:37:32 -0700 (PDT)
Subject: Re: io_uring_queue_exit is REALLY slow
To:     Clay Harris <bugs@claycon.org>, io-uring@vger.kernel.org
References: <20200607035555.tusxvwejhnb5lz2m@ps29521.dreamhostps.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c9446121-3229-565c-b946-f0efe6da52ce@kernel.dk>
Date:   Sun, 7 Jun 2020 08:37:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200607035555.tusxvwejhnb5lz2m@ps29521.dreamhostps.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/6/20 9:55 PM, Clay Harris wrote:
> So, I realize that this probably isn't something that you've looked
> at yet.  But, I was interested in a different criteria looking at
> io_uring.  That is how efficient it is for small numbers of requests
> which don't transfer much data.  In other words, what is the minimum
> amount of io_uring work for which a program speed-up can be obtained.
> I realize that this is highly dependent on how much overlap can be
> gained with async processing.
> 
> In order to get a baseline, I wrote a test program which performs
> 4 opens, followed by 4 read + closes.  For the baseline I
> intentionally used files in /proc so that there would be minimum
> async and I could set IOSQE_ASYNC later.  I was quite surprised
> by the result:  Almost the entire program wall time was used in
> the io_uring_queue_exit() call.
> 
> I wrote another test program which does just inits followed by exits.
> There are clock_gettime()s around the io_uring_queue_init(8, &ring, 0)
> and io_uring_queue_exit() calls and I printed the ratio of the
> io_uring_queue_exit() elapsed time and the sum of elapsed time of
> both calls.
> 
> The result varied between 0.94 and 0.99.  In other words, exit is
> between 16 and 100 times slower than init.  Average ratio was
> around 0.97.  Looking at the liburing code, exit does just what
> I'd expect (unmap pages and close io_uring fd).
> 
> I would have bet the ratio would be less than 0.50.  No
> operations were ever performed by the ring, so there should be
> minimal cleanup.  Even if the kernel needed to do a bunch of
> cleanup, it shouldn't need the pages mapped into user space to work;
> same thing for the fd being open in the user process.
> 
> Seems like there is some room for optimization here.

Can you share your test case? And what kernel are you using, that's
kind of important.

There's no reason for teardown to be slow, except if you have
pending IO that we need to either cancel or wait for. Due to
other reasons, newer kernels will have most/some parts of
the teardown done out-of-line.

-- 
Jens Axboe

