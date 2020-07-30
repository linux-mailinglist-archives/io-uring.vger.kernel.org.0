Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C636233676
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 18:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbgG3QOB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 12:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbgG3QOA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 12:14:00 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB8AC061575
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 09:14:00 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id q17so14569021pls.9
        for <io-uring@vger.kernel.org>; Thu, 30 Jul 2020 09:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2cEXkEXVTWwLucH9omujSAfOqa3WLkWR4PelWjXQFNg=;
        b=VP/dlrNE4R3fh1kC0zEFNVslfKeWiqHg2rvnG3XvMO07cpQGdmqp1i+GAdgwDXQ548
         baQ8y57LmBTqQhwBesX4FCAiukcf+aLMcOY1K2XaEmz1fU1G+P6bYrK8OPRXyiSMU/VX
         GFxZF3EyY+OvPy3BEbR1gOZ37VRpyEcUTnT+0ZR2Z1iOJ2p3IN870t/aTJRb3HipmO22
         1Tuj5S3jgOO/XEQUo8AB3NvrinwFrH5SAnkrxF/g9dayxQza2pg5EiNhiDQPmWpvtcJ7
         6ksBjlZNdtzEJTd9RO1LYI2wKShLlpjQ2Cx6aF+CsXn8NnMUuaty0oYsysIntLRNUKrd
         bbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2cEXkEXVTWwLucH9omujSAfOqa3WLkWR4PelWjXQFNg=;
        b=E5YZhlj7nvuw5LdX7QeHLCz8u8wewsGzqHU3JSV9vSQcKpMc29GdYbpF4iZNbeIoN/
         /YhYt4+NzQXNo3MetJn8qCCMJfIGEEpaDPtJ9PK8Gx7TBgQUeuFyXP0228ebyWvaIe/3
         tmPcEXJwB85GXT8B+YApopbwSxGmyFSEfaI4oTyitj6edWT8Byk3AX/vdmu/NG+AvTAI
         VzQXXCUwK6d7H/T8iFSpsrUrC2NAVKl6CQU/ZJDZR3G5nc9lTXWdM+DXb8UALYbUw5Sk
         vMMi8sUy5054So36DC0uZlGS6aHnulKCBXJGrqqaoQlpaCacFst/4X91BFvoSQ7sx1wX
         +Jww==
X-Gm-Message-State: AOAM531aTGyh+o13ocO3B0IdOJDKk0EW45Mw3k59IRb/5Gt5C7xutEI6
        NTQ3YgdFsm9nPMkLv2EQprboGQ==
X-Google-Smtp-Source: ABdhPJwjyBVK7W6BHEhO7L1UnGYqerVAaCNgXaICwWaIii4F/KcpzVLHAKaxC/zFM550+qDWayd5hA==
X-Received: by 2002:a17:90a:14a5:: with SMTP id k34mr16416649pja.37.1596125639842;
        Thu, 30 Jul 2020 09:13:59 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21e8::11c1? ([2620:10d:c090:400::5:6c5a])
        by smtp.gmail.com with ESMTPSA id i196sm6694268pgc.55.2020.07.30.09.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2020 09:13:59 -0700 (PDT)
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Kanchan Joshi <joshiiitr@gmail.com>
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <80d27717-080a-1ced-50d5-a3a06cf06cd3@kernel.dk>
Date:   Thu, 30 Jul 2020 10:13:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e871eef2-8a93-fdbc-b762-2923526a2db4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/30/20 10:08 AM, Pavel Begunkov wrote:
> On 27/07/2020 23:34, Jens Axboe wrote:
>> On 7/27/20 1:16 PM, Kanchan Joshi wrote:
>>> On Fri, Jul 24, 2020 at 10:00 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 7/24/20 9:49 AM, Kanchan Joshi wrote:
>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>> index 7809ab2..6510cf5 100644
>>>>> --- a/fs/io_uring.c
>>>>> +++ b/fs/io_uring.c
>>>>> @@ -1284,8 +1301,15 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
>>>>>       cqe = io_get_cqring(ctx);
>>>>>       if (likely(cqe)) {
>>>>>               WRITE_ONCE(cqe->user_data, req->user_data);
>>>>> -             WRITE_ONCE(cqe->res, res);
>>>>> -             WRITE_ONCE(cqe->flags, cflags);
>>>>> +             if (unlikely(req->flags & REQ_F_ZONE_APPEND)) {
>>>>> +                     if (likely(res > 0))
>>>>> +                             WRITE_ONCE(cqe->res64, req->rw.append_offset);
>>>>> +                     else
>>>>> +                             WRITE_ONCE(cqe->res64, res);
>>>>> +             } else {
>>>>> +                     WRITE_ONCE(cqe->res, res);
>>>>> +                     WRITE_ONCE(cqe->flags, cflags);
>>>>> +             }
>>>>
>>>> This would be nice to keep out of the fast path, if possible.
>>>
>>> I was thinking of keeping a function-pointer (in io_kiocb) during
>>> submission. That would have avoided this check......but argument count
>>> differs, so it did not add up.
>>
>> But that'd grow the io_kiocb just for this use case, which is arguably
>> even worse. Unless you can keep it in the per-request private data,
>> but there's no more room there for the regular read/write side.
>>
>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>>> index 92c2269..2580d93 100644
>>>>> --- a/include/uapi/linux/io_uring.h
>>>>> +++ b/include/uapi/linux/io_uring.h
>>>>> @@ -156,8 +156,13 @@ enum {
>>>>>   */
>>>>>  struct io_uring_cqe {
>>>>>       __u64   user_data;      /* sqe->data submission passed back */
>>>>> -     __s32   res;            /* result code for this event */
>>>>> -     __u32   flags;
>>>>> +     union {
>>>>> +             struct {
>>>>> +                     __s32   res;    /* result code for this event */
>>>>> +                     __u32   flags;
>>>>> +             };
>>>>> +             __s64   res64;  /* appending offset for zone append */
>>>>> +     };
>>>>>  };
>>>>
>>>> Is this a compatible change, both for now but also going forward? You
>>>> could randomly have IORING_CQE_F_BUFFER set, or any other future flags.
>>>
>>> Sorry, I didn't quite understand the concern. CQE_F_BUFFER is not
>>> used/set for write currently, so it looked compatible at this point.
>>
>> Not worried about that, since we won't ever use that for writes. But it
>> is a potential headache down the line for other flags, if they apply to
>> normal writes.
>>
>>> Yes, no room for future flags for this operation.
>>> Do you see any other way to enable this support in io-uring?
>>
>> Honestly I think the only viable option is as we discussed previously,
>> pass in a pointer to a 64-bit type where we can copy the additional
>> completion information to.
> 
> TBH, I hate the idea of such overhead/latency at times when SSDs can
> serve writes in less than 10ms. Any chance you measured how long does it

10us? :-)

> take to drag through task_work?

A 64-bit value copy is really not a lot of overhead... But yes, we'd
need to push the completion through task_work at that point, as we can't
do it from the completion side. That's not a lot of overhead, and most
notably, it's overhead that only affects this particular type.

That's not a bad starting point, and something that can always be
optimized later if need be. But I seriously doubt it'd be anything to
worry about.

-- 
Jens Axboe

