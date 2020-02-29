Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704AE1744ED
	for <lists+io-uring@lfdr.de>; Sat, 29 Feb 2020 05:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgB2Eub (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 23:50:31 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40421 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgB2Eua (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 23:50:30 -0500
Received: by mail-pg1-f195.google.com with SMTP id t24so2561040pgj.7
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2020 20:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1klXDbL5TLWL4hhHXYZJfSnjOsCuBn2f5326j2ujJN0=;
        b=TsOqJ3K65KTL+DoreL7FnuLsEAEiM7Dn25HwsXpgrkCfIfwPqNnt3GxgHOXl+0dIK1
         2M5maNYBDH5R2ND23ctk1z8Sy2rXD1uIyhqaqTOWvqmpQO5pPtLr2DlN/TxwG5OvhjJx
         xHOsd+qNTCiS3dkWZvzT0RC3TdTfjLBmHZMxNU3/aSl9zWBzGRhKJEaxo7nL9ttMQrCL
         O0Yr6TEOKP7NTW4cZYzy5ZHpea6D0ZIeF4djvpG7x9jAaHmX7aC0CTZPfWqZrl1voUnD
         7BPEMvP7DEbEiQ/dp5BsLXuXz1mhK7YT3f5Hvo5CpU0KWJ17871X/hS03rr/zcYnCB/5
         3B0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1klXDbL5TLWL4hhHXYZJfSnjOsCuBn2f5326j2ujJN0=;
        b=O9WqggsmM1RdUY4uottbD+c2AKm3kLrZ4y8OF48VdWBFO281x4pBWSNApOP4KNgL9v
         2qkhm3uQUzrpWyUm1Xv47r3oxtyjbXXHou0tSBpS4lHoMo17gc8LLyGvmPNjetTw/t0q
         VnddUVcu7eP8BjrZXZ3SLcJprMe40R1rwMZ0kuk0zq5vVrtsbFYnMADeLpCkSp5cD9rd
         D+gdVBdSaUMgBip+idWMTAnIeeMtNf99pfjPctrIJXaHaX74+5dMqscZRfBsHavV/Ojl
         jocO58Tl44gZmOHrJkVwxLOZaq8K72+a+36P0TnQbqY2J5bvl7ESauC2WExbEDw7SFff
         onGw==
X-Gm-Message-State: ANhLgQ1G/sFTg2jiz7qmwLdyJsVeuO9Q/6KnMwoooyCDXbGV8CaiKep9
        Zb5A7gyqu4is805+zxv0pbv2LXFKkK8=
X-Google-Smtp-Source: ADFU+vv1GGyH/4AGWxXEBO9xsOa8VOqaavId1wvFm0TIvhk9cNgGH0CAOQWPHvhV5TJCh5qoZcHWqw==
X-Received: by 2002:aa7:8426:: with SMTP id q6mr1506090pfn.221.1582951827767;
        Fri, 28 Feb 2020 20:50:27 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id a36sm11914624pga.32.2020.02.28.20.50.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2020 20:50:27 -0800 (PST)
Subject: Re: [PATCH 2/6] io_uring: add IORING_OP_PROVIDE_BUFFERS
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     andres@anarazel.de
References: <20200228203053.25023-1-axboe@kernel.dk>
 <20200228203053.25023-3-axboe@kernel.dk>
 <7671b196-99cc-d0a9-3b7e-86769c304b10@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <297b6e91-b683-80a3-38a2-9c3b845c4d06@kernel.dk>
Date:   Fri, 28 Feb 2020 21:50:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <7671b196-99cc-d0a9-3b7e-86769c304b10@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/28/20 5:43 PM, Pavel Begunkov wrote:
> 
> 
> On 28/02/2020 23:30, Jens Axboe wrote:
>> IORING_OP_PROVIDE_BUFFERS uses the buffer registration infrastructure to
>> support passing in an addr/len that is associated with a buffer ID and
>> buffer group ID. The group ID is used to index and lookup the buffers,
>> while the buffer ID can be used to notify the application which buffer
>> in the group was used. The addr passed in is the starting buffer address,
>> and length is each buffer length. A number of buffers to add with can be
>> specified, in which case addr is incremented by length for each addition,
>> and each buffer increments the buffer ID specified.
>>
>> No validation is done of the buffer ID. If the application provides
>> buffers within the same group with identical buffer IDs, then it'll have
>> a hard time telling which buffer ID was used. The only restriction is
>> that the buffer ID can be a max of 16-bits in size, so USHRT_MAX is the
>> maximum ID that can be used.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> 
>> +
>> +static int io_add_buffers(struct io_provide_buf *pbuf, struct list_head *list)
>> +{
>> +	struct io_buffer *buf;
>> +	u64 addr = pbuf->addr;
>> +	int i, bid = pbuf->bid;
>> +
>> +	for (i = 0; i < pbuf->nbufs; i++) {
>> +		buf = kmalloc(sizeof(*buf), GFP_KERNEL);
>> +		if (!buf)
>> +			break;
>> +
>> +		buf->addr = addr;
>> +		buf->len = pbuf->len;
>> +		buf->bid = bid;
>> +		list_add(&buf->list, list);
>> +		addr += pbuf->len;
> 
> So, it chops a linear buffer into pbuf->nbufs chunks of size pbuf->len.

Right

> Did you consider iovec? I'll try to think about it after getting some sleep

I did, my issue there is that if you do vecs, then you want non-contig
buffer IDs. And then you'd need something else than an iovec, and it
gets messy pretty quick.

But in general, I'd really like to reuse buffer IDs, because I think
that's what applications would generally want. Maybe that means that
single buffers is just easier to deal with, but at least you can do that
with this approach without needing any sort of "packaging" for the data
passed in - it's just a pointer.

I'm open to suggestions, though!

>> +static int io_provide_buffers(struct io_kiocb *req, struct io_kiocb **nxt,
>> +			      bool force_nonblock)
>> +{
>> +	struct io_provide_buf *p = &req->pbuf;
>> +	struct io_ring_ctx *ctx = req->ctx;
>> +	struct list_head *list;
>> +	int ret = 0;
>> +
>> +	/*
>> +	 * "Normal" inline submissions always hold the uring_lock, since we
>> +	 * grab it from the system call. Same is true for the SQPOLL offload.
>> +	 * The only exception is when we've detached the request and issue it
>> +	 * from an async worker thread, grab the lock for that case.
>> +	 */
>> +	if (!force_nonblock)
>> +		mutex_lock(&ctx->uring_lock);
> 
> io_poll_task_handler() calls it with force_nonblock==true, but it
> doesn't hold the mutex AFAIK.

True, that's the only exception. And that command doesn't transfer data
so would never need a buffer, but I agree that's perhaps not fully
clear. The async task handler grabs the mutex.

>> +	lockdep_assert_held(&ctx->uring_lock);
>> +
>> +	list = idr_find(&ctx->io_buffer_idr, p->gid);
>> +	if (!list) {
>> +		list = kmalloc(sizeof(*list), GFP_KERNEL);
>> +		if (!list) {
>> +			ret = -ENOMEM;
>> +			goto out;
>> +		}
>> +		INIT_LIST_HEAD(list);
>> +		ret = idr_alloc(&ctx->io_buffer_idr, list, p->gid, p->gid + 1,
>> +					GFP_KERNEL);
>> +		if (ret < 0) {
>> +			kfree(list);
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	ret = io_add_buffers(p, list);
> 
> Isn't it better to not do partial registration?
> i.e. it may return ret < pbuf->nbufs

Most things work like that, though. If you ask for an 8k read, you can't
unwind if you just get 4k. We return 4k for that. I think in general, if
it fails, you're probably somewhat screwed in either case. At least with
the partial return, you know which buffers got registered and how many
you can use. If you return 0 and undo it all, then the application
really has no way to continue except abort.

-- 
Jens Axboe

