Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18A478BBA7
	for <lists+io-uring@lfdr.de>; Tue, 29 Aug 2023 01:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbjH1Xn2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Aug 2023 19:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbjH1Xm4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Aug 2023 19:42:56 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C51B95;
        Mon, 28 Aug 2023 16:42:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 273A62186E;
        Mon, 28 Aug 2023 23:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1693266171; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WyLuViKwB7yRpzKJOiXJzu2kk1HfpR7YifPRHxHPzIA=;
        b=ouNNcGOYz1WGNu2XCTPHToawqKRzLcdyv78t53NqxpLcsAgO+7IkOJNGCzTwdd4LvNvaxD
        o8nvcPo3DsQgFZolt1ZTp3jWgZvqpv/4NlqOQNQ56EuLmAGEy4nTZhFNNXOkIThSl+LX2p
        kUHSwO9CDKnjQsY4eIRgtLNY6a3QWdM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1693266171;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WyLuViKwB7yRpzKJOiXJzu2kk1HfpR7YifPRHxHPzIA=;
        b=0wvIadsZ8d5FkaX2hFHXLMPVrttrVIDMKB4TqlwXeyYUg72i6mFimVRJ4xWpvqZ1NIdjyA
        gdyZsB8DfGnFVTAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E4069139CC;
        Mon, 28 Aug 2023 23:42:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aVnUMfow7WReWwAAMHmgww
        (envelope-from <krisman@suse.de>); Mon, 28 Aug 2023 23:42:50 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     syzbot <syzbot+c74fea926a78b8a91042@syzkaller.appspotmail.com>
Cc:     asml.silence@gmail.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: [PATCH] io_uring: Don't set affinity on a dying sqpoll thread
In-Reply-To: <000000000000753fbd0603f8c10b@google.com> (syzbot's message of
        "Mon, 28 Aug 2023 02:59:52 -0700")
References: <000000000000753fbd0603f8c10b@google.com>
Date:   Mon, 28 Aug 2023 19:42:49 -0400
Message-ID: <87v8cybuo6.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot <syzbot+c74fea926a78b8a91042@syzkaller.appspotmail.com> writes:

> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    626932085009 Add linux-next specific files for 20230825
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=12a97797a80000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8a8c992a790e5073
> dashboard link: https://syzkaller.appspot.com/bug?extid=c74fea926a78b8a91042
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/46ec18b3c2fb/disk-62693208.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/b4ea0cb78498/vmlinux-62693208.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/5fb3938c7272/bzImage-62693208.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+c74fea926a78b8a91042@syzkaller.appspotmail.com
>
> general protection fault, probably for non-canonical address 0xdffffc000000011d: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x00000000000008e8-0x00000000000008ef]
> CPU: 1 PID: 27342 Comm: syz-executor.5 Not tainted 6.5.0-rc7-next-20230825-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/26/2023
> RIP: 0010:io_sqpoll_wq_cpu_affinity+0x8c/0xe0 io_uring/sqpoll.c:433

Jens,

I'm not sure I got the whole story on this one, but it seems fairly
trivial to reproduce and I can't see another way it could be
triggered. What do you think?

Thanks,

-- >8 --
Subject: [PATCH] io_uring: Don't set affinity on a dying sqpoll thread

Syzbot reported a null-ptr-deref of sqd->thread inside
io_sqpoll_wq_cpu_affinity.  It turns out the sqd->thread can go away
from under us during io_uring_register, in case the process gets a
fatal signal during io_uring_register.

It is not particularly hard to hit the race, and while I am not sure
this is the exact case hit by syzbot, it solves it.  Finally, checking
->thread is enough to close the race because we locked sqd while
"parking" the thread, thus preventing it from going away.

I reproduced it fairly consistently with a program that does:

int main(void) {
  ...
  io_uring_queue_init(RING_LEN, &ring1, IORING_SETUP_SQPOLL);
  while (1) {
    io_uring_register_iowq_aff(ring, 1, &mask);
  }
}

Executed in a loop with timeout to trigger SIGTERM:
  while true; do timeout 1 /a.out ; done

This will hit the following BUG() in very few attempts.

BUG: kernel NULL pointer dereference, address: 00000000000007a8
PGD 800000010e949067 P4D 800000010e949067 PUD 10e46e067 PMD 0
Oops: 0000 [#1] PREEMPT SMP PTI
CPU: 0 PID: 15715 Comm: dead-sqpoll Not tainted 6.5.0-rc7-next-20230825-g193296236fa0-dirty #23
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
RIP: 0010:io_sqpoll_wq_cpu_affinity+0x27/0x70
Code: 90 90 90 0f 1f 44 00 00 55 53 48 8b 9f 98 03 00 00 48 85 db 74 4f
48 89 df 48 89 f5 e8 e2 f8 ff ff 48 8b 43 38 48 85 c0 74 22 <48> 8b b8
a8 07 00 00 48 89 ee e8 ba b1 00 00 48 89 df 89 c5 e8 70
RSP: 0018:ffffb04040ea7e70 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff93c010749e40 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffffffffa7653331 RDI: 00000000ffffffff
RBP: ffffb04040ea7eb8 R08: 0000000000000000 R09: c0000000ffffdfff
R10: ffff93c01141b600 R11: ffffb04040ea7d18 R12: ffff93c00ea74840
R13: 0000000000000011 R14: 0000000000000000 R15: ffff93c00ea74800
FS:  00007fb7c276ab80(0000) GS:ffff93c36f200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000007a8 CR3: 0000000111634003 CR4: 0000000000370ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ? __die_body+0x1a/0x60
 ? page_fault_oops+0x154/0x440
 ? do_user_addr_fault+0x174/0x7b0
 ? exc_page_fault+0x63/0x140
 ? asm_exc_page_fault+0x22/0x30
 ? io_sqpoll_wq_cpu_affinity+0x27/0x70
 __io_register_iowq_aff+0x2b/0x60
 __io_uring_register+0x614/0xa70
 __x64_sys_io_uring_register+0xaa/0x1a0
 do_syscall_64+0x3a/0x90
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8
RIP: 0033:0x7fb7c226fec9
Code: 2e 00 b8 ca 00 00 00 0f 05 eb a5 66 0f 1f 44 00 00 48 89 f8 48 89
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 97 7f 2d 00 f7 d8 64 89 01 48
RSP: 002b:00007ffe2c0674f8 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb7c226fec9
RDX: 00007ffe2c067530 RSI: 0000000000000011 RDI: 0000000000000003
RBP: 00007ffe2c0675d0 R08: 00007ffe2c067550 R09: 00007ffe2c067550
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe2c067750 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
CR2: 00000000000007a8
---[ end trace 0000000000000000 ]---

Reported-by: syzbot+c74fea926a78b8a91042@syzkaller.appspotmail.com
Fixes: ebdfefc09c6d ("io_uring/sqpoll: fix io-wq affinity when IORING_SETUP_SQPOLL is used")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 io_uring/sqpoll.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index ee2d2c687fda..bd6c2c7959a5 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -430,7 +430,9 @@ __cold int io_sqpoll_wq_cpu_affinity(struct io_ring_ctx *ctx,
 
 	if (sqd) {
 		io_sq_thread_park(sqd);
-		ret = io_wq_cpu_affinity(sqd->thread->io_uring, mask);
+		/* Don't set affinity for a dying thread */
+		if (sqd->thread)
+			ret = io_wq_cpu_affinity(sqd->thread->io_uring, mask);
 		io_sq_thread_unpark(sqd);
 	}
 
-- 
2.41.0



