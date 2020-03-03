Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB6F177477
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2020 11:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgCCKqL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Mar 2020 05:46:11 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44347 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728645AbgCCKqL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Mar 2020 05:46:11 -0500
Received: by mail-lj1-f195.google.com with SMTP id a10so2911084ljp.11;
        Tue, 03 Mar 2020 02:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=SbkIYLaPhhKtjFKgNZ2hx+6kz6HW2Pe3O+upvQAowvo=;
        b=ndlxdiN1wcbyOTqsSGN3SsavM1lRHbnDS1VW+VFx/V5kWY1MgYYZuc+2AyKpMAmgIz
         nA/DqQBokmB4/Ks6eLwIt0u+RWdq2AUihfhRV5F+wIyJ1IGwjmXDWubvflRryXCrQa4Y
         hTSTVqyOSz8NHRcoMO9FWm+x0daPEw7xhS8YMN1rDxI/6F9ZKOx2HgNvk/qVZd463yB3
         S4ccHUvWgFZ5C6sqqI/lQmAGqCGPlTnVljkwo887Xk65f7odNN2+kY6h3+mlpt9xtWdR
         p48n0r+NOaZN24K9/wfUuqTW+a0b68n7MIbqpc0fQO2ZPW5jFGq6W3cbGmrRLm/wggTF
         mgxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SbkIYLaPhhKtjFKgNZ2hx+6kz6HW2Pe3O+upvQAowvo=;
        b=TvrbbBYHFBiGVu26bUh75ZK0sSl/YMb3IA8/09heLmJqjZKcYTODnASzvF1uNdCzAk
         NPqMMe5LLkZJ6uUBirmHXYwdAaaRTZztKpHt3/AcgXvVIiCDy+V8YVUatKLMaunPHCaE
         nhg3HEhCtbNfiLkVULoYaCk5aiKZeWEgNc09VjSxHPzACTOuDkWekDk/lhhJpCE5Wo7z
         gnpdjRiM7XvMJrQ3zXeBn4KIbDQn65sd2TC/bQUoq0dsSA7x/DeFuBwIvFbshWVwTT4W
         u5IHyCaSdow49luwYgWPC/68jXA75JDTip2Mrx6LgRMS3lzr9WCMGZScDaPGRCm9d8TK
         FTCQ==
X-Gm-Message-State: ANhLgQ1NbpELegTifQywkN0Dl1OccrqL5M4FPNpxO9ONV8kr39h1vIA7
        g4vNbitAnhC2sZaqoAl/WSywOfk0xVY=
X-Google-Smtp-Source: ADFU+vsaEV75ZUdi48+sujsnA3/yGQfl7RNWuM6UT3rrS8JMnmdfqTovTbOoyrTgbyMeBPp+KeLbjw==
X-Received: by 2002:a2e:7d0b:: with SMTP id y11mr2049353ljc.95.1583232368464;
        Tue, 03 Mar 2020 02:46:08 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id e8sm14017696lfc.18.2020.03.03.02.46.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 02:46:07 -0800 (PST)
Subject: Re: [PATCH v2 4/4] io_uring: get next req on subm ref drop
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1583181841.git.asml.silence@gmail.com>
 <444aef98f849d947d7f10e88f30244fa0bc82360.1583181841.git.asml.silence@gmail.com>
 <3ab75953-ee39-2c4e-99e2-f8c18ceb6a8d@kernel.dk>
 <52b282f5-50f3-2ee6-a055-6ef0c2c39e93@gmail.com>
Message-ID: <9ead66eb-cb5d-2dab-1a78-02466958674a@gmail.com>
Date:   Tue, 3 Mar 2020 13:46:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <52b282f5-50f3-2ee6-a055-6ef0c2c39e93@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/3/2020 9:54 AM, Pavel Begunkov wrote:
> On 03/03/2020 07:26, Jens Axboe wrote:
>> On 3/2/20 1:45 PM, Pavel Begunkov wrote:
>>> Get next request when dropping the submission reference. However, if
>>> there is an asynchronous counterpart (i.e. read/write, timeout, etc),
>>> that would be dangerous to do, so ignore them using new
>>> REQ_F_DONT_STEAL_NEXT flag.
>>
>> Hmm, not so sure I like this one. It's not quite clear to me where we
>> need REQ_F_DONT_STEAL_NEXT. If we have an async component, then we set
>> REQ_F_DONT_STEAL_NEXT. So this is generally the case where our
>> io_put_req() for submit is not the last drop. And for the other case,
>> the put is generally in the caller anyway. So I don't really see what
>> this extra flag buys us?
> 
> Because io_put_work() holds a reference, no async handler can achive req->refs
> == 0, so it won't return next upon dropping the submission ref (i.e. by
> put_find_nxt()). And I want to have next before io_put_work(), to, instead of as
> currently:
> 
> run_work(work);
> assign_cur_work(NULL); // spinlock + unlock worker->lock
> new_work = put_work(work);
> assign_cur_work(new_work); // the second time
> 
> do:
> 
> new_work = run_work(work);
> assign_cur_work(new_work); // need new_work here
> put_work(work);
> 
> 
> The other way:
> 
> io_wq_submit_work() // for all async handlers
> {
> 	...
> 	// Drop submission reference.
> 	// One extra ref will be put in io_put_work() right
> 	// after return, and it'll be done in the same thread
> 	if (atomic_dec_and_get(req) == 1)
> 		steal_next(req);
> }
> 
> Maybe cleaner, but looks fragile as well. Would you prefer it?

Any chance you've measured your next-work fix? I wonder how much does it
hurt performance, and whether we need a terse patch for 5.6.


>> Few more comments below.
>>
>>> +static void io_put_req_async_submission(struct io_kiocb *req,
>>> +					struct io_wq_work **workptr)
>>> +{
>>> +	static struct io_kiocb *nxt;
>>> +
>>> +	nxt = io_put_req_submission(req);
>>> +	if (nxt)
>>> +		io_wq_assign_next(workptr, nxt);
>>> +}
>>
>> This really should be called io_put_req_async_completion() since it's
>> called on completion. The naming is confusing.
> 
> Ok
> 
>>> @@ -2581,14 +2598,11 @@ static void __io_fsync(struct io_kiocb *req)
>>>  static void io_fsync_finish(struct io_wq_work **workptr)
>>>  {
>>>  	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
>>> -	struct io_kiocb *nxt = NULL;
>>>  
>>>  	if (io_req_cancelled(req))
>>>  		return;
>>>  	__io_fsync(req);
>>> -	io_put_req(req); /* drop submission reference */
>>> -	if (nxt)
>>> -		io_wq_assign_next(workptr, nxt);
>>> +	io_put_req_async_submission(req, workptr);
>>>  }
>>>  
>>>  static int io_fsync(struct io_kiocb *req, bool force_nonblock)
>>> @@ -2617,14 +2631,11 @@ static void __io_fallocate(struct io_kiocb *req)
>>>  static void io_fallocate_finish(struct io_wq_work **workptr)
>>>  {
>>>  	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
>>> -	struct io_kiocb *nxt = NULL;
>>>  
>>>  	if (io_req_cancelled(req))
>>>  		return;
>>>  	__io_fallocate(req);
>>> -	io_put_req(req); /* drop submission reference */
>>> -	if (nxt)
>>> -		io_wq_assign_next(workptr, nxt);
>>> +	io_put_req_async_submission(req, workptr);
>>>  }
>>
>> All of these cleanups are nice (except the naming, as mentioned).
>>
>>> @@ -3943,7 +3947,10 @@ static int io_poll_add(struct io_kiocb *req)
>>>  	if (mask) {
>>>  		io_cqring_ev_posted(ctx);
>>>  		io_put_req(req);
>>> +	} else {
>>> +		req->flags |= REQ_F_DONT_STEAL_NEXT;
>>>  	}
>>> +
>>>  	return ipt.error;
>>>  }
>>
>> Is this racy? I guess it doesn't matter since we're still holding the
>> completion reference.
> 
> It's done by the same thread, that uses it. There could be a race if the async
> counterpart is going to change req->flags, but we tolerate false negative (i.e.
> put_req() will handle it).
> 

-- 
Pavel Begunkov
