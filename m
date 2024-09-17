Return-Path: <io-uring+bounces-3216-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC71497AA6C
	for <lists+io-uring@lfdr.de>; Tue, 17 Sep 2024 05:09:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C1802842E3
	for <lists+io-uring@lfdr.de>; Tue, 17 Sep 2024 03:09:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25CF31B813;
	Tue, 17 Sep 2024 03:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2YCg2V5w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2538115AF6
	for <io-uring@vger.kernel.org>; Tue, 17 Sep 2024 03:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726542564; cv=none; b=SFeKdoPQ9WWgdbcwfIzUE00szCAl4hxsMgm9BYp4MI3UZxeVzEngcIBDzH2gO9k50HRalCtuGR2lSVgg52OhqHe3j7cnNERkstqzhfbkwF/B0s83YXaZwoKdVv55ywd8M5Vl2yBLUXgHfC7WkRV5qQwfdqiJtRANVpg3r8Osmo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726542564; c=relaxed/simple;
	bh=GsfFGlZVFyY3dH3763/MmRF9WLxYqrO9bXL/bCos/gc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tcxEIl6nQd6msVCRERdre/pNgiIoc3TzASnzXsrUZLhOzR2fLE6OIS9AVQJIMrgynnUU4v6Qg0wgDaYnGgrILk8NIDBbx7pxf554Qy12sceAR7o8to680RQKeiB0qm27Bf+ZzBzjXx2EI/2P53kf7eFL/SxAfzlv8QyMIxr6qxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2YCg2V5w; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-42cbface8d6so51564655e9.3
        for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 20:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726542559; x=1727147359; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7QD4ri58b5hFO4z+hGDUx/5fc+0h9Nk/u6c1uOqQNfc=;
        b=2YCg2V5woRSqxg8VR2vLuzwiqu+lK3g3NDD4mc8oIYq2G2vY5iUP+0dalbtyKIsUPV
         Z5MePFTHMd0kQS9+8BktaZujpZ/ajan5ZEg+zLMb9VG0cGxGzHyJdbiaOWZDz71tKfho
         DW6GpPimXAW5FXXiujvfdEAgXFYekrmRhPNyHWRtqmZ4xp0NGHDT//tecphxHSaC11FI
         2h03euZTlW+0oDuJNYlOZVqESFvyzbJsaSigtyIROsvBrx1YbNXWJcvuEkE7pjusQmbn
         5JnKXlc8kYFeF7eRBTveProz2CKtwp8PeYQqhqJWWAQbF3DJlrLbtap3FueFBa9jhbx0
         pwSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726542559; x=1727147359;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7QD4ri58b5hFO4z+hGDUx/5fc+0h9Nk/u6c1uOqQNfc=;
        b=rtX0zjm+xO6E+xgQNSlstggxnJLZSr2D3OQhwKbrEL2I0hVlmjcdPm8RAKGAtUYoCs
         jUWpBTmVLr2D01otz+lWdCJgB+IuEux7+qPtqHpvjBHivUp+dGWbEhqk9T7Ao8hGpVyo
         an6naSJ9EPV1K+KM7guTmTCOh3hYY9tNJG4plR4UfOJcqDEZSf2spUd/Cpi9tu6GFzIn
         uwewV4sJseiUyo/5iCruvbU7OjhEkgefvdRVC4mumlSXkntlPOqi2XUP1XQrmgVFCkbJ
         w5kr8WLgBeDnOwNRPmaKA5rEadZ0nTfa5rShzvJSLPqLuExJGw+0wcv/hVtUCactIwD7
         te3g==
X-Forwarded-Encrypted: i=1; AJvYcCU6Ahu7INkpHOqLuRBoBbYKfuMW+7tptMYDuFM2wuQK8nPRjBaqg8U3e+5BRa4g+8AKpQABqtXaiw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbelSb1yuBY0zxaZdxIuHd2SgDYErvtSUo7JX5Pjku16B55f5U
	LjwJPq+5EiXXKGnShiH0Akh5qXddjuu1pngfwC0ASdHVDYapr9YIxEeMSxNBYd/Z6/i2s4uogmD
	AsNSjZAkx
X-Google-Smtp-Source: AGHT+IEmYtm6DRpTHxD9hx9lXya6pvP0RJb0a7Dl9y+BL7dAmEfsDG1ZJFEGaOPc12krm15x7yBOtg==
X-Received: by 2002:adf:f888:0:b0:374:d254:61b3 with SMTP id ffacd0b85a97d-378d61e2551mr11373579f8f.14.1726542559352;
        Mon, 16 Sep 2024 20:09:19 -0700 (PDT)
Received: from [192.168.0.216] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378e78044easm8442730f8f.91.2024.09.16.20.09.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Sep 2024 20:09:18 -0700 (PDT)
Message-ID: <c676d789-6ed7-4855-8ace-df6a82460fdf@kernel.dk>
Date: Mon, 16 Sep 2024 21:09:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] io_uring/napi: add static napi tracking strategy
To: Olivier Langlois <olivier@trillion01.com>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1726354973.git.olivier@trillion01.com>
 <cd6dc57659b7fe0417189b2d019ba7c5a290c34c.1726354973.git.olivier@trillion01.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cd6dc57659b7fe0417189b2d019ba7c5a290c34c.1726354973.git.olivier@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/16/24 1:20 PM, Olivier Langlois wrote:
> add the static napi tracking strategy that allows the user to manually
> manage the napi ids list to busy poll and offload the ring from
> dynamically update the list.

I like this, I suspect for many cases this is all you will need rather
than try and dynamically track multiple instances.

Away for the next week or so, so won't have time to do a proper review
until I'm back. Timing wise this doesn't matter too much as the 6.12
merge window is currently open, hence we cannot target this to anything
sooner than 6.13. So we have time to get this reviewed and queued up.

A few minor comments below.

> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index adc2524fd8e3..10d9030c4242 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -728,12 +728,40 @@ struct io_uring_buf_status {
>  	__u32	resv[8];
>  };
>  
> +enum io_uring_napi_op {
> +	/* register/ungister backward compatible opcode */
> +	IO_URING_NAPI_REGISTER_OP = 0,
> +
> +	/* opcodes to update napi_list when static tracking is used */
> +	IO_URING_NAPI_STATIC_ADD_ID = 1,
> +	IO_URING_NAPI_STATIC_DEL_ID = 2
> +};
> +
> +enum io_uring_napi_tracking_strategy {
> +	/* value must be 0 for backward compatibility */
> +	IO_URING_NAPI_TRACKING_DYNAMIC = 0,
> +	IO_URING_NAPI_TRACKING_STATIC = 1,
> +	IO_URING_NAPI_TRACKING_INACTIVE = 255
> +};

I think this is a fine way to do it, retaining compatability with what
we have now on the registration side.

>  /* argument for IORING_(UN)REGISTER_NAPI */
>  struct io_uring_napi {
>  	__u32	busy_poll_to;
>  	__u8	prefer_busy_poll;
> -	__u8	pad[3];
> -	__u64	resv;
> +
> +	/* a io_uring_napi_op value */
> +	__u8	opcode;
> +	__u8	pad[2];
> +
> +	/*
> +	 * for IO_URING_NAPI_REGISTER_OP, it is a
> +	 * io_uring_napi_tracking_strategy value.
> +	 *
> +	 * for IO_URING_NAPI_STATIC_ADD_ID/IO_URING_NAPI_STATIC_DEL_ID
> +	 * it is the napi id to add/del from napi_list.
> +	 */
> +	__u32	op_param;
> +	__u32	resv;
>  };

Looks good too.

> +static void common_tracking_show_fdinfo(struct io_ring_ctx *ctx,
> +					struct seq_file *m,
> +					const char *tracking_strategy)
> +{
> +	seq_puts(m, "NAPI:\tenabled\n");
> +	seq_printf(m, "napi tracking:\t%s\n", tracking_strategy);
> +	seq_printf(m, "napi_busy_poll_dt:\t%llu\n", ctx->napi_busy_poll_dt);
> +	if (ctx->napi_prefer_busy_poll)
> +		seq_puts(m, "napi_prefer_busy_poll:\ttrue\n");
> +	else
> +		seq_puts(m, "napi_prefer_busy_poll:\tfalse\n");
> +}
> +
> +static void napi_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
> +{
> +	switch (READ_ONCE(ctx->napi_track_mode)) {
> +	case IO_URING_NAPI_TRACKING_INACTIVE:
> +		seq_puts(m, "NAPI:\tdisabled\n");
> +		break;
> +	case IO_URING_NAPI_TRACKING_DYNAMIC:
> +		common_tracking_show_fdinfo(ctx, m, "dynamic");
> +		break;
> +	case IO_URING_NAPI_TRACKING_STATIC:
> +		common_tracking_show_fdinfo(ctx, m, "static");
> +		break;
> +	}
> +}

Maybe add an "unknown" default entry here, just in case it ever changes
and someone forgets to update the fdinfo code.

> +static inline bool __io_napi_do_busy_loop(struct io_ring_ctx *ctx,
> +					  void *loop_end_arg)
> +{
> +	if (READ_ONCE(ctx->napi_track_mode) == IO_URING_NAPI_TRACKING_STATIC)
> +		return static_tracking_do_busy_loop(ctx, loop_end_arg);
> +	else
> +		return dynamic_tracking_do_busy_loop(ctx, loop_end_arg);
> +}
> +

Minor style nit:

	if (READ_ONCE(ctx->napi_track_mode) == IO_URING_NAPI_TRACKING_STATIC)
		return static_tracking_do_busy_loop(ctx, loop_end_arg);
	return dynamic_tracking_do_busy_loop(ctx, loop_end_arg);

would do.

-- 
Jens Axboe

