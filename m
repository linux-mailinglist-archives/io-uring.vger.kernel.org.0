Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959272A31BE
	for <lists+io-uring@lfdr.de>; Mon,  2 Nov 2020 18:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgKBRil (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Nov 2020 12:38:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbgKBRij (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Nov 2020 12:38:39 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EC7C061A47
        for <io-uring@vger.kernel.org>; Mon,  2 Nov 2020 09:38:38 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id s10so1466332ioe.1
        for <io-uring@vger.kernel.org>; Mon, 02 Nov 2020 09:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=XgHK+n73DGSjTlF4tReOQabxZrHP7prERV8ecq6Sut4=;
        b=zjCJWGvRvEzzaS5KGlJUC1dFqwplLVJk01FNJYHeRqNkbT9zkXeL/ae9FSPhpyp1q0
         nFn3GVmuHBfpz93h5PAflmCKQzU9LmiD0wZuY+IWuD1p+yQV/Lpdl8T/xukIcpeOF40T
         nb2DsGZz0ffUJliV4/uN3XSrcPRI11fm+o/2+UZsYHDzdoHlzkT7F/XchGZEmpk9mXsB
         oMcrMfPvAUPdUJF6XuZMg3TG6Xj97zvLFDCJRZN9eNkAKnMv/jzMrGTnZD5FWjF78GO1
         h8QUgiawSnLNGi8qLiljhEoD5G1rK+YgIlNCHbrhx6S5M1s4g+QtZXEnL4ycaqbt8eYt
         4tog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XgHK+n73DGSjTlF4tReOQabxZrHP7prERV8ecq6Sut4=;
        b=imdeO2Ms10/eYOKjQtixbzwORQSvQTBjYwjZyUI214oScIuacALv0b0APM+iLamxp+
         OroXu6fprifmC4L0MrWhXUHbt5OVNvyCQcOhyP2VnLyqX6gm6u4WVaoV80SeMTMIqbZ/
         KWiGnu4Bd0fPELz6KUyeZjv+mtXt61OIlaraLiF4gFMAOvbwVvZkzkkx10BS5uTor/zk
         QUNuJZaUU+zlbYOI9HD+9jwn2/sXg91qxQugOEB80bh+r4Bz8IkXE3m4UTccPp3zMe0f
         LYeT5VGtWC9W3GT4sQ0NBsUYmO9+D38ViiOihBXYbPwc7TZzIMIVu4385jVBRLdI4Ogy
         wfbw==
X-Gm-Message-State: AOAM5314QSsEMzUsNjlMaa37fQ6xN0PujFwZovFbWV5e1PElfKq1RJ90
        OiE4667M2p2eRv/Ru3KyKswRNg==
X-Google-Smtp-Source: ABdhPJzLYKP4xBEydsBHfpr2/aVGTAX5oAa8OeKplgO09s2gpfHx4JJivnwZhV4NWx5yRt0KLomPpA==
X-Received: by 2002:a05:6602:2c41:: with SMTP id x1mr11554294iov.58.1604338717964;
        Mon, 02 Nov 2020 09:38:37 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f203sm10313277ioa.23.2020.11.02.09.38.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 09:38:37 -0800 (PST)
Subject: Re: KASAN: null-ptr-deref Write in kthread_use_mm
To:     syzbot <syzbot+b57abf7ee60829090495@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, mingo@redhat.com,
        peterz@infradead.org, rostedt@goodmis.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        will@kernel.org
References: <00000000000008604f05b31e6867@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d74a8b22-bd5e-102f-e896-79e66b09a4a4@kernel.dk>
Date:   Mon, 2 Nov 2020 10:38:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <00000000000008604f05b31e6867@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/2/20 4:54 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    4e78c578 Add linux-next specific files for 20201030
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=148969d4500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=83318758268dc331
> dashboard link: https://syzkaller.appspot.com/bug?extid=b57abf7ee60829090495
> compiler:       gcc (GCC) 10.1.0-syz 20200507
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e1346c500000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1388fbca500000
> 
> The issue was bisected to:
> 
> commit 4d004099a668c41522242aa146a38cc4eb59cb1e
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Fri Oct 2 09:04:21 2020 +0000
> 
>     lockdep: Fix lockdep recursion
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1354e614500000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=10d4e614500000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1754e614500000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+b57abf7ee60829090495@syzkaller.appspotmail.com
> Fixes: 4d004099a668 ("lockdep: Fix lockdep recursion")
> 
> ==================================================================
> BUG: KASAN: null-ptr-deref in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
> BUG: KASAN: null-ptr-deref in atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
> BUG: KASAN: null-ptr-deref in mmgrab include/linux/sched/mm.h:36 [inline]
> BUG: KASAN: null-ptr-deref in kthread_use_mm+0x11c/0x2a0 kernel/kthread.c:1257
> Write of size 4 at addr 0000000000000060 by task io_uring-sq/26191
> 
> CPU: 1 PID: 26191 Comm: io_uring-sq Not tainted 5.10.0-rc1-next-20201030-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:118
>  __kasan_report mm/kasan/report.c:549 [inline]
>  kasan_report.cold+0x5/0x37 mm/kasan/report.c:562
>  check_memory_region_inline mm/kasan/generic.c:186 [inline]
>  check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
>  instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
>  atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
>  mmgrab include/linux/sched/mm.h:36 [inline]
>  kthread_use_mm+0x11c/0x2a0 kernel/kthread.c:1257
>  __io_sq_thread_acquire_mm fs/io_uring.c:1092 [inline]
>  __io_sq_thread_acquire_mm+0x1c4/0x220 fs/io_uring.c:1085
>  io_sq_thread_acquire_mm_files.isra.0+0x125/0x180 fs/io_uring.c:1104
>  io_init_req fs/io_uring.c:6661 [inline]
>  io_submit_sqes+0x89d/0x25f0 fs/io_uring.c:6757
>  __io_sq_thread fs/io_uring.c:6904 [inline]
>  io_sq_thread+0x462/0x1630 fs/io_uring.c:6971
>  kthread+0x3af/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> ==================================================================
> Kernel panic - not syncing: panic_on_warn set ...
> CPU: 1 PID: 26191 Comm: io_uring-sq Tainted: G    B             5.10.0-rc1-next-20201030-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x107/0x163 lib/dump_stack.c:118
>  panic+0x306/0x73d kernel/panic.c:231
>  end_report+0x58/0x5e mm/kasan/report.c:106
>  __kasan_report mm/kasan/report.c:552 [inline]
>  kasan_report.cold+0xd/0x37 mm/kasan/report.c:562
>  check_memory_region_inline mm/kasan/generic.c:186 [inline]
>  check_memory_region+0x13d/0x180 mm/kasan/generic.c:192
>  instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
>  atomic_inc include/asm-generic/atomic-instrumented.h:240 [inline]
>  mmgrab include/linux/sched/mm.h:36 [inline]
>  kthread_use_mm+0x11c/0x2a0 kernel/kthread.c:1257
>  __io_sq_thread_acquire_mm fs/io_uring.c:1092 [inline]
>  __io_sq_thread_acquire_mm+0x1c4/0x220 fs/io_uring.c:1085
>  io_sq_thread_acquire_mm_files.isra.0+0x125/0x180 fs/io_uring.c:1104
>  io_init_req fs/io_uring.c:6661 [inline]
>  io_submit_sqes+0x89d/0x25f0 fs/io_uring.c:6757
>  __io_sq_thread fs/io_uring.c:6904 [inline]
>  io_sq_thread+0x462/0x1630 fs/io_uring.c:6971
>  kthread+0x3af/0x4a0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296
> Kernel Offset: disabled
> Rebooting in 86400 seconds..

I think this should fix it - we could _probably_ get by with a
READ_ONCE() of the task mm for this case, but let's play it safe and
lock down the task for a guaranteed consistent view of the current
state.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index dd2ee77feec6..610332f443bd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -995,20 +995,33 @@ static void io_sq_thread_drop_mm(void)
 	if (mm) {
 		kthread_unuse_mm(mm);
 		mmput(mm);
+		current->mm = NULL;
 	}
 }
 
 static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
 {
-	if (!current->mm) {
-		if (unlikely(!(ctx->flags & IORING_SETUP_SQPOLL) ||
-			     !ctx->sqo_task->mm ||
-			     !mmget_not_zero(ctx->sqo_task->mm)))
-			return -EFAULT;
-		kthread_use_mm(ctx->sqo_task->mm);
+	struct mm_struct *mm;
+
+	if (current->mm)
+		return 0;
+
+	/* Should never happen */
+	if (unlikely(!(ctx->flags & IORING_SETUP_SQPOLL)))
+		return -EFAULT;
+
+	task_lock(ctx->sqo_task);
+	mm = ctx->sqo_task->mm;
+	if (unlikely(!mm || !mmget_not_zero(mm)))
+		mm = NULL;
+	task_unlock(ctx->sqo_task);
+
+	if (mm) {
+		kthread_use_mm(mm);
+		return 0;
 	}
 
-	return 0;
+	return -EFAULT;
 }
 
 static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,

-- 
Jens Axboe

