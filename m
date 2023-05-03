Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03AC66F58C6
	for <lists+io-uring@lfdr.de>; Wed,  3 May 2023 15:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjECNPT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 May 2023 09:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjECNPS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 May 2023 09:15:18 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C03F10E5
        for <io-uring@vger.kernel.org>; Wed,  3 May 2023 06:15:17 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f178da21afso34818685e9.1
        for <io-uring@vger.kernel.org>; Wed, 03 May 2023 06:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683119715; x=1685711715;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vVk9f6wG2i72z2j/bzaaTSwWS+QQqiPm50aieSpDxMg=;
        b=cL/Pp+K49DDGJ6GfKuImGga1NpfJsY68ZbMaYCjGxukWRbH4oYEW8IP0CeDLXpYl1L
         +tM19QJUfc6HHEots2xtPYFI8XOv5cm8KyzKQ8uQ2rxjWwZNuWTawM6GgZfzmghoBmQT
         G98lTZRBGt1LfLzONdkvq/yRSAmuk/nD9ZKlOz/26/0918n6MSelBWxC2KHpKZ58rHOO
         Dj9e096j5Hq0pc57jVZB7dvL7HA5d89SxfX177d3Agdae06AvP2VmGRkYKRvwXMQlBND
         TC0OSePFTZmobgEK185WLB5rEzQKJWfGznnrkwRSCbD70YXYVbUhPQ63gKLqeY4DRF6P
         jWUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683119715; x=1685711715;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vVk9f6wG2i72z2j/bzaaTSwWS+QQqiPm50aieSpDxMg=;
        b=hXcnxUuYN52izlfFCLITeedPp9IAKSZmNf74kovdPeT2ry6jBdYq4xBu5YSHAJFUsh
         akaXidON/GMaQfEYimu3p21S0UBlSoHQGqCSrfA2Gp6gQKbDTy/x0/GDwKrYz80u/WGM
         S5mEyf/9rdbVsKaTP8PbYNv+K39Bs9WqxXVfjmQUkNl/9SP74rqWQhgEG/DBeWsVCODN
         0Z2W6qrEsihjWIdnwzELpnEJfBh9wuY72/72k/DVmL23wXZwULTdD61jMYRYXKe4ylq6
         hvqALephpSPlim/9nieWW3DbBq5BSmOs42Sl/j8wOtf+n6Q4BLewW0s8KaHWu/Fd83b6
         bH5g==
X-Gm-Message-State: AC+VfDxRXilKrDoHY29MkUmnNjTVFrUikebkAWxrZ7MIwbP+rv1Pgt5q
        8I1IMM36VzZwly88EckTc9SXnEu92/I=
X-Google-Smtp-Source: ACHHUZ77sftBPShsEO6bpVKc2nmie9f9UvhI0y+wAqDQrzAyfibe26TgsEuIQWQWNY4JxHzjBtpjNg==
X-Received: by 2002:a1c:cc0a:0:b0:3f3:fe82:ee89 with SMTP id h10-20020a1ccc0a000000b003f3fe82ee89mr1056402wmb.8.1683119715420;
        Wed, 03 May 2023 06:15:15 -0700 (PDT)
Received: from [192.168.8.100] (188.31.116.198.threembb.co.uk. [188.31.116.198])
        by smtp.gmail.com with ESMTPSA id l18-20020a05600c4f1200b003f07ef4e3e0sm54320463wmq.0.2023.05.03.06.15.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 06:15:15 -0700 (PDT)
Message-ID: <9b658d7e-39c9-b597-a8f4-5483615d1e7d@gmail.com>
Date:   Wed, 3 May 2023 14:13:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] io_uring: undeprecate epoll_ctl support
Content-Language: en-US
To:     Ben Noordhuis <info@bnoordhuis.nl>
Cc:     io-uring@vger.kernel.org
References: <20230501185240.352642-1-info@bnoordhuis.nl>
 <b6cca1a6-304c-ae72-c45f-7ee3b43cf00c@gmail.com>
 <CAHQurc9L-noiMjvFsXghaBoVEBs7KJ5-a4t-eRvRim0=5HuW8w@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHQurc9L-noiMjvFsXghaBoVEBs7KJ5-a4t-eRvRim0=5HuW8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/3/23 09:58, Ben Noordhuis wrote:
> On Tue, May 2, 2023 at 2:51 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 5/1/23 19:52, Ben Noordhuis wrote:
>>> Libuv recently started using it so there is at least one consumer now.
>>
>> It was rather deprecated because io_uring controlling epoll is a bad
>> idea and should never be used. One reason is that it means libuv still
>> uses epoll but not io_uring, and so the use of io_uring wouldn't seem
>> to make much sense. You're welcome to prove me wrong on that, why libuv
>> decided to use a deprecated API in the first place?
>> Sorry, but the warning is going to stay and libuv should revert the use
>> of epol_ctl requests.
> 
> Why use a deprecated API? Because it was only recently deprecated.
> Distro kernels don't warn about it yet. I only found out because of
> kernel source code spelunking.

I see. Looks it was introduced ~9 months ago, it's not as new,
but as Jens mentioned, it's really a shame it hasn't been
backported.

> Why combine io_uring and epoll? Libuv uses level-triggered I/O for
> reasons (I can go into detail but they're not material) so it's very
> profitable to batch epoll_ctl syscalls; it's the epoll_ctlv() syscall
> people have been asking for since practically forever.
> 
> Why not switch to io_uring wholesale? Libuv can't drop support for
> epoll because of old kernels, and io_uring isn't always clearly faster
> than epoll in the first place.
> 
> As to the warning: according to the commit that introduced it, it was
> added because no one was using IORING_OP_EPOLL_CTL. Well, now someone
> is using it. Saying it's a bad API feels like post-hoc

Well, the commit message is wrong, or rather incomplete. There was
a discussion about that, but not having users was obviously a
requirement for deprecation at the time.

> rationalization. I kindly ask you merge this patch. I'd be happy to
> keep an eye on io_uring/epoll.c if you're worried about maintenance
> burden.

-- 
Pavel Begunkov
