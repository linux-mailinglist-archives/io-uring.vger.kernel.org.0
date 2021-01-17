Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6562F902A
	for <lists+io-uring@lfdr.de>; Sun, 17 Jan 2021 03:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbhAQCOD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 21:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbhAQCNv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 21:13:51 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0096C061573
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 18:13:11 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id 11so8036293pfu.4
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 18:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=8x4mzxBqyOlsmeENoP0urZ3ZxPyxOjUukrW8+ULlKaA=;
        b=CDu5cykFZKsX3Pv7LSiNqfZETc5InNkKrt1lXLFFt5pF03IOlRS2xBdVjHIiYWU/iu
         7YMVTEOKvwwDxzswzNcFXo9KmY3qugmmZD1ByvzGFO8JKjpdULgkQebD7FRnK1MRJ1j3
         CMCfyLisGZCrEcUIi4V83O+gSGTZdaq2ReCIHr9pKN2dttAh+JpJ66nDw1iuET0ZL1cT
         /r1EC+NWIF9ty7k44VkgSP5BRhgJGGPmF2WbEJOZi7HIxJrZpcIqJPG7+rbZEtTapoej
         qF4T8FIouXZkqc1GSX1p7AUtSCUq/uwL2ikaa8YqeCppGDoR+oeVHwkJU3tPUgHMfV1q
         ShBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8x4mzxBqyOlsmeENoP0urZ3ZxPyxOjUukrW8+ULlKaA=;
        b=skVZpvVIo1ChhKN7+1izbxjH9X4ljRV9s4lS7sXZrDEn5KB9aGjTW+/HYzzIYGJuSQ
         iT+gYn7mGaAtRSMeXsBGnzWk6GS1cnTEfKtWLAP16vo8/uzIJV++w5UEWqsUcR03xT8+
         HgzvBGhSmhmB9Aa8xHkggrgVcJCze58e1jLa4mBqZVLjnFlynEJvHd4gZkBUYPWkakBm
         hxfMLWYpzpwIq0+6LMxedKinA0o/qCltp0P7P44iWb9SNriQ3LylL2ZU1BoyqNVn8jwL
         yt3IH857f89ZJxNVpihTp2khDduVvnME34eqI2tsDk1coyzPA0iKUcSfcTvYG1JkPErN
         26jw==
X-Gm-Message-State: AOAM532cpNLWF4BLarmqz+dXi19LWRzX2jXXPo0HnaIVyHQi74gM2LDo
        zlN5zRSPdsAaZ22CiYi2SlpDOYlWSwwzlA==
X-Google-Smtp-Source: ABdhPJydgy80LOTdRcJXgLzHEcIXt4pQnLL29887Mq3DZPde6bF4oLWJl8bmB8s9aMgvWHYho1AxeQ==
X-Received: by 2002:a63:3086:: with SMTP id w128mr19661381pgw.227.1610849590708;
        Sat, 16 Jan 2021 18:13:10 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 193sm12572589pfz.36.2021.01.16.18.13.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 18:13:10 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix skipping disabling sqo on exec
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <3148c408259dd9f2e12a1877cbe8ca9c29325c5a.1610840103.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <90886010-75ca-4468-0fff-61d330ed795a@kernel.dk>
Date:   Sat, 16 Jan 2021 19:13:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3148c408259dd9f2e12a1877cbe8ca9c29325c5a.1610840103.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/21 4:37 PM, Pavel Begunkov wrote:
> If there are no requests at the time __io_uring_task_cancel() is called,
> tctx_inflight() returns zero and and it terminates not getting a chance
> to go through __io_uring_files_cancel() and do
> io_disable_sqo_submit(). And we absolutely want them disabled by the
> time cancellation ends.
> 
> Also a fix potential false positive warning because of ctx->sq_data
> check before io_disable_sqo_submit().
> 
> Reported-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> To not grow diffstat now will be cleaned for-next
> 
>  fs/io_uring.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d494c4269fc5..0d50845f1f3f 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8937,10 +8937,12 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
>  {
>  	struct task_struct *task = current;
>  
> -	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
> +	if (ctx->flags & IORING_SETUP_SQPOLL) {
>  		/* for SQPOLL only sqo_task has task notes */
>  		WARN_ON_ONCE(ctx->sqo_task != current);
>  		io_disable_sqo_submit(ctx);
> +	}
> +	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
>  		task = ctx->sq_data->thread;
>  		atomic_inc(&task->io_uring->in_idle);
>  		io_sq_thread_park(ctx->sq_data);

Maybe just nest that inside?

	if (ctx->flags & IORING_SETUP_SQPOLL) {
  		/* for SQPOLL only sqo_task has task notes */
  		WARN_ON_ONCE(ctx->sqo_task != current);
  		io_disable_sqo_submit(ctx);
		if (ctx->sq_data) {
			...
		}
	}

That'd look a bit cleaner imho.
 
-- 
Jens Axboe

