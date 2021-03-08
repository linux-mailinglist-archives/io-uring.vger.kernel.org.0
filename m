Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0FC330896
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 08:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235128AbhCHHFd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 02:05:33 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13447 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235111AbhCHHFB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 02:05:01 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Dv8Sf1dnMzjWbP;
        Mon,  8 Mar 2021 15:03:30 +0800 (CST)
Received: from [10.174.177.143] (10.174.177.143) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Mon, 8 Mar 2021 15:04:49 +0800
Subject: Re: [PATCH 1/2] io_uring: fix UAF for personality_idr
To:     <axboe@kernel.dk>, <asml.silence@gmail.com>
CC:     <io-uring@vger.kernel.org>, <yi.zhang@huawei.com>
References: <20210308065903.2228332-1-yangerkun@huawei.com>
From:   yangerkun <yangerkun@huawei.com>
Message-ID: <ea327573-68c9-04af-9f85-08395a76a59c@huawei.com>
Date:   Mon, 8 Mar 2021 15:04:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210308065903.2228332-1-yangerkun@huawei.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.143]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



ÔÚ 2021/3/8 14:59, yangerkun Ð´µÀ:
> Loop with follow can trigger a UAF:

Add a synchronize_rcu as follow will help to improve the recurrence 
probability since we can ensure the radix_tree_node has been freed :)

@@ -8497,6 +8498,7 @@ static int io_remove_personalities(int id, void 
*p, void *data)
         struct io_ring_ctx *ctx = data;

         io_unregister_personality(ctx, id);
+       synchronize_rcu();
         return 0;
  }



> 
> void main()
> {
>          int ret;
>          struct io_uring ring;
>          struct io_uring_params p;
>          int i;
> 
>          ret = io_uring_queue_init(1, &ring, 0);
>          assert(ret == 0);
> 
>          for (i = 0; i < 10000; i++) {
>                  ret = io_uring_register_personality(&ring);
>                  if (ret < 0)
>                          break;
>          }
> 
>          ret = io_uring_unregister_personality(&ring, 1024);
>          assert(ret == 0);
> }
> 
> ==================================================================
> BUG: KASAN: use-after-free in radix_tree_next_slot
> include/linux/radix-tree.h:422 [inline]
> BUG: KASAN: use-after-free in idr_for_each+0x88/0x18c lib/idr.c:202
> Read of size 8 at addr ffff0001096539f8 by task syz-executor.2/3166
> 
> CPU: 0 PID: 3166 Comm: syz-executor.2 Not tainted
> 5.10.0-00843-g352c8610ccd2 #2
> Hardware name: linux,dummy-virt (DT)
> Call trace:
>   dump_backtrace+0x0/0x1d8 arch/arm64/kernel/stacktrace.c:132
>   show_stack+0x28/0x34 arch/arm64/kernel/stacktrace.c:196
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x110/0x164 lib/dump_stack.c:118
>   print_address_description+0x78/0x5c8 mm/kasan/report.c:385
>   __kasan_report mm/kasan/report.c:545 [inline]
>   kasan_report+0x148/0x1e4 mm/kasan/report.c:562
>   check_memory_region_inline mm/kasan/generic.c:183 [inline]
>   __asan_load8+0xb4/0xbc mm/kasan/generic.c:252
>   radix_tree_next_slot include/linux/radix-tree.h:422 [inline]
>   idr_for_each+0x88/0x18c lib/idr.c:202
>   io_ring_ctx_wait_and_kill+0xf0/0x210 fs/io_uring.c:8429
>   io_uring_release+0x3c/0x50 fs/io_uring.c:8454
>   __fput+0x1b8/0x3a8 fs/file_table.c:281
>   ____fput+0x1c/0x28 fs/file_table.c:314
>   task_work_run+0xec/0x13c kernel/task_work.c:151
>   exit_task_work include/linux/task_work.h:30 [inline]
>   do_exit+0x384/0xd68 kernel/exit.c:809
>   do_group_exit+0xb8/0x13c kernel/exit.c:906
>   get_signal+0x794/0xb04 kernel/signal.c:2758
>   do_signal arch/arm64/kernel/signal.c:658 [inline]
>   do_notify_resume+0x1dc/0x8a8 arch/arm64/kernel/signal.c:722
>   work_pending+0xc/0x180
> 
> Allocated by task 3149:
>   stack_trace_save+0x80/0xb8 kernel/stacktrace.c:121
>   kasan_save_stack mm/kasan/common.c:48 [inline]
>   kasan_set_track mm/kasan/common.c:56 [inline]
>   __kasan_kmalloc+0xdc/0x120 mm/kasan/common.c:461
>   kasan_slab_alloc+0x14/0x1c mm/kasan/common.c:469
>   slab_post_alloc_hook+0x50/0x8c mm/slab.h:535
>   slab_alloc_node mm/slub.c:2891 [inline]
>   slab_alloc mm/slub.c:2899 [inline]
>   kmem_cache_alloc+0x1f4/0x2fc mm/slub.c:2904
>   radix_tree_node_alloc+0x70/0x19c lib/radix-tree.c:274
>   idr_get_free+0x180/0x528 lib/radix-tree.c:1504
>   idr_alloc_u32+0xa8/0x164 lib/idr.c:46
>   idr_alloc_cyclic+0x8c/0x150 lib/idr.c:125
>   io_register_personality fs/io_uring.c:9512 [inline]
>   __io_uring_register+0xed8/0x1d9c fs/io_uring.c:9741
>   __do_sys_io_uring_register fs/io_uring.c:9791 [inline]
>   __se_sys_io_uring_register fs/io_uring.c:9773 [inline]
>   __arm64_sys_io_uring_register+0xd0/0x108 fs/io_uring.c:9773
>   __invoke_syscall arch/arm64/kernel/syscall.c:36 [inline]
>   invoke_syscall arch/arm64/kernel/syscall.c:48 [inline]
>   el0_svc_common arch/arm64/kernel/syscall.c:158 [inline]
>   do_el0_svc+0x120/0x260 arch/arm64/kernel/syscall.c:227
>   el0_svc+0x20/0x2c arch/arm64/kernel/entry-common.c:367
>   el0_sync_handler+0x98/0x170 arch/arm64/kernel/entry-common.c:383
>   el0_sync+0x140/0x180 arch/arm64/kernel/entry.S:670
> 
> Freed by task 4399:
>   stack_trace_save+0x80/0xb8 kernel/stacktrace.c:121
>   kasan_save_stack mm/kasan/common.c:48 [inline]
>   kasan_set_track+0x38/0x6c mm/kasan/common.c:56
>   kasan_set_free_info+0x20/0x40 mm/kasan/generic.c:355
>   __kasan_slab_free+0x124/0x150 mm/kasan/common.c:422
>   kasan_slab_free+0x10/0x1c mm/kasan/common.c:431
>   slab_free_hook mm/slub.c:1544 [inline]
>   slab_free_freelist_hook+0xb0/0x1ac mm/slub.c:1577
>   slab_free mm/slub.c:3142 [inline]
>   kmem_cache_free+0xc4/0x268 mm/slub.c:3158
>   radix_tree_node_rcu_free+0x60/0x6c lib/radix-tree.c:302
>   rcu_do_batch+0x180/0x404 kernel/rcu/tree.c:2479
>   rcu_core+0x3e0/0x410 kernel/rcu/tree.c:2714
>   rcu_core_si+0xc/0x14 kernel/rcu/tree.c:2727
>   __do_softirq+0x180/0x3e0 kernel/softirq.c:298
> 
> radix_tree_next_slot called by idr_for_each will traverse all slot
> regardless of whether the slot is valid. And once the last valid slot
> has been remove, we will try to free the node, and lead to a UAF.
> 
> idr_destroy will do what we want. So, just stop call idr_remove in
> io_unregister_personality to fix the problem.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>   fs/io_uring.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 92c25b5f1349..b462c2bf0f2c 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8494,9 +8494,9 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
>   
>   static int io_remove_personalities(int id, void *p, void *data)
>   {
> -	struct io_ring_ctx *ctx = data;
> +	const struct cred *creds = p;
>   
> -	io_unregister_personality(ctx, id);
> +	put_cred(creds);
>   	return 0;
>   }
>   
> 
