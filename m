Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6CFB5704F0
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 16:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiGKOEM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 10:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiGKOEK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 10:04:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89B531114C
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 07:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657548247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0kHWPQZp9knFWLD/qUktooZu2wR6f73ql2X6yW+je6k=;
        b=S6mj0K1/5gJCsGEnC0ycpgFLQgMGVFjcsw8V5q5bMGyubBMB1lbgekmX/OjIreJPPF/WwS
        C/LIRyRHZ5UVvrUqdzpuUdIKpPc159AODEqmKXbl8t5aymaFcihCTlCFSZRxBl6LXZTaxY
        F+tAiDKBeEzcSZonbIyj+p9jHJ5clDA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494-lDVieBmkO3yMCSVNTgBf1w-1; Mon, 11 Jul 2022 10:03:58 -0400
X-MC-Unique: lDVieBmkO3yMCSVNTgBf1w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04C50801755;
        Mon, 11 Jul 2022 14:03:58 +0000 (UTC)
Received: from T590 (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 078381121314;
        Mon, 11 Jul 2022 14:03:51 +0000 (UTC)
Date:   Mon, 11 Jul 2022 22:03:46 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>, ming.lei@redhat.com
Subject: Re: [PATCH V4 0/2] ublk: add io_uring based userspace block driver
Message-ID: <YswtwnJuWG+55NM1@T590>
References: <20220711022024.217163-1-ming.lei@redhat.com>
 <c8e593e6-105f-7a69-857f-5b91ecd3b801@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c8e593e6-105f-7a69-857f-5b91ecd3b801@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Xiaoguang,

On Mon, Jul 11, 2022 at 07:32:19PM +0800, Xiaoguang Wang wrote:
> Hello Ming,
> 
> First thanks for this great work, I think ublk will be a powerful
> replacement for tcmu. I read your v3 ublk kernel and user-space
> codes, and have some ublk design questions here:
> 
> 1) As I said before, currently ublk still needs user-space backstore
> to allocate io buffer in advance, for example, UBLK_IO_FETCH_REQ
> command needs to set ublk_io->addr when starting device. Currently,
> some of our internal business may create hundreds or thousands of
> tcmu devices in one host, when switching to ublk, it'll need user-space
> backstore to allocate lots of memory in advance, which will waste memory
> in a host with swap off. Also user-space backstore may use advanced
> network components, they may maintain internal memory pool, which
> can be used as io buffer.
> 
> So I'd like to suggest that at least we add a new flag and keep GET_DATA
> command. When used, FETCH command does not need to pass io
> buffer addr, and backstore needs to send a GET_DATA command with
> user addr for write request.
> 
> Support high flexibility, let's user decides what's best for them.

Please take a look at v4 patches or cover letter at least before asking
this question.

V4 adds one new command of REFETCH for supporting to build ublk driver
as module, you can allocate buffer when receiving REFETCH command
in userspace target code by adding one pair of callbacks.

Also the latest ublkserver adds callback for target code to pre-allocate
buffer, then if you have pre-allocated io buffer, the buffer can be passed
to driver via FETCH command during setting up queue.

Actually I have implemented pinning page during the whole io lifetime,
then the pre-allocated io buffers can be reclaimed without needing
swapout by kernel when io is completed:

https://github.com/ming1/linux/commits/ubd-master

So the preallocation is just allocation on virtual memory space, and
the pages are pinned actually when io is handled. After io handling is
done, kernel can reclaim pages at will without needing swapout on
these io pages.

> 
> 2) complicated ublk user-space
> First forgive me :) I think current ublk user-space codes looks somewhat
> complicated:

Please just look at libublksrv code, and example of demo_null.c &
demo_event.c.

Zixiang mentioned that it basically did almost everything what you
requested before:

https://lore.kernel.org/linux-block/532eb193-06cf-96a3-684f-cc7e16db5ddf@linux.alibaba.com/

Maybe you two need to talk a bit.

>   1. UBLK_CMD_START_DEV and io handler worker need to be
> in different task context, because UBLK_CMD_START_DEV needs
> to wait the number of queue depth of sqes to be submitted in advance.

Of course we have to wait until all IO commands are issued to driver,
since block IO can come to /dev/ublkbN after UBLK_CMD_START_DEV returns,
and /dev/ublkbN is exposed to userspace in running UBLK_CMD_START_DEV.

What is the matter of this kind of handling?

Also with libublksrv, you can do everything just in single task context,
see:

https://github.com/ming1/ubdsrv/blob/master/demo_null.c

> 
>   2. mixed getting ublk command and target io handle in one io_uring instance
> I'm not sure it's a good design, see ublksrv_handle_cqe(), which contains

io_uring is supposed to be bound with context, and serves all IOs
issued from this context. That is exactly typical AIO use pattern,
please look at example of t/io_uring.c in fio project, which can accept
lots of files in command line, then handle IOs to all these files in one
single io_uring context. Here /dev/ublkcN is just one file, we handle
IOs to other files and /dev/ublkcN in single io_uring/context, then
all of them can be handled at batching, then each single syscall can
handle more IOs, that is one important reason why io_uring performs so well.

> many flag handle work and is_target_io() check, I think the data flow is not
> that clear for me at least :)

/* 
 * this flag is set if we need to tell ublk driver to fetch io req only,
 * just needed in setup stage.  
 */
#define UBLKSRV_NEED_FETCH_RQ		(1UL << 0)

/* when one io is handled, we set this flag for committing io result */
#define UBLKSRV_NEED_COMMIT_RQ_COMP	(1UL << 1)

/*
 * this flag is set in case the command slot is free to issue new command;
 * cleared when io command is issued to driver.
 */
#define UBLKSRV_IO_FREE			(1UL << 2)

/*
 * added in v4, set in case UBLK_IO_RES_REFETCH is returned from driver,
 * so REFETCH command is issued to driver
 */
#define UBLKSRV_NEED_REFETCH_RQ		(1UL << 3)

Note, the flags are just for handling io commands.

> 
>   3. helper like tcmulib_get_next_command()
> I wonder whether current ublk user-space can offer similar helper which
> will return a set of io commands to backstore easily.

No, io command is supposed to use by libublksrv internal use, and target
code should _not_ deal with any io command.

The target code should just focus on implementing ->handle_io_async() in
which one new io command is received from driver, same with
->target_io_done() which is called when one target io is completed by
io_uring.

If target code doesn't use io_uring to handle io, please refer to
example of demo_event.c, in which ->handle_event() is required for
supporting to handle io in another contexts by either io_uring or libaio
or whatever. ->handle_event() is called when io_uring(for issuing io
command) is waken up by eventfd, which is triggered by target code
itself(two eventfd APIs).

> 
> I'd like to suggest:
> 1. When starting ublk dev, pass io_uring fd for every queue, then in
> blk-mq->queue_rq(), it'll generate one cqe for every coming request,
> not need to issue fetch sqes command in advance, kernel codes would

Why do you think it isn't good to issue fetch sqes in advance? It costs
nothing, meantime userspace can get io request pretty fast.

Actually you are suggesting one fundamental change to io_uring given
the current io_uring use model is that userspace issues io via sqe, and
kernel(io_uring) completes io via cqe, and sqe and cqe are in two rings
actually.

That current io_uring doesn't support to complete cqe to userspace without
issuing any sqe, also not see any benefit we can get in this way. If you
have, please explain it in details.


> simplify a bit,  UBLK_IO_FLAG_ACTIVE may be discarded. And helper
> like returning a set of io command would be added easily. Note these
> io_uring fd would be just used for notifying io command generated.
> 
> 2. We use another io_uring fd per queue to handle GET_DATA or
> COMMIT_REQ command. Indeed, if we can support synchronous ioctl
> interface to do GET_DATA and COMMIT_REQ, we may make libublk
> really simple.

IMO that won't be good idea. One important reason why io_uring is so
efficient is that batching issue/completion in single syscall. And using
ioctl to handle io can be too slow.

> 
> 
> Here I'd like to describe how we use tcmu. A main thread call
> tcmulib_get_next_command() to get a set of io commands, then
> it dispatches them to user-space io wokers. Take write requests as
> example, io worker use ioctl(2) to get data from bios, and send
> data to distributed fs, finally call ioctl(2) to commit req. Multiple

Hammm, not mentioning pthread communication, it takes at least 3 syscalls
for handling one io, how can you expect this way to work efficiently?

With ublk, usually we handle dozens or even more than hundred of IOs in
single io_uring_enter() syscall.

> io workers can run concurrently. Since GET_DATA(write request)
> or COMMIT_REQ(read request) mainly do memcpy work, one
> io_uring instance will just do these jobs sequentially, which may
> not take advantage of multi-cpu.

IMO you can implement target code to handle io in other pthreads against
current libublksrv design, see demo_event.c. Or if you think it is still
enough, please just share with us what the problem is. Without
understanding the problem, I won't try to figure out any solution or
change.

Again, the goal of ublk aims at implementing high performance & generic
userspace user space block driver.



Thanks,
Ming

