Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBAD20ACB4
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2020 09:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgFZHDt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Jun 2020 03:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgFZHDs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Jun 2020 03:03:48 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F486C08C5DB
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 00:03:48 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id b15so6094053edy.7
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2020 00:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=javigon-com.20150623.gappssmtp.com; s=20150623;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CI3FxrIl7lSns4541JWoWdk57zQMfx31FGFt5L4ayT8=;
        b=hpKkLtzCISaXM7UaRpk86PMZln2paDRk35L9s4Y+KtMylLwOgBcW3JGDz5rzP1BIJl
         joSwIHikA39AefxyGVN7nKmNbZVKT1OlK20Y6wbZXeFQuQXDggbSHVtVCAMESPjE5adW
         q207mt7UGT7ruQ0kSvRVzpc6f8A8IRYxMVrTb1djP6ac4NycqxIyKleGPKGb8b5SkBkC
         vVsqCGt3TurQwBlm29MfAToAQH8UFFO/miOtbV2gII5cHWxrsJUUnPjibGImxjL4SGwz
         51hqhbzW1F9dXdiAhPP9HtiPUY3P0y1ZKwMx250fBprS8wW3zNXonhQWwbLIUfBhMoUM
         v08w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CI3FxrIl7lSns4541JWoWdk57zQMfx31FGFt5L4ayT8=;
        b=oeflUNIHC2bpmMhlo1pv3pM2B1IWZOwD2isVBOW2tsqakuKHrBVbM8zrvpATLBg/ux
         LaCRL3FCMIkPirRqx6rjxgRofSeEYtpWM2rL2+BJWUoC/qGSoaENFTKr971asiIG4we+
         lgp7vLkHQERdWQJogH/Y7V//gszTv9HL5asNXHUGJMrzDdjsg5CJw0VvTv86Sy61HHJ1
         +cy+X+A8AckXf41aY939u6e7+qiOO96HM6r5K7zynM1/J3y86SrCsKJ7bZTszNFh2w0w
         4QyUfuUk8VLCt74WbZ8PcZIpGD/RWZXzdfT+shweXdBhHLLsJ86CydUc26kdtI8k2QuY
         zaGg==
X-Gm-Message-State: AOAM532ig+/zD/4V1qVE6jICYe0404tk0yqIw8TM4FrJcRzqrw86bVc1
        x0KaoEta7i+0pN8LLRFHFiGP+A==
X-Google-Smtp-Source: ABdhPJwNmdcT4mE0xDF8Ewsq0DmM7hEeCyMu0hfp5z0TYSOGnGMsBcd7wFfw4gvuWGBSJSo1RdtqmA==
X-Received: by 2002:aa7:d4ca:: with SMTP id t10mr1921245edr.244.1593155027037;
        Fri, 26 Jun 2020 00:03:47 -0700 (PDT)
Received: from localhost (ip-5-186-127-235.cgn.fibianet.dk. [5.186.127.235])
        by smtp.gmail.com with ESMTPSA id p4sm9756178eja.9.2020.06.26.00.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 00:03:46 -0700 (PDT)
From:   "javier.gonz@samsung.com" <javier@javigon.com>
X-Google-Original-From: "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Date:   Fri, 26 Jun 2020 09:03:45 +0200
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "mb@lightnvm.io" <mb@lightnvm.io>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "selvakuma.s1@samsung.com" <selvakuma.s1@samsung.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>
Subject: Re: [PATCH v2 0/2] zone-append support in io-uring and aio
Message-ID: <20200626070345.vuxic46l3agy3jay@mpHalley.localdomain>
References: <CGME20200625171829epcas5p268486a0780571edb4999fc7b3caab602@epcas5p2.samsung.com>
 <1593105349-19270-1-git-send-email-joshi.k@samsung.com>
 <CY4PR04MB37511E3B19035012A143D006E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
 <20200626063717.4dhsydpcnezjhj3o@mpHalley.localdomain>
 <CY4PR04MB375154780F0B8073AB83DA9CE7930@CY4PR04MB3751.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <CY4PR04MB375154780F0B8073AB83DA9CE7930@CY4PR04MB3751.namprd04.prod.outlook.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 26.06.2020 06:56, Damien Le Moal wrote:
>On 2020/06/26 15:37, javier.gonz@samsung.com wrote:
>> On 26.06.2020 03:11, Damien Le Moal wrote:
>>> On 2020/06/26 2:18, Kanchan Joshi wrote:
>>>> [Revised as per feedback from Damien, Pavel, Jens, Christoph, Matias, Wilcox]
>>>>
>>>> This patchset enables zone-append using io-uring/linux-aio, on block IO path.
>>>> Purpose is to provide zone-append consumption ability to applications which are
>>>> using zoned-block-device directly.
>>>>
>>>> The application may specify RWF_ZONE_APPEND flag with write when it wants to
>>>> send zone-append. RWF_* flags work with a certain subset of APIs e.g. uring,
>>>> aio, and pwritev2. An error is reported if zone-append is requested using
>>>> pwritev2. It is not in the scope of this patchset to support pwritev2 or any
>>>> other sync write API for reasons described later.
>>>>
>>>> Zone-append completion result --->
>>>> With zone-append, where write took place can only be known after completion.
>>>> So apart from usual return value of write, additional mean is needed to obtain
>>>> the actual written location.
>>>>
>>>> In aio, this is returned to application using res2 field of io_event -
>>>>
>>>> struct io_event {
>>>>         __u64           data;           /* the data field from the iocb */
>>>>         __u64           obj;            /* what iocb this event came from */
>>>>         __s64           res;            /* result code for this event */
>>>>         __s64           res2;           /* secondary result */
>>>> };
>>>>
>>>> In io-uring, cqe->flags is repurposed for zone-append result.
>>>>
>>>> struct io_uring_cqe {
>>>>         __u64   user_data;      /* sqe->data submission passed back */
>>>>         __s32   res;            /* result code for this event */
>>>>         __u32   flags;
>>>> };
>>>>
>>>> Since 32 bit flags is not sufficient, we choose to return zone-relative offset
>>>> in sector/512b units. This can cover zone-size represented by chunk_sectors.
>>>> Applications will have the trouble to combine this with zone start to know
>>>> disk-relative offset. But if more bits are obtained by pulling from res field
>>>> that too would compel application to interpret res field differently, and it
>>>> seems more painstaking than the former option.
>>>> To keep uniformity, even with aio, zone-relative offset is returned.
>>>
>>> I am really not a fan of this, to say the least. The input is byte offset, the
>>> output is 512B relative sector count... Arg... We really cannot do better than
>>> that ?
>>>
>>> At the very least, byte relative offset ? The main reason is that this is
>>> _somewhat_ acceptable for raw block device accesses since the "sector"
>>> abstraction has a clear meaning, but once we add iomap/zonefs async zone append
>>> support, we really will want to have byte unit as the interface is regular
>>> files, not block device file. We could argue that 512B sector unit is still
>>> around even for files (e.g. block counts in file stat). Bu the different unit
>>> for input and output of one operation is really ugly. This is not nice for the user.
>>>
>>
>> You can refer to the discussion with Jens, Pavel and Alex on the uring
>> interface. With the bits we have and considering the maximun zone size
>> supported, there is no space for a byte relative offset. We can take
>> some bits from cqe->res, but we were afraid this is not very
>> future-proof. Do you have a better idea?
>
>If you can take 8 bits, that gives you 40 bits, enough to support byte relative
>offsets for any zone size defined as a number of 512B sectors using an unsigned
>int. Max zone size is 2^31 sectors in that case, so 2^40 bytes. Unless I am
>already too tired and my math is failing me...

Yes, the match is correct. I was thinking more of the bits being needed
for other use-case that could collide with append. We considered this
and discard it for being messy - when Pavel brought up the 512B
alignment we saw it as a good alternative.

Note too that we would be able to translate to a byte offset in
iouring.h too so the user would not need to think of this.

I do not feel strongly on this, so the one that better fits the current
and near-future for uring, that is the one we will send on V3. Will give
it until next week for others to comment too.

>
>zone size is defined by chunk_sectors, which is used for raid and software raids
>too. This has been an unsigned int forever. I do not see the need for changing
>this to a 64bit anytime soon, if ever. A raid with a stripe size larger than 1TB
>does not really make any sense. Same for zone size...

Yes. I think already max zone sizes are pretty huge. But yes, this might
change, so we will take it when it happens.

[...]

Javier
