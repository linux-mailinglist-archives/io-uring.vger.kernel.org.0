Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEE0579E6BF
	for <lists+io-uring@lfdr.de>; Wed, 13 Sep 2023 13:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240186AbjIMLaB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Sep 2023 07:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240129AbjIMLaB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Sep 2023 07:30:01 -0400
Received: from mail-oi1-f208.google.com (mail-oi1-f208.google.com [209.85.167.208])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE4D173E
        for <io-uring@vger.kernel.org>; Wed, 13 Sep 2023 04:29:56 -0700 (PDT)
Received: by mail-oi1-f208.google.com with SMTP id 5614622812f47-3a9e0f4e17fso7510054b6e.2
        for <io-uring@vger.kernel.org>; Wed, 13 Sep 2023 04:29:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694604596; x=1695209396;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yBAeX2/r2WMnT3DZO4I6YyM4BkG96XFH6v+pLg0qyP8=;
        b=lZ1CUI0HW8IRlj1qt3Ck4SVfeXYpMCaE89+y6o+uDHyTRQegGdYo5N1e6HJdmaOdMm
         M20QN5RpXCK3YQyzYc5L7BV80JEt/AgEJRlmPYpVPC+HufE5NpRQLYHAvS4r7VJvp12n
         ++nEaeu9LxlStbwdOW+thL43n9mYRupA4T+dpJKWNSLaAxsagc1PMBU+ud0cvxc/rL1J
         qEoNBoeoRP+wJxLNgTKKLhUKrT7/I5F/zrYA3DWdKVe9pNiHlYyXb5nRbhqYqnywRgH3
         zM45GxcUVhlDaAG/2XHXn2R6oYnc2JXdB0eDCMpo+d8tgGU7onBHDW4guz44oUZPGkUy
         V/Ag==
X-Gm-Message-State: AOJu0YywWCsPfY1XHd1jUwSEw9DlLVz5ZGuTrdmfnzedOjRPj14ifeNY
        QdnISe+g36nHOHb2TzXVLR1M9wLNFZa0oqR5QxdJkYXX2BlH
X-Google-Smtp-Source: AGHT+IEog6mIKmxlTm23PKm37ZN/P7mMR9cgXuzsCcN0tUAzMfVgZQRz6J+8l7eaOsWqRy7YaoDfbCx6uwtpVPdtQiL6gBDJpASh
MIME-Version: 1.0
X-Received: by 2002:a05:6808:20a5:b0:3a7:75cd:df40 with SMTP id
 s37-20020a05680820a500b003a775cddf40mr983907oiw.7.1694604596110; Wed, 13 Sep
 2023 04:29:56 -0700 (PDT)
Date:   Wed, 13 Sep 2023 04:29:56 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fc6ba706053be013@google.com>
Subject: [syzbot] [io-uring?] KCSAN: data-race in io_wq_activate_free_worker / io_wq_worker_running
From:   syzbot <syzbot+a36975231499dc24df44@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f97e18a3f2fb Merge tag 'gpio-updates-for-v6.6' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12864667a80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fe440f256d065d3b
dashboard link: https://syzkaller.appspot.com/bug?extid=a36975231499dc24df44
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b1781aaff038/disk-f97e18a3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5b915468fd6d/vmlinux-f97e18a3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/abc8ece931f3/bzImage-f97e18a3.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a36975231499dc24df44@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in io_wq_activate_free_worker / io_wq_worker_running

write to 0xffff888127f736c4 of 4 bytes by task 4731 on cpu 1:
 io_wq_worker_running+0x64/0xa0 io_uring/io-wq.c:668
 schedule_timeout+0xcc/0x230 kernel/time/timer.c:2167
 io_wq_worker+0x4b2/0x840 io_uring/io-wq.c:633
 ret_from_fork+0x2e/0x40 arch/x86/kernel/process.c:145
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304

read to 0xffff888127f736c4 of 4 bytes by task 4719 on cpu 0:
 io_wq_get_acct io_uring/io-wq.c:168 [inline]
 io_wq_activate_free_worker+0xfa/0x280 io_uring/io-wq.c:267
 io_wq_enqueue+0x262/0x450 io_uring/io-wq.c:914
 io_queue_iowq+0x1d1/0x310 io_uring/io_uring.c:514
 io_queue_sqe_fallback+0x82/0xe0 io_uring/io_uring.c:2084
 io_submit_sqe io_uring/io_uring.c:2305 [inline]
 io_submit_sqes+0xbd3/0xfb0 io_uring/io_uring.c:2420
 __do_sys_io_uring_enter io_uring/io_uring.c:3628 [inline]
 __se_sys_io_uring_enter+0x1f8/0x1c10 io_uring/io_uring.c:3562
 __x64_sys_io_uring_enter+0x78/0x90 io_uring/io_uring.c:3562
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0x0000000d -> 0x0000000b

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 4719 Comm: syz-executor.1 Not tainted 6.5.0-syzkaller-01810-gf97e18a3f2fb #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/26/2023
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
