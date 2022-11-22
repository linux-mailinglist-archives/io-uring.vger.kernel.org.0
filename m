Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395CB634483
	for <lists+io-uring@lfdr.de>; Tue, 22 Nov 2022 20:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbiKVT1Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Nov 2022 14:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234751AbiKVT1Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Nov 2022 14:27:16 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D458B903BF
        for <io-uring@vger.kernel.org>; Tue, 22 Nov 2022 11:27:11 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id y6so11678208iof.9
        for <io-uring@vger.kernel.org>; Tue, 22 Nov 2022 11:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TXMVpP/J9ZV2xnke78gO8ON5t1nj5k7NV9PauokTolQ=;
        b=aGAD4qKzDpr/yDoUltWa21YPUrwXh9aOjLXdRENY4gvLcRuzdL9Lo3dEP3mEOeBx3t
         V8H4Ekl03oYfQWhVkM/J3/LKZ7fTb5tDgICgrtDUkAflAtzY8GdZXcdikp7w7BFdbomn
         60o47RkItfUCGbjrXbD3UxDuI0ZzlruHcE5ZjCF5feB6NNsmMWqax21cZuiu8FosvEW6
         T5Qpqds4ZcHxk1c/6zSnZi2CqKR9rGf97C6hE6Ig09sKi2vuM5DKSl8zlVVgR0LxM2oC
         vqq20sS8cpJtxg2RibGrYiTcJUt0CUOpwRBXMepOdy3R6ZRLP3UW77IsYL//W3kkxkck
         HGhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TXMVpP/J9ZV2xnke78gO8ON5t1nj5k7NV9PauokTolQ=;
        b=nVZEZSxbDJJ63Itn5T3HzqnawtblP8n2upZxOFzR/SSEN5K8af65D2GzZxzbY0wx69
         YC0CLJt5lh9wva8Bf2iPpa0yuYaAMBIGW0A3aG+JWQOm465OqaTGPuJLq6GCQzq5x+Az
         /or6sE7s3FmwF/5AJcrf3TcALbZjhit8IsukvDn3h/uVHzmx+BzJHKXaYLxAear7hykR
         xN38wcDsmxjoVEWTG6c+ALDnjeD+GeFJvqnsTCJgdzTLp7jM6XO3hlyDhnZu70+lQkW/
         LcVU6gAgLQxYZ2QYNU1ZbB59r5OK1Jf/KVCjTQvcJtItokMGCCYk3lpWcSFPYebd2k13
         OTZw==
X-Gm-Message-State: ANoB5plle/BD8AFSB93p+m3FQPgtdNHKifjy0LJdQxcgcsY/M5jRr+l1
        YJfFezpK/7TtoGOUOsqAPQwrdo3rDQVVE1U6
X-Google-Smtp-Source: AA0mqf5p5J6iH+E0K7O+igDruDem7Jyg3WAiHN0ukE+i6G7bdwdGIxCVp32D3GNz/bcYb97TSNFPoA==
X-Received: by 2002:a02:c492:0:b0:375:c128:72a6 with SMTP id t18-20020a02c492000000b00375c12872a6mr11713349jam.151.1669145230892;
        Tue, 22 Nov 2022 11:27:10 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k5-20020a026605000000b0037477c3d04asm5428049jac.130.2022.11.22.11.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 11:27:10 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Lin Ma <linma@zju.edu.cn>,
        linux-kernel@vger.kernel.org, asml.silence@gmail.com
In-Reply-To: <be4ba4b.5d44.184a0a406a4.Coremail.linma@zju.edu.cn>
References: <be4ba4b.5d44.184a0a406a4.Coremail.linma@zju.edu.cn>
Subject: Re: [PATCH v2] io_uring/filetable: fix file reference underflow
Message-Id: <166914522977.324391.10873052802740618844.b4-ty@kernel.dk>
Date:   Tue, 22 Nov 2022 12:27:09 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-28747
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 23 Nov 2022 02:40:15 +0800 (GMT+08:00), Lin Ma wrote:
> There is an interesting reference bug when -ENOMEM occurs in calling of
> io_install_fixed_file(). KASan report like below:
> 
> [   14.057131] ==================================================================
> [   14.059161] BUG: KASAN: use-after-free in unix_get_socket+0x10/0x90
> [   14.060975] Read of size 8 at addr ffff88800b09cf20 by task kworker/u8:2/45
> [   14.062684]
> [   14.062768] CPU: 2 PID: 45 Comm: kworker/u8:2 Not tainted 6.1.0-rc4 #1
> [   14.063099] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> [   14.063666] Workqueue: events_unbound io_ring_exit_work
> [   14.063936] Call Trace:
> [   14.064065]  <TASK>
> [   14.064175]  dump_stack_lvl+0x34/0x48
> [   14.064360]  print_report+0x172/0x475
> [   14.064547]  ? _raw_spin_lock_irq+0x83/0xe0
> [   14.064758]  ? __virt_addr_valid+0xef/0x170
> [   14.064975]  ? unix_get_socket+0x10/0x90
> [   14.065167]  kasan_report+0xad/0x130
> [   14.065353]  ? unix_get_socket+0x10/0x90
> [   14.065553]  unix_get_socket+0x10/0x90
> [   14.065744]  __io_sqe_files_unregister+0x87/0x1e0
> [   14.065989]  ? io_rsrc_refs_drop+0x1c/0xd0
> [   14.066199]  io_ring_exit_work+0x388/0x6a5
> [   14.066410]  ? io_uring_try_cancel_requests+0x5bf/0x5bf
> [   14.066674]  ? try_to_wake_up+0xdb/0x910
> [   14.066873]  ? virt_to_head_page+0xbe/0xbe
> [   14.067080]  ? __schedule+0x574/0xd20
> [   14.067273]  ? read_word_at_a_time+0xe/0x20
> [   14.067492]  ? strscpy+0xb5/0x190
> [   14.067665]  process_one_work+0x423/0x710
> [   14.067879]  worker_thread+0x2a2/0x6f0
> [   14.068073]  ? process_one_work+0x710/0x710
> [   14.068284]  kthread+0x163/0x1a0
> [   14.068454]  ? kthread_complete_and_exit+0x20/0x20
> [   14.068697]  ret_from_fork+0x22/0x30
> [   14.068886]  </TASK>
> [   14.069000]
> [   14.069088] Allocated by task 289:
> [   14.069269]  kasan_save_stack+0x1e/0x40
> [   14.069463]  kasan_set_track+0x21/0x30
> [   14.069652]  __kasan_slab_alloc+0x58/0x70
> [   14.069899]  kmem_cache_alloc+0xc5/0x200
> [   14.070100]  __alloc_file+0x20/0x160
> [   14.070283]  alloc_empty_file+0x3b/0xc0
> [   14.070479]  path_openat+0xc3/0x1770
> [   14.070689]  do_filp_open+0x150/0x270
> [   14.070888]  do_sys_openat2+0x113/0x270
> [   14.071081]  __x64_sys_openat+0xc8/0x140
> [   14.071283]  do_syscall_64+0x3b/0x90
> [   14.071466]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [   14.071791]
> [   14.071874] Freed by task 0:
> [   14.072027]  kasan_save_stack+0x1e/0x40
> [   14.072224]  kasan_set_track+0x21/0x30
> [   14.072415]  kasan_save_free_info+0x2a/0x50
> [   14.072627]  __kasan_slab_free+0x106/0x190
> [   14.072858]  kmem_cache_free+0x98/0x340
> [   14.073075]  rcu_core+0x427/0xe50
> [   14.073249]  __do_softirq+0x110/0x3cd
> [   14.073440]
> [   14.073523] Last potentially related work creation:
> [   14.073801]  kasan_save_stack+0x1e/0x40
> [   14.074017]  __kasan_record_aux_stack+0x97/0xb0
> [   14.074264]  call_rcu+0x41/0x550
> [   14.074436]  task_work_run+0xf4/0x170
> [   14.074619]  exit_to_user_mode_prepare+0x113/0x120
> [   14.074858]  syscall_exit_to_user_mode+0x1d/0x40
> [   14.075092]  do_syscall_64+0x48/0x90
> [   14.075272]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [   14.075529]
> [   14.075612] Second to last potentially related work creation:
> [   14.075900]  kasan_save_stack+0x1e/0x40
> [   14.076098]  __kasan_record_aux_stack+0x97/0xb0
> [   14.076325]  task_work_add+0x72/0x1b0
> [   14.076512]  fput+0x65/0xc0
> [   14.076657]  filp_close+0x8e/0xa0
> [   14.076825]  __x64_sys_close+0x15/0x50
> [   14.077019]  do_syscall_64+0x3b/0x90
> [   14.077199]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [   14.077448]
> [   14.077530] The buggy address belongs to the object at ffff88800b09cf00
> [   14.077530]  which belongs to the cache filp of size 232
> [   14.078105] The buggy address is located 32 bytes inside of
> [   14.078105]  232-byte region [ffff88800b09cf00, ffff88800b09cfe8)
> [   14.078685]
> [   14.078771] The buggy address belongs to the physical page:
> [   14.079046] page:000000001bd520e7 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88800b09de00 pfn:0xb09c
> [   14.079575] head:000000001bd520e7 order:1 compound_mapcount:0 compound_pincount:0
> [   14.079946] flags: 0x100000000010200(slab|head|node=0|zone=1)
> [   14.080244] raw: 0100000000010200 0000000000000000 dead000000000001 ffff88800493cc80
> [   14.080629] raw: ffff88800b09de00 0000000080190018 00000001ffffffff 0000000000000000
> [   14.081016] page dumped because: kasan: bad access detected
> [   14.081293]
> [   14.081376] Memory state around the buggy address:
> [   14.081618]  ffff88800b09ce00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   14.081974]  ffff88800b09ce80: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
> [   14.082336] >ffff88800b09cf00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [   14.082690]                                ^
> [   14.082909]  ffff88800b09cf80: fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc
> [   14.083266]  ffff88800b09d000: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
> [   14.083622] ==================================================================
> 
> [...]

Applied, thanks!

[1/1] io_uring/filetable: fix file reference underflow
      commit: b4255aa5c6aa8f7e1a74627e7df008563be7938c

Best regards,
-- 
Jens Axboe


