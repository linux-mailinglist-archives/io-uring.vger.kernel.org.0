Return-Path: <io-uring+bounces-1389-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 36BAA897BDB
	for <lists+io-uring@lfdr.de>; Thu,  4 Apr 2024 01:03:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82979B234C7
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 23:03:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A87F15689E;
	Wed,  3 Apr 2024 23:03:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5A815531D
	for <io-uring@vger.kernel.org>; Wed,  3 Apr 2024 23:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712185385; cv=none; b=dAuV4j+vNYbVa69ydyWKYIlAhQhDF8JkEi2yzMi6HEITCNNGlCpWS+UqlUIn8zCaPPHdBSCsQfeCqWdS5J8jSReKySet48mksLewb8yefCcSI2s+QGf3nMdzyjJki7hZUyKO6zLVKpRBIr+QCOzM3SMTBy3DnmYbfza5qLksnkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712185385; c=relaxed/simple;
	bh=EpBk6ZhHyCxqMJw6R/JFXJS9DJTM0aYnNEtGCjXfofg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=a5Ze07mjxcEU5EFElioTyj1jzPHRirgEsPAVujIg1HU8bY5x4tA55dKf9O80eXzkzAeNNYoBv+SQCUvg+VzPdxx88Y8+WqkvuudCTFSEtGla0ACwI/QK8+ruBqJMqqbZqpXfCM7rmP2Hnl3QoN8M3QfFKJ2/lFk6Fw2p0wBekak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7cc7a6a043bso39943239f.0
        for <io-uring@vger.kernel.org>; Wed, 03 Apr 2024 16:03:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712185382; x=1712790182;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JAzBMLpajJMjwGz/1aXWbO7fQSA6q5Ee86/0k68ezFw=;
        b=SMyXQx9bv1/vN9p1h+DHzoT6YmrFeapckvjY4LL3beEDYO8+QwI4u81iyqFpRiaICO
         r4aXw7BYtP31SUjD3YqedY6dB4grdjf/fhqZtPP4X1H9n20GUYX7IrIbJhqQeeQ97FO9
         4WgidfAYpILpcgzpHYcVwFYgPh99rQc0fPdMEEpzT8hzJ6muX/wT6vCwkzHJKwH/xvdq
         jHYg2NFVYuKJFyRD80c8GMwD48hLvui6gQOAxvzJcgYxXVJlQVcLbo9AN1KFWb9t6W6z
         0eOhlApJnatz+12H0t+R20lNPz77JssYG7fqZvtcFjMihZhcLyiq/uGnYOa9xyPlKe+B
         IvUA==
X-Forwarded-Encrypted: i=1; AJvYcCWBh7yISsAdsY75Isx4A6dhUUlEjzl1rwRq+Vg2L0s/5qZ/s+xtiq/yG51VuGPkPwwgHq27ZbrKwMSyR9kIY8Fp8/BAOVn2JAw=
X-Gm-Message-State: AOJu0YyUIF9cQ0odeq61ofPaifJqeqeLgA3rY33h3+7katoSi8Zh3CO3
	WAJxuiclly4DnuK3XczBiCREqgrif74AuXBmst3lktybJHWTtPiJhywKID/dd10//GeRRus2QFv
	lTGsjoiPnRK5cTValWj94bLfzZnCE82R5QhgNo6N09b9MdV2LUU8yu10=
X-Google-Smtp-Source: AGHT+IHnVwYISad/lhQvWMC3ciTnDeZkTIJ5+/dtmwBeCTPLwejhyASO/UxQVyUl8jrqojXdk3tt8HbtzswD/fHGiLMHkNfTj9l2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2dd4:b0:7cc:2522:f5fd with SMTP id
 l20-20020a0566022dd400b007cc2522f5fdmr80455iow.1.1712185382609; Wed, 03 Apr
 2024 16:03:02 -0700 (PDT)
Date: Wed, 03 Apr 2024 16:03:02 -0700
In-Reply-To: <eefce877-ce0e-45e6-b877-a1579c5833b0@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008536790615393938@google.com>
Subject: Re: [syzbot] [io-uring?] kernel BUG in __io_remove_buffers
From: syzbot <syzbot+beb5226eef6218124e9d@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

perboard
[    7.926982][    T1] usbcore: registered new interface driver dln2
[    7.928671][    T1] usbcore: registered new interface driver pn533_usb
[    7.935981][    T1] nfcsim 0.2 initialized
[    7.937582][    T1] usbcore: registered new interface driver port100
[    7.939440][    T1] usbcore: registered new interface driver nfcmrvl
[    7.947210][    T1] Loading iSCSI transport class v2.0-870.
[    7.968081][    T1] virtio_scsi virtio0: 1/0/0 default/read/poll queues
[    7.978141][    T1] ------------[ cut here ]------------
[    7.979719][    T1] refcount_t: decrement hit 0; leaking memory.
[    7.981758][    T1] WARNING: CPU: 0 PID: 1 at lib/refcount.c:31 refcount=
_warn_saturate+0xfa/0x1d0
[    7.984304][    T1] Modules linked in:
[    7.985206][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.9.0-rc2-=
syzkaller-00062-g25d658afbb9f #0
[    7.987566][    T1] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 03/27/2024
[    7.989580][    T1] RIP: 0010:refcount_warn_saturate+0xfa/0x1d0
[    7.991289][    T1] Code: b2 00 00 00 e8 67 f3 e9 fc 5b 5d c3 cc cc cc c=
c e8 5b f3 e9 fc c6 05 73 24 e8 0a 01 90 48 c7 c7 40 34 1f 8c e8 67 8e ac f=
c 90 <0f> 0b 90 90 eb d9 e8 3b f3 e9 fc c6 05 50 24 e8 0a 01 90 48 c7 c7
[    7.995319][    T1] RSP: 0000:ffffc90000066e18 EFLAGS: 00010246
[    7.996425][    T1] RAX: 4d5c6abb0d962900 RBX: ffff8880215f782c RCX: fff=
f8880166d0000
[    7.998305][    T1] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000=
0000000000000
[    7.999479][    T1] RBP: 0000000000000004 R08: ffffffff8157ffc2 R09: fff=
ffbfff1c39af8
[    8.001772][    T1] R10: dffffc0000000000 R11: fffffbfff1c39af8 R12: fff=
fea000502cdc0
[    8.004141][    T1] R13: ffffea000502cdc8 R14: 1ffffd4000a059b9 R15: 000=
0000000000000
[    8.006063][    T1] FS:  0000000000000000(0000) GS:ffff8880b9400000(0000=
) knlGS:0000000000000000
[    8.007727][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    8.009976][    T1] CR2: ffff88823ffff000 CR3: 000000000e134000 CR4: 000=
00000003506f0
[    8.011700][    T1] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
[    8.013384][    T1] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000=
0000000000400
[    8.015782][    T1] Call Trace:
[    8.016883][    T1]  <TASK>
[    8.017827][    T1]  ? __warn+0x163/0x4e0
[    8.019345][    T1]  ? refcount_warn_saturate+0xfa/0x1d0
[    8.021058][    T1]  ? report_bug+0x2b3/0x500
[    8.022280][    T1]  ? refcount_warn_saturate+0xfa/0x1d0
[    8.024027][    T1]  ? handle_bug+0x3e/0x70
[    8.025284][    T1]  ? exc_invalid_op+0x1a/0x50
[    8.026551][    T1]  ? asm_exc_invalid_op+0x1a/0x20
[    8.027878][    T1]  ? __warn_printk+0x292/0x360
[    8.029272][    T1]  ? refcount_warn_saturate+0xfa/0x1d0
[    8.030730][    T1]  ? refcount_warn_saturate+0xf9/0x1d0
[    8.032217][    T1]  __free_pages_ok+0xc60/0xd90
[    8.033265][    T1]  make_alloc_exact+0xa3/0xf0
[    8.034312][    T1]  vring_alloc_queue_split+0x20a/0x600
[    8.035607][    T1]  ? __pfx_vring_alloc_queue_split+0x10/0x10
[    8.036997][    T1]  ? vp_find_vqs+0x4c/0x4e0
[    8.038142][    T1]  ? virtscsi_probe+0x3ea/0xf60
[    8.039207][    T1]  ? virtio_dev_probe+0x991/0xaf0
[    8.040304][    T1]  ? really_probe+0x2b8/0xad0
[    8.041140][    T1]  ? driver_probe_device+0x50/0x430
[    8.042068][    T1]  vring_create_virtqueue_split+0xc6/0x310
[    8.042973][    T1]  ? ret_from_fork+0x4b/0x80
[    8.044035][    T1]  ? __pfx_vring_create_virtqueue_split+0x10/0x10
[    8.045362][    T1]  vring_create_virtqueue+0xca/0x110
[    8.046384][    T1]  ? __pfx_vp_notify+0x10/0x10
[    8.047405][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.048436][    T1]  setup_vq+0xe9/0x2d0
[    8.049363][    T1]  ? __pfx_vp_notify+0x10/0x10
[    8.050238][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.051200][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.053099][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.054362][    T1]  vp_setup_vq+0xbf/0x330
[    8.055098][    T1]  ? __pfx_vp_config_changed+0x10/0x10
[    8.056155][    T1]  ? ioread16+0x2f/0x90
[    8.057127][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.057929][    T1]  vp_find_vqs_msix+0x8b2/0xc80
[    8.058857][    T1]  vp_find_vqs+0x4c/0x4e0
[    8.059767][    T1]  virtscsi_init+0x8db/0xd00
[    8.060631][    T1]  ? __pfx_virtscsi_init+0x10/0x10
[    8.061568][    T1]  ? __pfx_default_calc_sets+0x10/0x10
[    8.062509][    T1]  ? scsi_host_alloc+0xa57/0xea0
[    8.063697][    T1]  ? vp_get+0xfd/0x140
[    8.064484][    T1]  virtscsi_probe+0x3ea/0xf60
[    8.065484][    T1]  ? __pfx_virtscsi_probe+0x10/0x10
[    8.066504][    T1]  ? kernfs_add_one+0x156/0x8b0
[    8.067579][    T1]  ? virtio_no_restricted_mem_acc+0x9/0x10
[    8.069445][    T1]  ? virtio_features_ok+0x10c/0x270
[    8.070687][    T1]  virtio_dev_probe+0x991/0xaf0
[    8.071903][    T1]  ? __pfx_virtio_dev_probe+0x10/0x10
[    8.073120][    T1]  really_probe+0x2b8/0xad0
[    8.074086][    T1]  __driver_probe_device+0x1a2/0x390
[    8.075198][    T1]  driver_probe_device+0x50/0x430
[    8.076215][    T1]  __driver_attach+0x45f/0x710
[    8.077779][    T1]  ? __pfx___driver_attach+0x10/0x10
[    8.078838][    T1]  bus_for_each_dev+0x239/0x2b0
[    8.080219][    T1]  ? __pfx___driver_attach+0x10/0x10
[    8.081427][    T1]  ? __pfx_bus_for_each_dev+0x10/0x10
[    8.082648][    T1]  ? do_raw_spin_unlock+0x13c/0x8b0
[    8.084332][    T1]  bus_add_driver+0x347/0x620
[    8.085542][    T1]  driver_register+0x23a/0x320
[    8.086355][    T1]  ? __pfx_virtio_scsi_init+0x10/0x10
[    8.087517][    T1]  virtio_scsi_init+0x65/0xe0
[    8.088253][    T1]  ? __pfx_virtio_scsi_init+0x10/0x10
[    8.089537][    T1]  do_one_initcall+0x248/0x880
[    8.090403][    T1]  ? __pfx_virtio_scsi_init+0x10/0x10
[    8.091597][    T1]  ? __pfx_lockdep_hardirqs_on_prepare+0x10/0x10
[    8.093212][    T1]  ? __pfx_do_one_initcall+0x10/0x10
[    8.094289][    T1]  ? __pfx_parse_args+0x10/0x10
[    8.095147][    T1]  ? do_initcalls+0x1c/0x80
[    8.096320][    T1]  ? rcu_is_watching+0x15/0xb0
[    8.097696][    T1]  do_initcall_level+0x157/0x210
[    8.098851][    T1]  do_initcalls+0x3f/0x80
[    8.099669][    T1]  kernel_init_freeable+0x435/0x5d0
[    8.100419][    T1]  ? __pfx_kernel_init_freeable+0x10/0x10
[    8.101767][    T1]  ? __pfx_lockdep_hardirqs_on_prepare+0x10/0x10
[    8.103417][    T1]  ? __pfx_kernel_init+0x10/0x10
[    8.104551][    T1]  ? __pfx_kernel_init+0x10/0x10
[    8.105480][    T1]  ? __pfx_kernel_init+0x10/0x10
[    8.106672][    T1]  kernel_init+0x1d/0x2b0
[    8.107961][    T1]  ret_from_fork+0x4b/0x80
[    8.108943][    T1]  ? __pfx_kernel_init+0x10/0x10
[    8.109758][    T1]  ret_from_fork_asm+0x1a/0x30
[    8.111216][    T1]  </TASK>
[    8.111818][    T1] Kernel panic - not syncing: kernel: panic_on_warn se=
t ...
[    8.113547][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.9.0-rc2-=
syzkaller-00062-g25d658afbb9f #0
[    8.114525][    T1] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 03/27/2024
[    8.114525][    T1] Call Trace:
[    8.114525][    T1]  <TASK>
[    8.114525][    T1]  dump_stack_lvl+0x241/0x360
[    8.114525][    T1]  ? __pfx_dump_stack_lvl+0x10/0x10
[    8.114525][    T1]  ? __pfx__printk+0x10/0x10
[    8.114525][    T1]  ? _printk+0xd5/0x120
[    8.114525][    T1]  ? vscnprintf+0x5d/0x90
[    8.114525][    T1]  panic+0x349/0x860
[    8.124011][    T1]  ? __warn+0x172/0x4e0
[    8.124011][    T1]  ? __pfx_panic+0x10/0x10
[    8.124011][    T1]  ? show_trace_log_lvl+0x4e6/0x520
[    8.124011][    T1]  ? ret_from_fork_asm+0x1a/0x30
[    8.124011][    T1]  __warn+0x346/0x4e0
[    8.124011][    T1]  ? refcount_warn_saturate+0xfa/0x1d0
[    8.124011][    T1]  report_bug+0x2b3/0x500
[    8.124011][    T1]  ? refcount_warn_saturate+0xfa/0x1d0
[    8.124011][    T1]  handle_bug+0x3e/0x70
[    8.133902][    T1]  exc_invalid_op+0x1a/0x50
[    8.133902][    T1]  asm_exc_invalid_op+0x1a/0x20
[    8.133902][    T1] RIP: 0010:refcount_warn_saturate+0xfa/0x1d0
[    8.133902][    T1] Code: b2 00 00 00 e8 67 f3 e9 fc 5b 5d c3 cc cc cc c=
c e8 5b f3 e9 fc c6 05 73 24 e8 0a 01 90 48 c7 c7 40 34 1f 8c e8 67 8e ac f=
c 90 <0f> 0b 90 90 eb d9 e8 3b f3 e9 fc c6 05 50 24 e8 0a 01 90 48 c7 c7
[    8.133902][    T1] RSP: 0000:ffffc90000066e18 EFLAGS: 00010246
[    8.133902][    T1] RAX: 4d5c6abb0d962900 RBX: ffff8880215f782c RCX: fff=
f8880166d0000
[    8.143997][    T1] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000=
0000000000000
[    8.143997][    T1] RBP: 0000000000000004 R08: ffffffff8157ffc2 R09: fff=
ffbfff1c39af8
[    8.143997][    T1] R10: dffffc0000000000 R11: fffffbfff1c39af8 R12: fff=
fea000502cdc0
[    8.143997][    T1] R13: ffffea000502cdc8 R14: 1ffffd4000a059b9 R15: 000=
0000000000000
[    8.143997][    T1]  ? __warn_printk+0x292/0x360
[    8.143997][    T1]  ? refcount_warn_saturate+0xf9/0x1d0
[    8.143997][    T1]  __free_pages_ok+0xc60/0xd90
[    8.143997][    T1]  make_alloc_exact+0xa3/0xf0
[    8.153906][    T1]  vring_alloc_queue_split+0x20a/0x600
[    8.153906][    T1]  ? __pfx_vring_alloc_queue_split+0x10/0x10
[    8.153906][    T1]  ? vp_find_vqs+0x4c/0x4e0
[    8.153906][    T1]  ? virtscsi_probe+0x3ea/0xf60
[    8.153906][    T1]  ? virtio_dev_probe+0x991/0xaf0
[    8.153906][    T1]  ? really_probe+0x2b8/0xad0
[    8.153906][    T1]  ? driver_probe_device+0x50/0x430
[    8.153906][    T1]  vring_create_virtqueue_split+0xc6/0x310
[    8.153906][    T1]  ? ret_from_fork+0x4b/0x80
[    8.153906][    T1]  ? __pfx_vring_create_virtqueue_split+0x10/0x10
[    8.163970][    T1]  vring_create_virtqueue+0xca/0x110
[    8.163970][    T1]  ? __pfx_vp_notify+0x10/0x10
[    8.163970][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.163970][    T1]  setup_vq+0xe9/0x2d0
[    8.163970][    T1]  ? __pfx_vp_notify+0x10/0x10
[    8.163970][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.163970][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.163970][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.173902][    T1]  vp_setup_vq+0xbf/0x330
[    8.173902][    T1]  ? __pfx_vp_config_changed+0x10/0x10
[    8.173902][    T1]  ? ioread16+0x2f/0x90
[    8.173902][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.173902][    T1]  vp_find_vqs_msix+0x8b2/0xc80
[    8.173902][    T1]  vp_find_vqs+0x4c/0x4e0
[    8.173902][    T1]  virtscsi_init+0x8db/0xd00
[    8.173902][    T1]  ? __pfx_virtscsi_init+0x10/0x10
[    8.173902][    T1]  ? __pfx_default_calc_sets+0x10/0x10
[    8.183960][    T1]  ? scsi_host_alloc+0xa57/0xea0
[    8.183960][    T1]  ? vp_get+0xfd/0x140
[    8.183960][    T1]  virtscsi_probe+0x3ea/0xf60
[    8.183960][    T1]  ? __pfx_virtscsi_probe+0x10/0x10
[    8.183960][    T1]  ? kernfs_add_one+0x156/0x8b0
[    8.183960][    T1]  ? virtio_no_restricted_mem_acc+0x9/0x10
[    8.183960][    T1]  ? virtio_features_ok+0x10c/0x270
[    8.193962][    T1]  virtio_dev_probe+0x991/0xaf0
[    8.193962][    T1]  ? __pfx_virtio_dev_probe+0x10/0x10
[    8.193962][    T1]  really_probe+0x2b8/0xad0
[    8.193962][    T1]  __driver_probe_device+0x1a2/0x390
[    8.193962][    T1]  driver_probe_device+0x50/0x430
[    8.193962][    T1]  __driver_attach+0x45f/0x710
[    8.193962][    T1]  ? __pfx___driver_attach+0x10/0x10
[    8.193962][    T1]  bus_for_each_dev+0x239/0x2b0
[    8.204004][    T1]  ? __pfx___driver_attach+0x10/0x10
[    8.204004][    T1]  ? __pfx_bus_for_each_dev+0x10/0x10
[    8.204004][    T1]  ? do_raw_spin_unlock+0x13c/0x8b0
[    8.204004][    T1]  bus_add_driver+0x347/0x620
[    8.204004][    T1]  driver_register+0x23a/0x320
[    8.204004][    T1]  ? __pfx_virtio_scsi_init+0x10/0x10
[    8.204004][    T1]  virtio_scsi_init+0x65/0xe0
[    8.204004][    T1]  ? __pfx_virtio_scsi_init+0x10/0x10
[    8.213923][    T1]  do_one_initcall+0x248/0x880
[    8.213923][    T1]  ? __pfx_virtio_scsi_init+0x10/0x10
[    8.213923][    T1]  ? __pfx_lockdep_hardirqs_on_prepare+0x10/0x10
[    8.213923][    T1]  ? __pfx_do_one_initcall+0x10/0x10
[    8.213923][    T1]  ? __pfx_parse_args+0x10/0x10
[    8.213923][    T1]  ? do_initcalls+0x1c/0x80
[    8.213923][    T1]  ? rcu_is_watching+0x15/0xb0
[    8.223993][    T1]  do_initcall_level+0x157/0x210
[    8.223993][    T1]  do_initcalls+0x3f/0x80
[    8.223993][    T1]  kernel_init_freeable+0x435/0x5d0
[    8.223993][    T1]  ? __pfx_kernel_init_freeable+0x10/0x10
[    8.223993][    T1]  ? __pfx_lockdep_hardirqs_on_prepare+0x10/0x10
[    8.223993][    T1]  ? __pfx_kernel_init+0x10/0x10
[    8.223993][    T1]  ? __pfx_kernel_init+0x10/0x10
[    8.233955][    T1]  ? __pfx_kernel_init+0x10/0x10
[    8.233955][    T1]  kernel_init+0x1d/0x2b0
[    8.233955][    T1]  ret_from_fork+0x4b/0x80
[    8.233955][    T1]  ? __pfx_kernel_init+0x10/0x10
[    8.233955][    T1]  ret_from_fork_asm+0x1a/0x30
[    8.233955][    T1]  </TASK>
[    8.233955][    T1] Kernel Offset: disabled
[    8.233955][    T1] Rebooting in 86400 seconds..


syzkaller build log:
go env (err=3D<nil>)
GO111MODULE=3D'auto'
GOARCH=3D'amd64'
GOBIN=3D''
GOCACHE=3D'/syzkaller/.cache/go-build'
GOENV=3D'/syzkaller/.config/go/env'
GOEXE=3D''
GOEXPERIMENT=3D''
GOFLAGS=3D''
GOHOSTARCH=3D'amd64'
GOHOSTOS=3D'linux'
GOINSECURE=3D''
GOMODCACHE=3D'/syzkaller/jobs/linux/gopath/pkg/mod'
GONOPROXY=3D''
GONOSUMDB=3D''
GOOS=3D'linux'
GOPATH=3D'/syzkaller/jobs/linux/gopath'
GOPRIVATE=3D''
GOPROXY=3D'https://proxy.golang.org,direct'
GOROOT=3D'/usr/local/go'
GOSUMDB=3D'sum.golang.org'
GOTMPDIR=3D''
GOTOOLCHAIN=3D'auto'
GOTOOLDIR=3D'/usr/local/go/pkg/tool/linux_amd64'
GOVCS=3D''
GOVERSION=3D'go1.21.4'
GCCGO=3D'gccgo'
GOAMD64=3D'v1'
AR=3D'ar'
CC=3D'gcc'
CXX=3D'g++'
CGO_ENABLED=3D'1'
GOMOD=3D'/syzkaller/jobs/linux/gopath/src/github.com/google/syzkaller/go.mo=
d'
GOWORK=3D''
CGO_CFLAGS=3D'-O2 -g'
CGO_CPPFLAGS=3D''
CGO_CXXFLAGS=3D'-O2 -g'
CGO_FFLAGS=3D'-O2 -g'
CGO_LDFLAGS=3D'-O2 -g'
PKG_CONFIG=3D'pkg-config'
GOGCCFLAGS=3D'-fPIC -m64 -pthread -Wl,--no-gc-sections -fmessage-length=3D0=
 -ffile-prefix-map=3D/tmp/go-build1588439291=3D/tmp/go-build -gno-record-gc=
c-switches'

git status (err=3D<nil>)
HEAD detached at 6baf50694
nothing to commit, working tree clean


tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
go list -f '{{.Stale}}' ./sys/syz-sysgen | grep -q false || go install ./sy=
s/syz-sysgen
make .descriptions
tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
bin/syz-sysgen
touch .descriptions
GOOS=3Dlinux GOARCH=3Damd64 go build "-ldflags=3D-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3D6baf506947ba27ed9ce775cf9351cb0886166083 -X '=
github.com/google/syzkaller/prog.gitRevisionDate=3D20240329-215124'" "-tags=
=3Dsyz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-fuzzer=
 github.com/google/syzkaller/syz-fuzzer
GOOS=3Dlinux GOARCH=3Damd64 go build "-ldflags=3D-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3D6baf506947ba27ed9ce775cf9351cb0886166083 -X '=
github.com/google/syzkaller/prog.gitRevisionDate=3D20240329-215124'" "-tags=
=3Dsyz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-execpr=
og github.com/google/syzkaller/tools/syz-execprog
GOOS=3Dlinux GOARCH=3Damd64 go build "-ldflags=3D-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3D6baf506947ba27ed9ce775cf9351cb0886166083 -X '=
github.com/google/syzkaller/prog.gitRevisionDate=3D20240329-215124'" "-tags=
=3Dsyz_target syz_os_linux syz_arch_amd64 " -o ./bin/linux_amd64/syz-stress=
 github.com/google/syzkaller/tools/syz-stress
mkdir -p ./bin/linux_amd64
gcc -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wfr=
ame-larger-than=3D16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-forma=
t-overflow -Wno-unused-but-set-variable -Wno-unused-command-line-argument -=
static-pie -fpermissive -w -DGOOS_linux=3D1 -DGOARCH_amd64=3D1 \
	-DHOSTGOOS_linux=3D1 -DGIT_REVISION=3D\"6baf506947ba27ed9ce775cf9351cb0886=
166083\"


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=3D102c48de180000


Tested on:

commit:         25d658af io_uring/kbuf: remove dead define
git tree:       git://git.kernel.dk/linux.git for-6.10/io_uring
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D51cdcd4a8f33256=
9
dashboard link: https://syzkaller.appspot.com/bug?extid=3Dbeb5226eef6218124=
e9d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debia=
n) 2.40

Note: no patches were applied.

