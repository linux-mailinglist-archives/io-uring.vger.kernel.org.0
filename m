Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6855E16F282
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 23:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgBYWSW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 17:18:22 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44642 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgBYWSW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 17:18:22 -0500
Received: by mail-pg1-f194.google.com with SMTP id a14so228761pgb.11
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 14:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jgjqJ7iUFgdhsz/7LB462gTvnTvtcTLymIiwchKeLjE=;
        b=WonY1I/sh+4E5joQGXJndVLcoQEg9dT4AEvFaWTbrOvHYmFcvtwHVRhQwXTaeQp9WO
         izTxBHjZYZx2dV9BTqys4nwjcHKLIypKbrR8iBsvOVF9fvs9j0Rn/Dyn4Sc2EU0mBbSp
         57Cn/zrIAekgrykZS/7nvxsuoySqpqxmS9ReQadMCXySDy70imhK+l9ZaoZ2QqdiJ9j3
         2Kv5wYoyFFDc9TmUC8AnqpNUNNXSWC1KuVu88NV9OqOAOuElilnq5pcpkDDPMIMNbkXn
         z3Z9wAmPA7iKHfyMoZOor7qv/KbKGKCqUZNHijfMYTx14eBf7btg4lwM7uRPFraUAB5o
         6cLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jgjqJ7iUFgdhsz/7LB462gTvnTvtcTLymIiwchKeLjE=;
        b=kc3ZZNA3TmGZ/s8OcwUvYLqWpQTH3v9r5w3mPufCR61/hA/sS7PJVYBP0SAGMwwT5g
         LiyX0seyhTrJk/5V7uL53SOrdqXLxy7csHSRVlB/Q/zrM1MueXQpO+nefdeGJSp9T6wZ
         Mo2ZUz2YmQNgdNFjNy91DjWgDjEPDzgfybpl9Pwkg6Nt5K04bG07H9E8yufFFPPkmVcr
         eEQ+rGF8AQHXVvUmq18ZgawH59XmYHc/TQkjUes3lKjFReyXaNjQAsbRWN455MsuddNd
         JYcnbF0C+utq9SSc/WjGEcNj+Kr5jUkLh7dp0eBSQLNBwccAQgNhRzlcqKHSbz9QmdcV
         zF3g==
X-Gm-Message-State: APjAAAXp0B5/2zD/n+5CEyHoIMN91DatAtpM1ffPlUAakhe3wYK4wyVu
        juvhlrIEFMZ72Xf6qBLFFialI8eycgCjkA==
X-Google-Smtp-Source: APXvYqyAjfIesLHtGdeuDKRxzhwPp1rJFC1iztmLgPmQm7l3EGGqBtgIh0MAbChkTkDqzwx2LGmqfw==
X-Received: by 2002:a63:1a21:: with SMTP id a33mr635007pga.421.1582669099521;
        Tue, 25 Feb 2020 14:18:19 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id u11sm118776pjn.2.2020.02.25.14.18.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 14:18:18 -0800 (PST)
Subject: Re: [PATCH] io_uring: pick up link work on submit reference drop
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <1c5f074e-22dd-095a-6be7-730c81eeb1b1@kernel.dk>
 <82423419-1c14-418e-8085-2d8b902b0a2d@gmail.com>
 <71add82f-9d25-b879-5fe5-8e2a4eb26877@kernel.dk>
 <32c9037d-d515-9065-3315-e023edaa4578@kernel.dk>
Message-ID: <dfc1fc59-46c5-d985-80f7-3d637cd40b13@kernel.dk>
Date:   Tue, 25 Feb 2020 15:18:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <32c9037d-d515-9065-3315-e023edaa4578@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/25/20 2:41 PM, Jens Axboe wrote:
> On 2/25/20 2:25 PM, Jens Axboe wrote:
>> On 2/25/20 2:22 PM, Pavel Begunkov wrote:
>>> On 25/02/2020 23:27, Jens Axboe wrote:
>>>> If work completes inline, then we should pick up a dependent link item
>>>> in __io_queue_sqe() as well. If we don't do so, we're forced to go async
>>>> with that item, which is suboptimal.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>
>>>> ---
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index ffd9bfa84d86..160cf1b0f478 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -4531,8 +4531,15 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
>>>>  		} while (1);
>>>>  	}
>>>>  
>>>> -	/* drop submission reference */
>>>> -	io_put_req(req);
>>>> +	/*
>>>> +	 * Drop submission reference. In case the handler already dropped the
>>>> +	 * completion reference, then it didn't pick up any potential link
>>>> +	 * work. If 'nxt' isn't set, try and do that here.
>>>> +	 */
>>>> +	if (nxt)
>>>
>>> It can't even get here, because of the submission ref, isn't it? would the
>>> following do?
>>>
>>> -	io_put_req(req);
>>> +	io_put_req_find_next(req, &nxt);
>>
>> I don't think it can, let me make that change. And test.
> 
> Because I'm a clown, the patch applied with offset. I meant to modify
> the __io_queue_sqe() path, as mentioned in the commit message. Here's
> the right one, dropped the check
> 
> The other one would not be correct without the nxt check, as the work
> queue handler could pass it back. For the __io_queue_sqe() path, we
> should do a 5.7 cleanup of the 'nxt passing, though. I don't want to
> do that for 5.6.

So this found something funky, we really should only be picking up
the next request if we're dropping the final reference to the
request. And io_put_req_find_next() also says that in the comment,
but it always looks it up. That doesn't seem safe at all, I think
this is what it should be:


commit eff5fe974f332c1b86c9bb274627e88b4ecbbc85
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Feb 25 13:25:41 2020 -0700

    io_uring: pick up link work on submit reference drop
    
    If work completes inline, then we should pick up a dependent link item
    in __io_queue_sqe() as well. If we don't do so, we're forced to go async
    with that item, which is suboptimal.
    
    This also fixes an issue with io_put_req_find_next(), which always looks
    up the next work item. That should only be done if we're dropping the
    last reference to the request, to prevent multiple lookups of the same
    work item.
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ffd9bfa84d86..f79ca494bb56 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1483,10 +1483,10 @@ static void io_free_req(struct io_kiocb *req)
 __attribute__((nonnull))
 static void io_put_req_find_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
 {
-	io_req_find_next(req, nxtptr);
-
-	if (refcount_dec_and_test(&req->refs))
+	if (refcount_dec_and_test(&req->refs)) {
+		io_req_find_next(req, nxtptr);
 		__io_free_req(req);
+	}
 }
 
 static void io_put_req(struct io_kiocb *req)
@@ -4749,7 +4749,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 err:
 	/* drop submission reference */
-	io_put_req(req);
+	io_put_req_find_next(req, &nxt);
 
 	if (linked_timeout) {
 		if (!ret)

-- 
Jens Axboe

