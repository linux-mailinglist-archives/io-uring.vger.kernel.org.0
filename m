Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73C173DAE3
	for <lists+io-uring@lfdr.de>; Mon, 26 Jun 2023 11:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjFZJM0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jun 2023 05:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbjFZJLz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Jun 2023 05:11:55 -0400
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2649A270D;
        Mon, 26 Jun 2023 02:10:04 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=mengferry@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VlzLk7o_1687770601;
Received: from 30.221.129.54(mailfrom:mengferry@linux.alibaba.com fp:SMTPD_---0VlzLk7o_1687770601)
          by smtp.aliyun-inc.com;
          Mon, 26 Jun 2023 17:10:02 +0800
Message-ID: <34696152-3ae8-138a-d426-aa4fdde4e7ab@linux.alibaba.com>
Date:   Mon, 26 Jun 2023 17:09:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Content-Language: en-US
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     joseph.qi@linux.alibaba.com, linux-block@vger.kernel.org
From:   Ferry Meng <mengferry@linux.alibaba.com>
Subject: [bug report] nvme passthrough: request failed when blocksize
 exceeding max_hw_sectors
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello:

I'm testing the io-uring nvme passthrough via fio. But I have 
encountered the following issue:
When I specify 'blocksize' exceeding 128KB (actually the maximum size 
per request can send 'max_sectors_kb'), the creation of request failed 
and directly returned -22 (-EINVAL).

For example:

# cat fio.job

     [global]
     ioengine=io_uring_cmd
     thread=1
     time_based
     numjobs=1
     iodepth=1
     runtime=120
     rw=randwrite
     cmd_type=nvme
     hipri=1

     [randwrite]
     bs=132k
     filename=/dev/ng1n1

# fio fio.job
randwrite: (g=0): rw=randwrite, bs=(R) 132KiB-132KiB, (W) 132KiB-132KiB, 
(T) 132KiB-132KiB, ioengine=io_uring_cmd, iodepth=1
fio-3.34-10-g2fa0-dirty
Starting 1 thread
fio: io_u error on file /dev/ng1n1: Invalid argument: write 
offset=231584956416, buflen=135168
fio: pid=148989, err=22/file:io_u.c:1889, func=io_u error, error=Invalid 
argument

I tracked the position that returns the error val in kernel and dumped 
calltrace.

[   83.352715] nvme nvme1: 15/0/1 default/read/poll queues
[   83.363273] nvme nvme1: Ignoring bogus Namespace Identifiers
[   91.578457] CPU: 14 PID: 3993 Comm: fio Not tainted 
6.4.0-rc7-00014-g692b7dc87ca6-dirty #2
[   91.578462] Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS 
2221b89 04/01/2014
[   91.578463] Call Trace:
[   91.578476]  <TASK>
[   91.578478]  dump_stack_lvl+0x36/0x50
[   91.578484]  ll_back_merge_fn+0x20d/0x320
[   91.578490]  blk_rq_append_bio+0x6d/0xc0
[   91.578492]  bio_map_user_iov+0x24a/0x3d0
[   91.578494]  blk_rq_map_user_iov+0x292/0x680
[   91.578496]  ? blk_mq_get_tag+0x249/0x280
[   91.578500]  blk_rq_map_user+0x56/0x80
[   91.578503]  nvme_map_user_request.isra.15+0x90/0x1e0 [nvme_core]
[   91.578515]  nvme_uring_cmd_io+0x29d/0x2f0 [nvme_core]
[   91.578522]  io_uring_cmd+0x89/0x110
[   91.578526]  ? __pfx_io_uring_cmd+0x10/0x10
[   91.578528]  io_issue_sqe+0x1e0/0x2d0
[   91.578530]  io_submit_sqes+0x1e3/0x650
[   91.578532]  __x64_sys_io_uring_enter+0x2da/0x450
[   91.578534]  do_syscall_64+0x3b/0x90
[   91.578537]  entry_SYSCALL_64_after_hwframe+0x72/0xdc

Here in bio_map_user_iov()->blk_rq_append_bio(), I found the error val 
-EINVAL:

blk_rq_append_bio:
     ...
     if (!ll_back_merge_fn(rq, bio, nr_segs))
         return -EINVAL;
     rq->biotail->bi_next = bio;
     ...

And in ll_back_merge_fn(), returns 0 if merge can't happen. It checks 
the request size:
ll_back_merge_fn:
     if (blk_rq_sectors(req) + bio_sectors(bio) >
         blk_rq_get_max_sectors(req, blk_rq_pos(req))) {
             req_set_nomerge(req->q, req);
             return 0;
     }

The ROOT cause is: In blk_rq_get_max_sectors, it returns 
'max_hw_sectors' directly(in my device ,it's 256 sector, which means 
128KB), causing the above inequality to hold true.
blk_rq_get_max_sectors:
     ...
     if (blk_rq_is_passthrough(rq)){
         return q->limits.max_hw_sectors;
     }
     ...

I checked my disk's specs(cat 
/sys/block/<mydisk>/queue/max_hw_sectors_kb 
/sys/block/<mydisk>/queue/max_sectors_kb), both are 128KB.So I think 
this arg causing the issue.

I'm not sure if this is a designed restriction. Or should I have to take 
care of it in application?

Thanks,
Ferry Meng

