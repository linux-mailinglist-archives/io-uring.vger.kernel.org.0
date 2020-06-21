Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF35202C0F
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2020 20:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730050AbgFUSzJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 14:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728822AbgFUSzI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 14:55:08 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D8BC061794
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 11:55:08 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id e15so1436379edr.2
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 11:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=GPfB6HK/DYyBqHUp1Y87210XO57AfA34v1HG1tywnFY=;
        b=hvUtvLFDZfu921YgAQV648pjBmxV8sLIVULFI+eRVmqqMdEpYZ6BvTOhLzSkgtlski
         GQ3Ryf/nMXInF5/69sRlDc2FKqBObmWW7FwBl86tOqLkEDThjoQGz71SS7HUA6Idlk0i
         DRI0qyBeEUk16kZvoOcsyzG9mEpJx0HhbLk5hNHqwnu2TNtEix1np+N10fQJoXjVl9gp
         sFaXF4qEqA8aVrtQEEuzvVDqYFTX3ARokc4keRJ2PeN5bRY9hy3ofYWnHSzf0u0kYN2c
         xjQt7KdoeZywtEckS72pFIVfx+7EAPf/zkl86+XkaMpy2tSR69afwBlhNhu+0NXi17YZ
         5fjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=GPfB6HK/DYyBqHUp1Y87210XO57AfA34v1HG1tywnFY=;
        b=ObVX5XSxWrqFJXNc8UM1LnRqx3RgpVMgw3XVbnVfia3GNW98RyCskEPiKUVsGiBC9l
         Dl0u/JrPJb/kvClQIbsZU/DJrA5foeMw1jFkR8HcbsnfVO3V1N720zPk4qlSb3O7sCz8
         KWG7CHoSIKDBNb7RV//OUHcU4r9LBN6QDXhd++593phmjCApIzZ1SSmBlNz+Xab4ZDtq
         gMBaJVGQle9qcJxdPl56f2JDkeygkrAoYxUiHutRGg26+iRndsAf4MAd44tOfezy+h62
         hCLx6C1TG/wbB7JjPJY34rgCWliB6cYKBixKBdAIWfOOTpZRUwaRd/y49lc50NZvNS0k
         JmPw==
X-Gm-Message-State: AOAM533G2UCJs1qKvJ6SEktQX+AF9xmrikPT9LArdZfC0H2K2PcDzsmT
        BJkcbyjO1wyjIwtrNL3poLzOpA==
X-Google-Smtp-Source: ABdhPJwUGh0Y9sbKiF34wYfnVsOxc19mVyoxbtUmEk5Pe/iFQU1c6Woi4ndJJt4Ihh7nru3pjy4i4w==
X-Received: by 2002:a05:6402:1d96:: with SMTP id dk22mr13957678edb.258.1592765706908;
        Sun, 21 Jun 2020 11:55:06 -0700 (PDT)
Received: from localhost (ip-5-186-127-235.cgn.fibianet.dk. [5.186.127.235])
        by smtp.gmail.com with ESMTPSA id j3sm10363857edr.87.2020.06.21.11.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 11:55:06 -0700 (PDT)
Date:   Sun, 21 Jun 2020 20:55:05 +0200
From:   "javier.gonz@samsung.com" <javier@javigon.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Matias =?utf-8?B?QmrDuHJsaW5n?= <mb@lightnvm.io>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "selvakuma.s1@samsung.com" <selvakuma.s1@samsung.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>
Subject: Re: [PATCH 3/3] io_uring: add support for zone-append
Message-ID: <20200621185505.4i46y4kndzvqlzdm@MacBook-Pro.localdomain>
References: <20200618083529.ciifu4chr4vrv2j5@mpHalley.local>
 <CY4PR04MB3751D5D6AFB0DA7B8A2DFF61E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200618091113.eu2xdp6zmdooy5d2@mpHalley.local>
 <20200619094149.uaorbger326s6yzz@mpHalley.local>
 <2ba2079c-9a5d-698a-a8f0-cbd6fdb9a9f0@lightnvm.io>
 <ca513fd1-4ca2-c16e-8b99-73cbd7fe6290@kernel.dk>
 <317fa6b5-ce64-114e-b34d-2be7b50c24f1@lightnvm.io>
 <26f41284-6e52-58d3-6119-8ed34511e5dc@kernel.dk>
 <87f750fb-d217-ab37-9790-de9ad1ef4a87@lightnvm.io>
 <d6463113-7dd1-7dc8-bf3b-46f067c5f57a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d6463113-7dd1-7dc8-bf3b-46f067c5f57a@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19.06.2020 09:44, Jens Axboe wrote:
>On 6/19/20 9:40 AM, Matias Bjørling wrote:
>> On 19/06/2020 17.20, Jens Axboe wrote:
>>> On 6/19/20 9:14 AM, Matias Bjørling wrote:
>>>> On 19/06/2020 16.18, Jens Axboe wrote:
>>>>> On 6/19/20 5:15 AM, Matias Bjørling wrote:
>>>>>> On 19/06/2020 11.41, javier.gonz@samsung.com wrote:
>>>>>>> Jens,
>>>>>>>
>>>>>>> Would you have time to answer a question below in this thread?
>>>>>>>
>>>>>>> On 18.06.2020 11:11, javier.gonz@samsung.com wrote:
>>>>>>>> On 18.06.2020 08:47, Damien Le Moal wrote:
>>>>>>>>> On 2020/06/18 17:35, javier.gonz@samsung.com wrote:
>>>>>>>>>> On 18.06.2020 07:39, Damien Le Moal wrote:
>>>>>>>>>>> On 2020/06/18 2:27, Kanchan Joshi wrote:
>>>>>>>>>>>> From: Selvakumar S <selvakuma.s1@samsung.com>
>>>>>>>>>>>>
>>>>>>>>>>>> Introduce three new opcodes for zone-append -
>>>>>>>>>>>>
>>>>>>>>>>>>     IORING_OP_ZONE_APPEND     : non-vectord, similiar to
>>>>>>>>>>>> IORING_OP_WRITE
>>>>>>>>>>>>     IORING_OP_ZONE_APPENDV    : vectored, similar to IORING_OP_WRITEV
>>>>>>>>>>>>     IORING_OP_ZONE_APPEND_FIXED : append using fixed-buffers
>>>>>>>>>>>>
>>>>>>>>>>>> Repurpose cqe->flags to return zone-relative offset.
>>>>>>>>>>>>
>>>>>>>>>>>> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
>>>>>>>>>>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>>>>>>>>>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>>>>>>>>>>>> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
>>>>>>>>>>>> ---
>>>>>>>>>>>> fs/io_uring.c                 | 72
>>>>>>>>>>>> +++++++++++++++++++++++++++++++++++++++++--
>>>>>>>>>>>> include/uapi/linux/io_uring.h |  8 ++++-
>>>>>>>>>>>> 2 files changed, 77 insertions(+), 3 deletions(-)
>>>>>>>>>>>>
>>>>>>>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>>>>>>>> index 155f3d8..c14c873 100644
>>>>>>>>>>>> --- a/fs/io_uring.c
>>>>>>>>>>>> +++ b/fs/io_uring.c
>>>>>>>>>>>> @@ -649,6 +649,10 @@ struct io_kiocb {
>>>>>>>>>>>>       unsigned long        fsize;
>>>>>>>>>>>>       u64            user_data;
>>>>>>>>>>>>       u32            result;
>>>>>>>>>>>> +#ifdef CONFIG_BLK_DEV_ZONED
>>>>>>>>>>>> +    /* zone-relative offset for append, in bytes */
>>>>>>>>>>>> +    u32            append_offset;
>>>>>>>>>>> this can overflow. u64 is needed.
>>>>>>>>>> We chose to do it this way to start with because struct io_uring_cqe
>>>>>>>>>> only has space for u32 when we reuse the flags.
>>>>>>>>>>
>>>>>>>>>> We can of course create a new cqe structure, but that will come with
>>>>>>>>>> larger changes to io_uring for supporting append.
>>>>>>>>>>
>>>>>>>>>> Do you believe this is a better approach?
>>>>>>>>> The problem is that zone size are 32 bits in the kernel, as a number
>>>>>>>>> of sectors.
>>>>>>>>> So any device that has a zone size smaller or equal to 2^31 512B
>>>>>>>>> sectors can be
>>>>>>>>> accepted. Using a zone relative offset in bytes for returning zone
>>>>>>>>> append result
>>>>>>>>> is OK-ish, but to match the kernel supported range of possible zone
>>>>>>>>> size, you
>>>>>>>>> need 31+9 bits... 32 does not cut it.
>>>>>>>> Agree. Our initial assumption was that u32 would cover current zone size
>>>>>>>> requirements, but if this is a no-go, we will take the longer path.
>>>>>>> Converting to u64 will require a new version of io_uring_cqe, where we
>>>>>>> extend at least 32 bits. I believe this will need a whole new allocation
>>>>>>> and probably ioctl().
>>>>>>>
>>>>>>> Is this an acceptable change for you? We will of course add support for
>>>>>>> liburing when we agree on the right way to do this.
>>>>>> I took a quick look at the code. No expert, but why not use the existing
>>>>>> userdata variable? use the lowest bits (40 bits) for the Zone Starting
>>>>>> LBA, and use the highest (24 bits) as index into the completion data
>>>>>> structure?
>>>>>>
>>>>>> If you want to pass the memory address (same as what fio does) for the
>>>>>> data structure used for completion, one may also play some tricks by
>>>>>> using a relative memory address to the data structure. For example, the
>>>>>> x86_64 architecture uses 48 address bits for its memory addresses. With
>>>>>> 24 bit, one can allocate the completion entries in a 32MB memory range,
>>>>>> and then use base_address + index to get back to the completion data
>>>>>> structure specified in the sqe.
>>>>> For any current request, sqe->user_data is just provided back as
>>>>> cqe->user_data. This would make these requests behave differently
>>>>> from everything else in that sense, which seems very confusing to me
>>>>> if I was an application writer.
>>>>>
>>>>> But generally I do agree with you, there are lots of ways to make
>>>>> < 64-bit work as a tag without losing anything or having to jump
>>>>> through hoops to do so. The lack of consistency introduced by having
>>>>> zone append work differently is ugly, though.
>>>>>
>>>> Yep, agree, and extending to three cachelines is big no-go. We could add
>>>> a flag that said the kernel has changes the userdata variable. That'll
>>>> make it very explicit.
>>> Don't like that either, as it doesn't really change the fact that you're
>>> now doing something very different with the user_data field, which is
>>> just supposed to be passed in/out directly. Adding a random flag to
>>> signal this behavior isn't very explicit either, imho. It's still some
>>> out-of-band (ish) notification of behavior that is different from any
>>> other command. This is very different from having a flag that says
>>> "there's extra information in this other field", which is much cleaner.
>>>
>> Ok. Then it's pulling in the bits from cqe->res and cqe->flags that you
>> mention in the other mail. Sounds good.
>
>I think that's the best approach, if we need > 32-bits. Maybe we can get
>by just using ->res, if we switch to multiples of 512b instead for the
>result like Pavel suggested. That'd provide enough room in ->res, and
>would be preferable imho. But if we do need > 32-bits, then we can use
>this approach.

Sounds good.

Thanks Matias too for chipping in with more ideas. We have enough for a
v2.

Javier
