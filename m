Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535923F4950
	for <lists+io-uring@lfdr.de>; Mon, 23 Aug 2021 13:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbhHWLDc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Aug 2021 07:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234865AbhHWLDb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Aug 2021 07:03:31 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D534AC061575
        for <io-uring@vger.kernel.org>; Mon, 23 Aug 2021 04:02:48 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id u15so10241707wmj.1
        for <io-uring@vger.kernel.org>; Mon, 23 Aug 2021 04:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uKYnu/DLXz9S7MebCTHbOwaQytZqOWiu67+hgD32v60=;
        b=YZoTFvuho2kGdrZneWrW2SnbxC3xxikiatyVf7CoI/YpfFfzl/UMJ7cFDLbYN0uMQj
         ss036gLKCzSVWeq0l740B7T36sj82NRQlqS1Xa7GbrsaALw99WkUsHiJjCQcOtr7pWlJ
         emoKhSi6aFp4asYGVuAyzcIXU9+MpTeFDblZc2miwPjZH3QxVtZF2YV4Q0YXKdxDOCD9
         UCOxFYKhuxMAPo9WZn/tLIDHSES56AHhFi9QtBnnorVUqY+xskiVUtZV26d/LjkX9GJZ
         kDnlLaO56xru8rTGKRzGzSiWEbCkDvygEecWYhno+PUCVUSgzWD1m7qdIq07YpKlvA0P
         yhhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uKYnu/DLXz9S7MebCTHbOwaQytZqOWiu67+hgD32v60=;
        b=R7SMI/N86DmbhNs7vkdZ/O+zhrbUt0wbbJjctgjUTjWS+ljxQNj2LiG64Ts7a5e8Eq
         1oeSXIHlBA/hOByeCMq8mNAStKaH4lVRGxcgZiiuFsLQw7gQEN7pqVm/9VtKYd58gZLl
         fEMbT92wFxk++rx2gdSjkYB8ScZVvRRRKdKGaBJ1p8WjQCN/uAgwcheM1+na7iA5bib5
         Q/CQ8CbB0OlsANUoJlFfngdkPSPlW5Xmb10YX7rAK3RvsyqDA5ALa8VEDqCxXjV8YGK7
         Vro/CSb++yRL4fdnL3z07ReOKzu/6BwAvhXVJreAOQ5PvQQNjaxuk2D1dfduJGdWKrtK
         DnSA==
X-Gm-Message-State: AOAM530ndVCjBgPHRtzKf4WvTFFKsXPQ07BEyNbf0Qzf6vlKrixNMbOu
        EHvR/bUui/xp249u5wV2VO4rqfjf2tU=
X-Google-Smtp-Source: ABdhPJwQIvfSuhD3clNeLlFBG0ovVXaBPDlFilte8nefztLim/xCzad3mZvgRkudovPJ1tDDWPFqLQ==
X-Received: by 2002:a05:600c:1ca7:: with SMTP id k39mr15797487wms.162.1629716567224;
        Mon, 23 Aug 2021 04:02:47 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.176])
        by smtp.gmail.com with ESMTPSA id i14sm12681713wmq.40.2021.08.23.04.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 04:02:46 -0700 (PDT)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210823032506.34857-1-haoxu@linux.alibaba.com>
 <20210823032506.34857-3-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 2/2] io_uring: fix failed linkchain code logic
Message-ID: <7a680e7a-801e-4515-e67c-a3849c581d02@gmail.com>
Date:   Mon, 23 Aug 2021 12:02:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210823032506.34857-3-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/23/21 4:25 AM, Hao Xu wrote:
> Given a linkchain like this:
> req0(link_flag)-->req1(link_flag)-->...-->reqn(no link_flag)
> 
> There is a problem:
>  - if some intermediate linked req like req1 's submittion fails, reqs
>    after it won't be cancelled.
> 
>    - sqpoll disabled: maybe it's ok since users can get the error info
>      of req1 and stop submitting the following sqes.
> 
>    - sqpoll enabled: definitely a problem, the following sqes will be
>      submitted in the next round.
> 
> The solution is to refactor the code logic to:
>  - if a linked req's submittion fails, just mark it and the head(if it
>    exists) as REQ_F_FAIL. Leverage req->result to indicate whether it
>    is failed or cancelled.
>  - submit or fail the whole chain when we come to the end of it.

This looks good to me, a couple of comments below.


> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io_uring.c | 61 +++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 45 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 44b1b2b58e6a..9ae8f2a5c584 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1776,8 +1776,6 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
>  	req->ctx = ctx;
>  	req->link = NULL;
>  	req->async_data = NULL;
> -	/* not necessary, but safer to zero */
> -	req->result = 0;

Please leave it. I'm afraid of leaking stack to userspace because
->result juggling looks prone to errors. And preinit is pretty cold
anyway.

[...]

>  
> @@ -6637,19 +6644,25 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  	ret = io_init_req(ctx, req, sqe);
>  	if (unlikely(ret)) {
>  fail_req:
> +		/* fail even hard links since we don't submit */
>  		if (link->head) {
> -			/* fail even hard links since we don't submit */
> -			io_req_complete_failed(link->head, -ECANCELED);
> -			link->head = NULL;
> +			req_set_fail(link->head);

I think it will be more reliable if we set head->result here, ...

if (!(link->head->flags & FAIL))
	link->head->result = -ECANCELED;

> -		ret = io_req_prep_async(req);
> -		if (unlikely(ret))
> -			goto fail_req;
> +		if (!(req->flags & REQ_F_FAIL)) {
> +			ret = io_req_prep_async(req);
> +			if (unlikely(ret)) {
> +				req->result = ret;
> +				req_set_fail(req);
> +				req_set_fail(link->head);

... and here (a helper?), ...

> +			}
> +		}
>  		trace_io_uring_link(ctx, req, head);
>  		link->last->link = req;
>  		link->last = req;
> @@ -6681,6 +6699,17 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
>  		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
>  			link->head = req;
>  			link->last = req;
> +			/*
> +			 * we can judge a link req is failed or cancelled by if
> +			 * REQ_F_FAIL is set, but the head is an exception since
> +			 * it may be set REQ_F_FAIL because of other req's failure
> +			 * so let's leverage req->result to distinguish if a head
> +			 * is set REQ_F_FAIL because of its failure or other req's
> +			 * failure so that we can set the correct ret code for it.
> +			 * init result here to avoid affecting the normal path.
> +			 */
> +			if (!(req->flags & REQ_F_FAIL))
> +				req->result = 0;

... instead of delaying to this point. Just IMHO, it's easier to look
after the code when it's set on the spot, i.e. may be easy to screw/forget
something while changing bits around.


>  		} else {
>  			io_queue_sqe(req);
>  		}
> 

-- 
Pavel Begunkov
