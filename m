Return-Path: <io-uring+bounces-2859-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB72895909F
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 00:45:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FE0028506E
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 22:45:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1221C14B94B;
	Tue, 20 Aug 2024 22:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SvNr7e44"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41CFE14AD38
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 22:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724193944; cv=none; b=HnSaHdbXHrYjyzRKD/tN+rA1mEP1sJWMCWDRPZNIoGz7/Zpdh+qL/YMF8GI8LIPrJM7wrbYrzWvo4Kbgpf/IzUFDqMXGz8gPouTsZPZPQvRcaAhEva7U2OGqO42Zr4ytiJcH+UHSHdiF80ig7ATnkEfFAU1JKjHTm9xMWZ5WJCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724193944; c=relaxed/simple;
	bh=7UPtdTOjB7hfvr6mm6siuD9USQbLxxtNjzSt9ezxbd4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kjh4QguyU012Icg60gE4/3MSivRfbe+wyiDudYAhvaofGVVzvqe1lFay8RqLWn4K8Ps5LtNMABpQKkJVjDwdQ7bKXzOX+Rj5QpRw+QGVH27e4pRwJO3K/UuzyvB6Es/T66PFvYbl6cKxbQ2DZd3UGq7JEftIqZi+v0n/LGLA1Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SvNr7e44; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a7ac469e4c4so33994366b.0
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 15:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724193940; x=1724798740; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fOxexOAYoq0Ku26UrLL0NnhNIWS7ZHTGbVYU1RPFCQA=;
        b=SvNr7e44Hh62MJQ+5XiSIkdHURujWzD3lc/ac8IfSpqA43qnUMyIkZmPE7fTh1Fy5P
         WMSuiVklJTyRI9RFTmhCpe72YcMd0HZwXFo1rCSCF2VWt3Mapp4/z7TZv1G1YNYBhK6v
         tO11RkxEJ4+QM5HUYYsxEy3f66Gta+R2pLl50jI1RBlK36RnTOQuIQxxZSxx3+XcJrqP
         5IDPjzWq99E5MLMhXvqi8U0RSHRziSj5K6P5QhTsH4RPgfPuD6X5D0jgDzKfHONEpGyu
         mYeyS50DGjZLr3rSEGQyXmk5LoFwO/mZ9BgH1adzEcDWpL6AKlmSpniD4iWMZOckZGSH
         UuPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724193940; x=1724798740;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fOxexOAYoq0Ku26UrLL0NnhNIWS7ZHTGbVYU1RPFCQA=;
        b=SWYB6Ou9lVu7TyTciFik8bU+jg6uymGrWhDBb4kGuMqqQsOEf1jQVH6V69eUMtfpAD
         fi+i47jZUE/DLIkJrsffp+Y91l1UXBdSt12pICSGtZ2pBqbLEHooD88350E9CafbDvBt
         IP2tOv3BF0Mkq7gapr+u3tYCXJP7nUpynVmjKUd8WAUbd5c95c3jzuTPrvL51l4iREnt
         h6yCssfL/ihV+4Z0qJqNctfyt6YzkM99yKAMajtZCSFN+q72lM7XuhnPDrAzLQGPld2J
         uAMMIIXg42KUW9yn1AKaNLWEcxRwoh1jrFsc7ekSoUStq2K+A+MpKsRs3wlOPVjW8O4t
         z+Tg==
X-Forwarded-Encrypted: i=1; AJvYcCXobZg5pz5Sp+mgVXHDvgIyplkoGLWOaYReiG9AaohmUE6tAhQAd6SrMVautd9H0QCeCtOV7kexKg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+9m4sTohyl9+DlxoMtQhEHE+iHf1ziKFYel+6vNjmyJPd5p+j
	l1j7nhxo4q7pp/Tjx9PzFXzTAjTHzV15lGxZX3h1pgMQF7vF8iw109hVOQ==
X-Google-Smtp-Source: AGHT+IFtmWDBKCBaEQ3UzY3ykcfmlp99ZeRKRhV+T44aw3G4U+NbmhJanNc4ACZvksGjP7hxBpNePQ==
X-Received: by 2002:a17:907:3d90:b0:a7a:afe8:1015 with SMTP id a640c23a62f3a-a867017ba7emr30315566b.29.1724193940043;
        Tue, 20 Aug 2024 15:45:40 -0700 (PDT)
Received: from [192.168.42.254] ([148.252.128.6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838cf0c4sm820624466b.51.2024.08.20.15.45.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 15:45:39 -0700 (PDT)
Message-ID: <abbab9cf-1249-4463-88cc-85a51399a950@gmail.com>
Date: Tue, 20 Aug 2024 23:46:08 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] io_uring: add support for batch wait timeout
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <20240819233042.230956-1-axboe@kernel.dk>
 <20240819233042.230956-5-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240819233042.230956-5-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/24 00:28, Jens Axboe wrote:
> Waiting for events with io_uring has two knobs that can be set:
> 
> 1) The number of events to wake for
> 2) The timeout associated with the event
> 
> Waiting will abort when either of those conditions are met, as expected.
> 
> This adds support for a third event, which is associated with the number
> of events to wait for. Applications generally like to handle batches of
> completions, and right now they'd set a number of events to wait for and
> the timeout for that. If no events have been received but the timeout
> triggers, control is returned to the application and it can wait again.
> However, if the application doesn't have anything to do until events are
> reaped, then it's possible to make this waiting more efficient.
> 
> For example, the application may have a latency time of 50 usecs and
> wanting to handle a batch of 8 requests at the time. If it uses 50 usecs
> as the timeout, then it'll be doing 20K context switches per second even
> if nothing is happening.
> 
> This introduces the notion of min batch wait time. If the min batch wait
> time expires, then we'll return to userspace if we have any events at all.
> If none are available, the general wait time is applied. Any request
> arriving after the min batch wait time will cause waiting to stop and
> return control to the application.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/io_uring.c | 75 +++++++++++++++++++++++++++++++++++++++------
>   io_uring/io_uring.h |  2 ++
>   2 files changed, 67 insertions(+), 10 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index ddfbe04c61ed..d09a7c2e1096 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2363,13 +2363,62 @@ static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
>   	return HRTIMER_NORESTART;
>   }
>   
> +/*
> + * Doing min_timeout portion. If we saw any timeouts, events, or have work,
> + * wake up. If not, and we have a normal timeout, switch to that and keep
> + * sleeping.
> + */
> +static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
> +{
> +	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
> +	struct io_ring_ctx *ctx = iowq->ctx;
> +
> +	/* no general timeout, or shorter, we are done */
> +	if (iowq->timeout == KTIME_MAX ||
> +	    ktime_after(iowq->min_timeout, iowq->timeout))
> +		goto out_wake;
> +	/* work we may need to run, wake function will see if we need to wake */
> +	if (io_has_work(ctx))
> +		goto out_wake;
> +	/* got events since we started waiting, min timeout is done */
> +	if (iowq->cq_min_tail != READ_ONCE(ctx->rings->cq.tail))
> +		goto out_wake;
> +	/* if we have any events and min timeout expired, we're done */
> +	if (io_cqring_events(ctx))
> +		goto out_wake;
> +
> +	/*
> +	 * If using deferred task_work running and application is waiting on
> +	 * more than one request, ensure we reset it now where we are switching
> +	 * to normal sleeps. Any request completion post min_wait should wake
> +	 * the task and return.
> +	 */
> +	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
> +		atomic_set(&ctx->cq_wait_nr, 1);

racy

atomic_set(&ctx->cq_wait_nr, 1);
smp_mb();
if (llist_empty(&ctx->work_llist))
	// wake;


> +
> +	iowq->t.function = io_cqring_timer_wakeup;
> +	hrtimer_set_expires(timer, iowq->timeout);
> +	return HRTIMER_RESTART;
> +out_wake:
> +	return io_cqring_timer_wakeup(timer);
> +}
> +


-- 
Pavel Begunkov

