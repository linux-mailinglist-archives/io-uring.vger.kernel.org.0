Return-Path: <io-uring+bounces-13486-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CK0/LrOxEWruowYAu9opvQ
	(envelope-from <io-uring+bounces-13486-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 15:54:59 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 21C9C5BF20D
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 15:54:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 634003001AC0
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 13:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A5E346E7F;
	Sat, 23 May 2026 13:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="sGmHWnB0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B2B19343E
	for <io-uring@vger.kernel.org>; Sat, 23 May 2026 13:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779544495; cv=none; b=niPCmb9ZKC3WgqKwEe66NR6nqZfzwvMtkRUerWSNue60AktX+wPTwoH21Lm/u9tyrXwyX6R2A6GQyVYKT9kqEdnCDRC2z7vfcfvI6Zmleo6lrVH/WrUrWaTy8n6UzDdhDHtFpwfMa6Iy3IVi0A4sVKyHvYoEpt7GpUmzPqhOI1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779544495; c=relaxed/simple;
	bh=D4WgZ6pig8o9yZ2h3BmGKYiqAdosri5bkWl0PBFcm7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qyELqzfA/iAp28ZxlZTaCCIp7ZPrnZlFJrQkZOulU5IIQm/xVWnOPq1DXGkYjiFu4rMf9GoIIS/Aku0vspoSpllKNLeuZYkSexzk/qE+BZXqaG54uiYaP/gWGPkugOXFGylibcIpYSaQX80zNsqXwVO083KjkfrqsVyLbhIe4oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=sGmHWnB0; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7e603d0ee0aso1119193a34.2
        for <io-uring@vger.kernel.org>; Sat, 23 May 2026 06:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779544491; x=1780149291; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VxUoX9oQBgBGQf9Y9Ltyy2hVrP5KJx3xuX90dX3IVEQ=;
        b=sGmHWnB0GmNZADjvcxqdoC7Yke5W8f/F+8zjTl/shUh9apzONUA3lChPElBRdajqG3
         IZbHM3t6fp0xShcbSLMxIg73KofzMG+X138EHyWyWOI0xw7WjjYNDoPskjr8VW/BiKi+
         Kk7K95slWyLAIOWE56FKDQGgDGcv2vYvaexcPswOieDK1X2ouaP955uCy4IndXWCHRge
         PX+zVbLbFMLjwqn49o5LxEnL5H1Q9ZsEv0aXDv2peRf3yX/WQDrJqAvXtlUr9rIZAKVA
         KueGqNYgQ3tL4VWnPuQsUbh/kzYlm2wx4sDFNHY9L0009NMufFYH/6wczX14HVLz2CCc
         DF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779544491; x=1780149291;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VxUoX9oQBgBGQf9Y9Ltyy2hVrP5KJx3xuX90dX3IVEQ=;
        b=s75EypVY9RmntNx4NBuYyEaYDqjyq3bDX0QOQYvbzxIqFC7Rh6r7nQxIqWvefjtYss
         rCh+hdVLl3gBRVw9iXmoFPmpEFpyDa/VA3gKRO9GKvPh1tXWbLs+zqHNF4tkIrhD9yCa
         2937tU41pRC5ZFg5wyqGssRkVzrbE3Syblb67etL5ecEFNa//Dj/JSD1YO2zhtWnMnUB
         k4T6XZqoMpDQb8ezqY7eePqGoZOmm3hyVZffqDXCAKDw2S9n6q3L1hg9XXRed3CMZsPl
         8ixKPFNdhA/a2zwBFhcnDTmEPbH0WF1yaeJ5Mh9U20QLePdAPT/oGftxmUpKhKL8gJhf
         7PiA==
X-Forwarded-Encrypted: i=1; AFNElJ/ptvkzMoA5SfK6meKV/ns5mPGgonGHaamx9e6l2AW8iQdVu29IZX2xCIE+T8w+6ck3wNcWm6zPKw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKELzkWzNDMFTz6HXL+vtu3pfEfxH1oHMPWk4Gx9vmRDcvjkRJ
	GMpWk6QJ0osOserQ2FunjJMOHs6d0qsjB5QZZowMBEgflqYHFN3yLdjLe4BQf355qQjpEqm9u/8
	E1h5Q
X-Gm-Gg: Acq92OGAGesLVcUZmUR9+ZHdqSQZZRCXRn1w+y81j+A4hKf43WZlD+S3EoV3spTSf/P
	mFhvZkNZCo9jtD3yQj9TvceHFiPC5WB0HwSQfYWCXJeYaQbwMBUlsPX5KMnS0/a3uWpmSklnL91
	6MHX3PtC0uc31kjBZSC3NrECePMeC7EFyqCJrrxiF9ArHxZZJs/tFuzObRXaiBUu/22pnR7crof
	Jo/seP2Do60qb1bkXSV2YXcWwGNDSOMf57jj20vMtQh2xW8nsrDPi/S3kbpWE0WCXkjHVPUPcxo
	jPOMjgsiCe5EV5cWOjyfaYtUXa+UWDToUF+oan5uG2lZTH4bloCALB9OHq3PChlFzAlNRqNUurW
	/9Dbt91gr4EgKtSnLGJNf6M+OaIWYTua1k5reHLazaOx/Z1oQlV/HGeDzD7ZoONrBNQpSiihhB7
	Nk4DNGwv79mEOpb+xMllZ+LCwvCd214mx/FQfmHmy1xNpgjjBrL3Daju8SxB9y/eKxLw4W6w9G5
	eowEYWaqw==
X-Received: by 2002:a05:6830:3c10:b0:7de:51f3:e7ed with SMTP id 46e09a7af769-7e5fef44dfcmr4930046a34.26.1779544491476;
        Sat, 23 May 2026 06:54:51 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e60648257csm3255891a34.9.2026.05.23.06.54.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2026 06:54:50 -0700 (PDT)
Message-ID: <2af95968-bcb3-4ed5-9242-3f8358e71f9e@kernel.dk>
Date: Sat, 23 May 2026 07:54:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug] io_uring : NULL pointer deref in
 io_register_iowq_max_workers()
To: =?UTF-8?B?7Iuc66as7Ja8?= <shja0831@gmail.com>, io-uring@vger.kernel.org
References: <CACR30Wj7yEweYqJg4Ovrbr4s9a8EZRYD8FMAWhjWUv3XunrMFQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CACR30Wj7yEweYqJg4Ovrbr4s9a8EZRYD8FMAWhjWUv3XunrMFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13486-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FREEMAIL_TO(0.00)[gmail.com,vger.kernel.org];
	DMARC_NA(0.00)[kernel.dk];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Queue-Id: 21C9C5BF20D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/23/26 6:00 AM, ??? wrote:
> Frist I'm not good at English, so my grammar might be weird.
> and i use translator so It may not look natural.
> 
> I found NULL-pointer dereference (general protection fault under
> KASAN) in io_register_iowq_max_workers() on 7.1.0-rc1. It is a race
> between the IORING_REGISTER_IOWQ_MAX_WORKERS propagation loop and a
> task installing its first io_uring task context (tctx) node on a
> shared ring. A small multithreaded reproducer triggers it reliably.
> 
> syzkaller log:
> 
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc0000000003: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
> CPU: 1 UID: 0 PID: 230570 Comm: syz.1.42039 Not tainted 7.1.0-rc1 #1
> PREEMPT(full)
> Hardware name: QEMU Ubuntu 26.04 PC (i440FX + PIIX, 1996), BIOS
> 1.17.0-debian-1.17.0-1ubuntu1 04/01/2014
> RIP: 0010:io_register_iowq_max_workers io_uring/register.c:423 [inline]
> RIP: 0010:__io_uring_register io_uring/register.c:865 [inline]
> RIP: 0010:__do_sys_io_uring_register.cold+0xcae/0xe32 io_uring/register.c:1029
> Code: bd 68 09 00 00 48 89 fa 48 c1 ea 03 42 80 3c 2a 00 74 05 e8 06
> 3a 40 01 48 8b ad 68 09 00 00 48 8d 7d 18 48 89 fa 48 c1 ea 03 <42> 80
> 3c 2a 00 74 05 e8 e8 39 40 01 48 8b 6d 18 48 85 ed 0f 85 ec
> RSP: 0018:ffffc90002a9fd90 EFLAGS: 00010206
> RAX: 1ffff11004c9f63a RBX: ffff888054ee4000 RCX: 0000000000000001
> RDX: 0000000000000003 RSI: ffffffff81364a23 RDI: 0000000000000018
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffc90002a9fd90 R11: 0000000080000000 R12: ffff8880264fb1c0
> R13: dffffc0000000000 R14: 0000000000000013 R15: 0000000000000013
> FS:  00007ff8525ee6c0(0000) GS:ffff8880d687a000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000005ea81000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xff/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff8543b85fd
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ff8525edff8 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
> RAX: ffffffffffffffda RBX: 00007ff854645fa0 RCX: 00007ff8543b85fd
> RDX: 0000200000000040 RSI: 0000000000000013 RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffdb063f3d0 R14: 00007ff8525eece4 R15: 00007ffdb063f4c7
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:io_register_iowq_max_workers io_uring/register.c:423 [inline]
> RIP: 0010:__io_uring_register io_uring/register.c:865 [inline]
> RIP: 0010:__do_sys_io_uring_register.cold+0xcae/0xe32 io_uring/register.c:1029
> Code: bd 68 09 00 00 48 89 fa 48 c1 ea 03 42 80 3c 2a 00 74 05 e8 06
> 3a 40 01 48 8b ad 68 09 00 00 48 8d 7d 18 48 89 fa 48 c1 ea 03 <42> 80
> 3c 2a 00 74 05 e8 e8 39 40 01 48 8b 6d 18 48 85 ed 0f 85 ec
> RSP: 0018:ffffc90002a9fd90 EFLAGS: 00010206
> RAX: 1ffff11004c9f63a RBX: ffff888054ee4000 RCX: 0000000000000001
> RDX: 0000000000000003 RSI: ffffffff81364a23 RDI: 0000000000000018
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffc90002a9fd90 R11: 0000000080000000 R12: ffff8880264fb1c0
> R13: dffffc0000000000 R14: 0000000000000013 R15: 0000000000000013
> FS:  00007ff8525ee6c0(0000) GS:ffff8880d687a000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f1280e130b0 CR3: 000000005ea81000 CR4: 0000000000352ef0
> ----------------
> Code disassembly (best guess):
>    0: bd 68 09 00 00       mov    $0x968,%ebp
>    5: 48 89 fa             mov    %rdi,%rdx
>    8: 48 c1 ea 03           shr    $0x3,%rdx
>    c: 42 80 3c 2a 00       cmpb   $0x0,(%rdx,%r13,1)
>   11: 74 05                 je     0x18
>   13: e8 06 3a 40 01       call   0x1403a1e
>   18: 48 8b ad 68 09 00 00 mov    0x968(%rbp),%rbp
>   1f: 48 8d 7d 18           lea    0x18(%rbp),%rdi
>   23: 48 89 fa             mov    %rdi,%rdx
>   26: 48 c1 ea 03           shr    $0x3,%rdx
> * 2a: 42 80 3c 2a 00       cmpb   $0x0,(%rdx,%r13,1) <-- trapping instruction
>   2f: 74 05                 je     0x36
>   31: e8 e8 39 40 01       call   0x1403a1e
>   36: 48 8b 6d 18           mov    0x18(%rbp),%rbp
>   3a: 48 85 ed             test   %rbp,%rbp
>   3d: 0f                   .byte 0xf
>   3e: 85 ec                 test   %ebp,%esp
> 
> 
> <<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>
> 
> This bug is in io_register_iowq_max_workers()
> 
> mutex_lock(&ctx->tctx_lock);
> list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
>     tctx = node->task->io_uring;
>     if (WARN_ON_ONCE(!tctx->io_wq)) // derefs tctx without NULL check
>         continue;
>     // skip
> }
> 
> propagates the limit to all registered users (non-SQPOLL path)
> 
> The node is published into ctx->tctx_list before node->task->io_uring
> is set (io_uring/tctx.c):
> 
> io_tctx_install_node():
>     node->task = current;
>     mutex_lock(&ctx->tctx_lock);
>     list_add(&node->ctx_node, &ctx->tctx_list);   // node visible
>     mutex_unlock(&ctx->tctx_lock); // lock dropped
> 
> __io_uring_add_tctx_node():
>     ret = io_tctx_install_node(ctx, tctx);
>     if (!ret)
>         current->io_uring = tctx;   // set AFTER, outside lock
> 
> There is a window where a node is on ctx->tctx_list while
> node->task->io_uring is still NULL (the task is doing its first
> io_uring op, tctx freshly allocated, not yet published). A concurrent
> IORING_REGISTER_IOWQ_MAX_WORKERS on the same ring takes
> ctx->tctx_lock, iterates, reads node->task->io_uring == NULL, and
> dereferences tctx->io_wq ? GPF.
> 
> The other two ctx->tctx_list consumers already guard this ? cancel.c
> io_async_cancel_one() and io_uring_try_cancel_iowq() both do if (!tctx
> || !tctx->io_wq). io_register_iowq_max_workers() is the only consumer
> that omits the !tctx check, so this is simply a missing guard.
> 
> Reproducer
> 
> Plain (non-SQPOLL) ring shared across threads. A stream of fresh
> threads each do their first io_uring_enter() (hits the window) while
> two threads spam IORING_REGISTER_IOWQ_MAX_WORKERS. GPFs within
> seconds-to-minutes on SMP+KASAN.
> 
> #define _GNU_SOURCE
> #include <pthread.h>
> #include <string.h>
> #include <sys/syscall.h>
> #include <linux/io_uring.h>
> static int ring_fd;
> static long setup(unsigned e, struct io_uring_params *p){ return
> syscall(__NR_io_uring_setup, e, p); }
> static long enter(int fd, unsigned ts){ return
> syscall(__NR_io_uring_enter, fd, ts, 0, 0, (void*)0, (size_t)0); }
> static long reg(int fd, unsigned op, void *a, unsigned n){ return
> syscall(__NR_io_uring_register, fd, op, a, n); }
> static void *fresh(void *x){ enter(ring_fd, 1); return 0; }   // first
> op -> window
> static void *spam(void *x){ unsigned c[2]={1,1}; for(;;) reg(ring_fd,
> IORING_REGISTER_IOWQ_MAX_WORKERS, c, 2); return 0; }
> int main(void){
>     struct io_uring_params p; memset(&p,0,sizeof(p));
>     ring_fd = setup(8, &p);
>     pthread_t s; pthread_create(&s,0,spam,0); pthread_create(&s,0,spam,0);
>     for(;;){ pthread_t t[64];
>         for(int i=0;i<64;i++) pthread_create(&t[i],0,fresh,0);
>         for(int i=0;i<64;i++) pthread_join(t[i],0); }
> }
> 
> Reproduced on 7.1.0-rc1 with KASAN; the racy ordering predates the
> 2024 shadow-variable cleanup that last touched register.c:422.
> 
> Suggested fix
> 
> Either make io_register_iowq_max_workers() match its siblings:
> 
> before:
> 
> mutex_lock(&ctx->tctx_lock);
> list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
>     tctx = node->task->io_uring;
>     if (WARN_ON_ONCE(!tctx->io_wq)) // derefs tctx without NULL check
>         continue;
>     // skip
> }
> 
> to:
> 
> mutex_lock(&ctx->tctx_lock);
> list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
>     tctx = node->task->io_uring;
>     if (!tctx || !tctx->io_wq)
>         continue;
>     // skip
> }
> 
> or close the window in __io_uring_add_tctx_node() by publishing
> current->io_uring = tctx before the node is added to ctx->tctx_list,
> so a listed node always has a valid task->io_uring.

Setting ->io_uring = tctx before adding to the list is, by far, the
better fix. Rather than just report it, do you want to submit an actual
patch for that? I can surely patch it up myself, but you could also just
send a patch for it.

-- 
Jens Axboe

