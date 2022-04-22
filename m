Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47DB50B42C
	for <lists+io-uring@lfdr.de>; Fri, 22 Apr 2022 11:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446076AbiDVJiO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 05:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230352AbiDVJiM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 05:38:12 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0A961260A
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 02:35:19 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id g16-20020a05660226d000b00638d8e1828bso4994346ioo.13
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 02:35:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=eJqj+y46Jg4jvSeLYvr2PbyuHx5gaVrCSckNNPhxPV4=;
        b=3Zvl9oGDGLKTKQj9qy/cYdcu7wBXbS9CIDg/QScjs6+Nwc6fWZSI3jsp4FnV8LtaMo
         Sdxuhk/w9fjeM9FK0rK80M9JcGWvtX/LCwtOzxe8jAUWPWOD7joVbjZIA06H2BCHPQzq
         s4b10IUMdLXs7ZpDQ7h+NNlommVqaIS2+Ofe9vD/Q2g6XaTYAibrz9uV7kZnZ0Q/+cex
         lrxrlU4oW6T4eO4S1zcSx6KFYFPrM4vDuU965dmqFMK48jKS6TSs1gPM3eJFsVKsD0LD
         xYGPAfGna6U8PtNt4eadEXzF9JFzOW4Lp7McRqHAS+KbjP84Qb9MB9+CozzcdM5Zb01Z
         ncew==
X-Gm-Message-State: AOAM5333hjAw68jdXtsl341tsDnc5Q2KemK7n6V0/KLt+edc13J5NGYQ
        HQZiUYHaQp0s/I3KJ1apa8RbHAM5LYh48K/L2uLGp9269X4a
X-Google-Smtp-Source: ABdhPJy6ZdJcyIQX7MReO97SecWiSPzDDNnmJYWIpl1AxZBVwUYcFkGe+49W+dV9Akk0Z3SQ396IlGtj1Bzrpn+pWfcB0gU1owFf
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2405:b0:327:d930:bc9c with SMTP id
 z5-20020a056638240500b00327d930bc9cmr1678727jat.70.1650620119126; Fri, 22 Apr
 2022 02:35:19 -0700 (PDT)
Date:   Fri, 22 Apr 2022 02:35:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dc142205dd3af12e@google.com>
Subject: [syzbot] KMSAN: uninit-value in io_fallback_req_func
From:   syzbot <syzbot+5ca552d10251920ab7e2@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, glider@google.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    33d9269ef6e0 Revert "kernel: kmsan: don't instrument stack..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=12a4e62cf00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f8f2668b971cd508
dashboard link: https://syzkaller.appspot.com/bug?extid=5ca552d10251920ab7e2
compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11a2e148f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1332bce8f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5ca552d10251920ab7e2@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in io_fallback_req_func+0x218/0x5f7 fs/io_uring.c:1399
 io_fallback_req_func+0x218/0x5f7 fs/io_uring.c:1399
 process_one_work+0xdb6/0x1820 kernel/workqueue.c:2307
 worker_thread+0x10b3/0x21e0 kernel/workqueue.c:2454
 kthread+0x3c7/0x500 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:737 [inline]
 kmem_cache_alloc_bulk+0xe98/0x1530 mm/slub.c:3744
 __io_alloc_req_refill+0x482/0x867 fs/io_uring.c:2072
 io_alloc_req_refill fs/io_uring.c:2098 [inline]
 io_submit_sqes+0x7d4/0x1a00 fs/io_uring.c:7441
 __do_sys_io_uring_enter fs/io_uring.c:10162 [inline]
 __se_sys_io_uring_enter+0x62f/0x23a0 fs/io_uring.c:10104
 __x64_sys_io_uring_enter+0x19d/0x200 fs/io_uring.c:10104
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:81
 entry_SYSCALL_64_after_hwframe+0x44/0xae

CPU: 0 PID: 3552 Comm: kworker/0:4 Not tainted 5.17.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Comput


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
