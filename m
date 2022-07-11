Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A3357015F
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 13:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiGKL6J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 07:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGKL6I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 07:58:08 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B71D32B96;
        Mon, 11 Jul 2022 04:58:05 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VJ0fXuV_1657540681;
Received: from 30.82.254.107(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VJ0fXuV_1657540681)
          by smtp.aliyun-inc.com;
          Mon, 11 Jul 2022 19:58:02 +0800
Message-ID: <bec45186-cafa-98bf-1397-bc9d51c65a6e@linux.alibaba.com>
Date:   Mon, 11 Jul 2022 19:58:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH V4 0/2] ublk: add io_uring based userspace block driver
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>
References: <20220711022024.217163-1-ming.lei@redhat.com>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <20220711022024.217163-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
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

Hello Ming,

First thanks for this great work, I think ublk will be a powerful
replacement for tcmu. I read your v3 ublk kernel and user-space
codes, and have some ublk design questions here:

1) As I said before, currently ublk still needs user-space backstore
to allocate io buffer in advance, for example, UBLK_IO_FETCH_REQ
command needs to set ublk_io->addr when starting device. Currently,
some of our internal business may create hundreds or thousands of
tcmu devices in one host, when switching to ublk, it'll need user-space
backstore to allocate lots of memory in advance, which will waste memory
in a host with swap off. Also user-space backstore may use advanced
network components, they may maintain internal memory pool, which
can be used as io buffer.

So I'd like to suggest that at least we add a new flag and keep GET_DATA
command. When used, FETCH command does not need to pass io
buffer addr, and backstore needs to send a GET_DATA command with
user addr for write request.

Support high flexibility, let's user decides what's best for them.

2) complicated ublk user-space
First forgive me  I think current ublk user-space codes looks somewhat
complicated:
  1. UBLK_CMD_START_DEV and io handler worker need to be
in different task context, because UBLK_CMD_START_DEV needs
to wait the number of queue depth of sqes to be submitted in advance.

  2. mixed getting ublk command and target io handle in one io_uring instance
I'm not sure it's a good design, see ublksrv_handle_cqe(), which contains
many flag handle work and is_target_io() check, I think the data flow is not
that clear for me at least

  3. helper like tcmulib_get_next_command()
I wonder whether current ublk user-space can offer similar helper which
will return a set of io commands to backstore easily.

I'd like to suggest:
1. When starting ublk dev, pass io_uring fd for every queue, then in
blk-mq->queue_rq(), it'll generate one cqe for every coming request,
not need to issue fetch sqes command in advance, kernel codes would
simplify a bit,  UBLK_IO_FLAG_ACTIVE may be discarded. And helper
like returning a set of io command would be added easily. Note these
io_uring fd would be just used for notifying io command generated.

2. We use another io_uring fd per queue to handle GET_DATA or
COMMIT_REQ command. Indeed, if we can support synchronous ioctl
interface to do GET_DATA and COMMIT_REQ, we may make libublk
really simple.


Here I'd like to describe how we use tcmu. A main thread call
tcmulib_get_next_command() to get a set of io commands, then
it dispatches them to user-space io wokers. Take write requests as
example, io worker use ioctl(2) to get data from bios, and send
data to distributed fs, finally call ioctl(2) to commit req. Multiple
io workers can run concurrently. Since GET_DATA(write request)
or COMMIT_REQ(read request) mainly do memcpy work, one
io_uring instance will just do these jobs sequentially, which may
not take advantage of multi-cpu.

So finally, I would suggest ublk or libulk just offer basic interface:
add/start/delete dev interface, get io commands sescriptor, get io
data, commit io helper. Let's user-space target make decisions,
for example, whether to use eventfd.

Thanks for your patience


Regards,
Xiaoguang Wang

> Hello Guys,
>
> ublk driver is one kernel driver for implementing generic userspace block
> device/driver, which delivers io request from ublk block device(/dev/ublkbN) into
> ublk server[1] which is the userspace part of ublk for communicating
> with ublk driver and handling specific io logic by its target module.
>
> Another thing ublk driver handles is to copy data between user space buffer
> and request/bio's pages, or take zero copy if mm is ready for support it in
> future. ublk driver doesn't handle any IO logic of the specific driver, so
> it is small/simple, and all io logics are done by the target code in ublkserver.
>
> The above two are main jobs done by ublk driver.
>
> ublk driver can help to move IO logic into userspace, in which the
> development work is easier/more effective than doing in kernel, such as,
> ublk-loop takes < 200 lines of loop specific code to get basically same 
> function with kernel loop block driver, meantime the performance is
> is even better than kernel loop with same setting. ublksrv[1] provide built-in
> test for comparing both by running "make test T=loop", for example, see
> the test result running on VM which is over my lattop(root disk is
> nvme/device mapper/xfs):
>
> 	[root@ktest-36 ubdsrv]#make -s -C /root/git/ubdsrv/tests run T=loop/001 R=10
> 	running loop/001
> 		fio (ublk/loop(/root/git/ubdsrv/tests/tmp/ublk_loop_VqbMA), libaio, bs 4k, dio, hw queues:1)...
> 		randwrite: jobs 1, iops 32572
> 		randread: jobs 1, iops 143052
> 		rw: jobs 1, iops read 29919 write 29964
> 	
> 	[root@ktest-36 ubdsrv]# make test T=loop/003
> 	make -s -C /root/git/ubdsrv/tests run T=loop/003 R=10
> 	running loop/003
> 		fio (kernel_loop/kloop(/root/git/ubdsrv/tests/tmp/ublk_loop_ZIVnG), libaio, bs 4k, dio, hw queues:1)...
> 		randwrite: jobs 1, iops 27436
> 		randread: jobs 1, iops 95273
> 		rw: jobs 1, iops read 22542 write 22543 
>
>
> Another example is high performance qcow2 support[2], which could be built with
> ublk framework more easily than doing it inside kernel.
>
> Also there are more people who express interests on userspace block driver[3],
> Gabriel Krisman Bertazi proposes this topic in lsf/mm/ebpf 2022 and mentioned
> requirement from Google. Ziyang Zhang from Alibaba said they "plan to
> replace TCMU by UBD as a new choice" because UBD can get better throughput than
> TCMU even with single queue[4], meantime UBD is simple. Also there is userspace
> storage service for providing storage to containers.
>
> It is io_uring based: io request is delivered to userspace via new added
> io_uring command which has been proved as very efficient for making nvme
> passthrough IO to get better IOPS than io_uring(READ/WRITE). Meantime one
> shared/mmap buffer is used for sharing io descriptor to userspace, the
> buffer is readonly for userspace, each IO just takes 24bytes so far.
> It is suggested to use io_uring in userspace(target part of ublk server)
> to handle IO request too. And it is still easy for ublkserver to support
> io handling by non-io_uring, and this work isn't done yet, but can be
> supported easily with help o eventfd.
>
> This way is efficient since no extra io command copy is required, no sleep
> is needed in transferring io command to userspace. Meantime the communication
> protocol is simple and efficient, one single command of
> UBD_IO_COMMIT_AND_FETCH_REQ can handle both fetching io request desc and commit
> command result in one trip. IO handling is often batched after single
> io_uring_enter() returns, both IO requests from ublk server target and
> IO commands could be handled as a whole batch.
>
> And the patch by patch change can be found in the following
> tree:
>
> https://github.com/ming1/linux/tree/my_for-5.20-ubd-devel_v4
>
> ublk server repo(master branch):
>
> 	https://github.com/ming1/ubdsrv
>
> Any comments are welcome!
>
> Since V3:
> - address Gabriel Krisman Bertazi's comments on V3: add userspace data
>   validation before handling command, remove warning, ...
> - remove UBLK_IO_COMMIT_REQ command as suggested by Zixiang and Gabriel Krisman Bertazi
> - fix one request double free when running abort
> - rewrite/cleanup ublk_copy_pages(), then this handling becomes very
>   clean
> - add one command of UBLK_IO_REFETCH_REQ for allowing ublk_drv to build
>   as module
>
> Since V2:
> - fix one big performance problem:
> 	https://github.com/ming1/linux/commit/3c9fd476951759858cc548dee4cedc074194d0b0
> - rename as ublk, as suggested by Gabriel Krisman Bertazi 
> - lots of cleanup & code improvement & bugfix, see details in git
>   hisotry
>
>
> Since V1:
>
> Remove RFC now because ublk driver codes gets lots of cleanup, enhancement and
> bug fixes since V1:
>
> - cleanup uapi: remove ublk specific error code,  switch to linux error code,
> remove one command op, remove one field from cmd_desc
>
> - add monitor mechanism to handle ubq_daemon being killed, ublksrv[1]
>   includes builtin tests for covering heavy IO with deleting ublk / killing
>   ubq_daemon at the same time, and V2 pass all the two tests(make test T=generic),
>   and the abort/stop mechanism is simple
>
> - fix MQ command buffer mmap bug, and now 'xfstetests -g auto' works well on
>   MQ ublk-loop devices(test/scratch)
>
> - improve batching submission as suggested by Jens
>
> - improve handling for starting device, replace random wait/poll with
> completion
>
> - all kinds of cleanup, bug fix,..
>
> Ming Lei (2):
>   ublk: add io_uring based userspace block driver
>   ublk_drv: add UBLK_IO_REFETCH_REQ for supporting to build as module
>
>  drivers/block/Kconfig         |    6 +
>  drivers/block/Makefile        |    2 +
>  drivers/block/ublk_drv.c      | 1701 +++++++++++++++++++++++++++++++++
>  include/uapi/linux/ublk_cmd.h |  173 ++++
>  4 files changed, 1882 insertions(+)
>  create mode 100644 drivers/block/ublk_drv.c
>  create mode 100644 include/uapi/linux/ublk_cmd.h
>

