Return-Path: <io-uring+bounces-7067-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 248C0A5E5A3
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 21:54:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E10B16A78B
	for <lists+io-uring@lfdr.de>; Wed, 12 Mar 2025 20:54:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E2761E9B04;
	Wed, 12 Mar 2025 20:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qLInnF3t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3553D81
	for <io-uring@vger.kernel.org>; Wed, 12 Mar 2025 20:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741812848; cv=none; b=a3jDepYo+738CjRMcFSKiNcLpQmQadG9r3+rdd0YRzAagXWT3XhBuUHSveoCmrW2JikPUDVAwEEeWiUnk3hejvpy4/+9O4PNYKdiF2qx/saPf+CyfeV/2dvS47x7VuAvEF4RiHKix0FlQH1Ps+NbAR1ktDLz2mdgY8q/8GqUq+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741812848; c=relaxed/simple;
	bh=DXSo/AARNRbRkGlPXt4rqTs8Rz3Z5GaAFHVdjYcdPQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MMtCrW97cmWYd9t+3OygOkQDdgqSLtmYP1ig4nlTIqrTHhXaIX3N5JSRpWyKJ9cuZAZOJdM/rFs/jTucpfHV09m2wIaZWkJOMc4Cqidt65/XPcFqFT8QPpy/t7br/YoozbmgSFUbjb92mvHXGblQx1oV+pGz7o7st2EhiMtYRMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qLInnF3t; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-85ae4dc67e5so11179939f.2
        for <io-uring@vger.kernel.org>; Wed, 12 Mar 2025 13:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741812844; x=1742417644; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nGkc/HsqNjPMc69ATOsv5UcZ0yYP7/GpqqJyOxIH5G4=;
        b=qLInnF3td2SwTSg2uKjy1Anpi8J6rAqMqLRZVz8k3X+wE4+rBPxXlNutWLWP5wIUhn
         QwKDXxiw9iIXNgg69ZcNdiK+mbgU3G8zAKY0RqgSg07I3SEDE5VJouBVA9GZrnWW4kJz
         s2PNKZqvmTE3UiYXHF/sFDmccPE8fuEwV6MlwGCuHonTuKHFu18wrC/9HgdzzmRE3QR6
         xT1C4Wrw9ewWaOQuUSsVFr8LdOmLZBM4uj+FphLpQHwHivXWKwmmoibWw1cPjfLwhG9r
         8KAZ7I4LE9z35Dy9ly1rlsVtXg8NUeYRk26r+j+nuW2EXeSKQUeU2OTcCVo9dMVgabaD
         hgwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741812844; x=1742417644;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nGkc/HsqNjPMc69ATOsv5UcZ0yYP7/GpqqJyOxIH5G4=;
        b=Zb45uP/DGuKn9NJ5rO0m0L7aDJNJHC2AP64dL7l8MnmSRA5LMzzC8y+XyRzjpvJ8ZU
         sl7MrPrEoQwuLpCecM9ClHM08BKhwH6fjf31b2X0+oLgs7XwbCpotF7xAMlBDpSNpBOw
         FucDfIdXUi3f7FDndjr0SYkkIFIj3svVpYmX7gW9BGVVl4nrDGWkqMbBExzc2Wl3yjrh
         6OpU6rb60N5RHZ+kuFS2/OnEn0aUYtdsXd1rzPVy/y4dDVpdTYD4TV67sTsla4tDh7jD
         GfU3fMWciZtPyOXKuIHtTmNsg9hOEggCbd4z1wrQX8KCK64k5McjNR/+EizrbrVfx+e5
         v9HQ==
X-Forwarded-Encrypted: i=1; AJvYcCURJuicrsErirtCivXXN8Pf40x++6MdOXi5H6xiMiRu4tKMDHuRMBO4/DEnxJM1AAFrUVlfNx36nA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9zxAkI+uW+qM4EzWYKFsUY9f5OskAI2NGgjrzJ8X2ohKK3Ehk
	fCy1Mf2e61oi5nzvhByG7eVm2hIdSxwXelZIlu2uX6JZT8Vo0a8T0/7joLdfOaw=
X-Gm-Gg: ASbGncs8J7nBQ8+vXrpTHotKzdfwdCf/wKiYhKL12cywN+aNj28btfA4EjP7CCk37ht
	E3AqsGlKCELN2nj9Qo2YicQ4l4Ms1lzm5YPtD4pqFsEFCQXsLP4DNjoONVJpKrN58e46ZAdUuh+
	RrY0iET9ymwBuYdHcvO5/nxFufxP5Z/DO96GW0Ry/J8RkUS/LPTQijDr52pQNI16sQdtCLPUtB9
	RX/K+BhEAKxWBkyRtRC6FeSvghcEsS6OuX8Ch9BLF4y4nTGAa2sAJfX41gHTE+1qnGzM+YJXhc3
	OCVO2G8o5YqUa+h0GEEUEBDbAQqpxCJM7RKOuSzO
X-Google-Smtp-Source: AGHT+IFqtgkrRv5kgFAR8EC7J+G1ndYiYnAUZ21tfLuFxL+rv+ZsCZpp+xykY/ZRBHVekXMHNfhp5Q==
X-Received: by 2002:a05:6602:6cc4:b0:85b:59f3:2ed3 with SMTP id ca18e2360f4ac-85b59f33589mr1471463239f.8.1741812844024;
        Wed, 12 Mar 2025 13:54:04 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-85b5e8be48esm106836739f.19.2025.03.12.13.54.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 13:54:03 -0700 (PDT)
Message-ID: <8ca3d37a-19cd-4adc-9f2e-37be77e9a89b@kernel.dk>
Date: Wed, 12 Mar 2025 14:54:02 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] possible deadlock in io_uring_mmap
To: syzbot <syzbot+96c4c7891428e8c9ac1a@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <67d0bee4.050a0220.14e108.001f.GAE@google.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <67d0bee4.050a0220.14e108.001f.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/11/25 4:53 PM, syzbot wrote:
> ======================================================
> WARNING: possible circular locking dependency detected
> 6.14.0-rc5-syzkaller-g77c95b8c7a16 #0 Not tainted
> ------------------------------------------------------
> syz.3.85/7036 is trying to acquire lock:
> ffff0000cf4f89b8 (&vma->vm_lock->lock){++++}-{4:4}, at: vma_start_write include/linux/mm.h:770 [inline]
> ffff0000cf4f89b8 (&vma->vm_lock->lock){++++}-{4:4}, at: vm_flags_set include/linux/mm.h:900 [inline]
> ffff0000cf4f89b8 (&vma->vm_lock->lock){++++}-{4:4}, at: io_region_mmap io_uring/memmap.c:312 [inline]
> ffff0000cf4f89b8 (&vma->vm_lock->lock){++++}-{4:4}, at: io_uring_mmap+0x37c/0x504 io_uring/memmap.c:339
> 
> but task is already holding lock:
> ffff0000f51da8d8 (&ctx->mmap_lock){+.+.}-{4:4}, at: class_mutex_constructor include/linux/mutex.h:201 [inline]
> ffff0000f51da8d8 (&ctx->mmap_lock){+.+.}-{4:4}, at: io_uring_mmap+0x100/0x504 io_uring/memmap.c:325
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #9 (&ctx->mmap_lock){+.+.}-{4:4}:
>        __mutex_lock_common+0x1f0/0x24b8 kernel/locking/mutex.c:585
>        __mutex_lock kernel/locking/mutex.c:730 [inline]
>        mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:782
>        class_mutex_constructor include/linux/mutex.h:201 [inline]
>        io_uring_get_unmapped_area+0x84/0x348 io_uring/memmap.c:357
>        __get_unmapped_area+0x1d8/0x364 mm/mmap.c:846
>        do_mmap+0x4a8/0x1150 mm/mmap.c:409
>        vm_mmap_pgoff+0x228/0x3c4 mm/util.c:575
>        ksys_mmap_pgoff+0x3a4/0x5c8 mm/mmap.c:607
>        __do_sys_mmap arch/arm64/kernel/sys.c:28 [inline]
>        __se_sys_mmap arch/arm64/kernel/sys.c:21 [inline]
>        __arm64_sys_mmap+0xf8/0x110 arch/arm64/kernel/sys.c:21
>        __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>        invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
>        el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
>        do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>        el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
>        el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
>        el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

Not sure I see how this isn't either happening all the time, or
happening at all... But in any case, it seems trivial to move the vma
lock outside of a dependency with the ctx mmap_lock, we can just set
VM_DONTEXPAND upfront. Yes that'll leave it set in case we fail, which
should be fine as far as I can tell (though it'd be trivial to clear it
again).


diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 76fcc79656b0..aeaf4be48838 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -311,7 +311,6 @@ static int io_region_mmap(struct io_ring_ctx *ctx,
 {
 	unsigned long nr_pages = min(mr->nr_pages, max_pages);
 
-	vm_flags_set(vma, VM_DONTEXPAND);
 	return vm_insert_pages(vma, vma->vm_start, mr->pages, &nr_pages);
 }
 
@@ -324,6 +323,8 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	struct io_mapped_region *region;
 	void *ptr;
 
+	vm_flags_set(vma, VM_DONTEXPAND);
+
 	guard(mutex)(&ctx->mmap_lock);
 
 	ptr = io_uring_validate_mmap_request(file, vma->vm_pgoff, sz);

-- 
Jens Axboe

