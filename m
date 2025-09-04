Return-Path: <io-uring+bounces-9559-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E9CEB43FA9
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 16:53:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD1021887E39
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 14:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C241272E51;
	Thu,  4 Sep 2025 14:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ZnLS8i3G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73A72DE70D
	for <io-uring@vger.kernel.org>; Thu,  4 Sep 2025 14:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756997540; cv=none; b=uTOX2V4w9ey8KECXtwvs5EJm175vN2upUee77x66XQkuh/E66dIfgVMLwKuMUOXcV2RpAoBPZxBp/wetnVeklwMryr5XoRozZ458UH4SLEc2c4uPIOqg8BF5kaNSJ/AABpZj5QnkX/u3R7JoKQ9FGFsSFrp1fRmRMih+cnu2bKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756997540; c=relaxed/simple;
	bh=M/qbKkwAMqX8y/mjZr7yB0B1J9DG1BwDuI+e+iriVCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MOgBRzmQRW1qBiD459/Kqd5wXi3Tdr8F+Ceqej82SMoNQ97FVnek2SJRhZszzk8NPpBBTz4N8N6rIPcXRLSO2RI4b/WbrIjMr2205FmJZsNGM/CtA+ogEoyfCDXAaKZqRskA/25MrCj4YtL5nOtfl9HdratMo7JSrrBgo3YcCtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ZnLS8i3G; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-24b150fb800so2585505ad.2
        for <io-uring@vger.kernel.org>; Thu, 04 Sep 2025 07:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1756997538; x=1757602338; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5L+1A0Qn6tDIJ/+5jrI0wrwIaFtPyK0t4LNaxoycC08=;
        b=ZnLS8i3Gsalr1yoHHJSUfPd0rgYAl7DFFKXmzO2jikUZENLNbrKLrG/hdprflybrND
         lJidFH5Gfrq5Xo7DqAujqJOmCq0u22SOQmf5mYg61qbIUppvYMOrrbwk56eX0Hizd/9w
         ZyhHHt2eBiPl5vdU8yWewPL74+i50IKaSl5iIg9ecyGHgwa0EVYrg7DTyZvf34hFouAo
         Ze485g4/tq21ABF16UmN2RjSwUJ3pr9sR14+uoXoBD50QtoYx32oXDYLFzpP5Wwrv7e6
         quLogIOUkZJQQDl6ishA7rlC1xz7t1lEqInEWbOs0jY6LKVnlAPiCkomAtYvwk0o/Hnz
         Pp4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756997538; x=1757602338;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5L+1A0Qn6tDIJ/+5jrI0wrwIaFtPyK0t4LNaxoycC08=;
        b=NeSY31Ghr5Alzwo07rezEEpbvNGWAiN14vDQhZRAx+AhvIqPqFit3fLle+BqsivlVb
         dp8AKhxzHMaBbvslC8ldXryIz8t9539EZjNYqN3sGDmmeqA+bY+bIUgr6lLggbAMq6F5
         +be5cx/cDgbZL1TQ2uqkpspZRV76533KKKwXCVGTIIA5Gem4QjyUr/uPQsgGRcGNqXtb
         r0Xw0BUc/eBTVC98pvodZG2czSLKMjGpVHdz6fav9LauxvVj5uGZTKbJJuyzrbO/UR/A
         Okn4odOs3AS/6Jmol8yofCpcOSyMEkKQAcLsEipDj374ZyuW4/Y11l5u4lnBChQEaGhE
         3f8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWb7QUf5zBrS9q6cWOY5WZ3blLgcZDv6ooMV7SNBtVzr5sLZf3eGEyqKr+cV1Ve4tPhybrdPzSxmw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwovBTXCTjzyiaDg+8MLad2uIxqowesc+trFft2mOJRdLING678
	XBuChj4/AcGWAJUZUdgmKEidcdNx96U2mskknri2L/IWF5lkNgIjORzWGh0jsZni9n6VAXnFACo
	FPn9v2DtyOUh1w140NXmf50vfvoeliZjXv60O9bDPAFDP2L6mCH7/VE0=
X-Gm-Gg: ASbGncv8sgjknCuMdwDccwTxifvxEpwf8QJhW/HXUTR1NE31GgeaiFgdOorw647yC4+
	iY7VjXjRz8/XPct+SuyEf9dTVKtTLJ1CakTKC8X32fbZ9a54S81zOcgjHAAlryaN8EEi8VTdUZ+
	6mD2dmCxkXAJ30MaaeULR1CFuSUk/JvIme/O9C8QDozLwGaZnCPd1Q5L+X8XtU6jRxiWOC1nOhn
	thwM9SzGjMgi2BxPCOQfAw=
X-Google-Smtp-Source: AGHT+IHrDO7rct8h3wx3u6xR/65kPbs84Tas/VoeMqMGcATS+awVWwLXLpF+ldKApAdeg3Rl6ZADKjLD+EBaorvmYQY=
X-Received: by 2002:a17:903:244b:b0:24c:cc2c:9da5 with SMTP id
 d9443c01a7336-24ccc2cacb3mr21272355ad.6.1756997537840; Thu, 04 Sep 2025
 07:52:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <68b8b95f.050a0220.3db4df.0206.GAE@google.com> <26aa509e-3070-4f6b-8150-7c730e05951d@kernel.dk>
In-Reply-To: <26aa509e-3070-4f6b-8150-7c730e05951d@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 4 Sep 2025 07:52:05 -0700
X-Gm-Features: Ac12FXzpBslhoYX3MBNzpJXMp8ILNPXUI_3B7i9RNClyL26lelIR3jOPX-IG6_o
Message-ID: <CADUfDZpTtLjyQjURhTOND5XbdJOSEduDLdSuyUJVk_OKG9HVGA@mail.gmail.com>
Subject: Re: [syzbot ci] Re: io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot ci <syzbot+cibd93ea08a14d0e1c@syzkaller.appspotmail.com>, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 3, 2025 at 4:30=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/3/25 3:55 PM, syzbot ci wrote:
> > syzbot ci has tested the following series
> >
> > [v1] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> > https://lore.kernel.org/all/20250903032656.2012337-1-csander@purestorag=
e.com
> > * [PATCH 1/4] io_uring: don't include filetable.h in io_uring.h
> > * [PATCH 2/4] io_uring/rsrc: respect submitter_task in io_register_clon=
e_buffers()
> > * [PATCH 3/4] io_uring: factor out uring_lock helpers
> > * [PATCH 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> >
> > and found the following issue:
> > WARNING in io_handle_tw_list
> >
> > Full report is available here:
> > https://ci.syzbot.org/series/54ae0eae-5e47-4cfe-9ae7-9eaaf959b5ae
> >
> > ***
> >
> > WARNING in io_handle_tw_list
> >
> > tree:      linux-next
> > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/nex=
t/linux-next
> > base:      5d50cf9f7cf20a17ac469c20a2e07c29c1f6aab7
> > arch:      amd64
> > compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1=
~exp1~20250708183702.136), Debian LLD 20.1.8
> > config:    https://ci.syzbot.org/builds/1de646dd-4ee2-418d-9c62-617d88e=
d4fd2/config
> > syz repro: https://ci.syzbot.org/findings/e229a878-375f-4286-89fe-b6724=
c23addd/syz_repro
> >
> > ------------[ cut here ]------------
> > WARNING: io_uring/io_uring.h:127 at io_ring_ctx_lock io_uring/io_uring.=
h:127 [inline], CPU#1: iou-sqp-6294/6297
> > WARNING: io_uring/io_uring.h:127 at io_handle_tw_list+0x234/0x2e0 io_ur=
ing/io_uring.c:1155, CPU#1: iou-sqp-6294/6297
> > Modules linked in:
> > CPU: 1 UID: 0 PID: 6297 Comm: iou-sqp-6294 Not tainted syzkaller #0 PRE=
EMPT(full)
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-=
1.16.2-1 04/01/2014
> > RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:127 [inline]
> > RIP: 0010:io_handle_tw_list+0x234/0x2e0 io_uring/io_uring.c:1155
> > Code: 00 00 48 c7 c7 e0 90 02 8c be 8e 04 00 00 31 d2 e8 01 e5 d2 fc 2e=
 2e 2e 31 c0 45 31 e4 4d 85 ff 75 89 eb 7c e8 ad fb 00 fd 90 <0f> 0b 90 e9 =
cf fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 22 ff
> > RSP: 0018:ffffc900032cf938 EFLAGS: 00010293
> > RAX: ffffffff84bfcba3 RBX: dffffc0000000000 RCX: ffff888107f61cc0
> > RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
> > RBP: ffff8881119a8008 R08: ffff888110bb69c7 R09: 1ffff11022176d38
> > R10: dffffc0000000000 R11: ffffed1022176d39 R12: ffff8881119a8000
> > R13: ffff888108441e90 R14: ffff888107f61cc0 R15: 0000000000000000
> > FS:  00007f81f25716c0(0000) GS:ffff8881a39f5000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000001b31b63fff CR3: 000000010f24c000 CR4: 00000000000006f0
> > Call Trace:
> >  <TASK>
> >  tctx_task_work_run+0x99/0x370 io_uring/io_uring.c:1223
> >  io_sq_tw io_uring/sqpoll.c:244 [inline]
> >  io_sq_thread+0xed1/0x1e50 io_uring/sqpoll.c:327
> >  ret_from_fork+0x47f/0x820 arch/x86/kernel/process.c:148
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >  </TASK>
>
> Probably the sanest thing to do here is to clear
> IORING_SETUP_SINGLE_ISSUER if it's set with IORING_SETUP_SQPOLL. If we
> allow it, it'll be impossible to uphold the locking criteria on both the
> issue and register side.

Yup, I was thinking the same thing. Thanks for taking a look.

Best,
Caleb

