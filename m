Return-Path: <io-uring+bounces-5473-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BC3C9F0816
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 10:39:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A48F1688B9
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 09:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFA441B21A6;
	Fri, 13 Dec 2024 09:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BGK/TlWj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216A51B21B5;
	Fri, 13 Dec 2024 09:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734082777; cv=none; b=kJTWljT+roqrSxZnzVfbjWAS13Ub7BYKnoEVAj1ubOPHNVlBI+KWmMlyfwTkM8T0zZBqAG8/KFye7qaiG8nJxWxzDWbZU2dHH/B58/MU9VWaH+YwRT0W1CpgInWlCE1bTxc6JP1LWHVWGTxyLCL2ZqbjUw3kwZLbjtM28QpY+q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734082777; c=relaxed/simple;
	bh=2L5lAyEWkdVmL96bLDlVUIG2j2Aq8GQiBNVleqkyBSQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tk0E88raLjcfkV5nykJ/m7CbFaonWzRElQpamUWh+J1mO+q6zjnnWkVgAr40HyYp5MEI0h8DWDLiUGG2RQc4IWCaD7jDlXnoLllSpNjbiZ/dQDMqozhnK6ziPjT5KHBBwTV5Q9lxSCtrcEIFeTKClexA+sqWsIep9CLU2ab7Yq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BGK/TlWj; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e3989d27ba3so1126097276.1;
        Fri, 13 Dec 2024 01:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734082775; x=1734687575; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2WzXrrNBCvQo/syDyaPkQNglT/v5xu+6+favT8WJcK4=;
        b=BGK/TlWjSGLqifpvNmAcFB9mdnjAjQWVJpc2tPLSVlCKSeiwpHFxFxbJZu4IgsC9yM
         YTlQ9z6o0gE9sRT365YHgJNEucgqAPF8J+GuSWsD91l5vjjLBREDIurs91f6SxMPiX3o
         wmoM9hvBrjASvLGuTO/HBbriNzi/hzOPbl3bwC/LVcyzy2tE6Dn+iWptW0Ql4mEBL2/O
         qEkJWkVuoBrOMxec2fVfWbU0QnCoP5NIJeIOJpPsOSq0yJ8PWKOfyp064towO2p3oTA+
         a4Q2s5LpZf+4H/hA5z2d5ZqTc6kzLlA43MV6eoTP+lHaG7fAp2rT0V9eCrLW3g5Muxrm
         eGvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734082775; x=1734687575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2WzXrrNBCvQo/syDyaPkQNglT/v5xu+6+favT8WJcK4=;
        b=EFFYThfx2Fz7qgM66Wos0nLQkbqsSADdaRMJEoEm5UY2lNpf3HVRXJ4tcuCyVts17E
         2wT6qeQ4cOcIyOJOe8mlNhw08qRGTxTKSDFf2zGTyZMGOTaJG7CN+PtU2MPn0Ns4ZXDP
         jgTjRZOg/oZ6kTyuoN8ePw9vGX9hkU8xotYeJ8m5lXyKdaJy7kdgDZKMdhuMjxmMyHhw
         670yDLsxJuGViXhmDPZB/W69QOMMm27Mdm4c5mW/7crkUMdeN3PQtrI9MmRC/g5TXZaN
         KVOzYgRD7HNtsODG3OD0FWApJUkruHy+icor1PcR/icvynkR4mvA4kv2E8YLIHe8HaCQ
         Vdfw==
X-Forwarded-Encrypted: i=1; AJvYcCVRgR5I3d8p61VScOIIkmFJSKoTOvgAECruf1nmwtX6K+i/BEy6QXr9BD6EnLdsz7r0z+rbw/FGagwyJqAN@vger.kernel.org, AJvYcCXM5zP/IghYutDAn8DnzvIp4EeexxDlYLf53wnA1au1RSltEQg44QBBypkAgpVHhNmuUdkTinBbUw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywnx1y8+FS1GvvpV1P6Sr14h2XBkC1Rf2T2FuO6deMu6hATD0Bo
	G5T6vQUxnBcnP9xxDgIJds9I4805WLODrqR8lk/OWm5JXxt6Va43QjLO5ClzWCjZvMN6HXrAKZD
	/2Yi+E7KmbiMt96l4FBMpeJVVXLk=
X-Gm-Gg: ASbGncvenQh0FyAGzYMiORVn4Rj2dUoMQTidJ2UDqaXvxsmzMhk+mhHCBBxrCru063E
	Iw8PCRhJVLMoJEHEaDHpZ/79CEpLVeoRYZjmCZowmvmljRWJ1x9A/JKJuY/+af30Y1Hgljt79
X-Google-Smtp-Source: AGHT+IEcOXDHlo9tEKngrWp6ebSiXKupA2V5MWh42fbUkTt+HhZQULMA6Dh20jiYUCgSPmcJBtOwk85vhH9TQmZBlEw=
X-Received: by 2002:a05:6902:1692:b0:e38:b48b:5fc3 with SMTP id
 3f1490d57ef6-e4350ba9a5emr1406490276.32.1734082775058; Fri, 13 Dec 2024
 01:39:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADZouDRcO6QORhUUHGRBQvZ_q8nip0S+Mn4Hb61W8zi_OfmSag@mail.gmail.com>
 <85c4b3a6-559a-4f1d-bf2d-ec2db876dec7@kernel.dk>
In-Reply-To: <85c4b3a6-559a-4f1d-bf2d-ec2db876dec7@kernel.dk>
From: chase xd <sl1589472800@gmail.com>
Date: Fri, 13 Dec 2024 10:39:24 +0100
Message-ID: <CADZouDRVN0eVMNXDPX9vSGXYbOPSHRgspWz20VO4fzNeFq18ew@mail.gmail.com>
Subject: Re: [io-uring] general protection fault in io_register_clone_buffers
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sure, I'm glad I could help. The kernel no longer crashes after this
patch, so it seems to be the right fix.

On Thu, Dec 12, 2024 at 3:58=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/12/24 3:06 AM, chase xd wrote:
> > Syzkaller hit 'general protection fault in io_register_clone_buffers' b=
ug.
> >
> > Oops: general protection fault, probably for non-canonical address
> > 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN NOPTI
> > KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> > CPU: 5 UID: 0 PID: 12910 Comm: syz-executor169 Not tainted
> > 6.12.0-rc4-00089-g7eb75ce75271-dirty #7
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04=
/01/2014
> > RIP: 0010:io_clone_buffers io_uring/rsrc.c:1039 [inline]
> > RIP: 0010:io_register_clone_buffers+0xbb1/0xf40 io_uring/rsrc.c:1076
> > Code: 48 63 c3 41 89 dd 4c 8d 3c c6 4c 89 fa 48 c1 ea 03 42 80 3c 22
> > 00 0f 85 61 02 00 00 49 8b 17 48 8d 7a 10 48 89 f9 48 c1 e9 03 <42> 80
> > 3c 21 00 0f 85 62 02 00 00 48 8b 72 10 4c 89 f7 e8 b8 93 ff
> > RSP: 0018:ffffc90011047bd8 EFLAGS: 00010212
> > RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000002
> > RDX: 0000000000000000 RSI: ffff888017acfec0 RDI: 0000000000000010
> > RBP: ffffc90011047d28 R08: 0000000000000000 R09: fffffbfff1dbb731
> > R10: 0000000000000002 R11: 0000000000000000 R12: dffffc0000000000
> > R13: 0000000000000001 R14: ffff888021760000 R15: ffff888017acfec8
> > FS:  00007fcbf80f4640(0000) GS:ffff88823bf00000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007fcbf806e658 CR3: 000000002420a000 CR4: 0000000000750ef0
> > PKRU: 55555554
> > Call Trace:
> >  <TASK>
> >  __io_uring_register+0x922/0x2290 io_uring/register.c:804
> >  __do_sys_io_uring_register io_uring/register.c:907 [inline]
> >  __se_sys_io_uring_register io_uring/register.c:884 [inline]
> >  __x64_sys_io_uring_register+0x178/0x2b0 io_uring/register.c:884
> >  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> >  do_syscall_64+0xcb/0x250 arch/x86/entry/common.c:83
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7fcbf815322d
> > Code: c3 e8 77 24 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 89 f8 48
> > 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> > 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007fcbf80f41a8 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
> > RAX: ffffffffffffffda RBX: 00007fcbf81f5088 RCX: 00007fcbf815322d
> > RDX: 0000000020000600 RSI: 000000000000001e RDI: 0000000000000004
> > RBP: 00007fcbf81f5080 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000c90
> > R13: 0000000000000003 R14: 00007fcbf811a630 R15: 00007fcbf80d4000
> >  </TASK>
> > Modules linked in:
> > ---[ end trace 0000000000000000 ]---
> > RIP: 0010:io_clone_buffers io_uring/rsrc.c:1039 [inline]
> > RIP: 0010:io_register_clone_buffers+0xbb1/0xf40 io_uring/rsrc.c:1076
>
> I can't run these crazy syzbot reproducers, I do wish they'd be dwindled
> down to the bare minimum rather than have tons of unrelated bits in
> there. That said, can you check with this patch?
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index adaae8630932..077f84684c18 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1036,8 +1036,10 @@ static int io_clone_buffers(struct io_ring_ctx *ct=
x, struct io_ring_ctx *src_ctx
>  out_put_free:
>         i =3D data.nr;
>         while (i--) {
> -               io_buffer_unmap(src_ctx, data.nodes[i]);
> -               kfree(data.nodes[i]);
> +               if (data.nodes[i]) {
> +                       io_buffer_unmap(src_ctx, data.nodes[i]);
> +                       kfree(data.nodes[i]);
> +               }
>         }
>  out_unlock:
>         io_rsrc_data_free(ctx, &data);
>
> --
> Jens Axboe

