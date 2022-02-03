Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 468BC4A9125
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 00:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355643AbiBCX0r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 18:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355983AbiBCX0o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 18:26:44 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A75C061714;
        Thu,  3 Feb 2022 15:26:44 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id k18so7991367wrg.11;
        Thu, 03 Feb 2022 15:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=myVtROYgMKE1wZAdyLUyq1uGnyhk8OXwXD/l2iqY7sw=;
        b=k37bXsanbVrjOlLv4wC/AL6qV941j3a0RvFnpqvUUBbhUw3j0z00u1LTEVo1WnPWmj
         Aigl0CZLcs06jqA6X3kB7begqSBivKkxA8kXy77fkvZWg0AQLJQhJLalkTANXhr9yFft
         h1ff4RtHvkZgiFszHPk59XHelYWiz5v634gjKOQAj9LyiwWTctoY6WyEFZQfpUqHyorE
         d+f2Vog1hmnHyojNVvmfz7otrvviQ0LCoogAc+UdcL2GCijcffZntNtGrj92gHVwDOPH
         MkUpOjs+INdSTBqhkgJeiTr+vMv8d7YT7rfU8VVBMQJEy3bVE/hLVmj33eAgu8v+ZSRk
         RsbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=myVtROYgMKE1wZAdyLUyq1uGnyhk8OXwXD/l2iqY7sw=;
        b=fiFTvBt/8VkXRnlEjny6AYFthaxv8gyYWZwC8V8Dlg61++hlO1IjzRbF764FXtSh8K
         NRwqXoH3u4Q6jze3UZemvPBWG92wy77j9uanigbHF+4T5Jel09H05r7trLvPpiQLJ0oc
         MqvEU9GZk8CQxAhui4L7Ovjs20waHuxaGB7Rijn1/6QSd/UCgjkSmzgOhhD8Qg/OLRwr
         ZDAF7dYd3jUpdEY5X50lwAUP6VUaNOvrV60YqWGeveq/GcJRuvFqWUJhbsYlWLznr4hg
         hzjt+upvTFflV3oSXKJ8omRxdl/2XSxDTpoirL5MJTZCkkGax6JHxGpJiBOIHri0mXEd
         6ohw==
X-Gm-Message-State: AOAM531GnKfA5CKrvfFhmW4eVA1ix96GN1ePZKAsKskHVzETGcq/FrZh
        UAJoVDMjWrxnFJwoE5etqtQ=
X-Google-Smtp-Source: ABdhPJwzGTdqmsldZcdMUarsFpmwzYrK9XBhdJLM6+BLH5WHBw6etuBseYorYuEzeMq2sZ1lC5s0ww==
X-Received: by 2002:a5d:500c:: with SMTP id e12mr177221wrt.193.1643930802640;
        Thu, 03 Feb 2022 15:26:42 -0800 (PST)
Received: from [192.168.8.198] ([85.255.232.204])
        by smtp.gmail.com with ESMTPSA id p2sm120572wmc.33.2022.02.03.15.26.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 15:26:42 -0800 (PST)
Message-ID: <2104dd91-676b-84af-3005-a40c996b9403@gmail.com>
Date:   Thu, 3 Feb 2022 23:21:41 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [External] Re: [PATCH v3 2/3] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
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
 <582c8c6f-cbcf-f8d7-4976-e70d0d51c42d@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <582c8c6f-cbcf-f8d7-4976-e70d0d51c42d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 22:16, Jens Axboe wrote:
> On 2/3/22 2:47 PM, Pavel Begunkov wrote:
>> On 2/3/22 19:54, Usama Arif wrote:
>>> On 03/02/2022 19:06, Jens Axboe wrote:
>>>> On 2/3/22 12:00 PM, Pavel Begunkov wrote:
>>>>> On 2/3/22 18:29, Jens Axboe wrote:
>>>>>> On 2/3/22 11:26 AM, Usama Arif wrote:
>>>>>>> Hmm, maybe i didn't understand you and Pavel correctly. Are you
>>>>>>> suggesting to do the below diff over patch 3? I dont think that would be
>>>>>>> correct, as it is possible that just after checking if ctx->io_ev_fd is
>>>>>>> present unregister can be called by another thread and set ctx->io_ev_fd
>>>>>>> to NULL that would cause a NULL pointer exception later? In the current
>>>>>>> patch, the check of whether ev_fd exists happens as the first thing
>>>>>>> after rcu_read_lock and the rcu_read_lock are extremely cheap i believe.
>>>>>>
>>>>>> They are cheap, but they are still noticeable at high requests/sec
>>>>>> rates. So would be best to avoid them.
>>>>>>
>>>>>> And yes it's obviously racy, there's the potential to miss an eventfd
>>>>>> notification if it races with registering an eventfd descriptor. But
>>>>>> that's not really a concern, as if you register with inflight IO
>>>>>> pending, then that always exists just depending on timing. The only
>>>>>> thing I care about here is that it's always _safe_. Hence something ala
>>>>>> what you did below is totally fine, as we're re-evaluating under rcu
>>>>>> protection.
>>>>>
>>>>> Indeed, the patch doesn't have any formal guarantees for propagation
>>>>> to already inflight requests, so this extra unsynchronised check
>>>>> doesn't change anything.
>>>>>
>>>>> I'm still more сurious why we need RCU and extra complexity when
>>>>> apparently there is no use case for that. If it's only about
>>>>> initial initialisation, then as I described there is a much
>>>>> simpler approach.
>>>>
>>>> Would be nice if we could get rid of the quiesce code in general, but I
>>>> haven't done a check to see what'd be missing after this...
>>>>
>>>
>>> I had checked! I had posted below in in reply to v1 (https://lore.kernel.org/io-uring/02fb0bc3-fc38-b8f0-3067-edd2a525ef29@gmail.com/T/#m5ac7867ac61d86fe62c099be793ffe5a9a334976), but i think it got missed! Copy-pasting here for reference:
>>
>> May have missed it then, apologies
>>
>>> "
>>> I see that if we remove ring quiesce from the the above 3 opcodes, then
>>> only IORING_REGISTER_ENABLE_RINGS and IORING_REGISTER_RESTRICTIONS is
>>> left for ring quiesce. I just had a quick look at those, and from what i
>>> see we might not need to enter ring quiesce in
>>> IORING_REGISTER_ENABLE_RINGS as the ring is already disabled at that point?
>>> And for IORING_REGISTER_RESTRICTIONS if we do a similar approach to
>>> IORING_REGISTER_EVENTFD, i.e. wrap ctx->restrictions inside an RCU
>>> protected data structure, use spin_lock to prevent multiple
>>> io_register_restrictions calls at the same time, and use read_rcu_lock
>>> in io_check_restriction, then we can remove ring quiesce from
>>> io_uring_register altogether?
>>>
>>> My usecase only uses IORING_REGISTER_EVENTFD, but i think entering ring
>>> quiesce costs similar in other opcodes. If the above sounds reasonable,
>>> please let me know and i can send patches for removing ring quiesce for
>>> io_uring_register.
>>> "
>>>
>>> Let me know if above makes sense, i can add patches on top of the current patchset, or we can do it after they get merged.
>>>
>>> As for why, quiesce state is very expensive. its making io_uring_register the most expensive syscall in my usecase (~15ms) compared to ~0.1ms now with RCU, which is why i started investigating this. And this patchset avoids ring quiesce for 3 of the opcodes, so it would generally be quite helpful if someone does registers and unregisters eventfd multiple times.
>>
>> I agree that 15ms for initial setup is silly and it has to be
>> reduced. However, I'm trying weight the extra complexity against
>> potential benefits of _also_ optimising [de,re]-registration
>>
>> Considering that you only register it one time at the beginning,
>> we risk adding a yet another feature that nobody is going to ever
>> use. This doesn't give me a nice feeling, well, unless you do
>> have a use case.
> 
> It's not really a new feature, it's just making the existing one not
> suck quite as much...

Does it matter when nobody uses it? My point is that does not.


>> To emphasise, I'm comparing 15->0.1 improvement for only initial
>> registration (which is simpler) vs 15->0.1 for both registration
>> and unregistration.
> 
> reg+unreg should be way faster too, if done properly with the assignment
> tricks.
> 
>> fwiw, it alters userpace visible behaviour in either case, shouldn't
>> be as important here but there is always a chance to break userspace
> 
> It doesn't alter userspace behavior, if the registration works like I
> described with being able to assign a new one while the old one is being
> torn down.
> 
> Or do you mean wrt inflight IO? I don't think the risk is very high
> there, to be honest.

Right, if somebody tries such a trick it'll be pretty confusing to
get randomly firing eventfd, though it's rather a marginal case.

-- 
Pavel Begunkov
