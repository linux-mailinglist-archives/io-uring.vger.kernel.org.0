Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7406F5934
	for <lists+io-uring@lfdr.de>; Wed,  3 May 2023 15:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjECNmk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 May 2023 09:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjECNmj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 May 2023 09:42:39 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEDF1A5
        for <io-uring@vger.kernel.org>; Wed,  3 May 2023 06:42:36 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-763af6790a3so26200039f.0
        for <io-uring@vger.kernel.org>; Wed, 03 May 2023 06:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683121355; x=1685713355;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hcLmmMif3sOuecLZlf6NnpSEQcU3rZ1MNkuv5pCaQJY=;
        b=dHbJTl3YD/NIy7enf+zltjOMeLIS9LIlkoCH9P/Bg9g/vvtv+R+heSnNjBuU6duBq7
         wQRva97KAhRWqjYCtNMCgo25HDAxU8yMeJg4NaRFpzRbltYShqlKMzQhRR+nubm9KP8b
         8vAr8YYwtH2VS0iWFfyg1syGkbnjhCMmaWrzHWFtsZ7D4IZmDPZXT6fMoUcpnqoFAu4Z
         wzRNkzX7tT6BxBeFAceNif7ERlirNWk4lM0OMSjZWaf59/ks1EatXI0OyRfInDOcTQSq
         gu2KibegWLB8+r9xOiIBNSnHxyDI40mb79digKzvufwmxyPAwRblG2yaMpmy7VUqXdg0
         VPYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683121355; x=1685713355;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hcLmmMif3sOuecLZlf6NnpSEQcU3rZ1MNkuv5pCaQJY=;
        b=hgf3Vza+x5BI334361WW9yEuk8TkcYLvtsmJmiVzWLnva6PN7JveLjOkSKXIE36pP7
         XdPD9XOs7C+ELlzpLj5zqQi+dhOugE3jyMAlcFMCoTdWt/A7v7yp5KLdz9U80VB09+Wz
         WiH6arILi0ZdK9pqxedDyxftjizbkwqgCxO9yIaAflloLRspG2fs0+5QHakolX5MPpHy
         eZ+xjRFBzWdUclbgRLQBcXOH4Rf0Pzf/N+SXoXOrLxeQZ/f2UlQ8A3dvEYn2Y3EYuNks
         /641/3FJZDiLGKEtbgyI7iFzWCevxekzEDA7McoRm3Oex4/ZMCap6oDEFxoP5ZC+E7N+
         OjYQ==
X-Gm-Message-State: AC+VfDzXN7fE8iCcBCYuO+JFGgNf3yb0VrcCDkk70efTbz8j1PgZZR/h
        HCopGwCd5xD+yEHOssywUlKREMb5u4Kvbs+w++U=
X-Google-Smtp-Source: ACHHUZ6Y1GjqSprHYmK/fD1ANL/cILRSMgKgusepjgHHTIPUIunW/UMLmxi9nwrBG//9mqE7oFekRw==
X-Received: by 2002:a05:6e02:1be4:b0:32a:a8d7:f099 with SMTP id y4-20020a056e021be400b0032aa8d7f099mr10386877ilv.3.1683121355451;
        Wed, 03 May 2023 06:42:35 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h18-20020a056638339200b0040fcd31af1csm9890853jav.65.2023.05.03.06.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 06:42:34 -0700 (PDT)
Message-ID: <ab3f3494-9c5f-8bfb-8b56-b078bc6d67d4@kernel.dk>
Date:   Wed, 3 May 2023 07:42:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] io_uring: undeprecate epoll_ctl support
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Ben Noordhuis <info@bnoordhuis.nl>
Cc:     io-uring@vger.kernel.org
References: <20230501185240.352642-1-info@bnoordhuis.nl>
 <b6cca1a6-304c-ae72-c45f-7ee3b43cf00c@gmail.com>
 <CAHQurc9L-noiMjvFsXghaBoVEBs7KJ5-a4t-eRvRim0=5HuW8w@mail.gmail.com>
 <dcd3d63e-c8ce-935e-3b43-5b6ca5c84eb8@kernel.dk>
 <73b4fc31-9832-adbb-4537-87ca76079f86@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <73b4fc31-9832-adbb-4537-87ca76079f86@gmail.com>
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

On 5/3/23 7:21?AM, Pavel Begunkov wrote:
> On 5/3/23 13:49, Jens Axboe wrote:
>> On 5/3/23 2:58?AM, Ben Noordhuis wrote:
>>> On Tue, May 2, 2023 at 2:51?PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>
>>>> On 5/1/23 19:52, Ben Noordhuis wrote:
>>>>> Libuv recently started using it so there is at least one consumer now.
>>>>
>>>> It was rather deprecated because io_uring controlling epoll is a bad
>>>> idea and should never be used. One reason is that it means libuv still
>>>> uses epoll but not io_uring, and so the use of io_uring wouldn't seem
>>>> to make much sense. You're welcome to prove me wrong on that, why libuv
>>>> decided to use a deprecated API in the first place?
>>>> Sorry, but the warning is going to stay and libuv should revert the use
>>>> of epol_ctl requests.
>>>
>>> Why use a deprecated API? Because it was only recently deprecated.
>>> Distro kernels don't warn about it yet. I only found out because of
>>> kernel source code spelunking.
>>>
>>> Why combine io_uring and epoll? Libuv uses level-triggered I/O for
>>> reasons (I can go into detail but they're not material) so it's very
>>> profitable to batch epoll_ctl syscalls; it's the epoll_ctlv() syscall
>>> people have been asking for since practically forever.
>>>
>>> Why not switch to io_uring wholesale? Libuv can't drop support for
>>> epoll because of old kernels, and io_uring isn't always clearly faster
>>> than epoll in the first place.
>>>
>>> As to the warning: according to the commit that introduced it, it was
>>> added because no one was using IORING_OP_EPOLL_CTL. Well, now someone
>>> is using it. Saying it's a bad API feels like post-hoc
>>> rationalization. I kindly ask you merge this patch. I'd be happy to
>>> keep an eye on io_uring/epoll.c if you're worried about maintenance
>>> burden.
>>
>> This is obviously mostly our fault, as the deprecation patch should've
>> obviously been backported to stable. Just adding it to the current
>> kernel defeated the purpose, as it added a long period where older
>> kernels quite happily accepted epoll use cases.
>>
>> So I do agree, the only sane course of action here is to un-deprecate
>> it.
> 
> nack, keeping piling rubbish is not a great course of action at all.
> 
> Has libuv already released it? Because it seems the patches were
> just merged.

This is not a NAK situation. Fact is that the code is out there, and
libuv isn't the first to discover this by accident. We messed up not
getting this to stable, but I think it's a reasonable assumption that
there are likely others there as most folks run distro and/or stable
kernels and are not on the bleeding edge.

The deprecation patch was in 6.0, so anyone running kernels before that
could be using the epoll support and have no idea that it would be going
away. Outside of that, it's also quite easy to miss a single dmesg blurp
on this unless you're actively looking for it or just happen to come
across it.

Unless there are reasons beyond "I'd love to remove this code", then it
will be reinstated. We don't get to make up special rules for io_uring
code that are counter to what the kernel generally guarantees, most
notable that you cannot remove an API that is out there and in use. This
isn't really about libuv in particular, as the io_uring support there is
rather new and they could change course. It's more about other projects
out there that already have it in production.

-- 
Jens Axboe

