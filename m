Return-Path: <io-uring+bounces-5779-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ED70A06D63
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 06:06:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5900B16576E
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 05:06:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EBA82144A3;
	Thu,  9 Jan 2025 05:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ScN/c669"
X-Original-To: io-uring@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDFD1214239
	for <io-uring@vger.kernel.org>; Thu,  9 Jan 2025 05:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736399200; cv=none; b=i+OrTHZH8vOuUvZMo4l3/h5ua6PrB6Wd4diYa4iSG2WP/EZoId85vBd2UPvBrpHbPoVLIFrnKiNhiVMcCOr7uu7LwIrRp1vyPutCV+1XGF86AuW7x5/S2vagO6ha+YqgCunTJuqJbk3fDx/49vMgBdlhsd0shTTZXuV4VY0JM5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736399200; c=relaxed/simple;
	bh=QNrComucqfbbp8jW1wDK2475y6rUwCE8ev27bFCR9iM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RRTq+5kpRAWmzx/iWAI+lBkp7gvDxe2x+SsWvvIAWNM5qQ35fOfFo2yYz0f/rfnJeyomycw1N9+UxyMPjzF0iyNAXgG25DsFIrfj9Ywa7S9uioXZzQ89vWarJSqA+vB21IUHbMs0ECh05H76UKsMehfABAj55wTf9xdqBSxHYYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ScN/c669; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [10.156.205.88] (unknown [167.220.238.88])
	by linux.microsoft.com (Postfix) with ESMTPSA id DF5ED203E3B2;
	Wed,  8 Jan 2025 21:06:37 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DF5ED203E3B2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1736399198;
	bh=oIAPnJ0Lr/afNhKltVG2BUXKmYOe/SgCE8DBV9mzRpY=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=ScN/c669ekX82kzW+gfVubvlrw5DauHU56DEBgRSxovpUjUj6DCnKiQ9dHpf2bFek
	 ziE1Zp3PAZ5exZ9ePC2rWqKRoKP4UzaJB800H67p/zGpL9k70l/yv0UhsFI3+hn+LW
	 fnNY3jJBALGkF+RzOpHaG3tMBZj3GYzAJNQz7ccE=
Message-ID: <8338b71d-9f40-45c3-9596-d5d761717314@linux.microsoft.com>
Date: Thu, 9 Jan 2025 10:36:35 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/eventfd: ensure io_eventfd_signal() defers
 another RCU period
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <7812ebd4-674f-4ad7-8c13-401684e8099b@kernel.dk>
Content-Language: en-US
From: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
In-Reply-To: <7812ebd4-674f-4ad7-8c13-401684e8099b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 09-01-2025 05:12, Jens Axboe wrote:
> io_eventfd_do_signal() is invoked from an RCU callback, but when
> dropping the reference to the io_ev_fd, it calls io_eventfd_free()
> directly if the refcount drops to zero. This isn't correct, as any
> potential freeing of the io_ev_fd should be deferred another RCU grace
> period.
>
> Just call io_eventfd_put() rather than open-code the dec-and-test and
> free, which will correctly defer it another RCU grace period.
>
> Fixes: 21a091b970cd ("io_uring: signal registered eventfd to process deferred task work")
> Reported-by: Jann Horn <jannh@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
> index fab936d31ba8..100d5da94cb9 100644
> --- a/io_uring/eventfd.c
> +++ b/io_uring/eventfd.c
> @@ -33,20 +33,18 @@ static void io_eventfd_free(struct rcu_head *rcu)
>   	kfree(ev_fd);
>   }
>   
> -static void io_eventfd_do_signal(struct rcu_head *rcu)
> +static void io_eventfd_put(struct io_ev_fd *ev_fd)
>   {
> -	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
> -
> -	eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
> -
>   	if (refcount_dec_and_test(&ev_fd->refs))
> -		io_eventfd_free(rcu);
> +		call_rcu(&ev_fd->rcu, io_eventfd_free);
>   }
>   
> -static void io_eventfd_put(struct io_ev_fd *ev_fd)
> +static void io_eventfd_do_signal(struct rcu_head *rcu)
>   {
> -	if (refcount_dec_and_test(&ev_fd->refs))
> -		call_rcu(&ev_fd->rcu, io_eventfd_free);
> +	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
> +
> +	eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
> +	io_eventfd_put(ev_fd);
>   }
>   
>   static void io_eventfd_release(struct io_ev_fd *ev_fd, bool put_ref)
>
Looks good to me.

Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>


