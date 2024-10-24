Return-Path: <io-uring+bounces-4010-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C049AF39C
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 22:26:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27CFE1F22FC6
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 20:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BB461AF0A0;
	Thu, 24 Oct 2024 20:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MOi5SFrm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB52189F5E
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 20:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729801558; cv=none; b=r0tdm6/HSNTead+gly9is40vZ31tmTAOgSOUPG0fSJJ6SHyS8o8Lq/Us8pqOXU1Y91t1A1+PppMoVXBuBYl2DemjUhau1OX9073Fs18OYUm+z2FqNm3M15x/zjMy4Y7QGQD4lIC9ck3+oZke4B0+kTR4nxE9uff4kuHRTIhOrm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729801558; c=relaxed/simple;
	bh=I5bN5IUf9+GOTUIMjvqdOlqmyMLZDXtCeSJAloy0t6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jozT2GELwZwjO6+sDZNSpszTfvIXnFAxtjpog6LuwHP+uv3K2VKrPtxywrKI/CBpQuM+1tMUaLyY+sCV5LpKANQ7JbaAAK6SJ2IVNgnvpe04UvRc3oUn0Ptd/IWicopo7eD5Xdy9bExZ8wWNd8mt9ZXB+PPAfV/ZZKGZgn2Ji1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MOi5SFrm; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-20cbca51687so11971055ad.1
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 13:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729801553; x=1730406353; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VUKAzNlnO3Lw1lgIRHKwvl59oFwt1VROigpnuSP76dE=;
        b=MOi5SFrmlAOtFiqHQV+oclCzYeiogGgbCMFEuvihquzq2xWI8jTpFMgF3TEyMkHIsD
         h0qeVQK5q/AwxNlh+471Q3WmxR+WId2WxWOGg6sxGmN0WJ2pA15oAzbdTH6sz27CsuCQ
         9gECyRaN2zgU0v8YPnDLxsjqvju31bP5x5pX/zwI8c0TCmoF5/lEJPjN7dOXb/WnSrqp
         pZB8/j26txYxG/twFh01lCKo9oRt8JRTH8ziRjUUDCxYc61VPE86mLuQgmTO/LpdCyve
         a9WwQ4wnBTTqpjSJ+ntGHhw1u8WhHjRfFu046ycw92UOyI2S0bZ8bFC6GpamhEbyr5TJ
         2bpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729801553; x=1730406353;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VUKAzNlnO3Lw1lgIRHKwvl59oFwt1VROigpnuSP76dE=;
        b=a4nx23GNNV7ByBltKqb73XfsdXA9oeBBnYkb0R/cVFP7vG5MiBHDzLEzuDhTNdhfXk
         3iMkB7fvHFMXwpeUrQr9ct316dnYsHQCmNOe3Hd1Am54dC8PO2J+LaCnOrLyQlvi3szB
         Fkag0CjbzJbkTEsabMrBHP1DT4c4X0thzkwGRbwBVmUMYD0Q5YmJ9FG4tAtCYTaJwNHY
         q1Lthospy0JF64QYCj3fBjQzJ9aKkN7UBpVFHt1jehPTaCGF/OmqVxhSPruw7Wi/Y4zc
         d6vkLRNEKldX5TWhP6D3M37frwA+B3uiNrLeiYsEcbEjJtPLuGj3JgvTQrp9PqDuAghE
         l5bw==
X-Gm-Message-State: AOJu0YzFmYzldSaruq98MdP1UrRYVBGoav/t3Ffl8B3P3aqHJto94Pru
	i6e9x/Mgt8FoBQNhhe1P9EGCCFS5sfDpqwSj800NYHhkGA5ZAB1rhIuvZ3aYixgXRs0kpJqNE0+
	C
X-Google-Smtp-Source: AGHT+IHuDc10JT55pvaWkG/4+vMsq6fU9dGw47J3wndBOaY/21riXBff+TG2gJorhyq440/xAkMD2g==
X-Received: by 2002:a17:902:da8d:b0:20b:ab6a:3a18 with SMTP id d9443c01a7336-20fa9e0abfamr106320135ad.17.1729801552914;
        Thu, 24 Oct 2024 13:25:52 -0700 (PDT)
Received: from ?IPV6:2600:380:4913:24d7:7c30:fdbf:222f:79ea? ([2600:380:4913:24d7:7c30:fdbf:222f:79ea])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f0bd4f1sm75953665ad.128.2024.10.24.13.25.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 13:25:52 -0700 (PDT)
Message-ID: <a55927a1-fa68-474c-a55b-9def6197fc93@kernel.dk>
Date: Thu, 24 Oct 2024 14:25:50 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring/register: add IORING_REGISTER_RESIZE_RINGS
To: Jann Horn <jannh@google.com>
Cc: io-uring@vger.kernel.org
References: <20241024170829.1266002-1-axboe@kernel.dk>
 <20241024170829.1266002-5-axboe@kernel.dk>
 <CAG48ez3kqabFd3F6r8H7eRnwKg7GZj_bRu5CoNAjKgWr9k=GZw@mail.gmail.com>
 <aaa3a0f3-a4f8-4e99-8143-1f81a5e39604@kernel.dk>
 <CAG48ez3KJwLr8REE8hPebWtkAF6ybEGQtRnEXYYKKJKbbDYbSg@mail.gmail.com>
 <1384e3fe-d6e9-4d43-b992-9c389422feaa@kernel.dk>
 <CAG48ez2iUrx7SauNXL3wAHHr7ceEv8zGNcaAiv+u2T8_cDO7HA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAG48ez2iUrx7SauNXL3wAHHr7ceEv8zGNcaAiv+u2T8_cDO7HA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 2:08 PM, Jann Horn wrote:
> On Thu, Oct 24, 2024 at 9:59?PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 10/24/24 1:53 PM, Jann Horn wrote:
>>> On Thu, Oct 24, 2024 at 9:50?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 10/24/24 12:13 PM, Jann Horn wrote:
>>>>> On Thu, Oct 24, 2024 at 7:08?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>> Add IORING_REGISTER_RESIZE_RINGS, which allows an application to resize
>>>>>> the existing rings. It takes a struct io_uring_params argument, the same
>>>>>> one which is used to setup the ring initially, and resizes rings
>>>>>> according to the sizes given.
>>>>> [...]
>>>>>> +        * We'll do the swap. Clear out existing mappings to prevent mmap
>>>>>> +        * from seeing them, as we'll unmap them. Any attempt to mmap existing
>>>>>> +        * rings beyond this point will fail. Not that it could proceed at this
>>>>>> +        * point anyway, as we'll hold the mmap_sem until we've done the swap.
>>>>>> +        * Likewise, hold the completion * lock over the duration of the actual
>>>>>> +        * swap.
>>>>>> +        */
>>>>>> +       mmap_write_lock(current->mm);
>>>>>
>>>>> Why does the mmap lock for current->mm suffice here? I see nothing in
>>>>> io_uring_mmap() that limits mmap() to tasks with the same mm_struct.
>>>>
>>>> Ehm does ->mmap() not hold ->mmap_sem already? I was under that
>>>> understanding. Obviously if it doesn't, then yeah this won't be enough.
>>>> Checked, and it does.
>>>>
>>>> Ah I see what you mean now, task with different mm. But how would that
>>>> come about? The io_uring fd is CLOEXEC, and it can't get passed.
>>>
>>> Yeah, that's what I meant, tasks with different mm. I think there are
>>> a few ways to get the io_uring fd into a different task, the ones I
>>> can immediately think of:
>>>
>>>  - O_CLOEXEC only applies on execve(), fork() should still inherit the fd
>>>  - O_CLOEXEC can be cleared via fcntl()
>>>  - you can use clone() to create two tasks that share FD tables
>>> without sharing an mm
>>
>> OK good catch, yes then it won't be enough. Might just make sense to
>> exclude mmap separately, then. Thanks, I'll work on that for v4!
> 
> Yeah, that sounds reasonable to me.

Something like this should do it, it's really just replacing mmap_sem
with a ring private lock. And since the ordering already had to deal
with uring_lock vs mmap_sem ABBA issues, this should slot straight in as
well.

Totally untested, will write a fork() test case as well for the
resize-rings test cases.

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 9746f4bb5182..2f12828b22a4 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -423,6 +423,13 @@ struct io_ring_ctx {
 	/* protected by ->completion_lock */
 	unsigned			evfd_last_cq_tail;
 
+	/*
+	 * Protection for resize vs mmap races - both the mmap and resize
+	 * side will need to grab this lock, to prevent either side from
+	 * being run concurrently with the other.
+	 */
+	struct mutex			resize_lock;
+
 	/*
 	 * If IORING_SETUP_NO_MMAP is used, then the below holds
 	 * the gup'ed pages for the two rings, and the sqes.
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d0b6ec8039cb..2863b957e373 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -353,6 +353,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
 	INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
 	io_napi_init(ctx);
+	mutex_init(&ctx->resize_lock);
 
 	return ctx;
 
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index d614824e17bd..fc777de2c229 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -251,6 +251,8 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned int npages;
 	void *ptr;
 
+	guard(mutex)(&ctx->resize_lock);
+
 	ptr = io_uring_validate_mmap_request(file, vma->vm_pgoff, sz);
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);
@@ -274,6 +276,7 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
 					 unsigned long len, unsigned long pgoff,
 					 unsigned long flags)
 {
+	struct io_ring_ctx *ctx = filp->private_data;
 	void *ptr;
 
 	/*
@@ -284,6 +287,8 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
 	if (addr)
 		return -EINVAL;
 
+	guard(mutex)(&ctx->resize_lock);
+
 	ptr = io_uring_validate_mmap_request(filp, pgoff, len);
 	if (IS_ERR(ptr))
 		return -ENOMEM;
@@ -329,8 +334,11 @@ unsigned long io_uring_get_unmapped_area(struct file *file, unsigned long addr,
 					 unsigned long len, unsigned long pgoff,
 					 unsigned long flags)
 {
+	struct io_uring_ctx *ctx = file->private_data;
 	void *ptr;
 
+	guard(mutex)(&ctx->resize_lock);
+
 	ptr = io_uring_validate_mmap_request(file, pgoff, len);
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);
diff --git a/io_uring/register.c b/io_uring/register.c
index 0f6b18b3d3d1..1eb686eaa310 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -486,14 +486,15 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	}
 
 	/*
-	 * We'll do the swap. Clear out existing mappings to prevent mmap
-	 * from seeing them, as we'll unmap them. Any attempt to mmap existing
-	 * rings beyond this point will fail. Not that it could proceed at this
-	 * point anyway, as we'll hold the mmap_sem until we've done the swap.
-	 * Likewise, hold the completion * lock over the duration of the actual
-	 * swap.
+	 * We'll do the swap. Grab the ctx->resize_lock, which will exclude
+	 * any new mmap's on the ring fd. Clear out existing mappings to prevent
+	 * mmap from seeing them, as we'll unmap them. Any attempt to mmap
+	 * existing rings beyond this point will fail. Not that it could proceed
+	 * at this point anyway, as the io_uring mmap side needs go grab the
+	 * ctx->resize_lock as well. Likewise, hold the completion lock over the
+	 * duration of the actual swap.
 	 */
-	mmap_write_lock(current->mm);
+	mutex_lock(&ctx->resize_lock);
 	spin_lock(&ctx->completion_lock);
 	o.rings = ctx->rings;
 	ctx->rings = NULL;
@@ -560,7 +561,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	ret = 0;
 out:
 	spin_unlock(&ctx->completion_lock);
-	mmap_write_unlock(current->mm);
+	mutex_unlock(&ctx->resize_lock);
 	io_register_free_rings(&p, to_free);
 
 	if (ctx->sq_data)

-- 
Jens Axboe

