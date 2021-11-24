Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7497645CB7A
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 18:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241380AbhKXR6j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 12:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350105AbhKXR6h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 12:58:37 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57436C061574
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 09:55:27 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x6so14065830edr.5
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 09:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=dcCTdXhc/66Hxhv0CMUh76tN/9qtGJlnWHRrC4adIBQ=;
        b=YtPHQ79E+x9wT9iMjR545coJo3fL9wy0fusltLVJgLeHkDF4OapsbYSa3L5Trdndeu
         8+Y/G7Q5akApxVQ1buK3KFdkH93ME5Y1+DsPORi7lXEICGS65W12X8EIHvzqfLYG7t1S
         Lb+IP/JQEi+yBHEY8GdOGIV3l5Lze+4Xa1IVYOtxbqUv8jTItSsRHyBtUTJQLw2VgRTM
         5an/3fAhcPPU2v7s+K3CcatpURtIEGKfepFCupwmrY0F0/9R/MckWqlud1KPnHmta8A+
         TX3Juy6+dcCmz8rhLYedSkVV9rmrUj+L4/U/93pJ0ol5dZClCAnYhVtP8X8REShZm+gx
         dUrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dcCTdXhc/66Hxhv0CMUh76tN/9qtGJlnWHRrC4adIBQ=;
        b=J/RrdIFZZAVAMEhufF8/pflvshvzyt1oo5b+7kHx+QmO5bIOiLahv21IOfFu059OXW
         dQ8mC9j3lzHoT/rYT91uqL0glPAlBFcdN5HgXNnowWxD/CzxCoKafRQiWz8AqlGidJhT
         pOltkOzubDhc0tBtSwmYiroo3rtKZ+ytFc4UcNDAxFhA5Ei39I7uouBVrfwOPcbf0+1p
         xBMSbVn5zNEFvvvKQ+tLGF4bIrUW9nLyUDVsI9tzSGhDy+HWdx3gvPHLoSG706PA20iE
         6mIj6ORb9JIBiHgepdZ5386m1/nPbQvz0QXGe1GjABL+68VK6OcOJOM/56fDn+X7n59V
         qKzw==
X-Gm-Message-State: AOAM531+4CuT7uUeJMiofNXNTxL2NrO2xdvCaTERtZ49prmvPFGZsQ+G
        S0tKIMl/JMmQe/G+gB0h7IxK/XnUy6E=
X-Google-Smtp-Source: ABdhPJzsNUG3yKV5XAPLGjuiRDGSd9z47ye5ddM2EheavQMIozu/VdaGLJRmyiAbXTqaLJ35ADP6JQ==
X-Received: by 2002:a17:906:8051:: with SMTP id x17mr23015282ejw.473.1637776525856;
        Wed, 24 Nov 2021 09:55:25 -0800 (PST)
Received: from [192.168.8.198] ([148.252.128.180])
        by smtp.gmail.com with ESMTPSA id x14sm269526ejs.124.2021.11.24.09.55.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 09:55:25 -0800 (PST)
Message-ID: <39fad08c-f820-e4ef-6d30-4f63f00a3282@gmail.com>
Date:   Wed, 24 Nov 2021 17:55:20 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 0/4] allow to skip CQE posting
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1636559119.git.asml.silence@gmail.com>
 <239ab9cc-e53c-f8aa-6bbf-816dfac73f32@kernel.dk>
 <153a9c03-6fae-d821-c18b-9ea1bb7c62d5@gmail.com>
 <7a4f8655-06df-9549-e3df-c3bf972f06e6@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7a4f8655-06df-9549-e3df-c3bf972f06e6@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/10/21 16:47, Jens Axboe wrote:
> On 11/10/21 9:42 AM, Pavel Begunkov wrote:
>> On 11/10/21 16:14, Jens Axboe wrote:
>>> On 11/10/21 8:49 AM, Pavel Begunkov wrote:
>>>> It's expensive enough to post an CQE, and there are other
>>>> reasons to want to ignore them, e.g. for link handling and
>>>> it may just be more convenient for the userspace.
>>>>
>>>> Try to cover most of the use cases with one flag. The overhead
>>>> is one "if (cqe->flags & IOSQE_CQE_SKIP_SUCCESS)" check per
>>>> requests and a bit bloated req_set_fail(), should be bearable.
>>>
>>> I like the idea, one thing I'm struggling with is I think a normal use
>>> case of this would be fast IO where we still need to know if a
>>> completion event has happened, we just don't need to know the details of
>>> it since we already know what those details would be if it ends up in
>>> success.
>>>
>>> How about having a skip counter? That would supposedly also allow drain
>>> to work, and it could be mapped with the other cq parts to allow the app
>>> to see it as well.
>>
>> It doesn't go through expensive io_cqring_ev_posted(), so the
>> userspace can't really wait on it. It can do some linking tricks to
>> alleviate that, but I don't see any new capabilities from the current
>> approach.
> 
> I'm not talking about waiting, just reading the cqring entry to see how
> many were skipped. If you ask for no cqe, by definition there would be
> nothing to wait on for you. Though it'd probably be better as an sqring
> entry, since we'd be accounting at that time. Only caveat there is then
> if the sqe errors and we do end up posting a cqe..
> 
>> Also the locking is a problem, I was thinking about it, mainly hoping
>> that I can adjust cq_extra and leave draining, but it didn't appear
>> great to me. AFAIK, it's either an atomic, beating the purpose of the
>> thing.
> 
> If we do submission side, then the ring mutex would cover it. No need
> for any extra locking

Jens, let's decide what we're going to do with this feature

> 
>> Another option is to split it in two, one counter is kept under
>> ->uring_lock and another under ->completion_lock. But it'll be messy,
>> shifting flushing part of draining to a work-queue for mutex locking,
>> adding yet another bunch of counters that hard to maintain and so.
> 
> You'd only need the cqring counter for the unlikely event that the
> request is failed and does post an cqe, though.
> 
>> And __io_submit_flush_completions() would also need to go through
>> the request list one extra time to do the accounting, wouldn't
>> want to grow massively inlined io_req_complete_state().
> 

-- 
Pavel Begunkov
