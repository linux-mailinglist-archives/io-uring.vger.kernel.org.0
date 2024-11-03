Return-Path: <io-uring+bounces-4384-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EFEB9BA9A4
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 00:58:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D6AAB21E13
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 23:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A387018BC06;
	Sun,  3 Nov 2024 23:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Neefg56A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96EF15B13C
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 23:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730678310; cv=none; b=jPjZcIZb/XBhijjFaO53R+qIWgkd8W6es/uJUXmtlKdj+XRbfTtFq1PpJeNk+CYaQaZlOV9gFni81OAu/BIMUojUzQBMyZYNJljVxyibKL1+1E66i3PHDv3W1kIX5s0UYXiZnJiNV07ZGbDhAc2oED0Z1orrfAD5dRPw8NZLF5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730678310; c=relaxed/simple;
	bh=ySz/n+fkh7UeZWYZe/29zxB4RM0VYtj4fBrp9IZ3q+k=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=oCR7KVkigTtlZ2ZoAf+DDxkZe4u3JZLACRh7PZPu6p1VClbKC66nZVrQZI6HzDTmwtz/g7fjVnlkszXpbO3aKHliANOX8zUDI2P5+bZfuJJWkBvGnoYH1Z+aN4yY9tPu4gm78y0kD4Vc/oqM2OXQ55daJJVo2s8DidFR2Bta0qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Neefg56A; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-71e61b47c6cso3264040b3a.2
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 15:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730678306; x=1731283106; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=za4XP+LF+OG+jru2fuIsM07ffRioXbBZ5xJE1gEteU0=;
        b=Neefg56A7z+kbtEnHM8XrYH1+mWN7oJcbZPjQjs2jnnKM3vetdxObnx1MtUbSNoFkz
         tJKLSaMFhDfgH9DAdMEB6oUEMUPZo8yKYqHGQnwnqwrHZuFAc7xpuErvQ+mmGq/IIW7U
         rNPaZnHKI+GCmBe4htDwCeD7JSGkD+v+NvQvi+UU/txWrmLXz1iEaxROmLHdkA0g7Z8F
         YEN1Q1fTV+7f5t51klvUNBXeCbaYQoqsEzr+XTU0DA5+eana5eD01OlqmQWBpi5y+4Td
         +6hlgcQiAa3KihXKeem1N5U2N7HXtOkhhLFhSKclqY1A2eluSPooSksyaoOg5WSWsfAj
         SJog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730678306; x=1731283106;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=za4XP+LF+OG+jru2fuIsM07ffRioXbBZ5xJE1gEteU0=;
        b=Nsgo/kr1qzn8DRGrLSrioeEKR9IEopoi4pK48IRd3qHVchmNgfafSFZWWEWNEll9xp
         k2EIcK2FuhwP2KkMkRtRhGecqRTjxMIR9e8DajiZL2NUZDgiv3BL5AVcIH0UvGYMUMQD
         piNrxo19C5MhJlOJghC8u31mWwD0ek2XPsEq8Y+T3ds0wxW8xWx0DCI5K4QAYN5QPJi3
         ax7JH/kiA036+Y07T5Ao2rYfOqoXz6WbHazSSqrWLCH0EubA01eRrd/81bVvo/sS5+mH
         5WY6mxGvVb6sxxtd+dCDFVHJDRRQE5WYTncz/m+LoebNSbQriqR19qhV/4H64tmmrxWE
         ZLXg==
X-Gm-Message-State: AOJu0YxM8QSFhm5tuMvqYbY/L5eDEVmCcgfv8yQvnQ0Fl+x/hw4UKxLn
	+bfMIMT08WR895cZ/iO1V915REK6vTVgODLYPYiVl8t6Kod0gLylSZ9350I5cl3qQu0UKqPpLQv
	PzeA=
X-Google-Smtp-Source: AGHT+IGcRBk+er9rIwmAHo+AiJy4t6HQ1wLoiPDXc/oCipudXLd7yzGFFZIPmy953ZPMyRssYRA0Ww==
X-Received: by 2002:a05:6a00:810:b0:71e:7af9:2d0f with SMTP id d2e1a72fcca58-7206306dff5mr44657206b3a.18.1730678305685;
        Sun, 03 Nov 2024 15:58:25 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc2c3dc6sm6193798b3a.102.2024.11.03.15.58.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Nov 2024 15:58:25 -0800 (PST)
Message-ID: <9818b4a3-c1ac-4b57-930a-f887fe3a3d22@kernel.dk>
Date: Sun, 3 Nov 2024 16:58:24 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: PROBLEM: io_uring hang causing uninterruptible sleep state on
 6.6.59
From: Jens Axboe <axboe@kernel.dk>
To: Andrew Marshall <andrew@johnandrewmarshall.com>
Cc: io-uring@vger.kernel.org
References: <3d913aef-8c44-4f50-9bdf-7d9051b08941@app.fastmail.com>
 <cc8b92ba-2daa-49e3-abe6-39e7d79f213d@kernel.dk>
Content-Language: en-US
In-Reply-To: <cc8b92ba-2daa-49e3-abe6-39e7d79f213d@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/3/24 4:53 PM, Jens Axboe wrote:
> On 11/3/24 4:47 PM, Andrew Marshall wrote:
>> Hi,
>>
>> I, and others (see downstream report below), are encountering io_uring
>> at times hanging on 6.6.59 LTS. If the process is killed, the process
>> remains stuck in sleep uninterruptible ("D"). This failure can be
>> fairly reliably reproduced via Node.js with `npm ci` in at least some
>> projects; disabling that tool?s use of io_uring causes via its
>> configuration causes it to succeed. I have identified what seems to be
>> the problematic commit on linux-6.6.y (f4ce3b5).
>>
>> Summary of Kernel version triaging:
>>
>> - 6.6.56: succeeds
>> - 6.6.57: fails
>> - 6.6.58: fails
>> - 6.6.59: fails
>> - 6.6.59 (with f4ce3b5 reverted): succeeds
>> - 6.11.6: succeeds
>>
>> System logs upon failure indicate hung task:
>>
>> kernel: INFO: task npm ci:47920 blocked for more than 245 seconds.
>> kernel:       Tainted: P           O       6.6.58 #1-NixOS
>> kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> kernel: task:npm ci          state:D stack:0     pid:47920 ppid:47710  flags:0x00004006
>> kernel: Call Trace:
>> kernel:  <TASK>
>> kernel:  __schedule+0x3fc/0x1430
>> kernel:  ? sysvec_apic_timer_interrupt+0xe/0x90
>> kernel:  schedule+0x5e/0xe0
>> kernel:  schedule_preempt_disabled+0x15/0x30
>> kernel:  __mutex_lock.constprop.0+0x3a2/0x6b0
>> kernel:  io_uring_del_tctx_node+0x61/0xf0
>> kernel:  io_uring_clean_tctx+0x5c/0xc0
>> kernel:  io_uring_cancel_generic+0x198/0x350
>> kernel:  ? srso_return_thunk+0x5/0x5f
>> kernel:  ? timerqueue_del+0x2e/0x50
>> kernel:  ? __pfx_autoremove_wake_function+0x10/0x10
>> kernel:  do_exit+0x167/0xad0
>> kernel:  ? __pfx_hrtimer_wakeup+0x10/0x10
>> kernel:  do_group_exit+0x31/0x80
>> kernel:  get_signal+0xa60/0xa60
>> kernel:  arch_do_signal_or_restart+0x3e/0x280
>> kernel:  exit_to_user_mode_prepare+0x1d4/0x230
>> kernel:  syscall_exit_to_user_mode+0x1b/0x50
>> kernel:  do_syscall_64+0x45/0x90
>> kernel:  entry_SYSCALL_64_after_hwframe+0x78/0xe2
>>
>> For more details, see the downstream bug report in Node.js: https://github.com/nodejs/node/issues/55587
>>
>> I identified f4ce3b5d26ce149e77e6b8e8f2058aa80e5b034e as the likely
>> problematic commit simply by browsing git log. As indicated above;
>> reverting that atop 6.6.59 results in success. Since it is passing on
>> 6.11.6, I suspect there is some missing backport to 6.6.x, or some
>> other semantic merge conflict. Unfortunately I do not have a compact,
>> minimal reproducer, but can provide my large one (it is testing a
>> larger build process in a VM) if needed?there are some additional
>> details in the above-linked downstream bug report, though. I hope that
>> having identified the problematic commit is enough for someone with
>> more context to go off of. Happy to provide more information if
>> needed.
> 
> Don't worry about not having a reproducer, having the backport commit
> pin pointed will do just fine. I'll take a look at this.

Ah that looks pretty dumb, in fact. The below should fix it. However,
it's worth noting that this will only happen if there's overflow going
on, and presumably only if the overflow list is quite long. That does
indicate a problem with the user of the ring, generally overflow should
not be seen at all. Entirely independent from this backport being buggy,
just wanted to bring it up as it is cause for concern on the application
side.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 39d8d1fc5c2b..aa7c67a037e7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -711,9 +711,11 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 		 */
 		if (need_resched()) {
 			io_cq_unlock_post(ctx);
-			mutex_unlock(&ctx->uring_lock);
+			if (ctx->flags & IORING_SETUP_IOPOLL)
+				mutex_unlock(&ctx->uring_lock);
 			cond_resched();
-			mutex_lock(&ctx->uring_lock);
+			if (ctx->flags & IORING_SETUP_IOPOLL)
+				mutex_lock(&ctx->uring_lock);
 			io_cq_lock(ctx);
 		}
 	}

-- 
Jens Axboe

