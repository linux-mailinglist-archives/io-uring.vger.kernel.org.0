Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2CB5AE966
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 15:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239964AbiIFNWe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Sep 2022 09:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbiIFNWe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Sep 2022 09:22:34 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A20402E1
        for <io-uring@vger.kernel.org>; Tue,  6 Sep 2022 06:22:32 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id bf4-20020a056602368400b0068baaa4f99bso6709841iob.3
        for <io-uring@vger.kernel.org>; Tue, 06 Sep 2022 06:22:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=k7QWw2QHO0H3mOKLS7XQj1IGVFb2UQKAqmEs/aBD0Dk=;
        b=FoiyGekvdafjQjmTdWB4L1Oo3S/A6GFUq8U1gvLpn3qq0gNPzRjgofk4NzC1hL3eR/
         Muu5SAgRoGRFUmkhy/X40vxOwRVqaEZu/gMvbNK2tQwNi4ejbyQaU0G7C+fwq5jsc06w
         Ps/aSUIe6XDSWWfbro61t3Ux/xvBnNd53fCTSnHbyGR4OOt/2UwM5F1YNiu2vkN2VsRM
         POlI4f69Zq5/R11ESr7na6GJlaLGtkZW4ULiuBdMDDgAem2lHMe3G/FqQowCjuobrgjK
         ODn87nC5Rq8fS6v90sho1Nwuatz7zHK3VtS6owJsJXxt7LaNJmN3yOoMFonU3YwN/AyA
         pv+g==
X-Gm-Message-State: ACgBeo0X1gUjLUlPSMbz178DWKayVnC2M4bwaJyhJGR/JOaf/9l+8vlE
        tq6xVXyZJApYwEnvoErqxtJVwL25O4JSvbN6CkueaZKm3nYp
X-Google-Smtp-Source: AA6agR4qlFnIjDVaJHjvxi34jyClkHd1wenKq1EIYpkvdrpRgT/xP9bugSu7jJ8oIqR5rcfrAxrqfM6ff0Zg+TtecMDDMGepNWu/
MIME-Version: 1.0
X-Received: by 2002:a05:6638:378f:b0:356:4966:9b7b with SMTP id
 w15-20020a056638378f00b0035649669b7bmr2296530jal.103.1662470552354; Tue, 06
 Sep 2022 06:22:32 -0700 (PDT)
Date:   Tue, 06 Sep 2022 06:22:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b9066905e802163a@google.com>
Subject: [syzbot] KMSAN: uninit-value in io_req_cqe_overflow
From:   syzbot <syzbot+12dde80bf174ac8ae285@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, glider@google.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
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

HEAD commit:    ac3859c02d7f block: kmsan: skip bio block merging logic fo..
git tree:       https://github.com/google/kmsan.git master
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1394e48b080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8e64bc5364a1307e
dashboard link: https://syzkaller.appspot.com/bug?extid=12dde80bf174ac8ae285
compiler:       clang version 15.0.0 (https://github.com/llvm/llvm-project.git 610139d2d9ce6746b3c617fb3e2f7886272d26ff), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12cb6983080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17744fbd080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+12dde80bf174ac8ae285@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in io_req_cqe_overflow+0x1f8/0x220 io_uring/io_uring.c:687
 io_req_cqe_overflow+0x1f8/0x220 io_uring/io_uring.c:687
 __io_fill_cqe_req+0x4ad/0x830 io_uring/io_uring.h:121
 __io_submit_flush_completions io_uring/io_uring.c:1192 [inline]
 io_submit_flush_completions+0x11c/0x390 io_uring/io_uring.c:166
 io_submit_state_end io_uring/io_uring.c:2025 [inline]
 io_submit_sqes+0x7d3/0xd50 io_uring/io_uring.c:2137
 __do_sys_io_uring_enter io_uring/io_uring.c:3053 [inline]
 __se_sys_io_uring_enter+0x597/0x1d30 io_uring/io_uring.c:2983
 __x64_sys_io_uring_enter+0x117/0x190 io_uring/io_uring.c:2983
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was stored to memory at:
 io_req_set_res io_uring/io_uring.h:156 [inline]
 io_recv_finish io_uring/net.c:537 [inline]
 io_recv+0x18ee/0x1d00 io_uring/net.c:845
 io_issue_sqe+0x3b1/0x11d0 io_uring/io_uring.c:1576
 io_queue_sqe io_uring/io_uring.c:1753 [inline]
 io_submit_sqe+0xb40/0x1be0 io_uring/io_uring.c:2011
 io_submit_sqes+0x542/0xd50 io_uring/io_uring.c:2122
 __do_sys_io_uring_enter io_uring/io_uring.c:3053 [inline]
 __se_sys_io_uring_enter+0x597/0x1d30 io_uring/io_uring.c:2983
 __x64_sys_io_uring_enter+0x117/0x190 io_uring/io_uring.c:2983
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Local variable msg created at:
 io_recv+0x4b/0x1d00 io_uring/net.c:763
 io_issue_sqe+0x3b1/0x11d0 io_uring/io_uring.c:1576

CPU: 0 PID: 3487 Comm: syz-executor126 Not tainted 6.0.0-rc2-syzkaller-47461-gac3859c02d7f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
