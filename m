Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55FE17B6E74
	for <lists+io-uring@lfdr.de>; Tue,  3 Oct 2023 18:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240384AbjJCQ1h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Oct 2023 12:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240395AbjJCQ1f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Oct 2023 12:27:35 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1650991
        for <io-uring@vger.kernel.org>; Tue,  3 Oct 2023 09:27:32 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-7748ca56133so10639139f.0
        for <io-uring@vger.kernel.org>; Tue, 03 Oct 2023 09:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696350451; x=1696955251; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QX+xlkj1M9gFP/IF5U1xKk0DZ1EDpjWyhDkxt05MlSM=;
        b=gO+F3ocLmFnWy6UwnMNIGJ66nLLXGIVy+J5VqceqZNfsAE2Fi4tgT6cB17KfeW23Qa
         N28k5VBizxpOQfjYIYfY7ZZjjEBoeHdpqL/DVKAkCkt5gkozqlfTeuEihfkEbd4eKmCx
         hWiqcVoJi5NkXOuTc77y9e7e6ULZoiyjj/XZZ7ujdRBQVeZjm6hZ6qp1/ntMQwcGV/6A
         np5ltR0NBY4Lmhbr7tdSKI6it1PYBL/WXdXQIC7FZfwd6dfe7RwEybreEwmS3VjpqmN9
         B4ONf92v8otZyUwOnSEH2Q73yooQZmKfPKRrro7UiQlbS+HUd6ID2WSBHG5zD5IV4bDw
         lCRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696350451; x=1696955251;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QX+xlkj1M9gFP/IF5U1xKk0DZ1EDpjWyhDkxt05MlSM=;
        b=kPrGk8ajzVPP7JvZ/CKIPmZMRms3Z7sS7AIRt8tdhKNgRlLeqM8HkyW3f1l7XIWTBk
         LJxxv6ckSREBJI9+0Uoec3VGqO/eogqmv+bTeJCuPkBmy/sAZ+vStvUoYp427bXBKu2a
         PrAq4wh47/IXaxdogGemLMQqiNwdsVCvxti4vr3DAua67ymXhRI5xd0PQSmPRHcHFYhY
         Yx04abdqb08izL8Tbuo87jWEKyp+X3SChkAEijTZPWob4eQVeIApC876DsROWlHlxfKW
         07gtF1CyifHO/IvNniIw3q05RHWKvUaBBBY0LpQAQex8/hoLSs/0rOobv9JVE79uXRro
         YUng==
X-Gm-Message-State: AOJu0Yw1cK30LWnZNGoWspoyH0P/PbfU6FznT5ps6Z8Vs3wyzU56Wxw2
        ahjqL91I4kBO+ewQkrvaV/YoUA==
X-Google-Smtp-Source: AGHT+IHf69VRLWPmsWCbdctudw/Vif2HTo1y7gbNMz9ZmNVavOlVwxZgThVH8cht54Aeup6NSDDg3A==
X-Received: by 2002:a5d:9d84:0:b0:792:6be4:3dcb with SMTP id ay4-20020a5d9d84000000b007926be43dcbmr18320602iob.2.1696350451369;
        Tue, 03 Oct 2023 09:27:31 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id i5-20020a6b7e05000000b007871aa2f144sm401446iom.16.2023.10.03.09.27.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 09:27:30 -0700 (PDT)
Message-ID: <08c0b5de-cf5e-432f-b8d6-a60204308d3a@kernel.dk>
Date:   Tue, 3 Oct 2023 10:27:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: don't allow IORING_SETUP_NO_MMAP rings on
 highmem pages
Content-Language: en-US
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <4c9eddf5-75d8-44cf-9365-a0dd3d0b4c05@kernel.dk>
 <x49edibpt2t.fsf@segfault.boston.devel.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <x49edibpt2t.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/3/23 10:30 AM, Jeff Moyer wrote:
> Hi, Jens,
> 
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On at least arm32, but presumably any arch with highmem, if the
>> application passes in memory that resides in highmem for the rings,
>> then we should fail that ring creation. We fail it with -EINVAL, which
>> is what kernels that don't support IORING_SETUP_NO_MMAP will do as well.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: 03d89a2de25b ("io_uring: support for user allocated memory for rings/sqes")
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 783ed0fff71b..d839a80a6751 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -2686,7 +2686,7 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
>>  {
>>  	struct page **page_array;
>>  	unsigned int nr_pages;
>> -	int ret;
>> +	int ret, i;
>>  
>>  	*npages = 0;
>>  
>> @@ -2716,6 +2716,20 @@ static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
>>  	 */
>>  	if (page_array[0] != page_array[ret - 1])
>>  		goto err;
>> +
>> +	/*
>> +	 * Can't support mapping user allocated ring memory on 32-bit archs
>> +	 * where it could potentially reside in highmem. Just fail those with
>> +	 * -EINVAL, just like we did on kernels that didn't support this
>> +	 * feature.
>> +	 */
>> +	for (i = 0; i < nr_pages; i++) {
>> +		if (PageHighMem(page_array[i])) {
>> +			ret = -EINVAL;
>> +			goto err;
>> +		}
>> +	}
>> +
> 
> What do you think about throwing a printk_once in there that explains
> the problem?  I'm worried that this will fail somewhat randomly, and it
> may not be apparent to the user why.  We should also add documentation,
> of course, and encourage developers to add fallbacks for this case.

For both cases posted, it's rather more advanced use cases. And 32-bit
isn't so prevalent anymore, thankfully. I was going to add to the man
pages explaining this failure case. Not sure it's worth adding a printk
for though.

FWIW, once I got an arm32 vm setup, it fails everytime for me. Not sure
how it'd do on 32-bit x86, similarly or more randomly. But yeah it's
definitely at the mercy of how things are mapped.

-- 
Jens Axboe

