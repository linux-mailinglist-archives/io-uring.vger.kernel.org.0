Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04737D14D6
	for <lists+io-uring@lfdr.de>; Fri, 20 Oct 2023 19:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjJTR0a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Oct 2023 13:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjJTR03 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Oct 2023 13:26:29 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C845BA3
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 10:26:26 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id e9e14a558f8ab-351610727adso1469955ab.0
        for <io-uring@vger.kernel.org>; Fri, 20 Oct 2023 10:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1697822786; x=1698427586; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tSba/+24YivrTjyw+V6XfhfLknwx8EZTO8XM9IU/678=;
        b=jTcMyxL2TuvKHE1/DcbDy7AYjqiG9ElrqO8pbVOA/O2hhnauq3XiiqJwsEETKESy9Y
         HWckkf5QmqVTsF7w2b2m1aSohOuhLnGbFc0Q7STQa4UZ0VCl04641+Aas2z4dTdJ2xZL
         plVNgtUYCJH51HuqFBnL970lc+8+s3quNNPSPbmrZgb4eh9q66HGcoUsPdZr3kJlmu88
         JEsopls2Qltv6ddBCWH30pWkJXRqoLMzN/GcQma8yxC4OR4GUYSnNC5zUzHlJsBbtJo6
         rkk78peOvrApB87MjYEFZF7npaBoyM09W4+fsJj84PxFpIJlNb8vv2QI+e2Oi/PZtpVn
         AwYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697822786; x=1698427586;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tSba/+24YivrTjyw+V6XfhfLknwx8EZTO8XM9IU/678=;
        b=TPLV8jwyyPZY29rcQxdbc0DHrSPeyuoXvsYu4UBsN7dUXeHIkTs84c/dGq7FfBczK6
         41tAzwNaRUxZk8GXT+rivmvhd87J6XrktnHemK5KJlJAGDFTFjP/jfCmGuG6gn5a/sFZ
         Szk72dRoyvdEZ918C45yjedSKPvFZ7QfPkkeBNYCxCUxBJSgY5SSHA8080UJ9dHDc9e8
         piCNwVxqINwgPVVuTHAYJtssmFoAJkUbRZiup9FSFBtuOqj/050EzLbJxiSrFmq5tzKk
         DRwa+rqKyn3fxVOig4NLd1+BoGMxI+rmUKbKOUpn4pr+K6W3rRc9LvrHN36ikI5B3O+a
         gWCA==
X-Gm-Message-State: AOJu0Yxr4ayOqj6LedK2sBhpvZ0pGdC+Vg2wefu1yexqhfx5t4n9DN9i
        dLu4313TkZpoDxfZ92o6leyUJA==
X-Google-Smtp-Source: AGHT+IGvgETLhqyeR13uGf1rGF8pO6xwcaXhFASwRuhYSmmmh7UCiCsST+j45XOk+BwNV0v7qItAGA==
X-Received: by 2002:a05:6602:120b:b0:79a:c487:2711 with SMTP id y11-20020a056602120b00b0079ac4872711mr2933929iot.0.1697822786055;
        Fri, 20 Oct 2023 10:26:26 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k21-20020a023355000000b0045a925e4e0csm670634jak.28.2023.10.20.10.26.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Oct 2023 10:26:25 -0700 (PDT)
Message-ID: <dc26efcb-753b-4c5d-9892-8a66e499a6d8@kernel.dk>
Date:   Fri, 20 Oct 2023 11:26:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: bcachefs KASAN SLAB out of bounds
Content-Language: en-US
To:     Kent Overstreet <kent.overstreet@linux.dev>,
        Daniel J Blueman <daniel@quora.org>
Cc:     linux-bcachefs@vger.kernel.org, io-uring@vger.kernel.org
References: <CAMVG2sss9S45sCRnV+0nQ2jcd+XTMqYXNZ0FObodhD9kFUhwyg@mail.gmail.com>
 <20231020172352.vh4y7fvmllod2j4n@moria.home.lan>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231020172352.vh4y7fvmllod2j4n@moria.home.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/20/23 11:23 AM, Kent Overstreet wrote:
> On Fri, Oct 20, 2023 at 05:03:45PM +0800, Daniel J Blueman wrote:
>> Hi Kent et al,
>>
>> Booting bcachefs/master (SHA a180af9d) with a stock Ubuntu 23.04
>> config plus CONFIG_KASAN=CONFIG_KASAN_VMALLOC=y, I have identified a
>> minimal and consistent reproducer [1] triggering a KASAN report after
>> ~90s of the fio workload [2].
>>
>> The report shows a SLAB out of bounds access in connection from IO
>> uring submission queue entries [3].
>>
>> I confirmed the report isn't emitted when using ext4 in place of
>> bcachefs; let me know if you'd like further testing on it.
>>
>> Thanks,
>>   Daniel
>>
>> -- [1]
>>
>> modprobe brd rd_nr=1 rd_size=1048576
>> bcachefs format /dev/ram0
>> mount -t bcachefs /dev/ram0 /mnt
>> fio workload.fio
>>
>> -- [2] workload.fio
>>
>> [global]
>> group_reporting
>> ioengine=io_uring
>> directory=/mnt
>> size=16m
>> time_based
>> runtime=48h
>> iodepth=256
>> verify_async=8
>> bs=4k-64k
>> norandommap
>> random_distribution=zipf:0.5
>> ioengine=io_uring
>> numjobs=16
>> rw=randrw
>>
>> [job1]
>> direct=1
>>
>> [job2]
>> direct=0
>>
>> -- [3]
>>
>> BUG: KASAN: slab-out-of-bounds in io_req_local_work_add+0xf0/0x2a0
>> Read of size 4 at addr ffff888138305218 by task iou-wrk-2702/3275
>>
>> CPU: 38 PID: 3275 Comm: iou-wrk-2702 Not tainted 6.5.0+ #1
>> Hardware name: Supermicro AS -3014TS-i/H12SSL-i, BIOS 2.5 09/08/2022
>> Call Trace:
>>  <TASK>
>>  dump_stack_lvl+0x48/0x70
>>  print_report+0xd2/0x660
>>  ? __virt_addr_valid+0x103/0x180
>>  ? srso_alias_return_thunk+0x5/0x7f
>>  ? kasan_complete_mode_report_info+0x40/0x230
>>  ? io_req_local_work_add+0xf0/0x2a0
>>  kasan_report+0xd0/0x120
>>  ? io_req_local_work_add+0xf0/0x2a0
>>  __asan_load4+0x8e/0xd0
>>  io_req_local_work_add+0xf0/0x2a0
>>  ? __pfx_io_req_local_work_add+0x10/0x10
>>  io_req_complete_post+0x88/0x120
>>  io_issue_sqe+0x363/0x6b0
>>  io_wq_submit_work+0x10c/0x4d0
>>  io_worker_handle_work+0x494/0xa60
>>  io_wq_worker+0x3d5/0x660
>>  ? __pfx_io_wq_worker+0x10/0x10
>>  ? srso_alias_return_thunk+0x5/0x7f
>>  ? __kasan_check_write+0x14/0x30
>>  ? srso_alias_return_thunk+0x5/0x7f
>>  ? _raw_spin_lock_irq+0x8b/0x100
>>  ? __pfx__raw_spin_lock_irq+0x10/0x10
>>  ? srso_alias_return_thunk+0x5/0x7f
>>  ? __kasan_check_write+0x14/0x30
>>  ? srso_alias_return_thunk+0x5/0x7f
>>  ? srso_alias_return_thunk+0x5/0x7f
>>  ? calculate_sigpending+0x5a/0x70
>>  ? __pfx_io_wq_worker+0x10/0x10
>>  ret_from_fork+0x47/0x80
>>  ? __pfx_io_wq_worker+0x10/0x10
>>  ret_from_fork_asm+0x1b/0x30
>> RIP: 0033:0x0
>> Code: Unable to access opcode bytes at 0xffffffffffffffd6.
>> RSP: 002b:0000000000000000 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
>> RAX: 0000000000000000 RBX: 00007f752ea36718 RCX: 000055792b721268
>> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000006
>> RBP: 00007f752ea36718 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000001
>> R13: 000055792d883950 R14: 00000000000532ed R15: 000055792d915740
>>  </TASK>
>>
>> Allocated by task 2702:
>>  kasan_save_stack+0x38/0x70
>>  kasan_set_track+0x25/0x40
>>  kasan_save_alloc_info+0x1e/0x40
>>  __kasan_slab_alloc+0x9d/0xa0
>>  slab_post_alloc_hook+0x5f/0xe0
>>  kmem_cache_alloc_bulk+0x264/0x3e0
>>  __io_alloc_req_refill+0x1d8/0x370
>>  io_submit_sqes+0x549/0xb80
>>  __do_sys_io_uring_enter+0x968/0x1330
>>  __x64_sys_io_uring_enter+0x7f/0xa0
>>  do_syscall_64+0x5b/0x90
>>  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
>>
>> The buggy address belongs to the object at ffff888138305180
>> which belongs to the cache io_kiocb of size 224
>> The buggy address is located 152 bytes inside of        allocated
>> 224-byte region [ffff888138305180, ffff888138305260)
>>
>> The buggy address belongs to the physical page:
>> page:00000000f168c2d3 refcount:1 mapcount:0 mapping:0000000000000000
>> index:0xffff8881383048c0 pfn:0x138304
>> head:00000000f168c2d3 order:2 entire_mapcount:0 nr_pages_mapped:0 pincount:0
>> memcg:ffff8881cfb7e001
>> flags: 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
>> page_type: 0xffffffff()
>> raw: 0017ffffc0010200 ffff888126f670c0 dead000000000122 0000000000000000
>> raw: ffff8881383048c0 000000008033002b 00000001ffffffff ffff8881cfb7e001
>> page dumped because: kasan: bad access detected
>>
>> Memory state around the buggy address:
>>  ffff888138305100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>  ffff888138305180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>> ffff888138305200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>               ^
>>  ffff888138305280: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
>>  ffff888138305300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> -- 
>> Daniel J Blueman
> 
> Beats me, this looks like an io_uring bug.

I think this is it:

commit 569f5308e54352a12181cc0185f848024c5443e8
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Wed Aug 9 13:22:16 2023 +0100

    io_uring: fix false positive KASAN warnings

which got added post 6.5.

-- 
Jens Axboe


