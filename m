Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91FC1E2356
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 15:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbgEZNuy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 09:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729400AbgEZNuw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 09:50:52 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7ACC03E96E
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 06:50:51 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q9so1365271pjm.2
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 06:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TsJ+ya7DLaAC9EC4liADTO0tprvxGjdA+7opmVl0FVA=;
        b=g1/7QOjKa61RC7wBeOn5GBPb3KCi20eVgYcsv13bLH50Z/106HIIkaLsu8OSxDSIFg
         ucdGdTmC48KzoU4rK60EfjAk9scExcaZ13dVFvi3tSLDoUcxKj/R/NFPqtNpe7MfrRXU
         dw3ZyFTS7C4diWZUxMwp9bdibC+YFYfzhQPe0AE89vq49rIBUReh4cFWufHq8nko2pco
         MTFYlOIl/V3YBqvvgIqihIeVIK2gPJx4HV3jVvEEkdeJvSqdMMBhrCeZukUvWBQCBePu
         DWM01ieH5nVgZ2sYu/3BF4pfwo2Ml59RwghLR5qHs2m6V1axIso60dJSSbANhObcrRa8
         V7Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TsJ+ya7DLaAC9EC4liADTO0tprvxGjdA+7opmVl0FVA=;
        b=oL5p9xmfj4NTT2uuFiJ98SV11jzdLDDJ5HiIdubwHbTDZAwOg71CXGRzYIiIDx6fAb
         OlAjEKkLSqC1O0ktL4zhOJl34lFXYH51wJatCo3S3NO0B/llbbSh63/86kCoicXAtLTd
         plKdfluBzsYl/dn/h4vMj7vYiwNDLLvUNusHbdMGHxMKm1r0knyGxY+9nB92+EB4BlA6
         rOB4uBHUv+eRGcG+ok6L6CYhZ2b5Ok8MdHuGh0ix1ss3IUWjfDiMkWAhjpw6RAXbkPz1
         kP3eR/nfJoWvJthWvjK3c2vkuEzRQcGrkRpYUupgFad51HhlVO4647SW1Xuc9o2FHVhO
         zqrg==
X-Gm-Message-State: AOAM530Tzc5Iv64ijqXVnSDk1EC+RpkPHQ+8hQbUjk5swbtUuKDwca0c
        M8DqGfkJRmE88j+WNSvkPPT6hg==
X-Google-Smtp-Source: ABdhPJwb1HZnXvh9qc7bN00VRiWnUaq6RK+j3csWhmS5gI/dE6tv/8uzHsGkFpESYgQ0S8vnjlSm/A==
X-Received: by 2002:a17:902:502:: with SMTP id 2mr1199090plf.134.1590501051121;
        Tue, 26 May 2020 06:50:51 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:a9e6:df54:e55e:4c47? ([2605:e000:100e:8c61:a9e6:df54:e55e:4c47])
        by smtp.gmail.com with ESMTPSA id i3sm15567936pfe.44.2020.05.26.06.50.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 06:50:50 -0700 (PDT)
Subject: Re: [PATCH 12/12] io_uring: support true async buffered reads, if
 file provides it
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
References: <20200523185755.8494-1-axboe@kernel.dk>
 <20200523185755.8494-13-axboe@kernel.dk>
 <8d429d6b-81ee-0a28-8533-2e1d4faa6b37@gmail.com>
 <717e474a-5168-8e1e-2e02-c1bdff007bd9@kernel.dk>
 <a8212987-bd06-5c67-73d7-e77a654df4ac@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <69516a01-a209-8a7e-6b9a-7d5b6fef4e96@kernel.dk>
Date:   Tue, 26 May 2020 07:50:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <a8212987-bd06-5c67-73d7-e77a654df4ac@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/26/20 1:44 AM, Pavel Begunkov wrote:
> On 25/05/2020 22:59, Jens Axboe wrote:
>> On 5/25/20 1:29 AM, Pavel Begunkov wrote:
>>> On 23/05/2020 21:57, Jens Axboe wrote:
>>>> If the file is flagged with FMODE_BUF_RASYNC, then we don't have to punt
>>>> the buffered read to an io-wq worker. Instead we can rely on page
>>>> unlocking callbacks to support retry based async IO. This is a lot more
>>>> efficient than doing async thread offload.
>>>>
>>>> The retry is done similarly to how we handle poll based retry. From
>>>> the unlock callback, we simply queue the retry to a task_work based
>>>> handler.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>  fs/io_uring.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 99 insertions(+)
>>>>
>>> ...
>>>> +
>>>> +	init_task_work(&rw->task_work, io_async_buf_retry);
>>>> +	/* submit ref gets dropped, acquire a new one */
>>>> +	refcount_inc(&req->refs);
>>>> +	tsk = req->task;
>>>> +	ret = task_work_add(tsk, &rw->task_work, true);
>>>> +	if (unlikely(ret)) {
>>>> +		/* queue just for cancelation */
>>>> +		init_task_work(&rw->task_work, io_async_buf_cancel);
>>>> +		tsk = io_wq_get_task(req->ctx->io_wq);
>>>
>>> IIRC, task will be put somewhere around io_free_req(). Then shouldn't here be
>>> some juggling with reassigning req->task with task_{get,put}()?
>>
>> Not sure I follow? Yes, we'll put this task again when the request
>> is freed, but not sure what you mean with juggling?
> 
> I meant something like:
> 
> ...
> /* queue just for cancelation */
> init_task_work(&rw->task_work, io_async_buf_cancel);
> + put_task_struct(req->task);
> + req->task = get_task_struct(io_wq_task);
> 
> 
> but, thinking twice, if I got the whole idea right, it should be ok as
> is -- io-wq won't go away before the request anyway, and leaving
> req->task pinned down for a bit is not a problem.

OK good, then I thin kwe agree it's fine.

>>>> +		task_work_add(tsk, &rw->task_work, true);
>>>> +	}
>>>> +	wake_up_process(tsk);
>>>> +	return 1;
>>>> +}
>>> ...
>>>>  static int io_read(struct io_kiocb *req, bool force_nonblock)
>>>>  {
>>>>  	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
>>>> @@ -2601,6 +2696,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
>>>>  	if (!ret) {
>>>>  		ssize_t ret2;
>>>>  
>>>> +retry:
>>>>  		if (req->file->f_op->read_iter)
>>>>  			ret2 = call_read_iter(req->file, kiocb, &iter);
>>>>  		else
>>>> @@ -2619,6 +2715,9 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
>>>>  			if (!(req->flags & REQ_F_NOWAIT) &&
>>>>  			    !file_can_poll(req->file))
>>>>  				req->flags |= REQ_F_MUST_PUNT;
>>>> +			if (io_rw_should_retry(req))
>>>
>>> It looks like a state machine with IOCB_WAITQ and gotos. Wouldn't it be cleaner
>>> to call call_read_iter()/loop_rw_iter() here directly instead of "goto retry" ?
>>
>> We could, probably making that part a separate helper then. How about the
>> below incremental?
> 
> IMHO, it was easy to get lost with such implicit state switching.
> Looks better now! See a small comment below.

Agree, that is cleaner.

>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index a5a4d9602915..669dccd81207 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2677,6 +2677,13 @@ static bool io_rw_should_retry(struct io_kiocb *req)
>>  	return false;
>>  }
>>  
>> +static int __io_read(struct io_kiocb *req, struct iov_iter *iter)
>> +{
>> +	if (req->file->f_op->read_iter)
>> +		return call_read_iter(req->file, &req->rw.kiocb, iter);
>> +	return loop_rw_iter(READ, req->file, &req->rw.kiocb, iter);
>> +}
>> +
>>  static int io_read(struct io_kiocb *req, bool force_nonblock)
>>  {
>>  	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
>> @@ -2710,11 +2717,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
>>  	if (!ret) {
>>  		ssize_t ret2;
>>  
>> -retry:
>> -		if (req->file->f_op->read_iter)
>> -			ret2 = call_read_iter(req->file, kiocb, &iter);
>> -		else
>> -			ret2 = loop_rw_iter(READ, req->file, kiocb, &iter);
>> +		ret2 = __io_read(req, &iter);
>>  
>>  		/* Catch -EAGAIN return for forced non-blocking submission */
>>  		if (!force_nonblock || ret2 != -EAGAIN) {
>> @@ -2729,8 +2732,11 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
>>  			if (!(req->flags & REQ_F_NOWAIT) &&
>>  			    !file_can_poll(req->file))
>>  				req->flags |= REQ_F_MUST_PUNT;
>> -			if (io_rw_should_retry(req))
>> -				goto retry;
>> +			if (io_rw_should_retry(req)) {
>> +				ret2 = __io_read(req, &iter);
>> +				if (ret2 != -EAGAIN)
>> +					goto out_free;
> 
> "goto out_free" returns ret=0, so someone should add a cqe
> 
> if (ret2 != -EAGAIN) {
> 	kiocb_done(kiocb, ret2);
> 	goto free_out;
> }

Fixed up in the current one.

-- 
Jens Axboe

