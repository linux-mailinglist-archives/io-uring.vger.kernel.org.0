Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04E367A0A3B
	for <lists+io-uring@lfdr.de>; Thu, 14 Sep 2023 18:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241373AbjINQEx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Sep 2023 12:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241300AbjINQEw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Sep 2023 12:04:52 -0400
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9781BDD
        for <io-uring@vger.kernel.org>; Thu, 14 Sep 2023 09:04:48 -0700 (PDT)
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3ab7fb11711so1561391b6e.2
        for <io-uring@vger.kernel.org>; Thu, 14 Sep 2023 09:04:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694707487; x=1695312287;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZNdUoJwIRehdPwgJQ6H5/eO4Vgm7GeU3hjbHHkOa5/E=;
        b=nBNQIgeGJi4JKQKBGF/Lgb7b1bdHq8XEuC9IAShRwNqmnQYr0AQlZ16wvLRCUVVSHS
         vZO5kf+rI0Qk1xUedQXz5ACG0KjayAuPhlGmcXDF9TQ7hBFGYl4qsIF8JRX7lFZZtBBh
         HGOwgMDZUr4qzKQv48ZBxecPz9dbQtXtoOZ0y+7ERVqmp6tiLABkzOodax/t46EcmsdQ
         1s5bQqOAylPHsBYnTH7v2geW4uWA3L0PoFLPq3MrvwLos5+uU2RA692g2NJjIi6eFTxe
         ZVsyNEf4uZDSpGxddMq6efJQShj+UANeCcFbinN4UOPTZZzVwRHougWpPkoIdU12UItB
         igeg==
X-Gm-Message-State: AOJu0Yzqd7sf4DGutMEYbAikYLV8KllFN5bCgkY6q5m97fm3PS1WfwCV
        h6JV0Iw1oswuhtNxJheRXJoN+jn0UMaIZys43tbgI5UbeHTc
X-Google-Smtp-Source: AGHT+IEDQtk73BIjie3qKGhsS3SlJkwNzsTIbJrHEDur23i7MA6UdvEoFBJnJLDhca2eLJO0edH5ljH5HcFw7e3vZNXEd6fSoRHH
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1893:b0:3a8:4895:63e1 with SMTP id
 bi19-20020a056808189300b003a8489563e1mr2724583oib.5.1694707487793; Thu, 14
 Sep 2023 09:04:47 -0700 (PDT)
Date:   Thu, 14 Sep 2023 09:04:47 -0700
In-Reply-To: <d1285714-a6ad-688a-1adf-6a41771aa301@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cee844060553d536@google.com>
Subject: Re: [syzbot] [io-uring?] UBSAN: array-index-out-of-bounds in io_setup_async_msg
From:   syzbot <syzbot+a4c6e5ef999b68b26ed1@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
UBSAN: array-index-out-of-bounds in io_setup_async_msg

================================================================================
UBSAN: array-index-out-of-bounds in io_uring/net.c:189:55
index 3779565697114 is out of range for type 'iovec [8]'
CPU: 1 PID: 5467 Comm: syz-executor.0 Not tainted 6.6.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/04/2023
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x125/0x1b0 lib/dump_stack.c:106
 ubsan_epilogue lib/ubsan.c:217 [inline]
 __ubsan_handle_out_of_bounds+0x111/0x150 lib/ubsan.c:348
 io_setup_async_msg+0x2a0/0x2b0 io_uring/net.c:189
 io_recvmsg+0x169f/0x2170 io_uring/net.c:781
 io_issue_sqe+0x54a/0xd80 io_uring/io_uring.c:1878
 io_queue_sqe io_uring/io_uring.c:2063 [inline]
 io_submit_sqe io_uring/io_uring.c:2323 [inline]
 io_submit_sqes+0x96c/0x1ed0 io_uring/io_uring.c:2438
 __do_sys_io_uring_enter+0x14ea/0x2650 io_uring/io_uring.c:3647
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f9a8a27cae9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 20 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9a8af210c8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007f9a8a39bf80 RCX: 00007f9a8a27cae9
RDX: 0000000000000000 RSI: 0000000000007689 RDI: 0000000000000003
RBP: 00007f9a8a2c847a R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000000b R14: 00007f9a8a39bf80 R15: 00007ffd083c1e58
 </TASK>
================================================================================


Tested on:

commit:         0bb80ecc Linux 6.6-rc1
git tree:       https://github.com/isilence/linux.git syz-test/netmsg-init-base
console output: https://syzkaller.appspot.com/x/log.txt?x=15ccbf30680000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f4894cf58531f
dashboard link: https://syzkaller.appspot.com/bug?extid=a4c6e5ef999b68b26ed1
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
