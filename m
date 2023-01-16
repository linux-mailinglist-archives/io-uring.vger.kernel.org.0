Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D088B66C444
	for <lists+io-uring@lfdr.de>; Mon, 16 Jan 2023 16:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjAPPuZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Jan 2023 10:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjAPPuX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Jan 2023 10:50:23 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF1B1A4BE
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 07:50:22 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso34329799pjt.0
        for <io-uring@vger.kernel.org>; Mon, 16 Jan 2023 07:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5OIW1YGG+0Oc0J1muJV3BXbF4aV089CCWwP+GB9Sy1o=;
        b=wnbSyIZz9APhU+54OJFnTurBzytr+vU60b42/0tHgObtF1eP+0BEFiHjFpzJ7rGCLv
         nYqdmvlLNeZZcJ9S1zhbpP2YNoW6Nb2j6vKCQwOtnM1w5TVPclmw/OXGDnxNPn/7jFTe
         fSIlPauAMVHRqm58JlvOiZmdOJVrZc8/YxN4P6OSlM5aw1uKvN6yuLmitVnroX+XcDuL
         R0H8eT/3GZk/jNzNCSqwwIOD9Lit+WN95QfTNSzXXls8XRM9kb2aSJOYbrETA5rNdnoR
         KzmjdGQMTOKRYlGrJsbFzHVq2hw8g+g68uc8qg0lo7vyZHLH27WonytURscI5OKM+hLC
         XOyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5OIW1YGG+0Oc0J1muJV3BXbF4aV089CCWwP+GB9Sy1o=;
        b=dJLYo+b6gxvn64eUbHF2pDUIzPfcywSXzv3RT1yHpjka6xFI/zmU5OXd3vPRfPTodo
         37nTKYual5Q2jL0grjd4QFbIS6e1MpzkODhaFw0rtS9YEBe7qjwAYTKcWO1HuPjUob1k
         QplK/FVBHoP30FJSbWTW7c/D7KfT39vj+l2iSBIFaew+/eb/6PnsRt2mg3WEEzqglNgG
         6tiJ5Xtl4htkWdz8EVa4Py/X8zlIImeA+2EI5zY4Llb2fb0zNrvvaXdMHna/c4NMShIt
         BtCVh9FENzVqpS69B9MbL4wOTTtKrAMvYoQx59UutEH5IVdXW+zuS/Tr4XueZkepv6Bo
         GWNA==
X-Gm-Message-State: AFqh2kpkhGs3kNUpU1LQUPnSryyEdcAR8TIcNZ7jLLfD7MgqmsB4Vx66
        HdocITA4+FPnMsDM/8W6pcNvAA==
X-Google-Smtp-Source: AMrXdXs0iug+d4vwdkOUuACUsQG9ZMBQj4SmNkBFcLdpJa/Eme6Oz9otbvTbBuqoUyJEFgoRyn0tjg==
X-Received: by 2002:a05:6a21:8cc4:b0:af:cc4e:f2d with SMTP id ta4-20020a056a218cc400b000afcc4e0f2dmr23839657pzb.0.1673884222225;
        Mon, 16 Jan 2023 07:50:22 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h18-20020a656392000000b0046b1dabf9a8sm15949662pgv.70.2023.01.16.07.50.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 07:50:21 -0800 (PST)
Message-ID: <0857ddf2-89a9-231b-89da-57cacc7342d5@kernel.dk>
Date:   Mon, 16 Jan 2023 08:50:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: =?UTF-8?Q?Re=3a_=5bregression=5d_Bug=c2=a0216932_-_io=5furing_with_?=
 =?UTF-8?Q?libvirt_cause_kernel_NULL_pointer_dereference_since_6=2e1=2e5?=
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux regressions mailing list <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Sergey V." <truesmb@gmail.com>
References: <74347fe1-ac68-2661-500d-b87fab6994f7@leemhuis.info>
 <c5632908-1b0f-af1f-4754-bf1d0027a6dc@kernel.dk>
 <a862915b-66f3-9ad8-77d4-4b9ce7044037@kernel.dk> <Y8VkB6Q2xqeut5N8@kroah.com>
 <e921f92d-52ac-1dc7-7720-c270910c2a2d@kernel.dk>
In-Reply-To: <e921f92d-52ac-1dc7-7720-c270910c2a2d@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/23 8:44 AM, Jens Axboe wrote:
> On 1/16/23 7:49 AM, Greg Kroah-Hartman wrote:
>> On Mon, Jan 16, 2023 at 07:13:40AM -0700, Jens Axboe wrote:
>>> On 1/16/23 6:42 AM, Jens Axboe wrote:
>>>> On 1/16/23 6:17?AM, Linux kernel regression tracking (Thorsten Leemhuis) wrote:
>>>>> Hi, this is your Linux kernel regression tracker.
>>>>>
>>>>> I noticed a regression report in bugzilla.kernel.org. As many (most?)
>>>>> kernel developer don't keep an eye on it, I decided to forward it by
>>>>> mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=216932 :
>>>>
>>>> Looks like:
>>>>
>>>> commit 6d47e0f6a535701134d950db65eb8fe1edf0b575
>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>> Date:   Wed Jan 4 08:52:06 2023 -0700
>>>>
>>>>     block: don't allow splitting of a REQ_NOWAIT bio
>>>>
>>>> got picked up by stable, but not the required prep patch:
>>>>
>>>>
>>>> commit 613b14884b8595e20b9fac4126bf627313827fbe
>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>> Date:   Wed Jan 4 08:51:19 2023 -0700
>>>>
>>>>     block: handle bio_split_to_limits() NULL return
>>>>
>>>> Greg/team, can you pick the latter too? It'll pick cleanly for
>>>> 6.1-stable, not sure how far back the other patch has gone yet.
>>>
>>> Looked back, and 5.15 has it too, but the cherry-pick won't work
>>> on that kernel.
>>>
>>> Here's one for 5.15-stable that I verified crashes before this one,
>>> and works with it. Haven't done an allmodconfig yet...
>>
>> All now queued up, thanks!
> 
> Thanks Greg! This one was my fault, as it was a set of 2 patches and
> I only marked 2/2 for stable. But how is that best handled? 1/2 could've
> been marked stable as well, but I don't think that would have prevented
> 2/2 applying fine and 1/2 failing and hence not getting queued up until
> I would've done a backport.
> 
> What's the recommended way to describe the dependency that you only
> want 2/2 applied when 1/2 is in as well?

What I'm asking is if we have something like Depends-on or similar
that would explain this dependency. Then patch 2/2 could have:

Depends-on: 613b14884b85 ("block: handle bio_split_to_limits() NULL return")

and then it'd be clear that either both get added, or none of them.

-- 
Jens Axboe


