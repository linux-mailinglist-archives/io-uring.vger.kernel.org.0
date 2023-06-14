Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A601172F14E
	for <lists+io-uring@lfdr.de>; Wed, 14 Jun 2023 03:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjFNBEq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Jun 2023 21:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241829AbjFNBEm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Jun 2023 21:04:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE1971BE3
        for <io-uring@vger.kernel.org>; Tue, 13 Jun 2023 18:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686704637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r7twEom+IZ2ulz+CER52rsFC7CN5qyfzZtkBBXFDNLQ=;
        b=JrVYTKiQzSJ8G+2WqL7m7UgPdWy4qBJArQDo/EUPWIma1RrQ0+lUq9L+1CfpswzMkvWNoQ
        sWPtAy+C/jKrV3ktSqnoRzA7gKb8dJwmUHkGv4ahNCpXubWn0borfoDDbrDVqi8EwwK0uz
        5PjS2VdKv8ci1VYFKs9+EquuhqUfwBo=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362-gNczvnKuPqOyLPIXYXnLNg-1; Tue, 13 Jun 2023 21:03:56 -0400
X-MC-Unique: gNczvnKuPqOyLPIXYXnLNg-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-25c23b4026cso670574a91.0
        for <io-uring@vger.kernel.org>; Tue, 13 Jun 2023 18:03:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686704635; x=1689296635;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r7twEom+IZ2ulz+CER52rsFC7CN5qyfzZtkBBXFDNLQ=;
        b=JD71ugATbdj45ErxQCOPnbOJJJgjR6kf5F+7kUmfoIobMdD2vaAwQe2iw8AUFReVIL
         IoV3z53mkuw0GezohDmGv44nxkjA2BjBhQkC+RsdNgBkT/7ZqhB/D9Klz+nnlrvSHco0
         Cx5uXPjkpKn+A478sF18t2me+cCROse5K+1xmm6KtmQqkWDzUNUmE8bbDX0dIwmIab8A
         ZYZQAXk3ljMJskkWHBwXPnpdHVq2hCvUDTQaMWyw+vdMYs/Qbz8Qo86MQeq/HF2lVzrp
         dA+lP4PiPWAR9mYehJoABCsv2YLhJC3gZRmNYtBuSNz/5qpKC0+uhLuXHhXJhw66HlYg
         PVIQ==
X-Gm-Message-State: AC+VfDy5VggpSB8ma3UQCWXvqEcfmGo1eyiJh7X9rz3SeE7Gr5mZ7xC5
        ZPYrZJNIl7AnbxXAAFVLQ2oP90PnnGJJKTTwiGRWa53au3kSKQpF7xsqdYmXIJyRbTYJXxHbXT3
        DsIGqdxKtRDRaUWYYrB9epQXxgg8JoQ==
X-Received: by 2002:a17:90a:303:b0:253:340d:77d8 with SMTP id 3-20020a17090a030300b00253340d77d8mr352811pje.33.1686704634159;
        Tue, 13 Jun 2023 18:03:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Hpnly5foHYf6OmKn8m3djrEQT+p1cPu/x9iafUlYH7BBE8HJy+muxLY2QbkZTQ0t/5uZeAQ==
X-Received: by 2002:a17:90a:303:b0:253:340d:77d8 with SMTP id 3-20020a17090a030300b00253340d77d8mr352783pje.33.1686704633293;
        Tue, 13 Jun 2023 18:03:53 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ms18-20020a17090b235200b0025bbe90d3cbsm6026588pjb.44.2023.06.13.18.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 18:03:52 -0700 (PDT)
Date:   Wed, 14 Jun 2023 09:03:48 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] io_uring/io-wq: don't clear PF_IO_WORKER on exit
Message-ID: <20230614010348.2o6wjax543teosph@zlang-mailbox>
References: <2392dcb4-71f4-1109-614b-4e2083c0941e@kernel.dk>
 <20230614005449.awc2ncxl5lb2eg6m@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614005449.awc2ncxl5lb2eg6m@zlang-mailbox>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 14, 2023 at 08:54:49AM +0800, Zorro Lang wrote:
> On Mon, Jun 12, 2023 at 12:11:57PM -0600, Jens Axboe wrote:
> > A recent commit gated the core dumping task exit logic on current->flags
> > remaining consistent in terms of PF_{IO,USER}_WORKER at task exit time.
> > This exposed a problem with the io-wq handling of that, which explicitly
> > clears PF_IO_WORKER before calling do_exit().
> > 
> > The reasons for this manual clear of PF_IO_WORKER is historical, where
> > io-wq used to potentially trigger a sleep on exit. As the io-wq thread
> > is exiting, it should not participate any further accounting. But these
> > days we don't need to rely on current->flags anymore, so we can safely
> > remove the PF_IO_WORKER clearing.
> > 
> > Reported-by: Zorro Lang <zlang@redhat.com>
> > Reported-by: Dave Chinner <david@fromorbit.com>
> > Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Link: https://lore.kernel.org/all/ZIZSPyzReZkGBEFy@dread.disaster.area/
> > Fixes: f9010dbdce91 ("fork, vhost: Use CLONE_THREAD to fix freezer/ps regression")
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > 
> > ---
> 
> Hi,
> 
> This patch fix the issue I reported. The bug can be reproduced on v6.4-rc6,
> then test passed on v6.4-rc6 with this patch.
> 
> But I found another KASAN bug [1] on aarch64 machine, by running generic/388.
> I hit that 3 times. And hit a panic [2] (once after that kasan bug) on a x86_64
> with pmem device (mount with dax=never), by running geneirc/388 too.

Oh, x86_64 with pmem can reproduce this kasan bug nearly 100%, no matter the
mount option. Then aarch64 (4k page size) can reproduce it too. But I didn't
hit it on ppc64le (64k page size). Other testing jobs haven't been done, currently
I only have these results.

Thanks,
Zorro

> 
> Thanks,
> Zorro
> 
> [1]
> [16505.224912] run fstests generic/388 at 2023-06-13 13:01:12 
> [16507.375208] XFS (vda3): Mounting V5 Filesystem c1139709-d136-4d28-9f24-ba77c4da95cd 
> [16507.390655] XFS (vda3): Ending clean mount 
> [16507.417771] XFS (vda3): User initiated shutdown received. 
> [16507.418371] XFS (vda3): Metadata I/O Error (0x4) detected at xfs_fs_goingdown+0x58/0x180 [xfs] (fs/xfs/xfs_fsops.c:483).  Shutting down filesystem. 
> [16507.419419] XFS (vda3): Please unmount the filesystem and rectify the problem(s) 
> [16507.447760] XFS (vda3): Unmounting Filesystem c1139709-d136-4d28-9f24-ba77c4da95cd 
> [16508.015675] XFS (vda3): Mounting V5 Filesystem 0e0c8b4e-9c4b-4804-a5f6-a7909cc599aa 
> [16508.032248] XFS (vda3): Ending clean mount 
> [16509.082072] XFS (vda3): User initiated shutdown received. 
> [16509.082538] XFS (vda3): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe8/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [16509.083606] XFS (vda3): Please unmount the filesystem and rectify the problem(s) 
> [16509.737031] XFS (vda3): Unmounting Filesystem 0e0c8b4e-9c4b-4804-a5f6-a7909cc599aa 
> [16510.077278] XFS (vda3): Mounting V5 Filesystem 0e0c8b4e-9c4b-4804-a5f6-a7909cc599aa 
> [16510.387017] XFS (vda3): Starting recovery (logdev: internal) 
> [16510.769548] XFS (vda3): Ending recovery (logdev: internal) 
> [16512.836365] XFS (vda3): User initiated shutdown received. 
> [16512.839914] XFS (vda3): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe8/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [16512.840959] XFS (vda3): Please unmount the filesystem and rectify the problem(s) 
> [16512.999722] ================================================================== 
> [16513.000246] BUG: KASAN: slab-use-after-free in io_wq_worker_running+0x108/0x120 
> [16513.000734] Read of size 4 at addr ffff0000da65b804 by task iou-wrk-1240163/1240168 
> [16513.001232]  
> [16513.001344] CPU: 2 PID: 1240168 Comm: iou-wrk-1240163 Kdump: loaded Not tainted 6.4.0-rc6+ #1 
> [16513.001910] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015 
> [16513.002396] Call trace: 
> [16513.002571]  dump_backtrace+0x9c/0x120 
> [16513.002844]  show_stack+0x1c/0x30 
> [16513.003064]  dump_stack_lvl+0xe0/0x168 
> [16513.003323]  print_address_description.constprop.0+0x80/0x390 
> [16513.003721]  print_report+0xa4/0x268 
> [16513.003969]  kasan_report+0x80/0xc0 
> [16513.004216]  __asan_report_load4_noabort+0x1c/0x28 
> [16513.004550]  io_wq_worker_running+0x108/0x120 
> [16513.004864]  schedule+0x178/0x208 
> [16513.005124]  coredump_task_exit+0x1e0/0x380 
> [16513.005434]  do_exit+0x16c/0xbc0 
> [16513.005675]  io_wq_worker+0x4dc/0x828 
> [16513.005936]  ret_from_fork+0x10/0x20 
> [16513.006188]  
> [16513.006312] Allocated by task 1240163: 
> [16513.006585]  kasan_save_stack+0x28/0x50 
> [16513.006868]  kasan_set_track+0x28/0x38 
> [16513.007156]  kasan_save_alloc_info+0x20/0x30 
> [16513.007458]  __kasan_kmalloc+0x98/0xb0 
> [16513.007725]  kmalloc_trace+0x78/0x90 
> [16513.007981]  create_io_worker+0xb0/0x478 
> [16513.008262]  io_wq_create_worker+0x128/0x200 
> [16513.008570]  io_wq_enqueue+0x304/0x6d0 
> [16513.008839]  io_queue_iowq+0x210/0x5a8 
> [16513.009116]  io_queue_async+0x120/0x430 
> [16513.009400]  io_submit_sqes+0xa44/0xfd0 
> [16513.009690]  __do_sys_io_uring_enter+0x554/0xec8 
> [16513.010035]  __arm64_sys_io_uring_enter+0xc4/0x138 
> [16513.010376]  invoke_syscall.constprop.0+0xd8/0x1d8 
> [16513.010719]  el0_svc_common.constprop.0+0x234/0x2c0 
> [16513.011065]  do_el0_svc+0x50/0x108 
> [16513.011314]  el0_svc+0x48/0x120 
> [16513.011538]  el0t_64_sync_handler+0xb4/0x130 
> [16513.011840]  el0t_64_sync+0x17c/0x180 
> [16513.012097]  
> [16513.012206] Freed by task 1239074: 
> [16513.012470]  kasan_save_stack+0x28/0x50 
> [16513.012753]  kasan_set_track+0x28/0x38 
> [16513.013032]  kasan_save_free_info+0x34/0x58 
> [16513.013329]  __kasan_slab_free+0xe4/0x158 
> [16513.013613]  slab_free_freelist_hook+0xf0/0x1d0 
> [16513.013939]  kmem_cache_free_bulk.part.0+0x250/0x4d0 
> [16513.014300]  kmem_cache_free_bulk+0x18/0x28 
> [16513.014600]  kvfree_rcu_bulk+0x338/0x420 
> [16513.014884]  kvfree_rcu_drain_ready+0x1fc/0x5c0 
> [16513.015212]  kfree_rcu_monitor+0x4c/0x980 
> [16513.015503]  process_one_work+0x79c/0x1678 
> [16513.015805]  worker_thread+0x3d8/0xc60 
> [16513.016078]  kthread+0x27c/0x300 
> [16513.016310]  ret_from_fork+0x10/0x20 
> [16513.016574]  
> [16513.016699] Last potentially related work creation: 
> [16513.017097]  kasan_save_stack+0x28/0x50 
> [16513.017396]  __kasan_record_aux_stack+0x98/0xc0 
> [16513.017741]  kasan_record_aux_stack_noalloc+0x10/0x18 
> [16513.018109]  kvfree_call_rcu+0x110/0x458 
> [16513.018416]  io_wq_worker+0x4c8/0x828 
> [16513.018696]  ret_from_fork+0x10/0x20 
> [16513.018972]  
> [16513.019098] Second to last potentially related work creation: 
> [16513.019518]  kasan_save_stack+0x28/0x50 
> [16513.019834]  __kasan_record_aux_stack+0x98/0xc0 
> [16513.020178]  kasan_record_aux_stack_noalloc+0x10/0x18 
> [16513.020559]  insert_work+0x54/0x290 
> [16513.020814]  __queue_work+0x4e4/0xf08 
> [16513.021079]  queue_work_on+0x110/0x160 
> [16513.021346]  xlog_cil_push_now.isra.0+0x154/0x1d8 [xfs] 
> [16513.021881]  xlog_cil_force_seq+0x20c/0x938 [xfs] 
> [16513.022359]  xfs_log_force_seq+0x268/0x840 [xfs] 
> [16513.022829]  xfs_log_force_inode+0xe8/0x140 [xfs] 
> [16513.023302]  xfs_dir_fsync+0x104/0x328 [xfs] 
> [16513.023746]  vfs_fsync_range+0xc4/0x1f0 
> [16513.024020]  do_fsync+0x40/0x88 
> [16513.024245]  __arm64_sys_fsync+0x38/0x58 
> [16513.024524]  invoke_syscall.constprop.0+0xd8/0x1d8 
> [16513.024875]  el0_svc_common.constprop.0+0x234/0x2c0 
> [16513.025221]  do_el0_svc+0x50/0x108 
> [16513.025470]  el0_svc+0x48/0x120 
> [16513.025714]  el0t_64_sync_handler+0xb4/0x130 
> [16513.026033]  el0t_64_sync+0x17c/0x180 
> [16513.026311]  
> [16513.026421] The buggy address belongs to the object at ffff0000da65b800 
> [16513.026421]  which belongs to the cache kmalloc-512 of size 512 
> [16513.027308] The buggy address is located 4 bytes inside of 
> [16513.027308]  freed 512-byte region [ffff0000da65b800, ffff0000da65ba00) 
> [16513.028163]  
> [16513.028282] The buggy address belongs to the physical page: 
> [16513.028687] page:0000000099e24e4d refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x11a658 
> [16513.029385] head:0000000099e24e4d order:2 entire_mapcount:0 nr_pages_mapped:0 pincount:0 
> [16513.029957] anon flags: 0x17ffff800010200(slab|head|node=0|zone=2|lastcpupid=0xfffff) 
> [16513.030548] page_type: 0xffffffff() 
> [16513.030816] raw: 017ffff800010200 ffff0000c0002600 0000000000000000 dead000000000001 
> [16513.031374] raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000 
> [16513.031929] page dumped because: kasan: bad access detected 
> [16513.032327]  
> [16513.032441] Memory state around the buggy address: 
> [16513.032821]  ffff0000da65b700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc 
> [16513.033336]  ffff0000da65b780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc 
> [16513.033865] >ffff0000da65b800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb 
> [16513.034378]                    ^ 
> [16513.034609]  ffff0000da65b880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb 
> [16513.035116]  ffff0000da65b900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb 
> [16513.035626] ================================================================== 
> [16513.036232] Disabling lock debugging due to kernel taint 
> [16513.262535] XFS (vda3): Unmounting Filesystem 0e0c8b4e-9c4b-4804-a5f6-a7909cc599aa 
> [16513.623346] XFS (vda3): Mounting V5 Filesystem 0e0c8b4e-9c4b-4804-a5f6-a7909cc599aa 
> [16513.735177] XFS (vda3): Starting recovery (logdev: internal) 
> [16514.226365] XFS (vda3): Ending recovery (logdev: internal) 
> [16514.253119] XFS (vda3): User initiated shutdown received. 
> [16514.253573] XFS (vda3): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe8/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [16514.254595] XFS (vda3): Please unmount the filesystem and rectify the problem(s) 
> [16514.432583] XFS (vda3): Unmounting Filesystem 0e0c8b4e-9c4b-4804-a5f6-a7909cc599aa 
> [16514.776940] XFS (vda3): Mounting V5 Filesystem 0e0c8b4e-9c4b-4804-a5f6-a7909cc599aa 
> [16514.800218] XFS (vda3): Starting recovery (logdev: internal) 
> [16514.807050] XFS (vda3): Ending recovery (logdev: internal) 
> [16514.826857] XFS (vda3): Unmounting Filesystem 0e0c8b4e-9c4b-4804-a5f6-a7909cc599aa 
> [16515.205970] XFS (vda3): Mounting V5 Filesystem 0e0c8b4e-9c4b-4804-a5f6-a7909cc599aa 
> [16515.220225] XFS (vda3): Ending clean mount 
> [16517.252566] XFS (vda3): User initiated shutdown received. 
> [16517.252990] XFS (vda3): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe8/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [16517.253979] XFS (vda3): Please unmount the filesystem and rectify the problem(s) 
> [16517.690386] XFS (vda3): Unmounting Filesystem 0e0c8b4e-9c4b-4804-a5f6-a7909cc599aa 
> [16517.977164] XFS (vda3): Mounting V5 Filesystem 0e0c8b4e-9c4b-4804-a5f6-a7909cc599aa 
> [16518.133228] XFS (vda3): Starting recovery (logdev: internal) 
> [16518.939479] XFS (vda3): Ending recovery (logdev: internal) 
> [16518.963049] XFS (vda3): User initiated shutdown received. 
> [16518.963057] XFS (vda3): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0 
> [16518.963481] XFS (vda3): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe8/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [16518.965017] XFS (vda3): Please unmount the filesystem and rectify the problem(s) 
> [16519.204814] XFS (vda3): Unmounting Filesystem 0e0c8b4e-9c4b-4804-a5f6-a7909cc599aa 
> [16519.463997] XFS (vda3): Mounting V5 Filesystem 0e0c8b4e-9c4b-4804-a5f6-a7909cc599aa 
> [16519.490002] XFS (vda3): Starting recovery (logdev: internal) 
> [16519.494259] XFS (vda3): Ending recovery (logdev: internal) 
> ...
> ...
> 
> [2]
> [ 8365.864086] run fstests generic/388 at 2023-06-13 08:49:12 
> [ 8368.274443] XFS (pmem1): Mounting V5 Filesystem 3c93b02c-97e9-4cc2-9173-73cb6d8c1004 
> [ 8368.293316] XFS (pmem1): Ending clean mount 
> [ 8368.318944] XFS (pmem1): User initiated shutdown received. 
> [ 8368.325440] XFS (pmem1): Metadata I/O Error (0x4) detected at xfs_fs_goingdown+0x4b/0x180 [xfs] (fs/xfs/xfs_fsops.c:483).  Shutting down filesystem. 
> [ 8368.338972] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8368.362196] XFS (pmem1): Unmounting Filesystem 3c93b02c-97e9-4cc2-9173-73cb6d8c1004 
> [ 8368.660094] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8368.678482] XFS (pmem1): Ending clean mount 
> [ 8370.719061] XFS (pmem1): User initiated shutdown received. 
> [ 8370.724599] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8370.738586] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8371.425668] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8371.601187] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8371.644024] XFS (pmem1): Starting recovery (logdev: internal) 
> [ 8374.884353] XFS (pmem1): Ending recovery (logdev: internal) 
> [ 8376.930483] XFS (pmem1): User initiated shutdown received. 
> [ 8376.930569] iomap_finish_ioend: 1 callbacks suppressed 
> [ 8376.930576] pmem1: writeback error on inode 29392430, offset 3960832, sector 18409168 
> [ 8376.936091] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8376.941475] pmem1: writeback error on inode 29392430, offset 7528448, sector 18425224 
> [ 8376.949302] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8377.575276] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8377.753574] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8377.792831] XFS (pmem1): Starting recovery (logdev: internal) 
> [ 8380.328214] XFS (pmem1): Ending recovery (logdev: internal) 
> [ 8380.373691] XFS (pmem1): User initiated shutdown received. 
> [ 8380.373702] XFS (pmem1): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0 
> [ 8380.373947] XFS (pmem1): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0 
> [ 8380.376499] XFS (pmem1): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0 
> [ 8380.379233] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8380.417452] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8380.825341] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8380.956173] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8380.983834] XFS (pmem1): Starting recovery (logdev: internal) 
> [ 8381.001996] XFS (pmem1): Ending recovery (logdev: internal) 
> [ 8382.043732] XFS (pmem1): User initiated shutdown received. 
> [ 8382.044041] pmem1: writeback error on inode 6374535, offset 45056, sector 4070976 
> [ 8382.049348] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8382.070775] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8382.624394] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8382.812699] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8382.846934] XFS (pmem1): Starting recovery (logdev: internal) 
> [ 8383.719470] XFS (pmem1): Ending recovery (logdev: internal) 
> [ 8383.747107] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8383.868827] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8383.895176] XFS (pmem1): Ending clean mount 
> [ 8383.935475] XFS (pmem1): User initiated shutdown received. 
> [ 8383.935563] XFS (pmem1): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0 
> [ 8383.936730] pmem1: writeback error on inode 6294790, offset 602112, sector 4021136 
> [ 8383.938410] XFS (pmem1): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0 
> [ 8383.941017] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8383.977798] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8384.390615] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8384.524097] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8384.553122] XFS (pmem1): Starting recovery (logdev: internal) 
> [ 8384.575037] XFS (pmem1): Ending recovery (logdev: internal) 
> [ 8384.599489] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8384.720213] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8384.749210] XFS (pmem1): Ending clean mount 
> [ 8386.789264] XFS (pmem1): User initiated shutdown received. 
> [ 8386.795506] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8386.808598] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8387.449606] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8387.656847] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8387.696287] XFS (pmem1): Starting recovery (logdev: internal) 
> [ 8389.867734] XFS (pmem1): Ending recovery (logdev: internal) 
> [ 8389.896231] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8390.023586] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8390.051077] XFS (pmem1): Ending clean mount 
> [ 8392.091249] XFS (pmem1): User initiated shutdown received. 
> [ 8392.097193] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8392.110286] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8392.747591] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8392.970949] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8393.010107] XFS (pmem1): Starting recovery (logdev: internal) 
> [ 8392.009668] restraintd[2003]: *** Current Time: Tue Jun 13 08:49:40 2023  Localwatchdog at: Thu Jun 15 06:31:39 2023 
> [ 8394.908469] XFS (pmem1): Ending recovery (logdev: internal) 
> [ 8396.954732] XFS (pmem1): User initiated shutdown received. 
> [ 8396.960271] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8396.973361] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8397.214607] ================================================================== 
> [ 8397.221835] BUG: KASAN: slab-use-after-free in io_wq_worker_running+0xd9/0xf0 
> [ 8397.228976] Read of size 4 at addr ffff888609f48404 by task iou-wrk-1340274/1340276 
> [ 8397.236629]  
> [ 8397.238128] CPU: 15 PID: 1340276 Comm: iou-wrk-1340274 Kdump: loaded Not tainted 6.4.0-rc6+ #1 
> [ 8397.246733] Hardware name: Dell Inc. PowerEdge R6515/07PXPY, BIOS 2.3.6 07/06/2021 
> [ 8397.254300] Call Trace: 
> [ 8397.256750]  <TASK> 
> [ 8397.258858]  dump_stack_lvl+0x60/0xb0 
> [ 8397.262525]  print_address_description.constprop.0+0x2c/0x3e0 
> [ 8397.268278]  print_report+0xb5/0x270 
> [ 8397.271859]  ? kasan_addr_to_slab+0x9/0xa0 
> [ 8397.275955]  ? io_wq_worker_running+0xd9/0xf0 
> [ 8397.280317]  kasan_report+0x8c/0xc0 
> [ 8397.283808]  ? io_wq_worker_running+0xd9/0xf0 
> [ 8397.288170]  ? do_exit+0x329/0xf70 
> [ 8397.291572]  io_wq_worker_running+0xd9/0xf0 
> [ 8397.295758]  do_exit+0x329/0xf70 
> [ 8397.298993]  ? __pfx_kvfree_call_rcu+0x10/0x10 
> [ 8397.303438]  ? __pfx_do_exit+0x10/0x10 
> [ 8397.307192]  ? io_wq_worker+0x668/0xa70 
> [ 8397.311031]  io_wq_worker+0x6c7/0xa70 
> [ 8397.314700]  ? __pfx_io_wq_worker+0x10/0x10 
> [ 8397.318881]  ? __pfx___lock_release+0x10/0x10 
> [ 8397.323241]  ? __pfx_do_raw_spin_trylock+0x10/0x10 
> [ 8397.328035]  ? __pfx_io_wq_worker+0x10/0x10 
> [ 8397.332221]  ret_from_fork+0x2c/0x50 
> [ 8397.335803]  </TASK> 
> [ 8397.337992]  
> [ 8397.339488] Allocated by task 1340274: 
> [ 8397.343242]  kasan_save_stack+0x1e/0x40 
> [ 8397.347081]  kasan_set_track+0x21/0x30 
> [ 8397.350834]  __kasan_kmalloc+0x7b/0x90 
> [ 8397.354586]  create_io_worker+0xbe/0x520 
> [ 8397.358513]  io_wq_enqueue+0x57e/0xa30 
> [ 8397.362264]  io_queue_iowq+0x226/0x450 
> [ 8397.366019]  io_queue_async+0x123/0x480 
> [ 8397.369857]  io_submit_sqes+0xac8/0xeb0 
> [ 8397.373695]  __do_sys_io_uring_enter+0x4f3/0x840 
> [ 8397.378314]  do_syscall_64+0x5c/0x90 
> [ 8397.381896]  entry_SYSCALL_64_after_hwframe+0x72/0xdc 
> [ 8397.386947]  
> [ 8397.388448] Freed by task 1339903: 
> [ 8397.391852]  kasan_save_stack+0x1e/0x40 
> [ 8397.395692]  kasan_set_track+0x21/0x30 
> [ 8397.399443]  kasan_save_free_info+0x2a/0x50 
> [ 8397.403631]  __kasan_slab_free+0x106/0x190 
> [ 8397.407729]  slab_free_freelist_hook+0x11d/0x1d0 
> [ 8397.412349]  kmem_cache_free_bulk.part.0+0x1f3/0x3c0 
> [ 8397.417313]  kvfree_rcu_bulk+0x3ce/0x4e0 
> [ 8397.421239]  kvfree_rcu_drain_ready+0x24f/0x760 
> [ 8397.425774]  kfree_rcu_monitor+0x44/0xe10 
> [ 8397.429784]  process_one_work+0x8c2/0x1570 
> [ 8397.433884]  worker_thread+0x5be/0xef0 
> [ 8397.437636]  kthread+0x2f4/0x3d0 
> [ 8397.440868]  ret_from_fork+0x2c/0x50 
> [ 8397.444450]  
> [ 8397.445949] Last potentially related work creation: 
> [ 8397.450827]  kasan_save_stack+0x1e/0x40 
> [ 8397.454668]  __kasan_record_aux_stack+0x97/0xb0 
> [ 8397.459198]  kvfree_call_rcu+0x103/0x480 
> [ 8397.463125]  io_wq_worker+0x6b3/0xa70 
> [ 8397.466789]  ret_from_fork+0x2c/0x50 
> [ 8397.470369]  
> [ 8397.471868] The buggy address belongs to the object at ffff888609f48400 
> [ 8397.471868]  which belongs to the cache kmalloc-512 of size 512 
> [ 8397.484375] The buggy address is located 4 bytes inside of 
> [ 8397.484375]  freed 512-byte region [ffff888609f48400, ffff888609f48600) 
> [ 8397.496447]  
> [ 8397.497946] The buggy address belongs to the physical page: 
> [ 8397.503520] page:00000000f81b3055 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x609f48 
> [ 8397.512907] head:00000000f81b3055 order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0 
> [ 8397.520990] flags: 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff) 
> [ 8397.528384] page_type: 0xffffffff() 
> [ 8397.531877] raw: 0017ffffc0010200 ffff88860004cc80 dead000000000100 dead000000000122 
> [ 8397.539616] raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000 
> [ 8397.547354] page dumped because: kasan: bad access detected 
> [ 8397.552927]  
> [ 8397.554425] Memory state around the buggy address: 
> [ 8397.559218]  ffff888609f48300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc 
> [ 8397.566437]  ffff888609f48380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc 
> [ 8397.573657] >ffff888609f48400: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb 
> [ 8397.580877]                    ^ 
> [ 8397.584109]  ffff888609f48480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb 
> [ 8397.591329]  ffff888609f48500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb 
> [ 8397.598546] ================================================================== 
> [ 8397.605801] Disabling lock debugging due to kernel taint 
> [ 8397.852031] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8397.997724] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8398.024623] XFS (pmem1): Starting recovery (logdev: internal) 
> [ 8399.109910] XFS (pmem1): Ending recovery (logdev: internal) 
> [ 8399.127813] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8399.205606] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8399.225964] XFS (pmem1): Ending clean mount 
> [ 8400.251290] XFS (pmem1): User initiated shutdown received. 
> [ 8400.256812] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8400.270262] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8400.604837] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8400.762347] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8400.788685] XFS (pmem1): Starting recovery (logdev: internal) 
> [ 8401.455999] XFS (pmem1): Ending recovery (logdev: internal) 
> [ 8403.485499] XFS (pmem1): User initiated shutdown received. 
> [ 8403.491496] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8403.504570] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8403.918900] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8404.071291] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8404.102643] XFS (pmem1): Starting recovery (logdev: internal) 
> [ 8406.143287] XFS (pmem1): Ending recovery (logdev: internal) 
> [ 8406.161472] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8406.242454] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8406.262542] XFS (pmem1): Ending clean mount 
> [ 8406.287327] XFS (pmem1): User initiated shutdown received. 
> [ 8406.287350] XFS (pmem1): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0 
> [ 8406.287468] XFS (pmem1): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0 
> [ 8406.292852] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8406.293069] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8406.524860] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8406.626770] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8406.647060] XFS (pmem1): Starting recovery (logdev: internal) 
> [ 8406.663675] XFS (pmem1): Ending recovery (logdev: internal) 
> [ 8406.680155] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8406.756538] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8406.777642] XFS (pmem1): Ending clean mount 
> [ 8406.802489] XFS (pmem1): User initiated shutdown received. 
> [ 8406.802512] XFS (pmem1): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0 
> [ 8406.803211] XFS (pmem1): xfs_imap_lookup: xfs_ialloc_read_agi() returned error -5, agno 0 
> [ 8406.808007] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8406.837523] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8407.073851] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8407.182295] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8407.201895] XFS (pmem1): Starting recovery (logdev: internal) 
> [ 8407.214975] XFS (pmem1): Ending recovery (logdev: internal) 
> [ 8407.231390] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8407.317269] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8407.340883] XFS (pmem1): Ending clean mount 
> [ 8409.367221] XFS (pmem1): User initiated shutdown received. 
> [ 8409.372743] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8409.386050] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8409.769341] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8409.934824] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8409.964592] XFS (pmem1): Starting recovery (logdev: internal) 
> [ 8411.426464] XFS (pmem1): Ending recovery (logdev: internal) 
> [ 8412.455356] XFS (pmem1): User initiated shutdown received. 
> [ 8412.460875] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8412.473949] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8412.810227] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8412.973145] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8412.998560] XFS (pmem1): Starting recovery (logdev: internal) 
> [ 8413.455386] XFS (pmem1): Ending recovery (logdev: internal) 
> [ 8414.483856] XFS (pmem1): User initiated shutdown received. 
> [ 8414.489379] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8414.502520] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8414.848931] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8415.007610] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8415.033772] XFS (pmem1): Starting recovery (logdev: internal) 
> [ 8415.443346] XFS (pmem1): Ending recovery (logdev: internal) 
> [ 8415.461155] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8415.553187] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8415.573764] XFS (pmem1): Ending clean mount 
> [ 8416.598523] XFS (pmem1): User initiated shutdown received. 
> [ 8416.604049] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8416.617127] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8416.934096] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8417.106652] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8417.128596] XFS (pmem1): Starting recovery (logdev: internal) 
> [ 8417.254168] XFS (pmem1): Ending recovery (logdev: internal) 
> [ 8417.271833] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8417.346746] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8417.369479] XFS (pmem1): Ending clean mount 
> [ 8417.395549] XFS (pmem1): User initiated shutdown received. 
> [ 8417.395688] pmem1: writeback error on inode 6639562, offset 245760, sector 4396792 
> [ 8417.401089] pmem1: writeback error on inode 6639562, offset 520192, sector 4397328 
> [ 8417.401099] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8417.408700] pmem1: writeback error on inode 379851, offset 696320, sector 1794184 
> [ 8417.416234] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8417.444058] pmem1: writeback error on inode 8519238, offset 1024000, sector 5373600 
> [ 8417.444069] pmem1: writeback error on inode 8519238, offset 1622016, sector 5406856 
> [ 8417.645652] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8417.765394] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8417.786756] XFS (pmem1): Starting recovery (logdev: internal) 
> [ 8417.807733] XFS (pmem1): Ending recovery (logdev: internal) 
> [ 8417.824673] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8417.912097] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8417.934861] XFS (pmem1): Ending clean mount 
> [ 8418.960516] XFS (pmem1): User initiated shutdown received. 
> [ 8418.966034] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8418.979113] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8419.309546] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8419.470480] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8419.494082] XFS (pmem1): Starting recovery (logdev: internal) 
> [ 8419.654738] XFS (pmem1): Ending recovery (logdev: internal) 
> [ 8419.672303] XFS (pmem1): Unmounting Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8419.758252] XFS (pmem1): Mounting V5 Filesystem ce96d037-325c-4e7d-9515-221f48f2ee33 
> [ 8419.780023] XFS (pmem1): Ending clean mount 
> [ 8421.311883] BUG: kernel NULL pointer dereference, address: 0000000000000008 
> [ 8421.318856] #PF: supervisor read access in kernel mode 
> [ 8421.323992] #PF: error_code(0x0000) - not-present page 
> [ 8421.329132] PGD 9327c1067 P4D 9327c1067 PUD 92593f067 PMD 0  
> [ 8421.334799] Oops: 0000 [#1] PREEMPT SMP KASAN NOPTI 
> [ 8421.339678] CPU: 2 PID: 1340923 Comm: fsstress Kdump: loaded Tainted: G    B              6.4.0-rc6+ #1 
> [ 8421.349063] Hardware name: Dell Inc. PowerEdge R6515/07PXPY, BIOS 2.3.6 07/06/2021 
> [ 8421.356629] RIP: 0010:qlist_free_all+0xd3/0x1a0 
> [ 8421.361162] Code: 03 05 d9 71 ad 02 48 8b 48 08 48 89 c2 f6 c1 01 0f 85 ba 00 00 00 0f 1f 44 00 00 48 8b 02 f6 c4 02 b8 00 00 00 00 48 0f 44 d0 <4c> 8b 72 08 e9 50 ff ff ff 49 83 7e 48 00 0f 85 68 ff ff ff 41 f7 
> [ 8421.379906] RSP: 0018:ffffc9000a867438 EFLAGS: 00010246 
> [ 8421.385133] RAX: 0000000000000000 RBX: ffff888b117c0800 RCX: ffffea002c45f008 
> [ 8421.392267] RDX: 0000000000000000 RSI: ffffea00223c6400 RDI: 0000000040000000 
> [ 8421.399399] RBP: 0000000000000000 R08: ffff888b117c0800 R09: 0000000000200012 
> [ 8421.406530] R10: ffffea00223c6400 R11: 0000000000000000 R12: dffffc0000000000 
> [ 8421.413663] R13: ffffc9000a867478 R14: 0000000000000000 R15: ffff88888f194c00 
> [ 8421.420795] FS:  00007f5b21032740(0000) GS:ffff88902de00000(0000) knlGS:0000000000000000 
> [ 8421.428881] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
> [ 8421.434627] CR2: 0000000000000008 CR3: 00000007f8c72000 CR4: 0000000000350ee0 
> [ 8421.441759] Call Trace: 
> [ 8421.444213]  <TASK> 
> [ 8421.446318]  ? __die+0x20/0x70 
> [ 8421.449378]  ? page_fault_oops+0x111/0x220 
> [ 8421.453477]  ? __pfx_page_fault_oops+0x10/0x10 
> [ 8421.457923]  ? do_raw_spin_trylock+0xb5/0x180 
> [ 8421.462285]  ? do_user_addr_fault+0xa5/0xda0 
> [ 8421.466554]  ? rcu_is_watching+0x11/0xb0 
> [ 8421.470483]  ? exc_page_fault+0x5a/0xe0 
> [ 8421.474320]  ? asm_exc_page_fault+0x22/0x30 
> [ 8421.478509]  ? qlist_free_all+0xd3/0x1a0 
> [ 8421.482433]  ? qlist_free_all+0x6d/0x1a0 
> [ 8421.486360]  kasan_quarantine_reduce+0x18b/0x1d0 
> [ 8421.490979]  __kasan_slab_alloc+0x45/0x70 
> [ 8421.494989]  kmem_cache_alloc+0x17c/0x3d0 
> [ 8421.499006]  xfs_inobt_init_common+0x88/0x370 [xfs] 
> [ 8421.504082]  xfs_inobt_cur+0xf6/0x2d0 [xfs] 
> [ 8421.508460]  xfs_iwalk_run_callbacks+0x345/0x540 [xfs] 
> [ 8421.513808]  xfs_iwalk_ag+0x60b/0x890 [xfs] 
> [ 8421.518191]  ? rcu_is_watching+0x11/0xb0 
> [ 8421.522120]  ? __pfx_xfs_iwalk_ag+0x10/0x10 [xfs] 
> [ 8421.527020]  ? rcu_is_watching+0x11/0xb0 
> [ 8421.530947]  ? __kmalloc+0xf9/0x190 
> [ 8421.534441]  ? rcu_is_watching+0x11/0xb0 
> [ 8421.538364]  ? lock_release+0x258/0x300 
> [ 8421.542207]  xfs_iwalk+0x233/0x3e0 [xfs] 
> [ 8421.546324]  ? __pfx_xfs_iwalk+0x10/0x10 [xfs] 
> [ 8421.550967]  ? kmem_cache_alloc+0x38d/0x3d0 
> [ 8421.555155]  ? __pfx_xfs_bulkstat_iwalk+0x10/0x10 [xfs] 
> [ 8421.560570]  ? xfs_trans_alloc_empty+0x7d/0xb0 [xfs] 
> [ 8421.565734]  ? __pfx_xfs_trans_alloc_empty+0x10/0x10 [xfs] 
> [ 8421.571413]  xfs_bulkstat+0x2cd/0x460 [xfs] 
> [ 8421.575797]  ? __pfx_xfs_bulkstat+0x10/0x10 [xfs] 
> [ 8421.580710]  ? __pfx_xfs_fsbulkstat_one_fmt+0x10/0x10 [xfs] 
> [ 8421.586474]  ? __might_fault+0xc5/0x170 
> [ 8421.590312]  ? rcu_is_watching+0x11/0xb0 
> [ 8421.594237]  ? lock_release+0x258/0x300 
> [ 8421.598080]  xfs_ioc_fsbulkstat.isra.0+0x214/0x380 [xfs] 
> [ 8421.603608]  ? __pfx_xfs_ioc_fsbulkstat.isra.0+0x10/0x10 [xfs] 
> [ 8421.609630]  ? xfs_ioc_fsbulkstat.isra.0+0x26d/0x380 [xfs] 
> [ 8421.615308]  ? __pfx_xfs_ioc_fsbulkstat.isra.0+0x10/0x10 [xfs] 
> [ 8421.621332]  ? lock_release+0x258/0x300 
> [ 8421.625174]  xfs_file_ioctl+0xfe0/0x1360 [xfs] 
> [ 8421.629825]  ? __pfx_xfs_file_ioctl+0x10/0x10 [xfs] 
> [ 8421.634895]  ? __pfx_xfs_file_ioctl+0x10/0x10 [xfs] 
> [ 8421.639961]  ? xfs_file_ioctl+0xfe0/0x1360 [xfs] 
> [ 8421.644775]  ? __pfx_xfs_file_ioctl+0x10/0x10 [xfs] 
> [ 8421.649843]  ? __pfx_do_raw_spin_trylock+0x10/0x10 
> [ 8421.654634]  ? rcu_is_watching+0x11/0xb0 
> [ 8421.658559]  ? lock_acquire+0x4d6/0x5e0 
> [ 8421.662400]  ? rcu_is_watching+0x11/0xb0 
> [ 8421.666325]  ? lock_acquire+0x4d6/0x5e0 
> [ 8421.670165]  ? __pfx_lock_acquire+0x10/0x10 
> [ 8421.674352]  ? __pfx_do_vfs_ioctl+0x10/0x10 
> [ 8421.678540]  ? ioctl_has_perm.constprop.0.isra.0+0x26a/0x430 
> [ 8421.684194]  ? __pfx_lock_acquire+0x10/0x10 
> [ 8421.688383]  ? __pfx_ioctl_has_perm.constprop.0.isra.0+0x10/0x10 
> [ 8421.694388]  ? check_prev_add+0x1bf5/0x2110 
> [ 8421.698574]  ? rcu_is_watching+0x11/0xb0 
> [ 8421.702501]  ? rcu_is_watching+0x11/0xb0 
> [ 8421.706424]  ? lock_release+0x258/0x300 
> [ 8421.710266]  ? __fget_files+0x1d0/0x3f0 
> [ 8421.714105]  ? security_file_ioctl+0x50/0x90 
> [ 8421.718377]  __x64_sys_ioctl+0x12b/0x1a0 
> [ 8421.722302]  do_syscall_64+0x5c/0x90 
> [ 8421.725882]  ? trace_hardirqs_on_prepare+0x19/0x30 
> [ 8421.730675]  ? do_syscall_64+0x69/0x90 
> [ 8421.734427]  ? trace_irq_enable.constprop.0+0x13d/0x180 
> [ 8421.739652]  ? trace_hardirqs_on_prepare+0x19/0x30 
> [ 8421.744444]  ? do_syscall_64+0x69/0x90 
> [ 8421.748197]  ? do_syscall_64+0x69/0x90 
> [ 8421.751949]  entry_SYSCALL_64_after_hwframe+0x72/0xdc 
> [ 8421.757002] RIP: 0033:0x7f5b20e3ec6b 
> [ 8421.760582] Code: 73 01 c3 48 8b 0d b5 b1 1b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 85 b1 1b 00 f7 d8 64 89 01 48 
> [ 8421.779326] RSP: 002b:00007ffca12282d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010 
> [ 8421.786892] RAX: ffffffffffffffda RBX: 0000000000001dd8 RCX: 00007f5b20e3ec6b 
> [ 8421.794025] RDX: 00007ffca12282f0 RSI: ffffffffc0205865 RDI: 0000000000000004 
> [ 8421.801156] RBP: 0000000001186400 R08: 0000000000000002 R09: 0000000000000000 
> [ 8421.805134] XFS (pmem1): User initiated shutdown received. 
> [ 8421.808290] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000002fc 
> [ 8421.808292] R13: 00000000000004fe R14: 0000000000000004 R15: 00007f5b210326c0 
> [ 8421.808299]  </TASK> 
> [ 8421.808300] Modules linked in: ext4 
> [ 8421.813804] XFS (pmem1): Log I/O Error (0x6) detected at xfs_fs_goingdown+0xe1/0x180 [xfs] (fs/xfs/xfs_fsops.c:486).  Shutting down filesystem. 
> [ 8421.820916]  mbcache jbd2 loop rfkill sunrpc intel_rapl_msr intel_rapl_common amd64_edac edac_mce_amd 
> [ 8421.828065] XFS (pmem1): Please unmount the filesystem and rectify the problem(s) 
> [ 8421.830251]  kvm_amd mlx5_ib ipmi_ssif kvm mgag200 dell_smbios i2c_algo_bit drm_shmem_helper dcdbas ib_uverbs drm_kms_helper irqbypass nd_pmem wmi_bmof dax_pmem dell_wmi_descriptor pcspkr rapl syscopyarea sysfillrect sysimgblt ib_core acpi_ipmi ptdma k10temp i2c_piix4 ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter drm fuse xfs libcrc32c sd_mod t10_pi sg mlx5_core ahci crct10dif_pclmul libahci mlxfw crc32_pclmul crc32c_intel tls libata ghash_clmulni_intel tg3 psample ccp megaraid_sas pci_hyperv_intf sp5100_tco wmi dm_mirror dm_region_hash dm_log dm_mod [last unloaded: scsi_debug] 
> [ 8421.915124] CR2: 0000000000000008 
> [ 8421.918441] ---[ end trace 0000000000000000 ]--- 
> [ 8421.923060] RIP: 0010:qlist_free_all+0xd3/0x1a0 
> [ 8421.927593] Code: 03 05 d9 71 ad 02 48 8b 48 08 48 89 c2 f6 c1 01 0f 85 ba 00 00 00 0f 1f 44 00 00 48 8b 02 f6 c4 02 b8 00 00 00 00 48 0f 44 d0 <4c> 8b 72 08 e9 50 ff ff ff 49 83 7e 48 00 0f 85 68 ff ff ff 41 f7 
> [ 8421.946339] RSP: 0018:ffffc9000a867438 EFLAGS: 00010246 
> [ 8421.951565] RAX: 0000000000000000 RBX: ffff888b117c0800 RCX: ffffea002c45f008 
> [ 8421.958695] RDX: 0000000000000000 RSI: ffffea00223c6400 RDI: 0000000040000000 
> [ 8421.965829] RBP: 0000000000000000 R08: ffff888b117c0800 R09: 0000000000200012 
> [ 8421.972962] R10: ffffea00223c6400 R11: 0000000000000000 R12: dffffc0000000000 
> [ 8421.980093] R13: ffffc9000a867478 R14: 0000000000000000 R15: ffff88888f194c00 
> [ 8421.987227] FS:  00007f5b21032740(0000) GS:ffff88902de00000(0000) knlGS:0000000000000000 
> [ 8421.995312] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
> [ 8422.001057] CR2: 0000000000000008 CR3: 00000007f8c72000 CR4: 0000000000350ee0 
> [ 8422.008192] note: fsstress[1340923] exited with irqs disabled 
> ...
> ...
> 
> > 
> > diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> > index b2715988791e..fe38eb0cbc82 100644
> > --- a/io_uring/io-wq.c
> > +++ b/io_uring/io-wq.c
> > @@ -221,9 +221,6 @@ static void io_worker_exit(struct io_worker *worker)
> >  	raw_spin_unlock(&wq->lock);
> >  	io_wq_dec_running(worker);
> >  	worker->flags = 0;
> > -	preempt_disable();
> > -	current->flags &= ~PF_IO_WORKER;
> > -	preempt_enable();
> >  
> >  	kfree_rcu(worker, rcu);
> >  	io_worker_ref_put(wq);
> > 
> > -- 
> > Jens Axboe
> > 

