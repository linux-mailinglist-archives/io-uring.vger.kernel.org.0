Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2A1588B79
	for <lists+io-uring@lfdr.de>; Wed,  3 Aug 2022 13:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237443AbiHCLpg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Aug 2022 07:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237627AbiHCLpe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Aug 2022 07:45:34 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4720F6431;
        Wed,  3 Aug 2022 04:45:27 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VLGwN9Y_1659527124;
Received: from 30.227.84.71(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VLGwN9Y_1659527124)
          by smtp.aliyun-inc.com;
          Wed, 03 Aug 2022 19:45:25 +0800
Message-ID: <99bc953a-22d4-2bb2-e2b9-f0a92e787c1b@linux.alibaba.com>
Date:   Wed, 3 Aug 2022 19:45:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Content-Language: en-US
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [bug report] ublk_drv: hang while removing ublk character device
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi all,

Now ublk_drv has been pushed into master branch and I am running tests on it.
With newest(master) kernel and newest(master) ublksrv[1], a test case(generic/001) of ublksrv failed(hanged):

$sudo make test_all
make -s -C ubdsrv/tests run_test_all R=10
running generic/001
        run fio with delete ublk-loop test
        run fio on ublk(uring_comp 1) with delete 1

and the dmesg shows:

[Wed Aug  3 19:07:28 2022] INFO: task ublk:44727 blocked for more than 122 seconds.
[Wed Aug  3 19:07:28 2022]       Tainted: G S          E      5.19.0 #117
[Wed Aug  3 19:07:28 2022] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[Wed Aug  3 19:07:28 2022] task:ublk            state:D stack:    0 pid:44727 ppid: 44650 flags:0x00004000
[Wed Aug  3 19:07:28 2022] Call Trace:
[Wed Aug  3 19:07:28 2022]  <TASK>
[Wed Aug  3 19:07:28 2022]  __schedule+0x212/0x600
[Wed Aug  3 19:07:28 2022]  schedule+0x5d/0xd0
[Wed Aug  3 19:07:28 2022]  ublk_ctrl_del_dev+0x133/0x1c0
[Wed Aug  3 19:07:28 2022]  ? cpuacct_percpu_seq_show+0x10/0x10
[Wed Aug  3 19:07:28 2022]  ublk_ctrl_uring_cmd+0x1a7/0x1e0
[Wed Aug  3 19:07:28 2022]  ? io_uring_cmd_prep+0x30/0x30
[Wed Aug  3 19:07:28 2022]  io_uring_cmd+0x55/0xe0
[Wed Aug  3 19:07:28 2022]  io_issue_sqe+0x196/0x310
[Wed Aug  3 19:07:28 2022]  io_submit_sqes+0x116/0x370
[Wed Aug  3 19:07:28 2022]  __do_sys_io_uring_enter+0x313/0x5a0
[Wed Aug  3 19:07:28 2022]  do_syscall_64+0x35/0x80
[Wed Aug  3 19:07:28 2022]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[Wed Aug  3 19:07:28 2022] RIP: 0033:0x7f6de1c13936
[Wed Aug  3 19:07:28 2022] RSP: 002b:00007ffcdbf42bc8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
[Wed Aug  3 19:07:28 2022] RAX: ffffffffffffffda RBX: 0000000000442f60 RCX: 00007f6de1c13936
[Wed Aug  3 19:07:28 2022] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000004
[Wed Aug  3 19:07:28 2022] RBP: 0000000000442f60 R08: 0000000000000000 R09: 0000000000000008
[Wed Aug  3 19:07:28 2022] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[Wed Aug  3 19:07:28 2022] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[Wed Aug  3 19:07:28 2022]  </TASK>

My environment:

(1) kernel: master(head is e2b542100719a93f8cdf6d90185410d38a57a4c1)
(2) ubdsrv: master(head is 304151a7ef031413df26302e86b457eb1bad908f)
(3) liburing: 2.2 release [2]

How to reproduce:

(1) clone kernel master branch. Please make sure that ublk_drv.c is in drivers/block directory.
(2) build the kernel, ublk_drv should be a module(M) or built-in(*).
(3) modprobe ublk_drv(if you choose 'M' while configuring the kernel)
(4) clone ming's ublksrv[1] and make. You should use gcc-10(or higher) and liburing(I choose 2.2[2])
(4) run tests by: make test_all

You should find that the first test: generic/001 hangs and the kernel prints message shown above.

My analysis:

(1) ublk_ctrl_del_dev+0x133 should be drivers/block/ublk_drv.c:1387. It is:
    wait_event(ublk_idr_wq, ublk_idr_freed(idx)) called in ublk_ctrl_del_dev()

(2) We hang beacuse we are infinitely waiting for a freed idr(such as idx 0 for /dev/ublkc0).

(3) This idr should be freed while calling ublk_cdev_rel()
    which is set as ->release() method for one ublk character device(such as /dev/ublkc0).

(4) I think ublk_cdev_rel() is not correctly called while removing /dev/ublkc0. Then the
    infinite wait_event happens.

[1] https://github.com/ming1/ubdsrv
[2] https://github.com/axboe/liburing/releases/tag/liburing-2.2



-- 
Ziyang Zhang
