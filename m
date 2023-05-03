Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65CB66F58FB
	for <lists+io-uring@lfdr.de>; Wed,  3 May 2023 15:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjECNXQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 May 2023 09:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjECNXP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 May 2023 09:23:15 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830655264
        for <io-uring@vger.kernel.org>; Wed,  3 May 2023 06:23:14 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-2f27a9c7970so4808121f8f.2
        for <io-uring@vger.kernel.org>; Wed, 03 May 2023 06:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683120193; x=1685712193;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wMErqJAVg8nEd0C52wlLbdmzfn2br0iZGOlGWLDFWFw=;
        b=HRbE/h178kBKv4I1z18oKfbQI5QVBv9Unu7cFUR9XxhFuaKfuxFuPrmCy77AnFxNnb
         8KdwJa4+VZlvdOqjYvVlHfAHLjZvoPcLEJPfFauLIQpOVW9hSBhn2CJ9oVNgngm8SmVE
         TK074D1qf9VTUeYZIB2H0F4WJNSDJToJeLKdqWroV7JQUOerSlka5urXd+wAozaWBY8y
         hI2pEjP6qbumD/DuboH726ntgwHLwdA34xc48dpVune1HXkOUeoJSr4BxU895D0hhSiX
         0FBaJLKnvD022KGTIqJArnL0oZvkfZgbLAMJlSrTsAx5E3kDB1bw3O0eHoILyLcL+b5N
         zqAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683120193; x=1685712193;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wMErqJAVg8nEd0C52wlLbdmzfn2br0iZGOlGWLDFWFw=;
        b=HkF4vRDeHnLOI0eB2SXfk/jFSA4puzUA18HxJK7LA/d+NFvox2IiKVLNwXVJpB96sg
         YTJjyTws+KpDENeD3JbUtHMFFpTioH3qb6GdOZqvAEL8BQ8NaArlRC/YoqOQkYlEHR34
         +aHCZEoJEbtGSpEtfu+c4/8y5aeMwcGpYyDQIj8AkD5v9WssOlOvfwBHzWMoPGbdfUXj
         jKu69RzIf4cTYuVRf/myF4WNphL9VBjPpu0BhU7t2Eg9CnNckepXDOL41OVO2v0dCXfh
         6HCB7MhiOcdOMOK9SHuSb0BLMOwTq8uy2QCemOrI3DTHxVnFgJm9awM4Ohrbd1Hy37lZ
         xiUw==
X-Gm-Message-State: AC+VfDwnazyWyqK/GTVoDdNzQ5xmMgrxb/EftAWDcIz3NRT81ezZn9QJ
        59fR/8cbw2Asyg3J77bLr50m2TMn4tU=
X-Google-Smtp-Source: ACHHUZ7zYP+KH1tymQIGCOO3A2YWrHd1KCKVNps6QQNdfAgPgA6EzF53DDjlmZkYIGVFTwfC+f4UKg==
X-Received: by 2002:a5d:6542:0:b0:306:4442:4c7a with SMTP id z2-20020a5d6542000000b0030644424c7amr65237wrv.33.1683120192963;
        Wed, 03 May 2023 06:23:12 -0700 (PDT)
Received: from [192.168.8.100] (188.31.116.198.threembb.co.uk. [188.31.116.198])
        by smtp.gmail.com with ESMTPSA id j6-20020a5d6186000000b003063772a55bsm4737287wru.61.2023.05.03.06.23.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 06:23:12 -0700 (PDT)
Message-ID: <73b4fc31-9832-adbb-4537-87ca76079f86@gmail.com>
Date:   Wed, 3 May 2023 14:21:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] io_uring: undeprecate epoll_ctl support
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, Ben Noordhuis <info@bnoordhuis.nl>
Cc:     io-uring@vger.kernel.org
References: <20230501185240.352642-1-info@bnoordhuis.nl>
 <b6cca1a6-304c-ae72-c45f-7ee3b43cf00c@gmail.com>
 <CAHQurc9L-noiMjvFsXghaBoVEBs7KJ5-a4t-eRvRim0=5HuW8w@mail.gmail.com>
 <dcd3d63e-c8ce-935e-3b43-5b6ca5c84eb8@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <dcd3d63e-c8ce-935e-3b43-5b6ca5c84eb8@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/3/23 13:49, Jens Axboe wrote:
> On 5/3/23 2:58?AM, Ben Noordhuis wrote:
>> On Tue, May 2, 2023 at 2:51?PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>
>>> On 5/1/23 19:52, Ben Noordhuis wrote:
>>>> Libuv recently started using it so there is at least one consumer now.
>>>
>>> It was rather deprecated because io_uring controlling epoll is a bad
>>> idea and should never be used. One reason is that it means libuv still
>>> uses epoll but not io_uring, and so the use of io_uring wouldn't seem
>>> to make much sense. You're welcome to prove me wrong on that, why libuv
>>> decided to use a deprecated API in the first place?
>>> Sorry, but the warning is going to stay and libuv should revert the use
>>> of epol_ctl requests.
>>
>> Why use a deprecated API? Because it was only recently deprecated.
>> Distro kernels don't warn about it yet. I only found out because of
>> kernel source code spelunking.
>>
>> Why combine io_uring and epoll? Libuv uses level-triggered I/O for
>> reasons (I can go into detail but they're not material) so it's very
>> profitable to batch epoll_ctl syscalls; it's the epoll_ctlv() syscall
>> people have been asking for since practically forever.
>>
>> Why not switch to io_uring wholesale? Libuv can't drop support for
>> epoll because of old kernels, and io_uring isn't always clearly faster
>> than epoll in the first place.
>>
>> As to the warning: according to the commit that introduced it, it was
>> added because no one was using IORING_OP_EPOLL_CTL. Well, now someone
>> is using it. Saying it's a bad API feels like post-hoc
>> rationalization. I kindly ask you merge this patch. I'd be happy to
>> keep an eye on io_uring/epoll.c if you're worried about maintenance
>> burden.
> 
> This is obviously mostly our fault, as the deprecation patch should've
> obviously been backported to stable. Just adding it to the current
> kernel defeated the purpose, as it added a long period where older
> kernels quite happily accepted epoll use cases.
> 
> So I do agree, the only sane course of action here is to un-deprecate
> it.

nack, keeping piling rubbish is not a great course of action at all.

Has libuv already released it? Because it seems the patches were
just merged.

-- 
Pavel Begunkov
