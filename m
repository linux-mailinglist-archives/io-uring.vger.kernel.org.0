Return-Path: <io-uring+bounces-11852-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aL7AInb7b2mUUgAAu9opvQ
	(envelope-from <io-uring+bounces-11852-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 23:02:30 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 341074CACE
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 23:02:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id DF922920B45
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 21:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A9C43D4138;
	Tue, 20 Jan 2026 20:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="D10FMc1T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4E73B9612
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 20:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768942459; cv=pass; b=WzeYPoT7XiansNp172wcbOeZ//fAwA/2gNTrBOeSzY2g3QTIoavGmwtTVH89ev/g/Op6KkVWHVHzZsfuUhROXmWxIJbtcn2dqDTurUPXua6lxs+wwsF9PjeQsazxdLc8lbu+LNHmsItiHFJvgLVyfrIN5tBtBLaoiOgZ7MwL/1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768942459; c=relaxed/simple;
	bh=nM/cxUFyVwygDBtOfCstp5vWS8LJLsEadJpBn92lyw4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cEUdpjqMth6oH/Sb6RuAPkuGXyhMrBe6QQ2BZjt3fuM3bNqTq9/fw8eI5hxVy90nmPdX5eV/apxR1woPbC4tc7Gxx01hP6kRnaTDBJjUGR6A+28fHZekbYHQfAWV/OqqqKkQy350wPSiugH8xZmS+F9coPYAjee1uaxLpkZ2t14=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=D10FMc1T; arc=pass smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1233bc11279so374161c88.1
        for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 12:54:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768942455; cv=none;
        d=google.com; s=arc-20240605;
        b=jRaotrMWzBHsvjPm7ooU5DEpgX1LTE4UDPHJ6LQ1yoxWMN6JwVNiiqsk+kfFpyh3il
         bboBs9gaz11HqH0GdNKE06INd04chncILKKNyOGv+roTK4egUIxj7nf0AvF5vdr/0NuN
         DgAN6n29LuIsbRRu5bB5lLxcQrblhw2e8JP7gD3u7yCDH9mOMfpIcMtuKO7Y8+wdVaeC
         WDUpxud37PtAucbEWjA4OVD4pY52syrD8gGY6Q7qiOCIX0DGe/aGiNrOUDPQA8z6nzZt
         TvTr/HXOYKLCaEha3A8pNsK16MsCSdfk4Y3gIzzYetcwi+jQTIh5VTorLFxDBeGaKH2A
         udvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DWPpQ5O7K/e2WYrYoCArv3AZO6TeXU3lY9Gs+T6Odss=;
        fh=SNdaROTEtREfUiyvELzH+GVQBqnPfYJnZsaOeCwAH60=;
        b=O1+VuB7BlfNlQ1js09tO5Fug4TeS/TwDEdA8dwupaGp1YdIjCGgMluld9pc1EqwRXU
         /H607AK9oBS4iBwQMMb+zaX1V0lCgLXB8ih0K8gK7ypmuXeqOuVgKB5VlWgq6SiuFRBO
         ZmkKruEDwFCAAuAb2Nj8OwG+dlIMBKgXJM13Vw3+JHRFV6fbpO5WjUiGNusYROO4ntvw
         jaIc0GdoXA4OUfZ2mRAI0PqstvXRoKEdxln6KzaQcSFK0Z8R0z3PzSwmfBKUhF2MbNZG
         B0wPl+sN/WWqnuIL/vbgqBi3PdRKy10LZYhvGi1BCyV6haiXNG7BxWWNXQ6VR4Q8b+9/
         Ligg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1768942455; x=1769547255; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DWPpQ5O7K/e2WYrYoCArv3AZO6TeXU3lY9Gs+T6Odss=;
        b=D10FMc1TLwtwa6RXFjwyjMeG6vHlSLes293zYEZATjwprGGylgI10gQAbnNq7SoZuk
         rHR1imkvBsQign7oN9c9Y3/uWeqrFCVVZWr8pcPmOqprXsXzZtXy3YJGFjQQYiR1dSs6
         RTn0cB8KB8ZbdtEbY51UOHjT/XMV4Lkra3aW5yEkYZ7P1DAUwPfNkYrfAiTyknjoUWDK
         mFfYcli6W5zvGmGH1MflehY/RZXzU1ncxoXPA8zoXurh9KrQx1uTdVtma5e2/5I6FmIV
         ZGwN9ZwFsrRXknXQPQL6EkW5P70zHthAUtQdrlAQ4d6Kz5gBbolQp1d+vSXm9vReBlMH
         6z3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768942455; x=1769547255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DWPpQ5O7K/e2WYrYoCArv3AZO6TeXU3lY9Gs+T6Odss=;
        b=Jy0eTzFdov2t6g4WobQLPdtQuRTnGYV7aq77+8fwtwGfpMvXEQr3siWnAxUxVP/XRl
         MdzuBOMez2bQlR/CDbAEmvC8Lp61KuLasMcLB6m+z/Uo45WG72ZKuK/Wc9LUTH1XBM81
         y3JSxsLCtXClZFYrjgXXFA7dyz9DE2ErvJ97Lu30g6bwEpq4pGq9sJk/EjGFiSSDUhJX
         1N1n7zdrlc5AHTKbQmTbbggA7a/qOUAZ1HVYeZ81GwwU5vtmbOk1xrXnTiXU7nVMB6ca
         fuM8tyyu0wU/Ly7cMsQnDiz65ahw6plas+sqqP8paxRJ5EecyD3qLwHHGgU5KnTrIY1k
         ZzPQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6Y4T3oPSi+I1e9T3vDIIB62YWTjIUTkdHw82zmcb0ahBEoucRlhcfKDS4rFKuvo5tBTzfY1yI6Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyOIpOPcCNgd6tGGN+NTb6zCny6dbV4hJF6Qg4hgmk7ThBympPz
	RXsR4vmAYUwSYeHr0h/IIA8nzTqL3ZtAecmliic8RtnHQ6hMlhoVAWElFbbXV4B+3C7nKPbL9n+
	w26rNUkHl+yAsIW6navAsWvzdzcC4nyi7zsoefbhy0w==
X-Gm-Gg: AY/fxX4/7N9svzBsSkWllmKiyoaew3vt4eAtV3+geQDi8IA7xycTBoan4Aq9ErnaduL
	ty1NGwktKF7uF1Qhoic02N4LXn7kYj4mLV4cofwIaxj9rwmFe3nY+p0tMkC0RhW83inkZ7FHaUV
	cdsyI4a8d/QV0bBvAOhGmNtxCmlYXYK0KYsKRuSrBG4N7sZ+KcVk9Yg0OuVHrQuEugZvALVDMfA
	5dKofe5pKhBQ0JEIR6krz7ll3KsszognwTK1EeZtSdkgW2wQcYLbQ4UF1hTBG7W6J0nG0vT
X-Received: by 2002:a05:7023:d02:b0:119:e56b:46ba with SMTP id
 a92af1059eb24-1244a7dd744mr5627145c88.4.1768942454919; Tue, 20 Jan 2026
 12:54:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251218024459.1083572-1-csander@purestorage.com>
 <6943b4db.a70a0220.25eec0.0028.GAE@google.com> <CADUfDZq7MK3r6c05CohT0hMowq-gqffGid-eC1cDGKy+4aaS=A@mail.gmail.com>
 <0bc36797-fe4e-46ba-933d-0b3d508ed0dd@kernel.dk>
In-Reply-To: <0bc36797-fe4e-46ba-933d-0b3d508ed0dd@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 20 Jan 2026 12:54:03 -0800
X-Gm-Features: AZwV_Qg1dBnCmYWZDnpEl80cJUsAVJPEFwdlyyx8JVPfq5JP9gaxKy5GFdka7v4
Message-ID: <CADUfDZoSnzyK9KEid+njTyfK6M2VD5V1QTMdS8kMo1EWpTAx7A@mail.gmail.com>
Subject: Re: [syzbot ci] Re: io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot ci <syzbot+ci6d21afd0455de45a@syzkaller.appspotmail.com>, 
	io-uring@vger.kernel.org, joannelkoong@gmail.com, 
	linux-kernel@vger.kernel.org, oliver.sang@intel.com, 
	syzbot@syzkaller.appspotmail.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.46 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[syzkaller.appspotmail.com,vger.kernel.org,gmail.com,intel.com,lists.linux.dev,googlegroups.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-11852-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_POLICY_ALLOW(0.00)[purestorage.com,reject];
	DKIM_TRACE(0.00)[purestorage.com:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	TAGGED_RCPT(0.00)[io-uring,ci6d21afd0455de45a];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,appspotmail.com:email,kernel.dk:email,syzbot.org:url,googlesource.com:url]
X-Rspamd-Queue-Id: 341074CACE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sun, Jan 18, 2026 at 10:34=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 12/22/25 1:19 PM, Caleb Sander Mateos wrote:
> > On Thu, Dec 18, 2025 at 3:01?AM syzbot ci
> > <syzbot+ci6d21afd0455de45a@syzkaller.appspotmail.com> wrote:
> >>
> >> syzbot ci has tested the following series
> >>
> >> [v6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> >> https://lore.kernel.org/all/20251218024459.1083572-1-csander@purestora=
ge.com
> >> * [PATCH v6 1/6] io_uring: use release-acquire ordering for IORING_SET=
UP_R_DISABLED
> >> * [PATCH v6 2/6] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING=
_SETUP_SQPOLL
> >> * [PATCH v6 3/6] io_uring: ensure submitter_task is valid for io_ring_=
ctx's lifetime
> >> * [PATCH v6 4/6] io_uring: use io_ring_submit_lock() in io_iopoll_req_=
issued()
> >> * [PATCH v6 5/6] io_uring: factor out uring_lock helpers
> >> * [PATCH v6 6/6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_IS=
SUER
> >>
> >> and found the following issue:
> >> INFO: task hung in io_wq_put_and_exit
> >>
> >> Full report is available here:
> >> https://ci.syzbot.org/series/21eac721-670b-4f34-9696-66f9b28233ac
> >>
> >> ***
> >>
> >> INFO: task hung in io_wq_put_and_exit
> >>
> >> tree:      torvalds
> >> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/to=
rvalds/linux
> >> base:      d358e5254674b70f34c847715ca509e46eb81e6f
> >> arch:      amd64
> >> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-=
1~exp1~20250708183702.136), Debian LLD 20.1.8
> >> config:    https://ci.syzbot.org/builds/1710cffe-7d78-4489-9aa1-823b8c=
2532ed/config
> >> syz repro: https://ci.syzbot.org/findings/74ae8703-9484-4d82-aa78-84cc=
37dcb1ef/syz_repro
> >>
> >> INFO: task syz.1.18:6046 blocked for more than 143 seconds.
> >>       Not tainted syzkaller #0
> >>       Blocked by coredump.
> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messa=
ge.
> >> task:syz.1.18        state:D stack:25672 pid:6046  tgid:6045  ppid:597=
1   task_flags:0x400548 flags:0x00080004
> >> Call Trace:
> >>  <TASK>
> >>  context_switch kernel/sched/core.c:5256 [inline]
> >>  __schedule+0x14bc/0x5000 kernel/sched/core.c:6863
> >>  __schedule_loop kernel/sched/core.c:6945 [inline]
> >>  schedule+0x165/0x360 kernel/sched/core.c:6960
> >>  schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
> >>  do_wait_for_common kernel/sched/completion.c:100 [inline]
> >>  __wait_for_common kernel/sched/completion.c:121 [inline]
> >>  wait_for_common kernel/sched/completion.c:132 [inline]
> >>  wait_for_completion+0x2bf/0x5d0 kernel/sched/completion.c:153
> >>  io_wq_exit_workers io_uring/io-wq.c:1328 [inline]
> >>  io_wq_put_and_exit+0x316/0x650 io_uring/io-wq.c:1356
> >>  io_uring_clean_tctx+0x11f/0x1a0 io_uring/tctx.c:207
> >>  io_uring_cancel_generic+0x6ca/0x7d0 io_uring/cancel.c:652
> >>  io_uring_files_cancel include/linux/io_uring.h:19 [inline]
> >>  do_exit+0x345/0x2310 kernel/exit.c:911
> >>  do_group_exit+0x21c/0x2d0 kernel/exit.c:1112
> >>  get_signal+0x1285/0x1340 kernel/signal.c:3034
> >>  arch_do_signal_or_restart+0x9a/0x7a0 arch/x86/kernel/signal.c:337
> >>  __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
> >>  exit_to_user_mode_loop+0x87/0x4f0 kernel/entry/common.c:75
> >>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inl=
ine]
> >>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:25=
6 [inline]
> >>  syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inli=
ne]
> >>  syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
> >>  do_syscall_64+0x2e3/0xf80 arch/x86/entry/syscall_64.c:100
> >>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >> RIP: 0033:0x7f6a8b58f7c9
> >> RSP: 002b:00007f6a8c4a00e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> >> RAX: 0000000000000001 RBX: 00007f6a8b7e5fa8 RCX: 00007f6a8b58f7c9
> >> RDX: 00000000000f4240 RSI: 0000000000000081 RDI: 00007f6a8b7e5fac
> >> RBP: 00007f6a8b7e5fa0 R08: 3fffffffffffffff R09: 0000000000000000
> >> R10: 0000000000000800 R11: 0000000000000246 R12: 0000000000000000
> >> R13: 00007f6a8b7e6038 R14: 00007ffcac96d220 R15: 00007ffcac96d308
> >>  </TASK>
> >> INFO: task iou-wrk-6046:6047 blocked for more than 143 seconds.
> >>       Not tainted syzkaller #0
> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messa=
ge.
> >> task:iou-wrk-6046    state:D stack:27760 pid:6047  tgid:6045  ppid:597=
1   task_flags:0x404050 flags:0x00080002
> >> Call Trace:
> >>  <TASK>
> >>  context_switch kernel/sched/core.c:5256 [inline]
> >>  __schedule+0x14bc/0x5000 kernel/sched/core.c:6863
> >>  __schedule_loop kernel/sched/core.c:6945 [inline]
> >>  schedule+0x165/0x360 kernel/sched/core.c:6960
> >>  schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
> >>  do_wait_for_common kernel/sched/completion.c:100 [inline]
> >>  __wait_for_common kernel/sched/completion.c:121 [inline]
> >>  wait_for_common kernel/sched/completion.c:132 [inline]
> >>  wait_for_completion+0x2bf/0x5d0 kernel/sched/completion.c:153
> >>  io_ring_ctx_lock_nested+0x2b3/0x380 io_uring/io_uring.h:283
> >>  io_ring_ctx_lock io_uring/io_uring.h:290 [inline]
> >>  io_ring_submit_lock io_uring/io_uring.h:554 [inline]
> >>  io_files_update+0x677/0x7f0 io_uring/rsrc.c:504
> >>  __io_issue_sqe+0x181/0x4b0 io_uring/io_uring.c:1818
> >>  io_issue_sqe+0x1de/0x1190 io_uring/io_uring.c:1841
> >>  io_wq_submit_work+0x6e9/0xb90 io_uring/io_uring.c:1953
> >>  io_worker_handle_work+0x7cd/0x1180 io_uring/io-wq.c:650
> >>  io_wq_worker+0x42f/0xeb0 io_uring/io-wq.c:704
> >>  ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
> >>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
> >>  </TASK>
> >
> > Interesting, a deadlock between io_wq_exit_workers() on submitter_task
> > (which is exiting) and io_ring_ctx_lock() on an io_uring worker
> > thread. io_ring_ctx_lock() is blocked until submitter_task runs task
> > work, but that will never happen because it's waiting on the
> > completion. Not sure what the best approach is here. Maybe have the
> > submitter_task alternate between running task work and waiting on the
> > completion? Or have some way for submitter_task to indicate that it's
> > exiting and disable the IORING_SETUP_SINGLE_ISSUER optimization in
> > io_ring_ctx_lock()?
>
> Finally got around to taking a look at this patchset today, and it does

Appreciate you taking a look!

> look sound to me. For cases that have zero expected io-wq activity, then
> it seems like a no-brainer. For cases that have a lot of expected io-wq
> activity, which are basically only things like fs/storage workloads on
> suboptimal configurations, the then the suspend/resume mechanism may be
> troublesome. But not quite sure what to do about that, or if it's evne
> noticable?

Yes, this is a good point. I was hoping io_uring worker threads
wouldn't need to acquire the ctx uring lock in most cases, as fixed
buffer and file lookup will likely have already happened during the
initial non-blocking submission. That clearly wouldn't be true for
IOSQE_ASYNC requests, though. And maybe other cases I haven't thought
of?
One possibility would be to introduce a new setup flag
("IORING_SETUP_TRULY_SINGLE_ISSUER" or something) to explicitly opt
into this behavior to avoid regressing any existing applications. Or
we could try to optimize IORING_SETUP_SINGLE_ISSUER + IOSQE_ASYNC to
import any fixed file, fixed buffer, or provided buffer on
submitter_task before punting the request to the worker thread.

>
> For the case in question, yes I think we'll need the completion wait
> cases to break for running task_work.

Thanks for taking a look. Are you thinking something like changing the
wait_for_completion() in io_wq_exit_workers() to
wait_for_completion_interruptible() and call io_run_task_work()
whenever the wait is interrupted?

Thanks,
Caleb

