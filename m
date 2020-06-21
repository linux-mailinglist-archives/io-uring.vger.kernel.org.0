Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BACB202C0B
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2020 20:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbgFUSwM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 14:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728822AbgFUSwL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 14:52:11 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033D3C061794
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 11:52:10 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id k11so15686322ejr.9
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 11:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GttXTfH5NxnFcwZf4Fm2ECkiTB9eBi9aaT3Bqtm4swk=;
        b=amBJNbYvy5lc+bE5pZ4KoeQASrwSom1ZY/4woHhtYjVoQNU/tqiUlC0lwOBGYvO+yc
         ClQMV1qvtAPDCJoAy6V9Vg2ynUm1hSnQKORuiWzKtCvaBJv0YQu//AxO19sTc9wuh2/+
         uDAmqOvz48L3zaT8Mffltyi95uAIEk8dfdV7T1ASByDevlDtRyz1LczMJm3C5OJCrBp8
         yP/VxK0T5VRMOgY+ZtiNjQKZq/bSbtRMyohi60gfBahBSkHCpt0Nb4sfjR4QSGXDtlLL
         9wEWaRnz49SOxiXAwsrhXusvf/AFvsaB5Dsd84kkW9vGudSt6Oojk8fDjHQfAqXeQPUU
         OVDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GttXTfH5NxnFcwZf4Fm2ECkiTB9eBi9aaT3Bqtm4swk=;
        b=UjUMMhuI7FCzL+HCDxmVL9nhRGD2mcaTd0qU8eTRDdnjibXcxnBlqmxb/lrQWcKnvz
         eiXZDYjweIWfoSgYfNwCG7IfbPx5Hl2mhfGSJ5pGspKAkGzZDzl3JlQyB2IsxtJFt38d
         mZms1vh6CaBCMvUiZ89sPoA3m0o9xVPSIVgAKZpgStxVywHP7mrPAn0LC4Sel/N13izk
         oQY+E0IjPZrWjiqAsGlETaMeaYwAEitNmpW+qEpgDlvLeFZHeolZXHwxjAf3Hvp2Lqqi
         s+FP8h6KElFJ/vF+XrEkeWRA7fKbvR8WwVO0ou5gNVKXpJbNSFqH4OWJ7ylIkXNPhSxx
         TCIg==
X-Gm-Message-State: AOAM533PKtt+XxNzmQ59nEkh8CBvCXCfYWTbHRQAF6JKb6Bf8Xk9AsAC
        aXqj+TPbPrnNFUuZx6vo7+AeXQ==
X-Google-Smtp-Source: ABdhPJx5L5rd0FuHOCqFGxYdf2RvcYSxBqSJzmoHqwkSB0Cc+W1UTYVEfaQgDIg4Zesnv4y3MCz8eA==
X-Received: by 2002:a17:906:b15:: with SMTP id u21mr7646345ejg.520.1592765529516;
        Sun, 21 Jun 2020 11:52:09 -0700 (PDT)
Received: from localhost (ip-5-186-127-235.cgn.fibianet.dk. [5.186.127.235])
        by smtp.gmail.com with ESMTPSA id b26sm9328835eju.6.2020.06.21.11.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2020 11:52:08 -0700 (PDT)
Date:   Sun, 21 Jun 2020 20:52:07 +0200
From:   "javier.gonz@samsung.com" <javier@javigon.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
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
Message-ID: <20200621185207.m7535hzpm4ubrk4i@MacBook-Pro.localdomain>
References: <CGME20200617172713epcas5p352f2907a12bd4ee3c97be1c7d8e1569e@epcas5p3.samsung.com>
 <1592414619-5646-4-git-send-email-joshi.k@samsung.com>
 <CY4PR04MB37510E916B6F243D189B4EB0E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200618083529.ciifu4chr4vrv2j5@mpHalley.local>
 <CY4PR04MB3751D5D6AFB0DA7B8A2DFF61E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200618091113.eu2xdp6zmdooy5d2@mpHalley.local>
 <20200619094149.uaorbger326s6yzz@mpHalley.local>
 <31f1c27e-4a3d-a411-3d3b-f88a2d92ce7b@kernel.dk>
 <24297973-82ad-a629-e5f5-38a5b12db83a@gmail.com>
 <a68cb8f6-e17c-9ee3-b732-4be689ffebc3@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <a68cb8f6-e17c-9ee3-b732-4be689ffebc3@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 19.06.2020 09:02, Jens Axboe wrote:
>On 6/19/20 8:59 AM, Pavel Begunkov wrote:
>> On 19/06/2020 17:15, Jens Axboe wrote:
>>> On 6/19/20 3:41 AM, javier.gonz@samsung.com wrote:
>>>> Jens,
>>>>
>>>> Would you have time to answer a question below in this thread?
>>>>
>>>> On 18.06.2020 11:11, javier.gonz@samsung.com wrote:
>>>>> On 18.06.2020 08:47, Damien Le Moal wrote:
>>>>>> On 2020/06/18 17:35, javier.gonz@samsung.com wrote:
>>>>>>> On 18.06.2020 07:39, Damien Le Moal wrote:
>>>>>>>> On 2020/06/18 2:27, Kanchan Joshi wrote:
>>>>>>>>> From: Selvakumar S <selvakuma.s1@samsung.com>
>>>>>>>>>
>>>>>>>>> Introduce three new opcodes for zone-append -
>>>>>>>>>
>>>>>>>>>   IORING_OP_ZONE_APPEND     : non-vectord, similiar to IORING_OP_WRITE
>>>>>>>>>   IORING_OP_ZONE_APPENDV    : vectored, similar to IORING_OP_WRITEV
>>>>>>>>>   IORING_OP_ZONE_APPEND_FIXED : append using fixed-buffers
>>>>>>>>>
>>>>>>>>> Repurpose cqe->flags to return zone-relative offset.
>>>>>>>>>
>>>>>>>>> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
>>>>>>>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>>>>>>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>>>>>>>>> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
>>>>>>>>> ---
>>>>>>>>> fs/io_uring.c                 | 72 +++++++++++++++++++++++++++++++++++++++++--
>>>>>>>>> include/uapi/linux/io_uring.h |  8 ++++-
>>>>>>>>> 2 files changed, 77 insertions(+), 3 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>>>>> index 155f3d8..c14c873 100644
>>>>>>>>> --- a/fs/io_uring.c
>>>>>>>>> +++ b/fs/io_uring.c
>>>>>>>>> @@ -649,6 +649,10 @@ struct io_kiocb {
>>>>>>>>> 	unsigned long		fsize;
>>>>>>>>> 	u64			user_data;
>>>>>>>>> 	u32			result;
>>>>>>>>> +#ifdef CONFIG_BLK_DEV_ZONED
>>>>>>>>> +	/* zone-relative offset for append, in bytes */
>>>>>>>>> +	u32			append_offset;
>>>>>>>>
>>>>>>>> this can overflow. u64 is needed.
>>>>>>>
>>>>>>> We chose to do it this way to start with because struct io_uring_cqe
>>>>>>> only has space for u32 when we reuse the flags.
>>>>>>>
>>>>>>> We can of course create a new cqe structure, but that will come with
>>>>>>> larger changes to io_uring for supporting append.
>>>>>>>
>>>>>>> Do you believe this is a better approach?
>>>>>>
>>>>>> The problem is that zone size are 32 bits in the kernel, as a number
>>>>>> of sectors.  So any device that has a zone size smaller or equal to
>>>>>> 2^31 512B sectors can be accepted. Using a zone relative offset in
>>>>>> bytes for returning zone append result is OK-ish, but to match the
>>>>>> kernel supported range of possible zone size, you need 31+9 bits...
>>>>>> 32 does not cut it.
>>>>>
>>>>> Agree. Our initial assumption was that u32 would cover current zone size
>>>>> requirements, but if this is a no-go, we will take the longer path.
>>>>
>>>> Converting to u64 will require a new version of io_uring_cqe, where we
>>>> extend at least 32 bits. I believe this will need a whole new allocation
>>>> and probably ioctl().
>>>>
>>>> Is this an acceptable change for you? We will of course add support for
>>>> liburing when we agree on the right way to do this.
>>>
>>> If you need 64-bit of return value, then it's not going to work. Even
>>> with the existing patches, reusing cqe->flags isn't going to fly, as
>>> it would conflict with eg doing zone append writes with automatic
>>> buffer selection.
>>
>> Buffer selection is for reads/recv kind of requests, but appends
>> are writes. In theory they can co-exist using cqe->flags.
>
>Yeah good point, since it's just writes, doesn't matter. But the other
>point still stands, it could potentially conflict with other flags, but
>I guess only to the extent where both flags would need extra storage in
>->flags. So not a huge concern imho.

Very good point Pavel!

If co-existing with the current flags is an option, I'll explore this
for the next version.

Thanks Jens and Pavel for the time and ideas!

Javier
