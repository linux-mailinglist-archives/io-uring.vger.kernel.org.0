Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 650571FEE59
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 11:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgFRJLU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 05:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728955AbgFRJLS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 05:11:18 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C9AC0613EE
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 02:11:16 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id l11so5250729wru.0
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 02:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nJ/ameCVngCfbGYTO+5aI2tlO0POD3IpltXZZNLuxEs=;
        b=zrEq0qH5SUEXfv9B8Ir5FQX8mZb9/7ShVjC1BqOnxa+nJeZZepPmEXK0JUq9Iyo/er
         x2eV2pn2BWHZZYzdw8xWsFUWKUmeJ2LD0KtYxtFNlFFMMUrP3JuBoJQh5pCG0LPjeBXb
         Bj/SSgbof0QLi7qLSpLHKlV1nbJkdJLFawhgO8tsKLBmz4bafqZR0T+4ppsS7C9a9SUW
         Uqs9ZRYksz+MN2tnjrFdL7Q3hlp6toE2WynUOVWvB1951khtuJOXjysmpuQxmkjTaK9w
         WKMnxGdseFfMzIDugIemYPP8DSqA3Reo0AAoyttSjL52Sb7wQ5cxg8jIDYGFDymW76Ol
         /7LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nJ/ameCVngCfbGYTO+5aI2tlO0POD3IpltXZZNLuxEs=;
        b=h5wHmpl0VhLI/Z4YvMkd6W6u6/GhKs+LxBPyzRfKgTTm09Gi/yhJWBVWddJxWeadwk
         TJoxhwYSCnmeyRJBEuyriZYmTKKaSDQHgJZOjts+Zh2iByEgpnIHsT3K/genSBwtPmVz
         YRfVIKd80yiRR67lm9qHZGQHHruZb785J3etYLfy90CxIBG6JM9/zNZJXX+ft5nC+xwb
         gsMKfYZdKE1qG+mCxjReHXekiIDx2YlFlr1tsXcHj3rQoGsR+2pjAyq+Xa5Eoggthza5
         zHjyO2mbR26U3y2WApGcAVIiKSqwFwZhDWR3i8e6fxWWo1ByXDxkFsOrguvLlJ3Dywsc
         Ekjg==
X-Gm-Message-State: AOAM532zmY5xgDK90gLU8LgmKUnFSaT69qfiD/CyKYF7kF+E4HbzqgTX
        1xbW8sm6gGhb3m1BIlkYowMQxA==
X-Google-Smtp-Source: ABdhPJxtEFr+KfP6DTCsP0An0esK+61P9lyK23C48ndc7t0VhLzMWIdc+iJ9BZ0TktVPWIm3QuGzWg==
X-Received: by 2002:a05:6000:114e:: with SMTP id d14mr3499793wrx.110.1592471475570;
        Thu, 18 Jun 2020 02:11:15 -0700 (PDT)
Received: from localhost ([194.62.217.57])
        by smtp.gmail.com with ESMTPSA id q4sm2773031wma.47.2020.06.18.02.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 02:11:14 -0700 (PDT)
Date:   Thu, 18 Jun 2020 11:11:13 +0200
From:   "javier.gonz@samsung.com" <javier@javigon.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
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
Subject: Re: [PATCH 3/3] io_uring: add support for zone-append
Message-ID: <20200618091113.eu2xdp6zmdooy5d2@mpHalley.local>
References: <1592414619-5646-1-git-send-email-joshi.k@samsung.com>
 <CGME20200617172713epcas5p352f2907a12bd4ee3c97be1c7d8e1569e@epcas5p3.samsung.com>
 <1592414619-5646-4-git-send-email-joshi.k@samsung.com>
 <CY4PR04MB37510E916B6F243D189B4EB0E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200618083529.ciifu4chr4vrv2j5@mpHalley.local>
 <CY4PR04MB3751D5D6AFB0DA7B8A2DFF61E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <CY4PR04MB3751D5D6AFB0DA7B8A2DFF61E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 18.06.2020 08:47, Damien Le Moal wrote:
>On 2020/06/18 17:35, javier.gonz@samsung.com wrote:
>> On 18.06.2020 07:39, Damien Le Moal wrote:
>>> On 2020/06/18 2:27, Kanchan Joshi wrote:
>>>> From: Selvakumar S <selvakuma.s1@samsung.com>
>>>>
>>>> Introduce three new opcodes for zone-append -
>>>>
>>>>    IORING_OP_ZONE_APPEND     : non-vectord, similiar to IORING_OP_WRITE
>>>>    IORING_OP_ZONE_APPENDV    : vectored, similar to IORING_OP_WRITEV
>>>>    IORING_OP_ZONE_APPEND_FIXED : append using fixed-buffers
>>>>
>>>> Repurpose cqe->flags to return zone-relative offset.
>>>>
>>>> Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
>>>> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>>>> Signed-off-by: Javier Gonzalez <javier.gonz@samsung.com>
>>>> ---
>>>>  fs/io_uring.c                 | 72 +++++++++++++++++++++++++++++++++++++++++--
>>>>  include/uapi/linux/io_uring.h |  8 ++++-
>>>>  2 files changed, 77 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 155f3d8..c14c873 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -649,6 +649,10 @@ struct io_kiocb {
>>>>  	unsigned long		fsize;
>>>>  	u64			user_data;
>>>>  	u32			result;
>>>> +#ifdef CONFIG_BLK_DEV_ZONED
>>>> +	/* zone-relative offset for append, in bytes */
>>>> +	u32			append_offset;
>>>
>>> this can overflow. u64 is needed.
>>
>> We chose to do it this way to start with because struct io_uring_cqe
>> only has space for u32 when we reuse the flags.
>>
>> We can of course create a new cqe structure, but that will come with
>> larger changes to io_uring for supporting append.
>>
>> Do you believe this is a better approach?
>
>The problem is that zone size are 32 bits in the kernel, as a number of sectors.
>So any device that has a zone size smaller or equal to 2^31 512B sectors can be
>accepted. Using a zone relative offset in bytes for returning zone append result
>is OK-ish, but to match the kernel supported range of possible zone size, you
>need 31+9 bits... 32 does not cut it.

Agree. Our initial assumption was that u32 would cover current zone size
requirements, but if this is a no-go, we will take the longer path.

>
>Since you need a 64-bit sized result, I would also prefer that you drop the zone
>relative offset as a result and return the absolute offset instead. That makes
>life easier for the applications since the zone append requests also must use
>absolute offsets for zone start. An absolute offset as a result becomes
>consistent with that and all other read/write system calls that all use absolute
>offsets (seek() is the only one that I know of that can use a relative offset,
>but that is not an IO system call).

Agree. Using relative offsets was a product of reusing the existing u32.
If we move to u64, there is no need to do an extra transformation.

Thanks Damien!
Javier

