Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EE625E661
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 10:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbgIEIYR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 04:24:17 -0400
Received: from mail.nickhill.org ([77.72.3.32]:34384 "EHLO mail.nickhill.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbgIEIYQ (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 5 Sep 2020 04:24:16 -0400
Received: from _ (localhost [127.0.0.1])
        by mail.nickhill.org (Postfix) with ESMTPSA id 9C5044032A;
        Sat,  5 Sep 2020 08:24:13 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 05 Sep 2020 01:24:13 -0700
From:   nick@nickhill.org
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: WRITEV with IOSQE_ASYNC broken?
In-Reply-To: <484b5876-a2e6-3e02-a566-10c5a02241e8@gmail.com>
References: <382946a1d3513fbb1354c8e2c875e036@nickhill.org>
 <bfd153eb-0ab9-5864-ca5d-1bc8298f7a21@kernel.dk>
 <fe3784cf-3389-6096-9dfd-f3aa8cd3a769@kernel.dk>
 <d8404079-fe7e-3f42-4460-22328b12b0fa@kernel.dk>
 <484b5876-a2e6-3e02-a566-10c5a02241e8@gmail.com>
Message-ID: <a7285fbdffcf587a3fc4eb8e75f57da3@nickhill.org>
X-Sender: nick@nickhill.org
User-Agent: Roundcube Webmail
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020-09-04 22:50, Pavel Begunkov wrote:
> On 05/09/2020 07:35, Jens Axboe wrote:
>> On 9/4/20 9:57 PM, Jens Axboe wrote:
>>> On 9/4/20 9:53 PM, Jens Axboe wrote:
>>>> On 9/4/20 9:22 PM, nick@nickhill.org wrote:
>>>>> Hi,
>>>>> 
>>>>> I am helping out with the netty io_uring integration, and came 
>>>>> across
>>>>> some strange behaviour which seems like it might be a bug related 
>>>>> to
>>>>> async offload of read/write iovecs.
>>>>> 
>>>>> Basically a WRITEV SQE seems to fail reliably with -BADADDRESS when 
>>>>> the
>>>>> IOSQE_ASYNC flag is set but works fine otherwise (everything else 
>>>>> the
>>>>> same). This is with 5.9.0-rc3.
>>>> 
>>>> Do you see it just on 5.9-rc3, or also 5.8? Just curious... But that 
>>>> is
>>>> very odd in any case, ASYNC writev is even part of the regular 
>>>> tests.
>>>> Any sort of deferral, be it explicit via ASYNC or implicit through
>>>> needing to retry, saves all the needed details to retry without
>>>> needing any of the original context.
>>>> 
>>>> Can you narrow down what exactly is being written - like file type,
>>>> buffered/O_DIRECT, etc. What file system, what device is hosting it.
>>>> The more details the better, will help me narrow down what is going 
>>>> on.
>>> 
>>> Forgot, also size of the IO (both total, but also number of iovecs in
>>> that particular request.
>>> 
>>> Essentially all the details that I would need to recreate what you're
>>> seeing.
>> 
>> Turns out there was a bug in the explicit handling, new in the current
>> -rc series. Can you try and add the below?
> 
> Hah, absolutely the same patch was in a series I was going to send
> today, but with a note that it works by luck so not a bug. Apparently,
> it is :)
> 
> BTW, const in iter->iov is guarding from such cases, yet another proof
> that const casts are evil.
> 
>> 
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 0d7be2e9d005..000ae2acfd58 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -2980,14 +2980,15 @@ static inline int io_rw_prep_async(struct 
>> io_kiocb *req, int rw,
>>  				   bool force_nonblock)
>>  {
>>  	struct io_async_rw *iorw = &req->io->rw;
>> +	struct iovec *iov;
>>  	ssize_t ret;
>> 
>> -	iorw->iter.iov = iorw->fast_iov;
>> -	ret = __io_import_iovec(rw, req, (struct iovec **) &iorw->iter.iov,
>> -				&iorw->iter, !force_nonblock);
>> +	iorw->iter.iov = iov = iorw->fast_iov;
>> +	ret = __io_import_iovec(rw, req, &iov, &iorw->iter, 
>> !force_nonblock);
>>  	if (unlikely(ret < 0))
>>  		return ret;
>> 
>> +	iorw->iter.iov = iov;
>>  	io_req_map_rw(req, iorw->iter.iov, iorw->fast_iov, &iorw->iter);
>>  	return 0;
>>  }
>> 

Thanks for the speedy replies and finding/fixing this so fast! I'm new 
to kernel dev and haven't built my own yet but I think Norman is going 
to try out your patch soon.

Nick
