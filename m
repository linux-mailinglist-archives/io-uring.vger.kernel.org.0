Return-Path: <io-uring+bounces-6597-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6EBAA3F79C
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 15:45:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C523A1899CD4
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 14:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB69120E038;
	Fri, 21 Feb 2025 14:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BrE9uVnm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4451BD9E3;
	Fri, 21 Feb 2025 14:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740149138; cv=none; b=g1JNUjWfk9WgutUL/hIFAjNhoik0qNQfugQB/coPxa+nD1pRAa32mxcqVC6OQvyhAxIMCSgQqukfxptEltebpI1Cr1jyB3IRRTWs/xp6PYk4OZzhKSqV56eAq5csf269/fFjkxcJ8/zEJVoZ06ul+P6X6wFBzy53h/7/PPAMqWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740149138; c=relaxed/simple;
	bh=DU81Dzqf9nYlLXZdQFeD439P3RnYbz/S9yF5kLD83f0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MkeIn6rA1TMaByqTNnPc30rZgl82pxO3WkIvna9m6QwYBEZW4BEs2lR6fYFCah2NetPCkIKXV7chjop2DBgpB7lZ1/s2UaFerrkqpiFdYjjhf0nJBy6jU8dRJ6eh7gsW1p5obQAGRT4PBSYrqPJla4ut50BVf3jEGzcoYx8jNYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BrE9uVnm; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-220e83d65e5so41872655ad.1;
        Fri, 21 Feb 2025 06:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740149136; x=1740753936; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OLkuXsQgFCYp86gEVTAjBfuMhegyaq1OLkRJqJkDRcM=;
        b=BrE9uVnm4tsZaWunhj9oEqan7v59DSngJUWl+hfi8TgYyqR8AZO2jJy0XbDE0NcWPj
         i862VuBkpYIhTcXJ7919TCpu/mNBMAbBVGnpCEt9xiY/rRXiBQcICexW5KPJC7Y5j5DW
         jfm+kVZ/IsKwqxDogHDBAenasFWvImce4nhXKMYBG4wF4DA11LBq42kHH/AoizEMrNci
         ngNNJcq0xQ05dLPdTfyCM8HUywpuPWvQASWugVuEPUis6Yu7AXkdBf98pTQlAqv60HLm
         wrTaMRcC8l+crmYSsRgbrVynsuQrtXQdtnk6QCSID+lHg2mZujL3r07nOArllPymbb35
         3GEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740149136; x=1740753936;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OLkuXsQgFCYp86gEVTAjBfuMhegyaq1OLkRJqJkDRcM=;
        b=WP//ZRaPsWfP76yxDX16fDOC+pLC3VbrNZg+0TpsU/g10B0wNJDeUMCvFNvJfMbE6d
         fStP0ACFSuX+D7RjNlm1uQkHGH6qKSgBiiaEUNP5WjedAeEpcPjoNAyznF6u9/ceLvnj
         sISyTeSaGP5rkdSv4yL0mwDxI8D1JuVfFtJAkxEB73se3IAEFJ4p+w0pG3TGafHw50sP
         yhuDhsgmsaiOWgQg1Bazpqx1cvUdY9bpcnlA5NtxK1YaslrWLtAVOvfeTDs1PPbguT+f
         hKjkNycy15zF+9V71H9/qEFqtYHguSOfTA9UQj1E9X+Z5l39Z/f744gTjOWrQiQLcHGB
         AZBA==
X-Forwarded-Encrypted: i=1; AJvYcCWWZPkG7pAgPcfzsrPDsvAR7xOlVTaKpzHnZjpTS2EfUaRFNpR1CHw/+kd2aJEmVckiXtHhDM3yDg==@vger.kernel.org, AJvYcCXbiN/vDgdHvyCObY3ZtDilNhCYXLRQ+Y0MUfch7ofCj0RyEnPFM/hIUdjPPLZ4cdkBkf0Q6ZeYhm6DSgqG@vger.kernel.org
X-Gm-Message-State: AOJu0YwsdkDWzW9zW+59IPIVnU5fZC6Zd/JuaTERqqIZzb7SsAW4k2Dj
	JZHhKQWL7JXWVHW/4B8zA94GDRTTAFjsvMaPlJlC1eaXyNE1PIc7fIV4fQ==
X-Gm-Gg: ASbGncsjQh1OanHJgZtaZUP4H16E72kj+acNjwe6+S6JiHoo/exJX6T/hOhI65s1CN2
	Hh/qsQ5GLXeSo8DMB2etNeAHIQ3+dRvho5dHFPi+x1WYSnOlpE7kChFWbMU1VZXzJMV+kfu893O
	MCCKcUBt1Pbkk94ytlKok3rVYdcD+4Q97J1oH7OKoO9rObiwbRUTitdoK21F4/A4UjQZ7JAr9bi
	G/BOsGhZ2oBWNrWQAKLFg9wPUkZcLseizHyjgANnt7eLlaWYxuHi2HG8rVeHVDQ/z1Gfu987E/0
	mjHFoooIxpaItzA0KZF3L8Al2YhBIM7cXw7seIrHJABH1RMrsmOp/sac09bt8DU8TnZh5aDIG7k
	Cyg==
X-Google-Smtp-Source: AGHT+IGXxbxC1Sxa/QsWuayI5lvCwrwS+z88VBylGY4ycncOWJj0brxvQ6WjZcoQrI94iybZR3dn8Q==
X-Received: by 2002:a05:6a20:3d85:b0:1ee:69aa:b665 with SMTP id adf61e73a8af0-1eef3d90d7dmr6241260637.29.1740149136149;
        Fri, 21 Feb 2025 06:45:36 -0800 (PST)
Received: from ?IPV6:2001:ee0:4f4d:ece0:3744:320e:7a6:5279? ([2001:ee0:4f4d:ece0:3744:320e:7a6:5279])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-adb57c5dcb6sm14273623a12.7.2025.02.21.06.45.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 06:45:35 -0800 (PST)
Message-ID: <c726ead9-e590-4733-953c-f5d8dd5d6600@gmail.com>
Date: Fri, 21 Feb 2025 21:45:31 +0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring/io-wq: try to batch multiple free work
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
References: <20250221041927.8470-1-minhquangbui99@gmail.com>
 <20250221041927.8470-3-minhquangbui99@gmail.com>
 <f34a5715-fae0-406e-a27b-7e94e3113641@gmail.com>
Content-Language: en-US
From: Bui Quang Minh <minhquangbui99@gmail.com>
In-Reply-To: <f34a5715-fae0-406e-a27b-7e94e3113641@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/25 19:44, Pavel Begunkov wrote:
> On 2/21/25 04:19, Bui Quang Minh wrote: >> Currently, in case we don't use IORING_SETUP_DEFER_TASKRUN, when >> 
io worker frees work, it needs to add a task work. This creates >> 
contention on tctx->task_list. With this commit, io work queues >> free 
work on a local list and batch multiple free work in one call >> when 
the number of free work in local list exceeds >> IO_REQ_ALLOC_BATCH. > > 
I see no relation to IO_REQ_ALLOC_BATCH, that should be a separate > 
macro. > >> Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com> --- 
 >> io_uring/io-wq.c | 62 ++++++++++++++++++++++++++++++++++++++++++ >> 
+-- io_uring/io-wq.h | 4 ++- io_uring/io_uring.c | 23 +++++++++ >> 
+++++--- io_uring/io_uring.h | 6 ++++- 4 files changed, 87 >> 
insertions(+), 8 deletions(-) >> >> diff --git a/io_uring/io-wq.c 
b/io_uring/io-wq.c index >> 5d0928f37471..096711707db9 100644 --- 
a/io_uring/io-wq.c +++ b/ >> io_uring/io-wq.c > ... >> @@ -601,7 +622,41 
@@ static void io_worker_handle_work(struct >> io_wq_acct *acct, 
wq->do_work(work); >> io_assign_current_work(worker, NULL); - linked = 
wq- >> >free_work(work); + /* + * All requests in >> free list must have 
the same + * io_ring_ctx. >> + */ + if (last_added_ctx && >> 
last_added_ctx != req->ctx) { + >> flush_req_free_list(&free_list, 
tail); + tail = >> NULL; + last_added_ctx = NULL; + >> free_req = 0; + } 
+ + /* + * Try >> to batch free work when + * ! >> 
IORING_SETUP_DEFER_TASKRUN to reduce contention + * on >> 
tctx->task_list. + */ + if (req->ctx->flags >> & 
IORING_SETUP_DEFER_TASKRUN) + linked = wq- >> >free_work(work, NULL, 
NULL); + else + >> linked = wq->free_work(work, &free_list, &did_free); 
 > > The problem here is that iowq is blocking and hence you lock up > 
resources of already completed request for who knows how long. In > case 
of unbound requests (see IO_WQ_ACCT_UNBOUND) it's indefinite, > and it's 
absolutely cannot be used without some kind of a timer. But > even in 
case of bound work, it can be pretty long.

That's a good point, I've overlooked the fact that work handler might 
block indefinitely.

> Maybe, for bound requests it can target N like here, but read > jiffies in between each request and flush if it has been too long. > 
So in worst case the total delay is the last req execution time + > DT. 
But even then it feels wrong, especially with filesystems > sometimes 
not even honouring NOWAIT. > > The question is, why do you force it into 
the worker pool with the > IOSQE_ASYNC flag? It's generally not 
recommended, and the name of > the flag is confusing as it should've 
been more like > "WORKER_OFFLOAD".

I launched more workers to parallel the work handler, but as you said, 
it seems like an incorrect use case.

However, I think the request free seems heavy, we need to create a task 
work so that we can hold the uring_lock to queue the request to 
ctx->submit_state->compl_reqs. Let me play around more to see if I can 
find an optimization for this.


Thank you,

Quang Minh.




