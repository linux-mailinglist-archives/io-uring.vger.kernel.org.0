Return-Path: <io-uring+bounces-6293-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ABB99A2C2AB
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 13:28:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB40018863E8
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2025 12:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A5F01E00BF;
	Fri,  7 Feb 2025 12:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bDDmhUMD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C24D1DE2D7;
	Fri,  7 Feb 2025 12:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738931295; cv=none; b=sRyL9jJZ23ORGm61wwSry1acLWToY2ffTY3dLcDC1jLv4ybgsDlfJCMVgaeUE1F4m/SfDhL2UiAdFjpat3GtawKt6Jmi5EbOn8VHThjenuenjR9RUAOr8WZdzR+bw6j4tl3GjWTE5LFMO0bxCfjwxAVjlT1ezHFkcSc9QNYNPMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738931295; c=relaxed/simple;
	bh=C/25fu5Y3laZWIDEiUQQ5VSHuKxsDRpnd//tMK9bevE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=occgerfx8sqyoBzpYvCTQ8qW1HD/vTZghnZxg05RGuWFlWjrZDJQAVVCgiFCqAuSGmaUKGWL5ixtr62nzoI94JSZEgZMhQb8R5E6+b33lQ3F2HpKQxOy68jfbjmW+wK2PiZSS78BhimIqsU3t5XONURVZIOpq3QKcffZWyHYGb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bDDmhUMD; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ab78d9c5542so94529666b.1;
        Fri, 07 Feb 2025 04:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738931291; x=1739536091; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ue8Cay3b+PMqZQNCdnsih7OpIuU+OFiiA1bevcVJOvk=;
        b=bDDmhUMDpEQJKhkIJNsFE4r6cB6SbhYfqJ62Nq+BVo9c8+o6dJFrkHxBluxkIIx3Ji
         iuOQOlfoDz5Jp3Kl2HjVEpGrE6bACH9XuOHk0t4qXLEzUCGZGQE0v1YWmWwBZL8yo+f2
         xDxH4dUATmJ3I5YsHUugTWvS+u2ZKM+hnDUWorLqieEgf6T1a3HzejWro41BDxgC9/b+
         qL6pK0ApYaWpYh5jbyrIJaMNaY57mM3NYIEvBVNlqhw/WN/tuZ5ifkkwfaHqLMYa8Wz+
         F/PsAKeg9PabqOAZvkzQ9pjnYN1Asb7+8aZ6m7KDF7X8SC8DUJp+Kp8HeOo/LLVJAmqy
         eILQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738931291; x=1739536091;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ue8Cay3b+PMqZQNCdnsih7OpIuU+OFiiA1bevcVJOvk=;
        b=ftJGtL30pvk5bx7hFYmf3BGGWJ09hpIROYiuFNKSpeZL05VfP1gMWCZBR+Qt4a08qv
         st9Tk2AHwaznNUW46ah+gAxX6P5PH+ptwoKUeX8ppPOY6pewa69LDDrhxMfAi6eYAnyH
         1sMF5ai1HSlOpWahNUy6520kN6orNUOrY0XDRKCYEJDSeVz4I5zwFUyKTW2QcLy9LsC4
         ZCPPwd+6XLPJFp2VRSj27+/1aKcU+/A582sxD+yCnf2tBiGE2PS6fMy8YdTzRtJszYfi
         RNJ/NbFIekR4YzVgX4UI9Dk5JU6u4sZe+S7vRqUyQMSi7jVa3wyxYO/8xPjbGSutH2Wb
         mhkg==
X-Forwarded-Encrypted: i=1; AJvYcCUoXdpDVyGrR/6wf7nlC4IRhYSdzCCSjXxgPmM5XoVFD9ePHqhSqYwT0msTYs5lBIuKHLiZgCSonQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyVAnsUY6hhb73JprdltAx5L8OZWl7lgGmJTP7OLMgw18NIoOMQ
	mArAwpp9W0A1zOdYDugsqiCvs84ZIUNRalRThWIiGMcch5i3FsBK
X-Gm-Gg: ASbGncurW9H2X0AB4AjaFYIyDthdutvppse8OFAAerFgCqMZk65Rg2fX3hAUzd2sjfR
	R3uR3uuaOHNg8TkOdTxMtgzvzkRw+/lsfoem+M/orrD4+h8dnkN2rke0HUHgYgpJAM+CwMeibWk
	rOVeRkav9Q4Ypy0TUNr5p8eueaFvfHcGea5QPehbHhXp9qDBqugLhcx4+MzoRyBlvg0KsVx94ps
	Wu4SX+19gihlnN5fLOaGdKjJSGO9TiwGbGyBgSKR2enMcNSqbUlvZIM/iqsmeMwmHr9KWy4h4mM
	NHbGgPIGbHrM9H5n1OsuSJdAu3vT8SH6M7urvj0X6uIBRzPi
X-Google-Smtp-Source: AGHT+IHIycV3Pte0CZdLb2aiER5tBUv43VqX/z2zHizFZNE0QLcxB+cz7ftGF+AHMEdmh9iBQXop2w==
X-Received: by 2002:a17:907:7e9b:b0:ab6:d6dd:2deb with SMTP id a640c23a62f3a-ab789a6790amr305346566b.8.1738931291415;
        Fri, 07 Feb 2025 04:28:11 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:8e12])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7732e71e3sm256747466b.112.2025.02.07.04.28.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 04:28:10 -0800 (PST)
Message-ID: <618af8fc-6a35-4d6e-9ac7-5e6c33514b44@gmail.com>
Date: Fri, 7 Feb 2025 12:28:17 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/11] eventpoll: add ep_poll_queue() loop
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org
References: <20250204194814.393112-1-axboe@kernel.dk>
 <20250204194814.393112-6-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250204194814.393112-6-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/4/25 19:46, Jens Axboe wrote:
> If a wait_queue_entry is passed in to epoll_wait(), then utilize this
> new helper for reaping events and/or adding to the epoll waitqueue
> rather than calling the potentially sleeping ep_poll(). It works like
> ep_poll(), except it doesn't block - it either returns the events that
> are already available, or it adds the specified entry to the struct
> eventpoll waitqueue to get a callback when events are triggered. It
> returns -EIOCBQUEUED for that case.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   fs/eventpoll.c | 37 ++++++++++++++++++++++++++++++++++++-
>   1 file changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index ecaa5591f4be..a8be0c7110e4 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -2032,6 +2032,39 @@ static int ep_try_send_events(struct eventpoll *ep,
>   	return res;
>   }
>   
> +static int ep_poll_queue(struct eventpoll *ep,
> +			 struct epoll_event __user *events, int maxevents,
> +			 struct wait_queue_entry *wait)
> +{
> +	int res, eavail;
> +
> +	/* See ep_poll() for commentary */
> +	eavail = ep_events_available(ep);
> +	while (1) {
> +		if (eavail) {
> +			res = ep_try_send_events(ep, events, maxevents);
> +			if (res)
> +				return res;
> +		}
> +
> +		eavail = ep_busy_loop(ep, true);

I have doubts we want to busy loop here even if it's just one iteration /
nonblockinf. And there is already napi polling support in io_uring done
from the right for io_uring users spot.

-- 
Pavel Begunkov


