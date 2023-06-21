Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2DCF738A34
	for <lists+io-uring@lfdr.de>; Wed, 21 Jun 2023 17:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbjFUP4g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Jun 2023 11:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjFUP4f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Jun 2023 11:56:35 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1026C19C
        for <io-uring@vger.kernel.org>; Wed, 21 Jun 2023 08:56:34 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-77dcff76e35so78392139f.1
        for <io-uring@vger.kernel.org>; Wed, 21 Jun 2023 08:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687362993; x=1689954993;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vYcvp71MTIIOpJpWxL01xl4yqXNwN5gjLptOK3gLd2M=;
        b=aUZhb/MF8p4ZHsz2FugFfRL2k25+8t7oSsK6wkT6Hxq32wFfdENd4SS1bDT535Df0p
         vBzf3CQ2V9xJqWwYKSYsxj1ruEX1S2VjOcDSvdDyqGkLP76mZwLbANK3DFlAqTKPULzK
         utZ3FN4lnqTZT4adeFjqOrM4EcSpDZYkLfXfSxvliyrd8ZKLwHT3rAiAEe8PikMVlexr
         7Juttzv0wcYw/SgoWXFgsQIaw/ejWWtIjB5H67+Q8rJCKdmcSmgDQ0oc7r3/k7lrV7bB
         D4BGArfQHZSZf6ni+eWmKh5vvkwKMPOpSsMps/WmhCUSvhScINLRVk+hniRwitrC+gDM
         lAkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687362993; x=1689954993;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vYcvp71MTIIOpJpWxL01xl4yqXNwN5gjLptOK3gLd2M=;
        b=af/eRSK4EjH24X82BwuoV/qmw5fUsCunyvWchMktc8aFirxQs2JBlvcygr+heTJ/bX
         EuXQE1dB2OceaAVn3HKwqW/SZ1xnKK1m/I81l538GFbwt7LXdiii/dT2BzapViLYPJR7
         OhEEm8b2J1Z0zTwZp7G60fvPfe93xY25C5NQ9ZF0cPp6fGIv/ULVey8pcw8AU4/YTRa6
         sDSp9Jtr6/gBbkcQdsPbYgjv47TE04mlKTOP6ajHbue/3ZELT2U0GL1nvVQqvrmT8dGG
         xeSnchr4nSGpm4rgjKbXOJ5aVlbXuK0Z3dp6KG2Nq2i3KVSz0qk9PjcF1F7bdRkpHrTo
         fCYQ==
X-Gm-Message-State: AC+VfDweX6YPS/diqnyksi8RbJ+XZO0rhn/1Lq4FyHpQezTji15FeGve
        S5ZeBMkb6yhCNzcFpWnSHuXVtg==
X-Google-Smtp-Source: ACHHUZ4oIiQGnz4t/noYYVjDaG+JTl41WzWesmgur+BItvfaArB4yoOvxG7SJKxAxd1v1RGOrx+gDg==
X-Received: by 2002:a05:6602:2acb:b0:77e:23a7:c9eb with SMTP id m11-20020a0566022acb00b0077e23a7c9ebmr508699iov.0.1687362993365;
        Wed, 21 Jun 2023 08:56:33 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f15-20020a6bdd0f000000b0077a1b6f73b9sm1446153ioc.41.2023.06.21.08.56.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jun 2023 08:56:32 -0700 (PDT)
Message-ID: <e7562fe1-0dd5-a864-cc0d-32701dac943c@kernel.dk>
Date:   Wed, 21 Jun 2023 09:56:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [bug report] BUG: KASAN: out-of-bounds in
 io_req_local_work_add+0x3b1/0x4a0
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Guangwu Zhang <guazhang@redhat.com>, linux-block@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, io-uring@vger.kernel.org
References: <CAGS2=YrvrD0hf7WGjQd4Me772=m9=E6J92aGtG0PAoF4yD6dTw@mail.gmail.com>
 <e92a19fa-74cc-2b9f-3173-6a04557a6534@kernel.dk>
 <ZJMDWIZv5kuJ7nGl@ovpn-8-23.pek2.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZJMDWIZv5kuJ7nGl@ovpn-8-23.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/21/23 8:04?AM, Ming Lei wrote:
> On Wed, Jun 21, 2023 at 07:40:49AM -0600, Jens Axboe wrote:
>> On 6/21/23 1:38?AM, Guangwu Zhang wrote:
>>> HI,
>>> Found the io_req_local_work_add error when run  liburing testing.
>>>
>>> kernel repo :
>>>     Merge branch 'for-6.5/block' into for-next
>>>     * for-6.5/block:
>>>       reiserfs: fix blkdev_put() warning from release_journal_dev()
>>>
>>> [ 1733.389012] BUG: KASAN: out-of-bounds in io_req_local_work_add+0x3b1/0x4a0
>>> [ 1733.395900] Read of size 4 at addr ffff888133320458 by task
>>> iou-wrk-97057/97138
>>> [ 1733.403205]
>>> [ 1733.404706] CPU: 4 PID: 97138 Comm: iou-wrk-97057 Kdump: loaded Not
>>> tainted 6.4.0-rc3.kasan+ #1
>>> [ 1733.413404] Hardware name: Dell Inc. PowerEdge R740/06WXJT, BIOS
>>> 2.13.3 12/13/2021
>>> [ 1733.420972] Call Trace:
>>> [ 1733.423425]  <TASK>
>>> [ 1733.425533]  dump_stack_lvl+0x33/0x50
>>> [ 1733.429207]  print_address_description.constprop.0+0x2c/0x3e0
>>> [ 1733.434959]  print_report+0xb5/0x270
>>> [ 1733.438539]  ? kasan_addr_to_slab+0x9/0xa0
>>> [ 1733.442639]  ? io_req_local_work_add+0x3b1/0x4a0
>>> [ 1733.447258]  kasan_report+0xcf/0x100
>>> [ 1733.450839]  ? io_req_local_work_add+0x3b1/0x4a0
>>> [ 1733.455456]  io_req_local_work_add+0x3b1/0x4a0
>>> [ 1733.459903]  ? __pfx_io_req_local_work_add+0x10/0x10
>>> [ 1733.464871]  ? __schedule+0x616/0x1530
>>> [ 1733.468622]  __io_req_task_work_add+0x1bc/0x270
>>> [ 1733.473156]  io_issue_sqe+0x55a/0xe80
>>> [ 1733.476831]  io_wq_submit_work+0x23e/0xa00
>>> [ 1733.480930]  io_worker_handle_work+0x2f5/0xa80
>>> [ 1733.485384]  io_wq_worker+0x6c5/0x9d0
>>> [ 1733.489051]  ? __pfx_io_wq_worker+0x10/0x10
>>> [ 1733.493246]  ? _raw_spin_lock_irq+0x82/0xe0
>>> [ 1733.497430]  ? __pfx_io_wq_worker+0x10/0x10
>>> [ 1733.501616]  ret_from_fork+0x29/0x50
>>> [ 1733.505204]  </TASK>
>>> [ 1733.507396]
>>> [ 1733.508894] Allocated by task 97057:
>>> [ 1733.512475]  kasan_save_stack+0x1e/0x40
>>> [ 1733.516313]  kasan_set_track+0x21/0x30
>>> [ 1733.520068]  __kasan_slab_alloc+0x83/0x90
>>> [ 1733.524080]  kmem_cache_alloc_bulk+0x13a/0x1e0
>>> [ 1733.528526]  __io_alloc_req_refill+0x238/0x510
>>> [ 1733.532971]  io_submit_sqes+0x65a/0xcd0
>>> [ 1733.536810]  __do_sys_io_uring_enter+0x4e9/0x830
>>> [ 1733.541430]  do_syscall_64+0x59/0x90
>>> [ 1733.545010]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
>>> [ 1733.550071]
>>> [ 1733.551571] The buggy address belongs to the object at ffff8881333203c0
>>> [ 1733.551571]  which belongs to the cache io_kiocb of size 224
>>> [ 1733.563816] The buggy address is located 152 bytes inside of
>>> [ 1733.563816]  224-byte region [ffff8881333203c0, ffff8881333204a0)
>>> [ 1733.575544]
>>> [ 1733.577042] The buggy address belongs to the physical page:
>>> [ 1733.582617] page:00000000edbe178c refcount:1 mapcount:0
>>> mapping:0000000000000000 index:0x0 pfn:0x133320
>>> [ 1733.592011] head:00000000edbe178c order:1 entire_mapcount:0
>>> nr_pages_mapped:0 pincount:0
>>> [ 1733.600096] memcg:ffff88810cd49001
>>> [ 1733.603501] flags:
>>> 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
>>> [ 1733.610896] page_type: 0xffffffff()
>>> [ 1733.614390] raw: 0017ffffc0010200 ffff888101222280 ffffea0004473900
>>> 0000000000000002
>>> [ 1733.622128] raw: 0000000000000000 0000000000190019 00000001ffffffff
>>> ffff88810cd49001
>>> [ 1733.629866] page dumped because: kasan: bad access detected
>>> [ 1733.635439]
>>> [ 1733.636938] Memory state around the buggy address:
>>> [ 1733.641731]  ffff888133320300: 00 00 00 00 00 00 00 00 00 00 00 00
>>> fc fc fc fc
>>> [ 1733.648952]  ffff888133320380: fc fc fc fc fc fc fc fc 00 00 00 00
>>> 00 00 00 00
>>> [ 1733.656169] >ffff888133320400: 00 00 00 00 00 00 00 00 00 00 00 00
>>> 00 00 00 00
>>> [ 1733.663389]                                                        ^
>>> [ 1733.669743]  ffff888133320480: 00 00 00 00 fc fc fc fc fc fc fc fc
>>> fc fc fc fc
>>> [ 1733.676961]  ffff888133320500: 00 00 00 00 00 00 00 00 00 00 00 00
>>> 00 00 00 00
>>
>> I appreciate you running tests and sending in failures, but can you
>> please be more specific about what exactly was run? We seem to need to
>> do this dance every time, which is just wasting time. So:
>>
>> 1) What test triggered this?
>> 2) Was it invoked with any arguments?
> 
> I can see the whole dmesg log, and it seems from "sq-full-cpp.c /dev/sda":
> 
> [ 1340.918880] Running test sq-full-cpp.t:
> [ 1341.009225] Running test sq-full-cpp.t /dev/sda:
> [ 1342.025292] restraintd[1061]: *** Current Time: Tue Jun 20 21:17:57 2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
> [ 1402.053433] restraintd[1061]: *** Current Time: Tue Jun 20 21:18:57 2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
> [ 1462.047970] restraintd[1061]: *** Current Time: Tue Jun 20 21:19:57 2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
> [-- MARK -- Wed Jun 21 01:20:00 2023]
> [ 1522.029598] restraintd[1061]: *** Current Time: Tue Jun 20 21:20:57 2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
> [ 1582.029278] restraintd[1061]: *** Current Time: Tue Jun 20 21:21:57 2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
> [ 1642.034617] restraintd[1061]: *** Current Time: Tue Jun 20 21:22:57 2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
> [ 1702.034344] restraintd[1061]: *** Current Time: Tue Jun 20 21:23:57 2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
> [ 1733.381782] ==================================================================
> [ 1733.389012] BUG: KASAN: out-of-bounds in io_req_local_work_add+0x3b1/0x4a0
> [ 1733.395900] Read of size 4 at addr ffff888133320458 by task iou-wrk-97057/97138

I don't think that's right - sq-full-cpp doesn't do anything if passed
an argument, and you also have a lot of time passing in between that
test being run and the warning being spewed. Maybe the tests are run
both as root and non-root? The root run ones will add the dmesg spew on
which test is being run, the non-root will not.

-- 
Jens Axboe

