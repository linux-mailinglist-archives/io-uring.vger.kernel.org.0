Return-Path: <io-uring+bounces-5202-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EA019E3E22
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 16:23:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 343011666EA
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 15:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88DA320C462;
	Wed,  4 Dec 2024 15:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fPz35+Z2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6F720D515;
	Wed,  4 Dec 2024 15:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733325759; cv=none; b=GbhJxDDLhfIybXKtsyXNx14eGKRMpG51fMTIlRrHGavmEDkOwHOgxokqTTcfb+Zh4T4Off+q969NFQrxm8wA9fviJTTcWn/J3EazZZ3SIihvbP/Z2o9DV4qGC55Ezy238IMNUeGKSDKthIX5nDbGJTkghGRuN9zjp3MOOO5HNp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733325759; c=relaxed/simple;
	bh=/TqB+llnTobyT0lJGCG96e4ET+EL+pZmgIbBSFix2GQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BLTjlDcZJyXgTFv3JcW+sL699VwT4AKWcj+93tgqtqX5p1Utrnkl+ozpG/WMg3ow0wxVQx/rdVo+Mk7Jfn8yTTvxMESvO56WmAwIaJ4UM8nlT984o4lETHFfxEFzFGVWC78V0NZbr3Q00l55eN9k4jD1MONclxr1yLFucABsrA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fPz35+Z2; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-53df1e0641fso7557360e87.1;
        Wed, 04 Dec 2024 07:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733325755; x=1733930555; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6afsJ2yFcI+Yl2bO9iFMRGUkAKAq+plwoBxQXkyhF8w=;
        b=fPz35+Z2A/fzjc4FQxNh7Q384YP37jY/xeMeCrd6dTrxNLsZTb/ZYF6GqmO9tQcJsr
         EPk/ezxh6HMHh0gGlNDl435JXdOce1H48UH2C8aSIolcnUyCP7Aw7nFyRPSEZ1TJvA/T
         HOr3EnQ2MYB+kYwIb1u6wBAIBWQar5TtVOL0UwebNvMNTgfCIwBa7EXD+DXhY9g/hX22
         8DICNQbKg0A1cFQL26sL6MAD/QRIoxemetlzX/gQV9UKQe60OSnmkHpIuRXFZj39kuOq
         hjv+Hf5Vq+6U5APUKMjaRizh9H4ySok8Zye+ihxBwFunI7hunm2pW3yVmkbbN8Ro2JeU
         7S2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733325755; x=1733930555;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6afsJ2yFcI+Yl2bO9iFMRGUkAKAq+plwoBxQXkyhF8w=;
        b=j4hiCuJd2iYiVs3WC9Jr22lvkqSAzYSrsjiVXlWmI0R8JxX45BR2AVXU3Kscxz+DdS
         lhiUvvMA3DVuNSCi67YyMNCDXFDMB0EbgqTpoA2HcLTEXPBndrMbQEITgLrJS9hQ1PtA
         p+EUqn7NP/olvaORIBoPuoIUTdVvbnGNxCxoWGHf5xAuqbur0fhjzJJ6B9XAEaC0xkuG
         BcJyg0chcJQXHw1rOvh258QGT9A+BJJwDpVlVA2gSh8bptPMSIxuVb26p2PqRHvHYo51
         wpwbG8MvSpXGlgJMfsfxQnYk2szHUbG1NRTE+plULCIYRGp7xKNePwxAbDsd+EnSyjvz
         /2rA==
X-Forwarded-Encrypted: i=1; AJvYcCVv31eCFLK/5RByiSZMRuvudEVDzgiv8CCFFbwORZYC5f20p5J/ATL6C0UwJaFq8rtPeIl4rBk15gUYRFp4@vger.kernel.org, AJvYcCWa8Fjx/wZ+RPiyOIeUcUx6uRZuK+OiSvytKnGeYs13vme9pecN2MqCE1IFpLLYaxkOCOzhivzSow==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQPGFXtgdLQqB2tiR/nGAiP+bqpka8ahJVNKSYpwkd6mia+iBG
	8/+tnhgyz00KcGXBrZ5OChSCr5L+UfHHNifUN+YHHLmuDdaEt1VQOrHxKSaQm9atE2UXSwrcWLV
	08+AAIXBxRcT7kZ+M21AOCCdp7Ys=
X-Gm-Gg: ASbGncsxYIvj8fKJVGA+iXmmzpyNGgl+KvUxIK9nYPPZoko6hOgiVznrqBMwpsQh2sJ
	LtdPqAJIDabGTx5jLleD6VgyZdf087Mj7MnxLaJAPt7a4ZRzYBt8JHVDZ+ImlaOhvJQ==
X-Google-Smtp-Source: AGHT+IGNUnqm/nSeoXYDXT045TPno+we4Z8y/9Tq82fC+/vSNin5ySvIB++nP7ahTG1Ao72yddkowVJnH/FzCUkbJ64=
X-Received: by 2002:a05:6512:3f1f:b0:53d:d420:7241 with SMTP id
 2adb3069b0e04-53e129ffeeamr3404666e87.20.1733325755214; Wed, 04 Dec 2024
 07:22:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67505f88.050a0220.17bd51.0069.GAE@google.com> <6be84787-b1d9-4a20-85f3-34d8d9a0d492@kernel.dk>
 <a41eb55f-01b3-4388-a98c-cc0de15179bd@kernel.dk>
In-Reply-To: <a41eb55f-01b3-4388-a98c-cc0de15179bd@kernel.dk>
From: Tamir Duberstein <tamird@gmail.com>
Date: Wed, 4 Dec 2024 10:21:59 -0500
Message-ID: <CAJ-ks9kN_qddZ3Ne5d=cADu5POC1rHd4rQcbVSD_spnZOrLLZg@mail.gmail.com>
Subject: Re: [syzbot] [io-uring?] KASAN: null-ptr-deref Write in sys_io_uring_register
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com>, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 10:10=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/4/24 8:01 AM, Jens Axboe wrote:
> > On 12/4/24 6:56 AM, syzbot wrote:
> >> Hello,
> >>
> >> syzbot found the following issue on:
> >>
> >> HEAD commit:    c245a7a79602 Add linux-next specific files for 2024120=
3
> >> git tree:       linux-next
> >> console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D10ae840f98=
0000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Daf3fe1d01b=
9e7b7
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=3D092bbab7da23=
5a02a03a
> >> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for =
Debian) 2.40
> >> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D14a448df=
980000
> >> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D15cca33058=
0000
> >>
> >> Downloadable assets:
> >> disk image: https://storage.googleapis.com/syzbot-assets/8cc90a2ea120/=
disk-c245a7a7.raw.xz
> >> vmlinux: https://storage.googleapis.com/syzbot-assets/0f6b1a1a0541/vml=
inux-c245a7a7.xz
> >> kernel image: https://storage.googleapis.com/syzbot-assets/9fa3eac09dd=
c/bzImage-c245a7a7.xz
> >>
> >> IMPORTANT: if you fix the issue, please add the following tag to the c=
ommit:
> >> Reported-by: syzbot+092bbab7da235a02a03a@syzkaller.appspotmail.com
> >>
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> BUG: KASAN: null-ptr-deref in instrument_atomic_read_write include/lin=
ux/instrumented.h:96 [inline]
> >> BUG: KASAN: null-ptr-deref in atomic_long_sub_and_test include/linux/a=
tomic/atomic-instrumented.h:4521 [inline]
> >> BUG: KASAN: null-ptr-deref in put_cred_many include/linux/cred.h:255 [=
inline]
> >> BUG: KASAN: null-ptr-deref in put_cred include/linux/cred.h:269 [inlin=
e]
> >> BUG: KASAN: null-ptr-deref in io_unregister_personality io_uring/regis=
ter.c:82 [inline]
> >> BUG: KASAN: null-ptr-deref in __io_uring_register io_uring/register.c:=
698 [inline]
> >> BUG: KASAN: null-ptr-deref in __do_sys_io_uring_register io_uring/regi=
ster.c:902 [inline]
> >> BUG: KASAN: null-ptr-deref in __se_sys_io_uring_register+0x1227/0x3b60=
 io_uring/register.c:879
> >> Write of size 8 at addr 0000000000000406 by task syz-executor274/5828
> >>
> >> CPU: 1 UID: 0 PID: 5828 Comm: syz-executor274 Not tainted 6.13.0-rc1-n=
ext-20241203-syzkaller #0
> >> Hardware name: Google Google Compute Engine/Google Compute Engine, BIO=
S Google 09/13/2024
> >> Call Trace:
> >>  <TASK>
> >>  __dump_stack lib/dump_stack.c:94 [inline]
> >>  dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
> >>  print_report+0xe8/0x550 mm/kasan/report.c:492
> >>  kasan_report+0x143/0x180 mm/kasan/report.c:602
> >>  kasan_check_range+0x282/0x290 mm/kasan/generic.c:189
> >>  instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
> >>  atomic_long_sub_and_test include/linux/atomic/atomic-instrumented.h:4=
521 [inline]
> >>  put_cred_many include/linux/cred.h:255 [inline]
> >>  put_cred include/linux/cred.h:269 [inline]
> >>  io_unregister_personality io_uring/register.c:82 [inline]
> >>  __io_uring_register io_uring/register.c:698 [inline]
> >>  __do_sys_io_uring_register io_uring/register.c:902 [inline]
> >>  __se_sys_io_uring_register+0x1227/0x3b60 io_uring/register.c:879
> >>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> >>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> >>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >> RIP: 0033:0x7f65bbcb03a9
> >> Code: 48 83 c4 28 c3 e8 37 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 8=
9 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0=
 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> >> RSP: 002b:00007ffe8fac7478 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
> >> RAX: ffffffffffffffda RBX: 000000000000371d RCX: 00007f65bbcb03a9
> >> RDX: 0000000000000000 RSI: 000000000000000a RDI: 0000000000000003
> >> RBP: 0000000000000003 R08: 00000000000ac5f8 R09: 00000000000ac5f8
> >> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> >> R13: 00007ffe8fac7648 R14: 0000000000000001 R15: 0000000000000001
> >>  </TASK>
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Not sure what's going on with -next, but this looks like nonsense - we
> > store a valid pointer in the xarry, and then attempt to delete an
> > invalid index which then returns a totally garbage pointer!? I'll check
> > what is in -next, but this very much does not look like an io_uring
> > issue.
>
> Took a quick look, and it's this patch:
>
> commit d2e88c71bdb07f1e5ccffbcc80d747ccd6144b75
> Author: Tamir Duberstein <tamird@gmail.com>
> Date:   Tue Nov 12 14:25:37 2024 -0500
>
>     xarray: extract helper from __xa_{insert,cmpxchg}
>
> in the current -next tree. Adding a few folks who might be interested.
>
> --
> Jens Axboe

Yep, looks broken. I believe the missing bit is

diff --git a/lib/xarray.c b/lib/xarray.c
index 2af86bede3c1..5da8d18899a1 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1509,7 +1509,7 @@ static void *xas_result(struct xa_state *xas, void *c=
urr)
 void *__xa_erase(struct xarray *xa, unsigned long index)
 {
  XA_STATE(xas, xa, index);
- return xas_result(&xas, xas_store(&xas, NULL));
+ return xas_result(&xas, xa_zero_to_null(xas_store(&xas, NULL)));
 }
 EXPORT_SYMBOL(__xa_erase);

This would explain deletion of a reserved entry returning
`XA_ZERO_ENTRY` rather than `NULL`.

My apologies for this breakage. Should I send a new version? A new
"fixes" patch?
tamird

