Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F196C266959
	for <lists+io-uring@lfdr.de>; Fri, 11 Sep 2020 22:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725798AbgIKUGS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Sep 2020 16:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgIKUGP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Sep 2020 16:06:15 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF67BC061573
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 13:06:15 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 7so7367612pgm.11
        for <io-uring@vger.kernel.org>; Fri, 11 Sep 2020 13:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MKvcM1sLzkNkiwtWjgBEpB0xsPWeE7ryilGHEx15Mg0=;
        b=QIsSZnebR6AVKaMaqErNZCDugHNs/V+HJniTchDCy90NiciCuLZdl/0qa3Uz8nxik2
         JXUgStLnX4ZuRQNilzNm7CyCCUm6C2LqWIyf9LBh0OAaeuconCjWB6Ypj3sEBu8cN56z
         pIkoBq8yrIMl37PSVYz6cuszYwrdcb6GjHWSXqjZ4Jo6KMhFMlhAaJ7PrHZFkD/dWanB
         Ywdq6F7zO/s74HKZBbgWNtLSYjsFynsaeKUiF7u65eQRWCgOeZVGqcsKTgvetcncWC2D
         miUI8IQZ/qBSG/M/5r2WedWIIjb3KuXLBvVlFDlvkl7Tpv8yURwxOrb8Ftdtdk9/6hvy
         bgzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MKvcM1sLzkNkiwtWjgBEpB0xsPWeE7ryilGHEx15Mg0=;
        b=oFKSY4PNJ7qUPHA8NfmkzKP6Cl7pviYSfqgcknJb55tdbeyihobU2nUXLzZ9cTKPJ/
         KtkYI76dqZVRvQ+fra8UjfW5GBp5s2QHCsXuFWPm0nT4JAVsbChSYStjhebVnHt/cwEh
         zPIRCbePBNummSrB8X5Gfkp70Xx36mCc8kA8EA8GPEk0n0o1xvMgceyO4LCORahGv17z
         1CPyp6GL5oE9vtQfnP/KQS2wFem0j4hEkwr8lYghudg7lfj0Qk4baVz/+8ZihQCOQUi3
         34SnqFeZ5OHj7zZonJhBL6jNg92pPuYZlDKL3g9g8H1o2pcBQgxf7k2xdprjVIIpD/lF
         hFVQ==
X-Gm-Message-State: AOAM5314Qv3QoaPHV3CZxHqp3o8kAqlL0P4pUUgY+ba9AYuBVjffBYYq
        ONYjsbbuBp15Azf5ow/FlgzUCgf9D6mR+que
X-Google-Smtp-Source: ABdhPJzENRJUtDzaNHtf7v/cwxZR3XxKYmvGDdV2okkCcUuIHhKWhesm4K/MihcA9q0vjS6w0jAeOA==
X-Received: by 2002:aa7:9aa9:: with SMTP id x9mr3455561pfi.67.1599854774993;
        Fri, 11 Sep 2020 13:06:14 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b203sm3088898pfb.205.2020.09.11.13.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 13:06:14 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: ensure IOSQE_ASYNC file table grabbing
 works, with SQPOLL
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <b105ea32-3831-b3c5-3993-4b38cc966667@kernel.dk>
 <8f6871c4-1344-8556-25a7-5c875aebe4a5@gmail.com>
 <622649c5-e30d-bc3c-4709-bbe60729cca1@kernel.dk>
 <1c088b17-53bb-0d6d-6573-a1958db88426@kernel.dk>
 <801ed334-54ea-bdee-4d81-34b7e358b506@gmail.com>
 <370c055e-fa8d-0b80-bd34-ba3ba9bc6b37@kernel.dk>
 <74c2802e-788e-d6b2-3ee6-5ef67950dc94@gmail.com>
 <b52f5068-8e03-22a9-cf7d-c3e77fc8282f@kernel.dk>
 <33a6730c-8e0c-e34f-9094-c256a13961cd@gmail.com>
 <163d7844-e2a4-2739-af4e-79f4a3ec9a1d@kernel.dk>
 <73b8038a-eedf-04f7-6991-938512faaee6@kernel.dk>
 <8f953abe-cdcd-18a9-fe06-2c0480cddff5@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7213bcb4-246f-9dfb-b96d-6d628d03f670@kernel.dk>
Date:   Fri, 11 Sep 2020 14:06:13 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8f953abe-cdcd-18a9-fe06-2c0480cddff5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/11/20 1:23 PM, Pavel Begunkov wrote:
> On 10/09/2020 21:18, Jens Axboe wrote:
>> On 9/10/20 7:11 AM, Jens Axboe wrote:
>>> On 9/10/20 6:37 AM, Pavel Begunkov wrote:
>>>> On 09/09/2020 19:07, Jens Axboe wrote:
>>>>> On 9/9/20 9:48 AM, Pavel Begunkov wrote:
>>>>>> On 09/09/2020 16:10, Jens Axboe wrote:
>>>>>>> On 9/9/20 1:09 AM, Pavel Begunkov wrote:
>>>>>>>> On 09/09/2020 01:54, Jens Axboe wrote:
>>>>>>>>> On 9/8/20 3:22 PM, Jens Axboe wrote:
>>>>>>>>>> On 9/8/20 2:58 PM, Pavel Begunkov wrote:
>>>>>>>>>>> On 08/09/2020 20:48, Jens Axboe wrote:
>>>>>>>>>>>> Fd instantiating commands like IORING_OP_ACCEPT now work with SQPOLL, but
>>>>>>>>>>>> we have an error in grabbing that if IOSQE_ASYNC is set. Ensure we assign
>>>>>>>>>>>> the ring fd/file appropriately so we can defer grab them.
>>>>>>>>>>>
>>>>>>>>>>> IIRC, for fcheck() in io_grab_files() to work it should be under fdget(),
>>>>>>>>>>> that isn't the case with SQPOLL threads. Am I mistaken?
>>>>>>>>>>>
>>>>>>>>>>> And it looks strange that the following snippet will effectively disable
>>>>>>>>>>> such requests.
>>>>>>>>>>>
>>>>>>>>>>> fd = dup(ring_fd)
>>>>>>>>>>> close(ring_fd)
>>>>>>>>>>> ring_fd = fd
>>>>>>>>>>
>>>>>>>>>> Not disagreeing with that, I think my initial posting made it clear
>>>>>>>>>> it was a hack. Just piled it in there for easier testing in terms
>>>>>>>>>> of functionality.
>>>>>>>>>>
>>>>>>>>>> But the next question is how to do this right...> 
>>>>>>>>> Looking at this a bit more, and I don't necessarily think there's a
>>>>>>>>> better option. If you dup+close, then it just won't work. We have no
>>>>>>>>> way of knowing if the 'fd' changed, but we can detect if it was closed
>>>>>>>>> and then we'll end up just EBADF'ing the requests.
>>>>>>>>>
>>>>>>>>> So right now the answer is that we can support this just fine with
>>>>>>>>> SQPOLL, but you better not dup and close the original fd. Which is not
>>>>>>>>> ideal, but better than NOT being able to support it.
>>>>>>>>>
>>>>>>>>> Only other option I see is to to provide an io_uring_register()
>>>>>>>>> command to update the fd/file associated with it. Which may be useful,
>>>>>>>>> it allows a process to indeed to this, if it absolutely has to.
>>>>>>>>
>>>>>>>> Let's put aside such dirty hacks, at least until someone actually
>>>>>>>> needs it. Ideally, for many reasons I'd prefer to get rid of
>>>>>>>
>>>>>>> BUt it is actually needed, otherwise we're even more in a limbo state of
>>>>>>> "SQPOLL works for most things now, just not all". And this isn't that
>>>>>>> hard to make right - on the flush() side, we just need to park/stall the
>>>>>>
>>>>>> I understand that it isn't hard, but I just don't want to expose it to
>>>>>> the userspace, a) because it's a userspace API, so couldn't probably be
>>>>>> killed in the future, b) works around kernel's problems, and so
>>>>>> shouldn't really be exposed to the userspace in normal circumstances.
>>>>>>
>>>>>> And it's not generic enough because of a possible "many fds -> single
>>>>>> file" mapping, and there will be a lot of questions and problems.
>>>>>>
>>>>>> e.g. if a process shares a io_uring with another process, then
>>>>>> dup()+close() would require not only this hook but also additional
>>>>>> inter-process synchronisation. And so on.
>>>>>
>>>>> I think you're blowing this out of proportion. Just to restate the
>>>>
>>>> I just think that if there is a potentially cleaner solution without
>>>> involving userspace, we should try to look for it first, even if it
>>>> would take more time. That was the point.
>>>
>>> Regardless of whether or not we can eliminate that need, at least it'll
>>> be a relaxing of the restriction, not an increase of it. It'll never
>>> hurt to do an extra system call for the case where you're swapping fds.
>>> I do get your point, I just don't think it's a big deal.
>>
>> BTW, I don't see how we can ever get rid of a need to enter the kernel,
>> we'd need some chance at grabbing the updated ->files, for instance.
> 
> Thanks for taking a look.
> Yeah, agree, it should get it from somewhere, and that reminds me that
> we have a similar situation with sqo_mm -- it grabs it from the
> task-creator and keeps it to the end... Do we really need to set
> ->files of another thread? Retaining to the end seem to work well
> enough with mm. And we need, then it would be more consistent
> to replace mm there as well.

The files can change, so we need the juggling.

>> Might be possible to hold a reference to the task and grab it from
>> there, though feels a bit iffy to hold a task reference from the ring on
>> the task that holds a reference to the ring. Haven't looked too close,
>> should work though as this won't hold a file/files reference, it's just
>> a freeing reference.
> 
> BTW, if the process-creator dies, then its ->files might be killed
> and ->sqo_files become dangling, so should be invalidated. Your
> approach with a task's reference probably handles it naturally.

We do prune and cancel if the process goes away, so it shouldn't have
that issue. But yes, it falls out naturally with the task based
approach.

-- 
Jens Axboe

