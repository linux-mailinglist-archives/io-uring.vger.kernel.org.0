Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0FD201565
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2020 18:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394700AbgFSQVo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Jun 2020 12:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390650AbgFSPAk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Jun 2020 11:00:40 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF64C06174E;
        Fri, 19 Jun 2020 08:00:40 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id dr13so10525967ejc.3;
        Fri, 19 Jun 2020 08:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nzEVZi8volNOB1waOh1GZnF3JShWIxX8djOHFw4lYjw=;
        b=Q0YBv3We5zGUJiH2ppbZraxmrVO9qUrHWpju0wO/75wJcDr8dzMrKvzrOSfcvQsCoe
         oLgsc93oYktBZ7P6tZVtw4A5LRWWt3G6eqw5curW4O2fPb4w395Cfku3EjtPM4Zv+NQW
         qG/UoTfUp41CP+ocnNC/uW8PM6KceyWt7hnyewi3WOWuqO3ex7OybN1umqk3kxpwq8IL
         CIQxdvFMdhdDqWWNodWMFBogCZqiSitk0+ZRAMiTXSkQZPYBDmsu7lLe9mF1NQrVQ8qY
         Os9FtBqXDvim5hk3hkUhP74zj1ZbUs7wFqZz4gCmROn+V80QnyXMeFMe4Tb0c/PdoXNR
         1FPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=nzEVZi8volNOB1waOh1GZnF3JShWIxX8djOHFw4lYjw=;
        b=ebkmuC1Lm5UBW0Ymt9EvAyqd/YjAad9L2VgcB5IR8ylTRN8EIyjQASVQesjuLB2ycC
         afx9q9aNIzECUUfpt3yc5l9x90JR5kohQ3BgKRZwZ5yo5Q4Ir2TNKXyOsAv2JzUQgEnc
         +jJMVBI3md3oo6h1mqRhwEhWt7gwwJBWzHSdHAc8qolJhY7vXgAUWJsjSZr+Wh4/Pzz9
         IWlhqCfBZFbdiFDguW06OVcmul/Zql9ApRYEAPdXhtOq4Z+zjJS17Pn8X7FTQ3Rkorq0
         UUf9BnjMIfS5Yxpx4uWdQCLASldMR70nk3v615LjnFk35lk6CR0/+3yfEGRSVx0xd2PV
         ZKnA==
X-Gm-Message-State: AOAM531NzEMSHf9Kh9l0iN19Crh6t12ufyjlO2FIxViUiN4xVILY9E8Y
        Lyj64OM0VA+Cv3qfVnIUbgg=
X-Google-Smtp-Source: ABdhPJzfByVwCoFRMHh4pPOZg9Ctxfik+BgbCOq/YS99Ts3p3Wi5Zgo4uPV2x0dOPF6mVvzHQFGfGA==
X-Received: by 2002:a17:906:8401:: with SMTP id n1mr3731213ejx.479.1592578837970;
        Fri, 19 Jun 2020 08:00:37 -0700 (PDT)
Received: from [192.168.43.243] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id w3sm4901342ejn.87.2020.06.19.08.00.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 08:00:37 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>,
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
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 3/3] io_uring: add support for zone-append
Message-ID: <24297973-82ad-a629-e5f5-38a5b12db83a@gmail.com>
Date:   Fri, 19 Jun 2020 17:59:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <31f1c27e-4a3d-a411-3d3b-f88a2d92ce7b@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19/06/2020 17:15, Jens Axboe wrote:
> On 6/19/20 3:41 AM, javier.gonz@samsung.com wrote:
>> Jens,
>>
>> Would you have time to answer a question below in this thread?
>>
>> On 18.06.2020 11:11, javier.gonz@samsung.com wrote:
>>> On 18.06.2020 08:47, Damien Le Moal wrote:
>>>> On 2020/06/18 17:35, javier.gonz@samsung.com wrote:
>>>>> On 18.06.2020 07:39, Damien Le Moal wrote:
>>>>>> On 2020/06/18 2:27, Kanchan Joshi wrote:
>>>>>>> From: Selvakumar S <selvakuma.s1@samsung.com>
>>>>>>>
>>>>>>> Introduce three new opcodes for zone-append -
>>>>>>>
>>>>>>>   IORING_OP_ZONE_APPEND     : non-vectord, similiar to IORING_OP_WRITE
>>>>>>>   IORING_OP_ZONE_APPENDV    : vectored, similar to IORING_OP_WRITEV
>>>>>>>   IORING_OP_ZONE_APPEND_FIXED : append using fixed-buffers
>>>>>>>
>>>>>>> Repurpose cqe->flags to return zone-relative offset.
>>>>>>>
>>>>>>> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
>>>>>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>>>>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>>>>>>> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
>>>>>>> ---
>>>>>>> fs/io_uring.c                 | 72 +++++++++++++++++++++++++++++++++++++++++--
>>>>>>> include/uapi/linux/io_uring.h |  8 ++++-
>>>>>>> 2 files changed, 77 insertions(+), 3 deletions(-)
>>>>>>>
>>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>>> index 155f3d8..c14c873 100644
>>>>>>> --- a/fs/io_uring.c
>>>>>>> +++ b/fs/io_uring.c
>>>>>>> @@ -649,6 +649,10 @@ struct io_kiocb {
>>>>>>> 	unsigned long		fsize;
>>>>>>> 	u64			user_data;
>>>>>>> 	u32			result;
>>>>>>> +#ifdef CONFIG_BLK_DEV_ZONED
>>>>>>> +	/* zone-relative offset for append, in bytes */
>>>>>>> +	u32			append_offset;
>>>>>>
>>>>>> this can overflow. u64 is needed.
>>>>>
>>>>> We chose to do it this way to start with because struct io_uring_cqe
>>>>> only has space for u32 when we reuse the flags.
>>>>>
>>>>> We can of course create a new cqe structure, but that will come with
>>>>> larger changes to io_uring for supporting append.
>>>>>
>>>>> Do you believe this is a better approach?
>>>>
>>>> The problem is that zone size are 32 bits in the kernel, as a number
>>>> of sectors.  So any device that has a zone size smaller or equal to
>>>> 2^31 512B sectors can be accepted. Using a zone relative offset in
>>>> bytes for returning zone append result is OK-ish, but to match the
>>>> kernel supported range of possible zone size, you need 31+9 bits...
>>>> 32 does not cut it.
>>>
>>> Agree. Our initial assumption was that u32 would cover current zone size
>>> requirements, but if this is a no-go, we will take the longer path.
>>
>> Converting to u64 will require a new version of io_uring_cqe, where we
>> extend at least 32 bits. I believe this will need a whole new allocation
>> and probably ioctl().
>>
>> Is this an acceptable change for you? We will of course add support for
>> liburing when we agree on the right way to do this.
> 
> If you need 64-bit of return value, then it's not going to work. Even
> with the existing patches, reusing cqe->flags isn't going to fly, as
> it would conflict with eg doing zone append writes with automatic
> buffer selection.

Buffer selection is for reads/recv kind of requests, but appends
are writes. In theory they can co-exist using cqe->flags.


> 
> We're not changing the io_uring_cqe. It's important to keep it lean, and
> any other request type is generally fine with 64-bit tag + 32-bit result
> (and 32-bit flags on the side) for completions.
> 
> Only viable alternative I see would be to provide an area to store this
> information, and pass in a pointer to this at submission time through
> the sqe. One issue I do see with that is if we only have this
> information available at completion time, then we'd need some async punt
> to copy it to user space... Generally not ideal.
> 
> A hackier approach would be to play some tricks with cqe->res and
> cqe->flags, setting aside a flag to denote an extension of cqe->res.
> That would mean excluding zone append (etc) from using buffer selection,
> which probably isn't a huge deal. It'd be more problematic for any other
> future flags. But if you just need 40 bits, then it could certainly
> work. Rigth now, if cqe->flags & 1 is set, then (cqe->flags >> 16) is
> the buffer ID. You could define IORING_CQE_F_ZONE_FOO to be bit 1, so
> that:
> 
> 	uint64_t val = cqe->res; // assuming non-error here
> 
> 	if (cqe->flags & IORING_CQE_F_ZONE_FOO)
> 		val |= (cqe->flags >> 16) << 32ULL;
> 
> and hence use the upper 16 bits of cqe->flags for the upper bits of your
> (then) 48-bit total value.

How about returning offset in terms of 512-bytes chunks? NVMe is 512B
atomic/aligned. We'll lose an ability to do non-512 aligned appends, but
it won't hit media as such anyway (will be padded or cached), so
personally I don't see much benefit in having it.


-- 
Pavel Begunkov
