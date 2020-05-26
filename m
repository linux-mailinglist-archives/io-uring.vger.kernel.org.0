Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871F31E1C73
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 09:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730713AbgEZHpX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 03:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbgEZHpW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 03:45:22 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB2FC061A0E;
        Tue, 26 May 2020 00:45:22 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id e2so22685016eje.13;
        Tue, 26 May 2020 00:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vDaaH5YD8SOmhn/fSd1uU44U5ZXnS6Yq8bfw6RSLqOM=;
        b=q69nsgQhasIfsuxrBPxmvt2K1zsLdoR5eFw9trjhssZ+qfTk0mh3cs5MkKFiZm58bR
         KTzu+0mFHMFx4Rxtgdb7s1yK33G3Uy0He2ZtyhReg6oaeUOccKoIDR/PjG2r2Yk3QTKC
         qkhflhbf8p8Q/ixx8KKAY+TgeS5h5CfVPle5/Xsl7cmImSjr0vUVpq+IOCnhtKDbqaDE
         oVylL00ShmOdghhEYFoIbgqZY5/4mSKrLOT5mgsSC0GIx0wexIzM7U6TSrSkaQ+yumKv
         51oLoxyn7DQAUmnp707/GMJJPGb6KnTFjEE5chzjPSMbgOGgop39CXOW/HumqJAoLXXw
         1V3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=vDaaH5YD8SOmhn/fSd1uU44U5ZXnS6Yq8bfw6RSLqOM=;
        b=sMqjd6Jfz6mMLOZXL+4Ii7WZCCAaRHdaiqcJ5CRUFmPgYfgTMkb8xzq0bIoeRlNP1T
         14GOYuQxOvKFSHnToXooj7PwSvuDGZafMiyCzYiIs1QZKtAViVowJQgL7DfSijfiZp28
         OHt9shw7NXEhGG0uYnon1X0juA5xv75Oa4/mu2M3cQn1S4dHcVFkHkfufhvKEbsIEbqX
         +ooKl38mOfhvI45nKTH3EOEmAxOs2kpT841M2ySwi3wFFh1MzO95hezy9+Wxg3ehaBxN
         xUS/YVgi9Ikl1SbLZLuVkD0QC1p3HUAIxul4lWuyqZjhnVHSyBZTlvYxXQXdvnXK+ko7
         e67Q==
X-Gm-Message-State: AOAM533RYk4Yc/prbHWcCMYhtfVPjB+o8GRfBbjdn5Rckl9p3qY4N54y
        gzcutNDsOxMVARv9fAKTkr2+v+Qr
X-Google-Smtp-Source: ABdhPJyxBQvVu1HqKfACm4GEdjeg5EWrxcEZwwQ7ecr3IgejneL78XBpCcdO0Bkz5oNWCArH986GyA==
X-Received: by 2002:a17:906:2dc8:: with SMTP id h8mr48498eji.108.1590479120869;
        Tue, 26 May 2020 00:45:20 -0700 (PDT)
Received: from [192.168.43.172] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id w12sm17450222eds.4.2020.05.26.00.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 00:45:15 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
References: <20200523185755.8494-1-axboe@kernel.dk>
 <20200523185755.8494-13-axboe@kernel.dk>
 <8d429d6b-81ee-0a28-8533-2e1d4faa6b37@gmail.com>
 <717e474a-5168-8e1e-2e02-c1bdff007bd9@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 12/12] io_uring: support true async buffered reads, if
 file provides it
Message-ID: <a8212987-bd06-5c67-73d7-e77a654df4ac@gmail.com>
Date:   Tue, 26 May 2020 10:44:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <717e474a-5168-8e1e-2e02-c1bdff007bd9@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 25/05/2020 22:59, Jens Axboe wrote:
> On 5/25/20 1:29 AM, Pavel Begunkov wrote:
>> On 23/05/2020 21:57, Jens Axboe wrote:
>>> If the file is flagged with FMODE_BUF_RASYNC, then we don't have to punt
>>> the buffered read to an io-wq worker. Instead we can rely on page
>>> unlocking callbacks to support retry based async IO. This is a lot more
>>> efficient than doing async thread offload.
>>>
>>> The retry is done similarly to how we handle poll based retry. From
>>> the unlock callback, we simply queue the retry to a task_work based
>>> handler.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>  fs/io_uring.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 99 insertions(+)
>>>
>> ...
>>> +
>>> +	init_task_work(&rw->task_work, io_async_buf_retry);
>>> +	/* submit ref gets dropped, acquire a new one */
>>> +	refcount_inc(&req->refs);
>>> +	tsk = req->task;
>>> +	ret = task_work_add(tsk, &rw->task_work, true);
>>> +	if (unlikely(ret)) {
>>> +		/* queue just for cancelation */
>>> +		init_task_work(&rw->task_work, io_async_buf_cancel);
>>> +		tsk = io_wq_get_task(req->ctx->io_wq);
>>
>> IIRC, task will be put somewhere around io_free_req(). Then shouldn't here be
>> some juggling with reassigning req->task with task_{get,put}()?
> 
> Not sure I follow? Yes, we'll put this task again when the request
> is freed, but not sure what you mean with juggling?

I meant something like:

...
/* queue just for cancelation */
init_task_work(&rw->task_work, io_async_buf_cancel);
+ put_task_struct(req->task);
+ req->task = get_task_struct(io_wq_task);


but, thinking twice, if I got the whole idea right, it should be ok as is --
io-wq won't go away before the request anyway, and leaving req->task pinned down
for a bit is not a problem.

>>> +		task_work_add(tsk, &rw->task_work, true);
>>> +	}
>>> +	wake_up_process(tsk);
>>> +	return 1;
>>> +}
>> ...
>>>  static int io_read(struct io_kiocb *req, bool force_nonblock)
>>>  {
>>>  	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
>>> @@ -2601,6 +2696,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
>>>  	if (!ret) {
>>>  		ssize_t ret2;
>>>  
>>> +retry:
>>>  		if (req->file->f_op->read_iter)
>>>  			ret2 = call_read_iter(req->file, kiocb, &iter);
>>>  		else
>>> @@ -2619,6 +2715,9 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
>>>  			if (!(req->flags & REQ_F_NOWAIT) &&
>>>  			    !file_can_poll(req->file))
>>>  				req->flags |= REQ_F_MUST_PUNT;
>>> +			if (io_rw_should_retry(req))
>>
>> It looks like a state machine with IOCB_WAITQ and gotos. Wouldn't it be cleaner
>> to call call_read_iter()/loop_rw_iter() here directly instead of "goto retry" ?
> 
> We could, probably making that part a separate helper then. How about the
> below incremental?

IMHO, it was easy to get lost with such implicit state switching.
Looks better now! See a small comment below.

> 
>> BTW, can this async stuff return -EAGAIN ?
> 
> Probably? Prefer not to make any definitive calls on that being possible or
> not, as it's sure to disappoint. If it does and IOCB_WAITQ is already set,
> then we'll punt to a thread like before.

Sounds reasonable

> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index a5a4d9602915..669dccd81207 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2677,6 +2677,13 @@ static bool io_rw_should_retry(struct io_kiocb *req)
>  	return false;
>  }
>  
> +static int __io_read(struct io_kiocb *req, struct iov_iter *iter)
> +{
> +	if (req->file->f_op->read_iter)
> +		return call_read_iter(req->file, &req->rw.kiocb, iter);
> +	return loop_rw_iter(READ, req->file, &req->rw.kiocb, iter);
> +}
> +
>  static int io_read(struct io_kiocb *req, bool force_nonblock)
>  {
>  	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
> @@ -2710,11 +2717,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
>  	if (!ret) {
>  		ssize_t ret2;
>  
> -retry:
> -		if (req->file->f_op->read_iter)
> -			ret2 = call_read_iter(req->file, kiocb, &iter);
> -		else
> -			ret2 = loop_rw_iter(READ, req->file, kiocb, &iter);
> +		ret2 = __io_read(req, &iter);
>  
>  		/* Catch -EAGAIN return for forced non-blocking submission */
>  		if (!force_nonblock || ret2 != -EAGAIN) {
> @@ -2729,8 +2732,11 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
>  			if (!(req->flags & REQ_F_NOWAIT) &&
>  			    !file_can_poll(req->file))
>  				req->flags |= REQ_F_MUST_PUNT;
> -			if (io_rw_should_retry(req))
> -				goto retry;
> +			if (io_rw_should_retry(req)) {
> +				ret2 = __io_read(req, &iter);
> +				if (ret2 != -EAGAIN)
> +					goto out_free;

"goto out_free" returns ret=0, so someone should add a cqe

if (ret2 != -EAGAIN) {
	kiocb_done(kiocb, ret2);
	goto free_out;
}


> +			}
>  			kiocb->ki_flags &= ~IOCB_WAITQ;
>  			return -EAGAIN;
>  		}
> 

-- 
Pavel Begunkov
