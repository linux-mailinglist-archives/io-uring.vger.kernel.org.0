Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E584A9039
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 22:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355516AbiBCVwQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 16:52:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355311AbiBCVwP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 16:52:15 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169BBC061714;
        Thu,  3 Feb 2022 13:52:15 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id o1-20020a1c4d01000000b0034d95625e1fso8128950wmh.4;
        Thu, 03 Feb 2022 13:52:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=buRa9dy1somA+KRSylXRCFC8cwfGjuaHgmtJ/vC9N5I=;
        b=AJNb52/UXg2h/IDNv/EvUdWeUh6pcQr6BUVY2EpdPy9u87X12BXD2JXN0P4WCGQtPN
         vvV6SVqmjQz7RJxChS7bwJl65p5kVU69BBes0C+l84m1I/++PUxcpPCV5bHd5FZu7WdC
         C4x4i1MfPCF44QyGdPdxgKDeKrQ5l0+QTxg85Pfpmepaa/fCpHb+yL5XlVYqCNKuOUTf
         OGCTZCnAASFiJ2kc/PRnajASxWLpiOgZtZebOmwzPxLzHs3WarP/uPY3XB6EketqJiYv
         kXe/cyB6tqWk0LqgtIuVIalJUlhrMiKvohA/evJaxHjrSdXNuH0c8gbu8efqAZw+47SD
         mUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=buRa9dy1somA+KRSylXRCFC8cwfGjuaHgmtJ/vC9N5I=;
        b=etszp/6QbEpBplZhHZbf3LtK3CoxjI9WOBt4igzoD+uyGuTvh0l1aoc6eigRqZQGWm
         5MIPnSYZS3GySmciHClDyeYkxwM75iDDUf5k8JpIcNDARlT9mcPH6SMWY7BZRchnHd6h
         +d+hkQQ05vhLrZVmgOv9oZYGT72NLNOEuBkfXCkClUNk0K3FGb2K1W7e3dELQ/6CRB/a
         4qLV0JePbU/PTlUA1WwFZQ5RmK7T9jQBbhihNsRJUH0ZFiUAZHF1mnfP+xSfO3ny3gnI
         dr9JF5WwlsDBj/0oK1aRtx6KkITQOgzDsX/pntSRwuAoJ0IAbbrTeng7Yv+cmM0ksJ+T
         Ey0A==
X-Gm-Message-State: AOAM532irNy0iiz0iPvpP5f7UQfwt8GSkzjD0ZBU8zz94MO+AvT+zbUF
        PZLLI+uvvq9WYkBU2Q/OCwsBO1KjfTU=
X-Google-Smtp-Source: ABdhPJzPWwnqVZ6nC+SkSCc23HRV11PNduKuSsjkFgoYPxIiyQtPgz7ZqNcgsVUX7Sh0vdGTTA/TPw==
X-Received: by 2002:a05:600c:3593:: with SMTP id p19mr11818890wmq.172.1643925133525;
        Thu, 03 Feb 2022 13:52:13 -0800 (PST)
Received: from [192.168.8.198] ([85.255.232.204])
        by smtp.gmail.com with ESMTPSA id u14sm20350wrs.55.2022.02.03.13.52.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 13:52:13 -0800 (PST)
Message-ID: <a2939109-5f97-ff56-df53-0a56ba12e268@gmail.com>
Date:   Thu, 3 Feb 2022 21:47:21 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [External] Re: [PATCH v3 2/3] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
Content-Language: en-US
To:     Usama Arif <usama.arif@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203174108.668549-1-usama.arif@bytedance.com>
 <20220203174108.668549-3-usama.arif@bytedance.com>
 <ffa271c7-3f49-2b5a-b67e-3bb1b052ee4e@kernel.dk>
 <877d54b9-5baa-f0b5-23fe-25aef78e37c4@bytedance.com>
 <dc6bb53f-19cc-ee23-2137-6e27396f7d57@kernel.dk>
 <ac5f5152-f9e4-8e83-642b-73c2620ce7c0@gmail.com>
 <a5992789-6b0b-f3a8-0a24-e00add2a005a@kernel.dk>
 <fc97036f-26a3-afb1-180f-30aa89d3cc01@bytedance.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <fc97036f-26a3-afb1-180f-30aa89d3cc01@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 19:54, Usama Arif wrote:
> On 03/02/2022 19:06, Jens Axboe wrote:
>> On 2/3/22 12:00 PM, Pavel Begunkov wrote:
>>> On 2/3/22 18:29, Jens Axboe wrote:
>>>> On 2/3/22 11:26 AM, Usama Arif wrote:
>>>>> Hmm, maybe i didn't understand you and Pavel correctly. Are you
>>>>> suggesting to do the below diff over patch 3? I dont think that would be
>>>>> correct, as it is possible that just after checking if ctx->io_ev_fd is
>>>>> present unregister can be called by another thread and set ctx->io_ev_fd
>>>>> to NULL that would cause a NULL pointer exception later? In the current
>>>>> patch, the check of whether ev_fd exists happens as the first thing
>>>>> after rcu_read_lock and the rcu_read_lock are extremely cheap i believe.
>>>>
>>>> They are cheap, but they are still noticeable at high requests/sec
>>>> rates. So would be best to avoid them.
>>>>
>>>> And yes it's obviously racy, there's the potential to miss an eventfd
>>>> notification if it races with registering an eventfd descriptor. But
>>>> that's not really a concern, as if you register with inflight IO
>>>> pending, then that always exists just depending on timing. The only
>>>> thing I care about here is that it's always _safe_. Hence something ala
>>>> what you did below is totally fine, as we're re-evaluating under rcu
>>>> protection.
>>>
>>> Indeed, the patch doesn't have any formal guarantees for propagation
>>> to already inflight requests, so this extra unsynchronised check
>>> doesn't change anything.
>>>
>>> I'm still more сurious why we need RCU and extra complexity when
>>> apparently there is no use case for that. If it's only about
>>> initial initialisation, then as I described there is a much
>>> simpler approach.
>>
>> Would be nice if we could get rid of the quiesce code in general, but I
>> haven't done a check to see what'd be missing after this...
>>
> 
> I had checked! I had posted below in in reply to v1 (https://lore.kernel.org/io-uring/02fb0bc3-fc38-b8f0-3067-edd2a525ef29@gmail.com/T/#m5ac7867ac61d86fe62c099be793ffe5a9a334976), but i think it got missed! Copy-pasting here for reference:

May have missed it then, apologies

> "
> I see that if we remove ring quiesce from the the above 3 opcodes, then
> only IORING_REGISTER_ENABLE_RINGS and IORING_REGISTER_RESTRICTIONS is
> left for ring quiesce. I just had a quick look at those, and from what i
> see we might not need to enter ring quiesce in
> IORING_REGISTER_ENABLE_RINGS as the ring is already disabled at that point?
> And for IORING_REGISTER_RESTRICTIONS if we do a similar approach to
> IORING_REGISTER_EVENTFD, i.e. wrap ctx->restrictions inside an RCU
> protected data structure, use spin_lock to prevent multiple
> io_register_restrictions calls at the same time, and use read_rcu_lock
> in io_check_restriction, then we can remove ring quiesce from
> io_uring_register altogether?
> 
> My usecase only uses IORING_REGISTER_EVENTFD, but i think entering ring
> quiesce costs similar in other opcodes. If the above sounds reasonable,
> please let me know and i can send patches for removing ring quiesce for
> io_uring_register.
> "
> 
> Let me know if above makes sense, i can add patches on top of the current patchset, or we can do it after they get merged.
> 
> As for why, quiesce state is very expensive. its making io_uring_register the most expensive syscall in my usecase (~15ms) compared to ~0.1ms now with RCU, which is why i started investigating this. And this patchset avoids ring quiesce for 3 of the opcodes, so it would generally be quite helpful if someone does registers and unregisters eventfd multiple times.

I agree that 15ms for initial setup is silly and it has to be
reduced. However, I'm trying weight the extra complexity against
potential benefits of _also_ optimising [de,re]-registration

Considering that you only register it one time at the beginning,
we risk adding a yet another feature that nobody is going to ever
use. This doesn't give me a nice feeling, well, unless you do
have a use case.

To emphasise, I'm comparing 15->0.1 improvement for only initial
registration (which is simpler) vs 15->0.1 for both registration
and unregistration.

fwiw, it alters userpace visible behaviour in either case, shouldn't
be as important here but there is always a chance to break userspace

-- 
Pavel Begunkov
