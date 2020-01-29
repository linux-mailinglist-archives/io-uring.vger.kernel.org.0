Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE1D114CC55
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 15:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgA2OXb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 09:23:31 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44178 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgA2OXb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 09:23:31 -0500
Received: by mail-lj1-f196.google.com with SMTP id q8so18607642ljj.11;
        Wed, 29 Jan 2020 06:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EeYfVyn/x+fUftoQL45T4vejSo0o7ls7nmzvnOvveI4=;
        b=tOeIFt3SdQSJHAIR14hC7ycfLfabdFVLmGJeR780D6g84QzXmk5/lGkwFZnTXe3ncY
         HHob2jCyJoY6ts1QC1ZTpuPko03tz4+NnQMaQJ0EKKPvwVwnFgaYH0hzk4xpMC1gIGOf
         tSpTjBYg7zwppGSTB16weMC3AfOJhc5plidqmXbB4W5Gu9I6Q3NCH94miOOMPcr12Qdi
         imdqUG2buk5NwsYytoQlI8YwAE+XjYZkFm+dVFjk4bUNTYaGv8oOT2Bvm5J7zD0MRr3o
         l4ReUN8xKYCEA8IZjU3bQYxLwdH/ABNL8KoCeMU1QtpSYvAypo+BvKglCimB0wfLx7Dp
         Px5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EeYfVyn/x+fUftoQL45T4vejSo0o7ls7nmzvnOvveI4=;
        b=DDONOXKnLAHxzivJ6aQC7/1zrDGDuH3gWgT1nx5aaJY+9vYaPW4ANxrGLOVXnAp6bS
         5UX7l6iQ8isjZerAg/QpFccNnAG/nFBVkKGrwL/bPoW1K/LCtLbh7adxnRni9QKT+n9V
         TaD/nf31+FdsmUcDx8BmuDapuZ/iQN1oFhRDmJQHT+eUD0jjAyY63CxbK79msOIlT6Wp
         R6t+dkTy80l1ufEFYzCb0L61jPE6bp0k3okOWQ2PDk+c9LAl5L9P8qnt5oLEaEsN6kGm
         vLk+dVANdkdW/kPj29R12YfZfaVuCGWtHOJan3p67AF2bMB5SxTU2isbFpXXC58ULWEN
         3oDg==
X-Gm-Message-State: APjAAAX7B4Ovz/hx++GSqd/CVozGgMgMNy6UqEMy4CsoM21lkgyBxQ0s
        LnQywV+59rws22pieUUcs91LsNT+ev0=
X-Google-Smtp-Source: APXvYqzoiVCzBtnHQ9WE00OiSQjE8JUrl9SVDkYHBsOb7Vy16rP4/GQilVkgDw3WGiwlUjXjN58FrQ==
X-Received: by 2002:a2e:8145:: with SMTP id t5mr16877121ljg.144.1580307807258;
        Wed, 29 Jan 2020 06:23:27 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id n206sm1143166lfd.50.2020.01.29.06.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 06:23:26 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
To:     Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
 <6c401e23-de7c-1fc1-4122-33d53fcf9700@kernel.dk>
 <35eebae7-76dd-52ee-58b2-4f9e85caee40@kernel.dk>
 <d3f9c1a4-8b28-3cfe-de88-503837a143bc@gmail.com>
 <c9e58b5c-f66e-8406-16d5-fd6df1a27e77@kernel.dk>
 <6e5ab6bf-6ff1-14df-1988-a80a7c6c9294@gmail.com>
 <2019e952-df2a-6b57-3571-73c525c5ba1a@kernel.dk>
 <0df4904f-780b-5d5f-8700-41df47a1b470@kernel.dk>
 <5406612e-299d-9d6e-96fc-c962eb93887f@gmail.com>
 <821243e7-b470-ad7a-c1a5-535bee58e76d@samba.org>
 <9a419bc5-4445-318d-87aa-1474b49266dd@gmail.com>
 <40d52623-5f9c-d804-cdeb-b7da6b13cb4f@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <3e1289de-8d8e-49cf-cc9f-fb7bc67f35d5@gmail.com>
Date:   Wed, 29 Jan 2020 17:23:25 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <40d52623-5f9c-d804-cdeb-b7da6b13cb4f@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/2020 4:56 PM, Stefan Metzmacher wrote:
>>> However I think there're a few things to improve/simplify.
>> Since 5.6 is already semi-open, it'd be great to have an incremental
>> patch for that. I'll retoss things as usual, if nobody do it before.
> 
> I'll wait for comments from Jens first:-)
> I guess we'll have things changed in his branch, when I wake up
> tomorrow. Otherwise I can also create patches and submit them.

Sure, I won't get there any time soon.

> 
> But I currently don't have an environment where I can do runtime tests
> with it.
> 
>>>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.6/io_uring-vfs&id=a26d26412e1e1783473f9dc8f030c3af3d54b1a6
>>>
>>> In fs/io_uring.c mmgrab() and get_current_cred() are used together in
>>> two places, why is put_cred() called in __io_req_aux_free while
>>> mmdrop() is called from io_put_work(). I think both should be called
>>> in io_put_work(), that makes the code much easier to understand.
>>>
>>> My guess is that you choose __io_req_aux_free() for put_cred() because
>>> of the following patches, but I'll explain on the other commit
>>> why it's not needed.
>>>
>>>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.6/io_uring-vfs&id=d9db233adf034bd7855ba06190525e10a05868be
>>>
>>> A minor one would be starting with 1 instead of 0 and using
>>> idr_alloc_cyclic() in order to avoid immediate reuse of ids.
>>> That way we could include the id in the tracing message and
>>> 0 would mean the current creds were used.
>>>
>>>> +static int io_remove_personalities(int id, void *p, void *data)
>>>> +{
>>>> +	struct io_ring_ctx *ctx = data;
>>>> +
>>>> +	idr_remove(&ctx->personality_idr, id);
>>>
>>> Here we need something like:
>>> put_creds((const struct cred *)p);
>>
>> Good catch
>>
>>>
>>>> +	return 0;
>>>> +}
>>>
>>>
>>> The io_uring_register() calles would look like this, correct?
>>>
>>>  id = io_uring_register(ring_fd, IORING_REGISTER_PERSONALITY, NULL, 0);
>>>  io_uring_register(ring_fd, IORING_UNREGISTER_PERSONALITY, NULL, id);
>>>
>>>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.6/io_uring-vfs&id=eec9e69e0ad9ad364e1b6a5dfc52ad576afee235
>>>> +
>>>> +	if (sqe_flags & IOSQE_PERSONALITY) {
>>>> +		int id = READ_ONCE(sqe->personality);
>>>> +
>>>> +		req->work.creds = idr_find(&ctx->personality_idr, id);
>>>> +		if (unlikely(!req->work.creds)) {
>>>> +			ret = -EINVAL;
>>>> +			goto err_req;
>>>> +		}
>>>> +		get_cred(req->work.creds);> +		old_creds = override_creds(req->work.creds);
>>>> +	}
>>>> +
>>>
>>> Here we could use a helper variable
>>> const struct cred *personality_creds;
>>> and leave req->work.creds as NULL.
>>> It means we can avoid the explicit get_cred() call
>>> and can skip the following hunk too:
>>>
>>>> @@ -3977,7 +3977,8 @@ static int io_req_defer_prep(struct io_kiocb *req,
>>>>  		mmgrab(current->mm);
>>>>  		req->work.mm = current->mm;
>>>>  	}
>>>> -	req->work.creds = get_current_cred();
>>>> +	if (!req->work.creds)
>>>> +		req->work.creds = get_current_cred();
>>>>  
>>>>  	switch (req->opcode) {
>>>>  	case IORING_OP_NOP:
>>>
>>> The override_creds(personality_creds) has changed current->cred
>>> and get_current_cred() will just pick it up as in the default case.
>>>
>>> This would make the patch much simpler and allows put_cred() to be
>>> in io_put_work() instead of __io_req_aux_free() as explained above.
>>>
>>
>> It's one extra get_current_cred(). I'd prefer to find another way to
>> clean this up.
> 
> As far as I can see it avoids a get_cred() in the IOSQE_PERSONALITY case
> and the if (!req->work.creds) for both cases.

Great, that you turned attention to that! override_creds() is already
grabbing a ref, so it shouldn't call get_cred() there.
So, that's a bug.

It could be I'm wrong with the statement above, need to recheck all this
code to be sure.

BTW, io_req_defer_prep() may be called twice for a req, so you will
reassign it without putting a ref. It's safer to leave NULL checks. At
least, until I've done reworking and fixing preparation paths.

> 
> What do you mean exactly with one extra get_current_cred()?
> Is that any worse than calling get_cred() and having an if check?
> 
> It also seems to avoid req->work.creds from being filled at all
> for the non-blocking case.
> 
> metze
> 

-- 
Pavel Begunkov
