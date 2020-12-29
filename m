Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616122E7191
	for <lists+io-uring@lfdr.de>; Tue, 29 Dec 2020 16:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgL2PBm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Dec 2020 10:01:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40055 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgL2PBm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Dec 2020 10:01:42 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1kuGUc-0005yc-B9; Tue, 29 Dec 2020 15:00:58 +0000
Date:   Tue, 29 Dec 2020 16:00:56 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     hch@infradead.org, willy@infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org
Subject: Re: Bug in __mmdrop() triggered by io-uring on v5.11-rc1
Message-ID: <20201229150056.7ki6h25biyioommx@wittgenstein>
References: <20201228165429.c3v637xlqxt56fsv@wittgenstein>
 <d6788552-90bb-33f8-48ee-fb7081965e08@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d6788552-90bb-33f8-48ee-fb7081965e08@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Dec 28, 2020 at 05:00:53PM -0700, Jens Axboe wrote:
> On 12/28/20 9:54 AM, Christian Brauner wrote:
> > Hey everyone,
> > 
> > The following oops can be triggered on a pristine v5.11-rc1 which I discovered
> > while rebasing my idmapped mount patchset onto v5.11-rc1:
> > 
> > [  577.716339][ T7216] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)/LXD, BIOS 0.0.0 02/06/2015
> > [  577.718584][ T7216] Call Trace:
> > [  577.719357][ T7216]  dump_stack+0x10b/0x167
> > [  577.720505][ T7216]  panic+0x347/0x783
> > [  577.721588][ T7216]  ? print_oops_end_marker.cold+0x15/0x15
> > [  577.723502][ T7216]  ? __warn.cold+0x5/0x2f
> > [  577.725079][ T7216]  ? __mmdrop+0x30c/0x400
> > [  577.736066][ T7216]  __warn.cold+0x20/0x2f
> > [  577.745503][ T7216]  ? __mmdrop+0x30c/0x400
> > [  577.755101][ T7216]  report_bug+0x277/0x300
> > 
> > f2-vm login: [  577.764873][ T7216]  handle_bug+0x3c/0x60
> > [  577.773982][ T7216]  exc_invalid_op+0x18/0x50
> > [  577.786341][ T7216]  asm_exc_invalid_op+0x12/0x20
> > [  577.795500][ T7216] RIP: 0010:__mmdrop+0x30c/0x400
> > [  577.804426][ T7216] Code: 00 00 4c 89 ef e8 64 61 8c 02 eb 82 e8 dd 48 32 00 4c 89 e7 e8 35 97 2e 00 e9 70 ff ff ff e8 cb 48 32 00 0f 0b e8 c4 48 32 00 <0f> 0b e9 51 fd ff ff e8 b8 48 32 00 0f 0b e9 82 fd ff ff e8 ac 48
> > [  577.826526][ T7216] RSP: 0018:ffffc900073676d8 EFLAGS: 00010246
> > [  577.836448][ T7216] RAX: 0000000000000000 RBX: ffff88810d56d1c0 RCX: ffff88810d56d1c0
> > [  577.845860][ T7216] RDX: 0000000000000000 RSI: ffff88810d56d1c0 RDI: 0000000000000002
> > [  577.856896][ T7216] RBP: ffff888025244700 R08: ffffffff8141a4ec R09: ffffed1004a488ed
> > [  577.866712][ T7216] R10: ffff888025244763 R11: ffffed1004a488ec R12: ffff8880660b4c40
> > [  577.875736][ T7216] R13: ffff888013930000 R14: ffff888025244700 R15: 0000000000000001
> > [  577.889094][ T7216]  ? __mmdrop+0x30c/0x400
> > [  577.898466][ T7216]  ? __mmdrop+0x30c/0x400
> > [  577.907746][ T7216]  finish_task_switch+0x56f/0x8c0
> > [  577.917553][ T7216]  ? __switch_to+0x580/0x1060
> > [  577.926962][ T7216]  __schedule+0xa04/0x2310
> > [  577.937965][ T7216]  ? firmware_map_remove+0x1a1/0x1a1
> > 
> > f2-vm login: [  577.947035][ T7216]  ? try_to_wake_up+0x7f3/0x16e0
> > [  577.955799][ T7216]  ? preempt_schedule_thunk+0x16/0x18
> > [  577.964988][ T7216]  preempt_schedule_common+0x4a/0xc0
> > [  577.973670][ T7216]  preempt_schedule_thunk+0x16/0x18
> > [  577.985967][ T7216]  try_to_wake_up+0x9eb/0x16e0
> > [  577.994498][ T7216]  ? migrate_swap_stop+0x9d0/0x9d0
> > [  578.003265][ T7216]  ? rcu_read_lock_held+0xae/0xc0
> > [  578.012182][ T7216]  ? rcu_read_lock_sched_held+0xe0/0xe0
> > [  578.021280][ T7216]  io_wqe_wake_worker.isra.0+0x4ba/0x670
> > [  578.029857][ T7216]  ? io_wq_manager+0xc00/0xc00
> > [  578.041295][ T7216]  ? _raw_spin_unlock_irqrestore+0x46/0x50
> > [  578.050139][ T7216]  io_wqe_enqueue+0x212/0x980
> > [  578.058213][ T7216]  __io_queue_async_work+0x201/0x4a0
> > [  578.067518][ T7216]  io_queue_async_work+0x52/0x80
> > [  578.078327][ T7216]  __io_queue_sqe+0x986/0xe80
> > [  578.086615][ T7216]  ? io_uring_setup+0x3a90/0x3a90
> > [  578.094528][ T7216]  ? radix_tree_load_root+0x119/0x1b0
> > [  578.102598][ T7216]  ? io_async_task_func+0xa90/0xa90
> > [  578.110208][ T7216]  ? __sanitizer_cov_trace_pc+0x1e/0x50
> > [  578.120847][ T7216]  io_queue_sqe+0x5e3/0xc40
> > [  578.127950][ T7216]  io_submit_sqes+0x17ca/0x26f0
> > [  578.135559][ T7216]  ? io_queue_sqe+0xc40/0xc40
> > [  578.143129][ T7216]  ? __x64_sys_io_uring_enter+0xa10/0xf00
> > [  578.152183][ T7216]  ? xa_store+0x40/0x50
> > [  578.162501][ T7216]  ? mutex_lock_io_nested+0x12a0/0x12a0
> > [  578.170203][ T7216]  ? do_raw_spin_unlock+0x175/0x260
> > [  578.177874][ T7216]  ? _raw_spin_unlock+0x28/0x40
> > [  578.185560][ T7216]  ? xa_store+0x40/0x50
> > [  578.192755][ T7216]  __x64_sys_io_uring_enter+0xa1b/0xf00
> > [  578.201089][ T7216]  ? __io_uring_task_cancel+0x1e0/0x1e0
> > [  578.210378][ T7216]  ? __sanitizer_cov_trace_pc+0x1e/0x50
> > [  578.218401][ T7216]  ? __audit_syscall_entry+0x3fe/0x540
> > [  578.226264][ T7216]  do_syscall_64+0x31/0x70
> > [  578.234410][ T7216]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > [  578.244957][ T7216] RIP: 0033:0x7f5204b9c89d
> > [  578.252372][ T7216] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c3 f5 0c 00 f7 d8 64 89 01 48
> > [  578.272398][ T7216] RSP: 002b:00007ffd62bb14e8 EFLAGS: 00000212 ORIG_RAX: 00000000000001aa
> > [  578.280966][ T7216] RAX: ffffffffffffffda RBX: 00007ffd62bb1560 RCX: 00007f5204b9c89d
> > [  578.289068][ T7216] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000005
> > [  578.300693][ T7216] RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000008
> > [  578.308932][ T7216] R10: 0000000000000000 R11: 0000000000000212 R12: 0000000000000001
> > [  578.317255][ T7216] R13: 0000000000000000 R14: 00007ffd62bb1520 R15: 0000000000000000
> > [  578.328448][ T7216] Kernel Offset: disabled
> > [  578.544329][ T7216] Rebooting in 86400 seconds..
> 
> I can't get your reproducer to work, and unfortunately that trace doesn't
> have some of the debug info? But it looks like it must be the BUG in there.
> Can you try with this? Must be related to creds and identity COW'ing,
> and you are using multiple processes that share the ring.
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 7e35283fc0b1..eb4620ff638e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1501,6 +1501,13 @@ static bool io_grab_identity(struct io_kiocb *req)
>  		spin_unlock_irq(&ctx->inflight_lock);
>  		req->work.flags |= IO_WQ_WORK_FILES;
>  	}
> +	if (!(req->work.flags & IO_WQ_WORK_MM) &&
> +	    (def->work_flags & IO_WQ_WORK_MM)) {
> +		if (id->mm != current->mm)
> +			return false;
> +		mmgrab(id->mm);
> +		req->work.flags |= IO_WQ_WORK_MM;
> +	}
>  
>  	return true;
>  }
> @@ -1525,13 +1532,6 @@ static void io_prep_async_work(struct io_kiocb *req)
>  			req->work.flags |= IO_WQ_WORK_UNBOUND;
>  	}
>  
> -	/* ->mm can never change on us */
> -	if (!(req->work.flags & IO_WQ_WORK_MM) &&
> -	    (def->work_flags & IO_WQ_WORK_MM)) {
> -		mmgrab(id->mm);
> -		req->work.flags |= IO_WQ_WORK_MM;
> -	}
> -
>  	/* if we fail grabbing identity, we must COW, regrab, and retry */
>  	if (io_grab_identity(req))
>  		return;

I've taken this and applied it to:
https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/commit/?h=io_uring_mmdrop&id=c8c68b2402709f7904a1a61cffbce4998278976e

With this patch applied the bug is gone so feel free to turn this into a
proper patch and add:
Tested-by: Christian Brauner <christian.brauner@ubuntu.com>:

Christian
