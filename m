Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F132907E8
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 17:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409688AbgJPPCc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Fri, 16 Oct 2020 11:02:32 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:58651 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2409671AbgJPPCc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 11:02:32 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-Zr93FOkDPlGdmAsYydw_Cw-1; Fri, 16 Oct 2020 11:02:26 -0400
X-MC-Unique: Zr93FOkDPlGdmAsYydw_Cw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 201BF1084C86;
        Fri, 16 Oct 2020 15:02:25 +0000 (UTC)
Received: from ovpn-112-203.rdu2.redhat.com (ovpn-112-203.rdu2.redhat.com [10.10.112.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 024056EF7B;
        Fri, 16 Oct 2020 15:02:23 +0000 (UTC)
Message-ID: <a7cac632aa89ed30c5c6deb9c67f428810aed9cb.camel@lca.pw>
Subject: Re: WARNING: suspicious RCU usage in io_init_identity
From:   Qian Cai <cai@lca.pw>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk,
        syzbot <syzbot+4596e1fcf98efa7d1745@syzkaller.appspotmail.com>
Date:   Fri, 16 Oct 2020 11:02:23 -0400
In-Reply-To: <00000000000010295205b1c553d5@google.com>
References: <00000000000010295205b1c553d5@google.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=cai@lca.pw
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lca.pw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 2020-10-16 at 01:12 -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b2926c10 Add linux-next specific files for 20201016
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=12fc877f900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=6160209582f55fb1
> dashboard link: https://syzkaller.appspot.com/bug?extid=4596e1fcf98efa7d1745
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+4596e1fcf98efa7d1745@syzkaller.appspotmail.com
> 
> =============================
> WARNING: suspicious RCU usage
> 5.9.0-next-20201016-syzkaller #0 Not tainted
> -----------------------------
> include/linux/cgroup.h:494 suspicious rcu_dereference_check() usage!

Introduced by the linux-next commits:

07950f53f85b ("io_uring: COW io_identity on mismatch")

Can't find the patchset was posted anywhere. Anyway, this should fix it? 

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1049,7 +1049,9 @@ static void io_init_identity(struct io_identity *id)
        id->files = current->files;
        id->mm = current->mm;
 #ifdef CONFIG_BLK_CGROUP
+       rcu_read_lock();
        id->blkcg_css = blkcg_css();
+       rcu_read_unlock();
 #endif
        id->creds = current_cred();
        id->nsproxy = current->nsproxy;

> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 2, debug_locks = 1
> no locks held by syz-executor.0/8301.
> 
> stack backtrace:
> CPU: 0 PID: 8301 Comm: syz-executor.0 Not tainted 5.9.0-next-20201016-
> syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google
> 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x198/0x1fb lib/dump_stack.c:118
>  task_css include/linux/cgroup.h:494 [inline]
>  blkcg_css include/linux/blk-cgroup.h:224 [inline]
>  blkcg_css include/linux/blk-cgroup.h:217 [inline]
>  io_init_identity+0x3a9/0x450 fs/io_uring.c:1052
>  io_uring_alloc_task_context+0x176/0x250 fs/io_uring.c:7730
>  io_uring_add_task_file+0x10d/0x180 fs/io_uring.c:8653
>  io_uring_get_fd fs/io_uring.c:9144 [inline]
>  io_uring_create fs/io_uring.c:9308 [inline]
>  io_uring_setup+0x2727/0x3660 fs/io_uring.c:9342
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45de59
> Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48
> 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f
> 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f7e11fe1bf8 EFLAGS: 00000206 ORIG_RAX: 00000000000001a9
> RAX: ffffffffffffffda RBX: 0000000020000080 RCX: 000000000045de59
> RDX: 00000000206d4000 RSI: 0000000020000080 RDI: 0000000000000087
> RBP: 000000000118c020 R08: 0000000020000040 R09: 0000000020000040
> R10: 0000000020000000 R11: 0000000000000206 R12: 00000000206d4000
> R13: 0000000020ee7000 R14: 0000000020000040 R15: 0000000020000000
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

