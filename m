Return-Path: <io-uring+bounces-6727-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 94E7BA4370A
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 09:11:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD5CC188586D
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 08:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0A751DD0E7;
	Tue, 25 Feb 2025 08:10:26 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1ACD214A67
	for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 08:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740471026; cv=none; b=TlG8Czi8Yx7XhTpWl4eEU9DdDpQ1+6EyOgmFpaxQhvCmYrmKFGxRefO/gw3YCzY7W4ZRRJLVdMY/w8pCi+N00l7f7KQhud3mBmdFLh5qJXAkDEMgqI00RkszOuxK4BrWP3pRbMbiLWc5qxsQnxlheK3n6zBxytT8JGNuU9SK3wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740471026; c=relaxed/simple;
	bh=uXlJ/8uX3vH1mAgnAEZX6cLjaJ0/Wc/Prk2XJX5CDQ8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=b3Gc2vr7PIxDovQYBMBYwP9kN2nE1yMNanEpjXLK5NzwkNjFiA67XQZqmJCsZQ76zSU97o8A1NsvN9xxppPX6gb6Mhi92plPK0oD3DVvupx19F2bAtJyPbdm9BjTxrL5z6DUFOzs9AEoYY+fp3nvCuM0aZ9Yu6fRZy1ERxI380o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d05b1ae6e3so44906435ab.0
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 00:10:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740471024; x=1741075824;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oAPT8sSyB+EAkcL0UXOlyTDITtKzKp59XJne9PMGRng=;
        b=Doy1iu/Aja3ZeFwkoPql9om2jjVoTYwEi5hfpAdR/lwMxgthd+vKmnbslkFF+nQV/8
         yxlSH/Iq2k7p3o/WlMjcF1N+OZmpjzmSm+VvhDn12fsNxuLIj4qCDUZP3NXkI84ZOHNS
         qL7735L6VM7U+SeQceoqgS7twz+eotKYzULa00Xwk8hIkBnPuK513Lz6JYJmeAGvXXF8
         v+XxQ9AGZiNqsyN01BhWeuzc8JAjOOPCZuZBT4+aSK802BK2Uzy7UIN8SRGhMxY5V9N9
         ldJle34+EoAKtupa4f6p9/b0c+R6T2QZgmF8NOiW0XB2PXXu9s3l71RNCqnF8rm434hM
         KQLQ==
X-Forwarded-Encrypted: i=1; AJvYcCW62mXohP+5U+vFLOoLZphjpYnvGkHYcC2wKtd9PK1HMpE9dfgyxldBpOr02qHtJ7HeTiDoudA09Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9BeIyDB0Les+F7NsqR6Lk1lN0uJNAnuJVf80IHHGFrVo2HerY
	mC6D8AjWNfqZl26R6PRi9HKPzfs+np9OkjopcC/bcmP1j8vYYhwooFO6Eb7gNaGvsRIaxkpvQ7g
	26KJ+hOd/yNdELL0WQLx/ZuukWz+eFX8ZOKG5wTPwAuPt+UOo+rwAjRs=
X-Google-Smtp-Source: AGHT+IHrjQnUBRkr5I/m8OuD5OeNoV3cV8jABSa/CAmx8uyTY9FivBJR0pFUxPRbl/TNlHa11sO+FkBf8AMhUodQEekJcGQchgMF
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a0c:b0:3d2:b4ea:5f60 with SMTP id
 e9e14a558f8ab-3d2fc0d38a4mr22388945ab.6.1740471024102; Tue, 25 Feb 2025
 00:10:24 -0800 (PST)
Date: Tue, 25 Feb 2025 00:10:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67bd7af0.050a0220.bbfd1.009e.GAE@google.com>
Subject: [syzbot] [io-uring?] [mm?] general protection fault in lock_vma_under_rcu
From: syzbot <syzbot+556fda2d78f9b0daa141@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, asml.silence@gmail.com, axboe@kernel.dk, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	shivankg@amd.com, surenb@google.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e5d3fd687aac Add linux-next specific files for 20250218
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1643b498580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4e945b2fe8e5992f
dashboard link: https://syzkaller.appspot.com/bug?extid=556fda2d78f9b0daa141
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=138207a4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ef079ccd2725/disk-e5d3fd68.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/99f2123d6831/vmlinux-e5d3fd68.xz
kernel image: https://storage.googleapis.com/syzbot-assets/eadfc9520358/bzImage-e5d3fd68.xz

The issue was bisected to:

commit 0670f2f4d6ff1cd6aa351389130ba7bbafb02320
Author: Suren Baghdasaryan <surenb@google.com>
Date:   Thu Feb 13 22:46:49 2025 +0000

    mm: replace vm_lock and detached flag with a reference count

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1355bfdf980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10d5bfdf980000
console output: https://syzkaller.appspot.com/x/log.txt?x=1755bfdf980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+556fda2d78f9b0daa141@syzkaller.appspotmail.com
Fixes: 0670f2f4d6ff ("mm: replace vm_lock and detached flag with a reference count")

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 27018 Comm: syz.1.4414 Not tainted 6.14.0-rc3-next-20250218-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
RIP: 0010:vma_refcount_put include/linux/mm.h:712 [inline]
RIP: 0010:vma_end_read include/linux/mm.h:811 [inline]
RIP: 0010:lock_vma_under_rcu+0x578/0xac0 mm/memory.c:6454
Code: be 5d b1 ff 49 be 00 00 00 00 00 fc ff df 4d 85 ff 74 0d 49 81 ff 01 f0 ff ff 0f 82 a3 02 00 00 49 83 ff f5 0f 85 55 03 00 00 <41> 80 3e 00 74 0a bf 05 00 00 00 e8 28 df 18 00 4c 8b 34 25 05 00
RSP: 0000:ffffc9000b837d80 EFLAGS: 00010246
RAX: fffffffffffffff5 RBX: 0000000000000000 RCX: ffff888079eb8000
RDX: ffff888079eb8000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000b837ed8 R08: ffffffff8210a26a R09: 1ffff110068be328
R10: dffffc0000000000 R11: ffffed10068be329 R12: ffffc9000b837e10
R13: ffff88802890aa20 R14: dffffc0000000000 R15: fffffffffffffff5
FS:  00005555908b1500(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000400000002fc0 CR3: 0000000011df6000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 do_user_addr_fault arch/x86/mm/fault.c:1328 [inline]
 handle_page_fault arch/x86/mm/fault.c:1480 [inline]
 exc_page_fault+0x17b/0x920 arch/x86/mm/fault.c:1538
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0033:0x7f617a954ed8
Code: fc 89 37 c3 c5 fa 6f 06 c5 fa 6f 4c 16 f0 c5 fa 7f 07 c5 fa 7f 4c 17 f0 c3 66 0f 1f 84 00 00 00 00 00 48 8b 4c 16 f8 48 8b 36 <48> 89 37 48 89 4c 17 f8 c3 c5 fe 6f 54 16 e0 c5 fe 6f 5c 16 c0 c5
RSP: 002b:00007ffc20f24718 EFLAGS: 00010246
RAX: 0000400000002fc0 RBX: 0000000000000004 RCX: 0031313230386c6e
RDX: 0000000000000008 RSI: 0031313230386c6e RDI: 0000400000002fc0
RBP: 0000000000000000 R08: 00007f617a800000 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000009 R12: 00007f617aba5fac
R13: 00007f617aba5fa0 R14: fffffffffffffffe R15: 0000000000000006
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:vma_refcount_put include/linux/mm.h:712 [inline]
RIP: 0010:vma_end_read include/linux/mm.h:811 [inline]
RIP: 0010:lock_vma_under_rcu+0x578/0xac0 mm/memory.c:6454
Code: be 5d b1 ff 49 be 00 00 00 00 00 fc ff df 4d 85 ff 74 0d 49 81 ff 01 f0 ff ff 0f 82 a3 02 00 00 49 83 ff f5 0f 85 55 03 00 00 <41> 80 3e 00 74 0a bf 05 00 00 00 e8 28 df 18 00 4c 8b 34 25 05 00
RSP: 0000:ffffc9000b837d80 EFLAGS: 00010246
RAX: fffffffffffffff5 RBX: 0000000000000000 RCX: ffff888079eb8000
RDX: ffff888079eb8000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000b837ed8 R08: ffffffff8210a26a R09: 1ffff110068be328
R10: dffffc0000000000 R11: ffffed10068be329 R12: ffffc9000b837e10
R13: ffff88802890aa20 R14: dffffc0000000000 R15: fffffffffffffff5
FS:  00005555908b1500(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff182f3cf98 CR3: 0000000011df6000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	5d                   	pop    %rbp
   1:	b1 ff                	mov    $0xff,%cl
   3:	49 be 00 00 00 00 00 	movabs $0xdffffc0000000000,%r14
   a:	fc ff df
   d:	4d 85 ff             	test   %r15,%r15
  10:	74 0d                	je     0x1f
  12:	49 81 ff 01 f0 ff ff 	cmp    $0xfffffffffffff001,%r15
  19:	0f 82 a3 02 00 00    	jb     0x2c2
  1f:	49 83 ff f5          	cmp    $0xfffffffffffffff5,%r15
  23:	0f 85 55 03 00 00    	jne    0x37e
* 29:	41 80 3e 00          	cmpb   $0x0,(%r14) <-- trapping instruction
  2d:	74 0a                	je     0x39
  2f:	bf 05 00 00 00       	mov    $0x5,%edi
  34:	e8 28 df 18 00       	call   0x18df61
  39:	4c                   	rex.WR
  3a:	8b                   	.byte 0x8b
  3b:	34 25                	xor    $0x25,%al
  3d:	05                   	.byte 0x5


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

