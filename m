Return-Path: <io-uring+bounces-3242-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A18D97D301
	for <lists+io-uring@lfdr.de>; Fri, 20 Sep 2024 10:51:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E24181F22FC5
	for <lists+io-uring@lfdr.de>; Fri, 20 Sep 2024 08:51:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46E3F2AE77;
	Fri, 20 Sep 2024 08:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UzwQxEdI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DE82B9BC
	for <io-uring@vger.kernel.org>; Fri, 20 Sep 2024 08:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726822276; cv=none; b=sDhTgbSUVgKKtaWHmdl+pU7VeIFKw4OwIx4Ag5teX9Bra36cpOudmDQGRFokl47yIzch3AADyYCU1xkqznvFypGsBC0zjJZOaLGUSSnZgAWTgUbcO38UWZhrmp8sFlU1aRVeGjH1MFWzGKgXEs94SQDE/4Cjrw6HP66SuyXgdHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726822276; c=relaxed/simple;
	bh=enjexeWIM/zfUTF9N6uDaW6CmXQXGi1d2i+TGQBYd+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GAEK4eMmEoSNmivaXczIofo8IZMEoQ1WkzOz9yiQNorJAj9thBwpDcQZCmjFz26xmf40Xqpu6DsVurR+YurTLXhKkeG3evwBT6Cqcb71LWY/JY99flBDJXS+tmVsfvuolVZgpE8BObmIYglL+o6FjNWZKk9gQ3MlHKDQK4HGej8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UzwQxEdI; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5c42bcf35fbso2404255a12.1
        for <io-uring@vger.kernel.org>; Fri, 20 Sep 2024 01:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726822271; x=1727427071; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rvy4/7iJkADqxJUMtWkXFnVrVE6Fo9oX+q4VInNWCCw=;
        b=UzwQxEdIh+iMIQzZlRSZKNKfsMPetTZfDWg4JJaaCxIKrgIsd+lntMzvgaMqf/nceO
         ACrcO3QQJqpW7/ZKQwRDHlwdGiGu+NUDiFYZANsRFFxmzPYqMMxLONqIJVD0XtBxkP1N
         AZqGSyH7QfJHeUpXF7Rbd2il6t0khD9+4NazijVj6A/mCkQe2JyCeMf/MXCP/iVSVCm+
         iVXdagyZQSdk7HvMvEdxRymD/Asz87BCstPUlaGCkUiPMOSNC7NhBZL61LTQNMsK7byX
         s+1TgY/ydX48X1G4csSzr3wtUYczFWrSrgjvQmf1miWV9ETHTcJEb1WBXlIP3knbZwJc
         PQIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726822271; x=1727427071;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rvy4/7iJkADqxJUMtWkXFnVrVE6Fo9oX+q4VInNWCCw=;
        b=BoegsGW67EdJUA4lp7Lyn/RElcPnmSFVpHRTX3NqtkMffgDF6UwajfGeXS4Dogo/aH
         O9frsyxemZeItfzQYuLIjSR/K0WXqZCq/16Rujz1DrX7ZpJkt+tXeY6JhGJxsKtBqaAt
         kDGBQTmI1CS0EojXhxieLaNnBZxDojqHbzTzq82aBLP0qBnbd0meJKaTTfG0aO/b165E
         f4dsDdE4eENJQghcHFg4QS2kxadugOu6Ev+mpp85s3buBE/KXJue4/P5m1K/ecoUQP+D
         hc8i0szFvuRav3+ZW6Ioh9mXyPE+ijzOYgj5+7GnOJaWEGXgZFWdqnHzaE2LfauA+R5e
         x4YQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiWhZZSOhg9xkbzaew44FiFQueY4o2/wmyUj68nk65cCoslwjmEd5oxskO1Bj4aJEHnHN545BCcw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOAF5AgIOc/H1cdESDZ0M7mvxDMsOJIwLc7oX+IJXAgGlHdlTX
	gmpV6aLBkM2YDVWHCCC3CfuobF293e6S7s6KaSyFABzh6cFyJWPb8LbCSsl8fk4=
X-Google-Smtp-Source: AGHT+IFREpCbUeNC+7klw4/rTFGjabYGgqoPION+JjvgLb78PO0UMh/HrYsrQj+a8l6zN8qNYtm1FQ==
X-Received: by 2002:a17:907:3f25:b0:a8a:ead3:8515 with SMTP id a640c23a62f3a-a90d514a83fmr159421166b.65.1726822271073;
        Fri, 20 Sep 2024 01:51:11 -0700 (PDT)
Received: from [192.168.0.216] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90610f42f1sm812092966b.57.2024.09.20.01.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Sep 2024 01:51:10 -0700 (PDT)
Message-ID: <0d88fc54-93a7-4075-996f-b2d343c0ba28@kernel.dk>
Date: Fri, 20 Sep 2024 02:51:09 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] INFO: rcu detected stall in
 sys_io_uring_enter (2)
To: syzbot <syzbot+5fca234bd7eb378ff78e@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <66ed061d.050a0220.29194.0053.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <66ed061d.050a0220.29194.0053.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/19/24 11:20 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    98f7e32f20d2 Linux 6.11
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17271c07980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c78874575ba70f27
> dashboard link: https://syzkaller.appspot.com/bug?extid=5fca234bd7eb378ff78e
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/20d79fec7eb2/disk-98f7e32f.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/57606ddb0989/vmlinux-98f7e32f.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/901e6ba22e57/bzImage-98f7e32f.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5fca234bd7eb378ff78e@syzkaller.appspotmail.com
> 
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu: 	1-...!: (0 ticks this GP) idle=11bc/1/0x4000000000000000 softirq=116660/116660 fqs=17
> rcu: 	(detected by 0, t=10502 jiffies, g=200145, q=315 ncpus=2)
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1
> CPU: 1 UID: 0 PID: 6917 Comm: syz.2.16175 Not tainted 6.11.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
> RIP: 0010:match_held_lock+0x0/0xb0 kernel/locking/lockdep.c:5204
> Code: 08 75 11 48 89 d8 48 83 c4 10 5b 41 5e 41 5f c3 cc cc cc cc e8 11 f9 ff ff 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <55> 53 bd 01 00 00 00 48 39 77 10 74 67 48 89 fb 81 7f 20 00 00 20
> RSP: 0018:ffffc90000a18d10 EFLAGS: 00000083
> RAX: 0000000000000002 RBX: ffff888057310b08 RCX: ffff888057310000
> RDX: ffff888057310000 RSI: ffff8880b892c898 RDI: ffff888057310b08
> RBP: 0000000000000001 R08: ffffffff8180cfbe R09: 0000000000000000
> R10: ffff88803641a340 R11: ffffed1006c8346b R12: 0000000000000046
> R13: ffff888057310000 R14: 00000000ffffffff R15: ffff8880b892c898
> FS:  00007f183bd6c6c0(0000) GS:ffff8880b8900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f7205d61f98 CR3: 000000001bb10000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <NMI>
>  </NMI>
>  <IRQ>
>  __lock_is_held kernel/locking/lockdep.c:5500 [inline]
>  lock_is_held_type+0xa9/0x190 kernel/locking/lockdep.c:5831
>  lock_is_held include/linux/lockdep.h:249 [inline]
>  __run_hrtimer kernel/time/hrtimer.c:1655 [inline]
>  __hrtimer_run_queues+0x2d9/0xd50 kernel/time/hrtimer.c:1753
>  hrtimer_interrupt+0x396/0x990 kernel/time/hrtimer.c:1815
>  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1032 [inline]
>  __sysvec_apic_timer_interrupt+0x110/0x3f0 arch/x86/kernel/apic/apic.c:1049
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1043 [inline]
>  sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1043
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
> RIP: 0010:lock_acquire+0x264/0x550 kernel/locking/lockdep.c:5763
> Code: 2b 00 74 08 4c 89 f7 e8 ea e1 87 00 f6 44 24 61 02 0f 85 85 01 00 00 41 f7 c7 00 02 00 00 74 01 fb 48 c7 44 24 40 0e 36 e0 45 <4b> c7 44 25 00 00 00 00 00 43 c7 44 25 09 00 00 00 00 43 c7 44 25
> RSP: 0018:ffffc9000c5c79a0 EFLAGS: 00000206
> RAX: 0000000000000001 RBX: 1ffff920018b8f40 RCX: 2e46bf6ba4daf100
> RDX: dffffc0000000000 RSI: ffffffff8beae6c0 RDI: ffffffff8c3fbac0
> RBP: ffffc9000c5c7ae8 R08: ffffffff93fa6967 R09: 1ffffffff27f4d2c
> R10: dffffc0000000000 R11: fffffbfff27f4d2d R12: 1ffff920018b8f3c
> R13: dffffc0000000000 R14: ffffc9000c5c7a00 R15: 0000000000000246
>  __mutex_lock_common kernel/locking/mutex.c:608 [inline]
>  __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
>  io_cqring_do_overflow_flush io_uring/io_uring.c:644 [inline]
>  io_cqring_wait io_uring/io_uring.c:2486 [inline]
>  __do_sys_io_uring_enter io_uring/io_uring.c:3255 [inline]
>  __se_sys_io_uring_enter+0x1c2a/0x2670 io_uring/io_uring.c:3147
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f

I know there's no reproducer for this and hence it can't get tested, but
this is obviously some syzbot nonsense that just wildly overflows the
CQE list. The below should fix it, will add it.

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f3570e81ecb4..c03d523ff468 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -635,6 +635,21 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
 		}
 		list_del(&ocqe->list);
 		kfree(ocqe);
+
+		/*
+		 * For silly syzbot cases that deliberately overflow by huge
+		 * amounts, check if we need to resched and drop and
+		 * reacquire the locks if so. Nothing real would ever hit this.
+		 * Ideally we'd have a non-posting unlock for this, but hard
+		 * to care for a non-real case.
+		 */
+		if (need_resched()) {
+			io_cq_unlock_post(ctx);
+			mutex_unlock(&ctx->uring_lock);
+			cond_resched();
+			mutex_lock(&ctx->uring_lock);
+			io_cq_lock(ctx);
+		}
 	}
 
 	if (list_empty(&ctx->cq_overflow_list)) {

-- 
Jens Axboe

