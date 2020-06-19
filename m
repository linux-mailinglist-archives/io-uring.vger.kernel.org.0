Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C530D201501
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2020 18:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390563AbgFSQQh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Jun 2020 12:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388905AbgFSPDD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Jun 2020 11:03:03 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7CCC0613EE
        for <io-uring@vger.kernel.org>; Fri, 19 Jun 2020 08:03:03 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id j4so4032824plk.3
        for <io-uring@vger.kernel.org>; Fri, 19 Jun 2020 08:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+LnqhKjbJEUfkGCu1m/2g+LppzzVyXYZg47hg3uhOd0=;
        b=ofA1AzoFRZ4MiXl9EfIriR7S7EEDw0MZ3OcZfvwiug8/LxQyXqMBhQNc2t5MB4T+MP
         1cBRaqv+Adlb0QGtdhesz8tTqpZT/UwhaqJF283gfDbIcx+/t4EHoPX+zzrLRht1fkO7
         /eKNTyjuZrSpP6Fa3jjLRB/oeFGV5+We667m5i+qOfK6jAKzhPFN4LZ7Aea1U3BBlq5y
         r3hyxLdpzzZk0u/q8g8dw5E33HSygPnaxl4wZAuLkwk+LRt7Wwyb1K0YLAGrwQ694bzP
         HPTAc7nLX+UjyYmLYhVbNDjEQQ2xyaNr+kVwkozO+qmrizxiTxaohrM6KVBv8BSzuh7G
         rPbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+LnqhKjbJEUfkGCu1m/2g+LppzzVyXYZg47hg3uhOd0=;
        b=SWNGhGiw4Zbe3dQ6Re9wHq24AXbnikJ/S5/zUst4+0oGp7dloZUpN2iDunfjkOZlxR
         ifb0r5xoHya0gUMtvqNW8qdVdggwgfAttGPl3lUK3d+Xgxu944AhQHsg/ffhP8qwNJcE
         XnoCYBA/4XPMNacBdyws9WdDQy+Yt0r/bbbk0Ot801acf+CwUXoH+eHTno8raQiVlO/Y
         MdqcAAzGIR8NUWDdjozuRGCSMvRyeKMQLuuKE5XTglsq2AIf3ubPFHRAKyJk3AcRVD+V
         9MrndhlhmsC/CUWPl2WpGcwr0/kakJMFhRhISe14WKcjXYotOQClrBae/pfon08X6m3F
         K5Tg==
X-Gm-Message-State: AOAM5314+Ym7UPz99OVOAuen1phovuvIjjqcNETHIXxtCx/TdxWeMC3K
        KUmgxjlC/A40cXAraxEG6yq9Og==
X-Google-Smtp-Source: ABdhPJzxl6m4GmVs1yhzQxBYGEsuQSldHuD3SkC6vlqhKC8YiMob8skih3KD4PgAX5KiZe8FPTwA+g==
X-Received: by 2002:a17:902:d392:: with SMTP id e18mr8544615pld.295.1592578983045;
        Fri, 19 Jun 2020 08:03:03 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q65sm6281283pfc.155.2020.06.19.08.02.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 08:03:01 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: add support for zone-append
To:     Pavel Begunkov <asml.silence@gmail.com>,
        "javier.gonz@samsung.com" <javier@javigon.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "selvakuma.s1@samsung.com" <selvakuma.s1@samsung.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>
References: <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
 <CGME20200617172713epcas5p352f2907a12bd4ee3c97be1c7d8e1569e@epcas5p3.samsung.com>
 <1592414619-5646-4-git-send-email-joshi.k@samsung.com>
 <CY4PR04MB37510E916B6F243D189B4EB0E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200618083529.ciifu4chr4vrv2j5@mpHalley.local>
 <CY4PR04MB3751D5D6AFB0DA7B8A2DFF61E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200618091113.eu2xdp6zmdooy5d2@mpHalley.local>
 <20200619094149.uaorbger326s6yzz@mpHalley.local>
 <31f1c27e-4a3d-a411-3d3b-f88a2d92ce7b@kernel.dk>
 <24297973-82ad-a629-e5f5-38a5b12db83a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a68cb8f6-e17c-9ee3-b732-4be689ffebc3@kernel.dk>
Date:   Fri, 19 Jun 2020 09:02:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <24297973-82ad-a629-e5f5-38a5b12db83a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/19/20 8:59 AM, Pavel Begunkov wrote:
> On 19/06/2020 17:15, Jens Axboe wrote:
>> On 6/19/20 3:41 AM, javier.gonz@samsung.com wrote:
>>> Jens,
>>>
>>> Would you have time to answer a question below in this thread?
>>>
>>> On 18.06.2020 11:11, javier.gonz@samsung.com wrote:
>>>> On 18.06.2020 08:47, Damien Le Moal wrote:
>>>>> On 2020/06/18 17:35, javier.gonz@samsung.com wrote:
>>>>>> On 18.06.2020 07:39, Damien Le Moal wrote:
>>>>>>> On 2020/06/18 2:27, Kanchan Joshi wrote:
>>>>>>>> From: Selvakumar S <selvakuma.s1@samsung.com>
>>>>>>>>
>>>>>>>> Introduce three new opcodes for zone-append -
>>>>>>>>
>>>>>>>>   IORING_OP_ZONE_APPEND     : non-vectord, similiar to IORING_OP_WRITE
>>>>>>>>   IORING_OP_ZONE_APPENDV    : vectored, similar to IORING_OP_WRITEV
>>>>>>>>   IORING_OP_ZONE_APPEND_FIXED : append using fixed-buffers
>>>>>>>>
>>>>>>>> Repurpose cqe->flags to return zone-relative offset.
>>>>>>>>
>>>>>>>> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
>>>>>>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>>>>>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>>>>>>>> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
>>>>>>>> ---
>>>>>>>> fs/io_uring.c                 | 72 +++++++++++++++++++++++++++++++++++++++++--
>>>>>>>> include/uapi/linux/io_uring.h |  8 ++++-
>>>>>>>> 2 files changed, 77 insertions(+), 3 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>>>> index 155f3d8..c14c873 100644
>>>>>>>> --- a/fs/io_uring.c
>>>>>>>> +++ b/fs/io_uring.c
>>>>>>>> @@ -649,6 +649,10 @@ struct io_kiocb {
>>>>>>>> 	unsigned long		fsize;
>>>>>>>> 	u64			user_data;
>>>>>>>> 	u32			result;
>>>>>>>> +#ifdef CONFIG_BLK_DEV_ZONED
>>>>>>>> +	/* zone-relative offset for append, in bytes */
>>>>>>>> +	u32			append_offset;
>>>>>>>
>>>>>>> this can overflow. u64 is needed.
>>>>>>
>>>>>> We chose to do it this way to start with because struct io_uring_cqe
>>>>>> only has space for u32 when we reuse the flags.
>>>>>>
>>>>>> We can of course create a new cqe structure, but that will come with
>>>>>> larger changes to io_uring for supporting append.
>>>>>>
>>>>>> Do you believe this is a better approach?
>>>>>
>>>>> The problem is that zone size are 32 bits in the kernel, as a number
>>>>> of sectors.  So any device that has a zone size smaller or equal to
>>>>> 2^31 512B sectors can be accepted. Using a zone relative offset in
>>>>> bytes for returning zone append result is OK-ish, but to match the
>>>>> kernel supported range of possible zone size, you need 31+9 bits...
>>>>> 32 does not cut it.
>>>>
>>>> Agree. Our initial assumption was that u32 would cover current zone size
>>>> requirements, but if this is a no-go, we will take the longer path.
>>>
>>> Converting to u64 will require a new version of io_uring_cqe, where we
>>> extend at least 32 bits. I believe this will need a whole new allocation
>>> and probably ioctl().
>>>
>>> Is this an acceptable change for you? We will of course add support for
>>> liburing when we agree on the right way to do this.
>>
>> If you need 64-bit of return value, then it's not going to work. Even
>> with the existing patches, reusing cqe->flags isn't going to fly, as
>> it would conflict with eg doing zone append writes with automatic
>> buffer selection.
> 
> Buffer selection is for reads/recv kind of requests, but appends
> are writes. In theory they can co-exist using cqe->flags.

Yeah good point, since it's just writes, doesn't matter. But the other
point still stands, it could potentially conflict with other flags, but
I guess only to the extent where both flags would need extra storage in
->flags. So not a huge concern imho.


-- 
Jens Axboe

