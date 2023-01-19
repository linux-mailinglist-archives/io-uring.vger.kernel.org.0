Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F45B673714
	for <lists+io-uring@lfdr.de>; Thu, 19 Jan 2023 12:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbjASLj3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Jan 2023 06:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjASLi6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Jan 2023 06:38:58 -0500
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D1221A38
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 03:38:01 -0800 (PST)
Received: by mail-qt1-x843.google.com with SMTP id s4so1298086qtx.6
        for <io-uring@vger.kernel.org>; Thu, 19 Jan 2023 03:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IsOTMR428w4RjWmHxlEXCsbcjyACGgotOAMBnayucPs=;
        b=qGSrr5OHBbmzHi/AxTaJIUJgw1E3DKA+4bfabwMjpDIMqoVL409SuehqQ8quaA1KTk
         avetb8LVLTw05Y93vL7g3iMWwkWiJFjqobQ25CcvsXUoMe2T++/XpEil3h450XozH0bu
         qB/bVKsRYScJp9GVQ3NF/kFvHwqpnofAjiQnolax0NZWHHMHKjw5jF8R9wkL8V8bCtgU
         FEEDOEImCUBhEppmnT/NWfL2saTlV6NmG5uiRf49MlIUXsxYYXp0/0ppnMyPEJ3WoldE
         B9q7C9xmgXeY4vhCHdt6MKoU8Jg4Dz+Y1l+QuLBGU1KtR34B6XpJ8NhSz9bre10+HMeJ
         OXoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IsOTMR428w4RjWmHxlEXCsbcjyACGgotOAMBnayucPs=;
        b=P/WDenjrKaJLzY4r3BkVpIa/0p+LCkGZb9ID/9Dg0F1RQX+ei9O4tTMnqMlxlherzE
         hjfVFcYnDdmjb91fv2M6HaLLmhxxKtHdztQWjzUki5KyrakYYVg8AlFXQDSB/E2r9b7M
         RuVHanAm8dBJmBBqu+154/2f94aEAFERCn8sTQ4fb0bFFdW+tZ+r1hOZ4sEWc9ZkL5h4
         pjoR9fvzPiBpHublVvOfG1uW7qdBaWu1smMwSNcAmX6aWmHnUde/JPGPNl8W+/X8prck
         GvwKcpXQTJidCGUa7orXpdDB9fK0x5+ufvkN2xAJ92BQ1eEQ+H88xE3SZ5GFvRTwhsV4
         OXRQ==
X-Gm-Message-State: AFqh2kqaEb6qgFeKM1OyLPUkqZ9iHqY4VKrhZp6z5fx2e0WBGHgX/kyW
        l63JRzqGK994YGi+FMwmFWo=
X-Google-Smtp-Source: AMrXdXsAJRyHjNU7OCpY68h4eIQ5XjvDAmITlWj0cbu38jbfvbRv8ZaQZ3GNqBq9zn75hxIP3ekX1g==
X-Received: by 2002:ac8:5642:0:b0:3a8:11ab:c537 with SMTP id 2-20020ac85642000000b003a811abc537mr13010858qtt.63.1674128280080;
        Thu, 19 Jan 2023 03:38:00 -0800 (PST)
Received: from ip-172-31-85-199.ec2.internal (ec2-44-201-124-83.compute-1.amazonaws.com. [44.201.124.83])
        by smtp.gmail.com with ESMTPSA id o24-20020ac85558000000b003b646a99aa6sm2545783qtr.77.2023.01.19.03.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 03:37:59 -0800 (PST)
Date:   Thu, 19 Jan 2023 19:37:57 +0800
From:   Xingyuan Mo <hdthky0@gmail.com>
To:     axboe@kernel.dk, asml.silence@gmail.com
Cc:     syzkaller@googlegroups.com, io-uring@vger.kernel.org
Subject: WARNING in io_fill_cqe_aux
Message-ID: <Y8krlYa52/0YGqkg@ip-172-31-85-199.ec2.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

Recently, when using our tool to fuzz kernel, the following bug was
triggered.

HEAD commit: 5dc4c995db9e Linux 6.2-rc4
git tree: mainline
compiler: gcc (Ubuntu 10.3.0-1ubuntu1~20.04) 10.3.0
kernel config: https://drive.google.com/file/d/1anGeZxcTgSKNZX4oywvsSfLqw1tcZSTp/view?usp=share_link
C reproducer: https://drive.google.com/file/d/1DxYuWGnFSBhqve-jjXloYhwKpyUm8nDt/view?usp=share_link

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: Xingyuan Mo <hdthky0@gmail.com>

------------[ cut here ]------------
WARNING: CPU: 1 PID: 36200 at io_uring/io_uring.h:108 io_get_cqe_overflow root/linux-6.2-rc4/io_uring/io_uring.h:108 [inline]
WARNING: CPU: 1 PID: 36200 at io_uring/io_uring.h:108 io_get_cqe root/linux-6.2-rc4/io_uring/io_uring.h:125 [inline]
WARNING: CPU: 1 PID: 36200 at io_uring/io_uring.h:108 io_fill_cqe_aux+0x69b/0x840 root/linux-6.2-rc4/io_uring/io_uring.c:832
Modules linked in:
CPU: 1 PID: 36200 Comm: syz-executor.0 Not tainted 6.2.0-rc4 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:io_get_cqe_overflow root/linux-6.2-rc4/io_uring/io_uring.h:108 [inline]
RIP: 0010:io_get_cqe root/linux-6.2-rc4/io_uring/io_uring.h:125 [inline]
RIP: 0010:io_fill_cqe_aux+0x69b/0x840 root/linux-6.2-rc4/io_uring/io_uring.c:832
Code: fd 48 8d bb a8 00 00 00 be ff ff ff ff e8 dd 1b 02 06 31 ff 89 c5 89 c6 e8 c2 76 7e fd 85 ed 0f 85 44 fa ff ff e8 05 7a 7e fd <0f> 0b e9 38 fa ff ff e8 f9 79 7e fd 31 ff 89 ee e8 a0 76 7e fd 85
RSP: 0018:ffffc90015747b68 EFLAGS: 00010212
RAX: 000000000000016e RBX: ffff8881245b6000 RCX: ffffc90013881000
RDX: 0000000000040000 RSI: ffffffff8401f31b RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000000 R15: ffff8881245b6018
FS:  00007fcf02ab4700(0000) GS:ffff888135c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2e024000 CR3: 00000001054e6000 CR4: 0000000000752ee0
PKRU: 55555554
Call Trace:
 <TASK>
 __io_post_aux_cqe root/linux-6.2-rc4/io_uring/io_uring.c:880 [inline]
 io_post_aux_cqe+0x3b/0x90 root/linux-6.2-rc4/io_uring/io_uring.c:890
 io_msg_ring_data root/linux-6.2-rc4/io_uring/msg_ring.c:74 [inline]
 io_msg_ring+0x5b9/0xb70 root/linux-6.2-rc4/io_uring/msg_ring.c:227
 io_issue_sqe+0x6c2/0x1210 root/linux-6.2-rc4/io_uring/io_uring.c:1856
 io_queue_sqe root/linux-6.2-rc4/io_uring/io_uring.c:2028 [inline]
 io_submit_sqe root/linux-6.2-rc4/io_uring/io_uring.c:2286 [inline]
 io_submit_sqes+0x96c/0x1e10 root/linux-6.2-rc4/io_uring/io_uring.c:2397
 __do_sys_io_uring_enter+0xc20/0x2540 root/linux-6.2-rc4/io_uring/io_uring.c:3345
 do_syscall_x64 root/linux-6.2-rc4/arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 root/linux-6.2-rc4/arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fcf01c8f6cd
Code: c3 e8 17 32 00 00 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fcf02ab3bf8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007fcf01dbbf80 RCX: 00007fcf01c8f6cd
RDX: 0000000000000000 RSI: 0000000000007b84 RDI: 0000000000000004
RBP: 00007fcf01cfcb05 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fcf01edfb2f R14: 00007fcf01edfcd0 R15: 00007fcf02ab3d80
 </TASK>
