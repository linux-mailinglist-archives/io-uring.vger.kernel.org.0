Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78663B0B66
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 19:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbhFVR2u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 13:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbhFVR2s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 13:28:48 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88EDFC061756
        for <io-uring@vger.kernel.org>; Tue, 22 Jun 2021 10:26:32 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id j11-20020a9d738b0000b02903ea3c02ded8so21960921otk.5
        for <io-uring@vger.kernel.org>; Tue, 22 Jun 2021 10:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r3OBFIsAAoXgqsp/h+x2P0r+7bnHgoNxCLJytGCKgiw=;
        b=RYXB5noJjHaz6GviOHE5FMqXfdRi3+PxLHU+nJEA5j6nAOAOCgTZ+H81ODh0Uq5lvt
         +vuA+OX+ibEYDE1OFV5UMoyqD2sa/z/Fl3WpA2FmZly12+6pLqw8hwl/BAjMj77pTUzh
         yChHCdx6MqhHVSsFNe+oHMF19+FQtcSvDRiVR1R3jF/DZMaz0JEjfrcZXcs9vCo5htDv
         iZT2TgRHOLo6C3jSnV9kXj5mn4SMwJVZUmuJxVvJCdI9SaEJOn9LMFrOqqHjNrMtVm1t
         5S2YPzQ7Q1BkJtXd4ILw7BxEJ10yhNa1LPtz0BI6sNEhcQa+MGkI/AAi469EfYgYevGJ
         Ftbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r3OBFIsAAoXgqsp/h+x2P0r+7bnHgoNxCLJytGCKgiw=;
        b=iFu0s07CVZcO7ran47kUATBoG4LDm8gu4wJkDslnqSUb8QcAVW7J1ErZ0vAWvcEt88
         W1znGssQjQL72bTZg/7X6z6iiPZWTMLOVO8f60u+gZV/pV2wUeeplit8sSqyiuPiLbjo
         H5XzCzwFzASw4Tt+bpYjWvGqjN+RCta6LOBm0XgwZsGSlbBVJF/e877Ypm4Huije3xxY
         drqY6UsvaSqEk28qoi5vHFamJJk+t180TrO0t1L/NDT1dllKz/xVezF7RwWqbeMtlkUU
         r1ziX0XfQSTZNPdtGCSH12rV4tKGbj1ZEglpzgJeSc5HiAanznvJtb5/kbeo+EPrJZV3
         xlYQ==
X-Gm-Message-State: AOAM531wVNdD5IfV6Wit5LAQUJyLEIZ45BtstRDLhkXILzxB88PV7hgz
        Mn9GUChwWAHab5Y5BWxDw0qOrOUVoHFhyg==
X-Google-Smtp-Source: ABdhPJzmEA3jeuoMUDQ+my6koAqPfhLQ0cmhI4pEeKHusxNrTIYZ+QFIT60zP4QYVSM8XdvU9WqoYA==
X-Received: by 2002:a9d:7acc:: with SMTP id m12mr4170586otn.27.1624382791729;
        Tue, 22 Jun 2021 10:26:31 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id u17sm2111otk.15.2021.06.22.10.26.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 10:26:31 -0700 (PDT)
Subject: Re: [PATCH v5 00/10] io_uring: add mkdir, [sym]linkat and mknodat
 support
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Dmitry Kadashev <dkadashev@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <CAOKbgA69B=nnNOaHH239vegj5_dRd=9Y-AcQBCD3viLxcH=LiQ@mail.gmail.com>
 <2c4d5933-965e-29b5-0c76-3f2e5f518fe8@kernel.dk>
 <a459abe3-b051-ea60-d8d9-412562a255d5@kernel.dk>
 <20210622081240.c7tzq7e7gt3y3u7j@wittgenstein>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dce1f614-18c8-94ec-35e4-16343d995f0d@kernel.dk>
Date:   Tue, 22 Jun 2021 11:26:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210622081240.c7tzq7e7gt3y3u7j@wittgenstein>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/21 2:12 AM, Christian Brauner wrote:
> On Mon, Jun 21, 2021 at 09:21:23AM -0600, Jens Axboe wrote:
>> On 6/18/21 10:10 AM, Jens Axboe wrote:
>>> On 6/18/21 12:24 AM, Dmitry Kadashev wrote:
>>>> On Thu, Jun 3, 2021 at 12:18 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>>>>>
>>>>> This started out as an attempt to add mkdirat support to io_uring which
>>>>> is heavily based on renameat() / unlinkat() support.
>>>>>
>>>>> During the review process more operations were added (linkat, symlinkat,
>>>>> mknodat) mainly to keep things uniform internally (in namei.c), and
>>>>> with things changed in namei.c adding support for these operations to
>>>>> io_uring is trivial, so that was done too. See
>>>>> https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
>>>>
>>>> Ping. Jens, are we waiting for the audit change to be merged before this
>>>> can go in?
>>>
>>> Not necessarily, as that should go in for 5.14 anyway.
>>>
>>> Al, are you OK with the generic changes?
>>
>> I have tentatively queued this up.
> 
> Hey Dmitry,
> hey Jens,
> 
> The additional op codes and suggested rework is partially on me. So I
> should share the blame in case this gets a NAK:
> 
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

Thanks Christian!

-- 
Jens Axboe

