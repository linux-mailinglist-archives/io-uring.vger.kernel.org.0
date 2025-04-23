Return-Path: <io-uring+bounces-7686-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 807C7A99BCC
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 00:58:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 709E71B81F4C
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 22:58:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 613BE2144B7;
	Wed, 23 Apr 2025 22:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SNAREsU3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9A21FE45D
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 22:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745449083; cv=none; b=ioKGi62G6zltbVUgxgxiAqnizQAZxQQVx+RsySEu3G0ofqtG7kQGoLwbURgJlaIIxydvWhTEWnv/008eCyfAPcEcGEsH5+15J/ZZtIogIsysmnj8tV6SVccD12rvtLPWNnMSmPCz79TZ6fVX4swwkE8bUkWB2qDVwdmaYLZFZuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745449083; c=relaxed/simple;
	bh=/4UucL9OcZlLE1S45vGuepvKmt16lIs23KtTTy+xA0I=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=PAHJD7z/ld7JQqalsYBrx/t9fx1r1XBlz5VE8TvoqWdKGj4uf/z5CpPE+bwRNYseb0K+cEaTLyqIc7iC0/QlX+moR3fJKV0mm5Y/OZOZUbgMVVZXz4JDTCPeHPZY8D6grqttchCKEGbM5pAIpXvZstU7U1Sxe597NGrbnZOeUG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SNAREsU3; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3d91b55bd39so2359645ab.0
        for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 15:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745449080; x=1746053880; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nEu7FtyxOTjoxH8k/xvlBTXItgCBkcLdRHMwp3SvrfA=;
        b=SNAREsU3vTSMUcc6Id3hic0KSOkZuL2+Zb9NbZ0OBj323wHoTP1G26s48H4UJBudap
         5Rc+4NtpkasQc4/rmp+ocS/9D6zfRoaxh3D68GHErIBGhR8otlUShlkJ/SYYAfiOVWtQ
         x6IajrALIfjUFoXMbu+zFtFVmjxcSnpc7jx/yVW+jlDnDWrPPT8b+/xfb9hhZy8U0ZUN
         tJPPPozsB/JN3k5aMVpdna07BLJVvmkFOAE8uL3wjNMCyqyVydJJiUVteZHNYEYCC+lh
         Y2M50syLASatyEQJfSNxNBnZ9+vr+GJyXkcE5p6J7MlT2hzjNl5O96M04/RbtVLRXAfX
         /XaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745449080; x=1746053880;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nEu7FtyxOTjoxH8k/xvlBTXItgCBkcLdRHMwp3SvrfA=;
        b=pSzh13MJEBavJOaG9EqNSDWODE8scVjjX3pdNmU6Z0RbNDpdj6XZ6lvQ8Jbts0ZICr
         V6UmBOKvLO+ovOm077NU6Y+jviC1BULoX97pblJavdo5yERnFAQQ2EQ4AhOkeN5eI6W8
         BJhSErUROlnoGRDOmtqV8AhteMEZfHq6WmYsqlz8M9PfwYgkTSuSSGS0y0OKzGgVxztK
         ohcWv8uTj1r8Rw6iOHZ0NKM0h3TFBc75GlrRGenfUl6/DQ1tNV5/AFE1+aM8EG7d5Jrb
         x/9PLgMW1RGy15TFGtdI7ZKN8JiHb/tW/XBjYzudCyG8iz4uHiat+95NDYMDK/X+tLqn
         hgyQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6EAeK22I9T4aTb0PcjrK3gLA1nwrOldfOR/KNb1fW7Fifrp8fetGSeg3u5CL+MXvI4Ymls/zcxw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyyzTSH2z48XQ7YK7LRJp6SN2vsAw7YAFz2sN80WlGbxV/Rvx5l
	wP4QQu8wDEnE74/vwkbxN3OZs2qWWIyXVsDKb5GU2NXEpiImBWZAJHrqNyKE9Fk=
X-Gm-Gg: ASbGnctIATrkZQZ0jt2cNbry95/24BajCuT4XlG+tk64R8/LuF8nm2amKDlgy3/ST6i
	Hqy2RPoCvbCkFJbLTCMcQdqYC3Z2iWqcDq5HeZdrAifpPXV/rpPKgn+CnoQ/GtKzC6LRzGBrmOX
	vOih2EI7oxSBkglLtQFR8//sD4vdNa4njLeD6IZ5DffSllU51gXcQz39jvi+BGqaa3Ba61siUTf
	wZ+fdt6H+f3RfKl51jaVPZcgCYzniNCb0qLlfvfjBPxLP+7qJaWRoeI1ufVxL1jfPJhVQSjnF1a
	RPgBx3WJODW5GZhUGINNS90K4MxCQc6S/c9kZFQZNf/jukg1
X-Google-Smtp-Source: AGHT+IH1BGArJHSmQ1z4igvxLHm34FM/Kao2fQH/vkfme/lYyWZaPS1lcFv9aGEXqQEZu1RKSF8Qag==
X-Received: by 2002:a05:6e02:1a25:b0:3d8:975:b825 with SMTP id e9e14a558f8ab-3d93038f94bmr5164455ab.5.1745449079826;
        Wed, 23 Apr 2025 15:57:59 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d9314b05a0sm191505ab.4.2025.04.23.15.57.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 15:57:59 -0700 (PDT)
Message-ID: <cac3a5c9-e798-47f2-81ff-3c6003c6d8bb@kernel.dk>
Date: Wed, 23 Apr 2025 16:57:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring: Add new functions to handle user fault
 scenarios
From: Jens Axboe <axboe@kernel.dk>
To: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 akpm@linux-foundation.org, peterx@redhat.com, asml.silence@gmail.com,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20250422162913.1242057-1-qq282012236@gmail.com>
 <20250422162913.1242057-2-qq282012236@gmail.com>
 <14195206-47b1-4483-996d-3315aa7c33aa@kernel.dk>
 <CANHzP_uW4+-M1yTg-GPdPzYWAmvqP5vh6+s1uBhrMZ3eBusLug@mail.gmail.com>
 <b61ac651-fafe-449a-82ed-7239123844e1@kernel.dk>
 <CANHzP_tLV29_uk2gcRAjT9sJNVPH3rMyVuQP07q+c_TWWgsfDg@mail.gmail.com>
 <7bea9c74-7551-4312-bece-86c4ad5c982f@kernel.dk>
 <52d55891-36e3-43e7-9726-a2cd113f5327@kernel.dk>
Content-Language: en-US
In-Reply-To: <52d55891-36e3-43e7-9726-a2cd113f5327@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/23/25 9:55 AM, Jens Axboe wrote:
> Something like this, perhaps - it'll ensure that io-wq workers get a
> chance to flush out pending work, which should prevent the looping. I've
> attached a basic test case. It'll issue a write that will fault, and
> then try and cancel that as a way to trigger the TIF_NOTIFY_SIGNAL based
> looping.

Something that may actually work - use TASK_UNINTERRUPTIBLE IFF
signal_pending() is true AND the fault has already been tried once
before. If that's the case, rather than just call schedule() with
TASK_INTERRUPTIBLE, use TASK_UNINTERRUPTIBLE and schedule_timeout() with
a suitable timeout length that prevents the annoying parts busy looping.
I used HZ / 10.

I don't see how to fix userfaultfd for this case, either using io_uring
or normal write(2). Normal syscalls can pass back -ERESTARTSYS and get
it retried, but there's no way to do that from inside fault handling. So
I think we just have to be nicer about it.

Andrew, as the userfaultfd maintainer, what do you think?

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index d80f94346199..1016268c7b51 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -334,15 +334,29 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
 	return ret;
 }
 
-static inline unsigned int userfaultfd_get_blocking_state(unsigned int flags)
+struct userfault_wait {
+	unsigned int task_state;
+	bool timeout;
+};
+
+static struct userfault_wait userfaultfd_get_blocking_state(unsigned int flags)
 {
+	/*
+	 * If the fault has already been tried AND there's a signal pending
+	 * for this task, use TASK_UNINTERRUPTIBLE with a small timeout.
+	 * This prevents busy looping where schedule() otherwise does nothing
+	 * for TASK_INTERRUPTIBLE when the task has a signal pending.
+	 */
+	if ((flags & FAULT_FLAG_TRIED) && signal_pending(current))
+		return (struct userfault_wait) { TASK_UNINTERRUPTIBLE, true };
+
 	if (flags & FAULT_FLAG_INTERRUPTIBLE)
-		return TASK_INTERRUPTIBLE;
+		return (struct userfault_wait) { TASK_INTERRUPTIBLE, false };
 
 	if (flags & FAULT_FLAG_KILLABLE)
-		return TASK_KILLABLE;
+		return (struct userfault_wait) { TASK_KILLABLE, false };
 
-	return TASK_UNINTERRUPTIBLE;
+	return (struct userfault_wait) { TASK_UNINTERRUPTIBLE, false };
 }
 
 /*
@@ -368,7 +382,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	struct userfaultfd_wait_queue uwq;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
 	bool must_wait;
-	unsigned int blocking_state;
+	struct userfault_wait wait_mode;
 
 	/*
 	 * We don't do userfault handling for the final child pid update
@@ -466,7 +480,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	uwq.ctx = ctx;
 	uwq.waken = false;
 
-	blocking_state = userfaultfd_get_blocking_state(vmf->flags);
+	wait_mode = userfaultfd_get_blocking_state(vmf->flags);
 
         /*
          * Take the vma lock now, in order to safely call
@@ -488,7 +502,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	 * following the spin_unlock to happen before the list_add in
 	 * __add_wait_queue.
 	 */
-	set_current_state(blocking_state);
+	set_current_state(wait_mode.task_state);
 	spin_unlock_irq(&ctx->fault_pending_wqh.lock);
 
 	if (!is_vm_hugetlb_page(vma))
@@ -501,7 +515,11 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 
 	if (likely(must_wait && !READ_ONCE(ctx->released))) {
 		wake_up_poll(&ctx->fd_wqh, EPOLLIN);
-		schedule();
+		/* See comment in userfaultfd_get_blocking_state() */
+		if (!wait_mode.timeout)
+			schedule();
+		else
+			schedule_timeout(HZ / 10);
 	}
 
 	__set_current_state(TASK_RUNNING);

-- 
Jens Axboe

