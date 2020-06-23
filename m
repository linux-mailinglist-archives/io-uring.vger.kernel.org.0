Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8052054F6
	for <lists+io-uring@lfdr.de>; Tue, 23 Jun 2020 16:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732869AbgFWOie (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Jun 2020 10:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732858AbgFWOid (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Jun 2020 10:38:33 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D17C061795
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 07:38:33 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id y5so23779302iob.12
        for <io-uring@vger.kernel.org>; Tue, 23 Jun 2020 07:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GO6VqQ1k5DfT8B3Hft14D4L5hj9uXyjCb94sDmddrkY=;
        b=i8Xvf0dO3HlBgVkDMm2UdFWATb6q5c49Gp1uR5t24gxH4xjYC+5ei4BkAqzDM2KSv/
         2gx/lezU+C8XyNWRfTI2XMPTKj6pxrB0XjEi8ZEynRWETcpvFmmMuGNdUvh/OrI+i/w5
         vwWn6nfaeBN2WmpS8aNmJKRPO4tUJvKILSS4Hvp003kdC/j3G3kbQiCz9bHiXZCSdqLh
         wIuxpVhhkSZ4J9U47uB+OkiyAa7fBy0f0ZDAIFve5z+1F2Hhm0G1n/FAMOS6UM/N4x95
         PT9eFcXR5AxlX0ghw/EevRefdUSRw1vMHUuPnw5mrl2JdpHHK03FgT984eqxkUrvctEj
         1eGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GO6VqQ1k5DfT8B3Hft14D4L5hj9uXyjCb94sDmddrkY=;
        b=l39U3K/cdmI0Sadju5kujuO7atRSkMT1tG2c36Mt2ayIOTv0ICXhFhgafpX1mk63Sa
         294hSokSZxHNlpfS9zpFedLu2KlhaMcymyfNec1Py288XDyZG4v9Rz9jMkUXD9F79tZe
         3FBVq7wn+hd/2hX4gYxqD9UkbPAniE92BfF3belSwJJzNExnex3PB5xAJuBJ6yWnXMch
         ffYs9W/EXfoZ6ZTi66O+e3XieEsAPvWZ7WpnRP10C4QiqrlznVT2FnzL5OwsqlikXd8Z
         4pv3AfHC+QnVlfjnYTheio6Fd1NB3cmrGTJxiOF8EBEuBss/OPP0QbnyVbUI8C86Um6m
         MD+w==
X-Gm-Message-State: AOAM531SU9swkGMgPJW3/xeX1bBSW2F+gdloNRVOcrNfbJmavCGdz7mF
        pwnat8fBFAc4F4ohtbU37mJmGg==
X-Google-Smtp-Source: ABdhPJxMOLP/f8YqjcdyvCnPvoh/iJidBaJRFad2O/9s6/oq7uoN5bcHuwnQcqjMnRJ+y18nv3dkKQ==
X-Received: by 2002:a02:2417:: with SMTP id f23mr25134322jaa.28.1592923113020;
        Tue, 23 Jun 2020 07:38:33 -0700 (PDT)
Received: from [192.168.1.56] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a20sm6546352ila.5.2020.06.23.07.38.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 07:38:31 -0700 (PDT)
Subject: Re: [PATCH 15/15] io_uring: support true async buffered reads, if
 file provides it
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org
References: <20200618144355.17324-1-axboe@kernel.dk>
 <20200618144355.17324-16-axboe@kernel.dk>
 <029947e3-7615-e446-3194-d48827730e1d@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9c368ff8-b867-d40e-cd3b-6dacbecc0515@kernel.dk>
Date:   Tue, 23 Jun 2020 08:38:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <029947e3-7615-e446-3194-d48827730e1d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/20 6:39 AM, Pavel Begunkov wrote:
> On 18/06/2020 17:43, Jens Axboe wrote:
>> If the file is flagged with FMODE_BUF_RASYNC, then we don't have to punt
>> the buffered read to an io-wq worker. Instead we can rely on page
>> unlocking callbacks to support retry based async IO. This is a lot more
>> efficient than doing async thread offload.
>>
>> The retry is done similarly to how we handle poll based retry. From
>> the unlock callback, we simply queue the retry to a task_work based
>> handler.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/io_uring.c | 145 +++++++++++++++++++++++++++++++++++++++++++++++---
>>  1 file changed, 137 insertions(+), 8 deletions(-)
>>
> ...
>>  static int io_read(struct io_kiocb *req, bool force_nonblock)
>>  {
>>  	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
>> @@ -2784,10 +2907,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
>>  		unsigned long nr_segs = iter.nr_segs;
>>  		ssize_t ret2 = 0;
>>  
>> -		if (req->file->f_op->read_iter)
>> -			ret2 = call_read_iter(req->file, kiocb, &iter);
>> -		else
>> -			ret2 = loop_rw_iter(READ, req->file, kiocb, &iter);
>> +		ret2 = io_iter_do_read(req, &iter);
>>  
>>  		/* Catch -EAGAIN return for forced non-blocking submission */
>>  		if (!force_nonblock || (ret2 != -EAGAIN && ret2 != -EIO)) {
>> @@ -2799,17 +2919,26 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
>>  			ret = io_setup_async_rw(req, io_size, iovec,
>>  						inline_vecs, &iter);
>>  			if (ret)
>> -				goto out_free;
>> +				goto out;
>>  			/* any defer here is final, must blocking retry */
>>  			if (!(req->flags & REQ_F_NOWAIT) &&
>>  			    !file_can_poll(req->file))
>>  				req->flags |= REQ_F_MUST_PUNT;
>> +			/* if we can retry, do so with the callbacks armed */
>> +			if (io_rw_should_retry(req)) {
>> +				ret2 = io_iter_do_read(req, &iter);
>> +				if (ret2 == -EIOCBQUEUED) {
>> +					goto out;
>> +				} else if (ret2 != -EAGAIN) {
>> +					kiocb_done(kiocb, ret2);
>> +					goto out;
>> +				}
>> +			}
>> +			kiocb->ki_flags &= ~IOCB_WAITQ;
>>  			return -EAGAIN;
>>  		}
>>  	}
>> -out_free:
>> -	kfree(iovec);
>> -	req->flags &= ~REQ_F_NEED_CLEANUP;
> 
> This looks fishy. For instance, if it fails early on rw_verify_area(), how would
> it free yet on-stack iovec? Is it handled somehow?

This was tweaked and rebased on top of the REQ_F_NEED_CLEANUP change,
it should be correct in the tree:

https://git.kernel.dk/cgit/linux-block/tree/fs/io_uring.c?h=for-5.9/io_uring#n2908

-- 
Jens Axboe

