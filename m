Return-Path: <io-uring+bounces-9562-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6554DB4438C
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 18:49:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 608301884423
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 16:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 412272D46AF;
	Thu,  4 Sep 2025 16:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Lc/cYZNb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900AC225A4F
	for <io-uring@vger.kernel.org>; Thu,  4 Sep 2025 16:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757004384; cv=none; b=Hu0kBBolgstbWRl8If0ocVzTpBZe2ogz6xniFujt51F1h7dLNUksyBSPECmIZlqXbgPx5UIZwbUUlRE3CJX7l6+yUq0mwh3GT63uoA0NuBtr3atjgZSya/T8BGaRWD8YjPog3VvOr9p8zQQJT6BJPC8C/gSQX13r+0N+fLP3EeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757004384; c=relaxed/simple;
	bh=yeig2/h6+JzCj8J11pJs7VODI2hn7tsgFbunC4RZtuw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MAq63vbf2JrB0esm9pt6JBCXdOkLO0eA2bSp01j8xRYijHKk3JjGsXeduDIH8cBQrGUsdlAP1B64I3VqQBQfvugmvvI412BIzIPFQTP7MSK44aJxLej+VtEvEQUEXITcuoy+NErSVT0sARugAHfEMf7wvCXTpeNsiJGl78FxIdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Lc/cYZNb; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-24ca270d700so2899125ad.0
        for <io-uring@vger.kernel.org>; Thu, 04 Sep 2025 09:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757004382; x=1757609182; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=esdQfPQXbS6WrJkjrbmIf4YcFmqNl+DroIr0Wz/5KiE=;
        b=Lc/cYZNbgaQ0l4SMf9I64auH60EIJpJOdNYKo7E3QctflA/cI3bOors2/cguIvOr5p
         YgkK3kjmp/F+hz44Trvy2nS91heWvDdpQ40Fmyeg8T6lqB4A4opQ/kruoi6vCklMtDX3
         MZXkfYlZedggCJ7J0Q7mIAHE/E4ckwLM7HfgcjbSkesNpt9SNnGwbGapqmH3LOfc5A0i
         vnc7w1F4MmBxHfkedD4AJzKwtnYOgeMoqrEpvf6ojDKd7+SFZ9KaWKIX6YuovvEBztVI
         J5VJWd50VjWilEW9xgSgWShY98eFEOaqPNs9Grrpo+iKOrU38PTSnINJR1hnKqfoaaaV
         mqRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757004382; x=1757609182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=esdQfPQXbS6WrJkjrbmIf4YcFmqNl+DroIr0Wz/5KiE=;
        b=u/Sl28HnBCL/YG83a8Z38OEF9H1ym8FRIT8KK16Z/RKt6hcWFuhlRxg108ua6VzvPU
         RKJP4thc30qnkmJ0wF9PoVZ+XKUY8/kdMd/VZCbPit6MjkziK/xyP6B+J1ablCqBD5NL
         VvRYS8CU9d624F+i4UZWhuSGi2H4xUbbzvpjRa4wv+3NYTMktYvOVkhg2AFYS8CMu5qz
         4nYYq1GZAR9qM8GnEOcZVeMJ1xh6tO/Q18Wq3KR/VpNLyS3WsKOuBHLtWU9zSSZdzlcc
         tOV/tLT8OOHhxc74UpW9q/et60CcCDdwtHpKDXSLlJpSSB7mRgahIIhk6UgwMK5+jrs5
         A8CQ==
X-Forwarded-Encrypted: i=1; AJvYcCXab/iA0M0E7ZuBmrfjVovceLNG3rJmAKYbGOpWe7jS93urgnZS3JzHO8KcIe/C2H3buOnrozDmlw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjhilU7aow15tVUgPMX1qsW6Vwtu4nXgsQc6B2SDML1outTLUy
	hfng334/oh2PSte3h3q3oFdP53lkzjed0uf0kvSvkkHhOUo0621BCDrAvUtNAd7UwPKO5n6gBs4
	BKjEnmSm1NvlKD1RX3G5mGZXRwCmwmHjsgAvbOg7GA5DKrYX5gg8sy4XEsQ==
X-Gm-Gg: ASbGncuBpCVahinZGwrA7b46G806htPmv8uqTbdTdtevt+JtDdxrI2j3kHRf4Z4n6Y6
	xJJI84oSMCYa/JrZQMR5smq0GFawjzst+8jT72Nu5+Zx9O2gKPmh5vfw7zMqY+haZdhLivZfj9K
	5uhc0BbXy5xSBi2B7GM7gKGcmiB50G6O4EBCM9HQgFdH4ZLOCdSNCxf7DbQZzChNsUwiuDbZyDs
	F0/OfYQ05Fp
X-Google-Smtp-Source: AGHT+IGrZNSK0knOxEHf6PsWEDnTsqGXLr9ZT4FDcu0e0+A+rMw9hJbAM6Q+b2AWs6Aec9Wiln+LuYk7mvryiLvgOqg=
X-Received: by 2002:a17:902:ce8c:b0:24c:7bc8:a51c with SMTP id
 d9443c01a7336-24c7bc8a879mr52655195ad.9.1757004381611; Thu, 04 Sep 2025
 09:46:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <68b8b95f.050a0220.3db4df.0206.GAE@google.com> <26aa509e-3070-4f6b-8150-7c730e05951d@kernel.dk>
 <CADUfDZpTtLjyQjURhTOND5XbdJOSEduDLdSuyUJVk_OKG9HVGA@mail.gmail.com>
In-Reply-To: <CADUfDZpTtLjyQjURhTOND5XbdJOSEduDLdSuyUJVk_OKG9HVGA@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 4 Sep 2025 09:46:08 -0700
X-Gm-Features: Ac12FXxn_8Ji6Q7m7oxenDDgFiIonvxO9qeRpHFqvVppbyILUhbyHtFsJ57ZCzw
Message-ID: <CADUfDZot=DxWjERupMofRuyvK3jKx79yQUOSniqT4uhMac2dbw@mail.gmail.com>
Subject: Re: [syzbot ci] Re: io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot ci <syzbot+cibd93ea08a14d0e1c@syzkaller.appspotmail.com>, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 7:52=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Wed, Sep 3, 2025 at 4:30=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
> >
> > On 9/3/25 3:55 PM, syzbot ci wrote:
> > > syzbot ci has tested the following series
> > >
> > > [v1] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> > > https://lore.kernel.org/all/20250903032656.2012337-1-csander@purestor=
age.com
> > > * [PATCH 1/4] io_uring: don't include filetable.h in io_uring.h
> > > * [PATCH 2/4] io_uring/rsrc: respect submitter_task in io_register_cl=
one_buffers()
> > > * [PATCH 3/4] io_uring: factor out uring_lock helpers
> > > * [PATCH 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSU=
ER
> > >
> > > and found the following issue:
> > > WARNING in io_handle_tw_list
> > >
> > > Full report is available here:
> > > https://ci.syzbot.org/series/54ae0eae-5e47-4cfe-9ae7-9eaaf959b5ae
> > >
> > > ***
> > >
> > > WARNING in io_handle_tw_list
> > >
> > > tree:      linux-next
> > > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/n=
ext/linux-next
> > > base:      5d50cf9f7cf20a17ac469c20a2e07c29c1f6aab7
> > > arch:      amd64
> > > compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976=
-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > > config:    https://ci.syzbot.org/builds/1de646dd-4ee2-418d-9c62-617d8=
8ed4fd2/config
> > > syz repro: https://ci.syzbot.org/findings/e229a878-375f-4286-89fe-b67=
24c23addd/syz_repro
> > >
> > > ------------[ cut here ]------------
> > > WARNING: io_uring/io_uring.h:127 at io_ring_ctx_lock io_uring/io_urin=
g.h:127 [inline], CPU#1: iou-sqp-6294/6297
> > > WARNING: io_uring/io_uring.h:127 at io_handle_tw_list+0x234/0x2e0 io_=
uring/io_uring.c:1155, CPU#1: iou-sqp-6294/6297
> > > Modules linked in:
> > > CPU: 1 UID: 0 PID: 6297 Comm: iou-sqp-6294 Not tainted syzkaller #0 P=
REEMPT(full)
> > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debia=
n-1.16.2-1 04/01/2014
> > > RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:127 [inline]
> > > RIP: 0010:io_handle_tw_list+0x234/0x2e0 io_uring/io_uring.c:1155
> > > Code: 00 00 48 c7 c7 e0 90 02 8c be 8e 04 00 00 31 d2 e8 01 e5 d2 fc =
2e 2e 2e 31 c0 45 31 e4 4d 85 ff 75 89 eb 7c e8 ad fb 00 fd 90 <0f> 0b 90 e=
9 cf fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 22 ff
> > > RSP: 0018:ffffc900032cf938 EFLAGS: 00010293
> > > RAX: ffffffff84bfcba3 RBX: dffffc0000000000 RCX: ffff888107f61cc0
> > > RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
> > > RBP: ffff8881119a8008 R08: ffff888110bb69c7 R09: 1ffff11022176d38
> > > R10: dffffc0000000000 R11: ffffed1022176d39 R12: ffff8881119a8000
> > > R13: ffff888108441e90 R14: ffff888107f61cc0 R15: 0000000000000000
> > > FS:  00007f81f25716c0(0000) GS:ffff8881a39f5000(0000) knlGS:000000000=
0000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000001b31b63fff CR3: 000000010f24c000 CR4: 00000000000006f0
> > > Call Trace:
> > >  <TASK>
> > >  tctx_task_work_run+0x99/0x370 io_uring/io_uring.c:1223
> > >  io_sq_tw io_uring/sqpoll.c:244 [inline]
> > >  io_sq_thread+0xed1/0x1e50 io_uring/sqpoll.c:327
> > >  ret_from_fork+0x47f/0x820 arch/x86/kernel/process.c:148
> > >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> > >  </TASK>
> >
> > Probably the sanest thing to do here is to clear
> > IORING_SETUP_SINGLE_ISSUER if it's set with IORING_SETUP_SQPOLL. If we
> > allow it, it'll be impossible to uphold the locking criteria on both th=
e
> > issue and register side.
>
> Yup, I was thinking the same thing. Thanks for taking a look.

On further thought, IORING_SETUP_SQPOLL actually does guarantee a
single issuer. io_uring_enter() already avoids taking the uring_lock
in the IORING_SETUP_SQPOLL case because it doesn't issue any SQEs
itself. Only the SQ thread does that, so it *is* the single issuer.
The assertions I added in io_ring_ctx_lock()/io_ring_ctx_unlock() is
just unnecessarily strict. It should expect current =3D=3D
ctx->sq_data->thread in the IORING_SETUP_SQPOLL case.

Best,
Caleb

