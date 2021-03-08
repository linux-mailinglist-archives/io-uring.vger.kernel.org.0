Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE469330BB0
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 11:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhCHKu6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 05:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhCHKue (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 05:50:34 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E13C06174A
        for <io-uring@vger.kernel.org>; Mon,  8 Mar 2021 02:50:33 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id t5-20020a1c77050000b029010e62cea9deso3503369wmi.0
        for <io-uring@vger.kernel.org>; Mon, 08 Mar 2021 02:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SNe5gfcrhW0ZGXBn4AR+5RuHI1sn/KRN4BXzQ2wl5UU=;
        b=HOOVneGmV/CufFGkVyxCH2r/u+eVxGQod32GK2yIlNBUiEJPNjQvKwLyUnjgiVaALj
         xzlpMydUIEJn+J34OdrQnrEeeOEVMs3hp0nfJnkY6sC13NjeM4xs+MJQTv7KjMFSMa40
         V2wf+45f6RvJ6ygwq90uKaGt5D3T1RAkZycd3VQDMR+KBvSOlV2QUE5YPzFmzc2ev4J2
         J4HBNBNn1w2b2558un/SCK01KrD4IBKgo+zS3D+s37t0DPgMlEqn9KiWsn9iADU0xABW
         1ul6xFpfWSK/vfj2/4IcL2ybqIPUq7o4/el/zGi78oXt7bwNp9jC11Nv7wxz5lFmVUav
         U0SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=SNe5gfcrhW0ZGXBn4AR+5RuHI1sn/KRN4BXzQ2wl5UU=;
        b=bo6SZlKsLaqpVvp5y4M5Vli2zSNlxMqlMk2bVW4/PUygcIjHGB9pibrJUW8xqLylCI
         hR7TIJZp/Tngi6XmL1nYBwxjC5QRD8iFygZ/HaS+tCJCAXmwCAulg8aBgtAA7P6igL3v
         H/WveourQ5kfVFEAcXGKqx8hVoH0Iq6/rwU/DEJizIi9Jmb4vWnKeWtas6n5KF6L9xBA
         Bwrdj7sG0IJX2IuMlmIYWx/7hpFfEvCttee7/IGTPRPyn8bQN2KHG2VuSOeAv07Ov4j5
         Fs+wdj2LN/MUaoXpnWN5TgJVQ42lwnqouL7Tx5ct9xEpXFaBdguE+LTPK1rveMIfKuJj
         X9AQ==
X-Gm-Message-State: AOAM5317QZ+G5VJHrygWcn8f3b5LQA5OoMjP1F7cdmGVYS5L/CYzxXlM
        3lsFgYQn0mJ2mQCc4XnleTT6wMtBgAxd6g==
X-Google-Smtp-Source: ABdhPJxXq3Xj3dqQaG1cYeAsU0KMkIRiT/cC/mhcMG8lJ5jWf91RU2TDvngaNwVR5WWAHsJaereMmQ==
X-Received: by 2002:a05:600c:614:: with SMTP id o20mr20861726wmm.66.1615200632499;
        Mon, 08 Mar 2021 02:50:32 -0800 (PST)
Received: from [192.168.8.117] ([148.252.132.144])
        by smtp.gmail.com with ESMTPSA id o20sm18343295wmq.5.2021.03.08.02.50.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 02:50:32 -0800 (PST)
To:     yangerkun <yangerkun@huawei.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, yi.zhang@huawei.com,
        Matthew Wilcox <willy@infradead.org>
References: <20210308065903.2228332-1-yangerkun@huawei.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 1/2] io_uring: fix UAF for personality_idr
Message-ID: <e4b79f4d-c777-103d-e87e-d72dc49cb440@gmail.com>
Date:   Mon, 8 Mar 2021 10:46:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210308065903.2228332-1-yangerkun@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/03/2021 06:59, yangerkun wrote:
> Loop with follow can trigger a UAF:
> 
> void main()
> {
>         int ret;
>         struct io_uring ring;
>         struct io_uring_params p;
>         int i;
> 
>         ret = io_uring_queue_init(1, &ring, 0);
>         assert(ret == 0);
> 
>         for (i = 0; i < 10000; i++) {
>                 ret = io_uring_register_personality(&ring);
>                 if (ret < 0)
>                         break;
>         }
> 
>         ret = io_uring_unregister_personality(&ring, 1024);
>         assert(ret == 0);
> }

Matthew, any chance you remember whether idr_for_each tolerates
idr_remove() from within the callback? Nothing else is happening in
parallel.



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
>  dump_backtrace+0x0/0x1d8 arch/arm64/kernel/stacktrace.c:132
>  show_stack+0x28/0x34 arch/arm64/kernel/stacktrace.c:196
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x110/0x164 lib/dump_stack.c:118
>  print_address_description+0x78/0x5c8 mm/kasan/report.c:385
>  __kasan_report mm/kasan/report.c:545 [inline]
>  kasan_report+0x148/0x1e4 mm/kasan/report.c:562
>  check_memory_region_inline mm/kasan/generic.c:183 [inline]
>  __asan_load8+0xb4/0xbc mm/kasan/generic.c:252
>  radix_tree_next_slot include/linux/radix-tree.h:422 [inline]
>  idr_for_each+0x88/0x18c lib/idr.c:202
>  io_ring_ctx_wait_and_kill+0xf0/0x210 fs/io_uring.c:8429
>  io_uring_release+0x3c/0x50 fs/io_uring.c:8454
>  __fput+0x1b8/0x3a8 fs/file_table.c:281
>  ____fput+0x1c/0x28 fs/file_table.c:314
>  task_work_run+0xec/0x13c kernel/task_work.c:151
>  exit_task_work include/linux/task_work.h:30 [inline]
>  do_exit+0x384/0xd68 kernel/exit.c:809
>  do_group_exit+0xb8/0x13c kernel/exit.c:906
>  get_signal+0x794/0xb04 kernel/signal.c:2758
>  do_signal arch/arm64/kernel/signal.c:658 [inline]
>  do_notify_resume+0x1dc/0x8a8 arch/arm64/kernel/signal.c:722
>  work_pending+0xc/0x180
> 
> Allocated by task 3149:
>  stack_trace_save+0x80/0xb8 kernel/stacktrace.c:121
>  kasan_save_stack mm/kasan/common.c:48 [inline]
>  kasan_set_track mm/kasan/common.c:56 [inline]
>  __kasan_kmalloc+0xdc/0x120 mm/kasan/common.c:461
>  kasan_slab_alloc+0x14/0x1c mm/kasan/common.c:469
>  slab_post_alloc_hook+0x50/0x8c mm/slab.h:535
>  slab_alloc_node mm/slub.c:2891 [inline]
>  slab_alloc mm/slub.c:2899 [inline]
>  kmem_cache_alloc+0x1f4/0x2fc mm/slub.c:2904
>  radix_tree_node_alloc+0x70/0x19c lib/radix-tree.c:274
>  idr_get_free+0x180/0x528 lib/radix-tree.c:1504
>  idr_alloc_u32+0xa8/0x164 lib/idr.c:46
>  idr_alloc_cyclic+0x8c/0x150 lib/idr.c:125
>  io_register_personality fs/io_uring.c:9512 [inline]
>  __io_uring_register+0xed8/0x1d9c fs/io_uring.c:9741
>  __do_sys_io_uring_register fs/io_uring.c:9791 [inline]
>  __se_sys_io_uring_register fs/io_uring.c:9773 [inline]
>  __arm64_sys_io_uring_register+0xd0/0x108 fs/io_uring.c:9773
>  __invoke_syscall arch/arm64/kernel/syscall.c:36 [inline]
>  invoke_syscall arch/arm64/kernel/syscall.c:48 [inline]
>  el0_svc_common arch/arm64/kernel/syscall.c:158 [inline]
>  do_el0_svc+0x120/0x260 arch/arm64/kernel/syscall.c:227
>  el0_svc+0x20/0x2c arch/arm64/kernel/entry-common.c:367
>  el0_sync_handler+0x98/0x170 arch/arm64/kernel/entry-common.c:383
>  el0_sync+0x140/0x180 arch/arm64/kernel/entry.S:670
> 
> Freed by task 4399:
>  stack_trace_save+0x80/0xb8 kernel/stacktrace.c:121
>  kasan_save_stack mm/kasan/common.c:48 [inline]
>  kasan_set_track+0x38/0x6c mm/kasan/common.c:56
>  kasan_set_free_info+0x20/0x40 mm/kasan/generic.c:355
>  __kasan_slab_free+0x124/0x150 mm/kasan/common.c:422
>  kasan_slab_free+0x10/0x1c mm/kasan/common.c:431
>  slab_free_hook mm/slub.c:1544 [inline]
>  slab_free_freelist_hook+0xb0/0x1ac mm/slub.c:1577
>  slab_free mm/slub.c:3142 [inline]
>  kmem_cache_free+0xc4/0x268 mm/slub.c:3158
>  radix_tree_node_rcu_free+0x60/0x6c lib/radix-tree.c:302
>  rcu_do_batch+0x180/0x404 kernel/rcu/tree.c:2479
>  rcu_core+0x3e0/0x410 kernel/rcu/tree.c:2714
>  rcu_core_si+0xc/0x14 kernel/rcu/tree.c:2727
>  __do_softirq+0x180/0x3e0 kernel/softirq.c:298
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
>  fs/io_uring.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 92c25b5f1349..b462c2bf0f2c 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8494,9 +8494,9 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
>  
>  static int io_remove_personalities(int id, void *p, void *data)
>  {
> -	struct io_ring_ctx *ctx = data;
> +	const struct cred *creds = p;
>  
> -	io_unregister_personality(ctx, id);
> +	put_cred(creds);
>  	return 0;
>  }
>  
> 

-- 
Pavel Begunkov
