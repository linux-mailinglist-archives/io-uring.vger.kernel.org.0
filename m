Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B919706B0F
	for <lists+io-uring@lfdr.de>; Wed, 17 May 2023 16:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjEQO14 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 10:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjEQO1z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 10:27:55 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156B176A9;
        Wed, 17 May 2023 07:27:54 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-965ddb2093bso127748266b.2;
        Wed, 17 May 2023 07:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684333672; x=1686925672;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rN+Cdxh6bJMHZ3jVV+gRbD4cc8AdLQRaRy43VoXFPgY=;
        b=GK/vTZFZrVXCsVbfVJieWLoH+vYxx1d0FLd12lg5wXTAGzxDqccz1SAz2+WbXHH0Gt
         AE/pGUQowxD9Pii/WRS0PNmseW2fhwr9DUMMJ7FGK+JKI4QIdm/+kdQiquRsGmWCsv2P
         Wzzrjgcw10041wQV5vMk2tgJzl770sj9Cw7akm28yQ2M8i3jdoXM4bHEwClTCZ9pf4xd
         Pbu7fZjgWq7DsZ9xbsIuqryVXbe0CURRFAN+nCQlI6BzVg4/iIDfh6qCRvmmyNB8D4tl
         lQOLlRUpne/JO4zYQvUlLbkuz13yQNGyiwZn6SlC1qkMRogLl3+2UPKxE+nK0cdDej09
         DxgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684333672; x=1686925672;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rN+Cdxh6bJMHZ3jVV+gRbD4cc8AdLQRaRy43VoXFPgY=;
        b=i6uNhSP1LDuogx3ZlAttyBFeJ14PNt5k42wV7IoJ6oU6him7eXYhCSvc6uTefoxWIU
         3IA0dLayKk0xx/gP+3/PzY6dewNLtO1zNESXLhO1/4vAmQFQehEapXfqyheVqQtBqwgS
         XcoMlC1e4uQvmiFEYvr1+ZG9ZQ/uNRZgpp621wTN0YQaE6rKXFgeI0uRDjIikPP9bpdt
         9OkUoRCL9mDe7qGqa4LYYhxFUO47CHCBDwS0URcqmhWIq4KOu1XsYF/7Jre5ktNi0Qk+
         /pNuNVxNkGIxvSjL7SfAv7rWioFXefqDBfmNeLv77CvgnFgot0Vq2kb9X7wzKRG4cDFx
         budA==
X-Gm-Message-State: AC+VfDyBnDCJG3BdXI+P2PXu9iEurG7EhAMjntaoSVSuztp0GVdkMW8X
        MXKJhhtjDslBqegQ22Yc5Ck=
X-Google-Smtp-Source: ACHHUZ7dhMAF8XkR2u2ayjygbCYCANZS+VTeA+yC2BUDEvaL8z6TanmI3GsASEE7RZHntBGigPkFBw==
X-Received: by 2002:a17:906:9749:b0:96f:1b96:6147 with SMTP id o9-20020a170906974900b0096f1b966147mr367462ejy.55.1684333672252;
        Wed, 17 May 2023 07:27:52 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:46a1])
        by smtp.gmail.com with ESMTPSA id z25-20020a17090674d900b0096ac3e01a35sm7054726ejl.130.2023.05.17.07.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 07:27:51 -0700 (PDT)
Message-ID: <bedf7aff-2914-350a-43e3-04bb86bf9d5a@gmail.com>
Date:   Wed, 17 May 2023 15:23:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [Bug report] kernel panic: System is deadlocked on memory
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     yang lan <lanyang0908@gmail.com>, axboe@kernel.dk,
        sashal@kernel.org, dylany@fb.com, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <CAAehj2kcgtRta0ou6KQiyz33O4hf+_7jgndzV_neyQRj5BjSJQ@mail.gmail.com>
 <e3d7d8cf-5fc1-b956-fc48-0351f1ecfc08@gmail.com>
 <2023051714-chain-constrain-4ce4@gregkh>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2023051714-chain-constrain-4ce4@gregkh>
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

On 5/17/23 15:05, Greg KH wrote:
> On Wed, May 17, 2023 at 02:00:53PM +0100, Pavel Begunkov wrote:
>> On 5/17/23 13:02, yang lan wrote:
>>> Hi,
>>>
>>> We use our modified Syzkaller to fuzz the Linux kernel and found the
>>> following issue:
>>>
>>> Head Commit: f1b32fda06d2cfb8eea9680b0ba7a8b0d5b81eeb
>>> Git Tree: stable
>>>
>>> Console output: https://pastebin.com/raw/Ssz6eVA6
>>> Kernel config: https://pastebin.com/raw/BiggLxRg
>>> C reproducer: https://pastebin.com/raw/tM1iyfjr
>>> Syz reproducer: https://pastebin.com/raw/CEF1R2jg
>>>
>>> root@syzkaller:~# uname -a
>>> Linux syzkaller 5.10.179 #5 SMP PREEMPT Mon May 1 23:59:32 CST 2023
>>> x86_64 GNU/Linux
>>> root@syzkaller:~# gcc poc_io_uring_enter.c -o poc_io_uring_enter
>>> root@syzkaller:~# ./poc_io_uring_enter
>>> ...
>>> [  244.945440][ T3106]
>>> oom-kill:constraint=CONSTRAINT_NONE,nodemask=(null),cpuset=/,mems_allowed=0-1,global_oom,task_memcg=/,task=dhclient,pid=4526,uid=0
>>> [  244.946537][ T3106] Out of memory: Killed process 4526 (dhclient)
>>> total-vm:20464kB, anon-rss:1112kB, file-rss:0kB, shmem-rss:0kB, UID:0
>>> pgtables:76kB oom_score_adj:0
>>> [  244.953740][ T9068] syz-executor.0 invoked oom-killer:
>>> gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=1000
>>> [  244.954411][ T9068] CPU: 0 PID: 9068 Comm: syz-executor.0 Not
>>> tainted 5.10.179 #5
>>> [  244.954903][ T9068] Hardware name: QEMU Standard PC (i440FX + PIIX,
>>> 1996), BIOS 1.12.0-1 04/01/2014
>>> [  244.955515][ T9068] Call Trace:
>>> [  244.955738][ T9068]  dump_stack+0x106/0x162
>>> [  244.956026][ T9068]  dump_header+0x117/0x6f8
>>> [  244.956315][ T9068]  ? ___ratelimit+0x1fc/0x430
>>> [  244.956621][ T9068]  oom_kill_process.cold.34+0x10/0x15
>>> [  244.956970][ T9068]  out_of_memory+0x122c/0x1540
>>> [  244.957283][ T9068]  ? oom_killer_disable+0x270/0x270
>>> [  244.957627][ T9068]  ? mutex_trylock+0x249/0x2c0
>>> [  244.957937][ T9068]  ? __alloc_pages_slowpath.constprop.104+0x9fa/0x2250
>>> [  244.958378][ T9068]  __alloc_pages_slowpath.constprop.104+0x1bec/0x2250
>>> [  244.958818][ T9068]  ? warn_alloc+0x130/0x130
>>> [  244.959117][ T9068]  ? find_held_lock+0x33/0x1c0
>>> [  244.959429][ T9068]  ? __alloc_pages_nodemask+0x3e8/0x6c0
>>> [  244.959789][ T9068]  ? lock_downgrade+0x6a0/0x6a0
>>> [  244.960104][ T9068]  ? lock_release+0x660/0x660
>>> [  244.960412][ T9068]  __alloc_pages_nodemask+0x5dd/0x6c0
>>> [  244.960762][ T9068]  ? __alloc_pages_slowpath.constprop.104+0x2250/0x2250
>>> [  244.961210][ T9068]  ? mark_held_locks+0xb0/0x110
>>> [  244.961531][ T9068]  alloc_pages_current+0x100/0x200
>>> [  244.961864][ T9068]  allocate_slab+0x302/0x490
>>> [  244.962166][ T9068]  ___slab_alloc+0x4eb/0x820
>>> [  244.962472][ T9068]  ? io_issue_sqe+0xf26/0x5d50
>>> [  244.962782][ T9068]  ? __slab_alloc.isra.78+0x64/0xa0
>>> [  244.963118][ T9068]  ? io_issue_sqe+0xf26/0x5d50
>>> [  244.963427][ T9068]  ? __slab_alloc.isra.78+0x8b/0xa0
>>> [  244.963762][ T9068]  __slab_alloc.isra.78+0x8b/0xa0
>>> [  244.964106][ T9068]  ? should_failslab+0x5/0x10
>>> [  244.964419][ T9068]  ? io_issue_sqe+0xf26/0x5d50
>>> [  244.964727][ T9068]  kmem_cache_alloc_trace+0x22a/0x270
>>> [  244.965077][ T9068]  io_issue_sqe+0xf26/0x5d50
>>> [  244.965379][ T9068]  ? io_write+0xf50/0xf50
>>> [  244.965662][ T9068]  ? io_submit_flush_completions+0x6a1/0x930
>>> [  244.966051][ T9068]  ? io_req_free_batch+0x710/0x710
>>> [  244.966380][ T9068]  ? allocate_slab+0x38c/0x490
>>> [  244.966690][ T9068]  __io_queue_sqe.part.124+0xb1/0xb00
>>> [  244.967036][ T9068]  ? kasan_unpoison_shadow+0x30/0x40
>>> [  244.967378][ T9068]  ? __kasan_kmalloc.constprop.10+0xc1/0xd0
>>> [  244.967760][ T9068]  ? io_issue_sqe+0x5d50/0x5d50
>>> [  244.968075][ T9068]  ? kmem_cache_alloc_bulk+0xe1/0x250
>>> [  244.968420][ T9068]  ? io_submit_sqes+0x1c47/0x7b00
>>> [  244.968744][ T9068]  io_submit_sqes+0x1c47/0x7b00
>>> [  244.969080][ T9068]  ? __x64_sys_io_uring_enter+0xcdd/0x11a0
>>> [  244.969456][ T9068]  __x64_sys_io_uring_enter+0xcdd/0x11a0
>>> [  244.969821][ T9068]  ? __io_uring_cancel+0x20/0x20
>>> [  244.970144][ T9068]  ? get_vtime_delta+0x23d/0x360
>>> [  244.970467][ T9068]  ? syscall_enter_from_user_mode+0x26/0x70
>>> [  244.970849][ T9068]  do_syscall_64+0x2d/0x70
>>> [  244.971136][ T9068]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
>>> [  244.971514][ T9068] RIP: 0033:0x46a8c9
>>> [  244.971771][ T9068] Code: Unable to access opcode bytes at RIP 0x46a89f.
>>> [  244.972208][ T9068] RSP: 002b:00007f4d887e0c38 EFLAGS: 00000246
>>> ORIG_RAX: 00000000000001aa
>>> [  244.972747][ T9068] RAX: ffffffffffffffda RBX: 000000000057bf80
>>> RCX: 000000000046a8c9
>>> [  244.973253][ T9068] RDX: 0000000000000000 RSI: 00000000000051cd
>>> RDI: 0000000000000003
>>> [  244.973792][ T9068] RBP: 00000000004c9f3b R08: 0000000000000000
>>> R09: 0000000000000000
>>> [  244.974299][ T9068] R10: 0000000000000000 R11: 0000000000000246
>>> R12: 000000000057bf80
>>> [  244.974802][ T9068] R13: 00007ffd88d30d4f R14: 000000000057bf80
>>> R15: 00007ffd88d30f00
>>> [  244.980610][ T9068] Mem-Info:
>>> [  244.980840][ T9068] active_anon:166 inactive_anon:8300 isolated_anon:0
>>> [  244.980840][ T9068]  active_file:2 inactive_file:3 isolated_file:0
>>> [  244.980840][ T9068]  unevictable:0 dirty:0 writeback:0
>>> [  244.980840][ T9068]  slab_reclaimable:12481 slab_unreclaimable:279862
>>> [  244.980840][ T9068]  mapped:52225 shmem:6769 pagetables:446 bounce:0
>>> [  244.980840][ T9068]  free:9671 free_pcp:453 free_cma:0
>>> ...
>>> [  245.694692][ T2959] Kernel Offset: disabled
>>> [  245.695139][ T2959] Rebooting in 86400 seconds..
>>>
>>> Please let me know if I can provide any more information, and I hope I
>>> didn't mess up this bug report.
>>
>> I think we should backport the commit below. It'll somewhat
>> degrade perf but we probably don't care that much about 5.10.
>>
>>
>>
>> commit 91f245d5d5de0802428a478802ec051f7de2f5d6
>> Author: Jens Axboe <axboe@kernel.dk>
>> Date:   Tue Feb 9 13:48:50 2021 -0700
>>
>>      io_uring: enable kmemcg account for io_uring requests
>>      This puts io_uring under the memory cgroups accounting and limits for
>>      requests.
>>      Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
> 
> this is already in the 5.10.y tree, so I don't think it will help much :(

Oops, my stable tree was heavily outdated.

Then it should be triggerable for 6.4. We should tell slab to fail
instead of oom'ing, sth like __GFP_NORETRY or __GFP_RETRY_MAYFAIL.

  * %__GFP_NORETRY: The VM implementation will try only very lightweight
  * memory direct reclaim to get some memory under memory pressure (thus
  * it can sleep). It will avoid disruptive actions like OOM killer...
  
-- 
Pavel Begunkov
