Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232162646DA
	for <lists+io-uring@lfdr.de>; Thu, 10 Sep 2020 15:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbgIJNWk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Sep 2020 09:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730497AbgIJNLk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Sep 2020 09:11:40 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2955BC061573
        for <io-uring@vger.kernel.org>; Thu, 10 Sep 2020 06:11:35 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id d190so6988133iof.3
        for <io-uring@vger.kernel.org>; Thu, 10 Sep 2020 06:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=TnLuNPS1QW5Qpwzkh/vn3tiuFZb1nA0f8M2TspenWk4=;
        b=S/U1wvMkZd9zVzb1jTSfy+sjlHdanMDTJVIcvbJ+IG/Gn1I+A6B4r7+WXeYKbd83ri
         rbeJhs7nqAfRgmtXvNSzY3EG/c5mQ1wbmEFAspdIwOOfFAVR5cIU79FAmFr5z1CE29PG
         RU2cx/fuVOzCylJ4e6hKoy6RvQf5xBYG/Hh/ZTM3OjsBOuznfkgk6txtYT1PvlQ1raSp
         0nOMpFmgj+hVaMjLQi/OH9bV5FA+Am19KXfA5QZMwHgdAN+ko/pK2QHg+5/f+2QKk5eE
         W/649zjNs+wfHKVsMDHuT5H313O+3xYlPG6YCuTEMv3hZNO+uv67sUqHr6aWfePWRv33
         n45w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TnLuNPS1QW5Qpwzkh/vn3tiuFZb1nA0f8M2TspenWk4=;
        b=XDG7bGDCs/5f+Jf243uaHHiJ4zrKFHXbXF3st6sljKQ9TMLA5nKTPi0P3XALuEYMKL
         2ckl91yakgxJgw7JLQLzYmZ3gP738W8ZVvUupsIt1EWggSfgqArfYqxPcFws3DtJs78D
         9owTaEiEUGJcn5QQbxrY93D4X9kyAoLiHxsMPfDLdL/epQPWbyxOLyoDQ1raRhcOYIr6
         t3SI0kXt1zQ/emZnEupq4UgkGnxmebUgSgXXjuwVlAo+EfH50T4KA4gavW7fcmCbundk
         PIC4ZR9P61FQcuhfE8Eg/UlZngu6h/w84Xp2N7GOotSd45vQyqRXVCYlfHA7VroJxYZ3
         kZiQ==
X-Gm-Message-State: AOAM531cE4j1LfzreBrAzYmuOoix5qxZwFhVkxbhlCz7ws7r2KU20XXB
        59ZhV7ENswHssKp4KuP+j22tvkCJAelhHrg9
X-Google-Smtp-Source: ABdhPJzhLVagnIsL5zZJTvngg/EeGI1RKnI/k77vlfPCHOBRz8mdeyki7vUKUkiZ9lguUSWftXshgQ==
X-Received: by 2002:a05:6638:2647:: with SMTP id n7mr8788712jat.9.1599743493955;
        Thu, 10 Sep 2020 06:11:33 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c2sm3134621ilo.7.2020.09.10.06.11.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2020 06:11:33 -0700 (PDT)
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <163d7844-e2a4-2739-af4e-79f4a3ec9a1d@kernel.dk>
Date:   Thu, 10 Sep 2020 07:11:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <33a6730c-8e0c-e34f-9094-c256a13961cd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/10/20 6:37 AM, Pavel Begunkov wrote:
> On 09/09/2020 19:07, Jens Axboe wrote:
>> On 9/9/20 9:48 AM, Pavel Begunkov wrote:
>>> On 09/09/2020 16:10, Jens Axboe wrote:
>>>> On 9/9/20 1:09 AM, Pavel Begunkov wrote:
>>>>> On 09/09/2020 01:54, Jens Axboe wrote:
>>>>>> On 9/8/20 3:22 PM, Jens Axboe wrote:
>>>>>>> On 9/8/20 2:58 PM, Pavel Begunkov wrote:
>>>>>>>> On 08/09/2020 20:48, Jens Axboe wrote:
>>>>>>>>> Fd instantiating commands like IORING_OP_ACCEPT now work with SQPOLL, but
>>>>>>>>> we have an error in grabbing that if IOSQE_ASYNC is set. Ensure we assign
>>>>>>>>> the ring fd/file appropriately so we can defer grab them.
>>>>>>>>
>>>>>>>> IIRC, for fcheck() in io_grab_files() to work it should be under fdget(),
>>>>>>>> that isn't the case with SQPOLL threads. Am I mistaken?
>>>>>>>>
>>>>>>>> And it looks strange that the following snippet will effectively disable
>>>>>>>> such requests.
>>>>>>>>
>>>>>>>> fd = dup(ring_fd)
>>>>>>>> close(ring_fd)
>>>>>>>> ring_fd = fd
>>>>>>>
>>>>>>> Not disagreeing with that, I think my initial posting made it clear
>>>>>>> it was a hack. Just piled it in there for easier testing in terms
>>>>>>> of functionality.
>>>>>>>
>>>>>>> But the next question is how to do this right...> 
>>>>>> Looking at this a bit more, and I don't necessarily think there's a
>>>>>> better option. If you dup+close, then it just won't work. We have no
>>>>>> way of knowing if the 'fd' changed, but we can detect if it was closed
>>>>>> and then we'll end up just EBADF'ing the requests.
>>>>>>
>>>>>> So right now the answer is that we can support this just fine with
>>>>>> SQPOLL, but you better not dup and close the original fd. Which is not
>>>>>> ideal, but better than NOT being able to support it.
>>>>>>
>>>>>> Only other option I see is to to provide an io_uring_register()
>>>>>> command to update the fd/file associated with it. Which may be useful,
>>>>>> it allows a process to indeed to this, if it absolutely has to.
>>>>>
>>>>> Let's put aside such dirty hacks, at least until someone actually
>>>>> needs it. Ideally, for many reasons I'd prefer to get rid of
>>>>
>>>> BUt it is actually needed, otherwise we're even more in a limbo state of
>>>> "SQPOLL works for most things now, just not all". And this isn't that
>>>> hard to make right - on the flush() side, we just need to park/stall the
>>>
>>> I understand that it isn't hard, but I just don't want to expose it to
>>> the userspace, a) because it's a userspace API, so couldn't probably be
>>> killed in the future, b) works around kernel's problems, and so
>>> shouldn't really be exposed to the userspace in normal circumstances.
>>>
>>> And it's not generic enough because of a possible "many fds -> single
>>> file" mapping, and there will be a lot of questions and problems.
>>>
>>> e.g. if a process shares a io_uring with another process, then
>>> dup()+close() would require not only this hook but also additional
>>> inter-process synchronisation. And so on.
>>
>> I think you're blowing this out of proportion. Just to restate the
> 
> I just think that if there is a potentially cleaner solution without
> involving userspace, we should try to look for it first, even if it
> would take more time. That was the point.

Regardless of whether or not we can eliminate that need, at least it'll
be a relaxing of the restriction, not an increase of it. It'll never
hurt to do an extra system call for the case where you're swapping fds.
I do get your point, I just don't think it's a big deal.

>>>>> fcheck(ctx->ring_fd) in favour of synchronisation in io_grab_files(),
>>>>> but I wish I knew how.
>>>>
>>>> That'd be nice, and apply equally to all cases as the SQPOLL case isn't
>>>> special at all anymore.
>>>
>>> I miss the whole story, have you asked fs guys about the problem?
>>> Or is it known that nothing would work?
>>
>> I haven't looked into it.
> 
> Any chance you have someone in mind who can take a look? I don't
> think I have a chance to get to anyone in fs.

I'll take a look.

-- 
Jens Axboe

