Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A125B738621
	for <lists+io-uring@lfdr.de>; Wed, 21 Jun 2023 16:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbjFUOFE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Jun 2023 10:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbjFUOEe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Jun 2023 10:04:34 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A204F107
        for <io-uring@vger.kernel.org>; Wed, 21 Jun 2023 07:04:32 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-668842bc50dso657343b3a.1
        for <io-uring@vger.kernel.org>; Wed, 21 Jun 2023 07:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687356272; x=1689948272;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=It4/jWCGCWpVyhoys8hgpiNAqM0yj2xvFZeiNVDpslo=;
        b=hMy/Xo6m0HSm6r+trE3rwtSeaFqxYi3x8e7XKVd7WBW6aRFCbwoiVGDBMwp6eqlCe7
         Mb8I1CQfafBYlWCc056YOqYpaTU5CL1fkw+xdqPtfPzsMw3lwEtMvu50wS8Z3E5m6pA6
         n1XjYXfa5Pa5a02bk/cO9mGgUyxlMqh6d03DocGlv0mzeOZftBg7c2pUITE9NsfH4xnE
         CGA18vMBwHK0J+zGapXZ91vfyP8ECZZKvaG1cs8AJwDlY8BJPbZpSe+N5mGBMO0tZX7P
         eH4qV9ihaDPYTQkh+IEYcXFgE240wUgL4n/exkkD9UDQ9phif5hnEJxqXkHnCqHHWdyG
         RKUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687356272; x=1689948272;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=It4/jWCGCWpVyhoys8hgpiNAqM0yj2xvFZeiNVDpslo=;
        b=D5I5H6YTPNNY2tu3TqxlBr470qIgglltVzNS3boNg8qgvPoD43QPEH5kLaINhtSggF
         GpRYRvwIExgZp5llTqqdahwjx/MMrk+uKMbqls9LTCFYrJy1HhJlRWyP2xGZJqRjQx7D
         p1QWKwK94mGFRoGTgOIt0VTHeon3w8IJ11chHpICWAU/d178fkgRRSVhBBAuKtxCnrl8
         wQPpAPEctpg47bKOSUPCB2bWXR63ODpd1yXq2TG4GdQDnSNyJyUgJrGeO/opIZg1THAz
         geqmURFAA/O7Mv8E9HjXjAwu0vLn5mKs1O3Bf8BGG/I0tw0+0/3/v9to88lCONW7OrV2
         nGFg==
X-Gm-Message-State: AC+VfDzus5ApbU12aCMRYfSznL/5kSeXlNUwpI04ACkGUuiHuO+ey/3x
        C6/PEYOIzX677EGWmcFCsRxUhQ==
X-Google-Smtp-Source: ACHHUZ5wmJ4i+/hrUfF2WuXVsXt7WpEm5F4be3Kq8sx/coB6eGOYYgcnMNA9fuJXFWoxKZ1olVV0aQ==
X-Received: by 2002:a05:6a20:244c:b0:11b:3e33:d2f3 with SMTP id t12-20020a056a20244c00b0011b3e33d2f3mr18941039pzc.0.1687356272052;
        Wed, 21 Jun 2023 07:04:32 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h4-20020aa786c4000000b0065fd8075bb1sm3085800pfo.14.2023.06.21.07.04.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jun 2023 07:04:31 -0700 (PDT)
Message-ID: <e69ee589-aa93-8380-25de-83d173c90677@kernel.dk>
Date:   Wed, 21 Jun 2023 08:04:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [bug report] BUG: KASAN: out-of-bounds in
 io_req_local_work_add+0x3b1/0x4a0
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Guangwu Zhang <guazhang@redhat.com>, linux-block@vger.kernel.org,
        Ming Lei <ming.lei@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
        io-uring@vger.kernel.org
References: <CAGS2=YrvrD0hf7WGjQd4Me772=m9=E6J92aGtG0PAoF4yD6dTw@mail.gmail.com>
 <e92a19fa-74cc-2b9f-3173-6a04557a6534@kernel.dk>
In-Reply-To: <e92a19fa-74cc-2b9f-3173-6a04557a6534@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/21/23 7:40?AM, Jens Axboe wrote:
> On 6/21/23 1:38?AM, Guangwu Zhang wrote:
>> HI,
>> Found the io_req_local_work_add error when run  liburing testing.
>>
>> kernel repo :
>>     Merge branch 'for-6.5/block' into for-next
>>     * for-6.5/block:
>>       reiserfs: fix blkdev_put() warning from release_journal_dev()
>>
>> [ 1733.389012] BUG: KASAN: out-of-bounds in io_req_local_work_add+0x3b1/0x4a0
>> [ 1733.395900] Read of size 4 at addr ffff888133320458 by task
>> iou-wrk-97057/97138
>> [ 1733.403205]
>> [ 1733.404706] CPU: 4 PID: 97138 Comm: iou-wrk-97057 Kdump: loaded Not
>> tainted 6.4.0-rc3.kasan+ #1
>> [ 1733.413404] Hardware name: Dell Inc. PowerEdge R740/06WXJT, BIOS
>> 2.13.3 12/13/2021
>> [ 1733.420972] Call Trace:
>> [ 1733.423425]  <TASK>
>> [ 1733.425533]  dump_stack_lvl+0x33/0x50
>> [ 1733.429207]  print_address_description.constprop.0+0x2c/0x3e0
>> [ 1733.434959]  print_report+0xb5/0x270
>> [ 1733.438539]  ? kasan_addr_to_slab+0x9/0xa0
>> [ 1733.442639]  ? io_req_local_work_add+0x3b1/0x4a0
>> [ 1733.447258]  kasan_report+0xcf/0x100
>> [ 1733.450839]  ? io_req_local_work_add+0x3b1/0x4a0
>> [ 1733.455456]  io_req_local_work_add+0x3b1/0x4a0
>> [ 1733.459903]  ? __pfx_io_req_local_work_add+0x10/0x10
>> [ 1733.464871]  ? __schedule+0x616/0x1530
>> [ 1733.468622]  __io_req_task_work_add+0x1bc/0x270
>> [ 1733.473156]  io_issue_sqe+0x55a/0xe80
>> [ 1733.476831]  io_wq_submit_work+0x23e/0xa00
>> [ 1733.480930]  io_worker_handle_work+0x2f5/0xa80
>> [ 1733.485384]  io_wq_worker+0x6c5/0x9d0
>> [ 1733.489051]  ? __pfx_io_wq_worker+0x10/0x10
>> [ 1733.493246]  ? _raw_spin_lock_irq+0x82/0xe0
>> [ 1733.497430]  ? __pfx_io_wq_worker+0x10/0x10
>> [ 1733.501616]  ret_from_fork+0x29/0x50
>> [ 1733.505204]  </TASK>
>> [ 1733.507396]
>> [ 1733.508894] Allocated by task 97057:
>> [ 1733.512475]  kasan_save_stack+0x1e/0x40
>> [ 1733.516313]  kasan_set_track+0x21/0x30
>> [ 1733.520068]  __kasan_slab_alloc+0x83/0x90
>> [ 1733.524080]  kmem_cache_alloc_bulk+0x13a/0x1e0
>> [ 1733.528526]  __io_alloc_req_refill+0x238/0x510
>> [ 1733.532971]  io_submit_sqes+0x65a/0xcd0
>> [ 1733.536810]  __do_sys_io_uring_enter+0x4e9/0x830
>> [ 1733.541430]  do_syscall_64+0x59/0x90
>> [ 1733.545010]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
>> [ 1733.550071]
>> [ 1733.551571] The buggy address belongs to the object at ffff8881333203c0
>> [ 1733.551571]  which belongs to the cache io_kiocb of size 224
>> [ 1733.563816] The buggy address is located 152 bytes inside of
>> [ 1733.563816]  224-byte region [ffff8881333203c0, ffff8881333204a0)
>> [ 1733.575544]
>> [ 1733.577042] The buggy address belongs to the physical page:
>> [ 1733.582617] page:00000000edbe178c refcount:1 mapcount:0
>> mapping:0000000000000000 index:0x0 pfn:0x133320
>> [ 1733.592011] head:00000000edbe178c order:1 entire_mapcount:0
>> nr_pages_mapped:0 pincount:0
>> [ 1733.600096] memcg:ffff88810cd49001
>> [ 1733.603501] flags:
>> 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
>> [ 1733.610896] page_type: 0xffffffff()
>> [ 1733.614390] raw: 0017ffffc0010200 ffff888101222280 ffffea0004473900
>> 0000000000000002
>> [ 1733.622128] raw: 0000000000000000 0000000000190019 00000001ffffffff
>> ffff88810cd49001
>> [ 1733.629866] page dumped because: kasan: bad access detected
>> [ 1733.635439]
>> [ 1733.636938] Memory state around the buggy address:
>> [ 1733.641731]  ffff888133320300: 00 00 00 00 00 00 00 00 00 00 00 00
>> fc fc fc fc
>> [ 1733.648952]  ffff888133320380: fc fc fc fc fc fc fc fc 00 00 00 00
>> 00 00 00 00
>> [ 1733.656169] >ffff888133320400: 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00
>> [ 1733.663389]                                                        ^
>> [ 1733.669743]  ffff888133320480: 00 00 00 00 fc fc fc fc fc fc fc fc
>> fc fc fc fc
>> [ 1733.676961]  ffff888133320500: 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00
> 
> I appreciate you running tests and sending in failures, but can you
> please be more specific about what exactly was run? We seem to need to
> do this dance every time, which is just wasting time. So:
> 
> 1) What test triggered this?
> 2) Was it invoked with any arguments?
> 
> In general, a good bug report should include exactly HOW you ended
> up there.

Another thing that's really handy in bug reports like this is a
disassemble of where the bad memory access occured.  We have this:

BUG: KASAN: out-of-bounds in io_req_local_work_add+0x3b1/0x4a0

and you can look that up in gdb, for example.

-- 
Jens Axboe

