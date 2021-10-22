Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24B64374B4
	for <lists+io-uring@lfdr.de>; Fri, 22 Oct 2021 11:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbhJVJ3i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Oct 2021 05:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbhJVJ3i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Oct 2021 05:29:38 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7353C061764
        for <io-uring@vger.kernel.org>; Fri, 22 Oct 2021 02:27:20 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id u13so1195210edy.10
        for <io-uring@vger.kernel.org>; Fri, 22 Oct 2021 02:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wbC4agIo4V86kfOF+WPedHeZk9MWONdrl5votHlA/xQ=;
        b=EkV1T+UdX7mrmjkKIIBSo3mA68TAUnBdn6vjgsWnOlZGmdl3yI7NGqPOqhDrBASdZ9
         mY2eoJmedvHI3r97s25771ZwIzfztZqQc29Myk2HRUUxOZRbmy8xYqHnerWbd2PP+rAo
         bHkr+Gx1S9JxPJ8nsZ8um3NRKCCr/fjk779u1gPP4DVCVqc1exip/epsFfUjIv4fvrP8
         eT2TqqtmZAr3epuqvPQALhqv2K8Fl0grQ5VGB/1G6cI1Ln0godp0tSR/M41nTs6QAm0o
         m7UGS6TJb6SvZGyM1NVlqmkar4a4M5e5XlLXh1r+Ja1E24UAgY7XdWfCx5nHre/ODBlg
         +cPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wbC4agIo4V86kfOF+WPedHeZk9MWONdrl5votHlA/xQ=;
        b=m1bDTKdMnraPS8WNx6bEjLiz3l91FWB+WjfqpEt8zPq/02zF0T3dZ3EaDhad1b8d3H
         4ROePdGjnxMKLn/FzUfQQib/bxQzbQ/9WMyuEUjLDvpdVfltX5EE4pttUp8ak9m59ZbN
         4qRZYvMbsFDC3OLHxpH2JGoHDPFV5wt+bf+dzoI8p0TOpbvEh/S0+orYLYrDk6mDuwHg
         sD+uEPm/HMNo5/5e2p5EHSgIiQ4r10644V7ezfr1dMfvACuOt7XYx2HQ/nh3LJ8Z92DY
         M7lpZqHvsyuWpSixZsDoZr3VyG5wiv9ByIvuNb9rfHPy9U9dalex6LchVucFC5V7iBaz
         EADw==
X-Gm-Message-State: AOAM532UU21lteKEKcZLHoV2OC3A6afIAsUyf+RGabqNLFK2Syb1hRkA
        oqGsMKI7MNxsvXkJU32X+o8=
X-Google-Smtp-Source: ABdhPJyQma8o0mTCf8xOlSBCtnC6oiISUSH5zIFLYroqQFLbfFhNkuF0ilNJyFgTDUSY/YulyIxdhw==
X-Received: by 2002:a17:907:6e2a:: with SMTP id sd42mr13802566ejc.333.1634894839444;
        Fri, 22 Oct 2021 02:27:19 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id g7sm4069582edu.48.2021.10.22.02.27.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 02:27:18 -0700 (PDT)
Message-ID: <3f81403d-9594-426c-c480-1508ce90d04f@gmail.com>
Date:   Fri, 22 Oct 2021 10:27:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3] io_uring: implement async hybrid mode for pollable
 requests
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211018133445.103438-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211018133445.103438-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/18/21 14:34, Hao Xu wrote:
> The current logic of requests with IOSQE_ASYNC is first queueing it to
> io-worker, then execute it in a synchronous way. For unbound works like
> pollable requests(e.g. read/write a socketfd), the io-worker may stuck
> there waiting for events for a long time. And thus other works wait in
> the list for a long time too.
> Let's introduce a new way for unbound works (currently pollable
> requests), with this a request will first be queued to io-worker, then
> executed in a nonblock try rather than a synchronous way. Failure of
> that leads it to arm poll stuff and then the worker can begin to handle
> other works.
> The detail process of this kind of requests is:

Looks good, I have some problems on my hands, but I'll try to test
it and review more carefully today. I hope we can get it for 5.16


> step1: original context:
>             queue it to io-worker
> step2: io-worker context:
>             nonblock try(the old logic is a synchronous try here)
>                 |
>                 |--fail--> arm poll
>                              |
>                              |--(fail/ready)-->synchronous issue
>                              |
>                              |--(succeed)-->worker finish it's job, tw
>                                             take over the req
> 
> This works much better than the old IOSQE_ASYNC logic in cases where
> unbound max_worker is relatively small. In this case, number of
> io-worker eazily increments to max_worker, new worker cannot be created
> and running workers stuck there handling old works in IOSQE_ASYNC mode.
> 
> In my 64-core machine, set unbound max_worker to 20, run echo-server,
> turns out:
> (arguments: register_file, connetion number is 1000, message size is 12
> Byte)
> original IOSQE_ASYNC: 76664.151 tps
> after this patch: 166934.985 tps
> 
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> 
> v1-->v2:
>   - tweak added code in io_wq_submit_work to reduce overhead
> v2-->v3:
>   - remove redundant IOSQE_ASYNC_HYBRID stuff
> 
> 
>   fs/io_uring.c | 36 +++++++++++++++++++++++++++++++++++-
>   1 file changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index b3546eef0289..86819c7917df 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6747,8 +6747,18 @@ static void io_wq_submit_work(struct io_wq_work *work)
>   		ret = -ECANCELED;
>   
>   	if (!ret) {
> +		bool needs_poll = false;
> +		unsigned int issue_flags = IO_URING_F_UNLOCKED;
> +
> +		if (req->flags & REQ_F_FORCE_ASYNC) {
> +			needs_poll = req->file && file_can_poll(req->file);
> +			if (needs_poll)
> +				issue_flags |= IO_URING_F_NONBLOCK;
> +		}
> +
>   		do {
> -			ret = io_issue_sqe(req, IO_URING_F_UNLOCKED);
> +issue_sqe:
> +			ret = io_issue_sqe(req, issue_flags);
>   			/*
>   			 * We can get EAGAIN for polled IO even though we're
>   			 * forcing a sync submission from here, since we can't
> @@ -6756,6 +6766,30 @@ static void io_wq_submit_work(struct io_wq_work *work)
>   			 */
>   			if (ret != -EAGAIN)
>   				break;
> +			if (needs_poll) {
> +				bool armed = false;
> +
> +				ret = 0;
> +				needs_poll = false;
> +				issue_flags &= ~IO_URING_F_NONBLOCK;
> +
> +				switch (io_arm_poll_handler(req)) {
> +				case IO_APOLL_READY:
> +					goto issue_sqe;
> +				case IO_APOLL_ABORTED:
> +					/*
> +					 * somehow we failed to arm the poll infra,
> +					 * fallback it to a normal async worker try.
> +					 */
> +					break;
> +				case IO_APOLL_OK:
> +					armed = true;
> +					break;
> +				}
> +
> +				if (armed)
> +					break;
> +			}
>   			cond_resched();
>   		} while (1);
>   	}
> 

-- 
Pavel Begunkov
