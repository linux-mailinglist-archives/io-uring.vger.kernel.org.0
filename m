Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3117068DE
	for <lists+io-uring@lfdr.de>; Wed, 17 May 2023 15:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjEQNE4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 09:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbjEQNEy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 09:04:54 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0169B1BC;
        Wed, 17 May 2023 06:04:53 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-965a68abfd4so127750666b.2;
        Wed, 17 May 2023 06:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684328691; x=1686920691;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c0yWtxFQUJzMXI5XdbEs6LdWyut+GGZnas0Iog3EnAo=;
        b=Dv/1FYcobSCSk3SuUbCkkgrzAPqCZUw/g/sQJQDqz7D2hQdI8MjTR73lw3/piKh7Pf
         MhbyX3UeeRDkads7ew42MA4doB9MpRzTOCdCdvSMVJpv+AYi2ZFte7l8S8uQ/x7DeZRi
         A0mfR3LHaNAizlCxuD3b3dVuMjtzI2B1FN/kAWH3Lla9e/PsA5LRcAHv3QUlYVBJiBxP
         ykwbdDOekVe5KXsgbVBZzU+MJqMBCsw6W14mEoX7xfvGd7Une6qORJQ+0nufDEBYF/Ux
         Jo3HOgSVvpSJYtCEWmDXx/rcYTZBeb9PU4DFjAsatfVEu9VR0lLqEgyKmAQHb9y+sppc
         ftGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684328691; x=1686920691;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c0yWtxFQUJzMXI5XdbEs6LdWyut+GGZnas0Iog3EnAo=;
        b=Kf92ZXvg1vJbOSXI7Ej9F0pb+xa6H0yOgZhgWYAjKjgTiq8C/FQNJwFR2k05Df5BHv
         eODzEeJMMg5loy9u+cYuDhI3fNjn8iGPtQdwo370t8uD80SqDE4T3/7hQkySPDZ8XoH1
         1t0GJMajUOYLAdVhnJccTbqbfXcA5J4j6/lR+lp+8h5d+JkdCD/4EkrGwos48RZwpFoL
         umBGaNUaQ1PIUTB85fqFqEaOLGBnz5f5VZ/zC547tsp/Pe5TKsaHuLozIyesF+ZnEMLS
         rOKOgA4M8+H/Xf/zDm/ark79gDOWC5L3OWt4nVJ0ro+XhYYAtNHTF+8S/p0aQOS0OdMd
         Nopg==
X-Gm-Message-State: AC+VfDyAJe5uxzALKWjOzH1Jvd4fHdR1h+UhVN7tci+2csYuKmhi31IN
        AZhz8HoIA9f2C8FJTW5DAew=
X-Google-Smtp-Source: ACHHUZ6r230LevdboIzeROoNFXpUT3VaQT1gfiIXgMbTwO1kx94G1lJT/qPt36FEzehppKTP81ilaA==
X-Received: by 2002:a17:906:974e:b0:96a:4c61:3c87 with SMTP id o14-20020a170906974e00b0096a4c613c87mr21862047ejy.71.1684328690931;
        Wed, 17 May 2023 06:04:50 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:46a1])
        by smtp.gmail.com with ESMTPSA id z13-20020a17090674cd00b0096ae152115bsm6375181ejl.175.2023.05.17.06.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 06:04:50 -0700 (PDT)
Message-ID: <e3d7d8cf-5fc1-b956-fc48-0351f1ecfc08@gmail.com>
Date:   Wed, 17 May 2023 14:00:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [Bug report] kernel panic: System is deadlocked on memory
Content-Language: en-US
To:     yang lan <lanyang0908@gmail.com>, axboe@kernel.dk,
        gregkh@linuxfoundation.org, sashal@kernel.org, dylany@fb.com,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <CAAehj2kcgtRta0ou6KQiyz33O4hf+_7jgndzV_neyQRj5BjSJQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAAehj2kcgtRta0ou6KQiyz33O4hf+_7jgndzV_neyQRj5BjSJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/23 13:02, yang lan wrote:
> Hi,
> 
> We use our modified Syzkaller to fuzz the Linux kernel and found the
> following issue:
> 
> Head Commit: f1b32fda06d2cfb8eea9680b0ba7a8b0d5b81eeb
> Git Tree: stable
> 
> Console output: https://pastebin.com/raw/Ssz6eVA6
> Kernel config: https://pastebin.com/raw/BiggLxRg
> C reproducer: https://pastebin.com/raw/tM1iyfjr
> Syz reproducer: https://pastebin.com/raw/CEF1R2jg
> 
> root@syzkaller:~# uname -a
> Linux syzkaller 5.10.179 #5 SMP PREEMPT Mon May 1 23:59:32 CST 2023
> x86_64 GNU/Linux
> root@syzkaller:~# gcc poc_io_uring_enter.c -o poc_io_uring_enter
> root@syzkaller:~# ./poc_io_uring_enter
> ...
> [  244.945440][ T3106]
> oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0-1,global_oom,task_memcg=/,task=dhclient,pid=4526,uid=0
> [  244.946537][ T3106] Out of memory: Killed process 4526 (dhclient)
> total-vm:20464kB, anon-rss:1112kB, file-rss:0kB, shmem-rss:0kB, UID:0
> pgtables:76kB oom_score_adj:0
> [  244.953740][ T9068] syz-executor.0 invoked oom-killer:
> gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=1000
> [  244.954411][ T9068] CPU: 0 PID: 9068 Comm: syz-executor.0 Not
> tainted 5.10.179 #5
> [  244.954903][ T9068] Hardware name: QEMU Standard PC (i440FX + PIIX,
> 1996), BIOS 1.12.0-1 04/01/2014
> [  244.955515][ T9068] Call Trace:
> [  244.955738][ T9068]  dump_stack+0x106/0x162
> [  244.956026][ T9068]  dump_header+0x117/0x6f8
> [  244.956315][ T9068]  ? ___ratelimit+0x1fc/0x430
> [  244.956621][ T9068]  oom_kill_process.cold.34+0x10/0x15
> [  244.956970][ T9068]  out_of_memory+0x122c/0x1540
> [  244.957283][ T9068]  ? oom_killer_disable+0x270/0x270
> [  244.957627][ T9068]  ? mutex_trylock+0x249/0x2c0
> [  244.957937][ T9068]  ? __alloc_pages_slowpath.constprop.104+0x9fa/0x2250
> [  244.958378][ T9068]  __alloc_pages_slowpath.constprop.104+0x1bec/0x2250
> [  244.958818][ T9068]  ? warn_alloc+0x130/0x130
> [  244.959117][ T9068]  ? find_held_lock+0x33/0x1c0
> [  244.959429][ T9068]  ? __alloc_pages_nodemask+0x3e8/0x6c0
> [  244.959789][ T9068]  ? lock_downgrade+0x6a0/0x6a0
> [  244.960104][ T9068]  ? lock_release+0x660/0x660
> [  244.960412][ T9068]  __alloc_pages_nodemask+0x5dd/0x6c0
> [  244.960762][ T9068]  ? __alloc_pages_slowpath.constprop.104+0x2250/0x2250
> [  244.961210][ T9068]  ? mark_held_locks+0xb0/0x110
> [  244.961531][ T9068]  alloc_pages_current+0x100/0x200
> [  244.961864][ T9068]  allocate_slab+0x302/0x490
> [  244.962166][ T9068]  ___slab_alloc+0x4eb/0x820
> [  244.962472][ T9068]  ? io_issue_sqe+0xf26/0x5d50
> [  244.962782][ T9068]  ? __slab_alloc.isra.78+0x64/0xa0
> [  244.963118][ T9068]  ? io_issue_sqe+0xf26/0x5d50
> [  244.963427][ T9068]  ? __slab_alloc.isra.78+0x8b/0xa0
> [  244.963762][ T9068]  __slab_alloc.isra.78+0x8b/0xa0
> [  244.964106][ T9068]  ? should_failslab+0x5/0x10
> [  244.964419][ T9068]  ? io_issue_sqe+0xf26/0x5d50
> [  244.964727][ T9068]  kmem_cache_alloc_trace+0x22a/0x270
> [  244.965077][ T9068]  io_issue_sqe+0xf26/0x5d50
> [  244.965379][ T9068]  ? io_write+0xf50/0xf50
> [  244.965662][ T9068]  ? io_submit_flush_completions+0x6a1/0x930
> [  244.966051][ T9068]  ? io_req_free_batch+0x710/0x710
> [  244.966380][ T9068]  ? allocate_slab+0x38c/0x490
> [  244.966690][ T9068]  __io_queue_sqe.part.124+0xb1/0xb00
> [  244.967036][ T9068]  ? kasan_unpoison_shadow+0x30/0x40
> [  244.967378][ T9068]  ? __kasan_kmalloc.constprop.10+0xc1/0xd0
> [  244.967760][ T9068]  ? io_issue_sqe+0x5d50/0x5d50
> [  244.968075][ T9068]  ? kmem_cache_alloc_bulk+0xe1/0x250
> [  244.968420][ T9068]  ? io_submit_sqes+0x1c47/0x7b00
> [  244.968744][ T9068]  io_submit_sqes+0x1c47/0x7b00
> [  244.969080][ T9068]  ? __x64_sys_io_uring_enter+0xcdd/0x11a0
> [  244.969456][ T9068]  __x64_sys_io_uring_enter+0xcdd/0x11a0
> [  244.969821][ T9068]  ? __io_uring_cancel+0x20/0x20
> [  244.970144][ T9068]  ? get_vtime_delta+0x23d/0x360
> [  244.970467][ T9068]  ? syscall_enter_from_user_mode+0x26/0x70
> [  244.970849][ T9068]  do_syscall_64+0x2d/0x70
> [  244.971136][ T9068]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
> [  244.971514][ T9068] RIP: 0033:0x46a8c9
> [  244.971771][ T9068] Code: Unable to access opcode bytes at RIP 0x46a89f.
> [  244.972208][ T9068] RSP: 002b:00007f4d887e0c38 EFLAGS: 00000246
> ORIG_RAX: 00000000000001aa
> [  244.972747][ T9068] RAX: ffffffffffffffda RBX: 000000000057bf80
> RCX: 000000000046a8c9
> [  244.973253][ T9068] RDX: 0000000000000000 RSI: 00000000000051cd
> RDI: 0000000000000003
> [  244.973792][ T9068] RBP: 00000000004c9f3b R08: 0000000000000000
> R09: 0000000000000000
> [  244.974299][ T9068] R10: 0000000000000000 R11: 0000000000000246
> R12: 000000000057bf80
> [  244.974802][ T9068] R13: 00007ffd88d30d4f R14: 000000000057bf80
> R15: 00007ffd88d30f00
> [  244.980610][ T9068] Mem-Info:
> [  244.980840][ T9068] active_anon:166 inactive_anon:8300 isolated_anon:0
> [  244.980840][ T9068]  active_file:2 inactive_file:3 isolated_file:0
> [  244.980840][ T9068]  unevictable:0 dirty:0 writeback:0
> [  244.980840][ T9068]  slab_reclaimable:12481 slab_unreclaimable:279862
> [  244.980840][ T9068]  mapped:52225 shmem:6769 pagetables:446 bounce:0
> [  244.980840][ T9068]  free:9671 free_pcp:453 free_cma:0
> ...
> [  245.694692][ T2959] Kernel Offset: disabled
> [  245.695139][ T2959] Rebooting in 86400 seconds..
> 
> Please let me know if I can provide any more information, and I hope I
> didn't mess up this bug report.

I think we should backport the commit below. It'll somewhat
degrade perf but we probably don't care that much about 5.10.



commit 91f245d5d5de0802428a478802ec051f7de2f5d6
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Feb 9 13:48:50 2021 -0700

     io_uring: enable kmemcg account for io_uring requests
     
     This puts io_uring under the memory cgroups accounting and limits for
     requests.
     
     Signed-off-by: Jens Axboe <axboe@kernel.dk>



-- 
Pavel Begunkov
