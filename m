Return-Path: <io-uring+bounces-927-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C38E687B2F9
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 21:40:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DEDE91C25350
	for <lists+io-uring@lfdr.de>; Wed, 13 Mar 2024 20:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B4813A1AE;
	Wed, 13 Mar 2024 20:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gHBsHj5Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6839F1A38E8;
	Wed, 13 Mar 2024 20:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710362433; cv=none; b=MmA4R3H0QzTwdu/dgKXkJxXUXkecXemjGPlRvENsTGtidS7uypr1BiHYYNW1+y+xSdN4/yEpIhdleLSZRbtBanD11v57l+kmLbKrUvx+dcvqlwC99mOr8z5YH+JEHQ1dh5K/JwvmYqWl+M7aC8diUMpO7dj3qtC8QayHjbw9OD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710362433; c=relaxed/simple;
	bh=l5RU722NA/EJGkYqWoeIRzBEIoZOPf8AH4c1zSMJtRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=juuMyF3TqgbzwLK3gQQsUXHo5QqryoNrY64W6sHLRxRj+76+KVLQYsy5Eo2caf8e2yJ7jUNLv40IJ7oHJcN5soBfn1EsxTR2006L/mXibTbtuD1lXcvR9xiskqRzdNWNMxuuKsoP/pLFpYzsuLWHIFLddLvSdWzwSykO27qt7rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gHBsHj5Y; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d28051376eso2847091fa.0;
        Wed, 13 Mar 2024 13:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710362429; x=1710967229; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9Zen2mvuGTke88qMtQ/Lj4wMjC+rrrBsIBN01qzdSb4=;
        b=gHBsHj5YhWha89irnxynxAfcBiEN02pmYCXt882TOc0q+LFceXph4kgIOO+byeMCoI
         iwlk0zL4iutnRBg/TD6C9wV7Esg8SBJFc2oQy72nc+ySJSscC59nYjXEjiHJtn6s966N
         7EeAnmw7GUv60Jo86bSxJj+d2hA1aicq8c0OU0h03FlxrmrE35yuEah45Hv7vmPoB0gi
         EhMMtFCxH61MmHeCLTblRo0jQb7OCtDKIikbVMOCz8PbHn4k6ObRGiHw4l6xqzxBdIj+
         z2g9kr3OnBoGeX6/jlinW4monWrgr0lsxG+yGrP6Fk/4UyoPBMTHd7VCxtL0Lp/TXs7D
         /h7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710362429; x=1710967229;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Zen2mvuGTke88qMtQ/Lj4wMjC+rrrBsIBN01qzdSb4=;
        b=LdtrLBSebxcgQ94JQBAYL5Cho4M42R1ne/Aj2OiNd/SARWkZbpt/MkQPauC+PKt00j
         z57Pa9DkKEg6fWeyt+2ZFmNsteaEzSPnN1Z9kP9dWi+OB/EsB1Q2LeLsYU95Ovd/wt3L
         b68utgC9Jpi9tR8xQBQ0hNToASNHbCMqa9xgGSjqMfRdLf/x3xO/7fEFphgHALFBHiRP
         2PLXFxndioY54jRCM9hq02m8UtuN02SDgYkSwzsCBEtqVloprg3vjBlwD17EsEOPbSsw
         BA0Zp/S8KBw78qSkAUPmQsr5P5m5nlDJ9RUYpKDVTJEyhUOaJWz/xvB7Ta66oi5j4i/I
         vfHg==
X-Forwarded-Encrypted: i=1; AJvYcCW0rsAep54Vyf4Ai0rP4ojtovuDydYTsfD+MaRvmddzmzrVL3v1ojjy8BjiUcFNeaFjVqSNDxCHkaiNWD2Yj1AhfI//+H8siMG00qvPzwtInLjCJJgvC0GpCthPDFoBaBU=
X-Gm-Message-State: AOJu0YzDmEQU0IrV9fL4Ue8MV+gQornLbMOm5osYDWfqK3wy+7Pd0YPM
	OC8CZUCHpFN6xfsX4IwidY2RBYYNssFdjWZ0oPhHm1bqfRoVU5hv
X-Google-Smtp-Source: AGHT+IFtHfgmpk256Tyoyg3zBCCuuScPHaGZgwW9jf/r09g6BZcDMWj9RkreqsmQuw22bKPzmIKHMw==
X-Received: by 2002:a05:6512:292:b0:513:c2c7:573e with SMTP id j18-20020a056512029200b00513c2c7573emr3792739lfp.23.1710362428753;
        Wed, 13 Mar 2024 13:40:28 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.146.134])
        by smtp.gmail.com with ESMTPSA id n12-20020a170906688c00b00a4665ac5f5asm423138ejr.164.2024.03.13.13.40.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Mar 2024 13:40:28 -0700 (PDT)
Message-ID: <4343cff7-37d9-4b78-af70-a0d7771b04bc@gmail.com>
Date: Wed, 13 Mar 2024 20:26:42 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 13/16] io_uring: add io_recvzc request
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20240312214430.2923019-1-dw@davidwei.uk>
 <20240312214430.2923019-14-dw@davidwei.uk>
 <7752a08c-f55c-48d5-87f2-70f248381e48@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7752a08c-f55c-48d5-87f2-70f248381e48@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/13/24 20:25, Jens Axboe wrote:
> On 3/12/24 3:44 PM, David Wei wrote:
>> Add an io_uring opcode OP_RECV_ZC for doing ZC reads from a socket that
>> is set up for ZC Rx. The request reads skbs from a socket. Completions
>> are posted into the main CQ for each page frag read.
>>
>> Big CQEs (CQE32) is required as the OP_RECV_ZC specific metadata (ZC
>> region, offset, len) are stored in the extended 16 bytes as a
>> struct io_uring_rbuf_cqe.
>>
>> For now there is no limit as to how much work each OP_RECV_ZC request
>> does. It will attempt to drain a socket of all available data.
>>
>> Multishot requests are also supported. The first time an io_recvzc
>> request completes, EAGAIN is returned which arms an async poll. Then, in
>> subsequent runs in task work, IOU_ISSUE_SKIP_COMPLETE is returned to
>> continue async polling.
> 
> I'd probably drop that last paragraph, this is how all multishot
> requests work and is implementation detail that need not go in the
> commit message. Probably suffices just to say it supports multishot.
> 
>> @@ -695,7 +701,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>>   	unsigned int cflags;
>>   
>>   	cflags = io_put_kbuf(req, issue_flags);
>> -	if (msg->msg_inq && msg->msg_inq != -1)
>> +	if (msg && msg->msg_inq && msg->msg_inq != -1)
>>   		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
>>   
>>   	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
>> @@ -723,7 +729,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
>>   			goto enobufs;
>>   
>>   		/* Known not-empty or unknown state, retry */
>> -		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq == -1) {
>> +		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || (msg && msg->msg_inq == -1)) {
>>   			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
>>   				return false;
>>   			/* mshot retries exceeded, force a requeue */
> 
> Maybe refactor this a bit so that you don't need to add these NULL
> checks? That seems pretty fragile, hard to read, and should be doable
> without extra checks.

That chunk can be completely thrown away, we're not using
io_recv_finish() here anymore


>> @@ -1053,6 +1058,85 @@ struct io_zc_rx_ifq *io_zc_verify_sock(struct io_kiocb *req,
>>   	return ifq;
>>   }
>>   
>> +int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>> +{
>> +	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>> +
>> +	/* non-iopoll defer_taskrun only */
>> +	if (!req->ctx->task_complete)
>> +		return -EINVAL;
> 
> What's the reasoning behind this?

CQ locking, see the comment a couple lines below


>> +	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>> +	struct io_zc_rx_ifq *ifq;
>> +	struct socket *sock;
>> +	int ret;
>> +
>> +	/*
>> +	 * We're posting CQEs deeper in the stack, and to avoid taking CQ locks
>> +	 * we serialise by having only the master thread modifying the CQ with
>> +	 * DEFER_TASkRUN checked earlier and forbidding executing it from io-wq.
>> +	 * That's similar to io_check_multishot() for multishot CQEs.
>> +	 */

This one ^^, though it doesn't read well, I should reword it for
next time.

>> +	if (issue_flags & IO_URING_F_IOWQ)
>> +		return -EAGAIN;
>> +	if (WARN_ON_ONCE(!(issue_flags & IO_URING_F_NONBLOCK)))
>> +		return -EAGAIN;
> 
> If rebased on the current tree, does this go away?

It's just a little behind not to have that change

-- 
Pavel Begunkov

