Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C077B73863C
	for <lists+io-uring@lfdr.de>; Wed, 21 Jun 2023 16:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbjFUOIZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Jun 2023 10:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjFUOIY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Jun 2023 10:08:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496BC1BFF
        for <io-uring@vger.kernel.org>; Wed, 21 Jun 2023 07:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687356438;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y0VXle0mWQQDtXBt0Zh+ZRqAUi1Ww/WnndqHkbNtqU4=;
        b=BFIOix73WgDcbFsMpNba2taOsxBRqwtEeY9F+evDRLXVz7aeP1JBm7RuSFbrFXFp7slzFq
        Kj7TzDHv9ka2s1kVrPG+BcjKu6jAqieba5IJ8J4BUNkxYOrLmsk9LadJLPGevVMdMIp/1K
        8y98oO8fRT3dW9FqEJe0IhwbWxjsWPM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-bOXMgb1EMzOU2WNg0OSAag-1; Wed, 21 Jun 2023 10:07:15 -0400
X-MC-Unique: bOXMgb1EMzOU2WNg0OSAag-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D5F889F51C;
        Wed, 21 Jun 2023 14:04:17 +0000 (UTC)
Received: from ovpn-8-23.pek2.redhat.com (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D43C0492B01;
        Wed, 21 Jun 2023 14:04:13 +0000 (UTC)
Date:   Wed, 21 Jun 2023 22:04:08 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Guangwu Zhang <guazhang@redhat.com>, linux-block@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, io-uring@vger.kernel.org
Subject: Re: [bug report] BUG: KASAN: out-of-bounds in
 io_req_local_work_add+0x3b1/0x4a0
Message-ID: <ZJMDWIZv5kuJ7nGl@ovpn-8-23.pek2.redhat.com>
References: <CAGS2=YrvrD0hf7WGjQd4Me772=m9=E6J92aGtG0PAoF4yD6dTw@mail.gmail.com>
 <e92a19fa-74cc-2b9f-3173-6a04557a6534@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e92a19fa-74cc-2b9f-3173-6a04557a6534@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 21, 2023 at 07:40:49AM -0600, Jens Axboe wrote:
> On 6/21/23 1:38?AM, Guangwu Zhang wrote:
> > HI,
> > Found the io_req_local_work_add error when run  liburing testing.
> > 
> > kernel repo :
> >     Merge branch 'for-6.5/block' into for-next
> >     * for-6.5/block:
> >       reiserfs: fix blkdev_put() warning from release_journal_dev()
> > 
> > [ 1733.389012] BUG: KASAN: out-of-bounds in io_req_local_work_add+0x3b1/0x4a0
> > [ 1733.395900] Read of size 4 at addr ffff888133320458 by task
> > iou-wrk-97057/97138
> > [ 1733.403205]
> > [ 1733.404706] CPU: 4 PID: 97138 Comm: iou-wrk-97057 Kdump: loaded Not
> > tainted 6.4.0-rc3.kasan+ #1
> > [ 1733.413404] Hardware name: Dell Inc. PowerEdge R740/06WXJT, BIOS
> > 2.13.3 12/13/2021
> > [ 1733.420972] Call Trace:
> > [ 1733.423425]  <TASK>
> > [ 1733.425533]  dump_stack_lvl+0x33/0x50
> > [ 1733.429207]  print_address_description.constprop.0+0x2c/0x3e0
> > [ 1733.434959]  print_report+0xb5/0x270
> > [ 1733.438539]  ? kasan_addr_to_slab+0x9/0xa0
> > [ 1733.442639]  ? io_req_local_work_add+0x3b1/0x4a0
> > [ 1733.447258]  kasan_report+0xcf/0x100
> > [ 1733.450839]  ? io_req_local_work_add+0x3b1/0x4a0
> > [ 1733.455456]  io_req_local_work_add+0x3b1/0x4a0
> > [ 1733.459903]  ? __pfx_io_req_local_work_add+0x10/0x10
> > [ 1733.464871]  ? __schedule+0x616/0x1530
> > [ 1733.468622]  __io_req_task_work_add+0x1bc/0x270
> > [ 1733.473156]  io_issue_sqe+0x55a/0xe80
> > [ 1733.476831]  io_wq_submit_work+0x23e/0xa00
> > [ 1733.480930]  io_worker_handle_work+0x2f5/0xa80
> > [ 1733.485384]  io_wq_worker+0x6c5/0x9d0
> > [ 1733.489051]  ? __pfx_io_wq_worker+0x10/0x10
> > [ 1733.493246]  ? _raw_spin_lock_irq+0x82/0xe0
> > [ 1733.497430]  ? __pfx_io_wq_worker+0x10/0x10
> > [ 1733.501616]  ret_from_fork+0x29/0x50
> > [ 1733.505204]  </TASK>
> > [ 1733.507396]
> > [ 1733.508894] Allocated by task 97057:
> > [ 1733.512475]  kasan_save_stack+0x1e/0x40
> > [ 1733.516313]  kasan_set_track+0x21/0x30
> > [ 1733.520068]  __kasan_slab_alloc+0x83/0x90
> > [ 1733.524080]  kmem_cache_alloc_bulk+0x13a/0x1e0
> > [ 1733.528526]  __io_alloc_req_refill+0x238/0x510
> > [ 1733.532971]  io_submit_sqes+0x65a/0xcd0
> > [ 1733.536810]  __do_sys_io_uring_enter+0x4e9/0x830
> > [ 1733.541430]  do_syscall_64+0x59/0x90
> > [ 1733.545010]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> > [ 1733.550071]
> > [ 1733.551571] The buggy address belongs to the object at ffff8881333203c0
> > [ 1733.551571]  which belongs to the cache io_kiocb of size 224
> > [ 1733.563816] The buggy address is located 152 bytes inside of
> > [ 1733.563816]  224-byte region [ffff8881333203c0, ffff8881333204a0)
> > [ 1733.575544]
> > [ 1733.577042] The buggy address belongs to the physical page:
> > [ 1733.582617] page:00000000edbe178c refcount:1 mapcount:0
> > mapping:0000000000000000 index:0x0 pfn:0x133320
> > [ 1733.592011] head:00000000edbe178c order:1 entire_mapcount:0
> > nr_pages_mapped:0 pincount:0
> > [ 1733.600096] memcg:ffff88810cd49001
> > [ 1733.603501] flags:
> > 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
> > [ 1733.610896] page_type: 0xffffffff()
> > [ 1733.614390] raw: 0017ffffc0010200 ffff888101222280 ffffea0004473900
> > 0000000000000002
> > [ 1733.622128] raw: 0000000000000000 0000000000190019 00000001ffffffff
> > ffff88810cd49001
> > [ 1733.629866] page dumped because: kasan: bad access detected
> > [ 1733.635439]
> > [ 1733.636938] Memory state around the buggy address:
> > [ 1733.641731]  ffff888133320300: 00 00 00 00 00 00 00 00 00 00 00 00
> > fc fc fc fc
> > [ 1733.648952]  ffff888133320380: fc fc fc fc fc fc fc fc 00 00 00 00
> > 00 00 00 00
> > [ 1733.656169] >ffff888133320400: 00 00 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00
> > [ 1733.663389]                                                        ^
> > [ 1733.669743]  ffff888133320480: 00 00 00 00 fc fc fc fc fc fc fc fc
> > fc fc fc fc
> > [ 1733.676961]  ffff888133320500: 00 00 00 00 00 00 00 00 00 00 00 00
> > 00 00 00 00
> 
> I appreciate you running tests and sending in failures, but can you
> please be more specific about what exactly was run? We seem to need to
> do this dance every time, which is just wasting time. So:
> 
> 1) What test triggered this?
> 2) Was it invoked with any arguments?

I can see the whole dmesg log, and it seems from "sq-full-cpp.c /dev/sda":

[ 1340.918880] Running test sq-full-cpp.t:
[ 1341.009225] Running test sq-full-cpp.t /dev/sda:
[ 1342.025292] restraintd[1061]: *** Current Time: Tue Jun 20 21:17:57 2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
[ 1402.053433] restraintd[1061]: *** Current Time: Tue Jun 20 21:18:57 2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
[ 1462.047970] restraintd[1061]: *** Current Time: Tue Jun 20 21:19:57 2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
[-- MARK -- Wed Jun 21 01:20:00 2023]
[ 1522.029598] restraintd[1061]: *** Current Time: Tue Jun 20 21:20:57 2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
[ 1582.029278] restraintd[1061]: *** Current Time: Tue Jun 20 21:21:57 2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
[ 1642.034617] restraintd[1061]: *** Current Time: Tue Jun 20 21:22:57 2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
[ 1702.034344] restraintd[1061]: *** Current Time: Tue Jun 20 21:23:57 2023  Localwatchdog at: Wed Jun 21 01:03:56 2023
[ 1733.381782] ==================================================================
[ 1733.389012] BUG: KASAN: out-of-bounds in io_req_local_work_add+0x3b1/0x4a0
[ 1733.395900] Read of size 4 at addr ffff888133320458 by task iou-wrk-97057/97138


Thank,
Ming

