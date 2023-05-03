Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0926F582A
	for <lists+io-uring@lfdr.de>; Wed,  3 May 2023 14:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjECMt5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 May 2023 08:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjECMt4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 May 2023 08:49:56 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A021FD2
        for <io-uring@vger.kernel.org>; Wed,  3 May 2023 05:49:55 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-63b621b1dabso1420595b3a.0
        for <io-uring@vger.kernel.org>; Wed, 03 May 2023 05:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683118195; x=1685710195;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sU8y0L55gAcNA5BW+dVwQOqXVoS7NhH6y525Gk+j/vs=;
        b=27fyfSOG5bC8mldD843pEsWjrg7/OCw4zDjAHJAGMjK3AbudcnNyWWln6Mn7HGzqlb
         EIbeUlp4xSzhV2E+MVL0uOLXdf22kRX4wtoT9sRniql9gEDZCRQclbWngOtv8acIf3Rt
         QW9gZvEYc6en0vMQEjGT9p3Vu9SVdflH4TzcMVcdSJCPJWVM32EURLbWNvGD2q0pn0c6
         AGodPOCZAO2yDwzK6lrEz0y/dN1I2j1a6K8qrwWMYXeXZBCmh4NlhjypueU7+d7x1InN
         yiHmHq66Ob1gLQneUEXis2cMOOYqOjn/x81424/+rz+MFAetNOK72l6pABzHDgfhm0a7
         19hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683118195; x=1685710195;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sU8y0L55gAcNA5BW+dVwQOqXVoS7NhH6y525Gk+j/vs=;
        b=POuJbZSN49TrmuA8fcCN75txnLoVnabcaaEqBC+q/pTlnUCfZs/Lv5CiIrcZarrZzA
         RUvzKi5+VkPY7lGiuqkM29n6EvL3rVlhdpddCwFNpddQmYmfiAf46XQu1OQEAZhABDIh
         dRbWWcqxLaIyH60LiUlqWeDsI+gxHWd7SEQjujKdC9iQRhaIp5DrFdL9dQaigBmGnKUY
         MWeqkp7UAlbL2IUj2JF7g6TMSaPX1Vm2Yll7rF2eiyfUDLn7oy0r1VreFKyLlIeCPMag
         8uh+In+9w9emu4Yrm6+KhYJ3z30aUZ+vvL8it93BoDotj9DNW6VIl75YRRdVjxPT3DqT
         NmDw==
X-Gm-Message-State: AC+VfDyXQhOBkV0cA60Jtc/PZYnWGDvLuaamuvqwuK5/5atXjFyI78HK
        S/Qywt2RtpfH392Vl7YacEm/tF5UigEP74QDm9I=
X-Google-Smtp-Source: ACHHUZ7nBzssEDjE7DSVvlQALO4XUVWZMP5T2ZdITJh8XXZ8wQuOfeNyrzDKcGZ0RH9Zfa+uYITV9A==
X-Received: by 2002:a05:6a20:12d0:b0:f0:38a7:dc71 with SMTP id v16-20020a056a2012d000b000f038a7dc71mr7907188pzg.4.1683118194864;
        Wed, 03 May 2023 05:49:54 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j12-20020a056a00174c00b00634b91326a9sm24319521pfc.143.2023.05.03.05.49.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 05:49:54 -0700 (PDT)
Message-ID: <dcd3d63e-c8ce-935e-3b43-5b6ca5c84eb8@kernel.dk>
Date:   Wed, 3 May 2023 06:49:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] io_uring: undeprecate epoll_ctl support
Content-Language: en-US
To:     Ben Noordhuis <info@bnoordhuis.nl>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <20230501185240.352642-1-info@bnoordhuis.nl>
 <b6cca1a6-304c-ae72-c45f-7ee3b43cf00c@gmail.com>
 <CAHQurc9L-noiMjvFsXghaBoVEBs7KJ5-a4t-eRvRim0=5HuW8w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHQurc9L-noiMjvFsXghaBoVEBs7KJ5-a4t-eRvRim0=5HuW8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/3/23 2:58?AM, Ben Noordhuis wrote:
> On Tue, May 2, 2023 at 2:51?PM Pavel Begunkov <asml.silence@gmail.com> wrote:
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
> 
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
> rationalization. I kindly ask you merge this patch. I'd be happy to
> keep an eye on io_uring/epoll.c if you're worried about maintenance
> burden.

This is obviously mostly our fault, as the deprecation patch should've
obviously been backported to stable. Just adding it to the current
kernel defeated the purpose, as it added a long period where older
kernels quite happily accepted epoll use cases.

So I do agree, the only sane course of action here is to un-deprecate
it.

-- 
Jens Axboe

