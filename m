Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DAE34D126
	for <lists+io-uring@lfdr.de>; Mon, 29 Mar 2021 15:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhC2Nac (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 29 Mar 2021 09:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbhC2NaU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 29 Mar 2021 09:30:20 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6C4C061574
        for <io-uring@vger.kernel.org>; Mon, 29 Mar 2021 06:30:20 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id nh23-20020a17090b3657b02900c0d5e235a8so5936721pjb.0
        for <io-uring@vger.kernel.org>; Mon, 29 Mar 2021 06:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Z+rfSUxj612z3LxG/Vepa5JXw+wAiazM9JAXRT3osv0=;
        b=kTjUbVJXtdWTV6fB8lXgADOxoI/4JpiDo6H7DPgelZtrTk6mpIaf9qHjkRLPRpp3Mv
         6TAsZw6Iya2YatR85tBv4CcnhTR0VCFzsjQz2SQrLQ/1chKVqr5qNEouH03QSYP1xSzW
         zbb18vp+dsliCHdgfQ28qnF403HrepXIX+/e1iKfppaubEshohacxGenb4q97SBQ5Tis
         D/5zzanBH0TBmbBBI3y/m5RJeYBvc+pqaVEpgtKDsz8fiNpQZaaE/k3Fy0ufCW0DPayg
         keOG/f/ne9qGOsSJzLa+KrERSYinhVDooAgX9zCVB+451pKNmg+Og/AJmMm55E5iyrfQ
         30tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z+rfSUxj612z3LxG/Vepa5JXw+wAiazM9JAXRT3osv0=;
        b=Ok/DMdARhQYiPuf8Lv5SQvE+TTNRDs4nVRiOuH+aRoGFsjqEQXTXvOSLaL71dlkfr+
         Qq08Y0o7BKrSek4nwVYa4T25bQNKDkfojvfYMVordtih42mpV6vDANgfhGcZLI9XviNQ
         IxWWP7ZGnOvMBUDei7bxwttkW6SVR1hEr+bgz9GbkB48vxvlLXL3oq/HdRszItI96Gi0
         R/4epdnzYYIldX0mKrAdP6HuOQRz8Wk+H99INfLFH+835pSCdoZTo0cUF/w4jYtbpVld
         4A990i/R+ixdXR+UjMewZCxzcI+UyoM9KsThU7oiTnTHA+5tiH+lDctZsVjlPStsa9Um
         A82Q==
X-Gm-Message-State: AOAM533uwDsvO2ZwLUtm46XHMKpkwYDCfuzN7sulWBSuAy5HIM/yIb8E
        dKFH+pR3gHFfAOUYra2xNhHp8w==
X-Google-Smtp-Source: ABdhPJx2RT6l5klpG+ZdI5N6yqEYRbJAtGLM1j7sfGoA6lGuykJU0+jEXXBkvkIVTWg5A1QumwgSTw==
X-Received: by 2002:a17:90b:4008:: with SMTP id ie8mr27278512pjb.231.1617024619366;
        Mon, 29 Mar 2021 06:30:19 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id bg16sm15392166pjb.43.2021.03.29.06.30.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 06:30:18 -0700 (PDT)
Subject: Re: [syzbot] WARNING: still has locks held in io_sq_thread
To:     syzbot <syzbot+796d767eb376810256f5@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000aa874e05beacddfd@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5065512b-a128-939c-8ca3-d8198f768859@kernel.dk>
Date:   Mon, 29 Mar 2021 07:30:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000aa874e05beacddfd@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/29/21 7:29 AM, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> WARNING in kvm_wait
> 
> ------------[ cut here ]------------
> raw_local_irq_restore() called with IRQs enabled
> WARNING: CPU: 1 PID: 5134 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
> Modules linked in:
> CPU: 1 PID: 5134 Comm: syz-executor.2 Not tainted 5.12.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
> Code: bf ff cc cc cc cc cc cc cc cc cc cc cc 80 3d 65 c2 0f 04 00 74 01 c3 48 c7 c7 a0 7b 6b 89 c6 05 54 c2 0f 04 01 e8 65 19 bf ff <0f> 0b c3 48 39 77 10 0f 84 97 00 00 00 66 f7 47 22 f0 ff 74 4b 48
> RSP: 0018:ffffc90002f5f9c0 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: ffff888023a7d040 RCX: 0000000000000000
> RDX: ffff88801bbcc2c0 RSI: ffffffff815b7375 RDI: fffff520005ebf2a
> RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff815b00de R11: 0000000000000000 R12: 0000000000000003
> R13: ffffed100474fa08 R14: 0000000000000001 R15: ffff8880b9f36000
> FS:  000000000293e400(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffd20e04f88 CR3: 00000000116b8000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  kvm_wait arch/x86/kernel/kvm.c:860 [inline]
>  kvm_wait+0xc9/0xe0 arch/x86/kernel/kvm.c:837
>  pv_wait arch/x86/include/asm/paravirt.h:564 [inline]
>  pv_wait_head_or_lock kernel/locking/qspinlock_paravirt.h:470 [inline]
>  __pv_queued_spin_lock_slowpath+0x8b8/0xb40 kernel/locking/qspinlock.c:508
>  pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:554 [inline]
>  queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:51 [inline]
>  queued_spin_lock include/asm-generic/qspinlock.h:85 [inline]
>  do_raw_spin_lock+0x200/0x2b0 kernel/locking/spinlock_debug.c:113
>  spin_lock include/linux/spinlock.h:354 [inline]
>  ext4_lock_group fs/ext4/ext4.h:3383 [inline]
>  __ext4_new_inode+0x384f/0x5570 fs/ext4/ialloc.c:1188
>  ext4_symlink+0x489/0xd50 fs/ext4/namei.c:3347
>  vfs_symlink fs/namei.c:4176 [inline]
>  vfs_symlink+0x10f/0x270 fs/namei.c:4161
>  do_symlinkat+0x27a/0x300 fs/namei.c:4206
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae

Same one that keeps happening, it's not related.

-- 
Jens Axboe

