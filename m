Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 100344EDF20
	for <lists+io-uring@lfdr.de>; Thu, 31 Mar 2022 18:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240254AbiCaQyK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 31 Mar 2022 12:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240253AbiCaQyJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 31 Mar 2022 12:54:09 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BAE9231AD3
        for <io-uring@vger.kernel.org>; Thu, 31 Mar 2022 09:52:22 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id u15-20020a92da8f000000b002c863d2f21dso148167iln.15
        for <io-uring@vger.kernel.org>; Thu, 31 Mar 2022 09:52:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=GaMCx1IhBeV8JT6zBDL6Q97AOSbpyw9US2EP5xW97F4=;
        b=Bnv5rf7mHQq46nIn5jTzuUSffhbAI39/+nFl3TtHS5edjr3tigXp71nHmLRy5dai1U
         0v3RPncoNsPhVbTe1935qmU7hyS8pDY3jOLWwD62XzLt3kjfxcBDhK8B2UX+ZvAWvzzU
         OyHHMG3yLwa8TL4tb1Ye5PiUq4MPJ5sqiSTih4UTixlKUSYJVyaQLTwe1Sy2q0IrEEA8
         sMtsbtvWbFZFV4B7fy7QjV0zeyjlS07OJk17a7Cioo7L/iZ9QUOfvKTAkZHPkP3gQXcl
         xTBYft2f4roVJGdKVfgqBkeHG2sfNEKiQ56/RNrvpYSi5ZvlayvW91sUrQYCZjfLtvgV
         7mrg==
X-Gm-Message-State: AOAM530PsRw4jsZ3nHnzWM/YFIfplN891LHGqqBLJK7bQ4ai9I9YptRI
        RiC95Sxo5crXkaytM5lfJqe1JLXG+7IQkOhSiPaOdmpFuA7d
X-Google-Smtp-Source: ABdhPJwSBtmVHolwvqSVt7vHpCPsvlmQijiwmEY1yUfFY4rB9xmEQsRvhlazLDm2pxGm9Tm3ml0N6hsQTkZ4zBotXshAPPSQtnMU
MIME-Version: 1.0
X-Received: by 2002:a5d:9249:0:b0:64c:8a57:b7ec with SMTP id
 e9-20020a5d9249000000b0064c8a57b7ecmr8780372iol.65.1648745541581; Thu, 31 Mar
 2022 09:52:21 -0700 (PDT)
Date:   Thu, 31 Mar 2022 09:52:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000054c03905db867c20@google.com>
Subject: [syzbot] KASAN: null-ptr-deref Write in io_file_get_normal
From:   syzbot <syzbot+c4b9303500a21750b250@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fdcbcd1348f4 Add linux-next specific files for 20220331
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1146e5fd700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=366ab475940a4177
dashboard link: https://syzkaller.appspot.com/bug?extid=c4b9303500a21750b250
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1434c99b700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1623e2f7700000

The issue was bisected to:

commit c686f7a5cbe2eff3c9b41f225fb7cf9e163cde5c
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Mar 29 16:59:20 2022 +0000

    io_uring: defer splice/tee file validity check until command issue

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12b0199b700000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11b0199b700000
console output: https://syzkaller.appspot.com/x/log.txt?x=16b0199b700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c4b9303500a21750b250@syzkaller.appspotmail.com
Fixes: c686f7a5cbe2 ("io_uring: defer splice/tee file validity check until command issue")

==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: null-ptr-deref in atomic_inc include/linux/atomic/atomic-instrumented.h:190 [inline]
BUG: KASAN: null-ptr-deref in io_req_track_inflight fs/io_uring.c:1648 [inline]
BUG: KASAN: null-ptr-deref in io_file_get_normal+0x33e/0x380 fs/io_uring.c:7518
Write of size 4 at addr 0000000000000118 by task iou-wrk-3588/3589

CPU: 1 PID: 3589 Comm: iou-wrk-3588 Not tainted 5.17.0-next-20220331-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_report mm/kasan/report.c:432 [inline]
 kasan_report.cold+0x61/0x1c6 mm/kasan/report.c:491
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_inc include/linux/atomic/atomic-instrumented.h:190 [inline]
 io_req_track_inflight fs/io_uring.c:1648 [inline]
 io_file_get_normal+0x33e/0x380 fs/io_uring.c:7518
 io_file_get fs/io_uring.c:7528 [inline]
 io_tee fs/io_uring.c:4401 [inline]
 io_issue_sqe+0x45f5/0x8f40 fs/io_uring.c:7354
 io_wq_submit_work+0x2b6/0x770 fs/io_uring.c:7444
 io_worker_handle_work+0xb1c/0x1ab0 fs/io-wq.c:597
 io_wqe_worker+0x637/0xdb0 fs/io-wq.c:644
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>
==================================================================
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 3589 Comm: iou-wrk-3588 Not tainted 5.17.0-next-20220331-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 panic+0x2d7/0x636 kernel/panic.c:274
 end_report.part.0+0x3f/0x7c mm/kasan/report.c:168
 end_report include/trace/events/error_report.h:69 [inline]
 kasan_report.cold+0x93/0x1c6 mm/kasan/report.c:493
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_inc include/linux/atomic/atomic-instrumented.h:190 [inline]
 io_req_track_inflight fs/io_uring.c:1648 [inline]
 io_file_get_normal+0x33e/0x380 fs/io_uring.c:7518
 io_file_get fs/io_uring.c:7528 [inline]
 io_tee fs/io_uring.c:4401 [inline]
 io_issue_sqe+0x45f5/0x8f40 fs/io_uring.c:7354
 io_wq_submit_work+0x2b6/0x770 fs/io_uring.c:7444
 io_worker_handle_work+0xb1c/0x1ab0 fs/io-wq.c:597
 io_wqe_worker+0x637/0xdb0 fs/io-wq.c:644
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
