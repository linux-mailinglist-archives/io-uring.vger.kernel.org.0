Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 448256EC6E5
	for <lists+io-uring@lfdr.de>; Mon, 24 Apr 2023 09:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbjDXHTw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Apr 2023 03:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231307AbjDXHTs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Apr 2023 03:19:48 -0400
Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9706410EC
        for <io-uring@vger.kernel.org>; Mon, 24 Apr 2023 00:19:46 -0700 (PDT)
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-7636c775952so342817639f.2
        for <io-uring@vger.kernel.org>; Mon, 24 Apr 2023 00:19:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682320786; x=1684912786;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FLByx+tb5N9xClS/DsZomBGA1slNzifZFIuUWr6Dpl4=;
        b=KR3ZKHSqmAvlYvtmnemaxMTWU8eX9h95Pvr+aG3hSxcaBL50cUUwSDdce2afhlT9V2
         rTOgw2U6U5JptTaJnWEURpxY7SMxU2Qpn6rMM91xSdYw/VcYD1+U5pxILT9vVqa8zuSP
         L5B2ukyaWsbzku6Wxwj8/e+6gqHns26ofccDw9oSI5Qw4SiVuEDYVHgrD9h4IY/g0Y1Z
         Ey739WcvdWQiMS9LDq3lUq4va939GrxyY/0IA8nlXHv2cB5qZPZpIdMFk3/JIbgiw01e
         etgT9wR0n6YW7pdYw47L7U8TqKV5wrbNnYmHX+aRpydExhtGo2bpYUqCwmy/XZcW+HdH
         zmGQ==
X-Gm-Message-State: AAQBX9dS9mqVgO3K9SBeBnvq2PsnKpBTU8fYOZPtzcfepGjq1wvVB3jX
        HTfyP0i+PQCuRHZZDhdLlL8T4jqbRHkFFXum1qyWzArZxbN7
X-Google-Smtp-Source: AKy350aVSc244kB95vKtt8mVPnmPoRok02FVSpXWyEUhaf0BU4Up28CYBn94FlLM/st5rdqmCdZGccWf7aiRpNP+Gg/m8G2shHFx
MIME-Version: 1.0
X-Received: by 2002:a5d:9703:0:b0:762:e1f2:3ec3 with SMTP id
 h3-20020a5d9703000000b00762e1f23ec3mr3903854iol.1.1682320785898; Mon, 24 Apr
 2023 00:19:45 -0700 (PDT)
Date:   Mon, 24 Apr 2023 00:19:45 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d7848305fa0fd413@google.com>
Subject: [syzbot] [io-uring?] KCSAN: data-race in __io_fill_cqe_req / io_timeout
From:   syzbot <syzbot+cb265db2f3f3468ef436@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    3a93e40326c8 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1280071ec80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f7350c77b8056a38
dashboard link: https://syzkaller.appspot.com/bug?extid=cb265db2f3f3468ef436
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2122926bc9fe/disk-3a93e403.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8392992358bc/vmlinux-3a93e403.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6398a2d19a7e/bzImage-3a93e403.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cb265db2f3f3468ef436@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in __io_fill_cqe_req / io_timeout

read-write to 0xffff888108bf8310 of 4 bytes by task 20447 on cpu 0:
 io_get_cqe_overflow io_uring/io_uring.h:112 [inline]
 io_get_cqe io_uring/io_uring.h:124 [inline]
 __io_fill_cqe_req+0x6c/0x4d0 io_uring/io_uring.h:137
 io_fill_cqe_req io_uring/io_uring.h:165 [inline]
 __io_req_complete_post+0x67/0x790 io_uring/io_uring.c:969
 io_req_complete_post io_uring/io_uring.c:1006 [inline]
 io_req_task_complete+0xb9/0x110 io_uring/io_uring.c:1654
 handle_tw_list io_uring/io_uring.c:1184 [inline]
 tctx_task_work+0x1fe/0x4d0 io_uring/io_uring.c:1246
 task_work_run+0x123/0x160 kernel/task_work.c:179
 get_signal+0xe5c/0xfe0 kernel/signal.c:2635
 arch_do_signal_or_restart+0x89/0x2b0 arch/x86/kernel/signal.c:306
 exit_to_user_mode_loop+0x6d/0xe0 kernel/entry/common.c:168
 exit_to_user_mode_prepare+0x6a/0xa0 kernel/entry/common.c:204
 __syscall_exit_to_user_mode_work kernel/entry/common.c:286 [inline]
 syscall_exit_to_user_mode+0x26/0x140 kernel/entry/common.c:297
 do_syscall_64+0x4d/0xc0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

read to 0xffff888108bf8310 of 4 bytes by task 20448 on cpu 1:
 io_timeout+0x88/0x270 io_uring/timeout.c:546
 io_issue_sqe+0x147/0x660 io_uring/io_uring.c:1907
 io_queue_sqe io_uring/io_uring.c:2079 [inline]
 io_submit_sqe io_uring/io_uring.c:2340 [inline]
 io_submit_sqes+0x689/0xfe0 io_uring/io_uring.c:2450
 __do_sys_io_uring_enter io_uring/io_uring.c:3458 [inline]
 __se_sys_io_uring_enter+0x1e5/0x1b70 io_uring/io_uring.c:3392
 __x64_sys_io_uring_enter+0x78/0x90 io_uring/io_uring.c:3392
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0x00000c75 -> 0x00000c76

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 20448 Comm: syz-executor.2 Not tainted 6.3.0-rc4-syzkaller-00025-g3a93e40326c8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
