Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3749D4B61E7
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 04:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbiBOD7X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Feb 2022 22:59:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbiBOD7X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Feb 2022 22:59:23 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0963137009;
        Mon, 14 Feb 2022 19:59:12 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V4WYNGT_1644897549;
Received: from 30.225.24.82(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V4WYNGT_1644897549)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 15 Feb 2022 11:59:10 +0800
Message-ID: <fe10885d-78b7-a90a-01a0-60ac58d64357@linux.alibaba.com>
Date:   Tue, 15 Feb 2022 11:59:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH v1 00/14] Support sync buffered writes for io-uring
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        kernel-team@fb.com
References: <20220214174403.4147994-1-shr@fb.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
In-Reply-To: <20220214174403.4147994-1-shr@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/2/15 上午1:43, Stefan Roesch 写道:
> This patch series adds support for async buffered writes. Currently
> io-uring only supports buffered writes in the slow path, by processing
> them in the io workers. With this patch series it is now possible to
> support buffered writes in the fast path. To be able to use the fast
> path the required pages must be in the page cache or they can be loaded
> with noio. Otherwise they still get punted to the slow path.
> 
> If a buffered write request requires more than one page, it is possible
> that only part of the request can use the fast path, the resst will be
> completed by the io workers.
> 
> Support for async buffered writes:
>    Patch 1: fs: Add flags parameter to __block_write_begin_int
>      Add a flag parameter to the function __block_write_begin_int
>      to allow specifying a nowait parameter.
>      
>    Patch 2: mm: Introduce do_generic_perform_write
>      Introduce a new do_generic_perform_write function. The function
>      is split off from the existing generic_perform_write() function.
>      It allows to specify an additional flag parameter. This parameter
>      is used to specify the nowait flag.
>      
>    Patch 3: mm: add noio support in filemap_get_pages
>      This allows to allocate pages with noio, if a page for async
>      buffered writes is not yet loaded in the page cache.
>      
>    Patch 4: mm: Add support for async buffered writes
>      For async buffered writes allocate pages without blocking on the
>      allocation.
> 
>    Patch 5: fs: split off __alloc_page_buffers function
>      Split off __alloc_page_buffers() function with new gfp_t parameter.
> 
>    Patch 6: fs: split off __create_empty_buffers function
>      Split off __create_empty_buffers() function with new gfp_t parameter.
> 
>    Patch 7: fs: Add aop_flags parameter to create_page_buffers()
>      Add aop_flags to create_page_buffers() function. Use atomic allocation
>      for async buffered writes.
> 
>    Patch 8: fs: add support for async buffered writes
>      Return -EAGAIN instead of -ENOMEM for async buffered writes. This
>      will cause the write request to be processed by an io worker.
> 
>    Patch 9: io_uring: add support for async buffered writes
>      This enables the async buffered writes for block devices in io_uring.
>      Buffered writes are enabled for blocks that are already in the page
>      cache or can be acquired with noio.
> 
>    Patch 10: io_uring: Add tracepoint for short writes
> 
> Support for write throttling of async buffered writes:
>    Patch 11: sched: add new fields to task_struct
>      Add two new fields to the task_struct. These fields store the
>      deadline after which writes are no longer throttled.
> 
>    Patch 12: mm: support write throttling for async buffered writes
>      This changes the balance_dirty_pages function to take an additonal
>      parameter. When nowait is specified the write throttling code no
>      longer waits synchronously for the deadline to expire. Instead
>      it sets the fields in task_struct. Once the deadline expires the
>      fields are reset.
>      
>    Patch 13: io_uring: support write throttling for async buffered writes
>      Adds support to io_uring for write throttling. When the writes
>      are throttled, the write requests are added to the pending io list.
>      Once the write throttling deadline expires, the writes are submitted.
>      
> Enable async buffered write support
>    Patch 14: fs: add flag to support async buffered writes
>      This sets the flags that enables async buffered writes for block
>      devices.
> 
> 
> Testing:
>    This patch has been tested with xfstests and fio.
> 
> 
> Peformance results:
>    For fio the following results have been obtained with a queue depth of
>    1 and 4k block size (runtime 600 secs):
> 
>                   sequential writes:
>                   without patch                 with patch
>    throughput:       329 Mib/s                    1032Mib/s
>    iops:              82k                          264k
>    slat (nsec)      2332                          3340
>    clat (nsec)      9017                            60
>                     
>    CPU util%:         37%                          78%
> 
> 
> 
>                   random writes:
>                   without patch                 with patch
>    throughput:       307 Mib/s                    909Mib/s
>    iops:              76k                         227k
>    slat (nsec)      2419                         3780
>    clat (nsec)      9934                           59
> 
>    CPU util%:         57%                          88%
> 
> For an io depth of 1, the new patch improves throughput by close to 3
> times and also the latency is considerably reduced. To achieve the same
> or better performance with the exisiting code an io depth of 4 is required.
> 
> Especially for mixed workloads this is a considerable improvement.
> 
> 
> 
> 
> Stefan Roesch (14):
>    fs: Add flags parameter to __block_write_begin_int
>    mm: Introduce do_generic_perform_write
>    mm: add noio support in filemap_get_pages
>    mm: Add support for async buffered writes
>    fs: split off __alloc_page_buffers function
>    fs: split off __create_empty_buffers function
>    fs: Add aop_flags parameter to create_page_buffers()
>    fs: add support for async buffered writes
>    io_uring: add support for async buffered writes
>    io_uring: Add tracepoint for short writes
>    sched: add new fields to task_struct
>    mm: support write throttling for async buffered writes
>    io_uring: support write throttling for async buffered writes
>    block: enable async buffered writes for block devices.
> 
>   block/fops.c                    |   5 +-
>   fs/buffer.c                     | 103 ++++++++++++++++---------
>   fs/internal.h                   |   3 +-
>   fs/io_uring.c                   | 130 +++++++++++++++++++++++++++++---
>   fs/iomap/buffered-io.c          |   4 +-
>   fs/read_write.c                 |   3 +-
>   include/linux/fs.h              |   4 +
>   include/linux/sched.h           |   3 +
>   include/linux/writeback.h       |   1 +
>   include/trace/events/io_uring.h |  25 ++++++
>   kernel/fork.c                   |   1 +
>   mm/filemap.c                    |  34 +++++++--
>   mm/folio-compat.c               |   4 +
>   mm/page-writeback.c             |  54 +++++++++----
>   14 files changed, 298 insertions(+), 76 deletions(-)
> 
> 
> base-commit: f1baf68e1383f6ed93eb9cff2866d46562607a43
> 
It's a little bit different between buffered read and buffered write,
there may be block points in detail filesystems due to journal
operations for the latter.

