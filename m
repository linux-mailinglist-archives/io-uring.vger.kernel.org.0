Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBA229091E
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410540AbgJPQCp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410536AbgJPQCp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:02:45 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798ACC061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:43 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id w11so1511857pll.8
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3SvKyoxquZEKoZGgJg0BoE3jyAI94+HaC3hbHKyQqrM=;
        b=xftlLI4X0FLJ/985DKJREfL3vvW8LxwVmMRDVSuW7rw0Tab9w8rA144+0T1cOnIXY1
         /fbM3BPfLni1ZLpLmAg/xUxYZFBmiMWWUZBK/w4+pEUThBfTDFsUj43KyyLmF06mIBi0
         tEEcwd4ZErihXUpelBwZHHlfeGRv/v4CshGRyus6yKW5dyKxTy/X6WBYHzR1wETTkUKf
         PrR2Jo5T4xPc0UhOTG5xwHLPj2B6zCp00XGzohHMCGJNb/68BupWrdLhb1skkgTXttc0
         eiG8ORYYDKhjgB7/xM5H5aH0vGAeOL22uHFdHOrx0G7EWCtXpUN6ivQR0F7govbnKcKh
         pHcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3SvKyoxquZEKoZGgJg0BoE3jyAI94+HaC3hbHKyQqrM=;
        b=IvEIXguhOIDl1djXqnfeCQ7cRZEh7u8H9Tu9GafHT6Eqo3pVcFfksRnL9e8JP+FbXt
         7hZumP7IsHCLU5ABVgDbsx41ZKdUl2mOI1LPN553i+yMWEaiFvaoD1HN84+R3aXTCahg
         tayi7p41NTkOnVnf/xsKXxuVIA6cyrlQwLwSdzGlFATZr4XG/P/IDnLUO/HbuX6297wA
         mcGCqwCFJuu1ZMn2OKhzVD1j6g4eOOXUJffgDySXCsYjG/VU3/eJfOXZkoGTG5/H1Qr9
         KTr3Jx5AoJnYl5PUrvVpGJyANGcJRO8lxe/UrVbI3Cj2KSxAPKLWby11cLTgrjeafbWi
         CB/Q==
X-Gm-Message-State: AOAM531s1bBL/iDmd+u4VAy1VuS+qtTOSIYwHppfjob0fCU5Y8KdMPGY
        GsSsHAIRt947KQcReT+0zKg1RDip2ErKJ26e
X-Google-Smtp-Source: ABdhPJxxIBcKEB69g/D8Ksj0cHGW10wXqEBW0qxwREnwMfREmxGEmwfCxCM2yRnCbAaFKagu9AkTIw==
X-Received: by 2002:a17:902:b711:b029:d3:f1e5:c9c1 with SMTP id d17-20020a170902b711b02900d3f1e5c9c1mr4832447pls.3.1602864161628;
        Fri, 16 Oct 2020 09:02:41 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:41 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+f4ebcc98223dafd8991e@syzkaller.appspotmail.com
Subject: [PATCH 10/18] io_uring: fix error path cleanup in io_sqe_files_register()
Date:   Fri, 16 Oct 2020 10:02:16 -0600
Message-Id: <20201016160224.1575329-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016160224.1575329-1-axboe@kernel.dk>
References: <20201016160224.1575329-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot reports the following crash:

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 PID: 8927 Comm: syz-executor.3 Not tainted 5.9.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_file_from_index fs/io_uring.c:5963 [inline]
RIP: 0010:io_sqe_files_register fs/io_uring.c:7369 [inline]
RIP: 0010:__io_uring_register fs/io_uring.c:9463 [inline]
RIP: 0010:__do_sys_io_uring_register+0x2fd2/0x3ee0 fs/io_uring.c:9553
Code: ec 03 49 c1 ee 03 49 01 ec 49 01 ee e8 57 61 9c ff 41 80 3c 24 00 0f 85 9b 09 00 00 4d 8b af b8 01 00 00 4c 89 e8 48 c1 e8 03 <80> 3c 28 00 0f 85 76 09 00 00 49 8b 55 00 89 d8 c1 f8 09 48 98 4c
RSP: 0018:ffffc90009137d68 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffc9000ef2a000
RDX: 0000000000040000 RSI: ffffffff81d81dd9 RDI: 0000000000000005
RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffed1012882a37
R13: 0000000000000000 R14: ffffed1012882a38 R15: ffff888094415000
FS:  00007f4266f3c700(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000118c000 CR3: 000000008e57d000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45de59
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f4266f3bc78 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00000000000083c0 RCX: 000000000045de59
RDX: 0000000020000280 RSI: 0000000000000002 RDI: 0000000000000005
RBP: 000000000118bf68 R08: 0000000000000000 R09: 0000000000000000
R10: 40000000000000a1 R11: 0000000000000246 R12: 000000000118bf2c
R13: 00007fff2fa4f12f R14: 00007f4266f3c9c0 R15: 000000000118bf2c
Modules linked in:
---[ end trace 2a40a195e2d5e6e6 ]---
RIP: 0010:io_file_from_index fs/io_uring.c:5963 [inline]
RIP: 0010:io_sqe_files_register fs/io_uring.c:7369 [inline]
RIP: 0010:__io_uring_register fs/io_uring.c:9463 [inline]
RIP: 0010:__do_sys_io_uring_register+0x2fd2/0x3ee0 fs/io_uring.c:9553
Code: ec 03 49 c1 ee 03 49 01 ec 49 01 ee e8 57 61 9c ff 41 80 3c 24 00 0f 85 9b 09 00 00 4d 8b af b8 01 00 00 4c 89 e8 48 c1 e8 03 <80> 3c 28 00 0f 85 76 09 00 00 49 8b 55 00 89 d8 c1 f8 09 48 98 4c
RSP: 0018:ffffc90009137d68 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffc9000ef2a000
RDX: 0000000000040000 RSI: ffffffff81d81dd9 RDI: 0000000000000005
RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffed1012882a37
R13: 0000000000000000 R14: ffffed1012882a38 R15: ffff888094415000
FS:  00007f4266f3c700(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000074a918 CR3: 000000008e57d000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

which is a copy of fget failure condition jumping to cleanup, but the
cleanup requires ctx->file_data to be assigned. Assign it when setup,
and ensure that we clear it again for the error path exit.

Fixes: 5398ae698525 ("io_uring: clean file_data access in files_register")
Reported-by: syzbot+f4ebcc98223dafd8991e@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 632f4e21569c..2c83c2688ec5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7282,6 +7282,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 
 	if (io_sqe_alloc_file_tables(file_data, nr_tables, nr_args))
 		goto out_ref;
+	ctx->file_data = file_data;
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
 		struct fixed_file_table *table;
@@ -7316,7 +7317,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		table->files[index] = file;
 	}
 
-	ctx->file_data = file_data;
 	ret = io_sqe_files_scm(ctx);
 	if (ret) {
 		io_sqe_files_unregister(ctx);
@@ -7349,6 +7349,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 out_free:
 	kfree(file_data->table);
 	kfree(file_data);
+	ctx->file_data = NULL;
 	return ret;
 }
 
-- 
2.28.0

