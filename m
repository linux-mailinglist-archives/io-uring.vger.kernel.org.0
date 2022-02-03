Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48ED34A8817
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 16:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbiBCPzH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 10:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352019AbiBCPzH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 10:55:07 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF9EC061714
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 07:55:07 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id r144so3751579iod.9
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 07:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sNxBcrnUzMIqHhDfzP2wiPhO1LoLqeoF7Jw2MZ9+MNI=;
        b=oKHMRWDWO0uGRxpVvliCE8uKRp8QOZHl4qPxYXGRGM2akzNqOnrN8kSmQ3zrtiftxE
         Nb56OxJ9Tu/5uNdkvsfloi8ki/QwgOhVvAcS4lLf/wo5M/XyeD9c+SwW+gQIOZiy67G1
         ZI6/356KT2o+m+Y7pUw7k6+IqAngr+QsPk2vEESqLsF1wC9VE7lLPGUwMCvM6+thB2Pl
         P92N5dZarZIQR3ovhsE8uWqIhgpTKqq1dLo1FF5htqanKnZh7p0HWAbLkVZIrpAHcPmC
         RUmVJjzwIzOOtIdhv/lAh07Ht8J9Of+eBYRy/i/ez5GNuWQ7HsPYEY/BuuVtQiGzULHz
         JN+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sNxBcrnUzMIqHhDfzP2wiPhO1LoLqeoF7Jw2MZ9+MNI=;
        b=uH+d1dQVDdseR7JyCVdoyAy1j0XtcT7cRh3QZV6Skn6SVkZM9Q6R6bN31lsgq+mvJB
         fnSjnvIi4AWJGE1qiddAJm9dDsO6dNMk7Tkcc2jNhqY2AdZiKFAq9EyfPbhYn8fPy8mJ
         zwYcPOSuohzvFiwLwKYQ6jxR6krKc/MLf709t4RTf/ILx/V7u4xC0IhCR8j/Z+5XxLbM
         njK5bNDFjxa7TGda9lx/4etlHvItY11QPw3gxn5p/HutVrYKt4DHxQwkh5VHUWumKA3p
         nIi6a08PU0TC24rkSa6/9FXxeTzBUsbgMaU1x2JJZE60+RH31dcYUy15LLH041PZU30e
         sxVQ==
X-Gm-Message-State: AOAM530JU4FXPj0dkTQHk75ioB9DnQvWyJ9wBs2LXZWObKW/Qt/D/XVS
        owammZ2faxEVE2jYJg5AzTOKDg==
X-Google-Smtp-Source: ABdhPJw0vFrYXi+FK6KhD3n0kq9KqfDAEN9+uHFtqE6XmXlnJX79rnuA283Hhm1zbsLV2/cCEZA4nw==
X-Received: by 2002:a6b:310b:: with SMTP id j11mr18545878ioa.149.1643903706529;
        Thu, 03 Feb 2022 07:55:06 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m13sm733822ilh.18.2022.02.03.07.55.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 07:55:06 -0800 (PST)
Subject: Re: [PATCH 1/2] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
To:     Usama Arif <usama.arif@bytedance.com>, io-uring@vger.kernel.org,
        asml.silence@gmail.com, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203151153.574032-1-usama.arif@bytedance.com>
 <20220203151153.574032-2-usama.arif@bytedance.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <87fca94e-3378-edbb-a545-a6ed8319a118@kernel.dk>
Date:   Thu, 3 Feb 2022 08:55:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220203151153.574032-2-usama.arif@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 8:11 AM, Usama Arif wrote:
> +static void io_eventfd_signal(struct io_ring_ctx *ctx)
> +{
> +	struct io_ev_fd *ev_fd;
> +
> +	rcu_read_lock();
> +	ev_fd = rcu_dereference(ctx->io_ev_fd);
> +
> +	if (!io_should_trigger_evfd(ctx, ev_fd))
> +		goto out;
> +
> +	eventfd_signal(ev_fd->cq_ev_fd, 1);
> +out:
> +	rcu_read_unlock();
> +}

Would be cleaner as:

static void io_eventfd_signal(struct io_ring_ctx *ctx)
{
	struct io_ev_fd *ev_fd;

	rcu_read_lock();
	ev_fd = rcu_dereference(ctx->io_ev_fd);

	if (io_should_trigger_evfd(ctx, ev_fd))
		eventfd_signal(ev_fd->cq_ev_fd, 1);

	rcu_read_unlock();
}

and might be worth considering pulling in the io_should_trigger_evfd()
code rather than have it be a separate helper now with just the one
caller.

> @@ -9353,35 +9374,67 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>  
>  static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
>  {
> +	struct io_ev_fd *ev_fd;
>  	__s32 __user *fds = arg;
> -	int fd;
> +	int fd, ret;
>  
> -	if (ctx->cq_ev_fd)
> -		return -EBUSY;
> +	mutex_lock(&ctx->ev_fd_lock);
> +	ret = -EBUSY;
> +	if (rcu_dereference_protected(ctx->io_ev_fd, lockdep_is_held(&ctx->ev_fd_lock)))
> +		goto out;
>  
> +	ret = -EFAULT;
>  	if (copy_from_user(&fd, fds, sizeof(*fds)))
> -		return -EFAULT;
> +		goto out;
>  
> -	ctx->cq_ev_fd = eventfd_ctx_fdget(fd);
> -	if (IS_ERR(ctx->cq_ev_fd)) {
> -		int ret = PTR_ERR(ctx->cq_ev_fd);
> +	ret = -ENOMEM;
> +	ev_fd = kmalloc(sizeof(*ev_fd), GFP_KERNEL);
> +	if (!ev_fd)
> +		goto out;
>  
> -		ctx->cq_ev_fd = NULL;
> -		return ret;
> +	ev_fd->cq_ev_fd = eventfd_ctx_fdget(fd);
> +	if (IS_ERR(ev_fd->cq_ev_fd)) {
> +		ret = PTR_ERR(ev_fd->cq_ev_fd);
> +		kfree(ev_fd);
> +		goto out;
>  	}
> +	ev_fd->ctx = ctx;
>  
> -	return 0;
> +	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
> +	ret = 0;
> +
> +out:
> +	mutex_unlock(&ctx->ev_fd_lock);
> +	return ret;
> +}

One thing that both mine and your version suffers from is if someone
does an eventfd unregister, and then immediately does an eventfd
register. If the rcu grace period hasn't passed, we'll get -EBUSY on
trying to do that, when I think the right behavior there would be to
wait for the grace period to pass.

I do think we need to handle that gracefully, spurious -EBUSY is
impossible for an application to deal with.

> @@ -11171,8 +11226,10 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
>  	mutex_lock(&ctx->uring_lock);
>  	ret = __io_uring_register(ctx, opcode, arg, nr_args);
>  	mutex_unlock(&ctx->uring_lock);
> +	rcu_read_lock();
>  	trace_io_uring_register(ctx, opcode, ctx->nr_user_files, ctx->nr_user_bufs,
> -							ctx->cq_ev_fd != NULL, ret);
> +				rcu_dereference(ctx->io_ev_fd) != NULL, ret);
> +	rcu_read_unlock();
>  out_fput:
>  	fdput(f);
>  	return ret;

We should probably just modify that tracepoint, kill that ev_fd argument
(it makes very little sense).

-- 
Jens Axboe

