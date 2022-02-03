Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6657D4A8B04
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 18:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238071AbiBCR47 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 12:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbiBCR46 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 12:56:58 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1667C06173B
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 09:56:58 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id r144so4223423iod.9
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 09:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QBQw4YaYAvigQAPD4ZL0nY/1iT625q+QNDy6YJwrySk=;
        b=YDmMmk2pG/yQ5AlcbYAlR6g02JmqXkdvWui9gp8rRkImqihSgKfmox2DvV5WF4W3hZ
         tLsl7QwNxjas7mdPCS347odQfyi9VY4oS1+XSFKiMp6jJDm1Yd09aw89trz+dsbnFT0y
         wv+lrb50Lozq/hoNPHgLsjgcc9V4KJJqMOQ4K00dJbxx45zhiqmrXHvjpAgD9lkn5VYi
         shTODxNPaLvUYXc+pbX3oJ7GYb6GmBDPAkxZ9PBYwTiBRH6YviNRhP0oRapyua+v4Q7d
         YcvwQENTbsTsV+eofp3kMMPwmkl+JqCJODI534DlDi7LDXa01gld6xijyJPH30TiZo+p
         Yvhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QBQw4YaYAvigQAPD4ZL0nY/1iT625q+QNDy6YJwrySk=;
        b=FFp4YAJFQchXdNAEo/6tNFaFRbKxy69DokSnAq/se73g9Wg5TnxOuK2JttRt2jwIMf
         29iY73UWGC/SPQYLrUmdSRVc7DfIn3Wo66V5pCDJRDC6P9O0DpU5Elh4Z8IF+Dywth4e
         6x0zwrkAMHedVJTGZSn0tZCo4a/vPte0kcUINIaBtjFAGHza1KgM6j92q+9G7RfiIAp3
         NAdgeRW1+hs5cjBpXMt2FNkeiuBBFt5rixnpUM8OR4UrsBvN7Sgg+aoh9vFxe5ixixHR
         HSTteneJchSukOV1fAsmR0bOfVaayF8Ji5AhqVjtSpOOIeOLSRq4vwBwwMhVZ5aZKsn3
         vjPw==
X-Gm-Message-State: AOAM532JDZNyl0jE2Rfw5C2w6Px+FGej6IJT7GsMLUKNSweebXLLnDO8
        gpFSVO9+xsckFK3yXLW5RAWsvg==
X-Google-Smtp-Source: ABdhPJytfhjGnanyS876GVdOlq4/O2Tq31lL8ASLDN+wmxsNOJfZLP7hXhmdJJg+k7NyQFdUUP+E6w==
X-Received: by 2002:a05:6602:2a49:: with SMTP id k9mr18570929iov.83.1643911018102;
        Thu, 03 Feb 2022 09:56:58 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id r8sm13309722ilj.4.2022.02.03.09.56.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 09:56:57 -0800 (PST)
Subject: Re: [PATCH v3 2/3] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
To:     Usama Arif <usama.arif@bytedance.com>, io-uring@vger.kernel.org,
        asml.silence@gmail.com, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203174108.668549-1-usama.arif@bytedance.com>
 <20220203174108.668549-3-usama.arif@bytedance.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ffa271c7-3f49-2b5a-b67e-3bb1b052ee4e@kernel.dk>
Date:   Thu, 3 Feb 2022 10:56:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220203174108.668549-3-usama.arif@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 10:41 AM, Usama Arif wrote:
> @@ -1726,13 +1732,24 @@ static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
>  	return &rings->cqes[tail & mask];
>  }
>  
> -static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
> +static void io_eventfd_signal(struct io_ring_ctx *ctx)
>  {
> -	if (likely(!ctx->cq_ev_fd))
> -		return false;
> +	struct io_ev_fd *ev_fd;
> +
> +	rcu_read_lock();
> +	/* rcu_dereference ctx->io_ev_fd once and use it for both for checking and eventfd_signal */
> +	ev_fd = rcu_dereference(ctx->io_ev_fd);
> +
> +	if (likely(!ev_fd))
> +		goto out;
>  	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
> -		return false;
> -	return !ctx->eventfd_async || io_wq_current_is_worker();
> +		goto out;
> +
> +	if (!ctx->eventfd_async || io_wq_current_is_worker())
> +		eventfd_signal(ev_fd->cq_ev_fd, 1);
> +
> +out:
> +	rcu_read_unlock();
>  }

Like Pavel pointed out, we still need the fast path (of not having an
event fd registered at all) to just do the cheap check and not need rcu
lock/unlock. Outside of that, I think this looks fine.

>  static int io_eventfd_unregister(struct io_ring_ctx *ctx)
>  {
> -	if (ctx->cq_ev_fd) {
> -		eventfd_ctx_put(ctx->cq_ev_fd);
> -		ctx->cq_ev_fd = NULL;
> -		return 0;
> +	struct io_ev_fd *ev_fd;
> +	int ret;
> +
> +	mutex_lock(&ctx->ev_fd_lock);
> +	ev_fd = rcu_dereference_protected(ctx->io_ev_fd, lockdep_is_held(&ctx->ev_fd_lock));
> +	if (!ev_fd) {
> +		ret = -ENXIO;
> +		goto out;
>  	}
> +	synchronize_rcu();
> +	eventfd_ctx_put(ev_fd->cq_ev_fd);
> +	kfree(ev_fd);
> +	rcu_assign_pointer(ctx->io_ev_fd, NULL);
> +	ret = 0;
>  
> -	return -ENXIO;
> +out:
> +	mutex_unlock(&ctx->ev_fd_lock);
> +	return ret;
>  }

synchronize_rcu() can take a long time, and I think this is in the wrong
spot. It should be on the register side, IFF we need to expedite the
completion of a previous event fd unregistration. If we do it that way,
at least it'll only happen if it's necessary. What do you think?

-- 
Jens Axboe

