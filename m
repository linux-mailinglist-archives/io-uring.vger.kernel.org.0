Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B944571888
	for <lists+io-uring@lfdr.de>; Tue, 12 Jul 2022 13:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiGLLan (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jul 2022 07:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiGLLam (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jul 2022 07:30:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E2211DA43
        for <io-uring@vger.kernel.org>; Tue, 12 Jul 2022 04:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657625439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yTb43hbxavY31b5rWO2RqROeeTIGc8C9HU+MpiDBwnc=;
        b=A7brWyLKx+/0MltfzlIW8w0HCizZWGxigkI5zMGdq/JgCI1j6gj7d6wxbCy8T5nG7AEJ6E
        aoeGAOErCgy/PoQmHMP5cZwAlfNV3IdKHrJLYHL0Nv7JJo3OOcuYv74eNvugFOlVoDhxE9
        zHFZFjJdvSAk0YLZTrAn6rxRbKzfqsE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-YzaXNybjOqeD6TlFvR6NHw-1; Tue, 12 Jul 2022 07:30:36 -0400
X-MC-Unique: YzaXNybjOqeD6TlFvR6NHw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 189B485A586;
        Tue, 12 Jul 2022 11:30:36 +0000 (UTC)
Received: from T590 (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 01B81492C3B;
        Tue, 12 Jul 2022 11:30:28 +0000 (UTC)
Date:   Tue, 12 Jul 2022 19:30:22 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>, ming.lei@redhat.com
Subject: Re: [PATCH V4 0/2] ublk: add io_uring based userspace block driver
Message-ID: <Ys1bTrVd+L5zYODg@T590>
References: <20220711022024.217163-1-ming.lei@redhat.com>
 <c8e593e6-105f-7a69-857f-5b91ecd3b801@linux.alibaba.com>
 <YswtwnJuWG+55NM1@T590>
 <0697cae5-f366-6f69-be39-96f060d8c586@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0697cae5-f366-6f69-be39-96f060d8c586@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 12, 2022 at 04:44:03PM +0800, Xiaoguang Wang wrote:
> Hello Ming,
> 
> > Hi Xiaoguang,
> >
> > On Mon, Jul 11, 2022 at 07:32:19PM +0800, Xiaoguang Wang wrote:
> > Please take a look at v4 patches or cover letter at least before asking
> > this question.
> Yeah, I should be, really sorry.
> >
> > V4 adds one new command of REFETCH for supporting to build ublk driver
> > as module, you can allocate buffer when receiving REFETCH command
> > in userspace target code by adding one pair of callbacks.
> >
> > Also the latest ublkserver adds callback for target code to pre-allocate
> > buffer, then if you have pre-allocated io buffer, the buffer can be passed
> > to driver via FETCH command during setting up queue.
> Now my concern about io buffer management has gone, thanks.
> 
> >
> > Actually I have implemented pinning page during the whole io lifetime,
> > then the pre-allocated io buffers can be reclaimed without needing
> > swapout by kernel when io is completed:
> >
> > https://github.com/ming1/linux/commits/ubd-master
> >
> > So the preallocation is just allocation on virtual memory space, and
> > the pages are pinned actually when io is handled. After io handling is
> > done, kernel can reclaim pages at will without needing swapout on
> > these io pages.
> OK, I'll learn codes later.
> 
> >
> >> 2) complicated ublk user-space
> >> First forgive me :) I think current ublk user-space codes looks somewhat
> >> complicated:
> > Please just look at libublksrv code, and example of demo_null.c &
> > demo_event.c.
> OK.
> 
> >
> >
> > Of course we have to wait until all IO commands are issued to driver,
> > since block IO can come to /dev/ublkbN after UBLK_CMD_START_DEV returns,
> > and /dev/ublkbN is exposed to userspace in running UBLK_CMD_START_DEV.
> >
> > What is the matter of this kind of handling?
> >
> > Also with libublksrv, you can do everything just in single task context,
> > see:
> >
> > https://github.com/ming1/ubdsrv/blob/master/demo_null.c
> No, indeed I don't mean that there are something wrong with your
> implementation. I just try to see whether I can simplify it a bit.
> 
> If we adopt to pass one io_uring fd per queue when starting device,
> blk-mq's queue_rq() will get corresponding io_uring file for this queue and
> use it to generate cqes directly to notify new io commands inserted,
> then UBLK_CMD_START_DEV doesn't need to wait, and can be in the
> same thread with ublksrv_queue_init or ublksrv_process_io.
> Seems that for demo_null.c, they are still in different threads.
> 
> For current io_uring implementation, one sqe may generate one or more
> cqes, but indeed, we can generate cqes without submitting sqes, just
> fill one event to io_uring ctx.
> Just suggestions :)

I don't have any interest in so unusual usage of io_uring, especially it
needs fundamental change in io_uring.

Compared with kernel side change, removing waiting until queue setup in
userspace side simplifies nothing.

> >
> >>   2. mixed getting ublk command and target io handle in one io_uring instance
> >> I'm not sure it's a good design, see ublksrv_handle_cqe(), which contains
> > io_uring is supposed to be bound with context, and serves all IOs
> > issued from this context. That is exactly typical AIO use pattern,
> > please look at example of t/io_uring.c in fio project, which can accept
> > lots of files in command line, then handle IOs to all these files in one
> > single io_uring context. Here /dev/ublkcN is just one file, we handle
> > IOs to other files and /dev/ublkcN in single io_uring/context, then
> > all of them can be handled at batching, then each single syscall can
> > handle more IOs, that is one important reason why io_uring performs so well.
> Yeah, I understand that you're doing your best to improve ublk performance,
> and I'm a early developer of io_uring and know how it works :)
> 
> It maybe just because of my poor design poor taste, I think put
> io command descriptors acquire and io command handling together
> seem not decouple well.
> >
> >> many flag handle work and is_target_io() check, I think the data flow is not
> >> that clear for me at least :)
> > /* 
> >  * this flag is set if we need to tell ublk driver to fetch io req only,
> >  * just needed in setup stage.  
> >  */
> > #define UBLKSRV_NEED_FETCH_RQ		(1UL << 0)
> >
> > /* when one io is handled, we set this flag for committing io result */
> > #define UBLKSRV_NEED_COMMIT_RQ_COMP	(1UL << 1)
> >
> > /*
> >  * this flag is set in case the command slot is free to issue new command;
> >  * cleared when io command is issued to driver.
> >  */
> > #define UBLKSRV_IO_FREE			(1UL << 2)
> >
> > /*
> >  * added in v4, set in case UBLK_IO_RES_REFETCH is returned from driver,
> >  * so REFETCH command is issued to driver
> >  */
> > #define UBLKSRV_NEED_REFETCH_RQ		(1UL << 3)
> >
> > Note, the flags are just for handling io commands.
> >
> >>   3. helper like tcmulib_get_next_command()
> >> I wonder whether current ublk user-space can offer similar helper which
> >> will return a set of io commands to backstore easily.
> > No, io command is supposed to use by libublksrv internal use, and target
> > code should _not_ deal with any io command.
> Seems different from design ideas of tcmu.
> 
> >
> > The target code should just focus on implementing ->handle_io_async() in
> > which one new io command is received from driver, same with
> > ->target_io_done() which is called when one target io is completed by
> > io_uring.
> >
> > If target code doesn't use io_uring to handle io, please refer to
> > example of demo_event.c, in which ->handle_event() is required for
> > supporting to handle io in another contexts by either io_uring or libaio
> > or whatever. ->handle_event() is called when io_uring(for issuing io
> > command) is waken up by eventfd, which is triggered by target code
> > itself(two eventfd APIs).
> OK.
> 
> >
> >> I'd like to suggest:
> >> 1. When starting ublk dev, pass io_uring fd for every queue, then in
> >> blk-mq->queue_rq(), it'll generate one cqe for every coming request,
> >> not need to issue fetch sqes command in advance, kernel codes would
> > Why do you think it isn't good to issue fetch sqes in advance? It costs
> > nothing, meantime userspace can get io request pretty fast.
> >
> > Actually you are suggesting one fundamental change to io_uring given
> > the current io_uring use model is that userspace issues io via sqe, and
> > kernel(io_uring) completes io via cqe, and sqe and cqe are in two rings
> > actually.
> >
> > That current io_uring doesn't support to complete cqe to userspace without
> > issuing any sqe, also not see any benefit we can get in this way. If you
> > have, please explain it in details.
> Hard to say it's one fundamental change, io_uring can easily add such
> a helper which generates cqes but needs not to submit sqes, which contains
>   allocate one cqe, with user_data, res
>   io_commit_cqring(ctx);

You still need io_kiocb/io_uring_cmd and both are allocated in
submission code path, since 'io_ring_ctx' is private for
io_uring.

And ublk server still needs one command to send io result to ublk driver,
that said this way saves nothing for us cause ublk driver uses single
command for both fetching io request and committing io result.

Easy to say than done, you may try to write a patch to verify your
ideas, especially no one uses io_ring in this way.

> 
> As I said before, there maybe such benefits:
> 1. may decouple io command descriptor acquire and io command handling well.
> At least helper like tcmulib_get_next_command maybe added easily. I'm not sure, some
> applications based on tcmu previously may need this helper.

Why do we need similar helper of tcmulib_get_next_command()? for what
purpose? In current design of ublk server, it should be enough for target
code to focus on ->handle_io_async(), ->target_io_done() in case of handling
target io via ubq io_uring, ->handle_event() in case of handling target io in
other contexts.

ublk server is one io_uring application, and interfaces provided
are based on io_uring design/interfaces. I guess TCMU isn't based on
io_uring, so it may have original style interface. You may ask
TCMU guys if it is possible to reuse current interface for supporting
io_uring with expected performance.

> 
> 2. UBLK_CMD_START_DEV won't need to wait another thread context to submit
> number of queue depth of sqes firstly, but I admit that it's not a big issue.

Yeah, it simplifies nothing, compared with fundamental io_uring change
and ublk driver side change.

> 
> >
> >
> >> simplify a bit,  UBLK_IO_FLAG_ACTIVE may be discarded. And helper
> >> like returning a set of io command would be added easily. Note these
> >> io_uring fd would be just used for notifying io command generated.
> >>
> >> 2. We use another io_uring fd per queue to handle GET_DATA or
> >> COMMIT_REQ command. Indeed, if we can support synchronous ioctl
> >> interface to do GET_DATA and COMMIT_REQ, we may make libublk
> >> really simple.
> > IMO that won't be good idea. One important reason why io_uring is so
> > efficient is that batching issue/completion in single syscall. And using
> > ioctl to handle io can be too slow.
> >
> >>
> >> Here I'd like to describe how we use tcmu. A main thread call
> >> tcmulib_get_next_command() to get a set of io commands, then
> >> it dispatches them to user-space io wokers. Take write requests as
> >> example, io worker use ioctl(2) to get data from bios, and send
> >> data to distributed fs, finally call ioctl(2) to commit req. Multiple
> > Hammm, not mentioning pthread communication, it takes at least 3 syscalls
> > for handling one io, how can you expect this way to work efficiently?
> I admit batch will be good, and syscalls userspace and kernel context switch
> introduce overhead. But for big io requests, batch in one context is not good. In
> the example of read requests, if io request is big, say 1MB, io_uring will do
> commit req sequentially, which indeed mainly do memcpy work. But if users
> can choose to issue multiple ioctls which do commit req concurrently, I think
> user may get higher io throughput.

If BS is big, single job could saturate devices bw easily, multiple jobs won't
make a difference, will it? Not mention sync cost among multiple jobs.

Not mention current ublk server does support multiple io jobs.

> 
> And in this case, user may not care userspace and kernel context switch overhead at all.
> 
> Or to put it another way, should libublk offer synchronous programming interface ?

It depends what the sync interface is.

You can call sync read()/write() for target io directly in ->handdle_io_async(),
or call them in other pthread(s) just by telling ubq after these sync ios are done
with the eventfd API.

demo_null.c is actually one such example.

> 
> >
> > With ublk, usually we handle dozens or even more than hundred of IOs in
> > single io_uring_enter() syscall.
> >
> >> io workers can run concurrently. Since GET_DATA(write request)
> >> or COMMIT_REQ(read request) mainly do memcpy work, one
> >> io_uring instance will just do these jobs sequentially, which may
> >> not take advantage of multi-cpu.
> > IMO you can implement target code to handle io in other pthreads against
> > current libublksrv design, see demo_event.c. Or if you think it is still
> > enough, please just share with us what the problem is. Without
> > understanding the problem, I won't try to figure out any solution or
> > change.
> I need to read your ublk userspace codes carefully, if I made

One small suggestion, you may start with the two builtin examples, both
are simple & clean, and the big one is only 300+ LOC, really complicated?


Thanks.
Ming

