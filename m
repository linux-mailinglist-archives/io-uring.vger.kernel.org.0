Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D189C4A8BDF
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 19:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353566AbiBCStP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 13:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344973AbiBCStO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 13:49:14 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583F6C061714
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 10:49:14 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id z18so2914103ilp.3
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 10:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yi3egB09pFMWmxHf611BRU+6JQL5GH8GclXypo1awkA=;
        b=FOEUsa6cMLCKHgbftb7PdZxjMzaJLyhqXu6zE6/HGBcw8UJivONwkKRHJFIpKG+4Cp
         5EAmoc5HXHDkp83ffol1bLsFixng5fqDrZltIRRmYBTGNu4Qp852viJt229/q1C7oIP1
         QTT40oAxbDZZ9/Z8IJG8kW8p8XHWcvLRMV2mq4knwnCDoBzfVG+TFoc+G/5Bi2V3oNN1
         83QK+vwB9In+wtpEKYYAg4R8pxdjSdNop27G7bzxPLlddks+j/MOfPiYg409nMtC7sFW
         7vy18PnE3zDHNlH4CFTB2hAeTITqVooJMPS0CVv95WOnspP411cmJIAGf4fiM4jrUrUE
         U5cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yi3egB09pFMWmxHf611BRU+6JQL5GH8GclXypo1awkA=;
        b=x4Ce146r3Hx/7/zZuGHfO5ifJ4AypcJe2smWsF/mczMlQaO4yWFKYFuGeBa8zhB3eg
         Ruu3B8TV7TsmEpazjgVhV5cfgGg8odKcRzpHNsng6I8y85OvbqcjFbZeMPwW8Hx+sIxA
         6B30ZTm6IHfbTHEU5WwkbYzwrQ+JR/rIXGq4xah64f/oy1Q2hbcYUD5E/e4K+uY08mOk
         PUgSZuGhXFxnzwVKHipH2L+vjCihF9FAElsSdp7ngQLm7drjLKpaH3ytRG5mBVLqdzyT
         H+iTeDQth51ZxdzCvz3JvhjmZaKLUy5pJGk/Q2RwB3nRTp9NRMEz/YwApMYv/lcAV53+
         okNA==
X-Gm-Message-State: AOAM530lAVz5888g66XsVe9I3u1DAUt6nmAsl5K121/VtS9EBdft2TeB
        MMtMX50P72i9j2ibj/e1UoOkzoj8A9MZgA==
X-Google-Smtp-Source: ABdhPJxywet9ivYWSQd29dwPDGsnX7LDLyVALsSiuN7w1UFAK+QVCH6KFeaNVsIG+kc7Qf70PKeZvA==
X-Received: by 2002:a05:6e02:1545:: with SMTP id j5mr21032614ilu.318.1643914153612;
        Thu, 03 Feb 2022 10:49:13 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f4sm11634988iow.53.2022.02.03.10.49.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 10:49:13 -0800 (PST)
Subject: Re: [PATCH v4 2/3] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
To:     Usama Arif <usama.arif@bytedance.com>, io-uring@vger.kernel.org,
        asml.silence@gmail.com, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203182441.692354-1-usama.arif@bytedance.com>
 <20220203182441.692354-3-usama.arif@bytedance.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8369e0be-f922-ba6b-ceed-24886ebcdb78@kernel.dk>
Date:   Thu, 3 Feb 2022 11:49:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220203182441.692354-3-usama.arif@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 11:24 AM, Usama Arif wrote:
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

This still needs what we discussed in v3, something ala:

/*
 * This will potential race with eventfd registration, but that's
 * always going to be the case if there is IO inflight while an eventfd
 * descriptor is being registered.
 */
if (!rcu_dereference_raw(ctx->io_ev_fd))
	return;

rcu_read_lock();
...

which I think is cheap enough and won't hit sparse complaints. The

> @@ -9353,35 +9370,70 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
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
> +	if (rcu_dereference_protected(ctx->io_ev_fd, lockdep_is_held(&ctx->ev_fd_lock))) {
> +		rcu_barrier();
> +		if(rcu_dereference_protected(ctx->io_ev_fd, lockdep_is_held(&ctx->ev_fd_lock)))
> +			goto out;
> +	}

I wonder if we can get away with assigning ctx->io_ev_fd to NULL when we
do the call_rcu(). The struct itself will remain valid as long as we're
under rcu_read_lock() protection, so I think we'd be fine? If we do
that, then we don't need any rcu_barrier() or synchronize_rcu() calls,
as we can register a new one while the previous one is still being
killed.

Hmm?

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
> +	if (ev_fd) {
> +		call_rcu(&ev_fd->rcu, io_eventfd_put);
> +		ret = 0;
> +		goto out;
>  	}
> +	ret = -ENXIO;
>  
> -	return -ENXIO;
> +out:
> +	mutex_unlock(&ctx->ev_fd_lock);
> +	return ret;
>  }

I also think that'd be cleaner without the goto:

{
	struct io_ev_fd *ev_fd;
	int ret;

	mutex_lock(&ctx->ev_fd_lock);
	ev_fd = rcu_dereference_protected(ctx->io_ev_fd,
					lockdep_is_held(&ctx->ev_fd_lock));
	if (ev_fd) {
		call_rcu(&ev_fd->rcu, io_eventfd_put);
		mutex_unlock(&ctx->ev_fd_lock);
		return 0;
	}

	mutex_unlock(&ctx->ev_fd_lock);
	return -ENXIO;
}

-- 
Jens Axboe

