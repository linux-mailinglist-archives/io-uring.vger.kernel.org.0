Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35DCB176FA9
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 07:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbgCCGyz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 01:54:55 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43298 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbgCCGyz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Mar 2020 01:54:55 -0500
Received: by mail-wr1-f67.google.com with SMTP id h9so1927034wrr.10;
        Mon, 02 Mar 2020 22:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HJA53stw5MpDLj7gN7o5jWXu3DD9XUs77kWYzhWWkVs=;
        b=BvtjiOsVWH3QiQVuLBakV0xzl9OyalGGKZ+oPpzLJnr58fa3Qx6axBfc5+KcjaUhLk
         bfaM72XDMr6s8hTQz9kj4kSXoFjVw+2q0knCglb1g9C91FEIU3pBdDd8PCAGhzzi1kzn
         XxbkY/37YtEpQurW7N8eP79J+c+Mol1g1pQ6rwt+kE13pEmMLRKpVlZ0u0Igxuf7l2Th
         M/FddnxjglqvmH2MCAWTAj/EWavRFeq0BcbRU+XzlweY1or1vowqwlY7cES4cbaOciIh
         11W795LGJ3uMt2JeR178vmeSFIBSbAL+I5phLmOz5NfbjO3pVadTZnM3+8O4iXes/BQJ
         6awg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HJA53stw5MpDLj7gN7o5jWXu3DD9XUs77kWYzhWWkVs=;
        b=q1gefgb1Z43RmAF+TE5IDwsCXTOlXgv79zySrz0cUofA7dE4VrYC4qS/jT6iqAQw6A
         iiVNkKRH9D7oA7Du9Cw0YYzRtX1A1ow9CH+FuQtCmBDMRpCUc9R4EZiklvwP/3ngWijC
         rtEB9Q2JcVS0GjLfXtRnMlp/ylB5V44hBzSHxiXk/55o+mTImQueHGdO7ht3af/6Pj/u
         c2qr5QRajjrTQ5J1ZfrA++FZfKC2EEnzvgilOdkE8FP6HNjQk0z1cFG7TVsOSrO2blBH
         RnL5xnsyGQ/mM8hDSlg7EkiJ/+uEFtFhv2Zewztn573rI3GjNEEdq+O02fSJ/d4GPLEm
         83ww==
X-Gm-Message-State: ANhLgQ0dkdd3ikUUyqFbYPk9uhk+nJcWE9asaSPIEh1+GNr3kkmrwAld
        +u8pshPAMKOyPkZHO+rOoXuJ82yv
X-Google-Smtp-Source: ADFU+vu3jeFtBmGfpvyqNKIgxLHcOzw9QvXbQOyVHOZTCIfGZgWlDz4Are5+p7ZDrWO0ZSsDwTWzZg==
X-Received: by 2002:adf:e383:: with SMTP id e3mr3945237wrm.10.1583218491532;
        Mon, 02 Mar 2020 22:54:51 -0800 (PST)
Received: from [192.168.43.27] ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id v7sm25173005wrm.49.2020.03.02.22.54.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 22:54:50 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1583181841.git.asml.silence@gmail.com>
 <444aef98f849d947d7f10e88f30244fa0bc82360.1583181841.git.asml.silence@gmail.com>
 <3ab75953-ee39-2c4e-99e2-f8c18ceb6a8d@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2 4/4] io_uring: get next req on subm ref drop
Message-ID: <52b282f5-50f3-2ee6-a055-6ef0c2c39e93@gmail.com>
Date:   Tue, 3 Mar 2020 09:54:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3ab75953-ee39-2c4e-99e2-f8c18ceb6a8d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 03/03/2020 07:26, Jens Axboe wrote:
> On 3/2/20 1:45 PM, Pavel Begunkov wrote:
>> Get next request when dropping the submission reference. However, if
>> there is an asynchronous counterpart (i.e. read/write, timeout, etc),
>> that would be dangerous to do, so ignore them using new
>> REQ_F_DONT_STEAL_NEXT flag.
> 
> Hmm, not so sure I like this one. It's not quite clear to me where we
> need REQ_F_DONT_STEAL_NEXT. If we have an async component, then we set
> REQ_F_DONT_STEAL_NEXT. So this is generally the case where our
> io_put_req() for submit is not the last drop. And for the other case,
> the put is generally in the caller anyway. So I don't really see what
> this extra flag buys us?

Because io_put_work() holds a reference, no async handler can achive req->refs
== 0, so it won't return next upon dropping the submission ref (i.e. by
put_find_nxt()). And I want to have next before io_put_work(), to, instead of as
currently:

run_work(work);
assign_cur_work(NULL); // spinlock + unlock worker->lock
new_work = put_work(work);
assign_cur_work(new_work); // the second time

do:

new_work = run_work(work);
assign_cur_work(new_work); // need new_work here
put_work(work);


The other way:

io_wq_submit_work() // for all async handlers
{
	...
	// Drop submission reference.
	// One extra ref will be put in io_put_work() right
	// after return, and it'll be done in the same thread
	if (atomic_dec_and_get(req) == 1)
		steal_next(req);
}

Maybe cleaner, but looks fragile as well. Would you prefer it?

> Few more comments below.
> 
>> +static void io_put_req_async_submission(struct io_kiocb *req,
>> +					struct io_wq_work **workptr)
>> +{
>> +	static struct io_kiocb *nxt;
>> +
>> +	nxt = io_put_req_submission(req);
>> +	if (nxt)
>> +		io_wq_assign_next(workptr, nxt);
>> +}
> 
> This really should be called io_put_req_async_completion() since it's
> called on completion. The naming is confusing.

Ok

>> @@ -2581,14 +2598,11 @@ static void __io_fsync(struct io_kiocb *req)
>>  static void io_fsync_finish(struct io_wq_work **workptr)
>>  {
>>  	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
>> -	struct io_kiocb *nxt = NULL;
>>  
>>  	if (io_req_cancelled(req))
>>  		return;
>>  	__io_fsync(req);
>> -	io_put_req(req); /* drop submission reference */
>> -	if (nxt)
>> -		io_wq_assign_next(workptr, nxt);
>> +	io_put_req_async_submission(req, workptr);
>>  }
>>  
>>  static int io_fsync(struct io_kiocb *req, bool force_nonblock)
>> @@ -2617,14 +2631,11 @@ static void __io_fallocate(struct io_kiocb *req)
>>  static void io_fallocate_finish(struct io_wq_work **workptr)
>>  {
>>  	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
>> -	struct io_kiocb *nxt = NULL;
>>  
>>  	if (io_req_cancelled(req))
>>  		return;
>>  	__io_fallocate(req);
>> -	io_put_req(req); /* drop submission reference */
>> -	if (nxt)
>> -		io_wq_assign_next(workptr, nxt);
>> +	io_put_req_async_submission(req, workptr);
>>  }
> 
> All of these cleanups are nice (except the naming, as mentioned).
> 
>> @@ -3943,7 +3947,10 @@ static int io_poll_add(struct io_kiocb *req)
>>  	if (mask) {
>>  		io_cqring_ev_posted(ctx);
>>  		io_put_req(req);
>> +	} else {
>> +		req->flags |= REQ_F_DONT_STEAL_NEXT;
>>  	}
>> +
>>  	return ipt.error;
>>  }
> 
> Is this racy? I guess it doesn't matter since we're still holding the
> completion reference.

It's done by the same thread, that uses it. There could be a race if the async
counterpart is going to change req->flags, but we tolerate false negative (i.e.
put_req() will handle it).

-- 
Pavel Begunkov
