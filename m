Return-Path: <io-uring+bounces-7551-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A4A5EA93BDF
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 19:21:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3AA2B1893466
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 17:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A3881BD01D;
	Fri, 18 Apr 2025 17:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gfjW9iGN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567B8184F
	for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 17:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744996859; cv=none; b=UQZt0LrmbuTpWRAzPTm6JizDmKw2cVB5DYumd630a1H9uToIbRCF2ivabV1YsxGiziS9KHX8wDbEuiobU+bpT3QBP0nGVnW3tL1RGEoCBy+FIzhTbeQHGOxf1fzU8RtcOu9BLJcG1ZMDZqsfKa+hYFJrEwP2udyTqVe+PbxGoOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744996859; c=relaxed/simple;
	bh=KBGmiWn7LOpLucgUUS3nyXz1vnShqeUfS8c0FFPP2/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CSptJy4VRjCCxIDO5AZieve5TnjUoQ/XWm8iJpEq4KUJbdv4/X1aHvPVa4CptNVdJ2VFdT6RDDS1fsSzs5sB96D/WGa7rG2yjTGyzPSmVhjW1tsWIwrRidFN2CkYz4u8jDMGCft2ML6q18rlvtp2k/gVl5pUzlngkvpOr30CQ/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gfjW9iGN; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4394a823036so12028285e9.0
        for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 10:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744996855; x=1745601655; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k3X37XLPc84raNOM9crxkkES/X+qHUB0zRxu69HlH4c=;
        b=gfjW9iGNps6OGPxU+M+trRnUVXt9PMN3UsD2xL0MxjAKtU2UXlztb6v4lm+uaERPcT
         KmjuYdV/JkBAjoJDA79lTofKf+3c18HwNI6MxdNZmLqUWWBEALEUCKFFl/SaB21elZpK
         O+IBZCRDbAvoIgztlFyz18gHtdrtgVeJLg1SaI3TlKVc0cQngF5wxeyY8yyi2uIn119k
         G+kxqroyY7O/AbfsbOc5bPcSBuVbVKb8LuNhJ68Z+AHjymBDM4cctRyqolw4tqqbRsI2
         I+GgBAv1OWz+HZaEMsQhE4tIOLjwScm2EW3DFLfkTUOo0tlQV29dU6SdnxN/H64soTRj
         IA3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744996855; x=1745601655;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k3X37XLPc84raNOM9crxkkES/X+qHUB0zRxu69HlH4c=;
        b=tmQ4xX8QUig+MKWB7CxJ/Tmn0Bla4Fgg0kxzoxLNueC3KBfMYRzSXmB88D03lshA8U
         GHTxS/10zyGcc8YEHRDISGqigRLgVgpjVMowhKRJx96CPqspDFaVz71zCd+PLfJ7GZKd
         co1SNBnhWzJwjGCOzIZHfKnwRqhsJqz8MGJ6C3NXeljr9SF6aG5/9JyQwcblnRLlmm7g
         +Sv8EVqKH+04saC8jYHt68HiGF/jSLEYaHbj+4g+XTt2vugDmhfC7gsQKSy39wgzScAP
         yHX4RMfnlqW7azilLhCpjx4VwmJp0E11tImPrPax4Lj7Bob4qJKptj0keW1xg+Wunhod
         /jyA==
X-Forwarded-Encrypted: i=1; AJvYcCWIBE025VnIPjFEpIrb31auUykBSPg1ZKNwkDKYDjTcUWWHbduMmW3au9zMmZv8N6ykB+Yaa/AumA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5JIAb/BspTeQE3/heFgMzof7krSmhToMkJS+fdghjevyZPiqo
	HGK4iLTFOwd6pP8GbfIEWtsCr9GIBzR8cmdQBEA2+6AxZ2Gi9qvc
X-Gm-Gg: ASbGncszKZSLAhlNKFGFrx+OAX4dxzhOo21AgbbFX/JuWYMzKdNV9obMfvxY0x5Zo41
	JJlV9gtfM7RC1UPTTCcYPex/LlP6FO6H8L5/WQaeQQh63QzcU+hS6qVCfTKZtCMw68QaZJdGVbt
	NgJ5jqNvQ70t1PSKk3q1dgS0rlOiheQLaub7r61LYDhJcTu5ZBHK9osxdFNolvVnPD7Z3mRnHpP
	OnFjEjXSmq7lUoVMZEzV5O2MLY+JDwVvXvQNs2TYc637ylouebis7DyZKFLJe90bol3pCeW6JKe
	jSBJ3BottbCCMun6r2D0dR2e7/hh0IK0hMumHwbrf5RKDjOwBA==
X-Google-Smtp-Source: AGHT+IFBbzDT0pUbC3eiyFvtaD4AvgoFV7z6MZzTr33jxy5y35lir/JYSlzm+MHvIIY0fL7qS5iTYg==
X-Received: by 2002:a05:600c:1c8f:b0:43c:f332:7038 with SMTP id 5b1f17b1804b1-4406ac1fe30mr23206145e9.21.1744996855484;
        Fri, 18 Apr 2025 10:20:55 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.144.40])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa433104sm3312713f8f.29.2025.04.18.10.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 10:20:54 -0700 (PDT)
Message-ID: <68cd2f57-91cc-4727-ab07-f46fe1f8994c@gmail.com>
Date: Fri, 18 Apr 2025 18:22:10 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] io_uring/zcrx: add support for multiple ifqs
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
References: <cover.1744815316.git.asml.silence@gmail.com>
 <8d8ddd5862a4793cdb1b4486601e285d427df22e.1744815316.git.asml.silence@gmail.com>
 <1b14f24b-f84a-4863-a0cb-33d0ebcd9171@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1b14f24b-f84a-4863-a0cb-33d0ebcd9171@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/18/25 18:01, David Wei wrote:
> On 2025-04-16 08:21, Pavel Begunkov wrote:
>> Allow the user to register multiple ifqs / zcrx contexts. With that we
>> can use multiple interfaces / interface queues in a single io_uring
>> instance.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   include/linux/io_uring_types.h |  5 ++--
>>   io_uring/io_uring.c            |  3 +-
>>   io_uring/net.c                 |  8 ++---
>>   io_uring/zcrx.c                | 53 +++++++++++++++++++++-------------
>>   4 files changed, 40 insertions(+), 29 deletions(-)
>>
> [...]
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index 5f1a519d1fc6..b3a643675ce8 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -1185,16 +1185,14 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>   	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>>   	unsigned ifq_idx;
>>   
>> -	if (unlikely(sqe->file_index || sqe->addr2 || sqe->addr ||
>> -		     sqe->addr3))
>> +	if (unlikely(sqe->addr2 || sqe->addr || sqe->addr3))
>>   		return -EINVAL;
> 
> Why remove sqe->file_index?

it's aliased with ->zcrx_ifq_idx. The ifq_idx check below
essentially does nothing. And fwiw, userspace was getting
correct errors, so it's not a fix.

>>   	ifq_idx = READ_ONCE(sqe->zcrx_ifq_idx);
>> -	if (ifq_idx != 0)
>> -		return -EINVAL;
>> -	zc->ifq = req->ctx->ifq;
>> +	zc->ifq = xa_load(&req->ctx->zcrx_ctxs, ifq_idx);
>>   	if (!zc->ifq)
>>   		return -EINVAL;
>> +
>>   	zc->len = READ_ONCE(sqe->len);
>>   	zc->flags = READ_ONCE(sqe->ioprio);
>>   	zc->msg_flags = READ_ONCE(sqe->msg_flags);
>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>> index d56665fd103d..e4ce971b1257 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
>> @@ -172,9 +172,6 @@ static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
>>   
>>   static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
>>   {
>> -	if (WARN_ON_ONCE(ifq->ctx->ifq))
>> -		return;
>> -
> 
> I think this should stay.

There is not ctx->ifq anymore. You may look up in the xarray,
but for that you need to know the index, and it's easier to
just remove it.

  
>>   	io_free_region(ifq->ctx, &ifq->region);
>>   	ifq->rq_ring = NULL;
>>   	ifq->rqes = NULL;
> [...]
>> @@ -440,16 +443,23 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>>   
>>   void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
>>   {
>> -	struct io_zcrx_ifq *ifq = ctx->ifq;
>> +	struct io_zcrx_ifq *ifq;
>> +	unsigned long id;
>>   
>>   	lockdep_assert_held(&ctx->uring_lock);
>>   
>> -	if (!ifq)
>> -		return;
>> +	while (1) {
>> +		scoped_guard(mutex, &ctx->mmap_lock) {
>> +			ifq = xa_find(&ctx->zcrx_ctxs, &id, ULONG_MAX, XA_PRESENT);
>> +			if (ifq)
>> +				xa_erase(&ctx->zcrx_ctxs, id);
>> +		}
>> +		if (!ifq)
>> +			break;
>> +		io_zcrx_ifq_free(ifq);
>> +	}
> 
> Why not xa_for_each()? Is it weirdness with scoped_guard macro?

I don't want io_zcrx_ifq_free() to be under mmap_lock, that might
complicate sync with mmap. It's good enough for now, but I'd like
to have sth like this in the future:

struct xarray tmp_onstack_xarray;

scoped_guard(mutex, &ctx->mmap_lock)
	xarray_swap(&tmp_onstack_xarray, &ctx->zcrx);
for_each_xarray(tmp_onstack_xarray)
	io_zcrx_ifq_free();

but there is no xarray_swap AFAIK.

-- 
Pavel Begunkov


