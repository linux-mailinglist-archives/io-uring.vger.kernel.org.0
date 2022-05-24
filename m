Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD8353215D
	for <lists+io-uring@lfdr.de>; Tue, 24 May 2022 05:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbiEXC71 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 May 2022 22:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiEXC7Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 May 2022 22:59:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60B809CF02
        for <io-uring@vger.kernel.org>; Mon, 23 May 2022 19:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653361163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jgi47uEDCSDEBXMjON2icaSZ1qxn/LW2b7pS1wUdrEA=;
        b=BBFg4Pkv1q4cPU/jsh8mozVXsWCq5wNnwKQH57qvpuAyg1EAbtEROdB/lN42qNjTQW+6js
        8rNYH2FXrIdx9aibasgkwzoNlTu2SQ3GJynmvdMo6bSGtcO2aXg9Htriu7qeH76R2t76pF
        XbBOQpCLf2jFdrRbOmHwbVnfu5FVz/w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-55gLLX85O-6cowadX8_jrw-1; Mon, 23 May 2022 22:59:19 -0400
X-MC-Unique: 55gLLX85O-6cowadX8_jrw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5B6298032E5;
        Tue, 24 May 2022 02:59:19 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3FDB440D1B98;
        Tue, 24 May 2022 02:59:11 +0000 (UTC)
Date:   Tue, 24 May 2022 10:59:06 +0800
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
Message-ID: <YoxJ+tagaYY8Lre9@T590>
References: <20220518063808.GA168577@storage2.sh.intel.com>
 <YoTyNVccpIYDpx9q@T590>
 <20220523145643.GA232396@storage2.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523145643.GA232396@storage2.sh.intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 23, 2022 at 10:56:43AM -0400, Liu Xiaodong wrote:
> On Wed, May 18, 2022 at 09:18:45PM +0800, Ming Lei wrote:
> > Hello Liu,
> > 
> > On Wed, May 18, 2022 at 02:38:08AM -0400, Liu Xiaodong wrote:
> > > On Tue, May 17, 2022 at 01:53:57PM +0800, Ming Lei wrote:
> > > > Hello Guys,
> > > > 
> > > > ubd driver is one kernel driver for implementing generic userspace block
> > > > device/driver, which delivers io request from ubd block device(/dev/ubdbN) into
> > > > ubd server[1] which is the userspace part of ubd for communicating
> > > > with ubd driver and handling specific io logic by its target module.
> > > > 
> > > > Another thing ubd driver handles is to copy data between user space buffer
> > > > and request/bio's pages, or take zero copy if mm is ready for support it in
> > > > future. ubd driver doesn't handle any IO logic of the specific driver, so
> > > > it is small/simple, and all io logics are done by the target code in ubdserver.
> > > > 
> > > > The above two are main jobs done by ubd driver.
> > > 
> > > Not like UBD which is straightforward and starts from scratch, VDUSE is
> > > embedded in virtio framework. So its implementation is more complicated, but
> > > all virtio frontend utilities can be leveraged.
> > > When considering security/permission issues, feels UBD would be easier to
> > > solve them.
> > 
> > Stefan Hajnoczi and I are discussing related security/permission
> > issues, can you share more details in your case?
> 
> Hi, Ming
> Security/permission things covered by your discussion are more than I've
> considered.

BTW, I'd rather make a summery about the discussion:

1) Stefan suggested that ubd device may be made as one container block
device, which can be isolated from others, such as, the ubd device
created in one container can only be controlled and read write inside
this container, and this way is useful for container use case.

2) the requirement actually needs both /dev/ubdcN and /dev/ubdbN to
be allowed for unprivileged user; so it could be solved by existed
process privilege & file ownership; let user of the process creating
the two devices owns the two devices, and apply FS's file permission
on the two devices;

3) it shouldn't be hard to allow unprivileged user to control
/dev/ubdcN or /dev/ubd-control

- every user can create ubd by sending ADD_DEV command to
  /dev/ubd-control; only user with permission to /dev/ubdcN can send
  other control commands to /dev/ubd-control for controlling/querying
  the specified device

- ubd driver is simple, both in interface and implementation, so we
can make it stable from the beginning

- only the daemon can communicate with /dev/ubdcN, which is only
  allowed to be opened by one process

4) the challenge is in allowing unprivileged user to access /dev/ubdbN:

- no any serious bug in io path(io hang, kernel panic), such as ubd io
  hang may cause sync() hang

- can't affect other users or processes or system, such as, one
  malicious may make a extremely slow device to dirty lots of pages, or
  prevent device from being deleted

- ...

5) as Stefan mentioned, we may start by:
- not allow unprivileged ubd device to be mounted
- not allow unprivileged ubd device's partition table to be read from
  kernel
- not support buffered io for unprivileged ubd device, and only direct io
  is allowed
- maybe more limit for minimizing security risk.


ubd for container is hard, and it should be one extra feature added
in future, especially after fully review/verification.


Thanks,
Ming

