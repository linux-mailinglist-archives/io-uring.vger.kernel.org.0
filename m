Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D97B693849
	for <lists+io-uring@lfdr.de>; Sun, 12 Feb 2023 17:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjBLQE2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Feb 2023 11:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBLQE2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Feb 2023 11:04:28 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5833E11669
        for <io-uring@vger.kernel.org>; Sun, 12 Feb 2023 08:04:27 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id s12-20020a056e021a0c00b0030efd0ed890so7940842ild.7
        for <io-uring@vger.kernel.org>; Sun, 12 Feb 2023 08:04:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uMdw4VNjkKTcp+sBTw6KN6DXlJ7EWhurhuyywUlLZ0s=;
        b=aHz0GnCPgDdsxmUdIOW6exCeovGpg332ZPTnuWUzQBPQXI1TIsIaeT+7J/b979HfX1
         MMt0VdeEttiIXzBzS1zi89h1l9aDjmpsybLXyQNVWKA5fg/Qvkgj4lCjjRnW+lKBBsdl
         Lqi4d75pEY+rHTWG8UzJjt8PkWYsEwmL9gtxaseI0j5xoktlDoYwxqv3+XbwjgTk8YTd
         +53Oc9RniqQY887+eSmwQCbia/1tfFzPSB9SfUu5O/6T6RShbkRuTXq5yrDFLPnK8fG/
         et7UHVeoBfxldn+AApSEwoD92tB52jozUrXscFjOzhMYc/7g9dDc1K/Id2N9HxmeikI1
         LHwQ==
X-Gm-Message-State: AO0yUKXaUEFGs2v+doPSM738p2e8YWiKiJcJ/rpthRps7g7YJ4FX1r3P
        LyhtsWwyT5wAWOd4kFBgOj1xsic7SCf4oS+Bk6vhFwuHPkrG
X-Google-Smtp-Source: AK7set8C7eOycha6Ttc3nwbfME05mwAqy7SvHEBO10twvw3kXJiXqj6V/JSxp46HxPZwwNDInj8vq17cBx/4POup3ry2DVB0gSW0
MIME-Version: 1.0
X-Received: by 2002:a92:1811:0:b0:313:c7f2:40be with SMTP id
 17-20020a921811000000b00313c7f240bemr12770410ily.26.1676217866477; Sun, 12
 Feb 2023 08:04:26 -0800 (PST)
Date:   Sun, 12 Feb 2023 08:04:26 -0800
In-Reply-To: <9552a45f-6a26-e7fa-aa63-3c74a7d17261@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007f69b605f482e2ee@google.com>
Subject: Re: [syzbot] BUG: bad usercopy in io_openat2_prep
From:   syzbot <syzbot+cdd9922704fc75e03ffc@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, kees@kernel.org, keescook@chromium.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
BUG: bad usercopy in io_openat2_prep

usercopy: Kernel memory overwrite attempt detected to SLUB object 'pid' (offset 24, size 24)!
------------[ cut here ]------------
kernel BUG at mm/usercopy.c:102!
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 4995 Comm: syz-executor.0 Not tainted 6.2.0-rc6-syzkaller-00050-gfbe870a72fd1 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/21/2023
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : usercopy_abort+0x90/0x94
lr : usercopy_abort+0x90/0x94
sp : ffff800012dd3be0
x29: ffff800012dd3bf0 x28: 000000000000001c x27: ffff0000d0e13400
x26: 00000000200000c0 x25: ffff80000cf51000 x24: fffffc0000000000
x23: 05ffc00000000200 x22: fffffc0003108280 x21: ffff0000c420a118
x20: 0000000000000000 x19: 0000000000000018 x18: 0000000000000000
x17: 0000000000000000 x16: ffff0000d0e13df8 x15: ffff80000dbd1118
x14: ffff0000d0e13400 x13: 00000000ffffffff x12: ffff0000d0e13400
x11: ff808000081bd5b0 x10: 0000000000000000 x9 : 4c3aa38d2e853f00
x8 : 4c3aa38d2e853f00 x7 : ffff800008162dbc x6 : 0000000000000000
x5 : 0000000000000080 x4 : 0000000000000001 x3 : 0000000000000000
x2 : ffff0001fefbff08 x1 : 0000000100000000 x0 : 000000000000005d
Call trace:
 usercopy_abort+0x90/0x94
 __check_heap_object+0xa8/0x100
 __check_object_size+0x208/0x6b8
 io_openat2_prep+0xcc/0x2f0
 io_submit_sqes+0x330/0xba8
 __arm64_sys_io_uring_enter+0x168/0x9b0
 invoke_syscall+0x64/0x178
 el0_svc_common+0xbc/0x180
 do_el0_svc+0x48/0x150
 el0_svc+0x58/0x14c
 el0t_64_sync_handler+0x84/0xf0
 el0t_64_sync+0x190/0x194
Code: 911d2800 aa0903e1 f90003e8 94e6d3da (d4210000) 
---[ end trace 0000000000000000 ]---


Tested on:

commit:         fbe870a7 io_uring,audit: don't log IORING_OP_MADVISE
git tree:       https://git.kernel.dk/linux.git for-6.3/io_uring
console output: https://syzkaller.appspot.com/x/log.txt?x=17241257480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=22fc000172595f28
dashboard link: https://syzkaller.appspot.com/bug?extid=cdd9922704fc75e03ffc
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64

Note: no patches were applied.
