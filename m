Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4A5427A39
	for <lists+io-uring@lfdr.de>; Sat,  9 Oct 2021 14:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbhJIMtW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Oct 2021 08:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbhJIMtW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Oct 2021 08:49:22 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B803C061570
        for <io-uring@vger.kernel.org>; Sat,  9 Oct 2021 05:47:25 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id k7so38183934wrd.13
        for <io-uring@vger.kernel.org>; Sat, 09 Oct 2021 05:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=auf8sWqvFOY/CsOqPCmH1p9IsMg2u6ckxJCpagtOUbQ=;
        b=h1k2PDNzpBJHXVeJw9ejFhwBEFMyjJd7cGgF44U2H1X40r7M2RQAck0hG3ZKxcox6T
         zAo1KaiYdlMv8uqeJG2nMEdpt6JuvHY61WIDDwyWjQM742OC/7ZKP40RKMV4yMGlnYo+
         RE4BdhWYuLdQs5VKxfHdC+Z1G08G55iF7HXRl3u6O9b1sWq19V3d30A9y6ZRT5WhxAPN
         dY8pqj47/SZX0s5ZuAi9fEirGfDGnFZdQef0Q6MNEZ7cFMH+dE2LafHDp38yMk+UBcXy
         bzp1btINVaETsXQoaWXKaqQK5AgHRh1TRe3fS2La3rAQ3ELxYwh2TwtIZr+CKg2ZcXo4
         MXbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=auf8sWqvFOY/CsOqPCmH1p9IsMg2u6ckxJCpagtOUbQ=;
        b=JGF9bESXn1GOR6YvfunEG+VfliiVxLuEqqbRec+1vGmUN6RrBekaHuv+1CFTlnTwgy
         bkQWQ5TfpuwidWBbwmdk6I+Ok7l/e1k0DWz8nKwvprJs3H3w0+BbPLIjp3cDxCdVQ7rO
         QCL11K+VoU1bda0A54DQv5dkrw/+9D2K9o6zw80M7RzpFtccsXJuHG6CNhO/42y2/M1P
         ku2TUbeDLQwfBb5U9jKDW56PjMXwMItvYvuif+4hhBZRuq2tOLAjoLkDOovgWqKdN2Mm
         aO6R3oBY/qdsq0DxwisZro0wHIgPiAU+hAFvD5/QedJpRqR2XobggHYMwdkDLluf+Xnk
         6+Eg==
X-Gm-Message-State: AOAM532+kS+69Fe074TCGf5BL5deK01iPabdKShyxE2sIow7l4tqGesV
        lXn6jauwBbgqmGkZS3HlyWGtMY6KMx0=
X-Google-Smtp-Source: ABdhPJzg0d7yIbaB7VrQ3D/LuzZqAJJlpCoNHAbVQEKD5waxgwuqz7Ode7pT/68dHNX4AYfWrhdcNQ==
X-Received: by 2002:adf:a454:: with SMTP id e20mr11259301wra.310.1633783643665;
        Sat, 09 Oct 2021 05:47:23 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.155])
        by smtp.gmail.com with ESMTPSA id o6sm2749536wri.49.2021.10.09.05.47.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Oct 2021 05:47:23 -0700 (PDT)
Message-ID: <0c0f713e-f1ef-5798-f38f-18ef8358eb6b@gmail.com>
Date:   Sat, 9 Oct 2021 13:46:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211008123642.229338-1-haoxu@linux.alibaba.com>
 <20211008123642.229338-3-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 2/2] io_uring: implementation of IOSQE_ASYNC_HYBRID logic
In-Reply-To: <20211008123642.229338-3-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/8/21 13:36, Hao Xu wrote:
> The process of this kind of requests is:
> 
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
> This works much better than IOSQE_ASYNC in cases where cpu resources
> are scarce or unbound max_worker is small. In these cases, number of
> io-worker eazily increments to max_worker, new worker cannot be created
> and running workers stuck there handling old works in IOSQE_ASYNC mode.
> 
> In my machine, set unbound max_worker to 20, run echo-server, turns out:
> (arguments: register_file, connetion number is 1000, message size is 12
> Byte)
> IOSQE_ASYNC: 76664.151 tps
> IOSQE_ASYNC_HYBRID: 166934.985 tps
> 
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   fs/io_uring.c | 42 ++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 38 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index a99f7f46e6d4..024cef09bc12 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1409,7 +1409,7 @@ static void io_prep_async_work(struct io_kiocb *req)
>   
>   	req->work.list.next = NULL;
>   	req->work.flags = 0;
> -	if (req->flags & REQ_F_FORCE_ASYNC)
> +	if (req->flags & (REQ_F_FORCE_ASYNC | REQ_F_ASYNC_HYBRID))
>   		req->work.flags |= IO_WQ_WORK_CONCURRENT;
>   
>   	if (req->flags & REQ_F_ISREG) {
> @@ -5575,7 +5575,13 @@ static int io_arm_poll_handler(struct io_kiocb *req)
>   	req->apoll = apoll;
>   	req->flags |= REQ_F_POLLED;
>   	ipt.pt._qproc = io_async_queue_proc;
> -	io_req_set_refcount(req);
> +	/*
> +	 * REQ_F_REFCOUNT set indicate we are in io-worker context, where we

Nope, it indicates that needs more complex refcounting. It includes linked
timeouts but also poll because of req_ref_get for double poll. fwiw, with
some work it can be removed for polls, harder (and IMHO not necessary) to do
for timeouts.

> +	 * already explicitly set the submittion and completion ref. So no

I'd say there is no notion of submission vs completion refs anymore.

> +	 * need to set refcount here if that is the case.
> +	 */
> +	if (!(req->flags & REQ_F_REFCOUNT))

Compare it with io_req_set_refcount(), that "if" is a a no-op

> +		io_req_set_refcount(req);
>   
>   	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
>   					io_async_wake);
> @@ -6704,8 +6710,11 @@ static void io_wq_submit_work(struct io_wq_work *work)
>   		ret = -ECANCELED;
>   
>   	if (!ret) {
> +		bool need_poll = req->flags & REQ_F_ASYNC_HYBRID;
> +
>   		do {
> -			ret = io_issue_sqe(req, 0);
> +issue_sqe:
> +			ret = io_issue_sqe(req, need_poll ? IO_URING_F_NONBLOCK : 0);

It's buggy, you will get all kinds of kernel crashes and leaks.
Currently IO_URING_F_NONBLOCK has dual meaning: obvious nonblock but
also whether we hold uring_lock or not. You'd need to split the flag
into two, i.e. IO_URING_F_LOCKED

-- 
Pavel Begunkov
