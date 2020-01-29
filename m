Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0780B14CB96
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 14:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgA2Nl2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 08:41:28 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:45367 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgA2Nl2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 08:41:28 -0500
Received: by mail-lf1-f65.google.com with SMTP id 203so11875579lfa.12;
        Wed, 29 Jan 2020 05:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l0u5WHmdUM6QOorSCuU0hXeCuOESdwfl8W0or7sC/p0=;
        b=ZzSj0KFUsblFkfZ8JM1YmuLQtJz39EMqJr/AwhnmBpeJVwCKJLWeA2KL8figj6KLM4
         5pl+cxLNpIjKM5fuTNsvcv5Z0DEiLjeLp9PrK27R6J+n8NzsYy3Axtvl8niVDHWG7vEh
         BRfiRXANFxQT7Efa6IOj/5wlTjUziYMA5K6fFqAtioFqNQReh+y/4bjENnJy5h2V6QP5
         8FjpWenUluP6NhV1yJcIZw1oxe0zBNtFgSEgscypBqDe8DumtVzqN+rZhWIr+3Gvjtto
         zXmC/CcVNVGulGpWNvaZS1lYRlENojUc+f5z5nBwyS/hUT8Q7VLs427feIceMCQ+kZW1
         d7aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l0u5WHmdUM6QOorSCuU0hXeCuOESdwfl8W0or7sC/p0=;
        b=rVbfbRnPY91+1U6ArwOKB7p3rSBvXjkRWBWwRGSujyHSDOz9Z0Uf1Tup4HAl+0aF8C
         eNG6QPJyEFrOgBlr46cde4mM9lUR2SemDVo21KlQ38FA1CAuD7FL3+9FPE3t73+qWJv0
         jqkCXQlXrsan0oPDEkZNuxZU1o86/z9tvq3qle9fXRmH35eG8Eem22ueYgfV6+b9BD83
         asnDOBajilwtLPatFkyNqWoeXLgM5DwwriJJQU6acwYO+m4Zn/9jsJ8+W09HtFOesQT1
         buM1PtElP4bkisnLQkLspU26cghQAQ/E2akd1h1BpSssNVsqLC9ZY36olwKtUvgUTSwI
         Fdzg==
X-Gm-Message-State: APjAAAXCym3nXc5MstUE5jKmNlPsK0ZR3B055VUyN2zBSIiN1fp//7GF
        jtPB5OHyV1NW6YWeTfI6pX5qlrpu+8k=
X-Google-Smtp-Source: APXvYqxKw+UDSzFPorj7gQLjp60qCAQLfwlLORGcNaod/wqAnoKknk0JoX4ZoTzkswj9Cu3BmvbE1Q==
X-Received: by 2002:ac2:47ec:: with SMTP id b12mr5653974lfp.162.1580305282902;
        Wed, 29 Jan 2020 05:41:22 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id a28sm975257ljn.75.2020.01.29.05.41.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 05:41:22 -0800 (PST)
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
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <9a419bc5-4445-318d-87aa-1474b49266dd@gmail.com>
Date:   Wed, 29 Jan 2020 16:41:18 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <821243e7-b470-ad7a-c1a5-535bee58e76d@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/2020 4:11 PM, Stefan Metzmacher wrote:
> Am 29.01.20 um 11:17 schrieb Pavel Begunkov:
>> On 29/01/2020 03:54, Jens Axboe wrote:
>>> On 1/28/20 5:24 PM, Jens Axboe wrote:
>>>> On 1/28/20 5:21 PM, Pavel Begunkov wrote:
>>>>> On 29/01/2020 03:20, Jens Axboe wrote:
>>>>>> On 1/28/20 5:10 PM, Pavel Begunkov wrote:
>>>>>>>>>> Checked out ("don't use static creds/mm assignments")
>>>>>>>>>>
>>>>>>>>>> 1. do we miscount cred refs? We grab one in get_current_cred() for each async
>>>>>>>>>> request, but if (worker->creds != work->creds) it will never be put.
>>>>>>>>>
>>>>>>>>> Yeah I think you're right, that needs a bit of fixing up.
>>>>>>>>
>>>>>>>
>>>>>>> Hmm, it seems it leaks it unconditionally, as it grabs in a ref in
>>>>>>> override_creds().
>>>>>>>
>>>>>>
>>>>>> We grab one there, and an extra one. Then we drop one of them inline,
>>>>>> and the other in __io_req_aux_free().
>>>>>>
>>>>> Yeah, with the last patch it should make it even
>>>>
>>>> OK good we agree on that. I should probably pull back that bit to the
>>>> original patch to avoid having a hole in there...
>>>
>>> Done
>>>
>>
>> ("io_uring/io-wq: don't use static creds/mm assignments") and ("io_uring:
>> support using a registered personality for commands") looks good now.
>>
>> Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> 
> I'm very happy with the design, thanks!
> That exactly what I had in mind:-)
> 
> It would also work with IORING_SETUP_SQPOLL, correct?
> 

Yep

> However I think there're a few things to improve/simplify.
> 

Since 5.6 is already semi-open, it'd be great to have an incremental
patch for that. I'll retoss things as usual, if nobody do it before.

>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.6/io_uring-vfs&id=a26d26412e1e1783473f9dc8f030c3af3d54b1a6
> 
> In fs/io_uring.c mmgrab() and get_current_cred() are used together in
> two places, why is put_cred() called in __io_req_aux_free while
> mmdrop() is called from io_put_work(). I think both should be called
> in io_put_work(), that makes the code much easier to understand.
> 
> My guess is that you choose __io_req_aux_free() for put_cred() because
> of the following patches, but I'll explain on the other commit
> why it's not needed.
> 
>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.6/io_uring-vfs&id=d9db233adf034bd7855ba06190525e10a05868be
> 
> A minor one would be starting with 1 instead of 0 and using
> idr_alloc_cyclic() in order to avoid immediate reuse of ids.
> That way we could include the id in the tracing message and
> 0 would mean the current creds were used.
> 
>> +static int io_remove_personalities(int id, void *p, void *data)
>> +{
>> +	struct io_ring_ctx *ctx = data;
>> +
>> +	idr_remove(&ctx->personality_idr, id);
> 
> Here we need something like:
> put_creds((const struct cred *)p);

Good catch

> 
>> +	return 0;
>> +}
> 
> 
> The io_uring_register() calles would look like this, correct?
> 
>  id = io_uring_register(ring_fd, IORING_REGISTER_PERSONALITY, NULL, 0);
>  io_uring_register(ring_fd, IORING_UNREGISTER_PERSONALITY, NULL, id);
> 
>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.6/io_uring-vfs&id=eec9e69e0ad9ad364e1b6a5dfc52ad576afee235
>> +
>> +	if (sqe_flags & IOSQE_PERSONALITY) {
>> +		int id = READ_ONCE(sqe->personality);
>> +
>> +		req->work.creds = idr_find(&ctx->personality_idr, id);
>> +		if (unlikely(!req->work.creds)) {
>> +			ret = -EINVAL;
>> +			goto err_req;
>> +		}
>> +		get_cred(req->work.creds);> +		old_creds = override_creds(req->work.creds);
>> +	}
>> +
> 
> Here we could use a helper variable
> const struct cred *personality_creds;
> and leave req->work.creds as NULL.
> It means we can avoid the explicit get_cred() call
> and can skip the following hunk too:
> 
>> @@ -3977,7 +3977,8 @@ static int io_req_defer_prep(struct io_kiocb *req,
>>  		mmgrab(current->mm);
>>  		req->work.mm = current->mm;
>>  	}
>> -	req->work.creds = get_current_cred();
>> +	if (!req->work.creds)
>> +		req->work.creds = get_current_cred();
>>  
>>  	switch (req->opcode) {
>>  	case IORING_OP_NOP:
> 
> The override_creds(personality_creds) has changed current->cred
> and get_current_cred() will just pick it up as in the default case.
> 
> This would make the patch much simpler and allows put_cred() to be
> in io_put_work() instead of __io_req_aux_free() as explained above.
> 

It's one extra get_current_cred(). I'd prefer to find another way to
clean this up.

-- 
Pavel Begunkov
