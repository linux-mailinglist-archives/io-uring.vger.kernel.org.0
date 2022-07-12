Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57DB95714F0
	for <lists+io-uring@lfdr.de>; Tue, 12 Jul 2022 10:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbiGLIof (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jul 2022 04:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbiGLIoK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jul 2022 04:44:10 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EEEA43BE;
        Tue, 12 Jul 2022 01:44:07 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VJ7X6Pa_1657615443;
Received: from 30.227.94.73(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VJ7X6Pa_1657615443)
          by smtp.aliyun-inc.com;
          Tue, 12 Jul 2022 16:44:04 +0800
Message-ID: <0697cae5-f366-6f69-be39-96f060d8c586@linux.alibaba.com>
Date:   Tue, 12 Jul 2022 16:44:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH V4 0/2] ublk: add io_uring based userspace block driver
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>
References: <20220711022024.217163-1-ming.lei@redhat.com>
 <c8e593e6-105f-7a69-857f-5b91ecd3b801@linux.alibaba.com>
 <YswtwnJuWG+55NM1@T590>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <YswtwnJuWG+55NM1@T590>
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

> Hi Xiaoguang,
>
> On Mon, Jul 11, 2022 at 07:32:19PM +0800, Xiaoguang Wang wrote:
> Please take a look at v4 patches or cover letter at least before asking
> this question.
Yeah, I should be, really sorry.
>
> V4 adds one new command of REFETCH for supporting to build ublk driver
> as module, you can allocate buffer when receiving REFETCH command
> in userspace target code by adding one pair of callbacks.
>
> Also the latest ublkserver adds callback for target code to pre-allocate
> buffer, then if you have pre-allocated io buffer, the buffer can be passed
> to driver via FETCH command during setting up queue.
Now my concern about io buffer management has gone, thanks.

>
> Actually I have implemented pinning page during the whole io lifetime,
> then the pre-allocated io buffers can be reclaimed without needing
> swapout by kernel when io is completed:
>
> https://github.com/ming1/linux/commits/ubd-master
>
> So the preallocation is just allocation on virtual memory space, and
> the pages are pinned actually when io is handled. After io handling is
> done, kernel can reclaim pages at will without needing swapout on
> these io pages.
OK, I'll learn codes later.

>
>> 2) complicated ublk user-space
>> First forgive me :) I think current ublk user-space codes looks somewhat
>> complicated:
> Please just look at libublksrv code, and example of demo_null.c &
> demo_event.c.
OK.

>
>
> Of course we have to wait until all IO commands are issued to driver,
> since block IO can come to /dev/ublkbN after UBLK_CMD_START_DEV returns,
> and /dev/ublkbN is exposed to userspace in running UBLK_CMD_START_DEV.
>
> What is the matter of this kind of handling?
>
> Also with libublksrv, you can do everything just in single task context,
> see:
>
> https://github.com/ming1/ubdsrv/blob/master/demo_null.c
No, indeed I don't mean that there are something wrong with your
implementation. I just try to see whether I can simplify it a bit.

If we adopt to pass one io_uring fd per queue when starting device,
blk-mq's queue_rq() will get corresponding io_uring file for this queue and
use it to generate cqes directly to notify new io commands inserted,
then UBLK_CMD_START_DEV doesn't need to wait, and can be in the
same thread with ublksrv_queue_init or ublksrv_process_io.
Seems that for demo_null.c, they are still in different threads.

For current io_uring implementation, one sqe may generate one or more
cqes, but indeed, we can generate cqes without submitting sqes, just
fill one event to io_uring ctx.

Just suggestions :)
>
>>   2. mixed getting ublk command and target io handle in one io_uring instance
>> I'm not sure it's a good design, see ublksrv_handle_cqe(), which contains
> io_uring is supposed to be bound with context, and serves all IOs
> issued from this context. That is exactly typical AIO use pattern,
> please look at example of t/io_uring.c in fio project, which can accept
> lots of files in command line, then handle IOs to all these files in one
> single io_uring context. Here /dev/ublkcN is just one file, we handle
> IOs to other files and /dev/ublkcN in single io_uring/context, then
> all of them can be handled at batching, then each single syscall can
> handle more IOs, that is one important reason why io_uring performs so well.
Yeah, I understand that you're doing your best to improve ublk performance,
and I'm a early developer of io_uring and know how it works :)

It maybe just because of my poor design poor taste, I think put
io command descriptors acquire and io command handling together
seem not decouple well.
>
>> many flag handle work and is_target_io() check, I think the data flow is not
>> that clear for me at least :)
> /* 
>  * this flag is set if we need to tell ublk driver to fetch io req only,
>  * just needed in setup stage.  
>  */
> #define UBLKSRV_NEED_FETCH_RQ		(1UL << 0)
>
> /* when one io is handled, we set this flag for committing io result */
> #define UBLKSRV_NEED_COMMIT_RQ_COMP	(1UL << 1)
>
> /*
>  * this flag is set in case the command slot is free to issue new command;
>  * cleared when io command is issued to driver.
>  */
> #define UBLKSRV_IO_FREE			(1UL << 2)
>
> /*
>  * added in v4, set in case UBLK_IO_RES_REFETCH is returned from driver,
>  * so REFETCH command is issued to driver
>  */
> #define UBLKSRV_NEED_REFETCH_RQ		(1UL << 3)
>
> Note, the flags are just for handling io commands.
>
>>   3. helper like tcmulib_get_next_command()
>> I wonder whether current ublk user-space can offer similar helper which
>> will return a set of io commands to backstore easily.
> No, io command is supposed to use by libublksrv internal use, and target
> code should _not_ deal with any io command.
Seems different from design ideas of tcmu.

>
> The target code should just focus on implementing ->handle_io_async() in
> which one new io command is received from driver, same with
> ->target_io_done() which is called when one target io is completed by
> io_uring.
>
> If target code doesn't use io_uring to handle io, please refer to
> example of demo_event.c, in which ->handle_event() is required for
> supporting to handle io in another contexts by either io_uring or libaio
> or whatever. ->handle_event() is called when io_uring(for issuing io
> command) is waken up by eventfd, which is triggered by target code
> itself(two eventfd APIs).
OK.

>
>> I'd like to suggest:
>> 1. When starting ublk dev, pass io_uring fd for every queue, then in
>> blk-mq->queue_rq(), it'll generate one cqe for every coming request,
>> not need to issue fetch sqes command in advance, kernel codes would
> Why do you think it isn't good to issue fetch sqes in advance? It costs
> nothing, meantime userspace can get io request pretty fast.
>
> Actually you are suggesting one fundamental change to io_uring given
> the current io_uring use model is that userspace issues io via sqe, and
> kernel(io_uring) completes io via cqe, and sqe and cqe are in two rings
> actually.
>
> That current io_uring doesn't support to complete cqe to userspace without
> issuing any sqe, also not see any benefit we can get in this way. If you
> have, please explain it in details.
Hard to say it's one fundamental change, io_uring can easily add such
a helper which generates cqes but needs not to submit sqes, which contains
  allocate one cqe, with user_data, res
  io_commit_cqring(ctx);

As I said before, there maybe such benefits:
1. may decouple io command descriptor acquire and io command handling well.
At least helper like tcmulib_get_next_command maybe added easily. I'm not sure, some
applications based on tcmu previously may need this helper.

2. UBLK_CMD_START_DEV won't need to wait another thread context to submit
number of queue depth of sqes firstly, but I admit that it's not a big issue.

>
>
>> simplify a bit,  UBLK_IO_FLAG_ACTIVE may be discarded. And helper
>> like returning a set of io command would be added easily. Note these
>> io_uring fd would be just used for notifying io command generated.
>>
>> 2. We use another io_uring fd per queue to handle GET_DATA or
>> COMMIT_REQ command. Indeed, if we can support synchronous ioctl
>> interface to do GET_DATA and COMMIT_REQ, we may make libublk
>> really simple.
> IMO that won't be good idea. One important reason why io_uring is so
> efficient is that batching issue/completion in single syscall. And using
> ioctl to handle io can be too slow.
>
>>
>> Here I'd like to describe how we use tcmu. A main thread call
>> tcmulib_get_next_command() to get a set of io commands, then
>> it dispatches them to user-space io wokers. Take write requests as
>> example, io worker use ioctl(2) to get data from bios, and send
>> data to distributed fs, finally call ioctl(2) to commit req. Multiple
> Hammm, not mentioning pthread communication, it takes at least 3 syscalls
> for handling one io, how can you expect this way to work efficiently?
I admit batch will be good, and syscalls userspace and kernel context switch
introduce overhead. But for big io requests, batch in one context is not good. In
the example of read requests, if io request is big, say 1MB, io_uring will do
commit req sequentially, which indeed mainly do memcpy work. But if users
can choose to issue multiple ioctls which do commit req concurrently, I think
user may get higher io throughput.

And in this case, user may not care userspace and kernel context switch overhead at all.

Or to put it another way, should libublk offer synchronous programming interface ?

>
> With ublk, usually we handle dozens or even more than hundred of IOs in
> single io_uring_enter() syscall.
>
>> io workers can run concurrently. Since GET_DATA(write request)
>> or COMMIT_REQ(read request) mainly do memcpy work, one
>> io_uring instance will just do these jobs sequentially, which may
>> not take advantage of multi-cpu.
> IMO you can implement target code to handle io in other pthreads against
> current libublksrv design, see demo_event.c. Or if you think it is still
> enough, please just share with us what the problem is. Without
> understanding the problem, I won't try to figure out any solution or
> change.
I need to read your ublk userspace codes carefully, if I made
some noises, sorry.
>
> Again, the goal of ublk aims at implementing high performance & generic
> userspace user space block driver.
Yeah, sure, thanks for this work again.

Regards,
Xiaoguang Wang
>
>
>
> Thanks,
> Ming

