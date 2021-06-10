Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36243A27AD
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 11:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbhFJJGK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 05:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhFJJGK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 05:06:10 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C77C061574;
        Thu, 10 Jun 2021 02:04:14 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id h22-20020a05600c3516b02901a826f84095so5915263wmq.5;
        Thu, 10 Jun 2021 02:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=yDSi4g0sV0qUX2g2a8fwt2TefXM0WRXPAMqlYc8RkCw=;
        b=AtcxMSFxepFBTbASltWunKOHw5kXxcP1vkes0TGZRmUFRvk39Z3M+w2L9ItXrVpITE
         Ek3yDpMC4xrwITjjqzNWB+bkNp+IKC4AiOR9yVugwFEL+NC43AmWSUJspD8ws61O6G0k
         UFVe3KVlb4o+TBmrV+BwMljnCVSw+7yR1nOIbXJTTf5evRwb+UWsd3AHmYP7JtWM7Se6
         2bELgmJerd3u+chMM4J8VYK4Xuuu5DU1DdSnYKAvDQ9EWdjAPbZL7VLd4kLT+y7a1asD
         AyqbrhPf0MCcU0oRLaXh99bp6SpJOm5PTj5GFq2zJysxUaJty8uZ5wL93P8GAWZYq3U+
         n8Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yDSi4g0sV0qUX2g2a8fwt2TefXM0WRXPAMqlYc8RkCw=;
        b=TJqd0UIll6UP6jZp+ArXSzWkyqnKxvfvhdzWq4rYBa/z4no6MM6uj5AV2nxqgemoa7
         Cf4qABxd894E4Qvv+uSoK3ZQarJJXV268jr56RrRKZtlomJWeZyrZn8xJUBkLNdOiGIA
         /v7EDTSYQrZRsximZKr9iYwLPZEGB1zk703uORcTK0pYU+Egw0fERtXq2urTkh+087Sx
         XkAykM1gxv+jvjDOwAhHj3+7QxzFmAwTwazsNx0/msnSiQd0Qk1hfzG0Dnsk2r92Bwir
         VNGaTaCpL0okyMwM+wF71f7SuLEgZ6REgJyy7gXqpCyhSw1SIKKOek3BR+nonLVNYoe1
         KaBQ==
X-Gm-Message-State: AOAM532U6ngYDbz1vKz7eqT+AOiJuWEkrqoqFvkRy1a0aBdgw6FbbDnx
        MLJKSknKYG1aYiQybbPATWk9RWGcKxua5r8m
X-Google-Smtp-Source: ABdhPJw3Nwt8e0AaLQCYyL/1hMoJK4pRYYr2317OxuaAD8GO7a5Wm4rlnBsx5ast32fLq44g4/kHcQ==
X-Received: by 2002:a05:600c:230b:: with SMTP id 11mr3921648wmo.81.1623315852124;
        Thu, 10 Jun 2021 02:04:12 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.95])
        by smtp.gmail.com with ESMTPSA id q5sm2829872wrm.15.2021.06.10.02.04.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 02:04:10 -0700 (PDT)
Subject: Re: [PATCH] io_uring: reduce latency by reissueing the operation
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60c13bec.1c69fb81.73967.f06dSMTPIN_ADDED_MISSING@mx.google.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <84e42313-d738-fb19-c398-08a4ed0e0d9c@gmail.com>
Date:   Thu, 10 Jun 2021 10:03:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <60c13bec.1c69fb81.73967.f06dSMTPIN_ADDED_MISSING@mx.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/21 11:08 PM, Olivier Langlois wrote:
> It is quite frequent that when an operation fails and returns EAGAIN,
> the data becomes available between that failure and the call to
> vfs_poll() done by io_arm_poll_handler().
> 
> Detecting the situation and reissuing the operation is much faster
> than going ahead and push the operation to the io-wq.

The poll stuff is not perfect and definitely can be improved,
but there are drawbacks, with this one fairness may suffer
with higher submit batching and make lat worse for all
but one request.

I'll get to it and another poll related email later,
probably next week.

> 
> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>  fs/io_uring.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 42380ed563c4..98cf3e323d5e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5138,15 +5138,16 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
>  	return mask;
>  }
>  
> -static bool io_arm_poll_handler(struct io_kiocb *req)
> +static bool io_arm_poll_handler(struct io_kiocb *req, __poll_t *ret)
>  {
>  	const struct io_op_def *def = &io_op_defs[req->opcode];
>  	struct io_ring_ctx *ctx = req->ctx;
>  	struct async_poll *apoll;
>  	struct io_poll_table ipt;
> -	__poll_t mask, ret;
> +	__poll_t mask;
>  	int rw;
>  
> +	*ret = 0;
>  	if (!req->file || !file_can_poll(req->file))
>  		return false;
>  	if (req->flags & REQ_F_POLLED)
> @@ -5184,9 +5185,9 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
>  
>  	ipt.pt._qproc = io_async_queue_proc;
>  
> -	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
> +	*ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
>  					io_async_wake);
> -	if (ret || ipt.error) {
> +	if (*ret || ipt.error) {
>  		io_poll_remove_double(req);
>  		spin_unlock_irq(&ctx->completion_lock);
>  		return false;
> @@ -6410,7 +6411,9 @@ static void __io_queue_sqe(struct io_kiocb *req)
>  {
>  	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
>  	int ret;
> +	__poll_t poll_ret;
>  
> +issue_sqe:
>  	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
>  
>  	/*
> @@ -6430,7 +6433,9 @@ static void __io_queue_sqe(struct io_kiocb *req)
>  			io_put_req(req);
>  		}
>  	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
> -		if (!io_arm_poll_handler(req)) {
> +		if (!io_arm_poll_handler(req, &poll_ret)) {
> +			if (poll_ret)
> +				goto issue_sqe;
>  			/*
>  			 * Queued up for async execution, worker will release
>  			 * submit reference when the iocb is actually submitted.
> 

-- 
Pavel Begunkov
