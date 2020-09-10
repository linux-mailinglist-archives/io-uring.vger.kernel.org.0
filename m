Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18320264D5D
	for <lists+io-uring@lfdr.de>; Thu, 10 Sep 2020 20:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgIJSlA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Sep 2020 14:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726789AbgIJSSn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Sep 2020 14:18:43 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF07C061786
        for <io-uring@vger.kernel.org>; Thu, 10 Sep 2020 11:18:35 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z13so8164242iom.8
        for <io-uring@vger.kernel.org>; Thu, 10 Sep 2020 11:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RAcrpU6dq67qEeU36ouUDeIS++DaEuIlRG1fJ/4d++s=;
        b=qRGRHd263lyD64RUNrN/DZAIrVpzFRjSN+/qPzJ1piPXNtU0bBx5uGmWmNjSperySp
         LIUeXCOM2ViJiMRhO9TioIrA7DEDLxv2XvraEpQs+4lNjVcD4W0PkbH/aGv5PC7VlfcH
         U5EhQMKnu8OuEJK/pa+ZwJdRXVjASghJZtIUE1GIKr8nwTpzoWH8EWDGmv2Gd8Qt+svK
         oTnyywkx6YANI9JY6QniMW2ryEQX6A+Vj6xa0xSlUJiDW8dHX42s3DTfWWGJykUBqSQq
         yXIR+QE5Ci4qJ1L9aPMRZOcauWt4Ay97D6wNBSuHls04aKRCy4IXmbjbqVFbRieHlhnJ
         OL6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RAcrpU6dq67qEeU36ouUDeIS++DaEuIlRG1fJ/4d++s=;
        b=ZbR8kH2GpnEMLMVghpH+f3JBUceWPnAxs2DABYqpDasWj+0nsFvkQQsxOtQU/IqjOw
         pVCHlheIz/E1ccKa6ZsAczd22tcs1ZULZ3uRum5J1wnjm2Clr45IgOxh74N7ZehWkEEb
         C9EElgGGTbOqdE0fZGXBph+I2TCIbIJw01JUnPR+QS137e8TfBpRcXSD8VB65cbbBt+5
         pkpXibQKkpBR7CVOimlfpsirTxtc1GOrMn0N/U1cT/77ZBOAqwFDZn0BjkBfV32XCBKi
         Cv7mxSpP0U5+G68rXEYwwAeM62piVLRht606kd1K5MnRL18RFDVU8ghxiR9ytdrliJvT
         NlYg==
X-Gm-Message-State: AOAM530osax/N1UvbIS/eeduW4H8GEaTHTEgmqs6+K+u+U5wSLsXZgSX
        xmJkuGitT9AyZqbIPnlQFypG0MzoZVcDiKlZ
X-Google-Smtp-Source: ABdhPJwCOTd9fGBQMHfrQJBpHPRFv1ebhWTqhXANU/sneHFeWdZsdY8E5vsN4sn5HxXXaRlooafxSw==
X-Received: by 2002:a6b:d603:: with SMTP id w3mr8659803ioa.29.1599761914300;
        Thu, 10 Sep 2020 11:18:34 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t67sm3629536ill.88.2020.09.10.11.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 11:18:33 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: ensure IOSQE_ASYNC file table grabbing
 works, with SQPOLL
From:   Jens Axboe <axboe@kernel.dk>
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
Message-ID: <73b8038a-eedf-04f7-6991-938512faaee6@kernel.dk>
Date:   Thu, 10 Sep 2020 12:18:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <163d7844-e2a4-2739-af4e-79f4a3ec9a1d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/10/20 7:11 AM, Jens Axboe wrote:
> On 9/10/20 6:37 AM, Pavel Begunkov wrote:
>> On 09/09/2020 19:07, Jens Axboe wrote:
>>> On 9/9/20 9:48 AM, Pavel Begunkov wrote:
>>>> On 09/09/2020 16:10, Jens Axboe wrote:
>>>>> On 9/9/20 1:09 AM, Pavel Begunkov wrote:
>>>>>> On 09/09/2020 01:54, Jens Axboe wrote:
>>>>>>> On 9/8/20 3:22 PM, Jens Axboe wrote:
>>>>>>>> On 9/8/20 2:58 PM, Pavel Begunkov wrote:
>>>>>>>>> On 08/09/2020 20:48, Jens Axboe wrote:
>>>>>>>>>> Fd instantiating commands like IORING_OP_ACCEPT now work with SQPOLL, but
>>>>>>>>>> we have an error in grabbing that if IOSQE_ASYNC is set. Ensure we assign
>>>>>>>>>> the ring fd/file appropriately so we can defer grab them.
>>>>>>>>>
>>>>>>>>> IIRC, for fcheck() in io_grab_files() to work it should be under fdget(),
>>>>>>>>> that isn't the case with SQPOLL threads. Am I mistaken?
>>>>>>>>>
>>>>>>>>> And it looks strange that the following snippet will effectively disable
>>>>>>>>> such requests.
>>>>>>>>>
>>>>>>>>> fd = dup(ring_fd)
>>>>>>>>> close(ring_fd)
>>>>>>>>> ring_fd = fd
>>>>>>>>
>>>>>>>> Not disagreeing with that, I think my initial posting made it clear
>>>>>>>> it was a hack. Just piled it in there for easier testing in terms
>>>>>>>> of functionality.
>>>>>>>>
>>>>>>>> But the next question is how to do this right...> 
>>>>>>> Looking at this a bit more, and I don't necessarily think there's a
>>>>>>> better option. If you dup+close, then it just won't work. We have no
>>>>>>> way of knowing if the 'fd' changed, but we can detect if it was closed
>>>>>>> and then we'll end up just EBADF'ing the requests.
>>>>>>>
>>>>>>> So right now the answer is that we can support this just fine with
>>>>>>> SQPOLL, but you better not dup and close the original fd. Which is not
>>>>>>> ideal, but better than NOT being able to support it.
>>>>>>>
>>>>>>> Only other option I see is to to provide an io_uring_register()
>>>>>>> command to update the fd/file associated with it. Which may be useful,
>>>>>>> it allows a process to indeed to this, if it absolutely has to.
>>>>>>
>>>>>> Let's put aside such dirty hacks, at least until someone actually
>>>>>> needs it. Ideally, for many reasons I'd prefer to get rid of
>>>>>
>>>>> BUt it is actually needed, otherwise we're even more in a limbo state of
>>>>> "SQPOLL works for most things now, just not all". And this isn't that
>>>>> hard to make right - on the flush() side, we just need to park/stall the
>>>>
>>>> I understand that it isn't hard, but I just don't want to expose it to
>>>> the userspace, a) because it's a userspace API, so couldn't probably be
>>>> killed in the future, b) works around kernel's problems, and so
>>>> shouldn't really be exposed to the userspace in normal circumstances.
>>>>
>>>> And it's not generic enough because of a possible "many fds -> single
>>>> file" mapping, and there will be a lot of questions and problems.
>>>>
>>>> e.g. if a process shares a io_uring with another process, then
>>>> dup()+close() would require not only this hook but also additional
>>>> inter-process synchronisation. And so on.
>>>
>>> I think you're blowing this out of proportion. Just to restate the
>>
>> I just think that if there is a potentially cleaner solution without
>> involving userspace, we should try to look for it first, even if it
>> would take more time. That was the point.
> 
> Regardless of whether or not we can eliminate that need, at least it'll
> be a relaxing of the restriction, not an increase of it. It'll never
> hurt to do an extra system call for the case where you're swapping fds.
> I do get your point, I just don't think it's a big deal.

BTW, I don't see how we can ever get rid of a need to enter the kernel,
we'd need some chance at grabbing the updated ->files, for instance.
Might be possible to hold a reference to the task and grab it from
there, though feels a bit iffy to hold a task reference from the ring on
the task that holds a reference to the ring. Haven't looked too close,
should work though as this won't hold a file/files reference, it's just
a freeing reference.

-- 
Jens Axboe

