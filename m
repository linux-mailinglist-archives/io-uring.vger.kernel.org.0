Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B614D53F997
	for <lists+io-uring@lfdr.de>; Tue,  7 Jun 2022 11:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239419AbiFGJ1o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jun 2022 05:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239042AbiFGJ1n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jun 2022 05:27:43 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5BA2DAB2;
        Tue,  7 Jun 2022 02:27:42 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id h19so22201733edj.0;
        Tue, 07 Jun 2022 02:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=naY06qGWIBiN+cZYIQCskVHvQKkTs2sOcg9EIs+BJtM=;
        b=h4dlaIe3mZKTtP/PiqyxTIoVmK4W3MxGSLxfO0f720/UTPNWYm03jsIwYoVitkeDRH
         uBcKYNlSvwg+mBAanJ7TbsdsdCG1d2dSeNXfJ+nHORNPPnAlLCTM8mSJNhB8+4kSvkQL
         /7wn1dJAyT1rAL2slZaktLs0NaqzLIY8ZjWu3Mspz423/ydlNoQXv8EkS/bRpEJqIPLU
         z+DceWkB8nf3WIInZJVkJj5QzdCcGNPtpmpyL7f1PBunqrnfHvMFT/0v51VpJJ9UwXfm
         kA2q7Wm+EI5FC8/nluSWbXnySiTo82oGdwEkgrQsR4D+11ve4y+18hZ8EY8YBCbY2JMi
         wSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=naY06qGWIBiN+cZYIQCskVHvQKkTs2sOcg9EIs+BJtM=;
        b=H5C6TcIOSWynQZQCwFI0O2A+pAspsMhoC8i9gU89YBdMa5gbaqMy9SV0p0AdTVS1fb
         U66c90rOzvzG9eenS22ZjBgkRErboBOHXAxhKAa1mklHGQ2BO7qBktc4e0sr2blTf6VN
         pC1sjAU1Dp0E41QSs52ptBsL76c4ZdX6vZWa0eOMOCGMSr4dhq/g2xei6F+xcmOaMbfE
         eVKHamBaP5U2dWcdZZuuUxQUlL1oFyZGxc86klZv2vGy3g+lxCWi4KyeV3IdNJ82O6eG
         AuF/EdWnXygCz6Gh3LeBeEkkOTvIeHTnD25aDdimlI/ZpSq+pBvLRdgouAHsaq0rNNdQ
         Echg==
X-Gm-Message-State: AOAM533HAvvebzK1r+Y+BI/y8WG1yVUf8RKhYWDiLU062EDxO5QMNhaE
        3R+ui3yQKf479Y70rySMYYsVDb9LTug=
X-Google-Smtp-Source: ABdhPJxhbXnzT43m69zDM9zjlCy1ccaYiF+ZjJdeLobrGVj1+USsTBLPLmyK9XvI0BKP57fTm9BdSw==
X-Received: by 2002:a05:6402:e0c:b0:42d:7f16:ac2c with SMTP id h12-20020a0564020e0c00b0042d7f16ac2cmr31921551edh.328.1654594060802;
        Tue, 07 Jun 2022 02:27:40 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a22-20020aa7d916000000b0042dd4f9c464sm9804521edr.84.2022.06.07.02.27.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 02:27:40 -0700 (PDT)
Message-ID: <d350c35e-1d73-b2c8-5ae4-e6ead92aebba@gmail.com>
Date:   Tue, 7 Jun 2022 10:27:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [RFC 0/5] support nonblock submission for splice pipe to pipe
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>
References: <20220607080619.513187-1-hao.xu@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220607080619.513187-1-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/7/22 09:06, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> splice from pipe to pipe is a trivial case, and we can support nonblock
> try for it easily. splice depends on iowq at all which is slow. Let's
> build a fast submission path for it by supporting nonblock.

fwiw,

https://www.spinics.net/lists/kernel/msg3652757.html



> Wrote a simple test to test time spent of splicing from pipe to pipe:
> 
> 
> Did 50 times test for each, ignore the highest and lowest number,
> calculate the average number:
> 
> before patchset: 119.85 usec
> with patchset: 29.5 usec
> 
> ----------------
> I'm not sure if we should use a io_uring specific flag rather than
> SPLICE_F_NONBLOCK since from mutex_lock_nest to mutex_trylock changes
> the behavior under debug environment I guess. Or maybe there is another
> better option than mutex_trylock?
> 
> 
> Hao Xu (5):
>    io_uring: move sp->len check up for splice and tee
>    pipe: add trylock helpers for pipe lock
>    splice: support nonblock for splice from pipe to pipe
>    io_uring: support nonblock try for splicing from pipe to pipe
>    io_uring: add file_in in io_splice{} to avoid duplicate calculation
> 
>   fs/pipe.c                 | 29 +++++++++++++++++++++
>   fs/splice.c               | 21 +++++++++++++---
>   include/linux/pipe_fs_i.h |  2 ++
>   io_uring/splice.c         | 53 +++++++++++++++++++++++++++++----------
>   4 files changed, 89 insertions(+), 16 deletions(-)
> 
> 
> base-commit: d8271bf021438f468dab3cd84fe5279b5bbcead8

-- 
Pavel Begunkov
