Return-Path: <io-uring+bounces-8654-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BF1CB02AA7
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 13:38:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 705EB1C23002
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 11:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11871179A7;
	Sat, 12 Jul 2025 11:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ce6teo5d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BD021FF58
	for <io-uring@vger.kernel.org>; Sat, 12 Jul 2025 11:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752320310; cv=none; b=XpNL5F0oqb/smaQjEKPhecf1PX9/wJeeOQvIjt1iJy0uNtKQVRkq1UEjGm4jIjzYM/3tIPqOnqXOW7l28jgPRQokwXBg6hw8++oUWb6XA/jAb4QLQ4qOsMoYyk/XJ81yc2T4Hg1R8WqPnUAf8JlY3RHymiwpK70mi1OhzrtKawA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752320310; c=relaxed/simple;
	bh=OyLlB/ghAPr0bz8jDksPZfTObi7hFFfG4Rw/nNiu72Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hTxG1ZnPyK71iDrDXpK8b5opk0wzloV+ct1K6ION5fj+1BSCMwk4oyrwksrkDa27Tv3lu4FUokW8xbnsofNwKcI8fNslz0WiaJloXGysR4jvLSnmvcRxq946yKxx+kg5o4L6Q7NxPf4lMvzcPRTWziP9PMnSmhliiey/q/Db5F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ce6teo5d; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-607ec30df2bso5708900a12.1
        for <io-uring@vger.kernel.org>; Sat, 12 Jul 2025 04:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752320306; x=1752925106; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vz1EdfHcEvWqKqRjGMN7WB+f+/2IxBr68QR0po7YBsY=;
        b=ce6teo5dsAaZBzUzq4P/Kv6GXBfUa4AxTapt/xmB7YmCOM7d5ncSn71RXqKel8t7+O
         2UakQzXcm/yV0Qx15CsQoxpzJL/ZYTGPWKrT0ZOHiBmRNtyaFAgfNRnD60yafix3Kbkb
         GPck3Wl1ZUzDgZykn2p3WgPQ3tcjwl6/pI8Rz2YYJbaZj5kiZqpTq34exDEzz2LuSELS
         GmyCLYaxvDOmqFLgjJL1aB7wVfH+Egh+j9a90MA2RLkbzI5mHlO0meE/JJzxMwS5Ze41
         /raElvXE9QBJmcYrwFvccTXnSA5iA6y4IQ7XebJMJGUWthAK3RtttSP1ARaAEe32yara
         x98A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752320306; x=1752925106;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vz1EdfHcEvWqKqRjGMN7WB+f+/2IxBr68QR0po7YBsY=;
        b=VjfweCwMnWHhKZJOGc6LtxIwO0vv1ajJPYshahcZ4nOBZ12MLFndqN8LRxcZ4p4S+W
         BdTgrtATkSBA6+elJ0/U4tSKQJzW6EopUvPp4GgLymMIXPolM5DlmXADF2PK66PV6pV+
         yEy0cZoM+xaQo/aaknHJ3gFMktJjoIGwhaQM7v1QJkhJfeHxzeJ7Zsjrcf7jH5yZJJsG
         iU6IDfNkoRwlxMePW2i7mCAAfg74qxLohLZlLuYplg/HZnBgOa1vpph8/I4MXFMDxnj0
         Wscr6v7QVgzqwGBz685ZfHyP0RcXkrMJB89YsB4w11WFcz64j3DER8pQUOZ+ufqK1pv0
         F17w==
X-Forwarded-Encrypted: i=1; AJvYcCXXVbePv/JyeCrmvBPfjESpq2OZt531gBAqcblUQUfheyYHxTCaaeh952vDkuvStz3fbS5sUVZGhg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/wQt6oBPl2lw0uK4KW2zc/wNcNCfDw9fs+ufCShNPEoMsKk6R
	tJnTMm3y7/JIGOqonmQCQ9jOVjO+YLlJ7Lg3ZbpXNQ0LTyvdyp3q3UXUjYPjjg==
X-Gm-Gg: ASbGnctlK2aKZnyKg2xLlyjqMJRq6RQoCqO7Y0eEal52Y20so4nEqg5WU1wqCgcti2C
	W1griU2l5c6WqzsvYNEogarPHCeTZQPzWLzH2v7IyKHq7aTw3153+R2H2hv13SsfsVwbNNwgLir
	HBetiMV9xKTRpdluSda7e4hTNvykmOXIYOcA7cpLX3oKsrbd5x7/5mgg4AvWT7M/29XeNsiR6m0
	9sI5m6obeK09agZ2Jss9rW6CKOtZ1yMYwt/tDN090dqMT93uBhol1ZQM7ZulWbv0IwtY32My/5h
	vbeaoV2oC2A7dpMEplh/kYEyTInGQ4piSvNzgc0swzjm6FyBc1z9DA9e+XhsMUcvgBm57xh02SQ
	oJqbmLBqKVp7plr6Gi6cCto48sV0L4THsQcU=
X-Google-Smtp-Source: AGHT+IFp0T9XktKfjYYB99N1RyOmD9DZrYV1bOD73MmBJenFCmjw5chgLeXGlX7ZsjyRbrjCG3LZyQ==
X-Received: by 2002:a17:907:1b0b:b0:ade:867f:1e9b with SMTP id a640c23a62f3a-ae6fbc1044dmr624830666b.9.1752320306066;
        Sat, 12 Jul 2025 04:38:26 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::1ac? ([2620:10d:c092:600::1:b2ad])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e8294013sm472710366b.118.2025.07.12.04.38.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Jul 2025 04:38:25 -0700 (PDT)
Message-ID: <801afb46-4070-4df4-a3f6-cb55ceb22a00@gmail.com>
Date: Sat, 12 Jul 2025 12:39:43 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/poll: flag request as having gone through
 poll wake machinery
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <[PATCHSET 0/3] Add support for IORING_CQE_F_POLLED>
 <20250712000344.1579663-1-axboe@kernel.dk>
 <20250712000344.1579663-3-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250712000344.1579663-3-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/12/25 00:59, Jens Axboe wrote:
> No functional changes in this patch, just in preparation for being able
> to flag completions as having completed via being triggered from poll.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   include/linux/io_uring_types.h | 3 +++
>   io_uring/poll.c                | 1 +
>   2 files changed, 4 insertions(+)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 80a178f3d896..b56fe2247077 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -505,6 +505,7 @@ enum {
>   	REQ_F_HAS_METADATA_BIT,
>   	REQ_F_IMPORT_BUFFER_BIT,
>   	REQ_F_SQE_COPIED_BIT,
> +	REQ_F_POLL_WAKE_BIT,
>   
>   	/* not a real bit, just to check we're not overflowing the space */
>   	__REQ_F_LAST_BIT,
> @@ -596,6 +597,8 @@ enum {
>   	REQ_F_IMPORT_BUFFER	= IO_REQ_FLAG(REQ_F_IMPORT_BUFFER_BIT),
>   	/* ->sqe_copy() has been called, if necessary */
>   	REQ_F_SQE_COPIED	= IO_REQ_FLAG(REQ_F_SQE_COPIED_BIT),
> +	/* request went through poll wakeup machinery */
> +	REQ_F_POLL_WAKE		= IO_REQ_FLAG(REQ_F_POLL_WAKE_BIT),
>   };
>   
>   typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw);
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index c7e9fb34563d..e1950b744f3b 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -423,6 +423,7 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>   			else
>   				req->flags &= ~REQ_F_SINGLE_POLL;
>   		}
> +		req->flags |= REQ_F_POLL_WAKE;

Same, it's overhead for all polled requests for a not clear gain.
Just move it to the arming function. It's also not correct to
keep it here, if that's what you care about.

>   		__io_poll_execute(req, mask);
>   	}
>   	return 1;

-- 
Pavel Begunkov


