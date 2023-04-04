Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14DB66D6C0C
	for <lists+io-uring@lfdr.de>; Tue,  4 Apr 2023 20:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235822AbjDDSaG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Apr 2023 14:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236580AbjDDS3u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Apr 2023 14:29:50 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D585FD8;
        Tue,  4 Apr 2023 11:27:08 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id eg48so134192646edb.13;
        Tue, 04 Apr 2023 11:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680632827;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Oedm92q8dEJmYYquU7xOB7iabQvVyp0aN9fXWUk/yrA=;
        b=XiyYVXewFcg5Zs/RE3zSz+hp+YPUew6NpGgnpbQVaBtPEPsbuwFLRt4F1SKiDLvQxw
         zCqGADWlYpvjJYZYge+LtD1oumYB4Dha7EZj2EAJQypq2ZIse29NyEj7XqN2Du6kG7bK
         /V0ovLU9xvpCoSbaSk9h8j3e9h3ibaf9lv20xhhLwMI20nWFUP7NXN/1RqOorlNwqJXd
         i+CudN0h/xTXXO8EKdkZUrH48IOw6DYTDGjmnHZVS6MOzMYrRmS5pa7vK5WXrLlb56xV
         Zv3HoYKVMSdC+95rN1p+50LrxL+22N0AQY0DcRbJncfeuUfuhPUFTFd4pdL7fifDItUU
         AiZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680632827;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oedm92q8dEJmYYquU7xOB7iabQvVyp0aN9fXWUk/yrA=;
        b=tp3Iij4AlYmQz9Jusaz46nXp8wFx1e9IHBDshFZ/4yPDuujGWk1x2wbx0ofYJLB6yE
         uod6CCDC0n8MoEvcJl82pl4wrmoIIyMxGbWIZtiZJEkRiwrP3nx/BW4QNxmB6b1E9EQQ
         9ZOfAwI3x+tlmsxey48aqwepzZDM0jH6VbN92Gc3cfWiilqzkZ07OqGW/sys/r6wYRlZ
         fKIwWG/AZ7jFRbs2xWEsCHiPzW3C0bGJkl/53vjMDUVo/z5Ytqtxl58sdKwjiV8Om0Km
         aoF27vGnHCwlJoVv9GbeyYr5bP/ZpaH9ZUfaNq9vhhl9ysGSiIY4wt3AL19+oIjqsubG
         nn9Q==
X-Gm-Message-State: AAQBX9cJbQ0Af4Djl6uPUrdrHR7WHGRK75w7SX0pSI1/VwwlOp1kQh1Y
        zhOyhObSKvzkQRQKWNtn18sIA85v/Zo=
X-Google-Smtp-Source: AKy350bQwaPCMWY/yelOwSCvM2MDgdKIQJ7a7YBNwjxQ/uRs4U1uhwMQZH45SdEsYx4tPg62lNdc9w==
X-Received: by 2002:a17:907:7893:b0:933:44ef:851e with SMTP id ku19-20020a170907789300b0093344ef851emr463575ejc.55.1680632827025;
        Tue, 04 Apr 2023 11:27:07 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:b4a4])
        by smtp.gmail.com with ESMTPSA id c26-20020a170906341a00b008df7d2e122dsm6212465ejb.45.2023.04.04.11.27.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 11:27:06 -0700 (PDT)
Message-ID: <b0189d79-2423-c88d-9da7-4a4ad6720808@gmail.com>
Date:   Tue, 4 Apr 2023 19:26:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 10/11] io_uring/rsrc: cache struct io_rsrc_node
To:     Gabriel Krisman Bertazi <krisman@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1680187408.git.asml.silence@gmail.com>
 <7f5eb1b89e8dcf93739607c79bbf7aec1784cbbe.1680187408.git.asml.silence@gmail.com>
 <87cz4p1083.fsf@suse.de> <6eaadad2-d6a6-dfbb-88aa-8ae68af2f89d@gmail.com>
 <87wn2wzcv3.fsf@suse.de> <4cc86e76-46b7-09ce-65f9-cd27ffe4b26e@gmail.com>
 <87h6tvzm0g.fsf@suse.de> <1e9a6dd5-b8c4-ef63-bf76-075ba0d42093@kernel.dk>
 <87cz4jzj0y.fsf@suse.de>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <87cz4jzj0y.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/4/23 17:53, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 4/4/23 9:48?AM, Gabriel Krisman Bertazi wrote:
>>> Pavel Begunkov <asml.silence@gmail.com> writes:
>>>
>>>> On 4/1/23 01:04, Gabriel Krisman Bertazi wrote:
>>>>> Pavel Begunkov <asml.silence@gmail.com> writes:
>>>
>>>>>> I didn't try it, but kmem_cache vs kmalloc, IIRC, doesn't bring us
>>>>>> much, definitely doesn't spare from locking, and the overhead
>>>>>> definitely wasn't satisfactory for requests before.
>>>>> There is no locks in the fast path of slub, as far as I know.  it has
>>>>> a
>>>>> per-cpu cache that is refilled once empty, quite similar to the fastpath
>>>>> of this cache.  I imagine the performance hit in slub comes from the
>>>>> barrier and atomic operations?
>>>>
>>>> Yeah, I mean all kinds of synchronisation. And I don't think
>>>> that's the main offender here, the test is single threaded without
>>>> contention and the system was mostly idle.
>>>>
>>>>> kmem_cache works fine for most hot paths of the kernel.  I think this
>>>>
>>>> It doesn't for io_uring. There are caches for the net side and now
>>>> in the block layer as well. I wouldn't say it necessarily halves
>>>> performance but definitely takes a share of CPU.
>>>
>>> Right.  My point is that all these caches (block, io_uring) duplicate
>>> what the slab cache is meant to do.  Since slab became a bottleneck, I'm
>>> looking at how to improve the situation on their side, to see if we can
>>> drop the caching here and in block/.
>>
>> That would certainly be a worthy goal, and I do agree that these caches
>> are (largely) working around deficiencies. One important point that you
>> may miss is that most of this caching gets its performance from both
>> avoiding atomics in slub, but also because we can guarantee that both
>> alloc and free happen from process context. The block IRQ bits are a bit
>> different, but apart from that, it's true elsewhere. Caching that needs
>> to even disable IRQs locally generally doesn't beat out slub by much,
>> the big wins are the cases where we know free+alloc is done in process
>> context.
> 
> Yes, I noticed that.  I was thinking of exposing a flag at kmem_cache
> creation-time to tell slab the user promises not to use it in IRQ
> context, so it doesn't need to worry about nested invocation in the
> allocation/free path.  Then, for those caches, have a
> kmem_cache_alloc_locked variant, where the synchronization is maintained
> by the caller (i.e. by ->uring_lock here), so it can manipulate the
> cache without atomics.
> 
> I was looking at your implementation of the block cache for inspiration
> and saw how you kept a second list for IRQ.  I'm thinking how to fit a

It works fine, but one problem I had while implementing it is
local_irq_save() in bio_put_percpu_cache() not being so cheap even when
interrupts are already disabled. Apparently, raw_local_save_flags() is
not as free as I wished it to be, and we can't easily pass the current
context. Would be nice to do something about it at some point.


> similar change inside slub.  But for now, I want to get the simpler
> case, which is all io_uring need.
> 
> I'll try to get a prototype before lsfmm and see if I get the MM folks
> input there.
> 

-- 
Pavel Begunkov
