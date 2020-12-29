Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918032E6CBA
	for <lists+io-uring@lfdr.de>; Tue, 29 Dec 2020 01:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730227AbgL2ABi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Dec 2020 19:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730219AbgL2ABh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Dec 2020 19:01:37 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9FAC061796
        for <io-uring@vger.kernel.org>; Mon, 28 Dec 2020 16:00:57 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id be12so6407776plb.4
        for <io-uring@vger.kernel.org>; Mon, 28 Dec 2020 16:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pLmwRaVmPS4eFmFVTegTCZkKTcXX+6gp0TQho8zJvWY=;
        b=0/5e63PLnPOMQqBEjVQfb/s+lIjXpYnZKzbyFV4HwHTTU+05C7Vjid50XebXPlDFAO
         U1WYnnY38b3YXTMTWezfNn/Frs0kwVjdMp4JoP384byy+/1PEZJ7q0JIqwGa0yiK+6rC
         8FdmsaYhLIxXgZMuwUgL8BuuIJa1OYCl7zmIdJUMJDC88z13PQDYOLA3XUKUQOZdYMW/
         BWsZl7O5AkG1UU/vawuhxDdfV8AzIi9Zx+vu/Nku1YL8C8+IuCxTv4yzlwHisN4XRWLw
         PJs4aPJJ0c9Zx/ydq4TmAMKQtta5/tLGM2azznr0aQERFSbH5khSx6cB3afveVuwnoOI
         5Udg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pLmwRaVmPS4eFmFVTegTCZkKTcXX+6gp0TQho8zJvWY=;
        b=EMSdV/LVfzdCyT0wTfWmoeX1QnRwkBmr5TYK9R+ZcA09MLDZcdNUJbb5C/Kcl67CWd
         W8Le//er28QzZVROTWuihGb0bvi43c3aF1Tfo9bCQbY2dueatPCZADZYvjwKnhIMAxRT
         EIu1CGJvYd3yF0urEOAPifBIb3IQlbwBQjiHa2lrMt0OoLqjGwfldsIc4j+rjTIt2SDW
         npdiBXWaEkNBk02djx9L2lYeKfvfSH9N4JUxAqrK/BrKWkTtWIu1dIkYATgYZLJ4AS9h
         j4tyycjdsL9rr0Ov54LJATQlNJAWttrt+fkA6neVJ7jFjEM+09ejMhV/ozomw0GPa0Hl
         K1cA==
X-Gm-Message-State: AOAM531boPb6rBOV2mnBTdzJLLqIeDTaDVN1K+StUosqPNCzSgpCqaZo
        kSxzv3F4lBX2hsv2chhrx3Oz/31kk9DsTA==
X-Google-Smtp-Source: ABdhPJxAFHgtQJ9jUAe6q+Z9VicIRKPnHkHNrcNWF9PwkNGOGb4tTmGaVVwfpXth46uJu498G0Mfag==
X-Received: by 2002:a17:902:d202:b029:da:d86b:78be with SMTP id t2-20020a170902d202b02900dad86b78bemr28119530ply.0.1609200056678;
        Mon, 28 Dec 2020 16:00:56 -0800 (PST)
Received: from ?IPv6:2603:8001:2900:d1ce:dbbc:ecfd:6790:1f2e? (2603-8001-2900-d1ce-dbbc-ecfd-6790-1f2e.res6.spectrum.com. [2603:8001:2900:d1ce:dbbc:ecfd:6790:1f2e])
        by smtp.gmail.com with ESMTPSA id w1sm37339494pfn.151.2020.12.28.16.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 16:00:55 -0800 (PST)
Subject: Re: Bug in __mmdrop() triggered by io-uring on v5.11-rc1
To:     Christian Brauner <christian.brauner@ubuntu.com>, hch@infradead.org
Cc:     willy@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org
References: <20201228165429.c3v637xlqxt56fsv@wittgenstein>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d6788552-90bb-33f8-48ee-fb7081965e08@kernel.dk>
Date:   Mon, 28 Dec 2020 17:00:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201228165429.c3v637xlqxt56fsv@wittgenstein>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/28/20 9:54 AM, Christian Brauner wrote:
> Hey everyone,
> 
> The following oops can be triggered on a pristine v5.11-rc1 which I discovered
> while rebasing my idmapped mount patchset onto v5.11-rc1:
> 
> [  577.716339][ T7216] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)/LXD, BIOS 0.0.0 02/06/2015
> [  577.718584][ T7216] Call Trace:
> [  577.719357][ T7216]  dump_stack+0x10b/0x167
> [  577.720505][ T7216]  panic+0x347/0x783
> [  577.721588][ T7216]  ? print_oops_end_marker.cold+0x15/0x15
> [  577.723502][ T7216]  ? __warn.cold+0x5/0x2f
> [  577.725079][ T7216]  ? __mmdrop+0x30c/0x400
> [  577.736066][ T7216]  __warn.cold+0x20/0x2f
> [  577.745503][ T7216]  ? __mmdrop+0x30c/0x400
> [  577.755101][ T7216]  report_bug+0x277/0x300
> 
> f2-vm login: [  577.764873][ T7216]  handle_bug+0x3c/0x60
> [  577.773982][ T7216]  exc_invalid_op+0x18/0x50
> [  577.786341][ T7216]  asm_exc_invalid_op+0x12/0x20
> [  577.795500][ T7216] RIP: 0010:__mmdrop+0x30c/0x400
> [  577.804426][ T7216] Code: 00 00 4c 89 ef e8 64 61 8c 02 eb 82 e8 dd 48 32 00 4c 89 e7 e8 35 97 2e 00 e9 70 ff ff ff e8 cb 48 32 00 0f 0b e8 c4 48 32 00 <0f> 0b e9 51 fd ff ff e8 b8 48 32 00 0f 0b e9 82 fd ff ff e8 ac 48
> [  577.826526][ T7216] RSP: 0018:ffffc900073676d8 EFLAGS: 00010246
> [  577.836448][ T7216] RAX: 0000000000000000 RBX: ffff88810d56d1c0 RCX: ffff88810d56d1c0
> [  577.845860][ T7216] RDX: 0000000000000000 RSI: ffff88810d56d1c0 RDI: 0000000000000002
> [  577.856896][ T7216] RBP: ffff888025244700 R08: ffffffff8141a4ec R09: ffffed1004a488ed
> [  577.866712][ T7216] R10: ffff888025244763 R11: ffffed1004a488ec R12: ffff8880660b4c40
> [  577.875736][ T7216] R13: ffff888013930000 R14: ffff888025244700 R15: 0000000000000001
> [  577.889094][ T7216]  ? __mmdrop+0x30c/0x400
> [  577.898466][ T7216]  ? __mmdrop+0x30c/0x400
> [  577.907746][ T7216]  finish_task_switch+0x56f/0x8c0
> [  577.917553][ T7216]  ? __switch_to+0x580/0x1060
> [  577.926962][ T7216]  __schedule+0xa04/0x2310
> [  577.937965][ T7216]  ? firmware_map_remove+0x1a1/0x1a1
> 
> f2-vm login: [  577.947035][ T7216]  ? try_to_wake_up+0x7f3/0x16e0
> [  577.955799][ T7216]  ? preempt_schedule_thunk+0x16/0x18
> [  577.964988][ T7216]  preempt_schedule_common+0x4a/0xc0
> [  577.973670][ T7216]  preempt_schedule_thunk+0x16/0x18
> [  577.985967][ T7216]  try_to_wake_up+0x9eb/0x16e0
> [  577.994498][ T7216]  ? migrate_swap_stop+0x9d0/0x9d0
> [  578.003265][ T7216]  ? rcu_read_lock_held+0xae/0xc0
> [  578.012182][ T7216]  ? rcu_read_lock_sched_held+0xe0/0xe0
> [  578.021280][ T7216]  io_wqe_wake_worker.isra.0+0x4ba/0x670
> [  578.029857][ T7216]  ? io_wq_manager+0xc00/0xc00
> [  578.041295][ T7216]  ? _raw_spin_unlock_irqrestore+0x46/0x50
> [  578.050139][ T7216]  io_wqe_enqueue+0x212/0x980
> [  578.058213][ T7216]  __io_queue_async_work+0x201/0x4a0
> [  578.067518][ T7216]  io_queue_async_work+0x52/0x80
> [  578.078327][ T7216]  __io_queue_sqe+0x986/0xe80
> [  578.086615][ T7216]  ? io_uring_setup+0x3a90/0x3a90
> [  578.094528][ T7216]  ? radix_tree_load_root+0x119/0x1b0
> [  578.102598][ T7216]  ? io_async_task_func+0xa90/0xa90
> [  578.110208][ T7216]  ? __sanitizer_cov_trace_pc+0x1e/0x50
> [  578.120847][ T7216]  io_queue_sqe+0x5e3/0xc40
> [  578.127950][ T7216]  io_submit_sqes+0x17ca/0x26f0
> [  578.135559][ T7216]  ? io_queue_sqe+0xc40/0xc40
> [  578.143129][ T7216]  ? __x64_sys_io_uring_enter+0xa10/0xf00
> [  578.152183][ T7216]  ? xa_store+0x40/0x50
> [  578.162501][ T7216]  ? mutex_lock_io_nested+0x12a0/0x12a0
> [  578.170203][ T7216]  ? do_raw_spin_unlock+0x175/0x260
> [  578.177874][ T7216]  ? _raw_spin_unlock+0x28/0x40
> [  578.185560][ T7216]  ? xa_store+0x40/0x50
> [  578.192755][ T7216]  __x64_sys_io_uring_enter+0xa1b/0xf00
> [  578.201089][ T7216]  ? __io_uring_task_cancel+0x1e0/0x1e0
> [  578.210378][ T7216]  ? __sanitizer_cov_trace_pc+0x1e/0x50
> [  578.218401][ T7216]  ? __audit_syscall_entry+0x3fe/0x540
> [  578.226264][ T7216]  do_syscall_64+0x31/0x70
> [  578.234410][ T7216]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [  578.244957][ T7216] RIP: 0033:0x7f5204b9c89d
> [  578.252372][ T7216] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c3 f5 0c 00 f7 d8 64 89 01 48
> [  578.272398][ T7216] RSP: 002b:00007ffd62bb14e8 EFLAGS: 00000212 ORIG_RAX: 00000000000001aa
> [  578.280966][ T7216] RAX: ffffffffffffffda RBX: 00007ffd62bb1560 RCX: 00007f5204b9c89d
> [  578.289068][ T7216] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000005
> [  578.300693][ T7216] RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000008
> [  578.308932][ T7216] R10: 0000000000000000 R11: 0000000000000212 R12: 0000000000000001
> [  578.317255][ T7216] R13: 0000000000000000 R14: 00007ffd62bb1520 R15: 0000000000000000
> [  578.328448][ T7216] Kernel Offset: disabled
> [  578.544329][ T7216] Rebooting in 86400 seconds..

I can't get your reproducer to work, and unfortunately that trace doesn't
have some of the debug info? But it looks like it must be the BUG in there.
Can you try with this? Must be related to creds and identity COW'ing,
and you are using multiple processes that share the ring.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7e35283fc0b1..eb4620ff638e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1501,6 +1501,13 @@ static bool io_grab_identity(struct io_kiocb *req)
 		spin_unlock_irq(&ctx->inflight_lock);
 		req->work.flags |= IO_WQ_WORK_FILES;
 	}
+	if (!(req->work.flags & IO_WQ_WORK_MM) &&
+	    (def->work_flags & IO_WQ_WORK_MM)) {
+		if (id->mm != current->mm)
+			return false;
+		mmgrab(id->mm);
+		req->work.flags |= IO_WQ_WORK_MM;
+	}
 
 	return true;
 }
@@ -1525,13 +1532,6 @@ static void io_prep_async_work(struct io_kiocb *req)
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
 
-	/* ->mm can never change on us */
-	if (!(req->work.flags & IO_WQ_WORK_MM) &&
-	    (def->work_flags & IO_WQ_WORK_MM)) {
-		mmgrab(id->mm);
-		req->work.flags |= IO_WQ_WORK_MM;
-	}
-
 	/* if we fail grabbing identity, we must COW, regrab, and retry */
 	if (io_grab_identity(req))
 		return;

-- 
Jens Axboe

