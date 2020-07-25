Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63D222D9D5
	for <lists+io-uring@lfdr.de>; Sat, 25 Jul 2020 22:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgGYUZw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jul 2020 16:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbgGYUZw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jul 2020 16:25:52 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A1BC08C5C0
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 13:25:52 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t10so882605plz.10
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 13:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=bpMLYNuxyqK+n51UG52LkjxNKXW8CFf1CozCd7+nYvw=;
        b=hRn3Iax3zrq6ROo71qjZFSB8SjG6XDbC2a1Oc/hh4CK2Vm+S8WR0g6Wn/pnmeF7cDV
         WomCJV5TkO6etsUI2gweTB3Fy/N5jUjYRB/y7zLD6pwzdqSjXpY6a/BjF2C37wpEY06g
         eHgClIsvY2ti3gohmSEeqYpTS3xqx6Tft6KVsmtdjPboW0gD2iu6qEwm7+47+RdXtRzr
         z6/GKmmZSW6EHwpKx57a1gJhigcsp4u0o0zHmVDTDYpRSL1KliA1STj7kqjV2USYJ6a6
         jdVLknWF3yHLzy8ZjoQlg+MSTxV0iz1VjWrscn24gjlAT+zSpBUIjP7QzLk01BUeiVyD
         Wamg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bpMLYNuxyqK+n51UG52LkjxNKXW8CFf1CozCd7+nYvw=;
        b=gSuq6YvD5Vc6sdHzprb1j2Oz08et9PNBfsKT+HwZs/94NZSeSBJHHI2cTeT6k+pEQW
         707phakCKpx1+FFy+0+TTMuDQZbENXMxzxGTPZbonVg8NYKGRku1wSKgh87ALUV8UfsH
         yvRRrB+mdGr8Sf20re2UgR6w6uf48ZKZ3qbd4AmeKaXiZfawE4clk/AQ4GxxPtToZGAz
         9l1njzch1h13dm6W63Zv1TaWxcle4zf9sxOkRJ5ngGSZ3nwBNAaYwu+m6Nzm847sdHEr
         srOSYzoradp2khYvz3sWsyJiGVilkoCNhvvDByVE65AUpqJsInyDdkPxWWc6wBhJEOZB
         Unpw==
X-Gm-Message-State: AOAM5321OZNuFwQeVKZv6yOVCPSQUrewBPjAl701d8dVpMGosH6M7UVj
        e2QjN6xVl+PRqYdsukSgTSGrYZkCsNw=
X-Google-Smtp-Source: ABdhPJxQxlESPbM1Xi6fF7hKcF15DPfbNms14HNWS8lNf/EfBb0/IK0hCq1g5WaSVJ6tQGGF7QIZ6A==
X-Received: by 2002:a17:902:6bc5:: with SMTP id m5mr13447149plt.150.1595708751312;
        Sat, 25 Jul 2020 13:25:51 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b13sm10169736pjl.7.2020.07.25.13.25.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jul 2020 13:25:50 -0700 (PDT)
Subject: Re: [RFC 0/2] 3 cacheline io_kiocb
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1595664743.git.asml.silence@gmail.com>
 <467e93fb-876d-e2a5-7596-4b9e21317d67@kernel.dk>
 <faf48a78-4327-50e6-083a-f5c762f66e8a@gmail.com>
 <b0ca655f-96ed-a249-6371-bea409b1f065@kernel.dk>
 <8203a1c1-ecf4-1890-d1f0-6cb135cba8cf@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d7076158-d8d0-7a23-f80e-ec83e4f4092d@kernel.dk>
Date:   Sat, 25 Jul 2020 14:25:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8203a1c1-ecf4-1890-d1f0-6cb135cba8cf@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/25/20 2:14 PM, Pavel Begunkov wrote:
>  On 25/07/2020 22:40, Jens Axboe wrote:
>> On 7/25/20 12:24 PM, Pavel Begunkov wrote:
>>> On 25/07/2020 18:45, Jens Axboe wrote:
>>>> On 7/25/20 2:31 AM, Pavel Begunkov wrote:
>>>>> That's not final for a several reasons, but good enough for discussion.
>>>>> That brings io_kiocb down to 192B. I didn't try to benchmark it
>>>>> properly, but quick nop test gave +5% throughput increase.
>>>>> 7531 vs 7910 KIOPS with fio/t/io_uring
>>>>>
>>>>> The whole situation is obviously a bunch of tradeoffs. For instance,
>>>>> instead of shrinking it, we can inline apoll to speed apoll path.
>>>>>
>>>>> [2/2] just for a reference, I'm thinking about other ways to shrink it.
>>>>> e.g. ->link_list can be a single-linked list with linked tiemouts
>>>>> storing a back-reference. This can turn out to be better, because
>>>>> that would move ->fixed_file_refs to the 2nd cacheline, so we won't
>>>>> ever touch 3rd cacheline in the submission path.
>>>>> Any other ideas?
>>>>
>>>> Nothing noticeable for me, still about the same performance. But
>>>> generally speaking, I don't necessarily think we need to go all in on
>>>> making this as tiny as possible. It's much more important to chase the
>>>> items where we only use 2 cachelines for the hot path, and then we have
>>>> the extra space in there already for the semi hot paths like poll driven
>>>> retry. Yes, we're still allocating from a pool that has slightly larger
>>>> objects, but that doesn't really matter _that_ much. Avoiding an extra
>>>> kmalloc+kfree for the semi hot paths are a bigger deal than making
>>>> io_kiocb smaller and smaller.
>>>>
>>>> That said, for no-brainer changes, we absolutely should make it smaller.
>>>> I just don't want to jump through convoluted hoops to get there.
>>>
>>> Agree, but that's not the end goal. The first point is to kill the union,
>>> but it already has enough space for that.
>>
>> Right
>>
>>> The second is to see, whether we can use the space in a better way. From
>>> the high level perspective ->apoll and ->work are alike and both serve to
>>> provide asynchronous paths, hence the idea to swap them naturally comes to
>>> mind.
>>
>> Totally agree, which is why the union of those kind of makes sense.
>> We're definitely NOT using them at the same time, but the fact that we
>> had various mm/creds/whatnot in the work_struct made that a bit iffy.
> 
> Thinking of it, if combined with work de-init as you proposed before, it's
> probably possible to make a layout similar to the one below
> 
> struct io_kiocb {
> 	...
> 	struct hlist_node	hash_node;
> 	struct callback_head	task_work;	
> 	union {
> 		struct io_wq_work	work;
> 		struct async_poll	apoll;
> 	};
> };
> 
> Saves ->apoll kmalloc(), and the actual work de-init would be negligibly
> rare. Worth to try

And hopefully get rid of the stupid apoll->work and the copy back and
forth... But yes, this would be most excellent, and an ideal layout.

>>> TBH, I don't think it'd do much, because init of ->io would probably
>>> hide any benefit.
>>
>> There should be no ->io init/alloc for this test case.
> 
> I mean, before getting into io_arm_poll_handler(), it should get -EAGAIN
> in io_{read,write}() and initialise ->io in io_setup_async_rw(), at least
> for READV, WRITEV.

Sure, but for my testing, there's never an EAGAIN, so I won't be
exercising that path for the peak testing.

-- 
Jens Axboe

