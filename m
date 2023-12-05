Return-Path: <io-uring+bounces-242-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA582806137
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 23:01:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 748F71F21579
	for <lists+io-uring@lfdr.de>; Tue,  5 Dec 2023 22:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2836FCEB;
	Tue,  5 Dec 2023 22:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bBfJuRYU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0D61B1
	for <io-uring@vger.kernel.org>; Tue,  5 Dec 2023 14:00:56 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6ce3281a307so420622b3a.0
        for <io-uring@vger.kernel.org>; Tue, 05 Dec 2023 14:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701813655; x=1702418455; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9VBn/3W7GTUNEUnK0A6sA01SP1HM7jAJH+Uilj5iVf0=;
        b=bBfJuRYUNxRg9m8jV4u1MR6/ZtlMpWo+rhgKUyV/MKMrojtcnA8tS7DZdVz82Dvy1W
         xA1mbBQ/XoXH4RLg+h/PXGXgd9B/rfWnQgHkmUCa3gJJzH+GY/HsEHZZLCN1N8LD2VFb
         DHSRra155pt26llwc7IWb9e8HsCXY2/xwiHtBsp+7Eg31hbu+TMF3jvKeBazjAh2RVEo
         iIJWAftpa47qr8vR1Qer/uoJyd21ayEvhfCdiAX+q7TUh8hN+RXll5UplIHhlofoY16M
         P1u5ARxlNBQBSJkhuOE+TAyJtaPg/XG7rbed+DxcsWsUSFIP3HIz9wM11YaErZbVRiBN
         qCPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701813655; x=1702418455;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9VBn/3W7GTUNEUnK0A6sA01SP1HM7jAJH+Uilj5iVf0=;
        b=Z1NRVCX/khy74amAeoPYzrseSF0h0iZGnRCMF2kDqM8X9xPosuij/9PZ8bZDpBCCuR
         eN3cWbGq52N1R/M5JLx/dRjcU0phW0AXxDk09/UaVc87Y3XiKwg4hIRp27UFZ9CzKEUp
         GlzXTtEAZz0jwU4tXT8D+w9iBd6obkpyVyUCvTpxLvVLZ/PIy7x0SXMBmM7YbblnW/rj
         gbLj9a7WMmcYd6ZPU4sE4CnOA67DHt2qoLPgGmu1Y3DkL45gwfaZkzK9xbL9iDwS/Gxm
         35O/3fgXnCGLYeYMQDMWyK4TeQRU89S28rKxPSOrwrwJgLVUR5UgpV+WD0kNeX0AjOE2
         rPoA==
X-Gm-Message-State: AOJu0YyGS6mAysqKMjF/7tlN+Nw6d75AWS0+qe92VmEbTLBGd3crcW8i
	9HgfBKGmpxfGIwaKV8M+J8tfV/edh8eW7evqX3/2Ow==
X-Google-Smtp-Source: AGHT+IGYvg1q9wSDxW0/gRVOC8fUmmqmFNIXFEULigN4wUG4Ze/sR/eQuNP9sJWUFDE9Vb2YEKcIZQ==
X-Received: by 2002:a05:6a00:3904:b0:68e:2fd4:288a with SMTP id fh4-20020a056a00390400b0068e2fd4288amr44053839pfb.3.1701813655479;
        Tue, 05 Dec 2023 14:00:55 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id x15-20020a056a00270f00b006ce3bf7acc7sm5562198pfv.113.2023.12.05.14.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 14:00:54 -0800 (PST)
Message-ID: <43ff7474-5174-4738-88d9-9c43517ae235@kernel.dk>
Date: Tue, 5 Dec 2023 15:00:52 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: save repeated issue_flags
Content-Language: en-US
To: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org
Cc: asml.silence@gmail.com, Keith Busch <kbusch@kernel.org>
References: <20231205215553.2954630-1-kbusch@meta.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231205215553.2954630-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/5/23 2:55 PM, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> No need to rebuild the issue_flags on every IO: they're always the same.
> 
> Suggested-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  include/linux/io_uring_types.h |  1 +
>  io_uring/io_uring.c            | 15 ++++++++++++---
>  io_uring/uring_cmd.c           |  8 +-------
>  3 files changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index bebab36abce89..dd192d828f463 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -228,6 +228,7 @@ struct io_ring_ctx {
>  	/* const or read-mostly hot data */
>  	struct {
>  		unsigned int		flags;
> +		unsigned int		issue_flags;
>  		unsigned int		drain_next: 1;
>  		unsigned int		restricted: 1;
>  		unsigned int		off_timeout_used: 1;
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 1d254f2c997de..a338e3660ecb8 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3975,11 +3975,20 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
>  	 * polling again, they can rely on io_sq_thread to do polling
>  	 * work, which can reduce cpu usage and uring_lock contention.
>  	 */
> -	if (ctx->flags & IORING_SETUP_IOPOLL &&
> -	    !(ctx->flags & IORING_SETUP_SQPOLL))
> -		ctx->syscall_iopoll = 1;
> +	if (ctx->flags & IORING_SETUP_IOPOLL) {
> +		ctx->issue_flags |= IO_URING_F_SQE128;
> +		if (!(ctx->flags & IORING_SETUP_SQPOLL))
> +			ctx->syscall_iopoll = 1;
> +	}

This does not look correct?

>  	ctx->compat = in_compat_syscall();
> +	if (ctx->compat)
> +		ctx->issue_flags |= IO_URING_F_COMPAT;
> +	if (ctx->flags & IORING_SETUP_SQE128)
> +		ctx->issue_flags |= IO_URING_F_SQE128;
> +	if (ctx->flags & IORING_SETUP_CQE32)
> +		ctx->issue_flags |= IO_URING_F_CQE32;
> +
>  	if (!ns_capable_noaudit(&init_user_ns, CAP_IPC_LOCK))
>  		ctx->user = get_uid(current_user());
>  
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 8a38b9f75d841..dbc0bfbfd0f05 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -158,19 +158,13 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>  	if (ret)
>  		return ret;
>  
> -	if (ctx->flags & IORING_SETUP_SQE128)
> -		issue_flags |= IO_URING_F_SQE128;
> -	if (ctx->flags & IORING_SETUP_CQE32)
> -		issue_flags |= IO_URING_F_CQE32;
> -	if (ctx->compat)
> -		issue_flags |= IO_URING_F_COMPAT;
>  	if (ctx->flags & IORING_SETUP_IOPOLL) {
>  		if (!file->f_op->uring_cmd_iopoll)
>  			return -EOPNOTSUPP;
> -		issue_flags |= IO_URING_F_IOPOLL;
>  		req->iopoll_completed = 0;
>  	}
>  
> +	issue_flags |= ctx->issue_flags;
>  	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
>  	if (ret == -EAGAIN) {
>  		if (!req_has_async_data(req)) {

I obviously like this idea, but it should be accompanied by getting rid
of ->compat and ->syscall_iopoll in the ctx as well?

-- 
Jens Axboe


