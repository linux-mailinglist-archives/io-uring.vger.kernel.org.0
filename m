Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F8145CBF2
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 19:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241695AbhKXSUy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 13:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhKXSUx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 13:20:53 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6F49C061574
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 10:17:43 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id f9so4340212ioo.11
        for <io-uring@vger.kernel.org>; Wed, 24 Nov 2021 10:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qdNYw7MlaeHdvI+Gff2jXbCCIW/XplvmMUOVBpQvAWU=;
        b=RUdNNClJepCKJ+uJoVXo5VN7qvwhccUQyBwMb9uceKgJNlUs4Xr4nV3f6BSSFFvogm
         QJC3K8OPpkO0MrsBDm1SCQmrcKDuWIYHOKcLwVj6/otYCQcqoVXJgcVBirD3IlD0VRLc
         AK/i4ZDbCU1GOb7gNKCj9YAHQjPrdwT1Gokja6xQxNc3Dema1Jrq8GM+k0tlDT5BS7kC
         zyeix5aCqVxjNp7H5rKnHYrb1napm1j8VY+ITDxvhUFhBUvWhKpTH89mu203379wlFdO
         vfhTtnBKXrfr/07KU8Km0L8+dz0qoBhKLB56pcLqi9ZX4BTzJEnKB3ApOmWRvXP4MLXD
         PbAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qdNYw7MlaeHdvI+Gff2jXbCCIW/XplvmMUOVBpQvAWU=;
        b=T75aZnbB9ekpl1+u79eHcomHxt8yf3kYjvmfKy130U1q3PKtfwfp4SrfoZ4sq62p3F
         XVShFAjUUjx6jMrT0gYmeptfdwqO2vPb9M4vgxdalyT6uJA1LmzetXO9HvB7jSkHgh7k
         /RZjcYSvsmJzhU3j2LbsU3pIE/FdJkLfvwMSSqf7Ek6MGEsmzhCaJPPBgYkwN31encyL
         Sn0O8wQsh27m3iw6kRJbBPFtYW3boE6QuvhAzmK2qR8FzgCrKC/E1FDfHOepapYHs+5p
         u0Md5NxrTWtvHRTf2RprTkR0lQ/6damdq8aZQbqb8IIjXVDjkLjME67tYkmYSZKgVnXU
         HJWA==
X-Gm-Message-State: AOAM531bYMXJWL8VPF7yrRZUTbMcqbetr+c+OlUxGviAT9t1+V6dBDuf
        5C4gNwZE2f8ZqEH9MhS58BYVAU6FVhb5U22o
X-Google-Smtp-Source: ABdhPJxHHWNh+ZveMSdSmyaiSFNKvpMmYYcfolHHLrDZ53pxlSiKJl/iwZ0gWsyPNmsXRWxE0iAj0Q==
X-Received: by 2002:a02:9a14:: with SMTP id b20mr19738560jal.52.1637777862084;
        Wed, 24 Nov 2021 10:17:42 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id 1sm266671ill.57.2021.11.24.10.17.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 10:17:41 -0800 (PST)
Subject: Re: [PATCH v2 0/4] allow to skip CQE posting
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1636559119.git.asml.silence@gmail.com>
 <239ab9cc-e53c-f8aa-6bbf-816dfac73f32@kernel.dk>
 <153a9c03-6fae-d821-c18b-9ea1bb7c62d5@gmail.com>
 <7a4f8655-06df-9549-e3df-c3bf972f06e6@kernel.dk>
 <39fad08c-f820-e4ef-6d30-4f63f00a3282@gmail.com>
 <3c9d0246-97f5-deb5-7d82-d6ba4d9aa990@kernel.dk>
 <9f825af2-3d51-c4d8-e986-eb1d5e7d6fe7@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e85246cb-a6b8-40f3-dc51-0ebb7ceb1328@kernel.dk>
Date:   Wed, 24 Nov 2021 11:17:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9f825af2-3d51-c4d8-e986-eb1d5e7d6fe7@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/24/21 11:02 AM, Pavel Begunkov wrote:
> On 11/24/21 17:57, Jens Axboe wrote:
>> On 11/24/21 10:55 AM, Pavel Begunkov wrote:
>>> On 11/10/21 16:47, Jens Axboe wrote:
>>>> On 11/10/21 9:42 AM, Pavel Begunkov wrote:
>>>>> On 11/10/21 16:14, Jens Axboe wrote:
>>>>>> On 11/10/21 8:49 AM, Pavel Begunkov wrote:
>>>>>>> It's expensive enough to post an CQE, and there are other
>>>>>>> reasons to want to ignore them, e.g. for link handling and
>>>>>>> it may just be more convenient for the userspace.
>>>>>>>
>>>>>>> Try to cover most of the use cases with one flag. The overhead
>>>>>>> is one "if (cqe->flags & IOSQE_CQE_SKIP_SUCCESS)" check per
>>>>>>> requests and a bit bloated req_set_fail(), should be bearable.
>>>>>>
>>>>>> I like the idea, one thing I'm struggling with is I think a normal use
>>>>>> case of this would be fast IO where we still need to know if a
>>>>>> completion event has happened, we just don't need to know the details of
>>>>>> it since we already know what those details would be if it ends up in
>>>>>> success.
>>>>>>
>>>>>> How about having a skip counter? That would supposedly also allow drain
>>>>>> to work, and it could be mapped with the other cq parts to allow the app
>>>>>> to see it as well.
>>>>>
>>>>> It doesn't go through expensive io_cqring_ev_posted(), so the
>>>>> userspace can't really wait on it. It can do some linking tricks to
>>>>> alleviate that, but I don't see any new capabilities from the current
>>>>> approach.
>>>>
>>>> I'm not talking about waiting, just reading the cqring entry to see how
>>>> many were skipped. If you ask for no cqe, by definition there would be
>>>> nothing to wait on for you. Though it'd probably be better as an sqring
>>>> entry, since we'd be accounting at that time. Only caveat there is then
>>>> if the sqe errors and we do end up posting a cqe..
>>>>
>>>>> Also the locking is a problem, I was thinking about it, mainly hoping
>>>>> that I can adjust cq_extra and leave draining, but it didn't appear
>>>>> great to me. AFAIK, it's either an atomic, beating the purpose of the
>>>>> thing.
>>>>
>>>> If we do submission side, then the ring mutex would cover it. No need
>>>> for any extra locking
>>>
>>> Jens, let's decide what we're going to do with this feature
>>
>> Only weird bit is the drain, but apart from that I think it looks sane.
> 
> agree, but I can't find a fix without penalising performance

I think we're OK as I don't DRAIN is used very much, and as long as it's
adequately documented in terms of them not co-existing and what the error
code is, then if we do find a way to  make them work together we can
relax them in the future.

>> Are you going to send a documentation update to liburing as well? Should
>> be detailed in terms of what it does and the usability of it.
> 
> yeah, and also need to rebase and resend tests

Great thanks.

-- 
Jens Axboe

