Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA08528E167
	for <lists+io-uring@lfdr.de>; Wed, 14 Oct 2020 15:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgJNNfy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Oct 2020 09:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726662AbgJNNfw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Oct 2020 09:35:52 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291B6C0613D3
        for <io-uring@vger.kernel.org>; Wed, 14 Oct 2020 06:35:51 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id o8so1781511pll.4
        for <io-uring@vger.kernel.org>; Wed, 14 Oct 2020 06:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Wy0Ge2R1/3xJqBcrn7DRgPvP5sQkmecIsTO05iyvDPI=;
        b=oaWRltC9WgKkU5AVb81kGaNKgvV3MWJ3WWPSbPNCtDxPQTLutzxBPvJyjz51KQDIWg
         ia6TLh6OIJzB85yCJhmub3PQTMcKxw8eceNIqvU4ZpiNJtQcDus4+bSrkNko05UPANIA
         phiaOeSA107xelJxqKRZOpjFe09QGS/xnj+DSOrIspouhmoWHOynGH+L1B6JW0EjPG3l
         ILuiS2oxWb2UCsPOya76QYvVqCAXQQRz59DQdn3VnVSBLiqkipdexdj6j8zmsUoFDCyV
         EB5qYgiwJTYtFoS4Je4VYCg5GR8cgWIKaWOETCwBDj6DOjnnMsz2qS2BggLFl4ltBLwT
         j3iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Wy0Ge2R1/3xJqBcrn7DRgPvP5sQkmecIsTO05iyvDPI=;
        b=tk6wz0P0PX1X877+A50XDR4nAZaDCDvebYzLSce43aA7HQQB0BzHaOIzajFscXHLLi
         /ggcibMlpHukd14oOVRHdshBqcVtyDs90q83V79Iw6uobhKJMNJVp6IzAbDhA+IlabIa
         mIsZ6L04BIycT456IUpQbZqKygibZnyLsxPcZtE9EHCDLMJl/UCFjMi9828sDpGqcRvB
         YiSLHYXttt8MHHdjePuSH+BBIsorGVqbiKFYY6l05flDqSZ8E1+nnUOh5AOTpgJ+xt/Q
         YVr2eLSn/f9Lqr8msZyfes8jtJcCTmEg04DjPs86g0XKnrRxfBtDII3XjZgg1WdEO9oB
         bnXg==
X-Gm-Message-State: AOAM533kRVTko2ShpYwMLBMMAUJB77eGg1XrqU6VweW3oY9nbgOIFafd
        1bqTRETeMF71Ttt/Wf/sTY9ARA==
X-Google-Smtp-Source: ABdhPJyftra9I5a+UmwFsdFPNjzXI/wjtHTShNQjT0d0+UsYDvRuic+mMuS4HpRz7Zn++E94jt+QJA==
X-Received: by 2002:a17:90a:4ece:: with SMTP id v14mr3797628pjl.70.1602682550509;
        Wed, 14 Oct 2020 06:35:50 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 190sm3596239pfc.151.2020.10.14.06.35.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2020 06:35:49 -0700 (PDT)
Subject: Re: general protection fault in __do_sys_io_uring_register
To:     syzbot <syzbot+f4ebcc98223dafd8991e@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk, Pavel Begunkov <asml.silence@gmail.com>
References: <0000000000005a849705b1a04ab8@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <94fe990f-6382-039b-34b5-233b437af610@kernel.dk>
Date:   Wed, 14 Oct 2020 07:35:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0000000000005a849705b1a04ab8@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/14/20 6:01 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    029f56db Merge tag 'x86_asm_for_v5.10' of git://git.kernel..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=13b5c678500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=d4ce0764b8e2dd3f
> dashboard link: https://syzkaller.appspot.com/bug?extid=f4ebcc98223dafd8991e
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f4ebcc98223dafd8991e@syzkaller.appspotmail.com
> 
> general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 PID: 8927 Comm: syz-executor.3 Not tainted 5.9.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:io_file_from_index fs/io_uring.c:5963 [inline]
> RIP: 0010:io_sqe_files_register fs/io_uring.c:7369 [inline]
> RIP: 0010:__io_uring_register fs/io_uring.c:9463 [inline]
> RIP: 0010:__do_sys_io_uring_register+0x2fd2/0x3ee0 fs/io_uring.c:9553
> Code: ec 03 49 c1 ee 03 49 01 ec 49 01 ee e8 57 61 9c ff 41 80 3c 24 00 0f 85 9b 09 00 00 4d 8b af b8 01 00 00 4c 89 e8 48 c1 e8 03 <80> 3c 28 00 0f 85 76 09 00 00 49 8b 55 00 89 d8 c1 f8 09 48 98 4c
> RSP: 0018:ffffc90009137d68 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffc9000ef2a000
> RDX: 0000000000040000 RSI: ffffffff81d81dd9 RDI: 0000000000000005
> RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffed1012882a37
> R13: 0000000000000000 R14: ffffed1012882a38 R15: ffff888094415000
> FS:  00007f4266f3c700(0000) GS:ffff8880ae500000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000118c000 CR3: 000000008e57d000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x45de59
> Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f4266f3bc78 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
> RAX: ffffffffffffffda RBX: 00000000000083c0 RCX: 000000000045de59
> RDX: 0000000020000280 RSI: 0000000000000002 RDI: 0000000000000005
> RBP: 000000000118bf68 R08: 0000000000000000 R09: 0000000000000000
> R10: 40000000000000a1 R11: 0000000000000246 R12: 000000000118bf2c
> R13: 00007fff2fa4f12f R14: 00007f4266f3c9c0 R15: 000000000118bf2c
> Modules linked in:
> ---[ end trace 2a40a195e2d5e6e6 ]---
> RIP: 0010:io_file_from_index fs/io_uring.c:5963 [inline]
> RIP: 0010:io_sqe_files_register fs/io_uring.c:7369 [inline]
> RIP: 0010:__io_uring_register fs/io_uring.c:9463 [inline]
> RIP: 0010:__do_sys_io_uring_register+0x2fd2/0x3ee0 fs/io_uring.c:9553
> Code: ec 03 49 c1 ee 03 49 01 ec 49 01 ee e8 57 61 9c ff 41 80 3c 24 00 0f 85 9b 09 00 00 4d 8b af b8 01 00 00 4c 89 e8 48 c1 e8 03 <80> 3c 28 00 0f 85 76 09 00 00 49 8b 55 00 89 d8 c1 f8 09 48 98 4c
> RSP: 0018:ffffc90009137d68 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffc9000ef2a000
> RDX: 0000000000040000 RSI: ffffffff81d81dd9 RDI: 0000000000000005
> RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffed1012882a37
> R13: 0000000000000000 R14: ffffed1012882a38 R15: ffff888094415000
> FS:  00007f4266f3c700(0000) GS:ffff8880ae400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000000074a918 CR3: 000000008e57d000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

I think this should fix it.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index fc6de6b4784e..528eced8ee1f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7311,6 +7311,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 
 	if (io_sqe_alloc_file_tables(file_data, nr_tables, nr_args))
 		goto out_ref;
+	ctx->file_data = file_data;
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
 		struct fixed_file_table *table;
@@ -7345,7 +7346,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		table->files[index] = file;
 	}
 
-	ctx->file_data = file_data;
 	ret = io_sqe_files_scm(ctx);
 	if (ret) {
 		io_sqe_files_unregister(ctx);
@@ -7378,6 +7378,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 out_free:
 	kfree(file_data->table);
 	kfree(file_data);
+	ctx->file_data = NULL;
 	return ret;
 }
 

-- 
Jens Axboe

