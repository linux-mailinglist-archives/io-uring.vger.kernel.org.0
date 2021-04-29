Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F1136E8F6
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 12:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbhD2KmU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Apr 2021 06:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbhD2KmT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 06:42:19 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6550DC06138B;
        Thu, 29 Apr 2021 03:41:33 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id a4so66398884wrr.2;
        Thu, 29 Apr 2021 03:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=REZoex94nDPpipmexh8x+anc7wXyq42sIDmrWVd+E4E=;
        b=Eox34uCxdNUwS2dzIsT2F9Cx+PE+MRH5UfXzYVwGKOWb1NxMievaRdJZ04r2nshq9y
         Tx7DxmJW8sYR3o+CmGGoT5khjFIv8Q+9jKNW/mc3E+YcKfPLUJEBzdkOPZmrgi0smIsR
         2329Pt3m2FokjXoMV7pn4UvNrD6jz859GTCBpRT6Ob3I9s3czsj7D2d0GOaWAVRz2Yns
         UUKwO1K+qQi17/M3kMZR2OK2Bl6vXqDWLRa8PLwPT4bdJuKknJ18aKDj0xHm3w/ajBKp
         4yOrRLlI0O7/+TcKX4z6AifEME6FgWsCa55MMiIXlG+44bPO3uKar5PqZ1LmFILongHK
         sauw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=REZoex94nDPpipmexh8x+anc7wXyq42sIDmrWVd+E4E=;
        b=JuoZbOlkeWGGFdp2/DVuGE3ROxf8FkhF+BD6yFAz6AlQ9DLFssXHbWrjlaF04O45Pp
         /LMQwynmivi5wKECBdvWlDch5BKKMM/QCtIVXUWq9lfXHjAo3OksM74PmW7ERQbfKCSZ
         P9piNS4J2DAXP2YQOrQImpOctM5x6BDg3eA1gjMIvOlsEnhG2QB0GilzOmAWQeMtyab9
         FGE7EEPRQxshvO9FQX4vjfRLxNLEIZGGdHcqw8EuQOz4VbZOJbaD22AAk4d0Rbbc2270
         2mjiW8n4PAdKh/PkF/RnvCRJ5mKREhZq7ZT0FBudWZZnTkRNqwMLQjFjSmms28p0Jhib
         j90A==
X-Gm-Message-State: AOAM5322MvHjuclzyXQJIjjs3lf+kXskamA3k8/Ce5AeAs0pBgtHMRMl
        bYsmqDAbFQDIsLBRR/7tomThK0rCcKE=
X-Google-Smtp-Source: ABdhPJw2JO/LXtxSZ9tvZoEIQ1VPjgXjqZgvLZvz5FHimdiE6knhHHeSqM0L8GdwgjkBYREXhFKFTg==
X-Received: by 2002:adf:e907:: with SMTP id f7mr33531332wrm.86.1619692891904;
        Thu, 29 Apr 2021 03:41:31 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id x8sm4307974wru.70.2021.04.29.03.41.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 03:41:31 -0700 (PDT)
Subject: Re: [PATCH][next] io_uring: Fix memory leak on error return path.
To:     Colin Ian King <colin.king@canonical.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210429102654.58943-1-colin.king@canonical.com>
 <6929b598-ac2f-521a-8e96-dbbf295d137a@gmail.com>
 <0aa1bcfe-9e45-ac54-1292-43caad8b9b06@canonical.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <36a3806a-ca15-b362-2084-75f6787b0412@gmail.com>
Date:   Thu, 29 Apr 2021 11:41:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <0aa1bcfe-9e45-ac54-1292-43caad8b9b06@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/21 11:36 AM, Colin Ian King wrote:
> On 29/04/2021 11:32, Pavel Begunkov wrote:
>> On 4/29/21 11:26 AM, Colin King wrote:
>>> From: Colin Ian King <colin.king@canonical.com>
>>>
>>> Currently the -EINVAL error return path is leaking memory allocated
>>> to data. Fix this by kfree'ing data before the return.
>>>
>>> Addresses-Coverity: ("Resource leak")
>>> Fixes: c3a40789f6ba ("io_uring: allow empty slots for reg buffers")
>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>> ---
>>>  fs/io_uring.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 47c2f126f885..beeb477e4f6a 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -8417,8 +8417,10 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>>>  		ret = io_buffer_validate(&iov);
>>>  		if (ret)
>>>  			break;
>>> -		if (!iov.iov_base && tag)
>>> +		if (!iov.iov_base && tag) {> +			kfree(data);
>>>  			return -EINVAL;
>>> +		}
>>
>> Buggy indeed, should have been:
>>
>> ret = -EINVAL;
>> break;
> Ah, thanks.
> 
>>
>> Colin, can you resend with the change?
> 
> Will do in a moment or so.

Hmm, there are actually two of them, look for

"iov.iov_base && tag"

>>
>>>  
>>>  		ret = io_sqe_buffer_register(ctx, &iov, &ctx->user_bufs[i],
>>>  					     &last_hpage);
>>>
>>
> 

-- 
Pavel Begunkov
