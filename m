Return-Path: <io-uring+bounces-8957-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA2F4B264F4
	for <lists+io-uring@lfdr.de>; Thu, 14 Aug 2025 14:05:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C655C2A2B4C
	for <lists+io-uring@lfdr.de>; Thu, 14 Aug 2025 12:05:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE9CF2FC89C;
	Thu, 14 Aug 2025 12:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WdfPffef"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B712EA72D
	for <io-uring@vger.kernel.org>; Thu, 14 Aug 2025 12:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755173110; cv=none; b=VX44dXlJtgFZeCyav+wrObCLvNoHJFd/O7zIBsJ6zGlXywKBpT6jbQVz8boAM//jG+2q7mdNonM0bMxSS23UgqmUpSk8HxzKuNoZbvB04dK+0kXhx2CEn8PB77HuGa/X1gyb66+O/q31JwdUa3Vyy1fP5BTve/yC/UCkIW2qO4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755173110; c=relaxed/simple;
	bh=lk3jW0faW7OReYq7pDapWGe91fd5chxPJdTiD0YhjJc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AnIkZQi7E0ZMoaS3NpkrM7Y1wsWlt+Oe29ksEH1gSvUP9zi6/FZzRYdxTWSY/+16NSMLeZKZnBRQgEN2tEz6cZBMKnPYYVyj/vjRiAFLeDn9x+z5Os5CfiOyIsAuDLowSanAC2LUg4TnGu+jLExrN6wrZ/Xotw2heiDKhn10J80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WdfPffef; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-76e2eb09041so766487b3a.3
        for <io-uring@vger.kernel.org>; Thu, 14 Aug 2025 05:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755173108; x=1755777908; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YbxwOaTxt+VPxH7wGs43dhEneWCWtvKUM9346HZzhbc=;
        b=WdfPffefxUPjalkPAjFUhdbgT5NxTUQoKkZQKBmPJR1lQ8VBsseXBTLbUnox6iXPHD
         d3KbLjUVNa5OgOZdF02DjGtJYQ2gZa21i3gQgE/mk932vrfGA3GSIk+V2ei1pymuAvIC
         zQgGZa/io/edTrZWAJFnxPRsK2/+ymKluW7XbQ5qR4wrlBtsNhXdtf/yZGyISkKGSxyQ
         uN0Y6EyF3Zk8jXqwGGriivXTpMiTBDHaNTHuWE+p7HE9NJIqbr7iwpg7b6v8dxH0UUw2
         K+0B+FpkaSrImzFmGnYS6CPaNhQEzEARwesVH0ctGh7b9xBTa1KXbqNmw4Ur4A+i9sqB
         blkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755173108; x=1755777908;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YbxwOaTxt+VPxH7wGs43dhEneWCWtvKUM9346HZzhbc=;
        b=AI6bEZilX+4qV0ZYnCiWbGw8eqFif3Wr+Sv2Xi7XJCxnhemyEAhZaOMebGLPBMCkYH
         zIj1xjU75+dCS1dWGGAT3Uj4UUGCG5R3vezjtZ1HDUPlgwbvwuBOoSu9MOoBjGZW0lnS
         W62dWCOR2n8zyCEk+xncs1t7shPASU5QDCjpKTc3dXEoANwDIAOxL5+9jnmKAf3B3zfL
         9U9eZ57qf+++/DEvsCOfnlHSV42B/AHnYEtTv6Ccx5EYOGsBFYf3mtQXsBl6ylrTU7KR
         yhyOPynMKrrSXbhWx58TC28cjBbGVYb6jlpmUT/zbBqjHhF2wb/ublY1uT+V3SPwYgks
         wPRA==
X-Forwarded-Encrypted: i=1; AJvYcCWj6DtUijMFAOGGUxabE0LC1p8BO/OCtN9yEH5fsHHiofCYOZVUCEMUnmH/1F9u+qNVQQr/qELuyQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwjviVRD8JR2YKAbwrOsUNYE4a+xY/UPe7Yfgd1uad9FR/4VqEB
	EnOg3XI7DjI5SSigAcLXz3K1MQ7E6R/5FykcuvHhnuqlK8PulHVfVyOykn0qCqJ1l2CELgtSe+Y
	KkF8ii4w/mBYANKNdsUqhJ3pbU9qmQu1URb5o47WN
X-Gm-Gg: ASbGncufrYRwsnwq/UTy7UndApIfahdGa/VYbNdcMNrAqG2SgdoNiWupiOKZsh/a5rt
	8PHa07SqBmEClvkZ7gGQ6mVMD+EANp/y8lTJNhzichqHbG6b1Dvbs4DulXtJWRAh1Jx7o5XmxYQ
	cixfO6M5ZSwLeXHzVR+vPhc+dZFYlKTFf+vHz/dw/NJ1dsXCZXYIyBtZtfUFgdVi5wZsFqqvz6N
	OCx0ghOsbb0fcLDsNwv/d9nQmcWJgo/BaqR8QJAwx09K2bOwuTNvZM=
X-Google-Smtp-Source: AGHT+IELWN7YR5k/Qexa61FDkbtcQO4u3bxP2v28zhnPFg2HZ8xCotv7o4JcAzeGXsKBzlDNPPoEv9ueklQHM3OWnkY=
X-Received: by 2002:a17:903:1ae4:b0:23d:f986:6472 with SMTP id
 d9443c01a7336-24458a65075mr33851945ad.25.1755173108111; Thu, 14 Aug 2025
 05:05:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6880f54c.050a0220.248954.0000.GAE@google.com> <4a32f6c1-8d81-4a51-beed-caf8bc52fcc2@kernel.dk>
In-Reply-To: <4a32f6c1-8d81-4a51-beed-caf8bc52fcc2@kernel.dk>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 14 Aug 2025 14:04:56 +0200
X-Gm-Features: Ac12FXyjw24Ser7OqH_RG52sC2W_8XRTLvzA8fomNCOW3wS5--cm3OoRWMfM6Nk
Message-ID: <CANp29Y56=ekm5UZyW6DgohHNFucYOwe_dYE09qw084wFOBiwzA@mail.gmail.com>
Subject: Re: [syzbot] [input?] [usb?] [io-uring?] INFO: task hung in
 io_wq_put_and_exit (5)
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot <syzbot+e328767eafd849df0a78@syzkaller.appspotmail.com>, 
	io-uring@vger.kernel.org, linux-input@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Wed, Aug 13, 2025 at 4:32=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On Wed, Jul 23, 2025 at 8:44?AM syzbot <syzbot+e328767eafd849df0a78@syzka=
ller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    bf61759db409 Merge tag 'sched_ext-for-6.16-rc6-fixes' o=
f g..
> > git tree:       upstream
> > console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D12b877d4580=
000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D415e83411fe=
fd73f
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3De328767eafd84=
9df0a78
> > compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binu=
tils for Debian) 2.40
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D110b938c5=
80000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1622a38c580=
000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/22c5f1286a72/d=
isk-bf61759d.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/cc79af4d966c/vmli=
nux-bf61759d.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/b2e6d621f424=
/bzImage-bf61759d.xz
> >
> > The issue was bisected to:
> >
> > commit e5598d6ae62626d261b046a2f19347c38681ff51
> > Author: Pavel Begunkov <asml.silence@gmail.com>
> > Date:   Thu Aug 24 22:53:31 2023 +0000
> >
> >     io_uring: compact SQ/CQ heads/tails
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D12c92b82=
580000
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D11c92b82=
580000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D16c92b82580=
000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+e328767eafd849df0a78@syzkaller.appspotmail.com
> > Fixes: e5598d6ae626 ("io_uring: compact SQ/CQ heads/tails")
> >
> > INFO: task syz-executor971:5849 blocked for more than 143 seconds.
> >       Not tainted 6.16.0-rc6-syzkaller-00279-gbf61759db409 #0
> >       Blocked by coredump.
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
> > task:syz-executor971 state:D stack:26488 pid:5849  tgid:5849  ppid:5844=
   task_flags:0x400148 flags:0x00024002
> > Call Trace:
> >  <TASK>
> >  context_switch kernel/sched/core.c:5397 [inline]
> >  __schedule+0x116a/0x5de0 kernel/sched/core.c:6786
> >  __schedule_loop kernel/sched/core.c:6864 [inline]
> >  schedule+0xe7/0x3a0 kernel/sched/core.c:6879
> >  schedule_timeout+0x257/0x290 kernel/time/sleep_timeout.c:75
> >  do_wait_for_common kernel/sched/completion.c:95 [inline]
> >  __wait_for_common+0x2ff/0x4e0 kernel/sched/completion.c:116
> >  io_wq_exit_workers io_uring/io-wq.c:1319 [inline]
> >  io_wq_put_and_exit+0x271/0x8d0 io_uring/io-wq.c:1347
> >  io_uring_clean_tctx+0x10d/0x190 io_uring/tctx.c:203
> >  io_uring_cancel_generic+0x69c/0x9a0 io_uring/io_uring.c:3212
> >  io_uring_files_cancel include/linux/io_uring.h:19 [inline]
> >  do_exit+0x2ce/0x2bd0 kernel/exit.c:911
> >  do_group_exit+0xd3/0x2a0 kernel/exit.c:1105
> >  __do_sys_exit_group kernel/exit.c:1116 [inline]
> >  __se_sys_exit_group kernel/exit.c:1114 [inline]
> >  __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:1114
> >  x64_sys_call+0x1530/0x1730 arch/x86/include/generated/asm/syscalls_64.=
h:232
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7f141ec08e39
> > RSP: 002b:00007ffcd1b0b6e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> > RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f141ec08e39
> > RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> > RBP: 00007f141ec843b0 R08: ffffffffffffffb8 R09: 0000000000000000
> > R10: 000000000000000e R11: 0000000000000246 R12: 00007f141ec843b0
> > R13: 0000000000000000 R14: 00007f141ec880c0 R15: 00007f141ebd7020
> >  </TASK>
> > INFO: task syz-executor971:5850 blocked for more than 143 seconds.
> >       Not tainted 6.16.0-rc6-syzkaller-00279-gbf61759db409 #0
> >       Blocked by coredump.
>
> I took a look at this one, and it's simply waiting on nullb0 timeouts
> that it's flooded the queue with. Since it's flooding the nullb0 device
> which has been configured to time out IO, we'll have a lot of io-wq
> workers that are sitting blocked waiting on making progress. That can
> obviously take a long time, which then in turn triggers the io_uring
> cancelation/exit warning because of that. It all seems to be working as
> it should.
>
> I don't think there's a bug here because of that, the only thing that's
> "stuck" is because each timeout takes 30s to trigger and there are tons
> of them.
>
> #syz invalid

FWIW: if the bug is weird, but syzbot keeps on observing the crashes,
it's better to let it stay open than to close it with "syz invalid".
In this case, syzbot will just reopen the bug as "INFO: task hung in
io_wq_put_and_exit (6)", "INFO: task hung in io_wq_put_and_exit (7)",
and so on.

--=20
Aleksandr

>
> --
> Jens Axboe
>

