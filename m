Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16745538C4A
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 09:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244635AbiEaHzg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 03:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244631AbiEaHzf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 03:55:35 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE1AF5B4
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 00:55:34 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id c1-20020a928e01000000b002d1b20aa761so9784751ild.6
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 00:55:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=cxpiXnK1IciwR0g2vIgtdnT2h0baAIafVhqTkrZDzaE=;
        b=wmt4VAhZZlkRWfzvSUHj3Fc/wbjN2eBmh5N9qzFCYgEEchdIeVPdVCYpYMFCkB2sOK
         3HD/1I6K13BTiFknD0YCm7UiRlUFmh/2pjceQeX/3UPJutPhzxfmKqPFexCzvCzxEcdc
         zLN1p7bIzhx9GpwmgSFe4qG9d3HINNbwIQucW8JOZ4cMaWSCfElHmrfUS6GBIV7/w58W
         tLTRdBffeoZKj+ZPVjyYl5ThvTSSG/o5ieU8Chc12QEWNf/DLnKkdU0uveCDz6omJD6x
         cF2dkYPE7Z63tMUksaDyj9858dCAEYQWK3nCbDYhERpl9freKXvblPUNbmXZRSxHYM/X
         MOyA==
X-Gm-Message-State: AOAM5300MiOK9PSzzr0GfTW4QPvzZLdcXYbNDWA2B4iacPB9knJg+DKB
        fkRUiBUdq1H97WSZQ6bu9/0E94eCcd9eXKFfGGbxSawlf9kR
X-Google-Smtp-Source: ABdhPJy7wpZl+xfY5dLEpG1T3xcfxloGUoCPapohjwDNaHJ9S9Y8qeR8R68SlXci3/iDZn2DIeYPq8IGMh6gjv2S2W43m45Zwsl5
MIME-Version: 1.0
X-Received: by 2002:a05:6638:265:b0:32e:7811:af92 with SMTP id
 x5-20020a056638026500b0032e7811af92mr29831212jaq.169.1653983734180; Tue, 31
 May 2022 00:55:34 -0700 (PDT)
Date:   Tue, 31 May 2022 00:55:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f0b26205e04a183b@google.com>
Subject: [syzbot] UBSAN: array-index-out-of-bounds in io_submit_sqes
From:   syzbot <syzbot+b6c9b65b6753d333d833@syzkaller.appspotmail.com>
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

HEAD commit:    3b46e4e44180 Add linux-next specific files for 20220531
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16e151f5f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccb8d66fc9489ef
dashboard link: https://syzkaller.appspot.com/bug?extid=b6c9b65b6753d333d833
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b6c9b65b6753d333d833@syzkaller.appspotmail.com

================================================================================
================================================================================
UBSAN: array-index-out-of-bounds in fs/io_uring.c:8860:19
index 75 is out of range for type 'io_op_def [47]'
CPU: 0 PID: 10377 Comm: syz-executor.4 Not tainted 5.18.0-next-20220531-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 ubsan_epilogue+0xb/0x50 lib/ubsan.c:151
 __ubsan_handle_out_of_bounds.cold+0x62/0x6c lib/ubsan.c:283
 io_init_req fs/io_uring.c:8860 [inline]
 io_submit_sqe fs/io_uring.c:8987 [inline]
 io_submit_sqes+0x6f0e/0x8020 fs/io_uring.c:9143
 __do_sys_io_uring_enter+0x1112/0x2300 fs/io_uring.c:12077
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7fd28ac89109
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd28be25168 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007fd28ad9bf60 RCX: 00007fd28ac89109
RDX: 0000000000000000 RSI: 00000000000001b9 RDI: 0000000000000003
RBP: 00007fd28ace308d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe7683a70f R14: 00007fd28be25300 R15: 0000000000022000
 </TASK>
================================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
