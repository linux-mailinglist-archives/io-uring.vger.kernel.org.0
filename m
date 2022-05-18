Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA0452BD59
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 16:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237615AbiERNTJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 09:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237632AbiERNTE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 09:19:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4507BD8084
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 06:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652879941;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2DQALIgDOHGNkvengitHc0v197uadYCpWLUueswTRnU=;
        b=HN+rdHQ4Yc75aKuj7J7px3oMaxv4d2MZiSLg2QMemhaZbAODlnCz2xF76YnMY7wLzTNplv
        z13GuTJJUSwNiKjUySMz5D4o3PYPfN8BIaRf+F17fMeTjHrmH+Iu9HUoZMqQho4pQ/SgGv
        6z3W4OGusry+zrgpHhkcZZeeEJI/Djs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-Tss1-yDPNfiFC43WVtTzsg-1; Wed, 18 May 2022 09:18:58 -0400
X-MC-Unique: Tss1-yDPNfiFC43WVtTzsg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF95C38035A5;
        Wed, 18 May 2022 13:18:57 +0000 (UTC)
Received: from T590 (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A87A1410F36;
        Wed, 18 May 2022 13:18:50 +0000 (UTC)
Date:   Wed, 18 May 2022 21:18:45 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Liu Xiaodong <xiaodong.liu@intel.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, ming.lei@redhat.com
Subject: Re: [PATCH V2 0/1] ubd: add io_uring based userspace block driver
Message-ID: <YoTyNVccpIYDpx9q@T590>
References: <20220517055358.3164431-1-ming.lei@redhat.com>
 <20220518063808.GA168577@storage2.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518063808.GA168577@storage2.sh.intel.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Liu,

On Wed, May 18, 2022 at 02:38:08AM -0400, Liu Xiaodong wrote:
> On Tue, May 17, 2022 at 01:53:57PM +0800, Ming Lei wrote:
> > Hello Guys,
> > 
> > ubd driver is one kernel driver for implementing generic userspace block
> > device/driver, which delivers io request from ubd block device(/dev/ubdbN) into
> > ubd server[1] which is the userspace part of ubd for communicating
> > with ubd driver and handling specific io logic by its target module.
> > 
> > Another thing ubd driver handles is to copy data between user space buffer
> > and request/bio's pages, or take zero copy if mm is ready for support it in
> > future. ubd driver doesn't handle any IO logic of the specific driver, so
> > it is small/simple, and all io logics are done by the target code in ubdserver.
> > 
> > The above two are main jobs done by ubd driver.
> 
> Hi, Lei
> 
> Your UBD implementation looks great. Its io_uring based design is interesting
> and brilliant.
> Towards the purpose of userspace block device, last year,
> VDUSE initialized by Yongji is going to do a similar work. But VDUSE is under
> vdpa. VDUSE will present a virtio-blk device to other userspace process
> like containers, while serving virtio-blk req also by an userspace target.
> https://lists.linuxfoundation.org/pipermail/iommu/2021-June/056956.html 
> 
> I've been working and thinking on serving RUNC container by SPDK efficiently.
> But this work requires a new proper userspace block device module in kernel.
> The highlevel design idea for userspace block device implementations
> should be that: Using ring for IO request, so client and target can exchange
> req/resp quickly in batch; Map bounce buffer between kernel and userspace
> target, so another extra IO data copy like NBD can be avoid. (Oh, yes, SPDK
> needs this kernel module has some more minor functions)
> 
> UBD and VDUSE are both implemented in this way, while of course each of
> them has specific features and advantages.
> 
> Not like UBD which is straightforward and starts from scratch, VDUSE is
> embedded in virtio framework. So its implementation is more complicated, but
> all virtio frontend utilities can be leveraged.
> When considering security/permission issues, feels UBD would be easier to
> solve them.

Stefan Hajnoczi and I are discussing related security/permission
issues, can you share more details in your case?

> 
> So my questions are:
> 1. what do you think about the purpose overlap between UBD and VDUSE?

Sorry, I am not familiar with VDUSE, motivation of ubd is just to make one
high performance generic userspace block driver. ubd driver(kernel part) is
just responsible for communication and copying data between userspace buffers
and kernel io request pages, and the ubdsrv(userspace) target handles io
logic.

> 2. Could UBD be implemented with SPDK friendly functionalities? (mainly about
> io data mapping, since HW devices in SPDK need to access the mapped data
> buffer. Then, in function ubdsrv.c/ubdsrv_init_io_bufs(),
> "addr = mmap(,,,,dev->cdev_fd,)",

No, that code is actually for supporting zero copy.

But each request's buffer is allocated by ubdsrv and definitely available for any
target, please see loop_handle_io_async() which handles IO from /dev/ubdbN about
how to use the buffer. Fro READ, the target code needs to implement READ
logic and fill data to the buffer, then the buffer will be copied to
kernel io request pages; for WRITE, the target code needs to use the buffer to handle
WRITE and the buffer has been updated with kernel io request.

> SPDK needs to know the PA of "addr".

What is PA? and why?

Userspace can only see VM of each buffer. 

> Also memory pointed by "addr" should be pinned all the time.)

The current implementation only pins pages when copying data between
userspace buffers and kernel io request pages. But I plan to support
three pin behavior:

- never (current behavior, just pin pages when copying pages)
- lazy (pin pages until the request is idle for enough time)
- always (all pages in userpace VM are pinned during the device lifetime)


Thanks, 
Ming

