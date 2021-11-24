Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA2645CBBB
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 19:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbhKXSFc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 13:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242387AbhKXSFb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 13:05:31 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F45C061574
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 10:02:21 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id r11so14163087edd.9
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 10:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=a96TsjGBRgkq3OSAWkA6vg0CqPq4yqAYUKZu9eNbMOE=;
        b=VqFRv5aR2f9Tu9tKcn9eOCVf9PuUhYuxgEeJto0SWT3AeZvjt1HsVWLsb3ozMJIcer
         Q3sFxH+AbLX+WzFfd8xA/8xd/2vCWJ2nID5LN6bSQVW1xrTVKhnXGkMOcwy6R7B0beeK
         dU9wp14lSb0mRLLvs0v8Ao7X3ueRT6/Vwd1vkIwkUdwI5Px1wqxdO1JNqKO3SEyCJp43
         Gk+aKDj+BIOO1WF/+FBwZ+aF18sV3JA6BMHBAvlgY6IEHPigGgZfSURTxpVy1578gIDT
         C4aJFuYBAPFOsLB7kBl0mAyMPnp2RYYlJGXkjQNSeOl4ij/1t1Gi+GQLpylbCs9/+ymE
         jbCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=a96TsjGBRgkq3OSAWkA6vg0CqPq4yqAYUKZu9eNbMOE=;
        b=gwmJt/Tas4FlbeaZZRlgpbYmAaUnYELjLx9sUjrF58GE8MIu4gGynNuPflLj5QKPIr
         Vgy6+DUJIdps2dDPV3gQ3ys1lCP0qQyYfeJ33hknBFF8j9tSbdJwnDsD3SjdHVepZFOu
         /6gWppZ48il1A6QWQk9jyIFcFHWBQ9u5/HRVOJpLXU1mJuOfVBzHNTbHGQjLSBUSuEqb
         nQGc+NuAoQ1zOBTTGR6yKVsTMARFb7JDiTOM5UsJf0iEf45FSxDH5xP04WsAfz9oOfhO
         H7LunU+3/aZqVnZ0TLU32jM/KcSqjggM/FOq2QPHyvSaosHv5pLoAUgwOVu7wNt5giGX
         CIKg==
X-Gm-Message-State: AOAM532ZkrMhrYWPn/U5656rgGHulyg9w9RMctbERnVMLDTrsVtVSvQh
        /clxyVHJHeM7AgKhrlpdM57cj4CQvRQ=
X-Google-Smtp-Source: ABdhPJx55LHpaoikMcHqyq4vqGf44l/xDSaq6KCPeWPab20bWZaHiGu+HzmHWdDk+olwyMU1FqsUgA==
X-Received: by 2002:a17:906:b00c:: with SMTP id v12mr21883461ejy.523.1637776940327;
        Wed, 24 Nov 2021 10:02:20 -0800 (PST)
Received: from [192.168.8.198] ([148.252.128.180])
        by smtp.gmail.com with ESMTPSA id gn16sm302790ejc.67.2021.11.24.10.02.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 10:02:20 -0800 (PST)
Message-ID: <9f825af2-3d51-c4d8-e986-eb1d5e7d6fe7@gmail.com>
Date:   Wed, 24 Nov 2021 18:02:15 +0000
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
 <39fad08c-f820-e4ef-6d30-4f63f00a3282@gmail.com>
 <3c9d0246-97f5-deb5-7d82-d6ba4d9aa990@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3c9d0246-97f5-deb5-7d82-d6ba4d9aa990@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/24/21 17:57, Jens Axboe wrote:
> On 11/24/21 10:55 AM, Pavel Begunkov wrote:
>> On 11/10/21 16:47, Jens Axboe wrote:
>>> On 11/10/21 9:42 AM, Pavel Begunkov wrote:
>>>> On 11/10/21 16:14, Jens Axboe wrote:
>>>>> On 11/10/21 8:49 AM, Pavel Begunkov wrote:
>>>>>> It's expensive enough to post an CQE, and there are other
>>>>>> reasons to want to ignore them, e.g. for link handling and
>>>>>> it may just be more convenient for the userspace.
>>>>>>
>>>>>> Try to cover most of the use cases with one flag. The overhead
>>>>>> is one "if (cqe->flags & IOSQE_CQE_SKIP_SUCCESS)" check per
>>>>>> requests and a bit bloated req_set_fail(), should be bearable.
>>>>>
>>>>> I like the idea, one thing I'm struggling with is I think a normal use
>>>>> case of this would be fast IO where we still need to know if a
>>>>> completion event has happened, we just don't need to know the details of
>>>>> it since we already know what those details would be if it ends up in
>>>>> success.
>>>>>
>>>>> How about having a skip counter? That would supposedly also allow drain
>>>>> to work, and it could be mapped with the other cq parts to allow the app
>>>>> to see it as well.
>>>>
>>>> It doesn't go through expensive io_cqring_ev_posted(), so the
>>>> userspace can't really wait on it. It can do some linking tricks to
>>>> alleviate that, but I don't see any new capabilities from the current
>>>> approach.
>>>
>>> I'm not talking about waiting, just reading the cqring entry to see how
>>> many were skipped. If you ask for no cqe, by definition there would be
>>> nothing to wait on for you. Though it'd probably be better as an sqring
>>> entry, since we'd be accounting at that time. Only caveat there is then
>>> if the sqe errors and we do end up posting a cqe..
>>>
>>>> Also the locking is a problem, I was thinking about it, mainly hoping
>>>> that I can adjust cq_extra and leave draining, but it didn't appear
>>>> great to me. AFAIK, it's either an atomic, beating the purpose of the
>>>> thing.
>>>
>>> If we do submission side, then the ring mutex would cover it. No need
>>> for any extra locking
>>
>> Jens, let's decide what we're going to do with this feature
> 
> Only weird bit is the drain, but apart from that I think it looks sane.

agree, but I can't find a fix without penalising performance

> Are you going to send a documentation update to liburing as well? Should
> be detailed in terms of what it does and the usability of it.

yeah, and also need to rebase and resend tests

-- 
Pavel Begunkov
