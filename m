Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38CA75BB77F
	for <lists+io-uring@lfdr.de>; Sat, 17 Sep 2022 11:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbiIQJR2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 17 Sep 2022 05:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiIQJR1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 17 Sep 2022 05:17:27 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144A045F64
        for <io-uring@vger.kernel.org>; Sat, 17 Sep 2022 02:17:26 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id h8so32632528wrf.3
        for <io-uring@vger.kernel.org>; Sat, 17 Sep 2022 02:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=+VPFd7gR9aAvf62mYPQ2z/Y2C8fhAzQkxEDCRXQVTRs=;
        b=kPNrmRP75FyzuckVW8oJPC3qPHjIuI/0jgh0MIOdORu5m3HAQNyAvCyMwfKB1Ed075
         aVW++O0q69eTOAa34xaG9PVZDK/It1pvuTIyDHqPQ+syak84j8GpDH/KahYIyFGouf2y
         JjCvJC8O4/CNTBB4LZs8ZvNccFevNQzcJYmhSFn7cG0EgqGJfJ4CCjxN+JJ4rmeKkuXI
         uj9/7U1ymD3yXHosNfyoOsMzjaL9bDNxYk+DtLP+yGwYp9EZ285YY5batQkDBjDcNRpz
         4r6klt67X0SAz6Qs2FqmCxHGlMp9a4ZNdqHEj9okBCRjlNJ7DobP1GCmkoPhXaN1oZcc
         cZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=+VPFd7gR9aAvf62mYPQ2z/Y2C8fhAzQkxEDCRXQVTRs=;
        b=BVFdhl37hQK9tjtPufpFNAhIiS33IN/ODR99x6ItYsxSs9b+AKtFJdrvqeVloq1WJJ
         LxT2qXPHsCU24gJuvAMUshvDBxz9eh/Xfry6H6yyiFC7AJOKqNvZWUJznE22YNeRFzLP
         h/IgXF5IENvyn7OPlHcMkc9IpEeq4Q8LODyLbEQ8mkmkJRPwMgAd/o3GLBbvAeFR4y7J
         BupD/E+p4qQF2Tc74qtl6rDSAnXp5wTVyFKEFjnNJUw0rF8Co6tz3QQDPiv5bVbcCNLH
         YcJCt48JXhgbdxUP9tUEdQ8iN1oYCiCgiDi5NqEYFoQrfC15Dr1xBQX3xWQxhQUz1C7B
         bVRw==
X-Gm-Message-State: ACrzQf2R8mAdwNtQQYFDoyN4yTKoGbMWCxjDls+F4Z++7V6/KW9kao3B
        BgC5AF9ep8+7PM2tGx+EhbY=
X-Google-Smtp-Source: AMsMyM5ku2nWzqWtpqKidVhHPbCxylQrQytqEvthXUgzr48KHD9Xk6Iuq6U0vYXMQCJa58gu2xBRWg==
X-Received: by 2002:a05:6000:101:b0:228:de40:8898 with SMTP id o1-20020a056000010100b00228de408898mr5042999wrx.106.1663406244372;
        Sat, 17 Sep 2022 02:17:24 -0700 (PDT)
Received: from [10.128.133.254] ([185.205.229.29])
        by smtp.gmail.com with ESMTPSA id f8-20020a05600c154800b003b477532e66sm12686107wmg.2.2022.09.17.02.17.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Sep 2022 02:17:23 -0700 (PDT)
Message-ID: <734a8945-3668-5aa8-df8a-a858213e73ed@gmail.com>
Date:   Sat, 17 Sep 2022 10:16:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH for-6.0 0/5] IORING_OP_SEND_ZC improvements
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        axboe@kernel.dk
References: <cover.1663363798.git.metze@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1663363798.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/16/22 22:36, Stefan Metzmacher wrote:
> Hi Pavel, hi Jens,
> 
> I did some initial testing with IORING_OP_SEND_ZC.
> While reading the code I think I found a race that
> can lead to IORING_CQE_F_MORE being missing even if
> the net layer got references.

Hey Stefan,

Did you see some kind of buggy behaviour in userspace?
If network sends anything it should return how many bytes
it queued for sending, otherwise there would be duplicated
packets / data on the other endpoint in userspace, and I
don't think any driver / lower layer would keep memory
after returning an error.

In any case, I was looking on a bit different problem, but
it should look much cleaner using the same approach, see
branch [1], and patch [3] for sendzc in particular.

[1] https://github.com/isilence/linux.git partial-fail
[2] https://github.com/isilence/linux/tree/io_uring/partial-fail
[3] https://github.com/isilence/linux/commit/acb4f9bf869e1c2542849e11d992a63d95f2b894


> While there I added some code to allow userpace to
> know how effective the IORING_OP_SEND_ZC attempt was,
> in order to avoid it it's not used (e.g. on a long living tcp
> connection).> 
> This change requires a change to the existing test, see:
> https://github.com/metze-samba/liburing/tree/test-send-zerocopy
> 
> Stefan Metzmacher (5):
>    io_uring/opdef: rename SENDZC_NOTIF to SEND_ZC
>    io_uring/core: move io_cqe->fd over from io_cqe->flags to io_cqe->res
>    io_uring/core: keep req->cqe.flags on generic errors
>    io_uring/net: let io_sendzc set IORING_CQE_F_MORE before
>      sock_sendmsg()
>    io_uring/notif: let userspace know how effective the zero copy usage
>      was
> 
>   include/linux/io_uring_types.h |  6 +++---
>   io_uring/io_uring.c            | 18 +++++++++++++-----
>   io_uring/net.c                 | 19 +++++++++++++------
>   io_uring/notif.c               | 18 ++++++++++++++++++
>   io_uring/opdef.c               |  2 +-
>   net/ipv4/ip_output.c           |  3 ++-
>   net/ipv4/tcp.c                 |  2 ++
>   net/ipv6/ip6_output.c          |  3 ++-
>   8 files changed, 54 insertions(+), 17 deletions(-)
> 

-- 
Pavel Begunkov
