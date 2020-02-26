Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797F416FB3F
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2020 10:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgBZJqs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Feb 2020 04:46:48 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44294 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbgBZJqr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Feb 2020 04:46:47 -0500
Received: by mail-lj1-f196.google.com with SMTP id q8so2278283ljj.11
        for <io-uring@vger.kernel.org>; Wed, 26 Feb 2020 01:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ExudxBhJW9ChvSIjRPaWtohGN1cvK+PSMwFH3dDIEBI=;
        b=ZauW9vzJ836t5AGB9mxK1R52d/zDq6n5eTEG7sVyhVNjs74S/mh5+9bLapIkvRL9Bm
         lB74bp0GrTxBsD/bncvTWT6oAH6t4kU5dP+pEhbhZaNwrUieMS1v3xatwUg3I06wLIx9
         gO+BYEueC2OeMNf/4fyUKqsGgy1RfArTEtKKHxvudY1KYlplUBFa01hbzUuRWpliFVxI
         rtxaaqG9ZGejnaVf2LrHzq+lSdSSloIfbk/Aj9N5ZvJZyPP5IfrIRdn7EOnura7E3/Gt
         GEnhKATRE/kq0JY+Xff7t9Ln/CqITsHJXKqX39rzKxx1DyZxO5nXptum1640t7gDx6Kz
         oQOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ExudxBhJW9ChvSIjRPaWtohGN1cvK+PSMwFH3dDIEBI=;
        b=uRK9IHC9P75/uMRdo9jKeNdQhVmX1bl3uZksF4V9lTUp9Ve8rHdrovdwcjXqgXTDIB
         vrCTTYVGuLT0Y4mIgiFd2+299Fty24v3XVaqQXv4oWnNb76xoD+jEoQCzInuxvBQrLRX
         C2W13X8+ACiJlVBgIzoddovsAw+d9/foqqTu2FB6IkyabE0J85lGeiFG0IpoCH3odVw7
         K4DdBFaHmELgGqKvh+HTO0FqtWAPNkEP3kAuKmcfI+eZOzPnVVkglpeb3kyX8oGLXZB1
         kY/5l+W0sPYb/iLcDMY1K2O0aCgoiq7dHb5DKwBTPnwH4HvMY2WyxtAdVQprYuTzrTo2
         sqCA==
X-Gm-Message-State: APjAAAWK81cjiTDniUqMqU7ByaKCpMtxCVMv3Hhiv2FUdzuVof7/CZyw
        KhoBQn/eln5lBAb2VMGrDumQ4ZeYWz4=
X-Google-Smtp-Source: ADFU+vs0GDqbGPAAs8NpfL7gfcovjpS29IybivqIa2Glih2Q0m7VNQHbeJ9SIhSQ5uOdnXjwFg56mQ==
X-Received: by 2002:a2e:b017:: with SMTP id y23mr2445131ljk.229.1582710405695;
        Wed, 26 Feb 2020 01:46:45 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id j11sm604746lfb.58.2020.02.26.01.46.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 01:46:45 -0800 (PST)
Subject: Re: [PATCH] io_uring: pick up link work on submit reference drop
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <1c5f074e-22dd-095a-6be7-730c81eeb1b1@kernel.dk>
 <82423419-1c14-418e-8085-2d8b902b0a2d@gmail.com>
 <71add82f-9d25-b879-5fe5-8e2a4eb26877@kernel.dk>
 <32c9037d-d515-9065-3315-e023edaa4578@kernel.dk>
 <dfc1fc59-46c5-d985-80f7-3d637cd40b13@kernel.dk>
 <14cc6bff-565a-c41b-bb96-7b2edad163ce@gmail.com>
Message-ID: <ed8076db-fb97-7913-cf5d-a7d25b6b4c43@gmail.com>
Date:   Wed, 26 Feb 2020 12:46:44 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <14cc6bff-565a-c41b-bb96-7b2edad163ce@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/26/2020 11:33 AM, Pavel Begunkov wrote:
> On 26/02/2020 01:18, Jens Axboe wrote:
>> So this found something funky, we really should only be picking up
>> the next request if we're dropping the final reference to the
>> request. And io_put_req_find_next() also says that in the comment,
>> but it always looks it up. That doesn't seem safe at all, I think
>> this is what it should be:
> 
> It was weird indeed, it looks good. And now it's safe to do the same in
> io_wq_submit_work().
> 
> Interestingly, this means that passing @nxt into the handlers is useless, as
> they won't ever return !=NULL, isn't it? I'll prepare the cleanup.

... and it will return @nxt==NULL as well, as there is a ref hold by
io_{put/get}_work().

Let's have this patch as is, and I'll cook up something on top
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
>>
>> commit eff5fe974f332c1b86c9bb274627e88b4ecbbc85
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Tue Feb 25 13:25:41 2020 -0700
>>
>>     io_uring: pick up link work on submit reference drop
>>     
>>     If work completes inline, then we should pick up a dependent link item
>>     in __io_queue_sqe() as well. If we don't do so, we're forced to go async
>>     with that item, which is suboptimal.
>>     
>>     This also fixes an issue with io_put_req_find_next(), which always looks
>>     up the next work item. That should only be done if we're dropping the
>>     last reference to the request, to prevent multiple lookups of the same
>>     work item.
>>     
>>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index ffd9bfa84d86..f79ca494bb56 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1483,10 +1483,10 @@ static void io_free_req(struct io_kiocb *req)
>>  __attribute__((nonnull))
>>  static void io_put_req_find_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
>>  {
>> -	io_req_find_next(req, nxtptr);
>> -
>> -	if (refcount_dec_and_test(&req->refs))
>> +	if (refcount_dec_and_test(&req->refs)) {
>> +		io_req_find_next(req, nxtptr);
>>  		__io_free_req(req);
>> +	}
>>  }
>>  
>>  static void io_put_req(struct io_kiocb *req)
>> @@ -4749,7 +4749,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  
>>  err:
>>  	/* drop submission reference */
>> -	io_put_req(req);
>> +	io_put_req_find_next(req, &nxt);
>>  
>>  	if (linked_timeout) {
>>  		if (!ret)
>>
> 

-- 
Pavel Begunkov
