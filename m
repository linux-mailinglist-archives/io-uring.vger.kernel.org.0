Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FFA4A908B
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 23:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355736AbiBCWQN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 17:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbiBCWQN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 17:16:13 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBF2C06173B
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 14:16:13 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so11313145pjj.4
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 14:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wF+Jmn9gWJUkdL4XKjJ8vgJJWNKU35vvnzSuRc8PN5Q=;
        b=GGo6gaJFMbgYTTuGPg8+xxapDAKK1AoJPtWyitET8UeYCT6aw6rlXQznUev0bDTH4v
         jsx724Annkq9eT47mBVels5GSoDInWT/A5LzW+i0QXCMIqJ1/RBic72KcDMO98zZoa/t
         aUli26OT4FBXcyU7lbIkrKfF8ZCuFL8FDnUHnZjc1U71+nCy9wTxEzt8oLIHkN7EMW5C
         z5Cv8jT3S6RHrn8PVrmJmjkTUfFfw1OLrlbc2ye9GMOpJHKKO3phXXAu7V5PjdK1Hrns
         8B5t5Xk69ub/jqvcqTnPSkaqMOVpGcyf7F7v3GhyLRNhE8+W6Tj5Gv3HzIwdc6rK/sTi
         8B9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wF+Jmn9gWJUkdL4XKjJ8vgJJWNKU35vvnzSuRc8PN5Q=;
        b=t7SiPq4q7oykfm+NO2H9+cjSZSZWAkYKmPlrPPYJnu0bjo1SeEZqU9ijg+4NyF1WqN
         EIcJrdujW+AOC5KH8evJIdFaVMsONIWbdIFSMNFunkK6ljUB6MR41095Nb60P1v/c1bF
         xevMcecv217Gs30PukSX6Vc1jcbjmL/Q1I1u/oouLA/nQzxgDu8NFERSz0Vcw4PNbc8D
         75rppxHU75k1zcyHM2RBBcerYAjaFrFM2GPyVr4GusRWX09/saMHeOxMnnxWNZxDFkFl
         36FzfkkZBrn57gLKl5L6xbmrcrKJjQoN+YArNJu8ExFDnbYnk79b2Czf5KttfqlH9Vl2
         WHUw==
X-Gm-Message-State: AOAM531pyBIye8sjS5Sen2icN9yI15t0Bp5HaK7NM9x/JEDNiZVnKnNI
        bH2UY7QJQeLMua6BKmanonOOUA==
X-Google-Smtp-Source: ABdhPJzgWKRvlrq0OdVAtkNHPx6X+C7JYM4nQdSwb4xDp0WcsTw4OCO71XeMPI+YqLKOIbe+NDOXVw==
X-Received: by 2002:a17:902:db02:: with SMTP id m2mr22417plx.136.1643926572417;
        Thu, 03 Feb 2022 14:16:12 -0800 (PST)
Received: from ?IPv6:2600:380:7677:2608:7e4f:2c76:b02e:3fbc? ([2600:380:7677:2608:7e4f:2c76:b02e:3fbc])
        by smtp.gmail.com with ESMTPSA id j4sm10095pfc.217.2022.02.03.14.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 14:16:12 -0800 (PST)
Subject: Re: [External] Re: [PATCH v3 2/3] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Usama Arif <usama.arif@bytedance.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203174108.668549-1-usama.arif@bytedance.com>
 <20220203174108.668549-3-usama.arif@bytedance.com>
 <ffa271c7-3f49-2b5a-b67e-3bb1b052ee4e@kernel.dk>
 <877d54b9-5baa-f0b5-23fe-25aef78e37c4@bytedance.com>
 <dc6bb53f-19cc-ee23-2137-6e27396f7d57@kernel.dk>
 <ac5f5152-f9e4-8e83-642b-73c2620ce7c0@gmail.com>
 <a5992789-6b0b-f3a8-0a24-e00add2a005a@kernel.dk>
 <fc97036f-26a3-afb1-180f-30aa89d3cc01@bytedance.com>
 <a2939109-5f97-ff56-df53-0a56ba12e268@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <582c8c6f-cbcf-f8d7-4976-e70d0d51c42d@kernel.dk>
Date:   Thu, 3 Feb 2022 15:16:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a2939109-5f97-ff56-df53-0a56ba12e268@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 2:47 PM, Pavel Begunkov wrote:
> On 2/3/22 19:54, Usama Arif wrote:
>> On 03/02/2022 19:06, Jens Axboe wrote:
>>> On 2/3/22 12:00 PM, Pavel Begunkov wrote:
>>>> On 2/3/22 18:29, Jens Axboe wrote:
>>>>> On 2/3/22 11:26 AM, Usama Arif wrote:
>>>>>> Hmm, maybe i didn't understand you and Pavel correctly. Are you
>>>>>> suggesting to do the below diff over patch 3? I dont think that would be
>>>>>> correct, as it is possible that just after checking if ctx->io_ev_fd is
>>>>>> present unregister can be called by another thread and set ctx->io_ev_fd
>>>>>> to NULL that would cause a NULL pointer exception later? In the current
>>>>>> patch, the check of whether ev_fd exists happens as the first thing
>>>>>> after rcu_read_lock and the rcu_read_lock are extremely cheap i believe.
>>>>>
>>>>> They are cheap, but they are still noticeable at high requests/sec
>>>>> rates. So would be best to avoid them.
>>>>>
>>>>> And yes it's obviously racy, there's the potential to miss an eventfd
>>>>> notification if it races with registering an eventfd descriptor. But
>>>>> that's not really a concern, as if you register with inflight IO
>>>>> pending, then that always exists just depending on timing. The only
>>>>> thing I care about here is that it's always _safe_. Hence something ala
>>>>> what you did below is totally fine, as we're re-evaluating under rcu
>>>>> protection.
>>>>
>>>> Indeed, the patch doesn't have any formal guarantees for propagation
>>>> to already inflight requests, so this extra unsynchronised check
>>>> doesn't change anything.
>>>>
>>>> I'm still more сurious why we need RCU and extra complexity when
>>>> apparently there is no use case for that. If it's only about
>>>> initial initialisation, then as I described there is a much
>>>> simpler approach.
>>>
>>> Would be nice if we could get rid of the quiesce code in general, but I
>>> haven't done a check to see what'd be missing after this...
>>>
>>
>> I had checked! I had posted below in in reply to v1 (https://lore.kernel.org/io-uring/02fb0bc3-fc38-b8f0-3067-edd2a525ef29@gmail.com/T/#m5ac7867ac61d86fe62c099be793ffe5a9a334976), but i think it got missed! Copy-pasting here for reference:
> 
> May have missed it then, apologies
> 
>> "
>> I see that if we remove ring quiesce from the the above 3 opcodes, then
>> only IORING_REGISTER_ENABLE_RINGS and IORING_REGISTER_RESTRICTIONS is
>> left for ring quiesce. I just had a quick look at those, and from what i
>> see we might not need to enter ring quiesce in
>> IORING_REGISTER_ENABLE_RINGS as the ring is already disabled at that point?
>> And for IORING_REGISTER_RESTRICTIONS if we do a similar approach to
>> IORING_REGISTER_EVENTFD, i.e. wrap ctx->restrictions inside an RCU
>> protected data structure, use spin_lock to prevent multiple
>> io_register_restrictions calls at the same time, and use read_rcu_lock
>> in io_check_restriction, then we can remove ring quiesce from
>> io_uring_register altogether?
>>
>> My usecase only uses IORING_REGISTER_EVENTFD, but i think entering ring
>> quiesce costs similar in other opcodes. If the above sounds reasonable,
>> please let me know and i can send patches for removing ring quiesce for
>> io_uring_register.
>> "
>>
>> Let me know if above makes sense, i can add patches on top of the current patchset, or we can do it after they get merged.
>>
>> As for why, quiesce state is very expensive. its making io_uring_register the most expensive syscall in my usecase (~15ms) compared to ~0.1ms now with RCU, which is why i started investigating this. And this patchset avoids ring quiesce for 3 of the opcodes, so it would generally be quite helpful if someone does registers and unregisters eventfd multiple times.
> 
> I agree that 15ms for initial setup is silly and it has to be
> reduced. However, I'm trying weight the extra complexity against
> potential benefits of _also_ optimising [de,re]-registration
> 
> Considering that you only register it one time at the beginning,
> we risk adding a yet another feature that nobody is going to ever
> use. This doesn't give me a nice feeling, well, unless you do
> have a use case.

It's not really a new feature, it's just making the existing one not
suck quite as much...

> To emphasise, I'm comparing 15->0.1 improvement for only initial
> registration (which is simpler) vs 15->0.1 for both registration
> and unregistration.

reg+unreg should be way faster too, if done properly with the assignment
tricks.

> fwiw, it alters userpace visible behaviour in either case, shouldn't
> be as important here but there is always a chance to break userspace

It doesn't alter userspace behavior, if the registration works like I
described with being able to assign a new one while the old one is being
torn down.

Or do you mean wrt inflight IO? I don't think the risk is very high
there, to be honest.

-- 
Jens Axboe

