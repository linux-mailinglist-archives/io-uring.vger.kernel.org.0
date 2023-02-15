Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44DFF69785F
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 09:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjBOIlI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 03:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjBOIlH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 03:41:07 -0500
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D11F3;
        Wed, 15 Feb 2023 00:41:02 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VbjZOxd_1676450459;
Received: from 30.221.150.4(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VbjZOxd_1676450459)
          by smtp.aliyun-inc.com;
          Wed, 15 Feb 2023 16:40:59 +0800
Message-ID: <45b1fea5-8ced-1eda-7f3d-dc6dc5727d55@linux.alibaba.com>
Date:   Wed, 15 Feb 2023 16:40:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [RFC 0/3] Add io_uring & ebpf based methods to implement
 zero-copy for ublk
Content-Language: en-US
To:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ming.lei@redhat.com, axboe@kernel.dk, asml.silence@gmail.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <20230215004122.28917-1-xiaoguang.wang@linux.alibaba.com>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <20230215004122.28917-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023/2/15 08:41, Xiaoguang Wang wrote:
> Normally, userspace block device impementations need to copy data between
> kernel block layer's io requests and userspace block device's userspace
> daemon, for example, ublk and tcmu both have similar logic, but this
> operation will consume cpu resources obviously, especially for large io.
> 
> There are methods trying to reduce these cpu overheads, then userspace
> block device's io performance will be improved further. These methods
> contain: 1) use special hardware to do memory copy, but seems not all
> architectures have these special hardware; 2) sofeware methods, such as
> mmap kernel block layer's io requests's data to userspace daemon [1],
> but it has page table's map/unmap, tlb flush overhead, security issue,
> etc, and it maybe only friendly to large io.
> 
> Add a new program type BPF_PROG_TYPE_UBLK for ublk, which is a generic
> framework for implementing block device logic from userspace. Typical
> userspace block device impementations need to copy data between kernel
> block layer's io requests and userspace block device's userspace daemon,
> which will consume cpu resources, especially for large io.
> 
> To solve this problem, I'd propose a new method, which will combine the
> respective advantages of io_uring and ebpf. Add a new program type
> BPF_PROG_TYPE_UBLK for ublk, userspace block device daemon process should
> register an ebpf prog. This bpf prog will use bpf helper offered by ublk
> bpf prog type to submit io requests on behalf of daemon process.
> Currently there is only one helper:
>     u64 bpf_ublk_queue_sqe(struct ublk_io_bpf_ctx *bpf_ctx,
> 		struct io_uring_sqe *sqe, u32 sqe_len, u32, fd)
> 
> This helper will use io_uring to submit io requests, so we need to make
> io_uring be able to submit a sqe located in kernel(Some codes idea comes
> from Pavel's patchset [2], but pavel's patch needs sqe->buf still comes
> from userspace addr), and bpf prog initializes sqes, but does not need to
> initializes sqes' buf field, sqe->buf will come from kernel block layer io
> requests in some form. See patch 2 for more.
> 
> In example of ublk loop target, we can easily implement such below logic in
> ebpf prog:
>   1. userspace daemon registers an ebpf prog and passes two backend file
> fd in ebpf map structure。
>   2. For kernel io requests against the first half of userspace device,
> ebpf prog prepares an io_uring sqe, which will submit io against the first
> backend file fd and sqe's buffer comes from kernel io reqeusts. Kernel
> io requests against second half of userspace device has similar logic,
> only sqe's fd will be the second backend file fd.
>   3. When ublk driver blk-mq queue_rq() is called, this ebpf prog will
> be executed and completes kernel io requests.
> 
> That means, by using ebpf, we can implement various userspace log in kernel.
> 
> From above expample, we can see that this method has 3 advantages at least:
>   1. Remove memory copy between kernel block layer and userspace daemon
> completely.
>   2. Save memory. Userspace daemon doesn't need to maintain memory to
> issue and complete io requests, and use kernel block layer io requests
> memory directly.
>   2. We may reduce the number of round trips between kernel and userspace
> daemon, so may reduce kernel & userspace context switch overheads.
> 
> Test:
> Add a ublk loop target: ublk add -t loop -q 1 -d 128 -f loop.file
> 
> fio job file:
>   [global]
>   direct=1
>   filename=/dev/ublkb0
>   time_based
>   runtime=60
>   numjobs=1
>   cpus_allowed=1
>   
>   [rand-read-4k]
>   bs=512K
>   iodepth=16
>   ioengine=libaio
>   rw=randwrite
>   stonewall
> 
> 
> Without this patch:
>   WRITE: bw=745MiB/s (781MB/s), 745MiB/s-745MiB/s (781MB/s-781MB/s), io=43.6GiB (46.8GB), run=60010-60010msec
>   ublk daemon's cpu utilization is about 9.3%~10.0%, showed by top tool.
> 
> With this patch:
>   WRITE: bw=744MiB/s (781MB/s), 744MiB/s-744MiB/s (781MB/s-781MB/s), io=43.6GiB (46.8GB), run=60012-60012msec
>   ublk daemon's cpu utilization is about 1.3%~1.7%, showed by top tool.
> 
> From above tests, this method can reduce cpu copy overhead obviously.
> 
> 
> TODO:
> I must say this patchset is just a RFC for design.
> 
> 1) Currently for this patchset, I just make ublk ebpf prog submit io requests
> using io_uring in kernel, cqe event still needs to be handled in userspace
> daemon. Once later we succeed in make io_uring handle cqe in kernel, ublk
> ebpf prog can implement io in kernel.
> 
> 2) ublk driver needs to work better with ebpf, currently I did some hack
> codes to support ebpf in ublk driver, it only can support write requests.
> 
> 3) I have not done much tests yet, will run liburing/ublk/blktests
> later.
> 
> Any review and suggestions are welcome, thanks.
> 
> [1] https://lore.kernel.org/all/20220318095531.15479-1-xiaoguang.wang@linux.alibaba.com/
> [2] https://lore.kernel.org/all/cover.1621424513.git.asml.silence@gmail.com/
> 
> 
> Xiaoguang Wang (3):
>   bpf: add UBLK program type
>   io_uring: enable io_uring to submit sqes located in kernel
>   ublk_drv: add ebpf support
> 
>  drivers/block/ublk_drv.c       | 228 ++++++++++++++++++++++++++++++++-
>  include/linux/bpf_types.h      |   2 +
>  include/linux/io_uring.h       |  13 ++
>  include/linux/io_uring_types.h |   8 +-
>  include/uapi/linux/bpf.h       |   2 +
>  include/uapi/linux/ublk_cmd.h  |  11 ++
>  io_uring/io_uring.c            |  59 ++++++++-
>  io_uring/rsrc.c                |  15 +++
>  io_uring/rsrc.h                |   3 +
>  io_uring/rw.c                  |   7 +
>  kernel/bpf/syscall.c           |   1 +
>  kernel/bpf/verifier.c          |   9 +-
>  scripts/bpf_doc.py             |   4 +
>  tools/include/uapi/linux/bpf.h |   9 ++
>  tools/lib/bpf/libbpf.c         |   2 +
>  15 files changed, 366 insertions(+), 7 deletions(-)
> 

Hi, Here is perf report output of ublk daemon(loop target):


+   57.96%     4.03%  ublk           liburing.so.2.2                                [.] _io_uring_get_cqe                    ▒
+   53.94%     0.00%  ublk           [kernel.vmlinux]                               [k] entry_SYSCALL_64                     ◆
+   53.94%     0.65%  ublk           [kernel.vmlinux]                               [k] do_syscall_64                        ▒
+   48.37%     1.18%  ublk           [kernel.vmlinux]                               [k] __do_sys_io_uring_enter              ▒
+   42.92%     1.72%  ublk           [kernel.vmlinux]                               [k] io_cqring_wait                       ▒
+   35.17%     0.06%  ublk           [kernel.vmlinux]                               [k] task_work_run                        ▒
+   34.75%     0.53%  ublk           [kernel.vmlinux]                               [k] io_run_task_work_sig                 ▒
+   33.45%     0.00%  ublk           [kernel.vmlinux]                               [k] ublk_bpf_io_submit_fn                ▒
+   33.16%     0.06%  ublk           bpf_prog_3bdc6181a3c616fb_ublk_io_submit_prog  [k] bpf_prog_3bdc6181a3c616fb_ublk_io_sub▒
+   32.68%     0.00%  iou-wrk-18583  [unknown]                                      [k] 0000000000000000                     ▒
+   32.68%     0.00%  iou-wrk-18583  [unknown]                                      [k] 0x00007efe920b1040                   ▒
+   32.68%     0.00%  iou-wrk-18583  [kernel.vmlinux]                               [k] ret_from_fork                        ▒
+   32.68%     0.47%  iou-wrk-18583  [kernel.vmlinux]                               [k] io_wqe_worker                        ▒
+   30.61%     0.00%  ublk           [kernel.vmlinux]                               [k] io_submit_sqe                        ▒
+   30.31%     0.06%  ublk           [kernel.vmlinux]                               [k] io_issue_sqe                         ▒
+   28.00%     0.00%  ublk           [kernel.vmlinux]                               [k] bpf_ublk_queue_sqe                   ▒
+   28.00%     0.00%  ublk           [kernel.vmlinux]                               [k] io_uring_submit_sqe                  ▒
+   27.18%     0.00%  ublk           [kernel.vmlinux]                               [k] io_write                             ▒
+   27.18%     0.00%  ublk           [xfs]                                          [k] xfs_file_write_iter

The call stack is:

-   57.96%     4.03%  ublk           liburing.so.2.2                                [.] _io_uring_get_cqe                    ◆
   - 53.94% _io_uring_get_cqe                                                                                                ▒
        entry_SYSCALL_64                                                                                                     ▒
      - do_syscall_64                                                                                                        ▒
         - 48.37% __do_sys_io_uring_enter                                                                                    ▒
            - 42.92% io_cqring_wait                                                                                          ▒
               - 34.75% io_run_task_work_sig                                                                                 ▒
                  - task_work_run                                                                                            ▒
                     - 32.50% ublk_bpf_io_submit_fn                                                                          ▒
                        - 32.21% bpf_prog_3bdc6181a3c616fb_ublk_io_submit_prog                                               ▒
                           - 27.12% bpf_ublk_queue_sqe                                                                       ▒
                              - io_uring_submit_sqe                                                                          ▒
                                 - 26.64% io_submit_sqe                                                                      ▒
                                    - 26.35% io_issue_sqe                                                                    ▒
                                       - io_write                                                                            ▒
                                         xfs_file_write_iter                                                                 ▒

Here, "io_submit" ebpf prog will be run in task_work of ublk daemon
process after io_uring_enter() syscall. In this ebpf prog, a sqe is
built and submitted. All information about this blk-mq request is
stored in a "ctx". Then io_uring can write to the backing file
(xfs_file_write_iter).

Here is call stack from perf report output of fio:

-    5.04%     0.18%  fio      [kernel.vmlinux]                             [k] ublk_queue_rq                                ▒
   - 4.86% ublk_queue_rq                                                                                                     ▒
      - 3.67% bpf_prog_b8456549dbe40c37_ublk_io_prep_prog                                                                    ▒
         - 3.10% bpf_trace_printk                                                                                            ▒
              2.83% _raw_spin_unlock_irqrestore                                                                              ▒
      - 0.70% task_work_add                                                                                                  ▒
         - try_to_wake_up                                                                                                    ▒
              _raw_spin_unlock_irqrestore                                                                                    ▒

Here, "io_prep" ebpf prog will be run in "ublk_queue_rq" process.
In this ebpf prog, qid, tag, nr_sectors, start_sector, op, flags
will be stored in one "ctx". Then we add a task_work to the ublk
daemon process.

Regards,
Zhang
