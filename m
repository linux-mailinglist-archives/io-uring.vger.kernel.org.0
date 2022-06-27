Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2373655D901
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 15:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbiF0P3X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jun 2022 11:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236142AbiF0P3W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jun 2022 11:29:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7CAE419002
        for <io-uring@vger.kernel.org>; Mon, 27 Jun 2022 08:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656343760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hs91Syf01nEkXMgHThKmIN042V1ZQVRmN49C9uaVFIE=;
        b=dLXunApOuq8itNQpIfIr34exZ6GQXliF+21it94TBN2K8ieCAnzW8AQI/vvw6yaoMgBSaA
        VWZfdtqQthww6ekwg8mir90xX9LAjqVfdAAvIV5qy1CnFffXcG90T4TBJohxCnYPnexVFL
        RsV0DaiUAt9ox+m8bjVCFmcXt+cqN5M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-bl0KVvUDMHSunmYDcwrysg-1; Mon, 27 Jun 2022 11:29:17 -0400
X-MC-Unique: bl0KVvUDMHSunmYDcwrysg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5B6B801233;
        Mon, 27 Jun 2022 15:29:16 +0000 (UTC)
Received: from T590 (ovpn-8-31.pek2.redhat.com [10.72.8.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DCD2F2026D07;
        Mon, 27 Jun 2022 15:29:11 +0000 (UTC)
Date:   Mon, 27 Jun 2022 23:29:06 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        joseph.qi@linux.alibaba.com
Subject: Re: [RFC] libubd: library for ubd(userspace block driver based on
 io_uring passthrough)
Message-ID: <YrnMwgW7TemVdbXv@T590>
References: <fd926012-6845-05e4-077b-6c8cfbf3d3cc@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd926012-6845-05e4-077b-6c8cfbf3d3cc@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Ziyang,

On Mon, Jun 27, 2022 at 04:20:55PM +0800, Ziyang Zhang wrote:
> Hi Ming,
> 
> We are learning your ubd code and developing a library: libubd for ubd.
> This article explains why we need libubd and how we design it.
> 
> Related threads:
> (1) https://lore.kernel.org/all/Yk%2Fn7UtGK1vVGFX0@T590/
> (2) https://lore.kernel.org/all/YnDhorlKgOKiWkiz@T590/
> (3) https://lore.kernel.org/all/20220509092312.254354-1-ming.lei@redhat.com/
> (4) https://lore.kernel.org/all/20220517055358.3164431-1-ming.lei@redhat.com/
> 
> 
> Userspace block driver(ubd)[1], based on io_uring passthrough,
> allows users to define their own backend storage in userspace
> and provides block devices such as /dev/ubdbX.
> Ming Lei has provided kernel driver code: ubd_drv.c[2]
> and userspace code: ubdsrv[3].
> 
> ubd_drv.c simply passes all blk-mq IO requests
> to ubdsrv through io_uring sqes/cqes. We think the kernel code
> is pretty well-designed.
> 
> ubdsrv is implemented by a single daemon
> and target(backend) IO handling(null_tgt and loop_tgt) 
> is embedded in the daemon. 
> While trying ubdsrv, we find ubdsrv is hard to be used 
> by our backend.

ubd is supposed to provide one generic framework for user space block
driver, and it can be used for doing lots of fun/useful thing.

If I understand correctly, this isn't same with your use case:

1) your user space block driver isn't generic, and should be dedicated
for Alibaba's uses

2) your case has been there for long time, and you want to switch from other
approach(maybe tcmu) to ubd given ubd has better performance.

> First is description of our backend:
> 
> (1) a distributing system sends/receives IO requests 
>     through network.
> 
> (2) The system use RPC calls among hundreds of
>      storage servers and RPC calls are associated with data buffers
>      allocated from a memory pool.
> 
> (3) On each server for each device(/dev/vdX), our backend runs
>      many threads to handle IO requests and manage the device. 
> 
> Second are reasons why ubdsrv is hard to use for us:
> 
> (1) ubdsrv requires the target(backend) issues IO requests
>     to the io_uring provided by ubdsrv but our backend 
>     uses something like RPC and does not support io_uring.

As one generic framework, the io command has to be io_uring
passthrough, and the io doesn't have to be handled by io_uring.

But IMO io_uring is much more efficient, so I'd try to make async io
(io uring) as the 1st citizen in the framework, especially for new
driver.

But it can support other way really, such as use io_uring with eventfd,
the other userspace context can handle io, then wake up io_uring context
via eventfd. You may not use io_uring for handling io, but you still
need to communicate with the context for handling io_uring passthrough
command, and one mechanism(such as eventfd) has to be there for the
communication.

> 
> (2) ubdsrv forks a daemon and it takes over everything.
>     Users should type "list/stop/del" ctrl-commands to interact with
>     the daemon. It is inconvenient for our backend
>     because it has threads(from a C++ thread library) running inside.

No, list/stop/del won't interact with the daemon, and the per-queue
pthread is only handling IO commands(io_uring passthrough) and IO request.

> 
> (3) ubdsrv PRE-allocates internal data buffers for each ubd device.
>     The data flow is:
>     bio vectors <-1-> ubdsrv data buffer <-2-> backend buffer(our RPC buffer).
>     Since ubdsrv does not export its internal data buffer to backend,
>     the second copy is unavoidable. 
>     PRE-allocating data buffer may not be a good idea for wasting memory
>     if there are hundreds of ubd devices(/dev/ubdbX).

The preallocation is just virtual memory, which is cheap and not pinned, but
ubdsrv does support buffer provided by io command, see:

https://github.com/ming1/linux/commit/0a964a1700e11ba50227b6d633edf233bdd8a07d

> 
> To better use ubd in more complicated scenarios, we have developed libubd.
> It does not assume implementation of backend and can be embedded into it.
> We refer to the code structure of tcmu-runner[4], 
> which includes a library(libtcmu) for users 
> to embed tcmu-runner inside backend's code. 
> It:
> 
> (1) Does not fork/pthread_create but embedded in backend's threads

That is because your backend may not use io_uring, I guess.

But it is pretty easy to move the decision of creating pthread to target
code, which can be done in the interface of .prepare_target().

> 
> (2) Provides libubd APIs for backend to add/delete ubd devices 
>     and fetch/commit IO requests

The above could be the main job of libubd.

> 
> (3) simply passes backend-provided data buffers to ubd_drv.c in kernel,
>     since the backend actually has no knowledge 
>     on incoming data size until it gets an IO descriptor.

I can understand your requirement, not look at your code yet, but libubd
should be pretty thin from function viewpoint, and there are lots of common
things to abstract/share among all drivers, please see recent ubdsrv change:

https://github.com/ming1/ubdsrv/commits/master

in which:
	- coroutine is added for handling target io
	- the target interface(ubdsrv_tgt_type) has been cleaned/improved for
	supporting complicated target
	- c++ support

IMO, libubd isn't worth of one freshly new project, and it could be integrated
into ubdsrv easily. The potential users could be existed usersapce
block driver projects.

If you don't object, I am happy to co-work with you to add the support
for libubd in ubdsrv, then we can avoid to invent a wheel.

> 
> Note: 
> 
> (1) libubd is just a POC demo and is not stick to the principles of
>     designing a library and we are still developing it now...
> 
> (2) The repo[5] including some useful examples using libubd. 
> 
> (3) We modify the kernel part: ubd_drv.c and 
>     it[6] is against Ming Lei's newest branch[2]
>     because we forked our branch from his early branch
>     (v5.17-ubd-dev).

Please look at the following tree for ubd driver:

https://github.com/ming1/linux/tree/my_for-5.19-ubd-devel_v3

in which most of your change should have been there already.

I will post v3 soon, please feel free to review after it is out and
see if it is fine for you.


Thanks,
Ming

