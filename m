Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490E53B0C6F
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 20:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhFVSKY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 14:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbhFVSKR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 14:10:17 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A373C061D73;
        Tue, 22 Jun 2021 11:02:15 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id m14so8206680edp.9;
        Tue, 22 Jun 2021 11:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qBI1JkDBHmE5U6gDX1UQMWanis3g+dXmcFngb016voY=;
        b=VrP/79qKyI1WcSDq3xBYfBlD8p1DVwzkezRJheMSMVGmGv9frGy0GfcK00e37zws65
         VxVOR6Iobsm5qKO84Ddegfr/XcE9JxS8RdAjFJ3+OKqPtqqy0EH9sjZRucNzRhwzq818
         s+4nAtFixTmV8BeBbfoJmtXb/gq5MjPC1fc1KUYPXZenmgzfcHNkRhBxaDIA6OdZYChg
         E6fsBE/82UP2H3pUFQzZuo2NSVGievn3uX6pyW9F8/gOSpCGArUOXOs9kJ4mCSrgPi2s
         Fiw787nEdUbxJDSi3xCTBRymLYgsaW3yP2vFaVzPIJ6hZqRY4sPfiFDUJ+Nei77FdW/o
         2KFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qBI1JkDBHmE5U6gDX1UQMWanis3g+dXmcFngb016voY=;
        b=YFuUmiGhIXDpas5FFEcGEq0iMUAQUQmM2Yz6v5F7IxWcbDbgWSqYbsMifbqEpxvMay
         mcsfXyEveMrO5lnzZtdVIykvYvtWOCjN+CQHjejCZRQqvI63Rr3UGLIF7z5OY07rZduR
         s+5kMX8w8aVzyzF7JWTuZ04N8yaHbyk6RsLjwNBiQir9RPDdy4PX1741w0WkgNWMB3nN
         bCyQoxmheLAlSEmqDFmkhsRe/9uXRMQjQH83rTeixa3jqsJLsnooSbKl0Pdxk5gZHMUN
         WJTaibG425bFM/mG83C+XPhygqr3Picbo4s9ZEUwHV1Mmsho8WAWlkaegkFmgEJ4ffIv
         DIDw==
X-Gm-Message-State: AOAM532xJYyNGqK8xiK0buncJSXYdCkd52DVyrxeOBh7Z3MH3b79hJA1
        ZGql5CcM28vvR33qNOHd2BP2vk/aEb+YcHfT
X-Google-Smtp-Source: ABdhPJxkjM9/PfEOaXDUG/U8iVWS8Ax0RkfwGKxHJyDN0b2LV/FkN3t5qQZtTGfEkowOz7n7jgeGHQ==
X-Received: by 2002:a05:6402:49:: with SMTP id f9mr6776435edu.178.1624384933767;
        Tue, 22 Jun 2021 11:02:13 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c093:600::2:9d6e])
        by smtp.gmail.com with ESMTPSA id ar14sm4521104ejc.108.2021.06.22.11.02.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 11:02:13 -0700 (PDT)
Subject: Re: [PATCH v4] io_uring: reduce latency by reissueing the operation
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <9e8441419bb1b8f3c3fcc607b2713efecdef2136.1624364038.git.olivier@trillion01.com>
 <678deb93-c4a5-5a14-9687-9e44f0f00b5a@gmail.com>
Message-ID: <7c47078a-9e2d-badf-a47d-1ca78e1a3253@gmail.com>
Date:   Tue, 22 Jun 2021 19:01:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <678deb93-c4a5-5a14-9687-9e44f0f00b5a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/21 6:54 PM, Pavel Begunkov wrote:
> On 6/22/21 1:17 PM, Olivier Langlois wrote:
>> It is quite frequent that when an operation fails and returns EAGAIN,
>> the data becomes available between that failure and the call to
>> vfs_poll() done by io_arm_poll_handler().
>>
>> Detecting the situation and reissuing the operation is much faster
>> than going ahead and push the operation to the io-wq.
>>
>> Performance improvement testing has been performed with:
>> Single thread, 1 TCP connection receiving a 5 Mbps stream, no sqpoll.
>>
>> 4 measurements have been taken:
>> 1. The time it takes to process a read request when data is already available
>> 2. The time it takes to process by calling twice io_issue_sqe() after vfs_poll() indicated that data was available
>> 3. The time it takes to execute io_queue_async_work()
>> 4. The time it takes to complete a read request asynchronously
>>
>> 2.25% of all the read operations did use the new path.
>>
>> ready data (baseline)
>> avg	3657.94182918628
>> min	580
>> max	20098
>> stddev	1213.15975908162
>>
>> reissue	completion
>> average	7882.67567567568
>> min	2316
>> max	28811
>> stddev	1982.79172973284
>>
>> insert io-wq time
>> average	8983.82276995305
>> min	3324
>> max	87816
>> stddev	2551.60056552038
>>
>> async time completion
>> average	24670.4758861127
>> min	10758
>> max	102612
>> stddev	3483.92416873804
>>
>> Conclusion:
>> On average reissuing the sqe with the patch code is 1.1uSec faster and
>> in the worse case scenario 59uSec faster than placing the request on
>> io-wq
>>
>> On average completion time by reissuing the sqe with the patch code is
>> 16.79uSec faster and in the worse case scenario 73.8uSec faster than
>> async completion.
>>
>> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
>> ---
>>  fs/io_uring.c | 31 ++++++++++++++++++++++---------
>>  1 file changed, 22 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index fc8637f591a6..5efa67c2f974 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
> 
> [...]
> 
>>  static bool __io_poll_remove_one(struct io_kiocb *req,
>> @@ -6437,6 +6445,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
>>  	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
>>  	int ret;
>>  
>> +issue_sqe:
>>  	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
>>  
>>  	/*
>> @@ -6456,12 +6465,16 @@ static void __io_queue_sqe(struct io_kiocb *req)
>>  			io_put_req(req);
>>  		}
>>  	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
>> -		if (!io_arm_poll_handler(req)) {
>> +		switch (io_arm_poll_handler(req)) {
>> +		case IO_APOLL_READY:
>> +			goto issue_sqe;
>> +		case IO_APOLL_ABORTED:
>>  			/*
>>  			 * Queued up for async execution, worker will release
>>  			 * submit reference when the iocb is actually submitted.
>>  			 */
>>  			io_queue_async_work(req);
>> +			break;
> 
> Hmm, why there is a new break here? It will miscount @linked_timeout
> if you do that. Every io_prep_linked_timeout() should be matched with
> io_queue_linked_timeout().

Never mind, I said some nonsense and apparently need some coffee


>>  		}
>>  	} else {
>>  		io_req_complete_failed(req, ret);
>>
> 

-- 
Pavel Begunkov
