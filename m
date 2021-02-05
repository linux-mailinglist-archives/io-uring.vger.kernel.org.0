Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15691311430
	for <lists+io-uring@lfdr.de>; Fri,  5 Feb 2021 23:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhBEWBZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Feb 2021 17:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbhBEO5n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Feb 2021 09:57:43 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD12C06178B
        for <io-uring@vger.kernel.org>; Fri,  5 Feb 2021 08:25:16 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id e1so6352734ilu.0
        for <io-uring@vger.kernel.org>; Fri, 05 Feb 2021 08:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mFkrczzU90D8CHDmfKDunabJBrNNdE+35qHQjQ9oaGk=;
        b=BXW0C4MPo4SQFxwCf+PPgJeOxKMM5tjN/kngoi+15tsiK+Iipzg7HyOzihp7KYWLlM
         3B9oMdPM8ggSIXjaiaqQYysa56ri3A799ZO5HcuyK0qM+BEM5/M7Afoi8fcT42m8Cd0u
         oE5+MwFVWeQPASy8CkMaxJ9qot7gtVaA58cGnKd20+wCT1cCSw94f1KxG2Au/Kff9JyA
         USMWfPCaqelts0Zoh4gyeUZRc3KZvmedbBcP4kkIZXtMQETDWq/BfioFkqbEcrf61W+c
         2nPnxkLr5Co/B1jXbgLzD1pmVsGFCUi/8q8KaHLzjKsKzTCTa8wc162D60wR1WWQ4qiz
         Md+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mFkrczzU90D8CHDmfKDunabJBrNNdE+35qHQjQ9oaGk=;
        b=c+EQa/JBASvebztncC2fmZik/S/kK7UimysrGXZUH3u63JY045DPYMLO1d2lT7YCit
         uzBoAjKE5p2t8HkCXRUA7i7Frv8ARV0auqwt5T7huBJ2RImsvADBwdvVDhvn5ll6ujKZ
         4OkbfAvhEUfhTr7TT3QZfSjAIpzOBKx3q+gcWceuh7tQuRdnQgohwrsqeOxxmOM2+JmH
         4uTYAIkbrQ8g5AL7KeukSvPZ7+Na6L+aiIgli5xoOAclmEextgZgx29HZ3OR/fPXuS4s
         d9V59DeZYOiPrEmxMI+gLVrsXPkAg4xU9+3VqUHLKhyQOO68nzu5zEHgZMAb51bz4jzC
         jFJA==
X-Gm-Message-State: AOAM533z4uDhX/qQbrSj1eTT/le+J5uqgn/RguU3vkLw3QVAXpc3pWO7
        1hRYEU62uEjHtQCc3cymHCfSZhZoEJz3k1iA
X-Google-Smtp-Source: ABdhPJyuIj+sxQeoECcieIK5ss/mdDXAVrZteFO5JJ1xLDgQwCoWupan9kP8Lh0q03TKsH1zAp+XdQ==
X-Received: by 2002:a92:c90b:: with SMTP id t11mr4238691ilp.275.1612536140728;
        Fri, 05 Feb 2021 06:42:20 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r6sm4155323ilt.56.2021.02.05.06.42.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 06:42:19 -0800 (PST)
Subject: Re: bug with fastpoll accept and sqpoll + IOSQE_FIXED_FILE
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwhCXpTCRjZ5tc_TPADTK3EFeWHD369wr8WV4nH8+M_thg@mail.gmail.com>
 <49743b61-3777-f152-e1d5-128a53803bcd@gmail.com>
 <c41e9907-d530-5d2a-7e1f-cf262d86568c@gmail.com>
 <CAM1kxwj6Cdqi0hJFNtGFvK=g=KoNRPMmLVoxtahFKZsjOkcTKQ@mail.gmail.com>
 <CAM1kxwg7wkB7Sj8CDi9RkssM5DwFXEFWeUcakUkpKtKVCOUSJQ@mail.gmail.com>
 <4b44f4e1-c039-a6b6-711f-22952ce1abfb@kernel.dk>
 <CAM1kxwgPW5Up-YqQWdh_cG4jvc5RWsD4UYNWN-jRRbWq5ide5g@mail.gmail.com>
 <06ceae30-7221-80e9-13e3-148cdf5e3c9f@kernel.dk>
 <8d75bf78-7361-0649-e5a3-1288fea1197f@gmail.com>
 <bb75dec2-2700-58ed-065e-a533994d3df7@gmail.com>
 <725fa06a-da7e-9918-49b4-7489672ff0b4@kernel.dk>
 <5c3d084f-88e4-3e86-3560-95d90bb9ffcd@gmail.com>
 <39bc0ff3-db02-8fc7-da5c-b2f5f0fc715e@gmail.com>
 <ab870cb5-513d-420e-6438-b918f9f6c453@kernel.dk>
 <c9550dcf-ce53-c214-8c4b-6165ad6605a9@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8349a07b-6975-dc55-dc0a-a4228f913af3@kernel.dk>
Date:   Fri, 5 Feb 2021 07:42:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c9550dcf-ce53-c214-8c4b-6165ad6605a9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/5/21 5:46 AM, Pavel Begunkov wrote:
> On 04/02/2021 16:50, Jens Axboe wrote:
>> On 2/3/21 4:49 AM, Pavel Begunkov wrote:
>>> On 02/02/2021 20:56, Pavel Begunkov wrote:
>>>> On 02/02/2021 20:48, Jens Axboe wrote:
>>>>> On 2/2/21 1:34 PM, Pavel Begunkov wrote:
>>>>>> On 02/02/2021 17:41, Pavel Begunkov wrote:
>>>>>>> On 02/02/2021 17:24, Jens Axboe wrote:
>>>>>>>> On 2/2/21 10:10 AM, Victor Stewart wrote:
>>>>>>>>>> Can you send the updated test app?
>>>>>>>>>
>>>>>>>>> https://gist.github.com/victorstewart/98814b65ed702c33480487c05b40eb56
>>>>>>>>>
>>>>>>>>> same link i just updated the same gist
>>>>>>>>
>>>>>>>> And how are you running it?
>>>>>>>
>>>>>>> with SQPOLL    with    FIXED FLAG -> FAILURE: failed with error = ???
>>>>>>> 	-> io_uring_wait_cqe_timeout() strangely returns -1, (-EPERM??)
>>>>>>
>>>>>> Ok, _io_uring_get_cqe() is just screwed twice
>>>>>>
>>>>>> TL;DR
>>>>>> we enter into it with submit=0, do an iteration, which decrements it,
>>>>>> then a second iteration passes submit=-1, which is returned back by
>>>>>> the kernel as a result and propagated back from liburing...
>>>>>
>>>>> Yep, that's what I came up with too. We really just need a clear way
>>>>> of knowing when to break out, and when to keep going. Eg if we've
>>>>> done a loop and don't end up calling the system call, then there's
>>>>> no point in continuing.
>>>>
>>>> We can bodge something up (and forget about it), and do much cleaner
>>>> for IORING_FEAT_EXT_ARG, because we don't have LIBURING_UDATA_TIMEOUT
>>>> reqs for it and so can remove peek and so on.
>>>
>>> This version looks reasonably simple, and even passes tests and all
>>> issues found by Victor's test. Didn't test it yet, but should behave
>>> similarly in regard of internal timeouts (pre IORING_FEAT_EXT_ARG).
>>>
>>> static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
>>> 			     struct get_data *data)
>>> {
>>> 	struct io_uring_cqe *cqe = NULL;
>>> 	int ret = 0, err;
>>>
>>> 	do {
>>> 		unsigned flags = 0;
>>> 		unsigned nr_available;
>>> 		bool enter = false;
>>>
>>> 		err = __io_uring_peek_cqe(ring, &cqe, &nr_available);
>>> 		if (err)
>>> 			break;
>>>
>>> 		/* IOPOLL won't proceed when there're not reaped CQEs */
>>> 		if (cqe && (ring->flags & IORING_SETUP_IOPOLL))
>>> 			data->wait_nr = 0;
>>>
>>> 		if (data->wait_nr > nr_available || cq_ring_needs_flush(ring)) {
>>> 			flags = IORING_ENTER_GETEVENTS | data->get_flags;
>>> 			enter = true;
>>> 		}
>>> 		if (data->submit) {
>>> 			sq_ring_needs_enter(ring, &flags);
>>> 			enter = true;
>>> 		}
>>> 		if (!enter)
>>> 			break;
>>>
>>> 		ret = __sys_io_uring_enter2(ring->ring_fd, data->submit,
>>> 					    data->wait_nr, flags, data->arg,
>>> 					    data->sz);
>>> 		if (ret < 0) {
>>> 			err = -errno;
>>> 			break;
>>> 		}
>>> 		data->submit -= ret;
>>> 	} while (1);
>>>
>>> 	*cqe_ptr = cqe;
>>> 	return err;
>>> }
>>
>> So here's my take on this - any rewrite of _io_uring_get_cqe() is going
>> to end up adding special cases, that's unfortunately just the nature of
>> the game. And since we're going to be doing a new liburing release very
>> shortly, this isn't a great time to add a rewrite of it. It'll certainly
>> introduce more bugs than it solves, and hence regressions, no matter how
>> careful we are.
>>
>> Hence my suggestion is to just patch this in a trivial kind of fashion,
>> even if it doesn't really make the function any prettier. But it'll be
>> safer for a release, and then we can rework the function after.
>>
>> With that in mind, here's my suggestion. The premise is if we go through
>> the loop and don't do io_uring_enter(), then there's no point in
>> continuing. That's the trivial fix.
> 
> Your idea but imho cleaner below.
> +1 comment inline

Shouldn't be hard, it was just a quick hack :-)

>> diff --git a/src/queue.c b/src/queue.c
>> index 94f791e..4161aa7 100644
>> --- a/src/queue.c
>> +++ b/src/queue.c
>> @@ -89,12 +89,13 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
>>  {
>>  	struct io_uring_cqe *cqe = NULL;
>>  	const int to_wait = data->wait_nr;
>> -	int ret = 0, err;
>> +	int err;
>>  
>>  	do {
>>  		bool cq_overflow_flush = false;
>>  		unsigned flags = 0;
>>  		unsigned nr_available;
>> +		int ret = -2;
>>  
>>  		err = __io_uring_peek_cqe(ring, &cqe, &nr_available);
>>  		if (err)
>> @@ -117,7 +118,9 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
>>  			ret = __sys_io_uring_enter2(ring->ring_fd, data->submit,
>>  					data->wait_nr, flags, data->arg,
>>  					data->sz);
>> -		if (ret < 0) {
>> +		if (ret == -2) {
>> +			break;
> 
> peek/wait_cqe expect that cqe_ptr is filled on return=0. Looks we need
> to return an error or hack up those functions.

Right good point, we'd need -EAGAIN.

>> +		} else if (ret < 0) {
>>  			err = -errno;
>>  		} else if (ret == (int)data->submit) {
>>  			data->submit = 0;
>>
> 
> 
> diff --git a/src/queue.c b/src/queue.c
> index 94f791e..7d6f31d 100644
> --- a/src/queue.c
> +++ b/src/queue.c
> @@ -112,11 +112,15 @@ static int _io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_pt
>  			flags = IORING_ENTER_GETEVENTS | data->get_flags;
>  		if (data->submit)
>  			sq_ring_needs_enter(ring, &flags);
> -		if (data->wait_nr > nr_available || data->submit ||
> -		    cq_overflow_flush)
> -			ret = __sys_io_uring_enter2(ring->ring_fd, data->submit,
> -					data->wait_nr, flags, data->arg,
> -					data->sz);
> +
> +		if (data->wait_nr <= nr_available && !data->submit &&
> +		    !cq_overflow_flush) {
> +			err = ?;

which I guess is the actual error missing from here?

> +			break;
> +		}
> +		ret = __sys_io_uring_enter2(ring->ring_fd, data->submit,
> +				data->wait_nr, flags, data->arg,
> +				data->sz);
>  		if (ret < 0) {
>  			err = -errno;
>  		} else if (ret == (int)data->submit) {
> 


-- 
Jens Axboe

