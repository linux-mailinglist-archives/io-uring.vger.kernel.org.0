Return-Path: <io-uring+bounces-13484-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gPoDHYOZEWpSoAYAu9opvQ
	(envelope-from <io-uring+bounces-13484-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 14:11:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 78FD95BED29
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 14:11:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4B46A3007AEE
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2026 12:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B46A38425A;
	Sat, 23 May 2026 12:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MhYouPan"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1862D1F44
	for <io-uring@vger.kernel.org>; Sat, 23 May 2026 12:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779538259; cv=pass; b=KDFb7KgNbNEGepHL0AyZpofeCUW5gPk59mpo5AUvuBxU318lARJFIK/8SXl/lhGm5mc6jz2v4crKN5rcGBRTMO3YdEdL5m7ZO5Ref2jf8NuaH6cPbbEnILOqsUX73CqIKjtmCVyuAG8U09u8iHKKX1keDyPvqo0wPN0EaLXRpnA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779538259; c=relaxed/simple;
	bh=wg0f+OvvCYylO83TtWG1nI/wKiurekcK2RjstRCc0TM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=tAKEgCI5bZVBH0mpVmvGf869PETje+DLSnMtGHSczqzJ2ymzxMOhAGhGfAqx0lpeBR7TFm2fFEuKhpTfDT7O8SPRh6qXTVeLkPZ5rni5Y6aRnMiygvxJOIcND75uBjO3QnaPScfk4+eIdPaJPyLoNCdyTl3rRfB6+8/2KAR56JE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MhYouPan; arc=pass smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-63127c440ccso6035287137.3
        for <io-uring@vger.kernel.org>; Sat, 23 May 2026 05:10:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779538256; cv=none;
        d=google.com; s=arc-20240605;
        b=AGQ1t9OZZlt6i4+Kta2JyS99Z65+AP9YPmag6X8362/n0vJpjJLW+GFDLNtFJjiwtJ
         Sxa5xxYSnhYdBm6mZ8U2eemJgtKQZfoqumuSPhu07vIxaxEYlxpaihhs5NenOssWht3V
         g3anVCSIXv1T/OCYBCtjRdBIOF+BUY/lB2oR4B1YweAfk170zSxcYGx+QZswPaaKzAko
         qFHHfi6V8mj23hthVX1s8PjuuuQehg5uy47sSagomAxw9ovrS9xj97q6cQb+6P5Tvg7T
         O7E1yTeQ8GHHFqG1L2D3Q4qEDBHFlRcmTSoEInOjd1sgrxiK8RzuxsQvLgY/JocW3VLT
         MmeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WPPlDffJ7huHFcDG9SMEKx0kEuxi5fGOap/S/XxM62s=;
        fh=idzk5Dr+ApQ8TEH6aUIB3iEAqiPcZ35vqDuKckUKuB8=;
        b=SBtlJtDgGn4q057787QY9tZ8xMw6o1O1sL1tCbgHhrtDNF/jsH0UuDDza0ScXRoQS/
         2Iojttg7spzcjFsiJmuk9vFBkKP9cRpg/tG4hnAfbWfpnIOAS1u+u5ZEWjolgs6iKafd
         MXAS/h1X1VLbSZDnEqutU4WHusRmOoUlzYDDOmOxw7+VTKVyxG9vco7Wt6HgId/vkrhN
         sR4aAJ3VnP2opOhzq0+Ov1HJRx52uJvI6iejh7cIEt9uMwnNAZDGz/+OgUC35j3dMFkd
         9N7316U5MYE+ch0o/ozeZLPNy6/uShgJTAPg8075WnNghlZB438trciXr7XFr9nElHaQ
         /ocg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779538256; x=1780143056; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WPPlDffJ7huHFcDG9SMEKx0kEuxi5fGOap/S/XxM62s=;
        b=MhYouPanQiJYekXnXSnBunNLuo6Pzxp/vQJ6hkyCAdGbcmlU2afp6pN46m/D66JYCS
         NwI5hDRn6gTAhNABMIHqejts2zfu/TW1iIsHoVSFBjKkPlN9FgDL2zILwOUzBDfPJXP5
         ta+1lmZGlQeLcQblxwKHSBxDSJ1HhNBVMJzApTAPr1c+jrGF1mILdq8ODZ4oj+0wMX9F
         kxRB0EwK9FaITt/BNBarH55f8eo0LWe2pqNLc9f9GVOGZmg/JEZCkuK8dOLhq1qKfdX+
         rp4JJo9LMY+cr/JC7u9aU8tPHUZdBAnzCDD9PfQLGF5Vmhrc9lu3fCsv7eIui/xCVHr4
         2npw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779538256; x=1780143056;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WPPlDffJ7huHFcDG9SMEKx0kEuxi5fGOap/S/XxM62s=;
        b=SP8YTjVWetA2fi5m3il/OPlsgw3grch+Cplu4v22duseIzvsS2pN+TmoZ4bv7uQvKp
         Dr2AW1SwR127syBMsW0wSV+liqnJhz4EvxjNmMgR2BYuIeRwMI++rzDcLh2UcIvYDLd2
         IFJmUdsZ9/4oYv86ZnemsGVdCWJUTOsBoRHdC4pBGvLSaehHmymo7bT47gZ2LT2aC4sk
         IV9YWxsmLVUwdLx5P6kH6lfMGaiNSh9ggPj1wMirFlmXzcn1yJN2YaSeLqXmDofxYhx4
         nO+svDDwdnB1aJkHkN3Cnodw128fmPGXb5+PM8U4oF7TYdp/80JA6s3Gja6IgPRfHtqu
         4qCQ==
X-Gm-Message-State: AOJu0Yyd6IaFd3TPV11VH8JnsnoxukiC5udXbwChIw/E+xQiNaka0ll4
	ZRo8ndqSFXf9WrLBUHf6g2bfRJGoExNIac4gXd+Wq19NoeB0F9SUY1JwY0F3n7uS9dFy8i8Qu05
	9LkrsLPrpixD4wSOS2DwMhcUscUenCKwlr4Pt
X-Gm-Gg: Acq92OGXM/Luln58olnQpB8jZuqKMaDgBYK8w+Sp9dU3PkhZHdzAM8hjG4fYww7XI8k
	Qj85FJqTEk2DL9Dm07MlcCC+F83CsHkz8tbZL3/wF75SqiXsM10KKxIEr51VyaQOdtc5ggazGvt
	yMjM6QBSaL4NCXVbRiVqFD6WcPg3HzCoSAQecplBKYAvT6U5lsMpIPj1vkFL4VMqJFyOVLm6IeQ
	2P+aWKcKSmpdziMgTPbtuOdHNfUtSHBNrSFkrBG3+zUu52CoHxSJUkwTx3AXfz7z6fYSQftP861
	VWy/S8CTrAetuinD2LH6KiSxzBw=
X-Received: by 2002:a05:6102:5114:b0:631:b365:40f6 with SMTP id
 ada2fe7eead31-67c7f2734f1mr3883781137.23.1779538256553; Sat, 23 May 2026
 05:10:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CACR30Wj7yEweYqJg4Ovrbr4s9a8EZRYD8FMAWhjWUv3XunrMFQ@mail.gmail.com>
In-Reply-To: <CACR30Wj7yEweYqJg4Ovrbr4s9a8EZRYD8FMAWhjWUv3XunrMFQ@mail.gmail.com>
From: =?UTF-8?B?7Iuc66as7Ja8?= <shja0831@gmail.com>
Date: Sat, 23 May 2026 21:10:45 +0900
X-Gm-Features: AVHnY4J9eLQ9lh3Gk3VGUtky4EseslaiQAlGyM1YKE3DxhI6QzZXYq70GujW8aw
Message-ID: <CACR30WjNLCzzFTvdtM-kHC5Ei+W6H6Jeq3WpVh-asm0Ju1zv_Q@mail.gmail.com>
Subject: Re: [bug] io_uring : NULL pointer deref in io_register_iowq_max_workers()
To: io-uring@vger.kernel.org, axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-13484-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[shja0831@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 78FD95BED29
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

I checked again: the missing `!tctx` check in
io_register_iowq_max_workers() is older, but the specific race window
I described appears to come from the recent tctx refactor.

2026=EB=85=84 5=EC=9B=94 23=EC=9D=BC (=ED=86=A0) =EC=98=A4=ED=9B=84 9:00, =
=EC=8B=9C=EB=A6=AC=EC=96=BC <shja0831@gmail.com>=EB=8B=98=EC=9D=B4 =EC=9E=
=91=EC=84=B1:
>
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
> RIP: 0010:__do_sys_io_uring_register.cold+0xcae/0xe32 io_uring/register.c=
:1029
> Code: bd 68 09 00 00 48 89 fa 48 c1 ea 03 42 80 3c 2a 00 74 05 e8 06
> 3a 40 01 48 8b ad 68 09 00 00 48 8d 7d 18 48 89 fa 48 c1 ea 03 <42> 80
> 3c 2a 00 74 05 e8 e8 39 40 01 48 8b 6d 18 48 85 ed 0f 85 ec
> RSP: 0018:ffffc90002a9fd90 EFLAGS: 00010206
> RAX: 1ffff11004c9f63a RBX: ffff888054ee4000 RCX: 0000000000000001
> RDX: 0000000000000003 RSI: ffffffff81364a23 RDI: 0000000000000018
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffc90002a9fd90 R11: 0000000080000000 R12: ffff8880264fb1c0
> R13: dffffc0000000000 R14: 0000000000000013 R15: 0000000000000013
> FS:  00007ff8525ee6c0(0000) GS:ffff8880d687a000(0000) knlGS:0000000000000=
000
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
> RIP: 0010:__do_sys_io_uring_register.cold+0xcae/0xe32 io_uring/register.c=
:1029
> Code: bd 68 09 00 00 48 89 fa 48 c1 ea 03 42 80 3c 2a 00 74 05 e8 06
> 3a 40 01 48 8b ad 68 09 00 00 48 8d 7d 18 48 89 fa 48 c1 ea 03 <42> 80
> 3c 2a 00 74 05 e8 e8 39 40 01 48 8b 6d 18 48 85 ed 0f 85 ec
> RSP: 0018:ffffc90002a9fd90 EFLAGS: 00010206
> RAX: 1ffff11004c9f63a RBX: ffff888054ee4000 RCX: 0000000000000001
> RDX: 0000000000000003 RSI: ffffffff81364a23 RDI: 0000000000000018
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffc90002a9fd90 R11: 0000000080000000 R12: ffff8880264fb1c0
> R13: dffffc0000000000 R14: 0000000000000013 R15: 0000000000000013
> FS:  00007ff8525ee6c0(0000) GS:ffff8880d687a000(0000) knlGS:0000000000000=
000
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
> * 2a: 42 80 3c 2a 00       cmpb   $0x0,(%rdx,%r13,1) <-- trapping instruc=
tion
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
>     tctx =3D node->task->io_uring;
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
>     node->task =3D current;
>     mutex_lock(&ctx->tctx_lock);
>     list_add(&node->ctx_node, &ctx->tctx_list);   // node visible
>     mutex_unlock(&ctx->tctx_lock); // lock dropped
>
> __io_uring_add_tctx_node():
>     ret =3D io_tctx_install_node(ctx, tctx);
>     if (!ret)
>         current->io_uring =3D tctx;   // set AFTER, outside lock
>
> There is a window where a node is on ctx->tctx_list while
> node->task->io_uring is still NULL (the task is doing its first
> io_uring op, tctx freshly allocated, not yet published). A concurrent
> IORING_REGISTER_IOWQ_MAX_WORKERS on the same ring takes
> ctx->tctx_lock, iterates, reads node->task->io_uring =3D=3D NULL, and
> dereferences tctx->io_wq =E2=86=92 GPF.
>
> The other two ctx->tctx_list consumers already guard this =E2=80=94 cance=
l.c
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
> static void *spam(void *x){ unsigned c[2]=3D{1,1}; for(;;) reg(ring_fd,
> IORING_REGISTER_IOWQ_MAX_WORKERS, c, 2); return 0; }
> int main(void){
>     struct io_uring_params p; memset(&p,0,sizeof(p));
>     ring_fd =3D setup(8, &p);
>     pthread_t s; pthread_create(&s,0,spam,0); pthread_create(&s,0,spam,0)=
;
>     for(;;){ pthread_t t[64];
>         for(int i=3D0;i<64;i++) pthread_create(&t[i],0,fresh,0);
>         for(int i=3D0;i<64;i++) pthread_join(t[i],0); }
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
>     tctx =3D node->task->io_uring;
>     if (WARN_ON_ONCE(!tctx->io_wq)) // derefs tctx without NULL check
>         continue;
>     // skip
> }
>
> to:
>
> mutex_lock(&ctx->tctx_lock);
> list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
>     tctx =3D node->task->io_uring;
>     if (!tctx || !tctx->io_wq)
>         continue;
>     // skip
> }
>
> or close the window in __io_uring_add_tctx_node() by publishing
> current->io_uring =3D tctx before the node is added to ctx->tctx_list,
> so a listed node always has a valid task->io_uring.
>
>
> LimHyeonJun

