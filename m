Return-Path: <io-uring+bounces-4983-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 536A99D62B4
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 18:06:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C432B1608B4
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 17:06:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10460148FF3;
	Fri, 22 Nov 2024 17:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DSf9AyWg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EC5155392
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 17:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732295172; cv=none; b=R2VpzQ0JNWg9TtT2XOX1vy0hhtRrUyeAAJUfznkMavtwrvhGO6Yw+mZ41Y9P9XGXMoyzDrS2cgpFptmvCPTDKZlmrwiZBPEb27p8MrXJj/Ik1Y5UspPcm8242qeMZ02yZno1jg/k33bgKyK7np20faMwp5E5miEkGV2c/UvMe/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732295172; c=relaxed/simple;
	bh=TiT5PZ9SCJQ6uUiV23TJKcVXiaqhaykOPcqWboVF1BM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cBD4rbB6vDRf7I1bcVQHzGqNu/Arw/hqT5+P6zGs946O2GKUv99GDlDVKCvRbZORHGO3E4OZ1Dmosgpdpm6bSqyDZwuF+3PSX/N8qzsnwJIZbAek6qJRUpQJtLdQKmDveSY64wNYClZ8iswLqfExSTFJo74T5PYB0fwed7TzwNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DSf9AyWg; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5cedf5fe237so2541925a12.3
        for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 09:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732295168; x=1732899968; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ArBXxVx+vkHLbae5m8bMfsgUmeRL2VmoSYGyzz5/GPc=;
        b=DSf9AyWgosjsImW7oKPB2KgLMAxvzXD3VhJKcsYA2ZwQoKDlQd22plX9nK1mGOwMG6
         dO7WqrQUm13s/TpzwgeOsAOirX3T6bstXFeqVuemNRnknqceUVMxD/Yhr2XNM7fFZdlt
         iLenbSnUfPY1nRUUZefYXHWCA50Qx/GXqT1SDJV4Rjz5LZGwJH+ynVC4v2OxjJ4Z4CaL
         a6QTiCnlznBwlNjmv59l+fzw4EeYWOJHX7/PBk0dBKb4z9kO4lrkqfUqauwGU2CMwGo9
         2HDTbKVWZXsHLQSKGUYtCio+9wu6hbAJdM5EHPsQ5HyUGrQLlk4W6XEIruPOdYwwhAAW
         YUWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732295168; x=1732899968;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ArBXxVx+vkHLbae5m8bMfsgUmeRL2VmoSYGyzz5/GPc=;
        b=w7TErtSb5cNTAxAuZgRpQ/3/dsx5YqPxVIJ0j3fVFuJxltiOXiEd4q1lZr+dQTHywN
         DQouSPCW5hmkzgxfuUAOo44QgtCAv+qneedBMugWBc+A8c7z5gKukwnTW7JnxrJ/+21M
         mW3Nj2wD/5qfVJ5QqbGxtePut+IDyOj3ejoyh9yRSVqmVqxYG3OxiG8aAkWdEPT99Ytt
         VYY7tD5FJVFSWpSHNQjP9nrEAUqm9Tf0r51lrJF5unRyTrP7YBVw6UpgPrlhaDMYVfvt
         ZsB4sAj/zf6loE+aLoiOCom8G1p+SYXdDlzCMzqFGz2ZBt9+vJRiWcu97sPrwQVJgbZo
         1cRA==
X-Forwarded-Encrypted: i=1; AJvYcCXUjvfpxQzboCU/cY7wDgTrsrpzSxXa26ng63xDbrpZpid/8EDCL9gN6G+d1wJF1YCEq9f2kudk2A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzFm6LjXou9m9XUCo9ODzUtNkZhedD6CRedWKw6O5d8AVSapBn0
	Ii5VOG0BcqI9XTLBi1ygWSp75fIFJYZ5JvbJRP3RRfHa6jX2AsQ4
X-Gm-Gg: ASbGncvbVTqdxCosUMS7sHSKg9nDw3mwE3u8HgdXRZckt9V/7AlsmcgRg2l/LC0mje0
	adDm+bFAfZOoKU+tInsFppx95o5l+aV+d6i3OnnmNmMxZbgoOwJinbmsJ4e946/JqTLYO/R+YTz
	JCO/2X8qDXz7Ud3aAJT54E1uiL4r3HgOTH3XVlvlK/cVThFHInsSyg4k4x939UHwm9H2zpwi56k
	vl72zjjqkm0s3OnbaNyH6TRLDGbEK0iexcyU91Fowuhl0LyngTc2L8xa9A=
X-Google-Smtp-Source: AGHT+IEbrE4QDMN2tnGzcL+KgseWjwJhVQiq98nuaRzTMAQeYB8/TA3SAf5SC8vtJ1lDayYQWv1Lzg==
X-Received: by 2002:a05:6402:35d6:b0:5ce:fa47:2597 with SMTP id 4fb4d7f45d1cf-5d0205f7d12mr2431074a12.9.1732295168289;
        Fri, 22 Nov 2024 09:06:08 -0800 (PST)
Received: from [192.168.42.9] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d01d41a382sm1092768a12.72.2024.11.22.09.06.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2024 09:06:07 -0800 (PST)
Message-ID: <f0c124b6-9a38-45ed-86ac-b219a51917e9@gmail.com>
Date: Fri, 22 Nov 2024 17:07:02 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] io_uring: replace defer task_work llist with
 io_wq_work_list
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20241122161645.494868-1-axboe@kernel.dk>
 <20241122161645.494868-3-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241122161645.494868-3-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/22/24 16:12, Jens Axboe wrote:
...
>   static inline void io_req_local_work_add(struct io_kiocb *req,
>   					 struct io_ring_ctx *ctx,
> -					 unsigned flags)
> +					 unsigned tw_flags)
>   {
> -	unsigned nr_wait, nr_tw, nr_tw_prev;
> -	struct llist_node *head;
> +	unsigned nr_tw, nr_tw_prev, nr_wait;
> +	unsigned long flags;
>   
>   	/* See comment above IO_CQ_WAKE_INIT */
>   	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
>   
>   	/*
> -	 * We don't know how many reuqests is there in the link and whether
> -	 * they can even be queued lazily, fall back to non-lazy.
> +	 * We don't know how many requests are in the link and whether they can
> +	 * even be queued lazily, fall back to non-lazy.
>   	 */
>   	if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
> -		flags &= ~IOU_F_TWQ_LAZY_WAKE;
> +		tw_flags &= ~IOU_F_TWQ_LAZY_WAKE;
>   
> -	guard(rcu)();

protects against ctx->task deallocation, see a comment in
io_ring_exit_work() -> synchronize_rcu()

> +	spin_lock_irqsave(&ctx->work_lock, flags);
> +	wq_list_add_tail(&req->io_task_work.work_node, &ctx->work_list);
> +	nr_tw_prev = ctx->work_items++;

Is there a good reason why it changes the semantics of
what's stored across adds? It was assigning a corrected
nr_tw, this one will start heavily spamming with wake_up()
in some cases.

> +	spin_unlock_irqrestore(&ctx->work_lock, flags);
>   
> -	head = READ_ONCE(ctx->work_llist.first);
> -	do {
> -		nr_tw_prev = 0;
> -		if (head) {
> -			struct io_kiocb *first_req = container_of(head,
> -							struct io_kiocb,
> -							io_task_work.node);
> -			/*
> -			 * Might be executed at any moment, rely on
> -			 * SLAB_TYPESAFE_BY_RCU to keep it alive.
> -			 */
> -			nr_tw_prev = READ_ONCE(first_req->nr_tw);
> -		}
> -
> -		/*
> -		 * Theoretically, it can overflow, but that's fine as one of
> -		 * previous adds should've tried to wake the task.
> -		 */
> -		nr_tw = nr_tw_prev + 1;
> -		if (!(flags & IOU_F_TWQ_LAZY_WAKE))
> -			nr_tw = IO_CQ_WAKE_FORCE;
> -
> -		req->nr_tw = nr_tw;
> -		req->io_task_work.node.next = head;
> -	} while (!try_cmpxchg(&ctx->work_llist.first, &head,
> -			      &req->io_task_work.node));
> -
> -	/*
> -	 * cmpxchg implies a full barrier, which pairs with the barrier
> -	 * in set_current_state() on the io_cqring_wait() side. It's used
> -	 * to ensure that either we see updated ->cq_wait_nr, or waiters
> -	 * going to sleep will observe the work added to the list, which
> -	 * is similar to the wait/wawke task state sync.
> -	 */
> +	nr_tw = nr_tw_prev + 1;
> +	if (!(tw_flags & IOU_F_TWQ_LAZY_WAKE))
> +		nr_tw = IO_CQ_WAKE_FORCE;
>   
> -	if (!head) {
> +	if (!nr_tw_prev) {
>   		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
>   			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
>   		if (ctx->has_evfd)
>   			io_eventfd_signal(ctx);
>   	}
>   
> +	/*
> +	 * We need a barrier after unlock, which pairs with the barrier
> +	 * in set_current_state() on the io_cqring_wait() side. It's used
> +	 * to ensure that either we see updated ->cq_wait_nr, or waiters
> +	 * going to sleep will observe the work added to the list, which
> +	 * is similar to the wait/wake task state sync.
> +	 */
> +	smp_mb();
>   	nr_wait = atomic_read(&ctx->cq_wait_nr);
>   	/* not enough or no one is waiting */
>   	if (nr_tw < nr_wait)
> @@ -1253,11 +1233,27 @@ void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,

-- 
Pavel Begunkov

