Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D1655FEB3
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 13:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbiF2Ldh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 07:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbiF2Ldg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 07:33:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 177F9B7E3
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 04:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656502414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ilJBK/v3zjRoqAnD05Wvaeb5ckpIlMQHR8Gc7dLQw7U=;
        b=D1fs3WVKMEuPHrZrToLABv/Ga2cGfQkHsJY2mQaxtgXUSCIRDKrBD6OQRDltuOl5m5WGnH
        Aqf4ZcyqJhT/xKiENOyBuwhy506yyS25I4nF0oVCHz7WJGcyDOsWnOi2ghLfswBUZzDGLx
        HT+NarD3aVjI1z2ry55Of/myjn+BV6s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-hJYGwb4LNL-wP5nfKiPDLQ-1; Wed, 29 Jun 2022 07:33:33 -0400
X-MC-Unique: hJYGwb4LNL-wP5nfKiPDLQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BB19811E76;
        Wed, 29 Jun 2022 11:33:32 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1442D1415108;
        Wed, 29 Jun 2022 11:33:26 +0000 (UTC)
Date:   Wed, 29 Jun 2022 19:33:20 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        joseph.qi@linux.alibaba.com, ming.lei@redhat.com
Subject: Re: [RFC] libubd: library for ubd(userspace block driver based on
 io_uring passthrough)
Message-ID: <Yrw4gJq+NaX+TCDz@T590>
References: <fd926012-6845-05e4-077b-6c8cfbf3d3cc@linux.alibaba.com>
 <YrnMwgW7TemVdbXv@T590>
 <fada5140-077e-6904-f9b6-c7bfba7779eb@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fada5140-077e-6904-f9b6-c7bfba7779eb@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 29, 2022 at 11:22:23AM +0800, Ziyang Zhang wrote:
> Hi Ming,
> 
> On 2022/6/27 23:29, Ming Lei wrote:
> > Hi Ziyang,
> > 
> > On Mon, Jun 27, 2022 at 04:20:55PM +0800, Ziyang Zhang wrote:
> >> Hi Ming,
> >>
> >> We are learning your ubd code and developing a library: libubd for ubd.
> >> This article explains why we need libubd and how we design it.
> >>
> >> Related threads:
> >> (1) https://lore.kernel.org/all/Yk%2Fn7UtGK1vVGFX0@T590/
> >> (2) https://lore.kernel.org/all/YnDhorlKgOKiWkiz@T590/
> >> (3) https://lore.kernel.org/all/20220509092312.254354-1-ming.lei@redhat.com/
> >> (4) https://lore.kernel.org/all/20220517055358.3164431-1-ming.lei@redhat.com/
> >>
> >>
> >> Userspace block driver(ubd)[1], based on io_uring passthrough,
> >> allows users to define their own backend storage in userspace
> >> and provides block devices such as /dev/ubdbX.
> >> Ming Lei has provided kernel driver code: ubd_drv.c[2]
> >> and userspace code: ubdsrv[3].
> >>
> >> ubd_drv.c simply passes all blk-mq IO requests
> >> to ubdsrv through io_uring sqes/cqes. We think the kernel code
> >> is pretty well-designed.
> >>
> >> ubdsrv is implemented by a single daemon
> >> and target(backend) IO handling(null_tgt and loop_tgt) 
> >> is embedded in the daemon. 
> >> While trying ubdsrv, we find ubdsrv is hard to be used 
> >> by our backend.
> > 
> > ubd is supposed to provide one generic framework for user space block
> > driver, and it can be used for doing lots of fun/useful thing.
> > 
> > If I understand correctly, this isn't same with your use case:
> > 
> > 1) your user space block driver isn't generic, and should be dedicated
> > for Alibaba's uses
> > 
> > 2) your case has been there for long time, and you want to switch from other
> > approach(maybe tcmu) to ubd given ubd has better performance.
> > 
> 
> Yes, you are correct :)
> The idea of design libubd is actually from libtcmu.
> 
> We do have some userspace storage system as the IO handling backend, 
> and we need ubd to provide block drivers such as /dev/ubdbX for up layer client apps.
> 
> 
> I think your motivation is that provides a complete user block driver to users
> and they DO NOT change any code.
> Users DO change their code using libubd for embedding libubd into the backend.
> 
> 
> >> First is description of our backend:
> >>
> >> (1) a distributing system sends/receives IO requests 
> >>     through network.
> >>
> >> (2) The system use RPC calls among hundreds of
> >>      storage servers and RPC calls are associated with data buffers
> >>      allocated from a memory pool.
> >>
> >> (3) On each server for each device(/dev/vdX), our backend runs
> >>      many threads to handle IO requests and manage the device. 
> >>
> >> Second are reasons why ubdsrv is hard to use for us:
> >>
> >> (1) ubdsrv requires the target(backend) issues IO requests
> >>     to the io_uring provided by ubdsrv but our backend 
> >>     uses something like RPC and does not support io_uring.
> > 
> > As one generic framework, the io command has to be io_uring
> > passthrough, and the io doesn't have to be handled by io_uring.
> 
> Yes, our backend define its own communicating method.
> 
> > 
> > But IMO io_uring is much more efficient, so I'd try to make async io
> > (io uring) as the 1st citizen in the framework, especially for new
> > driver.
> > 
> > But it can support other way really, such as use io_uring with eventfd,
> > the other userspace context can handle io, then wake up io_uring context
> > via eventfd. You may not use io_uring for handling io, but you still
> > need to communicate with the context for handling io_uring passthrough
> > command, and one mechanism(such as eventfd) has to be there for the
> > communication.
> 
> Ok, eventfd may be helpful. 
> If you read my API, you may find ubdlib_complete_io_request().
> I think the backend io worker thread can call this function to tell the 
> ubd queue thread(the io_uring context in it) to commit the IO.

The ubdlib_complete_io_request() has to be called in the same pthread
context, that looks not flexible. When you handle IO via non-io_uring in the same
context, the cpu utilization in submission/completion side should be
higher than io_uring. And this way should be worse than the usage in
ubd/loop, that is why I suggest to use one io_uring for handling both
io command and io request if possible.

> 
> 
> 
> > 
> >>
> >> (2) ubdsrv forks a daemon and it takes over everything.
> >>     Users should type "list/stop/del" ctrl-commands to interact with
> >>     the daemon. It is inconvenient for our backend
> >>     because it has threads(from a C++ thread library) running inside.
> > 
> > No, list/stop/del won't interact with the daemon, and the per-queue
> > pthread is only handling IO commands(io_uring passthrough) and IO request.
> > 
> 
> 
> Sorry I made a mistake.
> 
> I mean from user's view, 
> he has to type list/del/stop from cmdlind to control the daemon.
> (I know the control flow is cmdline-->ubd_drv.c-->ubdsrv daemon).
> 
> This is a little weird if we try to make a ubd library.
> So I actually provides APIs in libubd for users to do these list/del/stop works.

OK, that is fine to export APIs for admin purpose.

> 
> 
> >>
> >> (3) ubdsrv PRE-allocates internal data buffers for each ubd device.
> >>     The data flow is:
> >>     bio vectors <-1-> ubdsrv data buffer <-2-> backend buffer(our RPC buffer).
> >>     Since ubdsrv does not export its internal data buffer to backend,
> >>     the second copy is unavoidable. 
> >>     PRE-allocating data buffer may not be a good idea for wasting memory
> >>     if there are hundreds of ubd devices(/dev/ubdbX).
> > 
> > The preallocation is just virtual memory, which is cheap and not pinned, but
> > ubdsrv does support buffer provided by io command, see:
> > 
> > https://github.com/ming1/linux/commit/0a964a1700e11ba50227b6d633edf233bdd8a07d
> 
> Actually I discussed on the design of pre-allocation in your RFC patch for ubd_drv
> but you did not reply :)
> 
> I paste it here:
> 
> "I am worried about the fixed-size(size is max io size, 256KiB) pre-allocated data buffers in UBDSRV
> may consume too much memory. Do you mean these pages can be reclaimed by sth like madvise()?
> If (1)swap is not set and (2)madvise() is not called, these pages may not be reclaimed."
> 
> I observed that your ubdsrv use posix_memalign() to pre-allocate data buffers, 
> and I have already noticed the memory cost while testing your ubdsrv with hundreds of /dev/ubdbX.

Usually posix_memalign just allocates virtual memory which is unlimited
in 64bit arch, and pages should be allocated until the buffer is read or write.
After the READ/WRITE is done, kernel still can reclaim the pages in this
virtual memory.

In future, we still may optimize the memory uses via madvise, such as
MADV_DONTNEED, after the slot is idle for long enough.

> 
> Another IMPORTANT problem is your commit:
> https://github.com/ming1/linux/commit/0a964a1700e11ba50227b6d633edf233bdd8a07d
> may be not helpful for WRITE requests if I understand correctly.
> 
> Consider this data flow:
> 
> 1. ubdsrv commits an IO req(req1, a READ req).
> 
> 2. ubdsrv issues a sqe(UBD_IO_COMMIT_AND_FETCH_REQ), and sets io->addr to addr1.
>    addr1 is the addr of buffer user passed.
>    
> 
> 3. ubd gets the sqe and commits req1, sets io->addr to addr1.
> 
> 4. ubd gets IO req(req2, a WRITE req) from blk-mq(queue_rq) and commit a cqe.
> 
> 5. ubd copys data to be written from biovec to addr1 in a task_work.
> 
> 6. ubdsrv gets the cqe and tell the IO target to handle req2.
> 
> 7. IO target handles req2. It is a WRITE req so target issues a io_uring write
>    cmd(with buffer set to addr1).
> 
> 
> 
> The problem happens in 5). You cannot know the actual data_len of an blk-mq req
> until you get one in queue_rq. So length of addr1 may be less than data_len.

So far, the actual length of buffer has to be set as at least rq_max_blocks, since
we set it as ubd queue's max hw sectors. Yeah, you may argue memory
waste, but process virtual address is unlimited for 64bit arch, and
pages are allocated until actual read/write is started.

> > 
> >>
> >> To better use ubd in more complicated scenarios, we have developed libubd.
> >> It does not assume implementation of backend and can be embedded into it.
> >> We refer to the code structure of tcmu-runner[4], 
> >> which includes a library(libtcmu) for users 
> >> to embed tcmu-runner inside backend's code. 
> >> It:
> >>
> >> (1) Does not fork/pthread_create but embedded in backend's threads
> > 
> > That is because your backend may not use io_uring, I guess.
> > 
> > But it is pretty easy to move the decision of creating pthread to target
> > code, which can be done in the interface of .prepare_target().
> 
> I think the library should not create any thread if we want a libubd.

I Agree.

> 
> > 
> >>
> >> (2) Provides libubd APIs for backend to add/delete ubd devices 
> >>     and fetch/commit IO requests
> > 
> > The above could be the main job of libubd.
> 
> indeed.
> 
> > 
> >>
> >> (3) simply passes backend-provided data buffers to ubd_drv.c in kernel,
> >>     since the backend actually has no knowledge 
> >>     on incoming data size until it gets an IO descriptor.
> > 
> > I can understand your requirement, not look at your code yet, but libubd
> > should be pretty thin from function viewpoint, and there are lots of common
> > things to abstract/share among all drivers, please see recent ubdsrv change:
> > 
> > https://github.com/ming1/ubdsrv/commits/master
> > 
> > in which:
> > 	- coroutine is added for handling target io
> > 	- the target interface(ubdsrv_tgt_type) has been cleaned/improved for
> > 	supporting complicated target
> > 	- c++ support
> 
> Yes, I have read your coroutine code but I am not an expert of C++ 20.:(
> I think it is actually target(backend) design and ubd should not assume 
> how the backend handle IOs. 
> 
> The work ubd in userspace has to be done is:
> 
> 1) give some IO descriptors to backend, such as ubd_get_io_requests()
> 
> 2) get IO completion form backend, such as ubd_complete_io_requests()

Or the user provides/registers two callbacks: handle_io_async() and
io_complete(), the former is called when one request comes from ubd
driver, the latter(optional) is called when one io is done.

Also you didn't mention how you notify io_uring about io completion after
io_uring_enter() is slept if your backend code doesn't use io_uring to
handle io.

I think one communication mechanism(such as eventfd) is needed for your
case.

> 
> 
> 
> > 
> > IMO, libubd isn't worth of one freshly new project, and it could be integrated
> > into ubdsrv easily. The potential users could be existed usersapce
> > block driver projects.
> 
> Yes, so many userspace storage systems can use ubd!
> You may look at tcmu-runner. It:
> 
> 1) provides a library(libtcmu.c) for those who have a existing backend.
> 
> 2) provides a runner(main.c in tcmu-runner) like your ubdsrv 
>    for those who just want to run it. 
>    And the runner is build on top of libtcmu.
> 
> > 
> > If you don't object, I am happy to co-work with you to add the support
> > for libubd in ubdsrv, then we can avoid to invent a wheel
> 
> +1 :)

Thinking of further, I'd suggest to split ubdsrv into two parts:

1) libubdsrv
- provide APIs like what you did in libubd
- provide API for notify io_uring(handling io command) that one io is
completed, and the API should support handling IO from other context
(not same with the io_uring context for handling io command).

2) ubd target
- built on libubdsrv, such as ubd command is built on libubdsrv, and
specific target implementation is built on the library too.

It shouldn't be hard to work towards this direction, and I guess this
way should make current target implementation more clean.

> 
> > 
> >>
> >> Note: 
> >>
> >> (1) libubd is just a POC demo and is not stick to the principles of
> >>     designing a library and we are still developing it now...
> >>
> >> (2) The repo[5] including some useful examples using libubd. 
> >>
> >> (3) We modify the kernel part: ubd_drv.c and 
> >>     it[6] is against Ming Lei's newest branch[2]
> >>     because we forked our branch from his early branch
> >>     (v5.17-ubd-dev).
> > 
> > Please look at the following tree for ubd driver:
> > 
> > https://github.com/ming1/linux/tree/my_for-5.19-ubd-devel_v3
> > 
> > in which most of your change should have been there already.
> > 
> > I will post v3 soon, please feel free to review after it is out and
> > see if it is fine for you.
> 
> Yes, I have read your newest branch.
> You use some task_work() functions in ubd_drv.c 
> for error-handling such as aborting IO.

The IO aborting has to be supported, otherwise what if the io_uring
context(pthread) is killed, and what if the device is removed when
handling IO.

ubdsrv/tests/generic provides two tests for deleting ubd & killing
per-queue pthread meantime with heavy IO.

> 
> But I find they are too complicated to understand 
> and it's hard to write libubd code in this branch.

Actually the latest ubdsrv code becomes much clean, and should be
easier to abstract APIs for external/binary target.

> 
> So I choose your first(easiest to understand)
> version: v5.17-ubd-dev.

That code is outdated, and full of bugs, :-(


Thanks,
Ming

