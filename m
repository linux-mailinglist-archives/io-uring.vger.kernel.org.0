Return-Path: <io-uring+bounces-7071-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17C50A5F32E
	for <lists+io-uring@lfdr.de>; Thu, 13 Mar 2025 12:50:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 092421890CD1
	for <lists+io-uring@lfdr.de>; Thu, 13 Mar 2025 11:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D26D26869D;
	Thu, 13 Mar 2025 11:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BZURCnv0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93C01FAC5A
	for <io-uring@vger.kernel.org>; Thu, 13 Mar 2025 11:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741866293; cv=none; b=qV580y/kTh2ISAH6ht1tibxVTvs0uizrs51c8jRA65TAM8dnmcsJPkHmRuzEkyNt1rcDKGcl+xbZ7GquBiQlG2pdh8I60r6n15RX3y7y3690/aBctSVMQxYeRv6U06iiH0DRJ7iJ3505KXYbg8ynlPr2RtWpexCgBuCMbCSxfP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741866293; c=relaxed/simple;
	bh=NXl1n3p8QHYL9t33kprYE487+Jvior6WSgQbFflFOcM=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=sQ/2U7IprEfRy3QO5z1wU0TOnF/Zg/51rgrlUBoP6VlB9Oqicj0L9B1KbO3EULkyGXdcmqPugDX0y85zc2xEGaXpmuAIrFhJyc+GZ28+hawgw4YfYrhecxmSL9T6iEHL+f1Ox9urgqdsOBZlKFj7U2IEf14jk5kUtgqaBL1ZypU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BZURCnv0; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3d03d2bd7d2so8729855ab.0
        for <io-uring@vger.kernel.org>; Thu, 13 Mar 2025 04:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741866289; x=1742471089; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s+v48lbxZUu071LEemghCjKImRwZF6oHZSHUEFUZvNE=;
        b=BZURCnv0AaJXp07JJOS/s/1HTMLmqQqpuAEzw9dXSGoBZdFQgizCQH4C9+vONvvZZq
         CEAhOf/6NO5oqGQm/iXzPBf7IPP6cQRUaf641c5mC1FRmNZLVFmcu4xlu+8ImJc7JeN/
         NfNtVMXgrb7/A1IxC5jCS9Zto0RZuyfKGg3dZfpZEr4JHTE9go0DJzXxhn+UWFCdcZO5
         obY0ncef9e+rx2JwI+oc0eXtTkQyKS7gNWDbZrVz2IAv7+eCI4R+Jc/eoR+AGqrrE5uO
         F4HU8JLl8gqY1LBkFYdvkjm/UG6yCpPkEmR3Zoq4udEgSlMIHq7jWtBFJJX2DwbE3RM5
         97nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741866289; x=1742471089;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=s+v48lbxZUu071LEemghCjKImRwZF6oHZSHUEFUZvNE=;
        b=HPs7V/YM0h/shNKaTM9DJjpa7xRu8hIhc1wUUKgsHW4Bq4xdAKxHN2gtwhA8IMu3Nx
         nJMke4TUgzqzbRK/gVBeGogIuP6Lo8NlzokhwsZ95nw7tZXcpvRdep0rFS2U83Lv6H1i
         nCEMBMcegBhM70J80wXBkn64fJpCt/Hob9ueBcR7jSTySQmNcZpFYGnBa9aC9gYr8tvB
         OE/xvhj+oepRDIFZAMSmFWGe48N1OY3LZ+nKYyuk0A8IT9fdsbXm7T+E6GtLlh4TUq9s
         EHQ2HKW6P+784pXVSYz2jrZJxSYSCdz4mS9Qpy7LpdKNVOmCW/5DPa9a2a9Mc32yB8Ar
         2s2A==
X-Gm-Message-State: AOJu0Ywwjx0b39Xn7eaW3A62SDzPZ6kUyMlIZhB5hx0GN2i9oZnMpWbO
	ZF8pbx/8T0ODOCxuNYArqT9tGfl+WJF//A6gFokZK7eHnGzKlqleQoAxQkcW1Hr+dH5q0VxC9SY
	o
X-Gm-Gg: ASbGncujVuxrzkpQMLd1EoZ9NfB/CqIH2XuN0PMJr/Ze9aTYohsamsWNbUh2SFa5H/l
	J61nRHuZLpQzSL1dF8/suuoTSMSqF/bcfUIlOtHvWKOcd9P73oLXdtLJ0JBqBc0e8pYFtzdl4hp
	py9P6PlQmwOZNuGs9LzDCj+l+YLdTgfMfi/x7qRLQ9GGjXDOu3D+C13qZHINXlJBXShNhQr9pa9
	MS8HlaUcAiK/KEzQz6geo1KuyS6Bmo+5DtT6b0dCklbLRTI85XXPxkAZvXNZfpngdZxw4uzmySf
	1j64w4yEXeUQmiJn4pGVTBAW3Czb8igQNN6LHBMwUw==
X-Google-Smtp-Source: AGHT+IG4BovY6HccycTT8JLWnFxsYThxxFckaApBTeS+ShAenJHDO+NdXrzySp44Ai2f3qrf1CLvqQ==
X-Received: by 2002:a05:6e02:219c:b0:3d3:e41b:936f with SMTP id e9e14a558f8ab-3d44187c07emr291778885ab.3.1741866288981;
        Thu, 13 Mar 2025 04:44:48 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2638147d7sm291968173.122.2025.03.13.04.44.47
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Mar 2025 04:44:48 -0700 (PDT)
Message-ID: <a41f0843-21dd-469a-bc01-420a59f3ef45@kernel.dk>
Date: Thu, 13 Mar 2025 05:44:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/memmap: move vm_flags_set() outside of
 ctx->mmap_lock
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

syzbot complaints that sometimes the ordering between ctx->mmap_lock
and vma->vm_lock->lock aren't the same, which obviously makes lockdep
unhappy.

We'd normally expect the ctx->mmap_lock to nest inside the vma lock,
but vm_flags_set() -> vma_start_write() from the ->mmap() patch can
happen in the opposite order.

Move the vm_flags_set() to before ctx->mmap_lock is grabbed. This does
potentially leak the VM_DONT_EXPAND set for that vma, and while that
could get cleared, doesn't look like it's necessary to do so. Hence just
keep it simple.

Reported-by: syzbot+96c4c7891428e8c9ac1a@syzkaller.appspotmail.com
Link: https://lore.kernel.org/io-uring/67d0bee4.050a0220.14e108.001f.GAE@google.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 361134544427..d325b6ab6b99 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -309,7 +309,6 @@ static int io_region_mmap(struct io_ring_ctx *ctx,
 {
 	unsigned long nr_pages = min(mr->nr_pages, max_pages);
 
-	vm_flags_set(vma, VM_DONTEXPAND);
 	return vm_insert_pages(vma, vma->vm_start, mr->pages, &nr_pages);
 }
 
@@ -322,6 +321,8 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	struct io_mapped_region *region;
 	void *ptr;
 
+	vm_flags_set(vma, VM_DONTEXPAND);
+
 	guard(mutex)(&ctx->mmap_lock);
 
 	ptr = io_uring_validate_mmap_request(file, vma->vm_pgoff, sz);

-- 
Jens Axboe


