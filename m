Return-Path: <io-uring+bounces-13896-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id MCK5IyX4S2pXdwEAu9opvQ
	(envelope-from <io-uring+bounces-13896-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 20:47:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 01995714A43
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 20:47:00 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HT3E8Xbg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13896-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13896-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2201C3485CBF
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 17:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E5F7335575;
	Mon,  6 Jul 2026 17:01:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25C32ECD35
	for <io-uring@vger.kernel.org>; Mon,  6 Jul 2026 17:01:25 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783357287; cv=none; b=n8dSMP1szfu5iGpA3UhwZWzfFf+hPQy2C9wCcHoD+AMBgbr5C0hcqBqpwcsY0rUbHUO5txA8S2KaPiLFiqgxc78E5LtBqVF1HRBqNI4scuRMeVR28+A8q/VryO5TF5bSy0XB4QJwkf77O7zTy/uT27ff3ayY0w9n17nIefg/pC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783357287; c=relaxed/simple;
	bh=fl6C3WqBD+77o6KTKIP5Bf2tvII+05KGdHQ9X2vEP/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bwoBCcMCnqFLgOP+fkjA2Qh1l3w8cyr0zLKpSGDdIJaF3VA+Tp3Oz3GmOO+jCLY4/v7RRgw9vQqiSNf6FFt9yiEKUW7izw+o/vlUE3AdO+bUnm1he9RZsnT+25l+/oYFfEfCPpuHx8pxD7IX7wO09szboGvwPnA8W4XgwQ3g8I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HT3E8Xbg; arc=none smtp.client-ip=209.85.210.170
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-845c92bc464so2308966b3a.2
        for <io-uring@vger.kernel.org>; Mon, 06 Jul 2026 10:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783357285; x=1783962085; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CKGOJoysjkqZ0qDPwjq6RPUdhZSCHB0fSSKaiAm7hoU=;
        b=HT3E8XbgjDwPKvZxWNhGY1hTqiP7dD3Vme+RKfqttgHjAeMdgbdePq+yudjn46apPU
         6xDgtNvHjXRkiBNx7ewnWXHh9zyg6Fn5A/UWYR5d1YA50BRpSrPIyMRIZ2CPiEjkq5fL
         k7HmjsWRLl66ApG43M/o+oVfrXJDo9AGGaVT4w2HRr4gRwiZQS6RYXMKfmZ7liH9qdrm
         +zGzQR1dz1g3AWLu6rMGUoxeVpkIec7VAu2HIaPQKnmcHmO9DmmR4rBMSlwea9KNxyY/
         mcU5xjE+Sj+lJiVs5eSizrOde6rjwgOacn/ArilnFZ5P3h00uORIG+p1RBipXVXLYmuQ
         h1cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783357285; x=1783962085;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CKGOJoysjkqZ0qDPwjq6RPUdhZSCHB0fSSKaiAm7hoU=;
        b=hThT9ZpjO+EAKjKiv8VOevVL6UupyjzhSNSiEM7Sa/oAKxgwMpdf8LWXp4OWUz4MFh
         7L9m6SCO6vSYPyYx/qXiEIXjcAUIkuUBYRGibMSkA0AZZTge/6ZWLC4ZkqcQd2WOLm/m
         zthMsjTreScIR4+26KrKfw5uWkK7vxzGVOQ1hhii1bYWmK79nPKfU5jQ1W0X+6bvZ0+/
         2n2K3r+q7wQrp6giCScFZymAUrtc8AI5g+RWPWpV5XJIfKI1Uhvh7TnvCUqS++ZqXyZ9
         eziuf9x+uDdzv0iVTNDQ3EUiurHOCM3ASGd0eKGxcIhAhJm42q4VVDbndNfm4Tgqd2gA
         nXig==
X-Forwarded-Encrypted: i=1; AHgh+RrJE/rAdA8eQ0o2ftV/NWZh220F2DT7FRynADyeVXeC8rRsQJtFT87gmbleiJAkQ58/hUXE28wDpw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9Rzx8N9uL8pxUe/C4DUI7Uy018V9AyUTPq/3mdVm6P8zHkoym
	CAhR3afkYkmm0j75eav4KChpkX8ovk3XDpcVw1snzEn3VK837SB3f7Pq
X-Gm-Gg: AfdE7cks3FgVglvkNyezaa6l8Gf20h5vE245JONc9Ni+ImiQAomDoMye6ISlL0+Ms8k
	f49b0esLVIGnbYEg/o5Bw07005rQ6+wgSDaWVUD5uL1nJPyRWL5pK5lkd02J/OrIYBegXxY07bK
	eht5Oj0VIK+gdhBHoONwj9BaQ8FLV1eE6hSFhJ88DElXc/5whJ0Lre5Eu9M1oXA0FKBUZdA9z9l
	8R+dHk8tN8b6BcBHo90jYbP1tzAGc5qA72Cx/0STq/8CzziA0Mgtt517HWMla2XCZpcZjFvGvrw
	8k6zoI/R6RlgYDqtp+5MxC43Z3CeuzlEmELD4DlLyEW3BCqN+jDTPvz8vmjFGx4gKN1licFJBBO
	GkHUWqo9FFdpsdR6/u1wDbGJZfOSWD++oiV4RRQWaV4o2Uy37EwyD2Zmnq4n37yh2B0IKUHtKsL
	J9i5UiOIdNiKOuSljCDjLJWDCwffuPhQ/WjLxHar4=
X-Received: by 2002:a05:6a00:398f:b0:845:dfef:75b8 with SMTP id d2e1a72fcca58-84826ccee74mr1332526b3a.15.1783357284569;
        Mon, 06 Jul 2026 10:01:24 -0700 (PDT)
Received: from naup-virtual-machine ([140.113.139.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6dddf8bsm4151099b3a.61.2026.07.06.10.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 10:01:24 -0700 (PDT)
Date: Tue, 7 Jul 2026 01:01:20 +0800
From: Hao-Yu Yang <naup96721@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v1] io_uring: fix dangling iovec after provided-buffer
 bundle grow failure
Message-ID: <akvfYLvrpF5104us@naup-virtual-machine>
References: <20260705234534.768138-1-naup96721@gmail.com>
 <0a370728-f8be-4aaa-bbc6-276376adc5ce@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a370728-f8be-4aaa-bbc6-276376adc5ce@kernel.dk>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13896-lists,io-uring=lfdr.de];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[naup96721@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[naup96721@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 01995714A43

Sorry, i forgot to cc others mail

I discovered and wrote the PoC myself. Trigger way is
 send1: Submit an IORING_OP_SEND request with four valid
 provided buffers. The system will allocate and cache an
 iovec array (of size 4) for this request and store the
 pointer in kmsg->vec.iovec.

 send2: Submit a second send request with 8, and I set
 the fourth passed-in address to point to an invalid address.
 Now kmsg still hold old iovec, but old iovec object have
 been freed.

 So this will lead dangling pointer.

I also paste my full KASAN log

[    4.571640] BUG: KASAN: double-free in io_vec_free+0x2c/0x90
[    4.573757] Free of addr ffff888001ec6d80 by task e/73
[    4.575442]
[    4.576047] CPU: 0 UID: 1000 PID: 73 Comm: e Not tainted 7.2.0-rc1-g7404ce516372 #1 PREEMPT(lazy)
[    4.576064] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
[    4.576087] Call Trace:
[    4.576114]  <TASK>
[    4.576116]  dump_stack_lvl+0x55/0x70
[    4.576219]  print_report+0xcb/0x5e0
[    4.576270]  ? io_vec_free+0x2c/0x90
[    4.576273]  ? io_vec_free+0x2c/0x90
[    4.576276]  kasan_report_invalid_free+0x94/0xc0
[    4.576280]  ? io_vec_free+0x2c/0x90
[    4.576283]  ? io_vec_free+0x2c/0x90
[    4.576286]  check_slab_allocation+0xe4/0x110
[    4.576289]  kfree+0x104/0x3b0
[    4.576308]  io_vec_free+0x2c/0x90
[    4.576312]  __io_submit_flush_completions+0xc03/0x1e40
[    4.576337]  ? io_issue_sqe+0x7d/0x14a0
[    4.576341]  io_submit_sqes+0xdb5/0x2310
[    4.576344]  ? __pfx_mutex_lock+0x10/0x10
[    4.576355]  __do_sys_io_uring_enter+0x701/0x11a0
[    4.576359]  ? __pfx___do_sys_io_uring_enter+0x10/0x10
[    4.576362]  ? fdget_pos+0x53/0x4c0
[    4.576410]  ? ksys_write+0xee/0x1c0
[    4.576427]  ? __pfx_ksys_write+0x10/0x10
[    4.576430]  do_syscall_64+0x102/0x5a0
[    4.576448]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[    4.576478] RIP: 0033:0x44895d
[    4.576502] Code: 28 c3 e8 06 20 00 00 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 8
[    4.576508] RSP: 002b:00007ffdfca0f868 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
[    4.576555] RAX: ffffffffffffffda RBX: 00007f615f4a1000 RCX: 000000000044895d
[    4.576558] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000005
[    4.576559] RBP: 00007f615f49e000 R08: 0000000000000000 R09: 0000000000000000
[    4.576561] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000001
[    4.576573] R13: 00007ffdfca0fba8 R14: 00000000004c37d0 R15: 0000000000000001
[    4.576577]  </TASK>
[    4.576578]
[    4.625904] Allocated by task 73:
[    4.626662]  kasan_save_stack+0x24/0x50
[    4.627517]  kasan_save_track+0x14/0x30
[    4.628377]  __kasan_kmalloc+0x7f/0x90
[    4.629375]  __kmalloc_noprof+0x1b6/0x480
[    4.630133]  io_ring_buffers_peek+0x559/0xc60
[    4.631042]  io_buffers_select+0x1c1/0x460
[    4.632035]  io_send+0x770/0x1050
[    4.633444]  __io_issue_sqe+0xaf/0x730
[    4.634590]  io_issue_sqe+0x7d/0x14a0
[    4.636114]  io_submit_sqes+0x973/0x2310
[    4.637050]  __do_sys_io_uring_enter+0x701/0x11a0
[    4.638558]  do_syscall_64+0x102/0x5a0
[    4.639390]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[    4.640670]
[    4.641129] Freed by task 73:
[    4.641788]  kasan_save_stack+0x24/0x50
[    4.642456]  kasan_save_track+0x14/0x30
[    4.642983]  kasan_save_free_info+0x3b/0x60
[    4.643577]  __kasan_slab_free+0x43/0x70
[    4.644099]  kfree+0x127/0x3b0
[    4.645020]  io_ring_buffers_peek+0x71c/0xc60
[    4.646782]  io_buffers_select+0x1c1/0x460
[    4.648101]  io_send+0x770/0x1050
[    4.648861]  __io_issue_sqe+0xaf/0x730
[    4.649727]  io_issue_sqe+0x7d/0x14a0
[    4.650504]  io_submit_sqes+0x973/0x2310
[    4.651469]  __do_sys_io_uring_enter+0x701/0x11a0
[    4.652645]  do_syscall_64+0x102/0x5a0
[    4.653749]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[    4.655244]
[    4.655532] The buggy address belongs to the object at ffff888001ec6d80
[    4.655532]  which belongs to the cache kmalloc-64 of size 64
[    4.658285] The buggy address is located 0 bytes inside of
[    4.658285]  64-byte region [ffff888001ec6d80, ffff888001ec6dc0)
[    4.660820]
[    4.661276] The buggy address belongs to the physical page:
[    4.663970] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1ec6
[    4.666110] flags: 0x100000000000000(node=0|zone=1)
[    4.667589] page_type: f5(slab)
[    4.668475] raw: 0100000000000000 ffff8880010418c0 dead000000000100 dead000000000122
[    4.670353] raw: 0000000000000000 0000000000200020 00000000f5000000 0000000000000000
[    4.672192] page dumped because: kasan: bad access detected
[    4.673144]
[    4.673599] Memory state around the buggy address:
[    4.675006]  ffff888001ec6c80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
[    4.677516]  ffff888001ec6d00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
[    4.679495] >ffff888001ec6d80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
[    4.680794]                    ^
[    4.681362]  ffff888001ec6e00: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
[    4.682527]  ffff888001ec6e80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
[    4.684246] ==================================================================
[    4.685963] Kernel panic - not syncing: KASAN: panic_on_warn set ...
[    4.687476] CPU: 0 UID: 1000 PID: 73 Comm: e Not tainted 7.2.0-rc1-g7404ce516372 #1 PREEMPT(lazy)
[    4.689533] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
[    4.691507] Call Trace:
[    4.692161]  <TASK>
[    4.692802]  vpanic+0x504/0x700
[    4.693724]  ? __pfx_vpanic+0x10/0x10
[    4.694559]  ? __pfx_vprintk_emit+0x10/0x10
[    4.696838]  ? io_vec_free+0x2c/0x90
[    4.697672]  panic+0xbd/0xc0
[    4.698335]  ? __pfx_panic+0x10/0x10
[    4.699117]  ? panic_on_this_cpu+0x15/0x30
[    4.700001]  check_panic_on_warn+0x61/0x80
[    4.700745]  end_report+0xba/0xe0
[    4.701371]  ? io_vec_free+0x2c/0x90
[    4.702265]  kasan_report_invalid_free+0xa4/0xc0
[    4.703239]  ? io_vec_free+0x2c/0x90
[    4.704064]  ? io_vec_free+0x2c/0x90
[    4.704818]  check_slab_allocation+0xe4/0x110
[    4.706513]  kfree+0x104/0x3b0
[    4.707744]  io_vec_free+0x2c/0x90
[    4.709009]  __io_submit_flush_completions+0xc03/0x1e40
[    4.709740]  ? io_issue_sqe+0x7d/0x14a0
[    4.710366]  io_submit_sqes+0xdb5/0x2310
[    4.711531]  ? __pfx_mutex_lock+0x10/0x10
[    4.712488]  __do_sys_io_uring_enter+0x701/0x11a0
[    4.713771]  ? __pfx___do_sys_io_uring_enter+0x10/0x10
[    4.715081]  ? fdget_pos+0x53/0x4c0
[    4.715804]  ? ksys_write+0xee/0x1c0
[    4.716247]  ? __pfx_ksys_write+0x10/0x10
[    4.717130]  do_syscall_64+0x102/0x5a0
[    4.717942]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[    4.718930] RIP: 0033:0x44895d
[    4.719488] Code: 28 c3 e8 06 20 00 00 66 0f 1f 44 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 8
[    4.723727] RSP: 002b:00007ffdfca0f868 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
[    4.726144] RAX: ffffffffffffffda RBX: 00007f615f4a1000 RCX: 000000000044895d
[    4.727793] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000005
[    4.729366] RBP: 00007f615f49e000 R08: 0000000000000000 R09: 0000000000000000
[    4.731044] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000001
[    4.733021] R13: 00007ffdfca0fba8 R14: 00000000004c37d0 R15: 0000000000000001
[    4.734422]  </TASK>
[    4.735635] Kernel Offset: 0xb200000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

On Mon, Jul 06, 2026 at 10:20:36AM -0600, Jens Axboe wrote:
> On 7/5/26 5:45 PM, Hao-Yu Yang wrote:
> > BUG: KASAN: double-free in io_vec_free+0x2c/0x90
> > Freed by task 73:
> >  kfree+0x104/0x3b0
> >  io_vec_free+0x2c/0x90
> >  __io_submit_flush_completions+0xc03/0x1e40
> >  io_submit_sqes+0xdb5/0x2310
> > 
> > Allocated by task 73:
> >  io_ring_buffers_peek+0x559/0xc60
> >  io_buffers_select+0x1c1/0x460
> >  io_send+0x770/0x1050
> 
> Please also send your reproducer, the above looks a bit synthesized
> rather than a real trace... Is it actually from KASAN, or is it from
> whatever LLM you're using?
> 
> -- 
> Jens Axboe

