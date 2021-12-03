Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C075C467873
	for <lists+io-uring@lfdr.de>; Fri,  3 Dec 2021 14:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381168AbhLCNia (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Dec 2021 08:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381194AbhLCNiW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Dec 2021 08:38:22 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2DBBC06139A
        for <io-uring@vger.kernel.org>; Fri,  3 Dec 2021 05:34:56 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id r5so3042905pgi.6
        for <io-uring@vger.kernel.org>; Fri, 03 Dec 2021 05:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WLh7tFpP4KucswHbquZcNDu4MyRihxhPLauGM6dWyuc=;
        b=0me4p3+9aQHUI5cnf9bg/zwfCGsJwORalNjog3H+Io2pxHwAWPQtlTZuIT8XVOeaDt
         63kTgne+UtXHZfZdqVacaJQXenbcGJFiHINE434udQiEQxPjCJ/mg+h50uwYYffDvzUP
         YpRda53PCQQnacPHBwju44utRVsQ758Ci/dV0cQbCrJ4Vxyl9HJ1glLwsL8eg+dQDP2Y
         UdKY9lLgxPPgl46OLbiHz+mQjYsshZ0CSNiX9ZHH70gNTe+AoqrlfmUUms2l4wc4YTsm
         twU96CY7q6BZ6qrQAG9+/J06brOI76zGRPigOxjPd53EljDqLrulUF6l2A52qJZjZQQc
         RRNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WLh7tFpP4KucswHbquZcNDu4MyRihxhPLauGM6dWyuc=;
        b=LzyNU4XeOfjJs30HLilwrzcZdNLvLogN4jUUdcqqsry9hmuliuBa2gQT1E6RPdIJYL
         fOZLq2Cz2Sh4DgiBEwUbqo6pSB1JcxBac98ICgcSlE8KykQPnv9goMd3gJFPdcxJwljF
         UjCiB1R73hSBTsgHBxul0X2SSJT6jucQ2yLMyJgkJFCuKkL9WlzXltbpT1n5mA9P8RZn
         oEh2Aqad8Qz4QFVZ7jFvpz9LdLh1534XOMozz2mpmFg75rbykflBxpw5sRE3NLaJALsr
         K4HL34KcJGzhK53D6EK8W09tC0JGqioV2Yh05g1uBGWR2EF0GyLAobviaYa9USfuoNwG
         l/hA==
X-Gm-Message-State: AOAM530vvwAUQBLDzUnio4SKUtOhYN+WPFdzVMGyUhjf0/EkIwFNIoK0
        oRyZ3Ca2nrrxkF1lJlJpUwit7XE5uqWIIzG9
X-Google-Smtp-Source: ABdhPJxaecEggafht3pnbsFoq8kq479WgMMflwSsuRKbdMA2N8kfUjgXK9xnajCstYG5Po3ie/KOsA==
X-Received: by 2002:a05:6a00:a8b:b0:44d:ef7c:94b9 with SMTP id b11-20020a056a000a8b00b0044def7c94b9mr19231196pfl.36.1638538496245;
        Fri, 03 Dec 2021 05:34:56 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id q5sm3983517pfu.66.2021.12.03.05.34.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 05:34:55 -0800 (PST)
Subject: Re: Tasks stuck on exit(2) with 5.15.6
To:     io-uring@vger.kernel.org, flow@cs.fau.de
References: <20211202165606.mqryio4yzubl7ms5@pasture>
 <c4c47346-e499-2210-b511-8aa34677ff2e@kernel.dk>
 <20211203115251.nbwzvwokyg4w3b34@pasture>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <00283a90-a05e-1cd5-ed02-743c8c03faaf@kernel.dk>
Date:   Fri, 3 Dec 2021 06:34:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211203115251.nbwzvwokyg4w3b34@pasture>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/3/21 4:52 AM, Florian Fischer wrote:
> Hi Jens, 
> 
>> Thanks for the bug report, and I really appreciate including a reproducer.
>> Makes everything so much easier to debug.
> 
> Glad I could help :)
> 
>> Are you able to compile your own kernels? Would be great if you can try
>> and apply this one on top of 5.15.6.
>>
>>
>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>> index 8c6131565754..e8f77903d775 100644
>> --- a/fs/io-wq.c
>> +++ b/fs/io-wq.c
>> @@ -711,6 +711,13 @@ static bool io_wq_work_match_all(struct io_wq_work *work, void *data)
>>  
>>  static inline bool io_should_retry_thread(long err)
>>  {
>> +	/*
>> +	 * Prevent perpetual task_work retry, if the task (or its group) is
>> +	 * exiting.
>> +	 */
>> +	if (fatal_signal_pending(current))
>> +		return false;
>> +
>>  	switch (err) {
>>  	case -EAGAIN:
>>  	case -ERESTARTSYS:
> 
> With your patch on top of 5.15.6 I can no longer reproduce stuck processes.
> Neither with our software nor with the reproducer.
> I ran both a hundred times and both terminated immediately without unexpected CPU usage.
> 
> Tested-by: Florian Fischer <florian.fl.fischer@fau.de>

Great, thanks for testing!

-- 
Jens Axboe

