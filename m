Return-Path: <io-uring+bounces-7052-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C10A5D2BD
	for <lists+io-uring@lfdr.de>; Tue, 11 Mar 2025 23:53:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 672587A8B02
	for <lists+io-uring@lfdr.de>; Tue, 11 Mar 2025 22:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02867220693;
	Tue, 11 Mar 2025 22:53:28 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3611EE7CB
	for <io-uring@vger.kernel.org>; Tue, 11 Mar 2025 22:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741733607; cv=none; b=D9aiwzO/ZINlEpbqTiQo8R62ixC46s+dfa3lu5Vx4kZSnZkLs2PiLcLiyr8mcUBPEouc/r7tOHYPBeeCPgWB7b93RaU12ohJmdmIC4022IesFLgcrS6IGWczE54E1SjGrau5ehdoOGJH6ImRT9UB4KqfFEeB8RNFDA9X49VDsgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741733607; c=relaxed/simple;
	bh=kEd9Ek0Bsd2B5rWWkgGBxSb297ZI9V6d62ToRfAPTxA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=d6nnOyxzZ9EDtrqgwTdYoO0yxc5Cj+Z1XCjkLFeVfEwWGSLhCUGQW1SdivF1tigfm8rf5chlGQnjQEBSGqA0rfzAKHAWqtad2rRuPQuvbAhVQn12S1CQt1N/yQ06bdKaOE2ouhAVmYJVAX84KJLF3OpAD6QkV9Og6xBzc55HCEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-851a991cf8bso29983539f.0
        for <io-uring@vger.kernel.org>; Tue, 11 Mar 2025 15:53:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741733605; x=1742338405;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ocZPuP6VPq8evU7zsrsoR5L7O/sZVxmpq4603WTa5IA=;
        b=ZO1U0vUqyDldOlcjGtWCAz+LabALzumGtZtyRc9Kw8uRfHsgH6eOBK60GviDVj3gJk
         hJA/rUtnylci+8vFTZzJotgnanj7pNVH33wTCEe8LLG7bcGccbe+pqZBJomjNneyHq7e
         5KC5oAIpWTSJDE57nZ6YiWSmSpznNMZe1nUcZhQL/nb74OB2/xDzQtUPmbmPqkchvIHp
         Bg2WiS1KMubmSYFYMkYbdh1naeZUcdqcFDOkGde88A6EzSFtyOUp9U7WibSe1TCOniU/
         mQnZMB3pCnG7b3Qdu+v+8X+qaTwtE7XY5vOrbbbf5nJA4C+v52tdBaTEbg6XZ/sDuXz/
         6rdg==
X-Forwarded-Encrypted: i=1; AJvYcCV7zeOsf2jzTJmTH/ldvKqWu/FPvtxq7E3P+vR4kXgsw09bwCQrDtMwqSRm7vsbhoWLwzQhsQ1dxA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxZHeyL17px7xLzjDl9s/HWwufUcxTGKAwI5M65UZWKMNpqYQsk
	UytRiaX9kHzKahAhtz5rvDDHwB7MGdNI2HlXpOoKk+Q8tyI39oFdGZj3DMvIarS4SXF020a0tHh
	0Vfvm2YG8+CVvXyIBrj9279zUdnmYtMsKpiPKBUwtYwI/8eALZ93DOjM=
X-Google-Smtp-Source: AGHT+IGzgOU4zfW5n8Sdw0VIJcUg/BFtapFf4ths2BzYj0O2y5IJC7oOD40C4otA+00h51eBEETJu0KM0T7meI2/bESzqUOkVP4m
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a41:b0:3d3:d1a8:8e82 with SMTP id
 e9e14a558f8ab-3d4691b80fcmr54513855ab.9.1741733604864; Tue, 11 Mar 2025
 15:53:24 -0700 (PDT)
Date: Tue, 11 Mar 2025 15:53:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67d0bee4.050a0220.14e108.001f.GAE@google.com>
Subject: [syzbot] [io-uring?] possible deadlock in io_uring_mmap
From: syzbot <syzbot+96c4c7891428e8c9ac1a@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    77c95b8c7a16 Merge remote-tracking branch 'will/for-next/p..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=137d2a64580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=afb3000d0159783f
dashboard link: https://syzkaller.appspot.com/bug?extid=96c4c7891428e8c9ac1a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a9fe810b5d23/disk-77c95b8c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b46f8f4fa912/vmlinux-77c95b8c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/83ddebd15489/Image-77c95b8c.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+96c4c7891428e8c9ac1a@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.14.0-rc5-syzkaller-g77c95b8c7a16 #0 Not tainted
------------------------------------------------------
syz.3.85/7036 is trying to acquire lock:
ffff0000cf4f89b8 (&vma->vm_lock->lock){++++}-{4:4}, at: vma_start_write include/linux/mm.h:770 [inline]
ffff0000cf4f89b8 (&vma->vm_lock->lock){++++}-{4:4}, at: vm_flags_set include/linux/mm.h:900 [inline]
ffff0000cf4f89b8 (&vma->vm_lock->lock){++++}-{4:4}, at: io_region_mmap io_uring/memmap.c:312 [inline]
ffff0000cf4f89b8 (&vma->vm_lock->lock){++++}-{4:4}, at: io_uring_mmap+0x37c/0x504 io_uring/memmap.c:339

but task is already holding lock:
ffff0000f51da8d8 (&ctx->mmap_lock){+.+.}-{4:4}, at: class_mutex_constructor include/linux/mutex.h:201 [inline]
ffff0000f51da8d8 (&ctx->mmap_lock){+.+.}-{4:4}, at: io_uring_mmap+0x100/0x504 io_uring/memmap.c:325

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #9 (&ctx->mmap_lock){+.+.}-{4:4}:
       __mutex_lock_common+0x1f0/0x24b8 kernel/locking/mutex.c:585
       __mutex_lock kernel/locking/mutex.c:730 [inline]
       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:782
       class_mutex_constructor include/linux/mutex.h:201 [inline]
       io_uring_get_unmapped_area+0x84/0x348 io_uring/memmap.c:357
       __get_unmapped_area+0x1d8/0x364 mm/mmap.c:846
       do_mmap+0x4a8/0x1150 mm/mmap.c:409
       vm_mmap_pgoff+0x228/0x3c4 mm/util.c:575
       ksys_mmap_pgoff+0x3a4/0x5c8 mm/mmap.c:607
       __do_sys_mmap arch/arm64/kernel/sys.c:28 [inline]
       __se_sys_mmap arch/arm64/kernel/sys.c:21 [inline]
       __arm64_sys_mmap+0xf8/0x110 arch/arm64/kernel/sys.c:21
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #8 (&mm->mmap_lock){++++}-{4:4}:
       __might_fault+0xc4/0x124 mm/memory.c:6851
       drm_mode_object_get_properties+0x208/0x540 drivers/gpu/drm/drm_mode_object.c:407
       drm_mode_obj_get_properties_ioctl+0x2bc/0x4fc drivers/gpu/drm/drm_mode_object.c:459
       drm_ioctl_kernel+0x26c/0x368 drivers/gpu/drm/drm_ioctl.c:796
       drm_ioctl+0x6a0/0xb98 drivers/gpu/drm/drm_ioctl.c:893
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl fs/ioctl.c:892 [inline]
       __arm64_sys_ioctl+0x14c/0x1cc fs/ioctl.c:892
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #7 (crtc_ww_class_mutex){+.+.}-{4:4}:
       ww_acquire_init include/linux/ww_mutex.h:162 [inline]
       drm_modeset_acquire_init+0x1e4/0x384 drivers/gpu/drm/drm_modeset_lock.c:250
       drmm_mode_config_init+0xb98/0x130c drivers/gpu/drm/drm_mode_config.c:462
       vkms_modeset_init drivers/gpu/drm/vkms/vkms_drv.c:155 [inline]
       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:216 [inline]
       vkms_init+0x2fc/0x5fc drivers/gpu/drm/vkms/vkms_drv.c:253
       do_one_initcall+0x254/0xaa4 init/main.c:1257
       do_initcall_level+0x154/0x214 init/main.c:1319
       do_initcalls+0x84/0xf4 init/main.c:1335
       do_basic_setup+0x8c/0xa0 init/main.c:1354
       kernel_init_freeable+0x324/0x478 init/main.c:1568
       kernel_init+0x24/0x2a0 init/main.c:1457
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862

-> #6 (crtc_ww_class_acquire){+.+.}-{0:0}:
       ww_acquire_init include/linux/ww_mutex.h:161 [inline]
       drm_modeset_acquire_init+0x1c4/0x384 drivers/gpu/drm/drm_modeset_lock.c:250
       drm_client_modeset_commit_atomic+0xd8/0x724 drivers/gpu/drm/drm_client_modeset.c:1018
       drm_client_modeset_commit_locked+0xd0/0x4a8 drivers/gpu/drm/drm_client_modeset.c:1182
       drm_client_modeset_commit+0x50/0x7c drivers/gpu/drm/drm_client_modeset.c:1208
       __drm_fb_helper_restore_fbdev_mode_unlocked+0xd4/0x178 drivers/gpu/drm/drm_fb_helper.c:237
       drm_fb_helper_set_par+0xc4/0x110 drivers/gpu/drm/drm_fb_helper.c:1351
       fbcon_init+0xf34/0x1eb8 drivers/video/fbdev/core/fbcon.c:1113
       visual_init+0x27c/0x548 drivers/tty/vt/vt.c:1011
       do_bind_con_driver+0x7dc/0xe04 drivers/tty/vt/vt.c:3831
       do_take_over_console+0x4ac/0x5f0 drivers/tty/vt/vt.c:4397
       do_fbcon_takeover+0x158/0x260 drivers/video/fbdev/core/fbcon.c:549
       do_fb_registered drivers/video/fbdev/core/fbcon.c:2988 [inline]
       fbcon_fb_registered+0x370/0x4ec drivers/video/fbdev/core/fbcon.c:3008
       do_register_framebuffer drivers/video/fbdev/core/fbmem.c:449 [inline]
       register_framebuffer+0x470/0x610 drivers/video/fbdev/core/fbmem.c:515
       __drm_fb_helper_initial_config_and_unlock+0x1334/0x1880 drivers/gpu/drm/drm_fb_helper.c:1843
       drm_fb_helper_initial_config+0x48/0x64 drivers/gpu/drm/drm_fb_helper.c:1908
       drm_fbdev_client_hotplug+0x158/0x22c drivers/gpu/drm/clients/drm_fbdev_client.c:52
       drm_client_register+0x144/0x1e0 drivers/gpu/drm/drm_client.c:140
       drm_fbdev_client_setup+0x1a4/0x39c drivers/gpu/drm/clients/drm_fbdev_client.c:159
       drm_client_setup+0x78/0x140 drivers/gpu/drm/clients/drm_client_setup.c:39
       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:227 [inline]
       vkms_init+0x4ec/0x5fc drivers/gpu/drm/vkms/vkms_drv.c:253
       do_one_initcall+0x254/0xaa4 init/main.c:1257
       do_initcall_level+0x154/0x214 init/main.c:1319
       do_initcalls+0x84/0xf4 init/main.c:1335
       do_basic_setup+0x8c/0xa0 init/main.c:1354
       kernel_init_freeable+0x324/0x478 init/main.c:1568
       kernel_init+0x24/0x2a0 init/main.c:1457
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862

-> #5 (&client->modeset_mutex){+.+.}-{4:4}:
       __mutex_lock_common+0x1f0/0x24b8 kernel/locking/mutex.c:585
       __mutex_lock kernel/locking/mutex.c:730 [inline]
       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:782
       drm_client_modeset_probe+0x300/0x3cb0 drivers/gpu/drm/drm_client_modeset.c:843
       __drm_fb_helper_initial_config_and_unlock+0x100/0x1880 drivers/gpu/drm/drm_fb_helper.c:1820
       drm_fb_helper_initial_config+0x48/0x64 drivers/gpu/drm/drm_fb_helper.c:1908
       drm_fbdev_client_hotplug+0x158/0x22c drivers/gpu/drm/clients/drm_fbdev_client.c:52
       drm_client_register+0x144/0x1e0 drivers/gpu/drm/drm_client.c:140
       drm_fbdev_client_setup+0x1a4/0x39c drivers/gpu/drm/clients/drm_fbdev_client.c:159
       drm_client_setup+0x78/0x140 drivers/gpu/drm/clients/drm_client_setup.c:39
       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:227 [inline]
       vkms_init+0x4ec/0x5fc drivers/gpu/drm/vkms/vkms_drv.c:253
       do_one_initcall+0x254/0xaa4 init/main.c:1257
       do_initcall_level+0x154/0x214 init/main.c:1319
       do_initcalls+0x84/0xf4 init/main.c:1335
       do_basic_setup+0x8c/0xa0 init/main.c:1354
       kernel_init_freeable+0x324/0x478 init/main.c:1568
       kernel_init+0x24/0x2a0 init/main.c:1457
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862

-> #4 (&helper->lock){+.+.}-{4:4}:
       __mutex_lock_common+0x1f0/0x24b8 kernel/locking/mutex.c:585
       __mutex_lock kernel/locking/mutex.c:730 [inline]
       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:782
       __drm_fb_helper_restore_fbdev_mode_unlocked+0xb4/0x178 drivers/gpu/drm/drm_fb_helper.c:228
       drm_fb_helper_set_par+0xc4/0x110 drivers/gpu/drm/drm_fb_helper.c:1351
       fbcon_init+0xf34/0x1eb8 drivers/video/fbdev/core/fbcon.c:1113
       visual_init+0x27c/0x548 drivers/tty/vt/vt.c:1011
       do_bind_con_driver+0x7dc/0xe04 drivers/tty/vt/vt.c:3831
       do_take_over_console+0x4ac/0x5f0 drivers/tty/vt/vt.c:4397
       do_fbcon_takeover+0x158/0x260 drivers/video/fbdev/core/fbcon.c:549
       do_fb_registered drivers/video/fbdev/core/fbcon.c:2988 [inline]
       fbcon_fb_registered+0x370/0x4ec drivers/video/fbdev/core/fbcon.c:3008
       do_register_framebuffer drivers/video/fbdev/core/fbmem.c:449 [inline]
       register_framebuffer+0x470/0x610 drivers/video/fbdev/core/fbmem.c:515
       __drm_fb_helper_initial_config_and_unlock+0x1334/0x1880 drivers/gpu/drm/drm_fb_helper.c:1843
       drm_fb_helper_initial_config+0x48/0x64 drivers/gpu/drm/drm_fb_helper.c:1908
       drm_fbdev_client_hotplug+0x158/0x22c drivers/gpu/drm/clients/drm_fbdev_client.c:52
       drm_client_register+0x144/0x1e0 drivers/gpu/drm/drm_client.c:140
       drm_fbdev_client_setup+0x1a4/0x39c drivers/gpu/drm/clients/drm_fbdev_client.c:159
       drm_client_setup+0x78/0x140 drivers/gpu/drm/clients/drm_client_setup.c:39
       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:227 [inline]
       vkms_init+0x4ec/0x5fc drivers/gpu/drm/vkms/vkms_drv.c:253
       do_one_initcall+0x254/0xaa4 init/main.c:1257
       do_initcall_level+0x154/0x214 init/main.c:1319
       do_initcalls+0x84/0xf4 init/main.c:1335
       do_basic_setup+0x8c/0xa0 init/main.c:1354
       kernel_init_freeable+0x324/0x478 init/main.c:1568
       kernel_init+0x24/0x2a0 init/main.c:1457
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862

-> #3 (console_lock){+.+.}-{0:0}:
       console_lock+0x19c/0x1f4 kernel/printk/printk.c:2833
       __bch2_print_string_as_lines fs/bcachefs/util.c:267 [inline]
       bch2_print_string_as_lines+0x2c/0xd4 fs/bcachefs/util.c:286
       bch2_print_str+0x90/0xcc fs/bcachefs/super.c:102
       bch2_dump_trans_updates+0xf4/0x160 fs/bcachefs/btree_iter.c:1516
       bch2_bucket_ref_update+0xfc0/0x1390 fs/bcachefs/buckets.c:485
       __mark_pointer fs/bcachefs/buckets.c:550 [inline]
       bch2_trigger_pointer fs/bcachefs/buckets.c:589 [inline]
       __trigger_extent+0x1150/0x46dc fs/bcachefs/buckets.c:736
       bch2_trigger_extent+0x474/0x814 fs/bcachefs/buckets.c:865
       bch2_key_trigger fs/bcachefs/bkey_methods.h:88 [inline]
       bch2_key_trigger_old fs/bcachefs/bkey_methods.h:102 [inline]
       run_one_trans_trigger fs/bcachefs/btree_trans_commit.c:511 [inline]
       run_btree_triggers+0x6bc/0xe10 fs/bcachefs/btree_trans_commit.c:540
       bch2_trans_commit_run_triggers fs/bcachefs/btree_trans_commit.c:573 [inline]
       __bch2_trans_commit+0x210/0x6190 fs/bcachefs/btree_trans_commit.c:1010
       bch2_trans_commit fs/bcachefs/btree_update.h:183 [inline]
       bch2_extent_update+0x3d0/0x9b4 fs/bcachefs/io_write.c:326
       bch2_remap_range+0x193c/0x304c fs/bcachefs/reflink.c:715
       bch2_remap_file_range+0x9d4/0xcc8 fs/bcachefs/fs-io.c:916
       vfs_clone_file_range+0x69c/0xc58 fs/remap_range.c:403
       ioctl_file_clone fs/ioctl.c:240 [inline]
       ioctl_file_clone_range fs/ioctl.c:258 [inline]
       do_vfs_ioctl+0x1708/0x2724 fs/ioctl.c:853
       __do_sys_ioctl fs/ioctl.c:904 [inline]
       __se_sys_ioctl fs/ioctl.c:892 [inline]
       __arm64_sys_ioctl+0xe4/0x1cc fs/ioctl.c:892
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #2 (bcachefs_btree){+.+.}-{0:0}:
       trans_set_locked+0x88/0x1a4 fs/bcachefs/btree_locking.h:198
       bch2_trans_begin+0x6fc/0x980 fs/bcachefs/btree_iter.c:3305
       bchfs_read+0x1dc/0x1dc0 fs/bcachefs/fs-io-buffered.c:161
       bch2_readahead+0xafc/0xed4 fs/bcachefs/fs-io-buffered.c:291
       read_pages+0x150/0x4f0 mm/readahead.c:161
       page_cache_ra_order+0x7d0/0xb8c mm/readahead.c:516
       do_sync_mmap_readahead+0x3d8/0x890
       filemap_fault+0x69c/0x1518 mm/filemap.c:3447
       bch2_page_fault+0x34c/0x808 fs/bcachefs/fs-io-pagecache.c:594
       __do_fault+0xf8/0x498 mm/memory.c:4988
       do_read_fault mm/memory.c:5403 [inline]
       do_fault mm/memory.c:5537 [inline]
       do_pte_missing mm/memory.c:4058 [inline]
       handle_pte_fault+0x3504/0x57b0 mm/memory.c:5900
       __handle_mm_fault mm/memory.c:6043 [inline]
       handle_mm_fault+0xfa8/0x188c mm/memory.c:6212
       faultin_page mm/gup.c:1196 [inline]
       __get_user_pages+0x1878/0x3400 mm/gup.c:1491
       populate_vma_page_range+0x220/0x2f0 mm/gup.c:1929
       __mm_populate+0x240/0x3d8 mm/gup.c:2032
       mm_populate include/linux/mm.h:3386 [inline]
       vm_mmap_pgoff+0x304/0x3c4 mm/util.c:580
       ksys_mmap_pgoff+0x3a4/0x5c8 mm/mmap.c:607
       __do_sys_mmap arch/arm64/kernel/sys.c:28 [inline]
       __se_sys_mmap arch/arm64/kernel/sys.c:21 [inline]
       __arm64_sys_mmap+0xf8/0x110 arch/arm64/kernel/sys.c:21
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #1 (mapping.invalidate_lock#5){.+.+}-{4:4}:
       down_read+0x58/0x2fc kernel/locking/rwsem.c:1524
       filemap_invalidate_lock_shared include/linux/fs.h:932 [inline]
       filemap_fault+0x524/0x1518 mm/filemap.c:3435
       bch2_page_fault+0x34c/0x808 fs/bcachefs/fs-io-pagecache.c:594
       __do_fault+0xf8/0x498 mm/memory.c:4988
       do_shared_fault mm/memory.c:5467 [inline]
       do_fault mm/memory.c:5541 [inline]
       do_pte_missing mm/memory.c:4058 [inline]
       handle_pte_fault+0x1348/0x57b0 mm/memory.c:5900
       __handle_mm_fault mm/memory.c:6043 [inline]
       handle_mm_fault+0xfa8/0x188c mm/memory.c:6212
       do_page_fault+0x408/0x10ac arch/arm64/mm/fault.c:647
       do_translation_fault+0xc4/0x114 arch/arm64/mm/fault.c:783
       do_mem_abort+0x74/0x200 arch/arm64/mm/fault.c:919
       el0_da+0x60/0x178 arch/arm64/kernel/entry-common.c:604
       el0t_64_sync_handler+0xcc/0x108 arch/arm64/kernel/entry-common.c:765
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #0 (&vma->vm_lock->lock){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3163 [inline]
       check_prevs_add kernel/locking/lockdep.c:3282 [inline]
       validate_chain kernel/locking/lockdep.c:3906 [inline]
       __lock_acquire+0x34f0/0x7904 kernel/locking/lockdep.c:5228
       lock_acquire+0x23c/0x724 kernel/locking/lockdep.c:5851
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1577
       vma_start_write include/linux/mm.h:770 [inline]
       vm_flags_set include/linux/mm.h:900 [inline]
       io_region_mmap io_uring/memmap.c:312 [inline]
       io_uring_mmap+0x37c/0x504 io_uring/memmap.c:339
       call_mmap include/linux/fs.h:2245 [inline]
       mmap_file mm/internal.h:124 [inline]
       __mmap_new_file_vma mm/vma.c:2292 [inline]
       __mmap_new_vma mm/vma.c:2356 [inline]
       __mmap_region mm/vma.c:2457 [inline]
       mmap_region+0x1ae0/0x2518 mm/vma.c:2535
       do_mmap+0xbc8/0x1150 mm/mmap.c:561
       vm_mmap_pgoff+0x228/0x3c4 mm/util.c:575
       ksys_mmap_pgoff+0x3a4/0x5c8 mm/mmap.c:607
       __do_sys_mmap arch/arm64/kernel/sys.c:28 [inline]
       __se_sys_mmap arch/arm64/kernel/sys.c:21 [inline]
       __arm64_sys_mmap+0xf8/0x110 arch/arm64/kernel/sys.c:21
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

other info that might help us debug this:

Chain exists of:
  &vma->vm_lock->lock --> &mm->mmap_lock --> &ctx->mmap_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ctx->mmap_lock);
                               lock(&mm->mmap_lock);
                               lock(&ctx->mmap_lock);
  lock(&vma->vm_lock->lock);

 *** DEADLOCK ***

2 locks held by syz.3.85/7036:
 #0: ffff0000c2fc45d0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_write_lock_killable include/linux/mmap_lock.h:152 [inline]
 #0: ffff0000c2fc45d0 (&mm->mmap_lock){++++}-{4:4}, at: vm_mmap_pgoff+0x154/0x3c4 mm/util.c:573
 #1: ffff0000f51da8d8 (&ctx->mmap_lock){+.+.}-{4:4}, at: class_mutex_constructor include/linux/mutex.h:201 [inline]
 #1: ffff0000f51da8d8 (&ctx->mmap_lock){+.+.}-{4:4}, at: io_uring_mmap+0x100/0x504 io_uring/memmap.c:325

stack backtrace:
CPU: 0 UID: 0 PID: 7036 Comm: syz.3.85 Not tainted 6.14.0-rc5-syzkaller-g77c95b8c7a16 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:466 (C)
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_circular_bug+0x154/0x1c0 kernel/locking/lockdep.c:2076
 check_noncircular+0x310/0x404 kernel/locking/lockdep.c:2208
 check_prev_add kernel/locking/lockdep.c:3163 [inline]
 check_prevs_add kernel/locking/lockdep.c:3282 [inline]
 validate_chain kernel/locking/lockdep.c:3906 [inline]
 __lock_acquire+0x34f0/0x7904 kernel/locking/lockdep.c:5228
 lock_acquire+0x23c/0x724 kernel/locking/lockdep.c:5851
 down_write+0x50/0xc0 kernel/locking/rwsem.c:1577
 vma_start_write include/linux/mm.h:770 [inline]
 vm_flags_set include/linux/mm.h:900 [inline]
 io_region_mmap io_uring/memmap.c:312 [inline]
 io_uring_mmap+0x37c/0x504 io_uring/memmap.c:339
 call_mmap include/linux/fs.h:2245 [inline]
 mmap_file mm/internal.h:124 [inline]
 __mmap_new_file_vma mm/vma.c:2292 [inline]
 __mmap_new_vma mm/vma.c:2356 [inline]
 __mmap_region mm/vma.c:2457 [inline]
 mmap_region+0x1ae0/0x2518 mm/vma.c:2535
 do_mmap+0xbc8/0x1150 mm/mmap.c:561
 vm_mmap_pgoff+0x228/0x3c4 mm/util.c:575
 ksys_mmap_pgoff+0x3a4/0x5c8 mm/mmap.c:607
 __do_sys_mmap arch/arm64/kernel/sys.c:28 [inline]
 __se_sys_mmap arch/arm64/kernel/sys.c:21 [inline]
 __arm64_sys_mmap+0xf8/0x110 arch/arm64/kernel/sys.c:21
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

