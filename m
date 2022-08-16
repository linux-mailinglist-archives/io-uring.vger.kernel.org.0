Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF17595FE2
	for <lists+io-uring@lfdr.de>; Tue, 16 Aug 2022 18:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiHPQLF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Aug 2022 12:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236467AbiHPQKq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Aug 2022 12:10:46 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9CA63204B;
        Tue, 16 Aug 2022 09:10:20 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id p12-20020a7bcc8c000000b003a5360f218fso9637082wma.3;
        Tue, 16 Aug 2022 09:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=VNGeV/c4lH4sYoSOZM8OmJVDymhn+MJK+It11cuEEyU=;
        b=lbX1Ha0KPRd7xdtFmhUNQXCWVe+0LZsby37oTlcs5lG4bFdqh+Y99M8AmKu2q3nouO
         Cd6nyGgs2mwNnzKCoFvD+DYzNoDk/npMI8DnPvRNdPH/RToJzXSATBF40/njPAjR211a
         wfE9cGDD1ADRXdGSJ8O8ptbdQDq1b8XgTQ8sQWHRZRhfAaz90msy6Ba+Xo6jMs+yzdcm
         HrY4yLOuiLgseZSm5LUWjdkOkjP22wtZxZvsb6PYn8CP2LMV8/C/zDB1B6mlxEiDMPxS
         2hcYiz8jyek06I0kvuCt2AkwN11vyKcxPjWE6Au9gwYGLB/7AS/R2GiJHiWrOig++FMZ
         opgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=VNGeV/c4lH4sYoSOZM8OmJVDymhn+MJK+It11cuEEyU=;
        b=c/FQ3eMimm12A7KXJdVu+f6f6ucV0GswWkxCMfmZn4VNZlIhyUlkGPYauVlECyBKkQ
         E/r2LbsheJKkuP2MIQY5TYzGNVgRUylei537WzHeXjyRDfVQOW3lcYNnC5bLxfagNkRY
         CyEfRiNWd/yO9JxKFfnb+PYdd9kiTmXykV4LD2hdNHVFAN3oC//C26c4AgF0ddBwYtfn
         ubZj+SHZoSUMJjtaRcuN83pcuDS+Bev58M6CHDugRcIp9erNkkPX7ZyD+G7EKDeQB7fQ
         BTcw1aaImkR0TdkxZruU9InBr5Sp+Pu5kltDR+TbzProZL538PN6fWA9F6KSpC+/Hup2
         mx/A==
X-Gm-Message-State: ACgBeo3gbf4a7ITCS5m7K0+n8uD/aUgRDHTQnYfknr8IKpTsSOXdVefa
        4ElMyMr7/rwQF6Z/bs/QPKrMMcxK7kXD1XIqEtSzY7HxuLhcsas0
X-Google-Smtp-Source: AA6agR4JRMXCBnDZrj4pN9GqvA30EnYi9QliS53uv5SQuHiU9ZW00Zi/Bg9XJsXUvP6d3Pfu/eoolEgtri31IakzM+E=
X-Received: by 2002:a1c:44d5:0:b0:3a5:4fa3:b260 with SMTP id
 r204-20020a1c44d5000000b003a54fa3b260mr13607481wma.165.1660666218849; Tue, 16
 Aug 2022 09:10:18 -0700 (PDT)
MIME-Version: 1.0
From:   Jiacheng Xu <578001344xu@gmail.com>
Date:   Wed, 17 Aug 2022 00:10:09 +0800
Message-ID: <CAO4S-mdVW5GkODk0+vbQexNAAJZopwzFJ9ACvRCJ989fQ4A6Ow@mail.gmail.com>
Subject: KASAN: null-ptr-deref Write in io_file_get_normal
To:     linux-kernel@vger.kernel.org, axboe@kernel.dk,
        asml.silence@gmail.co
Cc:     io-uring@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_STARTS_WITH_NUMS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

When using modified Syzkaller to fuzz the Linux kernel-5.15.58, the
following crash was triggered.

HEAD commit: 568035b01cfb Linux-5.15.58
git tree: upstream

console output:
https://drive.google.com/file/d/1lW1tGegMXfLgS1gfyWmZShhX7LOx3vFJ/view?usp=sharing
kernel config: https://drive.google.com/file/d/1wgIUDwP5ho29AM-K7HhysSTfWFpfXYkG/view?usp=sharing
syz repro: https://drive.google.com/file/d/13l2TaalviEK6WBoXjF4tAiYfSUmlzstU/view?usp=sharing
C reproducer: https://drive.google.com/file/d/1iHOn1jRiQs4iKxxRTDZcATyJcZlVFQqR/view?usp=sharing

There is a similar problem: https://www.spinics.net/lists/io-uring/msg13047.html

Environment:
Ubuntu 20.04 on Linux 5.4.0
QEMU 4.2.1:
qemu-system-x86_64 \
  -m 2G \
  -smp 2 \
  -kernel /home/workdir/bzImage \
  -append "console=ttyS0 root=/dev/sda earlyprintk=serial net.ifnames=0" \
  -drive file=/home/workdir/stretch.img,format=raw \
  -net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22 \
  -net nic,model=e1000 \
  -enable-kvm \
  -nographic \
  -pidfile vm.pid \
  2>&1 | tee vm.log

If you fix this issue, please add the following tag to the commit:
Reported-by:  Jiacheng Xu<stitch@zju.edu.cn>

==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read_write
include/linux/instrumented.h:101 [inline]
BUG: KASAN: null-ptr-deref in atomic_inc
include/linux/atomic/atomic-instrumented.h:181 [inline]
BUG: KASAN: null-ptr-deref in io_req_track_inflight fs/io_uring.c:1408 [inline]
BUG: KASAN: null-ptr-deref in io_file_get_normal+0x318/0x340 fs/io_uring.c:6934
Write of size 4 at addr 0000000000000118 by task iou-wrk-13680/13681

CPU: 3 PID: 13681 Comm: iou-wrk-13680 Not tainted 5.15.58 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x8b/0xb3 lib/dump_stack.c:106
 __kasan_report mm/kasan/report.c:446 [inline]
 kasan_report.cold+0x66/0xdf mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x14e/0x1b0 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_inc include/linux/atomic/atomic-instrumented.h:181 [inline]
 io_req_track_inflight fs/io_uring.c:1408 [inline]
 io_file_get_normal+0x318/0x340 fs/io_uring.c:6934
 io_file_get fs/io_uring.c:6944 [inline]
 io_tee fs/io_uring.c:4051 [inline]
 io_issue_sqe+0x4ad9/0x7540 fs/io_uring.c:6797
 io_wq_submit_work+0x1bc/0x390 fs/io_uring.c:6863
 io_worker_handle_work+0x97c/0x1710 fs/io-wq.c:576
 io_wqe_worker+0x5b1/0xd30 fs/io-wq.c:630
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>
==================================================================
Kernel panic - not syncing: panic_on_warn set ...
CPU: 2 PID: 13681 Comm: iou-wrk-13680 Tainted: G    B             5.15.58 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x8b/0xb3 lib/dump_stack.c:106
 panic+0x2b0/0x6dd kernel/panic.c:232
 end_report mm/kasan/report.c:128 [inline]
 end_report.cold+0x63/0x6f mm/kasan/report.c:113
 __kasan_report mm/kasan/report.c:449 [inline]
 kasan_report.cold+0x71/0xdf mm/kasan/report.c:459
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x14e/0x1b0 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_inc include/linux/atomic/atomic-instrumented.h:181 [inline]
 io_req_track_inflight fs/io_uring.c:1408 [inline]
 io_file_get_normal+0x318/0x340 fs/io_uring.c:6934
 io_file_get fs/io_uring.c:6944 [inline]
 io_tee fs/io_uring.c:4051 [inline]
 io_issue_sqe+0x4ad9/0x7540 fs/io_uring.c:6797
 io_wq_submit_work+0x1bc/0x390 fs/io_uring.c:6863
 io_worker_handle_work+0x97c/0x1710 fs/io-wq.c:576
 io_wqe_worker+0x5b1/0xd30 fs/io-wq.c:630
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>
