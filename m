Return-Path: <io-uring+bounces-1973-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF5328D1D0E
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 15:33:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 836261F2476A
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 13:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E0F16F281;
	Tue, 28 May 2024 13:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ce4BpxpT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F16C16F0EE
	for <io-uring@vger.kernel.org>; Tue, 28 May 2024 13:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716903156; cv=none; b=AVlOUMSFkT6raxVV16hM5wb+HdqqPXyc5GRbCzcZL36LcVxAJS8vHVFOGMOLuVgN2qI6NcotYodE2R/ImrImFJQyo0gGYVB1tJ5Opm6eLZf9W7D2HvESpLt0iWheJ63mKtMWkFsUr4XZ2ABsBFR4bQJ7xCRCzTfwCSi+u46+YCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716903156; c=relaxed/simple;
	bh=HMwOjlEkV5GxUYuUh3jMKKU9C0/bF6zXvXL5ivfdhFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gCXXXzenC74DAzEC6oPNUKpPDgGTYCsMlS3HOxMi8q35DzAN9cliAJge5rxwedx5sY2BhBdoOVWKh7Wm4SzVIChaWKhwjrNVCdz9uIPzWTqlXWvvH2diRBI1i0gb97JYeYhw6tJM/yQCg+RkigkAdLwsgICl3taMtL+K4/WFLYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ce4BpxpT; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-529b79609cbso1454290e87.3
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 06:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716903154; x=1717507954; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/LmGLS5C43VBdoBT6ALHSkVtX564fUhisS9OOJSMWhU=;
        b=ce4BpxpTTbDCA9MvUs1mNOwmwOfrxARJUwGXPmK/y8Vdqw2U/i55R+WQA+oBvspM6M
         JiLssnm1a2bPq0nfCa4Rwww1DW3sbeNFADesLjwuHk3QTeqIyykFrwXj+MwMU+zAfpIP
         IHNLHHSUWGfdURlBXmqPQ6aV3Qon+uCM9qZChDDJOr1Ff5m0pTwXifiOtlNp7cspk8My
         Bqf+b8DA1lLmGExB2BhcVxKmdCyGfYMV5iFcuJYOM3SOtLkM1KajYPiPepMSF0Jc/Rcu
         I0a6agUflNF8RL9RjJcnMum9jk69vO1mh+Cie46utVL79GfJaxj0MDRf+qAAPuiY8lFE
         J4+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716903154; x=1717507954;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/LmGLS5C43VBdoBT6ALHSkVtX564fUhisS9OOJSMWhU=;
        b=lnbtGEMsiGbuSbP1rXXZIlnbW77BuIQ/FzvCXKCTLnJluoRY8JIYfMLlDVJku5fvza
         9RYhN+KXq+f94T+r68qSGMy/kykpsvhberorYTkYhnha4d04+PuZrCDhaal8e59YLd9O
         uwyU/1cUUVnWh6YhpSA77/J4nE1KzKtYx9POJ/FfWWQZs5NfnSwwWQ7KcmaLgq4Cw5tX
         h0g9DxUXnrMEXVcnTSKwJt/RfVZ+KVyFt9HfZFmGfnFccUw0Q915gKNIl8D3d3VoQixC
         JdPkXbMOTYF8vgtDtIVgVQSOfEd1FLQTlvaW3Zx9zBMcCxjbKagU3AcPbrT2fHdzEwLD
         xRfA==
X-Forwarded-Encrypted: i=1; AJvYcCX+QgFAoc22TGZlCAlTSIkNOwL2FJZHLIdSj3/c9oJv5dzW9ZVfL1hZTtFPT5jsBFbeMZ0s8EBZ0zKES7BdtsEx6C6nffaM4lg=
X-Gm-Message-State: AOJu0YyMcZCEv7rYMCjvfau4WjqcUcjt/z6/TV6GIJkdnJ3EwjkE9hGW
	oXnvPhO8kAEg+iJKG6mS+dKXi4uTcVoC0EePKx0LQG2J6d42gzCeLpvu2Q==
X-Google-Smtp-Source: AGHT+IF4nbjU0PcJh8fIoyUiQP1VKSOjP3OKWrj2cyS3CbVagw8LmgKxdSGhtxcbCjDqVZZ1O8hXRA==
X-Received: by 2002:a19:e005:0:b0:51c:adb8:8921 with SMTP id 2adb3069b0e04-52966ca7921mr7240033e87.58.1716903153294;
        Tue, 28 May 2024 06:32:33 -0700 (PDT)
Received: from [192.168.42.21] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a626c817088sm610559166b.24.2024.05.28.06.32.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 06:32:33 -0700 (PDT)
Message-ID: <d0ea0826-2929-4a52-86b1-788a521a6356@gmail.com>
Date: Tue, 28 May 2024 14:32:37 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/msg_ring: avoid double indirection task_work
 for data messages
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240524230501.20178-1-axboe@kernel.dk>
 <20240524230501.20178-3-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240524230501.20178-3-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/24/24 23:58, Jens Axboe wrote:
> If IORING_SETUP_SINGLE_ISSUER is set, then we can't post CQEs remotely
> to the target ring. Instead, task_work is queued for the target ring,
> which is used to post the CQE. To make matters worse, once the target
> CQE has been posted, task_work is then queued with the originator to
> fill the completion.
> 
> This obviously adds a bunch of overhead and latency. Instead of relying
> on generic kernel task_work for this, fill an overflow entry on the
> target ring and flag it as such that the target ring will flush it. This
> avoids both the task_work for posting the CQE, and it means that the
> originator CQE can be filled inline as well.
> 
> In local testing, this reduces the latency on the sender side by 5-6x.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/msg_ring.c | 77 +++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 74 insertions(+), 3 deletions(-)
> 
> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
> index feff2b0822cf..3f89ff3a40ad 100644
> --- a/io_uring/msg_ring.c
> +++ b/io_uring/msg_ring.c
> @@ -123,6 +123,69 @@ static void io_msg_tw_complete(struct callback_head *head)
>   	io_req_queue_tw_complete(req, ret);
>   }
>   
> +static struct io_overflow_cqe *io_alloc_overflow(struct io_ring_ctx *target_ctx)
> +{
> +	bool is_cqe32 = target_ctx->flags & IORING_SETUP_CQE32;
> +	size_t cqe_size = sizeof(struct io_overflow_cqe);
> +	struct io_overflow_cqe *ocqe;
> +
> +	if (is_cqe32)
> +		cqe_size += sizeof(struct io_uring_cqe);
> +
> +	ocqe = kmalloc(cqe_size, GFP_ATOMIC | __GFP_ACCOUNT);

__GFP_ACCOUNT looks painful

> +	if (!ocqe)
> +		return NULL;
> +
> +	if (is_cqe32)
> +		ocqe->cqe.big_cqe[0] = ocqe->cqe.big_cqe[1] = 0;
> +
> +	return ocqe;
> +}
> +
...

-- 
Pavel Begunkov

