Return-Path: <io-uring+bounces-1387-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56E2F8978C6
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 21:06:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11A0128725B
	for <lists+io-uring@lfdr.de>; Wed,  3 Apr 2024 19:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C5B2154BE2;
	Wed,  3 Apr 2024 19:06:07 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1AC154458
	for <io-uring@vger.kernel.org>; Wed,  3 Apr 2024 19:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712171167; cv=none; b=SCAaumCW9EeuLXnxFk/iw1Hctczjjn6iwnAXbpxbF8aKNUKB0HMpU3/d9gp/UPWZy/bkX3Cn63lrXj91LyXC4zU82bZ6mIDLg2QfmNz4LAyY0VgtDWNSzwT1wEUkpPDm+GzmfBkssXsdPtN12qlr8Vy0YXQBw8ep45ut8ByL9To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712171167; c=relaxed/simple;
	bh=VwGyxskK0KqbA7rcHFwFRc7eX5GTf+WW0y8CHqc/ydM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=eKMJhvj9LcUlqawCIlQDYZPsqJe9u+CfoSpAIM6q8gMKI2QJsFn94XOgE35GsJZTikIssQkoZiV7X/LhQ6FdFV3Q3iB+kTJTTuf5thCxHd97Ki15PINDWwiQt3pObF4e1mHX2fkOv72PDCIaK45DLjy0vYFJCY8xpqU/i5sWa7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7cc7a6a04d9so21647139f.3
        for <io-uring@vger.kernel.org>; Wed, 03 Apr 2024 12:06:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712171164; x=1712775964;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lx7pBAczKVli4R8OsMM+s/RIIMHJN0PZzEWNrp4ElYY=;
        b=n7KUgE+awLLR8WVp0XEI6XVvKRFLMYXFvbe1wxn6IsnqLwr1nuCR3aa5lkejpndSMG
         37Ggzz5vm7BZnPk1vKjIQUWecwHbESVTz0YnvkljPa/DrBDVdAVbod9tZUBm7JXmKweT
         zPuzGolVSzgKqgskWnZjd1glQ3dtoPG9aDuSD2hj+r9AzS3geVY3Et2/LYWlil4Xby3P
         yEjRQ7GgETjPhWfymF0pjiC3yU27Kkoi3w6d2eBueTkBV8jTZuY5ZoyyQxwPl2L6juch
         pLUkBNQkAXgjw2ZrwhHziBheJBkWIx5cL9x/ZqZGDohfT2rYNkyjlWeghAtLyr/uA37T
         BhLg==
X-Forwarded-Encrypted: i=1; AJvYcCXMK9wM6M5VHns2gj+KmqDRXM+NzajQ7l1Kh36IFHLzkyXnpTDKBim5oQTpt21EvSUDK7vrd2QDcHRWefprkHbDTTykycP6f/Y=
X-Gm-Message-State: AOJu0YzdA6AOsAXlVZeI4/AbNWz0rd4NGEO9xuVbfWt+WFNG/xJLz3kZ
	m9ao/sPjUSCP1ThZuAptRrSI/qfwc5gZsVGXCy1Mi8Q/CRXY6ooVKG2G576i5RWxxKPM91Y6p+9
	ZFnG0+Yf0D++DQ2Wo3WJf5HD8adhwqnHRcMiUnrhQDYFFo4lFH+MBobE=
X-Google-Smtp-Source: AGHT+IHaMFxLsMk/CRkWpvYVCGVnfhIGQTKTQ/Itx4Wc7YiZ8EtvxCYz4Qe60u+idzpX8One7Srj4nV9XSBFIsV22P0IVBEmCQPd
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d0c:b0:368:d130:a718 with SMTP id
 i12-20020a056e021d0c00b00368d130a718mr37566ila.0.1712171164541; Wed, 03 Apr
 2024 12:06:04 -0700 (PDT)
Date: Wed, 03 Apr 2024 12:06:04 -0700
In-Reply-To: <7bfa6e57-11e2-4a48-a024-e92a379b45cc@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000eb6fc061535ea92@google.com>
Subject: Re: [syzbot] [io-uring?] kernel BUG in put_page
From: syzbot <syzbot+324f30025b9b5d66fab9@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

rd
[    8.809543][    T1] usbcore: registered new interface driver dln2
[    8.811777][    T1] usbcore: registered new interface driver pn533_usb
[    8.818634][    T1] nfcsim 0.2 initialized
[    8.819601][    T1] usbcore: registered new interface driver port100
[    8.821888][    T1] usbcore: registered new interface driver nfcmrvl
[    8.828017][    T1] Loading iSCSI transport class v2.0-870.
[    8.847616][    T1] virtio_scsi virtio0: 1/0/0 default/read/poll queues
[    8.857238][    T1] ------------[ cut here ]------------
[    8.858042][    T1] refcount_t: decrement hit 0; leaking memory.
[    8.859263][    T1] WARNING: CPU: 1 PID: 1 at lib/refcount.c:31 refcount=
_warn_saturate+0xfa/0x1d0
[    8.863740][    T1] Modules linked in:
[    8.864831][    T1] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.9.0-rc2-=
syzkaller-00062-g25d658afbb9f #0
[    8.867287][    T1] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 03/27/2024
[    8.868833][    T1] RIP: 0010:refcount_warn_saturate+0xfa/0x1d0
[    8.869927][    T1] Code: b2 00 00 00 e8 67 f3 e9 fc 5b 5d c3 cc cc cc c=
c e8 5b f3 e9 fc c6 05 73 24 e8 0a 01 90 48 c7 c7 40 34 1f 8c e8 67 8e ac f=
c 90 <0f> 0b 90 90 eb d9 e8 3b f3 e9 fc c6 05 50 24 e8 0a 01 90 48 c7 c7
[    8.874169][    T1] RSP: 0000:ffffc90000066e18 EFLAGS: 00010246
[    8.875227][    T1] RAX: 2c4d17207a88ac00 RBX: ffff8881446fa13c RCX: fff=
f8880166d0000
[    8.876287][    T1] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000=
0000000000000
[    8.877447][    T1] RBP: 0000000000000004 R08: ffffffff8157ffc2 R09: fff=
ffbfff1c39af8
[    8.878641][    T1] R10: dffffc0000000000 R11: fffffbfff1c39af8 R12: fff=
fea000504edc0
[    8.879942][    T1] R13: ffffea000504edc8 R14: 1ffffd4000a09db9 R15: 000=
0000000000000
[    8.881594][    T1] FS:  0000000000000000(0000) GS:ffff8880b9500000(0000=
) knlGS:0000000000000000
[    8.883506][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    8.884669][    T1] CR2: 0000000000000000 CR3: 000000000e134000 CR4: 000=
00000003506f0
[    8.885932][    T1] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000=
0000000000000
[    8.887158][    T1] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000=
0000000000400
[    8.888416][    T1] Call Trace:
[    8.888893][    T1]  <TASK>
[    8.889405][    T1]  ? __warn+0x163/0x4e0
[    8.890173][    T1]  ? refcount_warn_saturate+0xfa/0x1d0
[    8.891099][    T1]  ? report_bug+0x2b3/0x500
[    8.891833][    T1]  ? refcount_warn_saturate+0xfa/0x1d0
[    8.892704][    T1]  ? handle_bug+0x3e/0x70
[    8.893508][    T1]  ? exc_invalid_op+0x1a/0x50
[    8.894358][    T1]  ? asm_exc_invalid_op+0x1a/0x20
[    8.895351][    T1]  ? __warn_printk+0x292/0x360
[    8.896090][    T1]  ? refcount_warn_saturate+0xfa/0x1d0
[    8.896832][    T1]  ? refcount_warn_saturate+0xf9/0x1d0
[    8.897742][    T1]  __free_pages_ok+0xc60/0xd90
[    8.898411][    T1]  make_alloc_exact+0xa3/0xf0
[    8.899052][    T1]  vring_alloc_queue_split+0x20a/0x600
[    8.900061][    T1]  ? __pfx_vring_alloc_queue_split+0x10/0x10
[    8.901034][    T1]  ? vp_find_vqs+0x4c/0x4e0
[    8.901695][    T1]  ? virtscsi_probe+0x3ea/0xf60
[    8.902445][    T1]  ? virtio_dev_probe+0x991/0xaf0
[    8.903285][    T1]  ? really_probe+0x2b8/0xad0
[    8.904128][    T1]  ? driver_probe_device+0x50/0x430
[    8.904872][    T1]  vring_create_virtqueue_split+0xc6/0x310
[    8.905969][    T1]  ? ret_from_fork+0x4b/0x80
[    8.906739][    T1]  ? __pfx_vring_create_virtqueue_split+0x10/0x10
[    8.907802][    T1]  vring_create_virtqueue+0xca/0x110
[    8.908537][    T1]  ? __pfx_vp_notify+0x10/0x10
[    8.909350][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.910582][    T1]  setup_vq+0xe9/0x2d0
[    8.911201][    T1]  ? __pfx_vp_notify+0x10/0x10
[    8.911948][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.913087][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.914107][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.915020][    T1]  vp_setup_vq+0xbf/0x330
[    8.915969][    T1]  ? __pfx_vp_config_changed+0x10/0x10
[    8.917767][    T1]  ? ioread16+0x2f/0x90
[    8.918376][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.919158][    T1]  vp_find_vqs_msix+0x8b2/0xc80
[    8.920114][    T1]  vp_find_vqs+0x4c/0x4e0
[    8.920765][    T1]  virtscsi_init+0x8db/0xd00
[    8.921424][    T1]  ? __pfx_virtscsi_init+0x10/0x10
[    8.922125][    T1]  ? __pfx_default_calc_sets+0x10/0x10
[    8.923108][    T1]  ? scsi_host_alloc+0xa57/0xea0
[    8.923930][    T1]  ? vp_get+0xfd/0x140
[    8.924553][    T1]  virtscsi_probe+0x3ea/0xf60
[    8.925375][    T1]  ? __pfx_virtscsi_probe+0x10/0x10
[    8.926277][    T1]  ? kernfs_add_one+0x156/0x8b0
[    8.926980][    T1]  ? virtio_no_restricted_mem_acc+0x9/0x10
[    8.927786][    T1]  ? virtio_features_ok+0x10c/0x270
[    8.928528][    T1]  virtio_dev_probe+0x991/0xaf0
[    8.929356][    T1]  ? __pfx_virtio_dev_probe+0x10/0x10
[    8.930386][    T1]  really_probe+0x2b8/0xad0
[    8.931050][    T1]  __driver_probe_device+0x1a2/0x390
[    8.931934][    T1]  driver_probe_device+0x50/0x430
[    8.932722][    T1]  __driver_attach+0x45f/0x710
[    8.933792][    T1]  ? __pfx___driver_attach+0x10/0x10
[    8.934513][    T1]  bus_for_each_dev+0x239/0x2b0
[    8.935198][    T1]  ? __pfx___driver_attach+0x10/0x10
[    8.935920][    T1]  ? __pfx_bus_for_each_dev+0x10/0x10
[    8.936707][    T1]  ? do_raw_spin_unlock+0x13c/0x8b0
[    8.937589][    T1]  bus_add_driver+0x347/0x620
[    8.938335][    T1]  driver_register+0x23a/0x320
[    8.939169][    T1]  ? __pfx_virtio_scsi_init+0x10/0x10
[    8.940184][    T1]  virtio_scsi_init+0x65/0xe0
[    8.940980][    T1]  ? __pfx_virtio_scsi_init+0x10/0x10
[    8.941836][    T1]  do_one_initcall+0x248/0x880
[    8.942709][    T1]  ? __pfx_virtio_scsi_init+0x10/0x10
[    8.943764][    T1]  ? __pfx_lockdep_hardirqs_on_prepare+0x10/0x10
[    8.944826][    T1]  ? __pfx_do_one_initcall+0x10/0x10
[    8.945830][    T1]  ? __pfx_parse_args+0x10/0x10
[    8.946758][    T1]  ? do_initcalls+0x1c/0x80
[    8.947503][    T1]  ? rcu_is_watching+0x15/0xb0
[    8.948308][    T1]  do_initcall_level+0x157/0x210
[    8.949064][    T1]  do_initcalls+0x3f/0x80
[    8.949957][    T1]  kernel_init_freeable+0x435/0x5d0
[    8.950799][    T1]  ? __pfx_kernel_init_freeable+0x10/0x10
[    8.951875][    T1]  ? __pfx_lockdep_hardirqs_on_prepare+0x10/0x10
[    8.952863][    T1]  ? __pfx_kernel_init+0x10/0x10
[    8.953577][    T1]  ? __pfx_kernel_init+0x10/0x10
[    8.954289][    T1]  ? __pfx_kernel_init+0x10/0x10
[    8.954998][    T1]  kernel_init+0x1d/0x2b0
[    8.955683][    T1]  ret_from_fork+0x4b/0x80
[    8.956316][    T1]  ? __pfx_kernel_init+0x10/0x10
[    8.957112][    T1]  ret_from_fork_asm+0x1a/0x30
[    8.957936][    T1]  </TASK>
[    8.958420][    T1] Kernel panic - not syncing: kernel: panic_on_warn se=
t ...
[    8.959664][    T1] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.9.0-rc2-=
syzkaller-00062-g25d658afbb9f #0
[    8.959938][    T1] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 03/27/2024
[    8.959938][    T1] Call Trace:
[    8.959938][    T1]  <TASK>
[    8.959938][    T1]  dump_stack_lvl+0x241/0x360
[    8.959938][    T1]  ? __pfx_dump_stack_lvl+0x10/0x10
[    8.959938][    T1]  ? __pfx__printk+0x10/0x10
[    8.959938][    T1]  ? _printk+0xd5/0x120
[    8.959938][    T1]  ? vscnprintf+0x5d/0x90
[    8.959938][    T1]  panic+0x349/0x860
[    8.959938][    T1]  ? __warn+0x172/0x4e0
[    8.959938][    T1]  ? __pfx_panic+0x10/0x10
[    8.959938][    T1]  ? show_trace_log_lvl+0x4e6/0x520
[    8.970055][    T1]  ? ret_from_fork_asm+0x1a/0x30
[    8.970055][    T1]  __warn+0x346/0x4e0
[    8.970055][    T1]  ? refcount_warn_saturate+0xfa/0x1d0
[    8.970055][    T1]  report_bug+0x2b3/0x500
[    8.970055][    T1]  ? refcount_warn_saturate+0xfa/0x1d0
[    8.970055][    T1]  handle_bug+0x3e/0x70
[    8.970055][    T1]  exc_invalid_op+0x1a/0x50
[    8.970055][    T1]  asm_exc_invalid_op+0x1a/0x20
[    8.970055][    T1] RIP: 0010:refcount_warn_saturate+0xfa/0x1d0
[    8.970055][    T1] Code: b2 00 00 00 e8 67 f3 e9 fc 5b 5d c3 cc cc cc c=
c e8 5b f3 e9 fc c6 05 73 24 e8 0a 01 90 48 c7 c7 40 34 1f 8c e8 67 8e ac f=
c 90 <0f> 0b 90 90 eb d9 e8 3b f3 e9 fc c6 05 50 24 e8 0a 01 90 48 c7 c7
[    8.979931][    T1] RSP: 0000:ffffc90000066e18 EFLAGS: 00010246
[    8.979931][    T1] RAX: 2c4d17207a88ac00 RBX: ffff8881446fa13c RCX: fff=
f8880166d0000
[    8.979931][    T1] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000=
0000000000000
[    8.979931][    T1] RBP: 0000000000000004 R08: ffffffff8157ffc2 R09: fff=
ffbfff1c39af8
[    8.979931][    T1] R10: dffffc0000000000 R11: fffffbfff1c39af8 R12: fff=
fea000504edc0
[    8.979931][    T1] R13: ffffea000504edc8 R14: 1ffffd4000a09db9 R15: 000=
0000000000000
[    8.979931][    T1]  ? __warn_printk+0x292/0x360
[    8.990056][    T1]  ? refcount_warn_saturate+0xf9/0x1d0
[    8.990056][    T1]  __free_pages_ok+0xc60/0xd90
[    8.990056][    T1]  make_alloc_exact+0xa3/0xf0
[    8.990056][    T1]  vring_alloc_queue_split+0x20a/0x600
[    8.990056][    T1]  ? __pfx_vring_alloc_queue_split+0x10/0x10
[    8.990056][    T1]  ? vp_find_vqs+0x4c/0x4e0
[    8.990056][    T1]  ? virtscsi_probe+0x3ea/0xf60
[    8.990056][    T1]  ? virtio_dev_probe+0x991/0xaf0
[    8.990056][    T1]  ? really_probe+0x2b8/0xad0
[    8.990056][    T1]  ? driver_probe_device+0x50/0x430
[    8.990056][    T1]  vring_create_virtqueue_split+0xc6/0x310
[    8.990056][    T1]  ? ret_from_fork+0x4b/0x80
[    8.999988][    T1]  ? __pfx_vring_create_virtqueue_split+0x10/0x10
[    8.999988][    T1]  vring_create_virtqueue+0xca/0x110
[    8.999988][    T1]  ? __pfx_vp_notify+0x10/0x10
[    8.999988][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.999988][    T1]  setup_vq+0xe9/0x2d0
[    8.999988][    T1]  ? __pfx_vp_notify+0x10/0x10
[    8.999988][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.999988][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.999988][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    8.999988][    T1]  vp_setup_vq+0xbf/0x330
[    8.999988][    T1]  ? __pfx_vp_config_changed+0x10/0x10
[    8.999988][    T1]  ? ioread16+0x2f/0x90
[    8.999988][    T1]  ? __pfx_virtscsi_ctrl_done+0x10/0x10
[    9.010034][    T1]  vp_find_vqs_msix+0x8b2/0xc80
[    9.010034][    T1]  vp_find_vqs+0x4c/0x4e0
[    9.010034][    T1]  virtscsi_init+0x8db/0xd00
[    9.010034][    T1]  ? __pfx_virtscsi_init+0x10/0x10
[    9.010034][    T1]  ? __pfx_default_calc_sets+0x10/0x10
[    9.010034][    T1]  ? scsi_host_alloc+0xa57/0xea0
[    9.010034][    T1]  ? vp_get+0xfd/0x140
[    9.010034][    T1]  virtscsi_probe+0x3ea/0xf60
[    9.010034][    T1]  ? __pfx_virtscsi_probe+0x10/0x10
[    9.010034][    T1]  ? kernfs_add_one+0x156/0x8b0
[    9.010034][    T1]  ? virtio_no_restricted_mem_acc+0x9/0x10
[    9.010034][    T1]  ? virtio_features_ok+0x10c/0x270
[    9.019933][    T1]  virtio_dev_probe+0x991/0xaf0
[    9.019933][    T1]  ? __pfx_virtio_dev_probe+0x10/0x10
[    9.019933][    T1]  really_probe+0x2b8/0xad0
[    9.019933][    T1]  __driver_probe_device+0x1a2/0x390
[    9.019933][    T1]  driver_probe_device+0x50/0x430
[    9.019933][    T1]  __driver_attach+0x45f/0x710
[    9.019933][    T1]  ? __pfx___driver_attach+0x10/0x10
[    9.019933][    T1]  bus_for_each_dev+0x239/0x2b0
[    9.019933][    T1]  ? __pfx___driver_attach+0x10/0x10
[    9.019933][    T1]  ? __pfx_bus_for_each_dev+0x10/0x10
[    9.019933][    T1]  ? do_raw_spin_unlock+0x13c/0x8b0
[    9.019933][    T1]  bus_add_driver+0x347/0x620
[    9.030102][    T1]  driver_register+0x23a/0x320
[    9.030102][    T1]  ? __pfx_virtio_scsi_init+0x10/0x10
[    9.030102][    T1]  virtio_scsi_init+0x65/0xe0
[    9.030102][    T1]  ? __pfx_virtio_scsi_init+0x10/0x10
[    9.030102][    T1]  do_one_initcall+0x248/0x880
[    9.030102][    T1]  ? __pfx_virtio_scsi_init+0x10/0x10
[    9.030102][    T1]  ? __pfx_lockdep_hardirqs_on_prepare+0x10/0x10
[    9.030102][    T1]  ? __pfx_do_one_initcall+0x10/0x10
[    9.030102][    T1]  ? __pfx_parse_args+0x10/0x10
[    9.039922][    T1]  ? do_initcalls+0x1c/0x80
[    9.039922][    T1]  ? rcu_is_watching+0x15/0xb0
[    9.039922][    T1]  do_initcall_level+0x157/0x210
[    9.039922][    T1]  do_initcalls+0x3f/0x80
[    9.039922][    T1]  kernel_init_freeable+0x435/0x5d0
[    9.039922][    T1]  ? __pfx_kernel_init_freeable+0x10/0x10
[    9.039922][    T1]  ? __pfx_lockdep_hardirqs_on_prepare+0x10/0x10
[    9.039922][    T1]  ? __pfx_kernel_init+0x10/0x10
[    9.039922][    T1]  ? __pfx_kernel_init+0x10/0x10
[    9.039922][    T1]  ? __pfx_kernel_init+0x10/0x10
[    9.039922][    T1]  kernel_init+0x1d/0x2b0
[    9.050013][    T1]  ret_from_fork+0x4b/0x80
[    9.050013][    T1]  ? __pfx_kernel_init+0x10/0x10
[    9.050013][    T1]  ret_from_fork_asm+0x1a/0x30
[    9.050013][    T1]  </TASK>
[    9.050013][    T1] Kernel Offset: disabled
[    9.050013][    T1] Rebooting in 86400 seconds..


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
GOMODCACHE=3D'/syzkaller/jobs-2/linux/gopath/pkg/mod'
GONOPROXY=3D''
GONOSUMDB=3D''
GOOS=3D'linux'
GOPATH=3D'/syzkaller/jobs-2/linux/gopath'
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
GOMOD=3D'/syzkaller/jobs-2/linux/gopath/src/github.com/google/syzkaller/go.=
mod'
GOWORK=3D''
CGO_CFLAGS=3D'-O2 -g'
CGO_CPPFLAGS=3D''
CGO_CXXFLAGS=3D'-O2 -g'
CGO_FFLAGS=3D'-O2 -g'
CGO_LDFLAGS=3D'-O2 -g'
PKG_CONFIG=3D'pkg-config'
GOGCCFLAGS=3D'-fPIC -m64 -pthread -Wl,--no-gc-sections -fmessage-length=3D0=
 -ffile-prefix-map=3D/tmp/go-build2770999391=3D/tmp/go-build -gno-record-gc=
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
https://syzkaller.appspot.com/x/error.txt?x=3D148f06ad180000


Tested on:

commit:         25d658af io_uring/kbuf: remove dead define
git tree:       git://git.kernel.dk/linux.git for-6.10/io_uring
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D51cdcd4a8f33256=
9
dashboard link: https://syzkaller.appspot.com/bug?extid=3D324f30025b9b5d66f=
ab9
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debia=
n) 2.40

Note: no patches were applied.

