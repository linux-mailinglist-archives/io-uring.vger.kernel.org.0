Return-Path: <io-uring+bounces-13511-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WHTUMcqUFmppngcAu9opvQ
	(envelope-from <io-uring+bounces-13511-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 08:52:58 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EEF05E00A0
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 08:52:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 376413003998
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 06:52:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4D223B52E6;
	Wed, 27 May 2026 06:52:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4496230569E
	for <io-uring@vger.kernel.org>; Wed, 27 May 2026 06:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779864747; cv=none; b=Svc9UlT2fG92Z6GcDuuevh7d7UyFseMCBy1DW+M+eLI3vZZfresHSYJ8CQr3fDMG3YI8DQYVcrQT/4XL1+gI+joKtFZePKr/GFTuktfjM16zw0Mu86U0OQfCnzpuytQnaYxYzo3cPdafC7g4ApwRl5wbFQMQmiKukbiI2h56bPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779864747; c=relaxed/simple;
	bh=NuLaWxGjOC5dN8u0YVORzKrs+9B8bupzzokaxFZjFdE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=mmCpvfmKsPeDe0SInn0f5B9hLwR60FS6AZmxaunU2iFd3N55Rfu3CTI7shCwUIZXGsd2xNYtHkmASTBQNWF8UzFcmZh/mXE2rz9apj555/KPPPRWWMaXrXI7C2efzwdn0IElKgYaeKLBO0RWaRhNB6k9+1fgHlPPpVzOyTPtV/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-69d9197c60bso4877673eaf.0
        for <io-uring@vger.kernel.org>; Tue, 26 May 2026 23:52:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779864745; x=1780469545;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fva24a47+k5joHjeL7H6qpg8fGP2lloRAuq58Skum0g=;
        b=CD1ewFzi+s4XXTKbjaXhs9/GWnBMZg3M63DKJOOh1QWq8VgYoKZG+AfOFiT/nrsh42
         fi35LoJUkm5ssUVI0W32al+1Dea9K3F0X1R+DtdNuEu6xzbJeBfvis+FhCmaNVMeX4Tl
         hv+v+9ljYdC/7mevyCbcJCYetEZMnIVhiEpIkl1W8wxe6f2CteT5VDDawJHZ5QR8x5Bq
         uvDrf5209JdLU7GH80pLouP9EFoY3VNRJBePlpBQ6fYPkN0weVQmBY1aSUQp28E2HVjc
         28wJs4WthJm83oGkdy2MSgZH7vopS/SYx7fgEqWSUkgbTANJDkv2fRbFv2E7Q9myEvXJ
         ksJg==
X-Forwarded-Encrypted: i=1; AFNElJ9KOaHQbWxhP1+yVfrDI+vpfwswg5rPmUXDNmB1KWaGji/sxos4W5a/1xx3TNLZcuvf5kGmEP0HmA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzer6dkP8gyDLuY85S1I/0q6y7T9NN0I8ZnQLuIZarCqZO7UnjZ
	h0OT13I2MitVB/juLND0Y02rFoHmYD1wlwoVCyxgTzST5Ie5CUaxpFacgXcodW6H7U380VZHKsT
	Ha2Pb0f0hApyAGLXxoa9Xk3XtevmAMw96OB8Eqk53Va3cbFrGiSL5KdjkLxY=
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4ccb:b0:69d:ecb9:4a6 with SMTP id
 006d021491bc7-69decb90861mr113467eaf.47.1779864745284; Tue, 26 May 2026
 23:52:25 -0700 (PDT)
Date: Tue, 26 May 2026 23:52:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a1694a9.17ccd394.1fa6b8.0001.GAE@google.com>
Subject: [syzbot] [io-uring?] WARNING in io_wq_put_and_exit (2)
From: syzbot <syzbot+b0d54b9e81de55179e47@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	URI_HIDDEN_PATH(1.00)[https://syzkaller.appspot.com/x/.config?x=e327ee9a867dd6b9];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[appspotmail.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-13511-lists,io-uring=lfdr.de,b0d54b9e81de55179e47];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	SUBJECT_HAS_QUESTION(0.00)[];
	REDIRECTOR_URL(0.00)[goo.gl];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[syzbot@syzkaller.appspotmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[goo.gl:url,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,storage.googleapis.com:url,googlegroups.com:email,appspotmail.com:email,syzkaller.appspot.com:url]
X-Rspamd-Queue-Id: 6EEF05E00A0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello,

syzbot found the following issue on:

HEAD commit:    6a97c4d5262d Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17a41ea6580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e327ee9a867dd6b9
dashboard link: https://syzkaller.appspot.com/bug?extid=b0d54b9e81de55179e47
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5cc8b6debcbd/disk-6a97c4d5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/649698f0231f/vmlinux-6a97c4d5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b297958f355b/bzImage-6a97c4d5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b0d54b9e81de55179e47@syzkaller.appspotmail.com

------------[ cut here ]------------
time_after(jiffies, warn_timeout)
WARNING: io_uring/io-wq.c:1370 at io_wq_exit_workers io_uring/io-wq.c:1370 [inline], CPU#1: syz.1.3756/22484
WARNING: io_uring/io-wq.c:1370 at io_wq_put_and_exit+0x36c/0x9d0 io_uring/io-wq.c:1399, CPU#1: syz.1.3756/22484
Modules linked in:
CPU: 1 UID: 0 PID: 22484 Comm: syz.1.3756 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
RIP: 0010:io_wq_exit_workers io_uring/io-wq.c:1370 [inline]
RIP: 0010:io_wq_put_and_exit+0x36c/0x9d0 io_uring/io-wq.c:1399
Code: 00 00 0f 85 7d 05 00 00 48 8b 15 9f 3c 4c 09 4d 89 e7 31 ff 49 29 d7 4c 89 fe e8 cf f6 13 fd 4d 85 ff 79 aa e8 e5 fb 13 fd 90 <0f> 0b 90 eb 9f e8 da fb 13 fd 4c 8d 63 08 48 b8 00 00 00 00 00 fc
RSP: 0018:ffffc900077af8c0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888033fdb000 RCX: ffffffff84f4b5f1
RDX: ffff888030d4ca00 RSI: ffffffff84f4b5fb RDI: ffff888030d4ca00
RBP: fffffbfff1c81e50 R08: 0000000000000007 R09: 0000000000000000
R10: ffffffffffffe7c3 R11: 0000000000000000 R12: 0000000100027def
R13: 0000000000001b58 R14: ffff888033fdb018 R15: ffffffffffffe7c3
FS:  00007ff97ac796c0(0000) GS:ffff88812446a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4b79c90b9b CR3: 0000000037235000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 io_uring_clean_tctx+0x114/0x180 io_uring/tctx.c:248
 io_uring_cancel_generic+0x7b9/0x810 io_uring/cancel.c:657
 io_uring_files_cancel include/linux/io_uring.h:20 [inline]
 do_exit+0x344/0x2af0 kernel/exit.c:916
 do_group_exit+0xd5/0x2a0 kernel/exit.c:1119
 get_signal+0x20ff/0x2210 kernel/signal.c:3037
 arch_do_signal_or_restart+0x91/0x7e0 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0x8b/0x4f0 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x706/0x860 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff979d9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff97ac79028 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: 0000000000018ff8 RBX: 00007ff97a015fa0 RCX: 00007ff979d9ce59
RDX: 0000000000018ff8 RSI: 0000200000009b80 RDI: 0000000000000003
RBP: 00007ff979e32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff97a016038 R14: 00007ff97a015fa0 R15: 00007ffc1552e588
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

