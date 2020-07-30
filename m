Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84701233805
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 19:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgG3Ry4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 13:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbgG3Ryz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 13:54:55 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C93C061575
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 10:54:55 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id s21so23203469ilk.5
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 10:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qZxl6RlcjeBo55Fcy6iPmsqYVaQtSKURd48rtYSeZj4=;
        b=gw/iCFk/RVskyceLGKO+tloqFLuIWEnHnjupL2l++0br12+PBSUShRgw+bPKiu0Yaa
         rFRORmkDAc/gmiQfJBtek+oKYwvboV6LyOiZKFUjHUHOwzfLDIrAZwTr8FKxQNz4r4mK
         Htd/eMSeNZ3K5/2RrcTIrmsJ57EAmXi63QkPP/ovDgTG8zg+6JuRvRRXA7ACQuZHTekN
         0h0XN5fYP8uAKYUv1TKsgv3Xfmwj4mMFyBK+3vaLqpVGItDeySe5ZZ4m4unh5flZ+WbF
         LBk6kFJlJlPGjCWJEIVG2Yh75Vjiilk7dhg9FrBhoHvwaEC6SmvuBIQY8OiD/p6OV7iu
         akvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qZxl6RlcjeBo55Fcy6iPmsqYVaQtSKURd48rtYSeZj4=;
        b=hG1M4yIod5bCuUpuZNwFztyr4go+5A4GWsNZmdYYzqhxqDqeMzt3rzbEUf0zIhs9Pl
         uwjgjZpYcPPPm0Gl4aMpxI1EIfV/WrzzTxSHJoLFNB3S0ajvry/Na2GdBZp5rx6dR+B8
         ZUBFqACCGefwy8xoEty7UdoPjYkXfubaw76GqaHQ/dMq6QpezCMkTMU/RskCsq5OvO9E
         Bmx8PSM3ppYannzNuXaW8r4Z8+ic1QelAM0pw3BtfYTExxxuqZeCzBjT+QBtYJlNu3kq
         STdHR/+IJ526BEXJQeda2lmMUWKehT4DjS/qOyT5rHm9Csthoty/q6z/Ugms8SuNMDx4
         FytQ==
X-Gm-Message-State: AOAM533ELro5ZsltaaOWYwYvB82JRKNGksmBdNMxp0C7V2dztE9J7QFh
        I2LcLNpmJm66XWz1BHjVdhSvWw==
X-Google-Smtp-Source: ABdhPJwBJLXpr2je4Zc+DCL3I1fwHXLDw7C0LU53JyfAwAy9/eHrQfqARPYwMJRvkwx8uyKJIjJ2iQ==
X-Received: by 2002:a92:bd0f:: with SMTP id c15mr38652504ile.95.1596131694849;
        Thu, 30 Jul 2020 10:54:54 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c25sm3447235ilf.63.2020.07.30.10.54.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 10:54:54 -0700 (PDT)
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
To:     Kanchan Joshi <joshiiitr@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-api@vger.kernel.org,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
 <CGME20200724155350epcas5p3b8f1d59eda7f8fbb38c828f692d42fd6@epcas5p3.samsung.com>
 <1595605762-17010-7-git-send-email-joshi.k@samsung.com>
 <f5416bd4-93b3-4d14-3266-bdbc4ae1990b@kernel.dk>
 <CA+1E3rJAa3E2Ti0fvvQTzARP797qge619m4aYLjXeR3wxdFwWw@mail.gmail.com>
 <b0b7159d-ed10-08ad-b6c7-b85d45f60d16@kernel.dk>
 <e871eef2-8a93-fdbc-b762-2923526a2db4@gmail.com>
 <80d27717-080a-1ced-50d5-a3a06cf06cd3@kernel.dk>
 <da4baa8c-76b0-7255-365c-d8b58e322fd0@gmail.com>
 <65a7e9a6-aede-31ce-705c-b7f94f079112@kernel.dk>
 <d4f9a5d3-1df2-1060-94fa-f77441a89299@gmail.com>
 <CA+1E3rJ3SoLU9aYcugAQgJnSPnJtcCwjZdMREXS3FTmXgy3yow@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f030a338-cd52-2e83-e1da-bdbca910d49e@kernel.dk>
Date:   Thu, 30 Jul 2020 11:54:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+1E3rJ3SoLU9aYcugAQgJnSPnJtcCwjZdMREXS3FTmXgy3yow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/30/20 11:51 AM, Kanchan Joshi wrote:
> On Thu, Jul 30, 2020 at 11:10 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 30/07/2020 20:16, Jens Axboe wrote:
>>> On 7/30/20 10:26 AM, Pavel Begunkov wrote:
>>>> On 30/07/2020 19:13, Jens Axboe wrote:
>>>>> On 7/30/20 10:08 AM, Pavel Begunkov wrote:
>>>>>> On 27/07/2020 23:34, Jens Axboe wrote:
>>>>>>> On 7/27/20 1:16 PM, Kanchan Joshi wrote:
>>>>>>>> On Fri, Jul 24, 2020 at 10:00 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>>
>>>>>>>>> On 7/24/20 9:49 AM, Kanchan Joshi wrote:
>>>>>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>>>>>> index 7809ab2..6510cf5 100644
>>>>>>>>>> --- a/fs/io_uring.c
>>>>>>>>>> +++ b/fs/io_uring.c
>>>>>>>>>> @@ -1284,8 +1301,15 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
>>>>>>>>>>       cqe = io_get_cqring(ctx);
>>>>>>>>>>       if (likely(cqe)) {
>>>>>>>>>>               WRITE_ONCE(cqe->user_data, req->user_data);
>>>>>>>>>> -             WRITE_ONCE(cqe->res, res);
>>>>>>>>>> -             WRITE_ONCE(cqe->flags, cflags);
>>>>>>>>>> +             if (unlikely(req->flags & REQ_F_ZONE_APPEND)) {
>>>>>>>>>> +                     if (likely(res > 0))
>>>>>>>>>> +                             WRITE_ONCE(cqe->res64, req->rw.append_offset);
>>>>>>>>>> +                     else
>>>>>>>>>> +                             WRITE_ONCE(cqe->res64, res);
>>>>>>>>>> +             } else {
>>>>>>>>>> +                     WRITE_ONCE(cqe->res, res);
>>>>>>>>>> +                     WRITE_ONCE(cqe->flags, cflags);
>>>>>>>>>> +             }
>>>>>>>>>
>>>>>>>>> This would be nice to keep out of the fast path, if possible.
>>>>>>>>
>>>>>>>> I was thinking of keeping a function-pointer (in io_kiocb) during
>>>>>>>> submission. That would have avoided this check......but argument count
>>>>>>>> differs, so it did not add up.
>>>>>>>
>>>>>>> But that'd grow the io_kiocb just for this use case, which is arguably
>>>>>>> even worse. Unless you can keep it in the per-request private data,
>>>>>>> but there's no more room there for the regular read/write side.
>>>>>>>
>>>>>>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>>>>>>>> index 92c2269..2580d93 100644
>>>>>>>>>> --- a/include/uapi/linux/io_uring.h
>>>>>>>>>> +++ b/include/uapi/linux/io_uring.h
>>>>>>>>>> @@ -156,8 +156,13 @@ enum {
>>>>>>>>>>   */
>>>>>>>>>>  struct io_uring_cqe {
>>>>>>>>>>       __u64   user_data;      /* sqe->data submission passed back */
>>>>>>>>>> -     __s32   res;            /* result code for this event */
>>>>>>>>>> -     __u32   flags;
>>>>>>>>>> +     union {
>>>>>>>>>> +             struct {
>>>>>>>>>> +                     __s32   res;    /* result code for this event */
>>>>>>>>>> +                     __u32   flags;
>>>>>>>>>> +             };
>>>>>>>>>> +             __s64   res64;  /* appending offset for zone append */
>>>>>>>>>> +     };
>>>>>>>>>>  };
>>>>>>>>>
>>>>>>>>> Is this a compatible change, both for now but also going forward? You
>>>>>>>>> could randomly have IORING_CQE_F_BUFFER set, or any other future flags.
>>>>>>>>
>>>>>>>> Sorry, I didn't quite understand the concern. CQE_F_BUFFER is not
>>>>>>>> used/set for write currently, so it looked compatible at this point.
>>>>>>>
>>>>>>> Not worried about that, since we won't ever use that for writes. But it
>>>>>>> is a potential headache down the line for other flags, if they apply to
>>>>>>> normal writes.
>>>>>>>
>>>>>>>> Yes, no room for future flags for this operation.
>>>>>>>> Do you see any other way to enable this support in io-uring?
>>>>>>>
>>>>>>> Honestly I think the only viable option is as we discussed previously,
>>>>>>> pass in a pointer to a 64-bit type where we can copy the additional
>>>>>>> completion information to.
>>>>>>
>>>>>> TBH, I hate the idea of such overhead/latency at times when SSDs can
>>>>>> serve writes in less than 10ms. Any chance you measured how long does it
>>>>>
>>>>> 10us? :-)
>>>>
>>>> Hah, 10us indeed :)
>>>>
>>>>>
>>>>>> take to drag through task_work?
>>>>>
>>>>> A 64-bit value copy is really not a lot of overhead... But yes, we'd
>>>>> need to push the completion through task_work at that point, as we can't
>>>>> do it from the completion side. That's not a lot of overhead, and most
>>>>> notably, it's overhead that only affects this particular type.
>>>>>
>>>>> That's not a bad starting point, and something that can always be
>>>>> optimized later if need be. But I seriously doubt it'd be anything to
>>>>> worry about.
>>>>
>>>> I probably need to look myself how it's really scheduled, but if you don't
>>>> mind, here is a quick question: if we do work_add(task) when the task is
>>>> running in the userspace, wouldn't the work execution wait until the next
>>>> syscall/allotted time ends up?
>>>
>>> It'll get the task to enter the kernel, just like signal delivery. The only
>>> tricky part is really if we have a dependency waiting in the kernel, like
>>> the recent eventfd fix.
>>
>> I see, thanks for sorting this out!
> 
> Few more doubts about this (please mark me wrong if that is the case):
> 
> - Task-work makes me feel like N completions waiting to be served by
> single task.
> Currently completions keep arriving and CQEs would be updated with
> result, but the user-space (submitter task) would not be poked.
> 
> - Completion-code will set the task-work. But post that it cannot go
> immediately to its regular business of picking cqe and updating
> res/flags, as we cannot afford user-space to see the cqe before the
> pointer update. So it seems completion-code needs to spawn another
> work which will allocate/update cqe after waiting for pointer-update
> from task-work?

The task work would post the completion CQE for the request after
writing the offset.

-- 
Jens Axboe

