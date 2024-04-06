Return-Path: <io-uring+bounces-1421-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45F2A89A85F
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 04:08:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C71D71F21465
	for <lists+io-uring@lfdr.de>; Sat,  6 Apr 2024 02:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D90C8E1;
	Sat,  6 Apr 2024 02:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="V02ZmSBn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3522125C1
	for <io-uring@vger.kernel.org>; Sat,  6 Apr 2024 02:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712369318; cv=none; b=C35KlYGVcxEY6Cvoo7ae7yDzZusSwaUzOF5IafhTD55KhNRpclTNvTGnqcMqOKrzZre1pZAX2Rxkjg/UaA8QrNN7U94nH8HH1bSJqSiP0A+t0bWa6+fKqxeuZxn2r+DYrfoXBtc57VB2ciw7IWYX1JGWNHdaBIevlEPmkL5PBOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712369318; c=relaxed/simple;
	bh=d7FdW0cChXkers0Ly6h3Ru1sqGHkUlsgC3zHpZhjtnQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SinOSp08b+XSEHr7qfnwyvKrCiIXPFJyGbuWTbspm4rDw6Brfvvmc4AZQBcQSRGEhw2eUdcH0/CKNTQpwqCzF5byTWxCkzE368RSP0IwVfNrbaeHQTWmxqZn8rpJ391RGtTXKI5WZaKDYCrFpaDTzdinpCUeGNp2OnpXA7HcOMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=V02ZmSBn; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7d0772bb5ffso58330939f.0
        for <io-uring@vger.kernel.org>; Fri, 05 Apr 2024 19:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712369316; x=1712974116; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nYKTkqHvc8Ys+nmrGU0gFzd6wHz9klsx6WKRernNS5I=;
        b=V02ZmSBnXmMuwnwfrdtaLeXiDfs+e+2Efv7S84s4KGqNkOSZRxNVnYzroYDID6sg+M
         qkGRnJ23H0tbsgwxJlwr/gOngzEeo27dgCYcaw6+4RYud82KX3f9WzXnBuOvo6U+afat
         bdZVYwTEbhmCVs+jJ5iHX/2qJYqFa5Jvk6bZtpPl8qXT6u3Rw649LfL7ngaZvqZ7lupV
         SXuxdrcKahqPmqbC/QAvVTj0Y2Yq+BrnYaksYRAB8c/RiEbhjZ64q5Q40bZw9pkXwhBO
         NMyt0/T7H0NNJ6J0udahlN7YfKI7buBwbv8c8th/dpHnY93laKiNe3I3Ki8tCVCwMSlS
         0+dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712369316; x=1712974116;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nYKTkqHvc8Ys+nmrGU0gFzd6wHz9klsx6WKRernNS5I=;
        b=YUXWDZDIBP3ThmoUx/dS5P72RB/U6/vO18UIVtjyZPUJxktwbMlfBw10JBeXWmBdxj
         WZKwx3tspP+tpvzj0yoFYhtxTIhogaTU2IxpCk1c3WtTXgmDyPCFLhcUlTmCaX/K/WGZ
         PYjv8C6BuN4DfdfB0gGdS2O0LtMlK5xMaMLB30Judbec2Gs56lIPdkA/XCPeRe2OwtNg
         IeUxBbqTG2JonI88YcIpKFmr8Rsq2SeNGY8ip04wutb7ffJZLtGW+TEigax/s0rELh1C
         ZA+YrwSB7pxdPpL24SzgB2vjywa2jfeSrl09xgQ6csnU/Q3WJ9wN90/SSyY6TMT/SgKy
         G3zQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpViLUlIicPkwLSGEsbi9FPA6X2C9dtRq3ezfYISrz5Y+KfA7jeCQkCXOtGB6tB7mJMe5kC7Hcx//JJnHnM629hfajBRB3LB4=
X-Gm-Message-State: AOJu0Yx0UDcwnYE2uEs82wlqTX+NTopwxiqozX2yNvvaYCLNZt1pIGyi
	s4OnD09Ld1cfRW/eyOw3LmQsL2cMQvFL7jIhTW7VttgQkjHtOMmOn+aOuoNLpxg=
X-Google-Smtp-Source: AGHT+IHZHLGrMcEzuosPHOQk2LGMsPJ6mSf8fFEAKF6TE8/7PDk0OPldALllg0DB5KFGOHLrU/hhog==
X-Received: by 2002:a92:db11:0:b0:369:f047:19db with SMTP id b17-20020a92db11000000b00369f04719dbmr2967110iln.2.1712369315672;
        Fri, 05 Apr 2024 19:08:35 -0700 (PDT)
Received: from [172.19.0.169] ([99.196.135.167])
        by smtp.gmail.com with ESMTPSA id s5-20020a92cb05000000b0036a0e23db86sm612548ilo.33.2024.04.05.19.08.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 19:08:35 -0700 (PDT)
Message-ID: <1cfa6085-edc6-41cf-a922-684303a1d574@kernel.dk>
Date: Fri, 5 Apr 2024 20:08:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] kernel BUG in __io_remove_buffers
Content-Language: en-US
To: syzbot <syzbot+beb5226eef6218124e9d@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <0000000000008536790615393938@google.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0000000000008536790615393938@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/3/24 5:03 PM, syzbot wrote:
> Hello,
> 
> syzbot tried to test the proposed patch but the build/boot failed:
> 
> perboard
> [    7.926982][    T1] usbcore: registered new interface driver dln2
> [    7.928671][    T1] usbcore: registered new interface driver pn533_usb
> [    7.935981][    T1] nfcsim 0.2 initialized
> [    7.937582][    T1] usbcore: registered new interface driver port100
> [    7.939440][    T1] usbcore: registered new interface driver nfcmrvl
> [    7.947210][    T1] Loading iSCSI transport class v2.0-870.
> [    7.968081][    T1] virtio_scsi virtio0: 1/0/0 default/read/poll queues
> [    7.978141][    T1] ------------[ cut here ]------------
> [    7.979719][    T1] refcount_t: decrement hit 0; leaking memory.
> [    7.981758][    T1] WARNING: CPU: 0 PID: 1 at lib/refcount.c:31 refcount_warn_saturate+0xfa/0x1d0
> [    7.984304][    T1] Modules linked in:
> [    7.985206][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.9.0-rc2-syzkaller-00062-g25d658afbb9f #0
> [    7.987566][    T1] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
> [    7.989580][    T1] RIP: 0010:refcount_warn_saturate+0xfa/0x1d0
> [    7.991289][    T1] Code: b2 00 00 00 e8 67 f3 e9 fc 5b 5d c3 cc cc cc cc e8 5b f3 e9 fc c6 05 73 24 e8 0a 01 90 48 c7 c7 40 34 1f 8c e8 67 8e ac fc 90 <0f> 0b 90 90 eb d9 e8 3b f3 e9 fc c6 05 50 24 e8 0a 01 90 48 c7 c7
> [    7.995319][    T1] RSP: 0000:ffffc90000066e18 EFLAGS: 00010246
> [    7.996425][    T1] RAX: 4d5c6abb0d962900 RBX: ffff8880215f782c RCX: ffff8880166d0000
> [    7.998305][    T1] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [    7.999479][    T1] RBP: 0000000000000004 R08: ffffffff8157ffc2 R09: fffffbfff1c39af8
> [    8.001772][    T1] R10: dffffc0000000000 R11: fffffbfff1c39af8 R12: ffffea000502cdc0
> [    8.004141][    T1] R13: ffffea000502cdc8 R14: 1ffffd4000a059b9 R15: 0000000000000000
> [    8.006063][    T1] FS:  0000000000000000(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
> [    8.007727][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    8.009976][    T1] CR2: ffff88823ffff000 CR3: 000000000e134000 CR4: 00000000003506f0
> [    8.011700][    T1] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    8.013384][    T1] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [    8.015782][    T1] Call Trace:
> [    8.016883][    T1]  <TASK>
> [    8.017827][    T1]  ? __warn+0x163/0x4e0
> [    8.019345][    T1]  ? refcount_warn_saturate+0xfa/0x1d0
> [    8.021058][    T1]  ? report_bug+0x2b3/0x500
> [    8.022280][    T1]  ? refcount_warn_saturate+0xfa/0x1d0
> [    8.024027][    T1]  ? handle_bug+0x3e/0x70
> [    8.025284][    T1]  ? exc_invalid_op+0x1a/0x50
> [    8.026551][    T1]  ? asm_exc_invalid_op+0x1a/0x20
> [    8.027878][    T1]  ? __warn_printk+0x292/0x360
> [    8.029272][    T1]  ? refcount_warn_saturate+0xfa/0x1d0
> [    8.030730][    T1]  ? refcount_warn_saturate+0xf9/0x1d0
> [    8.032217][    T1]  __free_pages_ok+0xc60/0xd90
> [    8.033265][    T1]  make_alloc_exact+0xa3/0xf0
> [    8.034312][    T1]  vring_alloc_queue_split+0x20a/0x600
> [    8.035607][    T1]  ? __pfx_vring_alloc_queue_split+0x10/0x10
> [    8.036997][    T1]  ? vp_find_vqs+0x4c/0x4e0
> [    8.038142][    T1]  ? virtscsi_probe+0x3ea/0xf60
> [    8.039207][    T1]  ? virtio_dev_probe+0x991/0xaf0
> [    8.040304][    T1]  ? really_probe+0x2b8/0xad0
> [    8.041140][    T1]  ? driver_probe_device+0x50/0x430
> [    8.042068][    T1]  vring_create_virtqueue_split+0xc6/0x310
> [    8.042973][    T1]  ? ret_from_fork+0x4b/0x80
> [    8.044035][    T1]  ? __pfx_vring_create_virtqueue_split+0x10/0x10
> [    8.045362][    T1]  vring_create_virtqueue+0xca/0x110
> [    8.046384][    T1]  ? __pfx_vp_notify+0x10/0x10
> [    8.047405][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
> [    8.048436][    T1]  setup_vq+0xe9/0x2d0
> [    8.049363][    T1]  ? __pfx_vp_notify+0x10/0x10
> [    8.050238][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
> [    8.051200][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
> [    8.053099][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
> [    8.054362][    T1]  vp_setup_vq+0xbf/0x330
> [    8.055098][    T1]  ? __pfx_vp_config_changed+0x10/0x10
> [    8.056155][    T1]  ? ioread16+0x2f/0x90
> [    8.057127][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
> [    8.057929][    T1]  vp_find_vqs_msix+0x8b2/0xc80
> [    8.058857][    T1]  vp_find_vqs+0x4c/0x4e0
> [    8.059767][    T1]  virtscsi_init+0x8db/0xd00
> [    8.060631][    T1]  ? __pfx_virtscsi_init+0x10/0x10
> [    8.061568][    T1]  ? __pfx_default_calc_sets+0x10/0x10
> [    8.062509][    T1]  ? scsi_host_alloc+0xa57/0xea0
> [    8.063697][    T1]  ? vp_get+0xfd/0x140
> [    8.064484][    T1]  virtscsi_probe+0x3ea/0xf60
> [    8.065484][    T1]  ? __pfx_virtscsi_probe+0x10/0x10
> [    8.066504][    T1]  ? kernfs_add_one+0x156/0x8b0
> [    8.067579][    T1]  ? virtio_no_restricted_mem_acc+0x9/0x10
> [    8.069445][    T1]  ? virtio_features_ok+0x10c/0x270
> [    8.070687][    T1]  virtio_dev_probe+0x991/0xaf0
> [    8.071903][    T1]  ? __pfx_virtio_dev_probe+0x10/0x10
> [    8.073120][    T1]  really_probe+0x2b8/0xad0
> [    8.074086][    T1]  __driver_probe_device+0x1a2/0x390
> [    8.075198][    T1]  driver_probe_device+0x50/0x430
> [    8.076215][    T1]  __driver_attach+0x45f/0x710
> [    8.077779][    T1]  ? __pfx___driver_attach+0x10/0x10
> [    8.078838][    T1]  bus_for_each_dev+0x239/0x2b0
> [    8.080219][    T1]  ? __pfx___driver_attach+0x10/0x10
> [    8.081427][    T1]  ? __pfx_bus_for_each_dev+0x10/0x10
> [    8.082648][    T1]  ? do_raw_spin_unlock+0x13c/0x8b0
> [    8.084332][    T1]  bus_add_driver+0x347/0x620
> [    8.085542][    T1]  driver_register+0x23a/0x320
> [    8.086355][    T1]  ? __pfx_virtio_scsi_init+0x10/0x10
> [    8.087517][    T1]  virtio_scsi_init+0x65/0xe0
> [    8.088253][    T1]  ? __pfx_virtio_scsi_init+0x10/0x10
> [    8.089537][    T1]  do_one_initcall+0x248/0x880
> [    8.090403][    T1]  ? __pfx_virtio_scsi_init+0x10/0x10
> [    8.091597][    T1]  ? __pfx_lockdep_hardirqs_on_prepare+0x10/0x10
> [    8.093212][    T1]  ? __pfx_do_one_initcall+0x10/0x10
> [    8.094289][    T1]  ? __pfx_parse_args+0x10/0x10
> [    8.095147][    T1]  ? do_initcalls+0x1c/0x80
> [    8.096320][    T1]  ? rcu_is_watching+0x15/0xb0
> [    8.097696][    T1]  do_initcall_level+0x157/0x210
> [    8.098851][    T1]  do_initcalls+0x3f/0x80
> [    8.099669][    T1]  kernel_init_freeable+0x435/0x5d0
> [    8.100419][    T1]  ? __pfx_kernel_init_freeable+0x10/0x10
> [    8.101767][    T1]  ? __pfx_lockdep_hardirqs_on_prepare+0x10/0x10
> [    8.103417][    T1]  ? __pfx_kernel_init+0x10/0x10
> [    8.104551][    T1]  ? __pfx_kernel_init+0x10/0x10
> [    8.105480][    T1]  ? __pfx_kernel_init+0x10/0x10
> [    8.106672][    T1]  kernel_init+0x1d/0x2b0
> [    8.107961][    T1]  ret_from_fork+0x4b/0x80
> [    8.108943][    T1]  ? __pfx_kernel_init+0x10/0x10
> [    8.109758][    T1]  ret_from_fork_asm+0x1a/0x30
> [    8.111216][    T1]  </TASK>
> [    8.111818][    T1] Kernel panic - not syncing: kernel: panic_on_warn set ...
> [    8.113547][    T1] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.9.0-rc2-syzkaller-00062-g25d658afbb9f #0
> [    8.114525][    T1] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
> [    8.114525][    T1] Call Trace:
> [    8.114525][    T1]  <TASK>
> [    8.114525][    T1]  dump_stack_lvl+0x241/0x360
> [    8.114525][    T1]  ? __pfx_dump_stack_lvl+0x10/0x10
> [    8.114525][    T1]  ? __pfx__printk+0x10/0x10
> [    8.114525][    T1]  ? _printk+0xd5/0x120
> [    8.114525][    T1]  ? vscnprintf+0x5d/0x90
> [    8.114525][    T1]  panic+0x349/0x860
> [    8.124011][    T1]  ? __warn+0x172/0x4e0
> [    8.124011][    T1]  ? __pfx_panic+0x10/0x10
> [    8.124011][    T1]  ? show_trace_log_lvl+0x4e6/0x520
> [    8.124011][    T1]  ? ret_from_fork_asm+0x1a/0x30
> [    8.124011][    T1]  __warn+0x346/0x4e0
> [    8.124011][    T1]  ? refcount_warn_saturate+0xfa/0x1d0
> [    8.124011][    T1]  report_bug+0x2b3/0x500
> [    8.124011][    T1]  ? refcount_warn_saturate+0xfa/0x1d0
> [    8.124011][    T1]  handle_bug+0x3e/0x70
> [    8.133902][    T1]  exc_invalid_op+0x1a/0x50
> [    8.133902][    T1]  asm_exc_invalid_op+0x1a/0x20
> [    8.133902][    T1] RIP: 0010:refcount_warn_saturate+0xfa/0x1d0
> [    8.133902][    T1] Code: b2 00 00 00 e8 67 f3 e9 fc 5b 5d c3 cc cc cc cc e8 5b f3 e9 fc c6 05 73 24 e8 0a 01 90 48 c7 c7 40 34 1f 8c e8 67 8e ac fc 90 <0f> 0b 90 90 eb d9 e8 3b f3 e9 fc c6 05 50 24 e8 0a 01 90 48 c7 c7
> [    8.133902][    T1] RSP: 0000:ffffc90000066e18 EFLAGS: 00010246
> [    8.133902][    T1] RAX: 4d5c6abb0d962900 RBX: ffff8880215f782c RCX: ffff8880166d0000
> [    8.143997][    T1] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [    8.143997][    T1] RBP: 0000000000000004 R08: ffffffff8157ffc2 R09: fffffbfff1c39af8
> [    8.143997][    T1] R10: dffffc0000000000 R11: fffffbfff1c39af8 R12: ffffea000502cdc0
> [    8.143997][    T1] R13: ffffea000502cdc8 R14: 1ffffd4000a059b9 R15: 0000000000000000
> [    8.143997][    T1]  ? __warn_printk+0x292/0x360
> [    8.143997][    T1]  ? refcount_warn_saturate+0xf9/0x1d0
> [    8.143997][    T1]  __free_pages_ok+0xc60/0xd90
> [    8.143997][    T1]  make_alloc_exact+0xa3/0xf0
> [    8.153906][    T1]  vring_alloc_queue_split+0x20a/0x600
> [    8.153906][    T1]  ? __pfx_vring_alloc_queue_split+0x10/0x10
> [    8.153906][    T1]  ? vp_find_vqs+0x4c/0x4e0
> [    8.153906][    T1]  ? virtscsi_probe+0x3ea/0xf60
> [    8.153906][    T1]  ? virtio_dev_probe+0x991/0xaf0
> [    8.153906][    T1]  ? really_probe+0x2b8/0xad0
> [    8.153906][    T1]  ? driver_probe_device+0x50/0x430
> [    8.153906][    T1]  vring_create_virtqueue_split+0xc6/0x310
> [    8.153906][    T1]  ? ret_from_fork+0x4b/0x80
> [    8.153906][    T1]  ? __pfx_vring_create_virtqueue_split+0x10/0x10
> [    8.163970][    T1]  vring_create_virtqueue+0xca/0x110
> [    8.163970][    T1]  ? __pfx_vp_notify+0x10/0x10
> [    8.163970][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
> [    8.163970][    T1]  setup_vq+0xe9/0x2d0
> [    8.163970][    T1]  ? __pfx_vp_notify+0x10/0x10
> [    8.163970][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
> [    8.163970][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
> [    8.163970][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
> [    8.173902][    T1]  vp_setup_vq+0xbf/0x330
> [    8.173902][    T1]  ? __pfx_vp_config_changed+0x10/0x10
> [    8.173902][    T1]  ? ioread16+0x2f/0x90
> [    8.173902][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
> [    8.173902][    T1]  vp_find_vqs_msix+0x8b2/0xc80
> [    8.173902][    T1]  vp_find_vqs+0x4c/0x4e0
> [    8.173902][    T1]  virtscsi_init+0x8db/0xd00
> [    8.173902][    T1]  ? __pfx_virtscsi_init+0x10/0x10
> [    8.173902][    T1]  ? __pfx_default_calc_sets+0x10/0x10
> [    8.183960][    T1]  ? scsi_host_alloc+0xa57/0xea0
> [    8.183960][    T1]  ? vp_get+0xfd/0x140
> [    8.183960][    T1]  virtscsi_probe+0x3ea/0xf60
> [    8.183960][    T1]  ? __pfx_virtscsi_probe+0x10/0x10
> [    8.183960][    T1]  ? kernfs_add_one+0x156/0x8b0
> [    8.183960][    T1]  ? virtio_no_restricted_mem_acc+0x9/0x10
> [    8.183960][    T1]  ? virtio_features_ok+0x10c/0x270
> [    8.193962][    T1]  virtio_dev_probe+0x991/0xaf0
> [    8.193962][    T1]  ? __pfx_virtio_dev_probe+0x10/0x10
> [    8.193962][    T1]  really_probe+0x2b8/0xad0
> [    8.193962][    T1]  __driver_probe_device+0x1a2/0x390
> [    8.193962][    T1]  driver_probe_device+0x50/0x430
> [    8.193962][    T1]  __driver_attach+0x45f/0x710
> [    8.193962][    T1]  ? __pfx___driver_attach+0x10/0x10
> [    8.193962][    T1]  bus_for_each_dev+0x239/0x2b0
> [    8.204004][    T1]  ? __pfx___driver_attach+0x10/0x10
> [    8.204004][    T1]  ? __pfx_bus_for_each_dev+0x10/0x10
> [    8.204004][    T1]  ? do_raw_spin_unlock+0x13c/0x8b0
> [    8.204004][    T1]  bus_add_driver+0x347/0x620
> [    8.204004][    T1]  driver_register+0x23a/0x320
> [    8.204004][    T1]  ? __pfx_virtio_scsi_init+0x10/0x10
> [    8.204004][    T1]  virtio_scsi_init+0x65/0xe0
> [    8.204004][    T1]  ? __pfx_virtio_scsi_init+0x10/0x10
> [    8.213923][    T1]  do_one_initcall+0x248/0x880
> [    8.213923][    T1]  ? __pfx_virtio_scsi_init+0x10/0x10
> [    8.213923][    T1]  ? __pfx_lockdep_hardirqs_on_prepare+0x10/0x10
> [    8.213923][    T1]  ? __pfx_do_one_initcall+0x10/0x10
> [    8.213923][    T1]  ? __pfx_parse_args+0x10/0x10
> [    8.213923][    T1]  ? do_initcalls+0x1c/0x80
> [    8.213923][    T1]  ? rcu_is_watching+0x15/0xb0
> [    8.223993][    T1]  do_initcall_level+0x157/0x210
> [    8.223993][    T1]  do_initcalls+0x3f/0x80
> [    8.223993][    T1]  kernel_init_freeable+0x435/0x5d0
> [    8.223993][    T1]  ? __pfx_kernel_init_freeable+0x10/0x10
> [    8.223993][    T1]  ? __pfx_lockdep_hardirqs_on_prepare+0x10/0x10
> [    8.223993][    T1]  ? __pfx_kernel_init+0x10/0x10
> [    8.223993][    T1]  ? __pfx_kernel_init+0x10/0x10
> [    8.233955][    T1]  ? __pfx_kernel_init+0x10/0x10
> [    8.233955][    T1]  kernel_init+0x1d/0x2b0
> [    8.233955][    T1]  ret_from_fork+0x4b/0x80
> [    8.233955][    T1]  ? __pfx_kernel_init+0x10/0x10
> [    8.233955][    T1]  ret_from_fork_asm+0x1a/0x30
> [    8.233955][    T1]  </TASK>
> [    8.233955][    T1] Kernel Offset: disabled
> [    8.233955][    T1] Rebooting in 86400 seconds..

This doesn't look related at all.

-- 
Jens Axboe


