Return-Path: <io-uring+bounces-4854-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD5AD9D3210
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 03:09:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3372D1F23C24
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 02:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D340A42A93;
	Wed, 20 Nov 2024 02:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="H2u79SPO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A7C1E485
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 02:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732068546; cv=none; b=ebPdh7BXou+4ICC/R6DUm6HxxwUd2PC18Mhhm/6pSpCs4WSuwWf6Kh2sKQ5VRkbsr6yqD3Ps4AMCNRWF4E7rgOXeqNTkbIw7JFmc6FTnkN3LeGY7ZgcXels2pTL3zQc8BPl4S5CU+iEiwjYePsBM+Pttu/9WRZnC9a6+W53hyYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732068546; c=relaxed/simple;
	bh=5GVhUiPvRQDQUwe/tKJCOsnyD7A0Clmez3Qq8pNgWT8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Uu8vS0GImp/kxgfo8Zpf9tbWgFNb+HEr5u6fVEhnc9yEh0ENRFaCVnB/2rTAuV5KARDd1JaT2sqmeLIIaRCm0VO0ehekkMCsnZHuSqVEv6IzqZRyT+BWybULmmx0Z98aZ9NiVfJaOR6dxhDJEfX9FfojJJ20KT0iwtqBBa5hAag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=H2u79SPO; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-21210eaa803so32382235ad.2
        for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 18:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732068544; x=1732673344; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2h82quloITTdBUdVp6tDUqoe9w3KkmGAGNei0et3wPM=;
        b=H2u79SPO93/viTbDz0BMtSLbAL3G1sThSs2zYVrSJoeUGNxnBCCdGYIG1boGuBBlP5
         PrLqcwuvN06ZXCKSQfRVKxkLAe4VS5XJh4aMdifIYOvAIuEtyZqC6FrSp6mfiAOXpad0
         IkYIijIsqv0LmSKHModSDbKpYe/GMqq78wRTT8CTnmgE3aai9SdbKkIP6KE3utX4+tlO
         fDQYyyRcR3EDp5l05i3npDdWk9aYW6NQ2yhWqf9znJ3bWEe+yKezFjRLnP3i37aTwIP2
         o35eYULMslvzo8hlZGdDqFH3A9PFZYUQVGYR00+AznjOh/MjPyNAJdJdHhKJzSNQsINp
         WI9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732068544; x=1732673344;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2h82quloITTdBUdVp6tDUqoe9w3KkmGAGNei0et3wPM=;
        b=O9yZmAj6gHdquex2BQ82CNhrkL5zX9YnafDmQkCoSn4Yd3VXRf38zJCC3LbdsdvSFK
         wqeh0rptcsECXEBzvZqRjcF8bMM+yDhlz7QgdWcCE+g0j87BDm2uwUkx2TOFqrj3Bneu
         z+3YMCWDBuZNNCXxLsbbs6OHWJCJ3M11eseCzeOfOuGpR61Uq5F5ngr81PZCzGNHABXY
         CqlS0dogoqicCFaX0eTuPmAv8yqM51X+1Ngrs/FNslaXWpiRfvz6BIiwiOO6ct2kOgDW
         n1RszF3cgA5a3ePuUioFilnl6gKk2ZicEWaWpYBn0vH04i+uKZsP+F9M1a0dRTxp75MJ
         97KQ==
X-Forwarded-Encrypted: i=1; AJvYcCXA4TFBLWDITESa2QEoea9EEJ5JurnO8cJ5OmYLuruq/Ka9T8hLvieBZb423A6zQR8u2QrgBvKGsA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/S9ZWe3HMcdJQNW2hsGbJwyuk9PmoCz8Mva1jCIaC5raHt8wL
	V+nSQYIMJjcsbbdPLLp2L1mwPyezbfiQ9SMrdh2jBu1vhSNzJJhiQ95dkBmHGcU=
X-Google-Smtp-Source: AGHT+IHGETfVsy25zpRmx32L3XEHtj0O2ZxDzWIQvXLyEqX4QEn/jJ2LWs5f/389WJTc5gyEYfhJiA==
X-Received: by 2002:a17:903:2ace:b0:206:96bf:b0cf with SMTP id d9443c01a7336-2126a287eb6mr18660715ad.0.1732068544153;
        Tue, 19 Nov 2024 18:09:04 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21259f208b6sm17151955ad.267.2024.11.19.18.09.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2024 18:09:03 -0800 (PST)
Message-ID: <07b133f5-4352-4c1a-bbc9-d1e881c96781@kernel.dk>
Date: Tue, 19 Nov 2024 19:09:02 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] WARNING in __io_uring_free
To: syzbot <syzbot+cc36d44ec9f368e443d3@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <673c1643.050a0220.87769.0066.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <673c1643.050a0220.87769.0066.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/18/24 9:38 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    cfaaa7d010d1 Merge tag 'net-6.12-rc8' of git://git.kernel...
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13005cc0580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d2aeec8c0b2e420c
> dashboard link: https://syzkaller.appspot.com/bug?extid=cc36d44ec9f368e443d3
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-cfaaa7d0.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/63eae0d3e67f/vmlinux-cfaaa7d0.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/6495d9e4ddee/bzImage-cfaaa7d0.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+cc36d44ec9f368e443d3@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 16 at io_uring/tctx.c:51 __io_uring_free+0xfa/0x140 io_uring/tctx.c:51
> Modules linked in:
> CPU: 0 UID: 0 PID: 16 Comm: ksoftirqd/0 Not tainted 6.12.0-rc7-syzkaller-00125-gcfaaa7d010d1 #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:__io_uring_free+0xfa/0x140 io_uring/tctx.c:51
> Code: 80 7c 25 00 00 74 08 4c 89 f7 e8 a1 8a 49 fd 49 c7 06 00 00 00 00 5b 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc e8 37 ad df fc 90 <0f> 0b 90 e9 6a ff ff ff e8 29 ad df fc 90 0f 0b 90 eb 84 e8 1e ad
> RSP: 0018:ffffc900004279b8 EFLAGS: 00010246
> RAX: ffffffff84b53cd9 RBX: ffff88804fc3b8e0 RCX: ffff88801b7e8000
> RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffff88801f058000
> RBP: 0000000000000001 R08: ffffffff8154d881 R09: 1ffff11003e0b005
> R10: dffffc0000000000 R11: ffffed1003e0b006 R12: dffffc0000000000
> R13: 1ffff11003e0b120 R14: ffff88801f058900 R15: ffff88804fc3b800
> FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005594393ad338 CR3: 000000000e734000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  io_uring_free include/linux/io_uring.h:31 [inline]
>  __put_task_struct+0xd5/0x290 kernel/fork.c:975
>  put_task_struct include/linux/sched/task.h:144 [inline]
>  delayed_put_task_struct+0x125/0x300 kernel/exit.c:228
>  rcu_do_batch kernel/rcu/tree.c:2567 [inline]
>  rcu_core+0xaaa/0x17a0 kernel/rcu/tree.c:2823
>  handle_softirqs+0x2c5/0x980 kernel/softirq.c:554
>  run_ksoftirqd+0xca/0x130 kernel/softirq.c:927
>  smpboot_thread_fn+0x544/0xa30 kernel/smpboot.c:164
>  kthread+0x2f0/0x390 kernel/kthread.c:389
>  ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>  </TASK>

I had to click the report to see that it's using forced memory failure
allocations to trigger this. But with that in mind, I still didn't see
what the issue was. I guess I'll take a look when a reproducer exists,
but don't think there's much afoul here due to the usage of fault
injection.

-- 
Jens Axboe

