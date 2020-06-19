Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BC7200792
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2020 13:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgFSLQM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Jun 2020 07:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728554AbgFSLQA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Jun 2020 07:16:00 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E03C0613F0
        for <io-uring@vger.kernel.org>; Fri, 19 Jun 2020 04:15:59 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id t18so9303261wru.6
        for <io-uring@vger.kernel.org>; Fri, 19 Jun 2020 04:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lightnvm-io.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Hi8U0oa4ECwGBgwFm+Zk8gf3umBmRtguu4SNlo3Wcp4=;
        b=StEaGEJZO0usAcheUJQMceOcousYFImUR4fWmkkQMJKjNfv8JxCdBue29dvVNfA9+Q
         SO5ENs/fd8JGrgQQHpElj1DY++tLKIKs+7VpWwis/cm1ihs/5jwEbxxchngdEGXdBZxX
         u3gJvA1BO2V2vdjKeTQMfk8w9B5ye56dHXq1BbykgADfbeg3LJK12ChC++/fbMj4PnYc
         Ls94rIO5c7cj7m+buXEmq8K8HoL6RTGbIcDPaXFJlactwIwpDjGvFgHGG4NyelbmSpkI
         w3bR0MmTy6JdxuMGP1vVBrmubVp6r8pclc1wG2FD4wFnridmLYee+p/EI1XwRJ9vcEf3
         hylA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Hi8U0oa4ECwGBgwFm+Zk8gf3umBmRtguu4SNlo3Wcp4=;
        b=eDwAh3iE+egISYt5S0PZvHFJ9vpuClb+cYR1R+AatmGlPXhyrB8WaLnzWiI3/+jznl
         a4O3kDT+gsly/Pn45vN1sCLwZglUNhkywIJlMj0IMf7ptXeb/MB3gcQMwCLg6i6TDaeI
         o4zxgexQCiX+CGCyJJSsSRzQi6CHquTG4RgtG/nczipA69dld7U7Eu5/kN17U7zI0b0H
         2K/5178gyU+Do3mnKc6/Kh8UAnH4t+IQ68uI3FcXJX/Js1HgKWLPS3Ds4gTVCp50ucLA
         KDQw6zSAZWfDtAxV9Za/66N0Cqi0WVzSrkDGNPwT5o34Es2xm+W8qAcfJnwovAaGRGEx
         NVig==
X-Gm-Message-State: AOAM532HoeqIbj+i2JkcZJfuDkiDAPJHAebs0ur3m+I8LFvtXUe42dvJ
        BVQwWGbYzsCaOMzkHXCke5XKxS8gO1c=
X-Google-Smtp-Source: ABdhPJymysNAQo58huj/2H6j2pwg0CJUZVco9yeQXveWJ30tQT04huMXGSMMbfsYuI2OMrd6oOsFOQ==
X-Received: by 2002:adf:f512:: with SMTP id q18mr3849183wro.38.1592565357974;
        Fri, 19 Jun 2020 04:15:57 -0700 (PDT)
Received: from [10.0.0.6] (xb932c246.cust.hiper.dk. [185.50.194.70])
        by smtp.gmail.com with ESMTPSA id v27sm7450473wrv.81.2020.06.19.04.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 04:15:57 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: add support for zone-append
To:     "javier.gonz@samsung.com" <javier@javigon.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
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
From:   =?UTF-8?Q?Matias_Bj=c3=b8rling?= <mb@lightnvm.io>
Message-ID: <2ba2079c-9a5d-698a-a8f0-cbd6fdb9a9f0@lightnvm.io>
Date:   Fri, 19 Jun 2020 13:15:57 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200619094149.uaorbger326s6yzz@mpHalley.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19/06/2020 11.41, javier.gonz@samsung.com wrote:
> Jens,
>
> Would you have time to answer a question below in this thread?
>
> On 18.06.2020 11:11, javier.gonz@samsung.com wrote:
>> On 18.06.2020 08:47, Damien Le Moal wrote:
>>> On 2020/06/18 17:35, javier.gonz@samsung.com wrote:
>>>> On 18.06.2020 07:39, Damien Le Moal wrote:
>>>>> On 2020/06/18 2:27, Kanchan Joshi wrote:
>>>>>> From: Selvakumar S <selvakuma.s1@samsung.com>
>>>>>>
>>>>>> Introduce three new opcodes for zone-append -
>>>>>>
>>>>>>   IORING_OP_ZONE_APPEND     : non-vectord, similiar to 
>>>>>> IORING_OP_WRITE
>>>>>>   IORING_OP_ZONE_APPENDV    : vectored, similar to IORING_OP_WRITEV
>>>>>>   IORING_OP_ZONE_APPEND_FIXED : append using fixed-buffers
>>>>>>
>>>>>> Repurpose cqe->flags to return zone-relative offset.
>>>>>>
>>>>>> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
>>>>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>>>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>>>>>> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
>>>>>> ---
>>>>>> fs/io_uring.c                 | 72 
>>>>>> +++++++++++++++++++++++++++++++++++++++++--
>>>>>> include/uapi/linux/io_uring.h |  8 ++++-
>>>>>> 2 files changed, 77 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>> index 155f3d8..c14c873 100644
>>>>>> --- a/fs/io_uring.c
>>>>>> +++ b/fs/io_uring.c
>>>>>> @@ -649,6 +649,10 @@ struct io_kiocb {
>>>>>>     unsigned long        fsize;
>>>>>>     u64            user_data;
>>>>>>     u32            result;
>>>>>> +#ifdef CONFIG_BLK_DEV_ZONED
>>>>>> +    /* zone-relative offset for append, in bytes */
>>>>>> +    u32            append_offset;
>>>>>
>>>>> this can overflow. u64 is needed.
>>>>
>>>> We chose to do it this way to start with because struct io_uring_cqe
>>>> only has space for u32 when we reuse the flags.
>>>>
>>>> We can of course create a new cqe structure, but that will come with
>>>> larger changes to io_uring for supporting append.
>>>>
>>>> Do you believe this is a better approach?
>>>
>>> The problem is that zone size are 32 bits in the kernel, as a number 
>>> of sectors.
>>> So any device that has a zone size smaller or equal to 2^31 512B 
>>> sectors can be
>>> accepted. Using a zone relative offset in bytes for returning zone 
>>> append result
>>> is OK-ish, but to match the kernel supported range of possible zone 
>>> size, you
>>> need 31+9 bits... 32 does not cut it.
>>
>> Agree. Our initial assumption was that u32 would cover current zone size
>> requirements, but if this is a no-go, we will take the longer path.
>
> Converting to u64 will require a new version of io_uring_cqe, where we
> extend at least 32 bits. I believe this will need a whole new allocation
> and probably ioctl().
>
> Is this an acceptable change for you? We will of course add support for
> liburing when we agree on the right way to do this.

I took a quick look at the code. No expert, but why not use the existing 
userdata variable? use the lowest bits (40 bits) for the Zone Starting 
LBA, and use the highest (24 bits) as index into the completion data 
structure?

If you want to pass the memory address (same as what fio does) for the 
data structure used for completion, one may also play some tricks by 
using a relative memory address to the data structure. For example, the 
x86_64 architecture uses 48 address bits for its memory addresses. With 
24 bit, one can allocate the completion entries in a 32MB memory range, 
and then use base_address + index to get back to the completion data 
structure specified in the sqe.

Best, Matias


