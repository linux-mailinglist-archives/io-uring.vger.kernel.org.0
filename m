Return-Path: <io-uring+bounces-2809-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB08E955381
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 00:49:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD8091C21448
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 22:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD77D140E29;
	Fri, 16 Aug 2024 22:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oqjn9jJJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D4D13FD84
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 22:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723848557; cv=none; b=FIYqO7FF7YQCMlZgzE8N4J3eJSpLk/BG+YWK5Yx7Sr1XjKObiIZeTMSVvhp7dq4TL0h1Jh5SeRZ3H6P+4Evs6avE9eC30j9AKTbZaXEmAriJLt6vTB3P/hbYsS4cPqtYLLL21LHXwDi4v3u3aniB/Zpk/hkaoC2mmzzjgKsIWYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723848557; c=relaxed/simple;
	bh=euLjOw7zaFfPVKztl78UejuABhIuP+Lpgt7X7nsKHbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gt3M1s2HDXZCxqa/nw1dd0/+1fshwgDHar+V3h9sH47BmdFbL9o+kL+bXjjZazm8CyglAXfEuckvFrhK6ZcLrOJibYFWsnlrmmJd+1wYzpIhXoo4qIw3D+ShrI/V2X0k3286JgvS+AKl0vFh54gtCGHxx3PSPzTBKGgG3krc+X4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oqjn9jJJ; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-70d2cd07869so115836b3a.0
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 15:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723848553; x=1724453353; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PhTHBp9fv94Qa7YsNVXxFPtP+rjaQFMEtmANvYYXhIk=;
        b=oqjn9jJJO75qFP9BkJY4Z9J8SwhEVEBk6PwqkFEtOG9yNbxla+NhjSRxT913m9V7Fc
         HueDx2knz6Bi3cjofgfOyFG5FPG9M807D1SlznaQRPyCtBzKc0XicLH51ZLhgO+RSdSV
         dlqrn0iAdKYRj7q1asLVGF07XGYzTc5ivKomwDfudigdc+Gnht3aO13f3UqR5L/C1WEZ
         IGNw+LLTxweRswC/I98sFieXBPRvB9BqtjH6mUFc8aIA4I56VtRZ3jtr28QIuNddwtbd
         OZjYXTdxJxi2v+kauc8OORi9Urc7AL2zvCBaGx5Vn3p3aQAAm/2vL2WZqVfBqWUTaShp
         9CvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723848553; x=1724453353;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PhTHBp9fv94Qa7YsNVXxFPtP+rjaQFMEtmANvYYXhIk=;
        b=RqszdmE+N+WF/zDgw80+6cVqjebL7lEhUCvzaUTEdtKDi312lkODqHuZ0vaxnRy1JO
         hhIx3rCXRBRn4Kvg/XFl6XWxJy8ZvX4ffZmIvzMWoOmrB9lTxI6ygLw4b0ku9ZeMtcsX
         HYI7thOb+ZdtKT8UZuXSg2u4CC85IkuxKVbQ3cV1pbFAY0e7NlW4HhdZeQlyhSuo2qAJ
         Sx4YNN43pLz+sG+xkkUu2x049JCf7wvH8hkciTaryC/bLLWNLT7NoK/2aDEIJ/2b2uXY
         Wp6Jsydvfzwr5l4jLEHbYS+TCxFMDAY+OM9Z6wwB7v21Cbb8aFs3nCJ1T09krhbYMJhj
         y2Yg==
X-Forwarded-Encrypted: i=1; AJvYcCXIjQVIxwun6s5ynrySs/0Xeioipet6YGGbVDcwHZP5RosY9F/+uc6t9vpvxOq6EUu2aUY37JBbDw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyB+7kGDboTCro+jaB20JBS93d4UqoYUWPt/iofPLYN86Z0aW2P
	VIiKZnnIXKeQDO/HAhgLiiuOoZSUR9Ee5PbW7R/i9FxkupRgTM+BnVcgKOa7XN4=
X-Google-Smtp-Source: AGHT+IGi1DJWgbsm3AvNnPiu1j9zB1a7xIwckkAR3UxXUyTj/cqpMeciO1fhMvaFCFGik3kO+RVxYQ==
X-Received: by 2002:a17:90a:d517:b0:2d3:c488:fa6b with SMTP id 98e67ed59e1d1-2d3e151f6d8mr2833689a91.5.1723848553259;
        Fri, 16 Aug 2024 15:49:13 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d3e3c74f3fsm2459339a91.46.2024.08.16.15.49.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 15:49:12 -0700 (PDT)
Message-ID: <0c15e397-766f-4da7-a851-bb776ca25ab8@kernel.dk>
Date: Fri, 16 Aug 2024 16:49:11 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v1] Add io_uring_iowait_toggle()
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20240816224015.1154816-1-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240816224015.1154816-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/16/24 4:40 PM, David Wei wrote:
> diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
> index 5e4121b..c06050a 100644
> --- a/man/io_uring_enter.2
> +++ b/man/io_uring_enter.2
> @@ -104,6 +104,11 @@ If the ring file descriptor has been registered through use of
>  then setting this flag will tell the kernel that the
>  .I ring_fd
>  passed in is the registered ring offset rather than a normal file descriptor.
> +.TP
> +.B IORING_ENTER_NO_IOWAIT
> +If this flag is set, then in_iowait will not be set for the current task if
> +.BR io_uring_enter (2)
> +results in waiting.

I'd probably would say something ala:

If this flag is set, then waiting on events will not be accounted as
iowait for the task if
.BR io_uring_enter (2)
results in waiting.

or something like that. io_iowait is an in-kernel thing, iowait is what
application writers will know about.

> +.B #include <liburing.h>
> +.PP
> +.BI "int io_uring_iowait_toggle(struct io_uring *" ring ",
> +.BI "                            bool " enabled ");"
> +.BI "
> +.fi
> +.SH DESCRIPTION
> +.PP
> +The
> +.BR io_uring_iowait_toggle (3)
> +function toggles for a given
> +.I ring
> +whether in_iowait is set for the current task while waiting for completions.
> +When in_iowait is set, time spent waiting is accounted as iowait time;
> +otherwise, it is accounted as idle time. The default behavior is to always set
> +in_iowait to true.

And ditto here

> +Setting in_iowait achieves two things:
> +
> +1. Account time spent waiting as iowait time
> +
> +2. Enable cpufreq optimisations, setting SCHED_CPUFREQ_IOWAIT on the rq

This should probably be something ala:

Setting in_iowait achieves two things:
.TP
.B Account time spent waiting as iowait time
.TP
.B Enable cpufreq optimisations, setting SCHED_CPUFREQ_IOWAIT on the rq
.PP

to make that format like a man page.

> +Some user tooling attributes iowait time as CPU utilization time, so high
> +iowait time can look like apparent high CPU utilization, even though the task
> +is not scheduled and the CPU is free to run other tasks.  This function
> +provides a way to disable this behavior where it makes sense to do so.

And here. Since this is the main man page, maybe also add something
about how iowait is a relic from the old days of only having one CPU,
and it indicates that the task is block uninterruptibly waiting for IO
and hence cannot do other things. These days it's mostly a bogus
accounting value, but it does help with the cpufreq boost for certain
high frequency waits. Rephrase as needed :-)

> diff --git a/src/queue.c b/src/queue.c
> index c436061..bd2e6af 100644
> --- a/src/queue.c
> +++ b/src/queue.c
> @@ -110,6 +110,8 @@ static int _io_uring_get_cqe(struct io_uring *ring,
>  
>  		if (ring->int_flags & INT_FLAG_REG_RING)
>  			flags |= IORING_ENTER_REGISTERED_RING;
> +		if (ring->int_flags & INT_FLAG_NO_IOWAIT)
> +			flags |= IORING_ENTER_NO_IOWAIT;
>  		ret = __sys_io_uring_enter2(ring->enter_ring_fd, data->submit,
>  					    data->wait_nr, flags, data->arg,
>  					    data->sz);

Not strictly related, and we can always do that after, but now we have
two branches here. Since the INT flags are purely internal, we can
renumber them so that INT_FLAG_REG_RING matches
IORING_ENTER_REGISTERED_RING and INT_FLAG_NO_IOWAIT matches
IORING_ENTER_NO_IOWAIT. With that, you could kill the above two branches
and simply do:

	flags |= (ring->int_flags & INT_TO_ENTER_MASK);

which I think would be a nice thing to do.

Rest looks good, no further comments.

-- 
Jens Axboe


