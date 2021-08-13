Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6250A3EBD70
	for <lists+io-uring@lfdr.de>; Fri, 13 Aug 2021 22:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbhHMUeT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Aug 2021 16:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbhHMUeS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Aug 2021 16:34:18 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A81C061756
        for <io-uring@vger.kernel.org>; Fri, 13 Aug 2021 13:33:51 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id f3so13542822plg.3
        for <io-uring@vger.kernel.org>; Fri, 13 Aug 2021 13:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ABWosmjAaFo3NK/8PQj1Ap5zVyQ9s7Ah5OZmjqVTvdk=;
        b=lL3C0yRT2oUzwav5KLs6yrUqX0MI35Na+qPc6LIwuv39c0zoUeURjYVj6+Qu86Ccuo
         rYM/n7teOzKMnAeSl5TcG0oG6zQvBgdpUVerEERlqALZfGBvxArJj7YCnnFqzLCj7yKp
         /ht8pi1qQ0d/5XNkNaTwoIDhiBLsa+pxlO9H9BYz3tpqRPGFIB5ld7qTXUxhlMmuYRlm
         gXcOlp5H4EatcVE+1mFFJUhSHthjjmvRZ5sGZZWvXht4yeHaRrjlnPNUIu3bDtgZJNkt
         W+VkfgRlUPbWhc2CPFOZgBV4Wy4lgwLkM8zFOawcCc4Llh4ZQlhv9CqA2yQg65ri3uLD
         n+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ABWosmjAaFo3NK/8PQj1Ap5zVyQ9s7Ah5OZmjqVTvdk=;
        b=d2vUMWBylIfJci+1EDlgCwNyUwOJZcTaqKN0m2J9lTsjChP9Mvu0e/Pl8B0ea2fPWo
         F7gfIt7WuOVejltWjFz87zqstytB2mSrtW77hf0tQnFwKVme2YwGcmFFInETK2tupZe8
         k+3fEmC/DI5kaSW7R7i84PIO9CpVJ+Lfc/DKxuwV+kcd9vRhUk7/BIvZSQGhW8edblJj
         GaFK9FXcnmIxSrv4Td+PLwPZjcrOWh3L9zojLbM3LohOZDP4v0/ql5gA4x5ltqlmKqqV
         bJ8R9qvIACmLm4mX5KnSCXsgbwMFFx/0GiLGY1c2FIpaXJ/AloGk2QianC3ZUlu1PL65
         wuhA==
X-Gm-Message-State: AOAM533b0As5GvZ20jqEavSn+2aZQtKo1sIesnAAXzmr3e5su/NYfYSM
        OGpP0ADwuzCJyPZmt3Nyrocl4A==
X-Google-Smtp-Source: ABdhPJxRXlziHeLEdRZ78OBP2O1Yt1YK3jHIBrHNoOKAKFI3ic1PxitCyp6hgizB6kyc3aU19RSRPA==
X-Received: by 2002:a17:90a:2f44:: with SMTP id s62mr4219435pjd.222.1628886829966;
        Fri, 13 Aug 2021 13:33:49 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id n15sm3376164pff.149.2021.08.13.13.33.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 13:33:49 -0700 (PDT)
Subject: Re: [PATCH 4/6] block: clear BIO_PERCPU_CACHE flag if polling isn't
 supported
To:     Keith Busch <kbusch@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        hch@infradead.org
References: <20210812154149.1061502-1-axboe@kernel.dk>
 <20210812154149.1061502-5-axboe@kernel.dk>
 <20210812173143.GA3138953@dhcp-10-100-145-180.wdc.com>
 <b60e0031-77b0-fe27-2b52-437ba21babcb@kernel.dk>
 <20210813201722.GB2661@dhcp-10-100-145-180.wdc.com>
 <33d05811-a9c6-c1d3-8b9c-7b95bdadd457@kernel.dk>
 <20210813203138.GA2761@dhcp-10-100-145-180.wdc.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f75f3fdc-d696-f417-fae1-087ad5d0eb44@kernel.dk>
Date:   Fri, 13 Aug 2021 14:33:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210813203138.GA2761@dhcp-10-100-145-180.wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/13/21 2:31 PM, Keith Busch wrote:
> On Fri, Aug 13, 2021 at 02:19:11PM -0600, Jens Axboe wrote:
>> On 8/13/21 2:17 PM, Keith Busch wrote:
>>> On Thu, Aug 12, 2021 at 11:41:58AM -0600, Jens Axboe wrote:
>>>> Indeed. Wonder if we should make that a small helper, as any clear of
>>>> REQ_HIPRI should clear BIO_PERCPU_CACHE as well.
>>>>
>>>>
>>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>>> index 7e852242f4cc..d2722ecd4d9b 100644
>>>> --- a/block/blk-core.c
>>>> +++ b/block/blk-core.c
>>>> @@ -821,11 +821,8 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
>>>>  		}
>>>>  	}
>>>>  
>>>> -	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags)) {
>>>> -		/* can't support alloc cache if we turn off polling */
>>>> -		bio_clear_flag(bio, BIO_PERCPU_CACHE);
>>>> -		bio->bi_opf &= ~REQ_HIPRI;
>>>> -	}
>>>> +	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
>>>> +		bio_clear_hipri(bio);
>>>
>>> Since BIO_PERCPU_CACHE doesn't work without REQ_HIRPI, should this check
>>> look more like this?
>>>
>>> 	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
>>> 		bio->bi_opf &= ~REQ_HIPRI;
>>> 	if (!(bio->bi_opf & REQ_HIPRI))
>>> 		bio_clear_flag(bio, BIO_PERCPU_CACHE);
>>>
>>> I realise the only BIO_PERCPU_CACHE user in this series never sets it
>>> without REQ_HIPRI, but it looks like a problem waiting to happen if
>>> nothing enforces this pairing: someone could set the CACHE flag on a
>>> QUEUE_FLAG_POLL enabled queue without setting HIPRI and get the wrong
>>> bio_put() action.
>>
>> I'd rather turn that into a WARN_ON or similar. But probably better to
>> do that on the freeing side, honestly. That'll be the most reliable way,
>> but a shame to add cycles to the hot path...
> 
> Yeah, it is a coding error if that happened, so a WARN sounds okay. I
> also don't like adding these kinds of checks, so please feel free to not
> include it if you think the usage is clear enough.

Just have to watch for new additions of IOCB_ALLOC_CACHE, which
thankfully shouldn't be too bad.

-- 
Jens Axboe

