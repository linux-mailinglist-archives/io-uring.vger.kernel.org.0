Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E41215A01
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2020 16:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729286AbgGFOuU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jul 2020 10:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729285AbgGFOuU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jul 2020 10:50:20 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD6AC061755
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 07:50:20 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id f6so24054350ioj.5
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2020 07:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=VRasAoYujXKStbZYAcOMAw9UG93dWJG9VpTwhqcq8ZY=;
        b=j1HTR/fP6qeFanxDniDFs4RaY3HYfTyP59ETwcIvKMXgH1nSuP9UJziI1IC4hsk/jE
         5bw0NmSVBm9Jv+zMAWmpKhfYYACndRxqPidB7BTbTAyBbyy1U2odMpV4/ACNrmNAVvaf
         ouDpHY7+AwOwsy8JOzXjNoGk3fppmAOkRlRiEjaiLsCxOxkoyA20Y1QDtR0rHVd1uamr
         fRfZgLEb3dE7aY1ZAAhLOIx+/kzvjp3zU7HlbAPh0SXzguEU6MKFzBnW1jnuamfzVI/V
         GU3pXK710f8vONoKmTqbcGIen2HqoSWhxHzgJ3oLkBROYNPdl4WuQi/2vKaiwA6tRBal
         k5yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VRasAoYujXKStbZYAcOMAw9UG93dWJG9VpTwhqcq8ZY=;
        b=N3lNQaq30PxC4rBMu6kCTmjjs7SN0Po31LAHe8pJC7UgjVSFEn/0+KpegMcKKtke9D
         yeuzOCbJOvN7JtAyuy1qXXoDz3cTEQhQOd3AbIa1I0awuzo1k9PwSUaBFp/x78c+tgT8
         VvH2+I1VNW7U0hxhBt7GI8GaDi0qAPY/Np+9TrQCTJauhi0LeXGJiB874VBPI74jSoga
         /LOy4SW8gXzOXU0pcQw4Efr2ddq3cqYGcQoGyF71NC7AZQ8O6OJVLPZuQL0p8WsmflAi
         RcAmr0WAN6KgNBVc4qvf7UPn+b/TE+pMh/HBtK39on2NBA5hWYOWX9rteQwYIye+x37J
         iFcA==
X-Gm-Message-State: AOAM532vZ1q/i+rOTIekNfcv4v3LY5fZgmUqaD88dm4aKIvrvn/fIfBd
        N9n+uNvQ6AGDixVX0HD0PexWTAt8+Sf7Dw==
X-Google-Smtp-Source: ABdhPJxNMVmY8xg3jIzvdv5LbMG5Mpshwn7PxeYnQ+XwW6IkLUjHQgHbi6iPGUk3HR3Sf80/+1OpNA==
X-Received: by 2002:a5d:9ed0:: with SMTP id a16mr25661726ioe.176.1594047019432;
        Mon, 06 Jul 2020 07:50:19 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u9sm10828754iom.14.2020.07.06.07.50.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2020 07:50:18 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: briefly loose locks while reaping events
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1594044830.git.asml.silence@gmail.com>
 <da2c8de6c06d9ec301b08d023a962fdb85781796.1594044830.git.asml.silence@gmail.com>
 <e8cfe972-0b28-8c5d-122d-0a724b3424fa@kernel.dk>
 <6a21bbfd-d1b2-09f0-af08-b964b810a449@gmail.com>
 <323d7cb4-c88f-9d58-f337-1da61ea54280@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <4a7a8530-5e66-c3cf-6ec1-1b1951611f94@kernel.dk>
Date:   Mon, 6 Jul 2020 08:50:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <323d7cb4-c88f-9d58-f337-1da61ea54280@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/6/20 8:45 AM, Pavel Begunkov wrote:
> 
> 
> On 06/07/2020 17:42, Pavel Begunkov wrote:
>> On 06/07/2020 17:31, Jens Axboe wrote:
>>> On 7/6/20 8:14 AM, Pavel Begunkov wrote:
>>>> It's not nice to hold @uring_lock for too long io_iopoll_reap_events().
>>>> For instance, the lock is needed to publish requests to @poll_list, and
>>>> that locks out tasks doing that for no good reason. Loose it
>>>> occasionally.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>  fs/io_uring.c | 3 +++
>>>>  1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index 020944a193d0..568e25bcadd6 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -2059,11 +2059,14 @@ static void io_iopoll_reap_events(struct io_ring_ctx *ctx)
>>>>  
>>>>  		io_iopoll_getevents(ctx, &nr_events, 1);
>>>>  
>>>> +		/* task_work takes the lock to publish a req to @poll_list */
>>>> +		mutex_unlock(&ctx->uring_lock);
>>>>  		/*
>>>>  		 * Ensure we allow local-to-the-cpu processing to take place,
>>>>  		 * in this case we need to ensure that we reap all events.
>>>>  		 */
>>>>  		cond_resched();
>>>> +		mutex_lock(&ctx->uring_lock);
>>>>  	}
>>>>  	mutex_unlock(&ctx->uring_lock);
>>>>  }
>>>
>>> This would be much better written as:
>>>
>>> if (need_resched()) {
>>> 	mutex_unlock(&ctx->uring_lock);
>>> 	cond_resched();
>>> 	mutex_lock(&ctx->uring_lock);
>>> }
>>>
>>> to avoid shuffling the lock when not needed to. Every cycle counts for
>>> polled IO.
>>
>> It happens only when io_uring is being killed, can't imagine any sane app
>> trying to catch CQEs after doing that. I'll resend
> 
> Also, io_iopoll_getevents() already does need_resched(). Hmm, do you wan't
> me to resend?

I missed this was the "reap on dead" path. But yes, please resend.

-- 
Jens Axboe

